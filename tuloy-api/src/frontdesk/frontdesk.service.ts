import { Injectable } from '@nestjs/common';
import { Membership, Prisma } from '@prisma/client';
import { BookingService, PAID_STATUSES, discountCents, paidCents, paymentState, snap } from '../booking/booking.service';
import { DAY_MS, canTransition, fromCents, isoDate, toCents, todayIn, zonedToUtc } from '../booking/domain';
import { sameHotel } from '../common/auth';
import { assetUrl } from '../common/storage';
import { AppError } from '../common/errors';
import { Locale, t } from '../common/i18n';
import { PrismaService } from '../common/prisma.service';
import { LoyaltyService } from '../loyalty/loyalty.service';
import { WifiService } from '../wifi/wifi.service';

export type RoomStatus = 'blocked' | 'occupied' | 'departing' | 'arriving' | 'reserved' | 'free';

/** A room's state today from tonight's night (kind, booking status) and whether a guest checks out of it today. */
export function roomStatus(kind?: string, status?: string, arrivesToday?: boolean, departsToday = false): RoomStatus {
  if (kind === 'BLOCKED') return 'blocked';
  if (status === 'CHECKED_IN') return 'occupied';
  if (departsToday) return 'departing'; // free tonight once they leave, even if someone arrives later
  if (status === 'CONFIRMED' && arrivesToday) return 'arriving';
  return kind ? 'reserved' : 'free';
}

export type ReservationView = 'arrivals' | 'departures' | 'inhouse' | 'pending' | 'upcoming' | 'all';

/** Staff operations on reservations (T-1…T-3) and both dashboards (T-1, A-4). */
@Injectable()
export class FrontDeskService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly booking: BookingService,
    private readonly wifi: WifiService,
    private readonly loyalty: LoyaltyService,
  ) {}

  private async hotelDay(hotelId: string) {
    const hotel = await this.prisma.hotel.findUniqueOrThrow({ where: { id: hotelId } });
    const today = todayIn(hotel.timezone);
    const start = zonedToUtc(today, '00:00', hotel.timezone);
    return { hotel, today, todayDate: new Date(`${today}T00:00:00Z`), start, end: new Date(start.getTime() + DAY_MS) };
  }

  async list(m: Membership, view: ReservationView = 'upcoming', q?: string, locale: Locale = 'en') {
    const { hotel, todayDate } = await this.hotelDay(m.hotelId);
    const where: Prisma.ReservationWhereInput = { hotelId: m.hotelId };
    if (view === 'arrivals') Object.assign(where, { checkIn: todayDate, status: 'CONFIRMED' });
    if (view === 'departures') Object.assign(where, { checkOut: todayDate, status: 'CHECKED_IN' });
    if (view === 'inhouse') Object.assign(where, { status: 'CHECKED_IN' });
    if (view === 'pending') Object.assign(where, { status: 'PENDING' });
    if (view === 'upcoming') Object.assign(where, { checkOut: { gte: todayDate }, status: { in: ['PENDING', 'CONFIRMED', 'CHECKED_IN'] } });
    if (view === 'all') where.status = { notIn: ['HOLD', 'EXPIRED'] };
    if (q) {
      where.OR = [
        { code: { contains: q, mode: 'insensitive' } },
        { guest: { fullName: { contains: q, mode: 'insensitive' } } },
        { guest: { email: { contains: q, mode: 'insensitive' } } },
        { guest: { phone: { contains: q } } },
      ];
    }
    const rows = await this.prisma.reservation.findMany({
      where,
      include: { guest: true, nights: { include: { room: true }, take: 1, orderBy: { date: 'asc' } }, payments: true, invoiceLines: true },
      orderBy: [{ checkIn: 'asc' }, { createdAt: 'asc' }],
      take: 200,
    });
    return rows.map((r) => ({
      id: r.id,
      code: r.code,
      status: r.status,
      checkIn: isoDate(r.checkIn),
      checkOut: isoDate(r.checkOut),
      guestName: r.guest.fullName,
      roomType: t(snap(r).roomType.name, locale, hotel.defaultLocale),
      room: r.nights[0]?.room.number ?? null,
      balance: fromCents(Math.max(0, toCents(r.total) - discountCents(r.invoiceLines) - paidCents(r.payments))),
      payment: paymentState(r.payments, toCents(r.total) - discountCents(r.invoiceLines)),
      currency: r.currency,
    }));
  }

  /** Booking detail + guest contact and internal notes (staff only). */
  async detail(m: Membership, id: string, userId: string, locale: Locale) {
    const r = sameHotel(
      await this.prisma.reservation.findUnique({ where: { id }, include: { guest: true, payments: true, invoiceLines: true } }),
      m,
    );
    const history = await this.prisma.statusEvent.findMany({ where: { entityType: 'reservation', entityId: id }, orderBy: { at: 'asc' } });
    return {
      ...(await this.booking.view(id, userId, locale)),
      guest: { id: r.guest.id, fullName: r.guest.fullName, email: r.guest.email, phone: r.guest.phone },
      internalNotes: r.internalNotes,
      payment: paymentState(r.payments, toCents(r.total) - discountCents(r.invoiceLines)),
      history: history.map((h) => ({ from: h.fromStatus, to: h.toStatus, at: h.at, note: h.note })),
    };
  }

  async notes(m: Membership, id: string, internalNotes: string) {
    sameHotel(await this.prisma.reservation.findUnique({ where: { id } }), m);
    await this.prisma.reservation.update({ where: { id }, data: { internalNotes } });
  }

  /** Move a reservation along; the conditional update makes two staff tapping at once safe. */
  private async move(m: Membership, id: string, to: string, userId: string, note?: string) {
    const r = sameHotel(await this.prisma.reservation.findUnique({ where: { id } }), m);
    if (!canTransition(r.status, to)) throw new AppError('INVALID_TRANSITION', 409);
    const ok = await this.prisma.reservation.updateMany({ where: { id, status: r.status }, data: { status: to as never } });
    if (!ok.count) throw new AppError('INVALID_TRANSITION', 409);
    await this.booking.statusEvent(r, r.status, to, userId, note);
    await this.prisma.audit({ hotelId: r.hotelId, actorId: userId, action: `reservation.${to.toLowerCase()}`, entityType: 'reservation', entityId: id, after: { note } });
    return r;
  }

  async approve(m: Membership, id: string, userId: string) {
    const r = await this.move(m, id, 'CONFIRMED', userId);
    await this.booking.confirmed(r, await this.booking.hotel(r.hotelId));
  }

  async decline(m: Membership, id: string, userId: string, reason?: string) {
    const r = await this.move(m, id, 'DECLINED', userId, reason);
    await this.prisma.roomNight.deleteMany({ where: { reservationId: id } });
    const payments = await this.prisma.payment.findMany({ where: { reservationId: id, status: { in: PAID_STATUSES } } });
    await this.booking.refundAndNotify(r, payments.map((p) => p.id), paidCents(payments), reason ?? 'Declined by hotel', userId);
    await this.booking.notifyCancelled(r, reason);
  }

  async checkIn(m: Membership, id: string, userId: string) {
    const { today } = await this.hotelDay(m.hotelId);
    const r0 = sameHotel(await this.prisma.reservation.findUnique({ where: { id } }), m);
    if (isoDate(r0.checkIn) > today) throw new AppError('TOO_EARLY', 409);
    const r = await this.move(m, id, 'CHECKED_IN', userId);
    const night = await this.prisma.roomNight.findFirst({ where: { reservationId: id }, include: { room: true } });
    await this.wifi.issue(r, night?.room.number ?? null);
  }

  async checkOut(m: Membership, id: string, userId: string) {
    const { todayDate } = await this.hotelDay(m.hotelId);
    const r = await this.move(m, id, 'CHECKED_OUT', userId);
    // Early departure frees the remaining nights.
    await this.prisma.roomNight.deleteMany({ where: { reservationId: id, date: { gte: todayDate } } });
    await this.wifi.revoke(id);
    const paid = paidCents(await this.prisma.payment.findMany({ where: { reservationId: id } }));
    await this.loyalty.earn(r.guestId, r.hotelId, paid, 'reservation', id);
  }

  async noShow(m: Membership, id: string, userId: string) {
    await this.move(m, id, 'NO_SHOW', userId);
    await this.prisma.roomNight.deleteMany({ where: { reservationId: id } });
  }

  /** Re-issue Wi-Fi if the provider call failed at check-in. */
  async reissueWifi(m: Membership, id: string) {
    const r = sameHotel(await this.prisma.reservation.findUnique({ where: { id } }), m);
    if (r.status !== 'CHECKED_IN') throw new AppError('INVALID_TRANSITION', 409);
    await this.wifi.revoke(id);
    const night = await this.prisma.roomNight.findFirst({ where: { reservationId: id }, include: { room: true } });
    await this.wifi.issue(r, night?.room.number ?? null);
  }

  // ───────────── room board, guests, team, notifications ─────────────

  /** Every active room's state today, plus free rooms per type tonight. */
  async board(m: Membership, locale: Locale) {
    const { hotel, today, todayDate } = await this.hotelDay(m.hotelId);
    const yesterday = new Date(todayDate.getTime() - DAY_MS);
    const [rooms, nights] = await Promise.all([
      this.prisma.room.findMany({ where: { hotelId: m.hotelId, active: true }, include: { roomType: true }, orderBy: { number: 'asc' } }),
      this.prisma.roomNight.findMany({
        where: { hotelId: m.hotelId, date: { in: [yesterday, todayDate] } },
        include: { reservation: { include: { guest: true } } },
      }),
    ]);
    const tonight = new Map(nights.filter((n) => +n.date === +todayDate).map((n) => [n.roomId, n]));
    const leaving = new Map(
      nights
        .filter((n) => +n.date === +yesterday && n.reservation?.status === 'CHECKED_IN' && isoDate(n.reservation.checkOut) === today)
        .map((n) => [n.roomId, n]),
    );
    const out = rooms.map((room) => {
      const n = tonight.get(room.id);
      const r = n?.reservation;
      const status = roomStatus(n?.kind, r?.status, !!r && isoDate(r.checkIn) === today, leaving.has(room.id));
      const who = r ?? leaving.get(room.id)?.reservation;
      return {
        id: room.id,
        number: room.number,
        floor: room.floor,
        roomTypeId: room.roomTypeId,
        roomType: t(room.roomType.name, locale, hotel.defaultLocale),
        status,
        guestName: who?.guest.fullName ?? null,
        reservationId: who?.id ?? null,
      };
    });
    const photo = new Map(rooms.map((r) => [r.roomTypeId, r.roomType.photos[0]]));
    const types = new Map<string, { roomTypeId: string; roomType: string; photoUrl: string | null; total: number; free: number }>();
    for (const r of out) {
      const key = photo.get(r.roomTypeId);
      const x = types.get(r.roomTypeId) ?? { roomTypeId: r.roomTypeId, roomType: r.roomType, photoUrl: key ? assetUrl(key) : null, total: 0, free: 0 };
      x.total++;
      if (r.status === 'free' || r.status === 'departing') x.free++;
      types.set(r.roomTypeId, x);
    }
    return { date: today, rooms: out, types: [...types.values()] };
  }

  /** Guests who booked at this hotel, newest stay first. ponytail: capped at 200; page it when guest lists outgrow that. */
  async guests(m: Membership, q?: string) {
    const mine: Prisma.ReservationWhereInput = { hotelId: m.hotelId, status: { notIn: ['HOLD', 'EXPIRED'] } };
    const users = await this.prisma.user.findMany({
      where: {
        reservations: { some: mine },
        ...(q && {
          OR: [
            { fullName: { contains: q, mode: 'insensitive' } },
            { email: { contains: q, mode: 'insensitive' } },
            { phone: { contains: q } },
          ],
        }),
      },
      include: {
        reservations: { where: mine, orderBy: { checkIn: 'desc' }, select: { id: true, code: true, status: true, checkIn: true, checkOut: true } },
      },
      take: 200,
    });
    return users
      .map((u) => {
        const last = u.reservations[0];
        return {
          id: u.id,
          fullName: u.fullName,
          email: u.email,
          phone: u.phone,
          bookings: u.reservations.length,
          stays: u.reservations.filter((r) => r.status === 'CHECKED_OUT' || r.status === 'CHECKED_IN').length,
          last: last && { id: last.id, code: last.code, status: last.status, checkIn: isoDate(last.checkIn), checkOut: isoDate(last.checkOut) },
        };
      })
      .sort((a, b) => (b.last?.checkIn ?? '').localeCompare(a.last?.checkIn ?? ''));
  }

  /** Staff directory (read-only); admins edit it under /admin/staff. */
  async team(m: Membership) {
    const { todayDate } = await this.hotelDay(m.hotelId);
    const [rows, leave] = await Promise.all([
      this.prisma.membership.findMany({
        where: { hotelId: m.hotelId, role: { in: ['RESTAURANT', 'STAFF', 'ADMIN'] }, user: { disabledAt: null } },
        include: { user: true, department: true },
      }),
      // Approved leave covering today, or starting later (shown as upcoming).
      this.prisma.leaveRequest.findMany({
        where: { hotelId: m.hotelId, status: 'approved', to: { gte: todayDate } },
        orderBy: { from: 'asc' },
      }),
    ]);
    const leaveOf = (userId: string) => leave.find((x) => x.userId === userId);
    return rows
      .map((r) => ({
        id: r.userId,
        employeeNo: r.employeeNo,
        leave: (() => {
          const x = leaveOf(r.userId);
          return x && { from: isoDate(x.from), to: isoDate(x.to), type: x.type, today: x.from <= todayDate };
        })(),
        photoUrl: r.photoKey ? assetUrl(r.photoKey) : null,
        fullName: r.user.fullName,
        email: r.user.email,
        phone: r.user.phone,
        role: r.role,
        department: r.department?.name ?? null,
      }))
      .sort((a, b) => a.fullName.localeCompare(b.fullName));
  }

  /**
   * Front-desk feed from what is already recorded: new and cancelled bookings and new requests/orders
   * (status history), plus guest chat messages. Read state is kept by the app (last seen time).
   */
  async notifications(m: Membership, locale: Locale) {
    const h = m.hotelId;
    const since = new Date(Date.now() - 7 * DAY_MS);
    const take = 30;
    const [events, messages, hotel] = await Promise.all([
      this.prisma.statusEvent.findMany({
        where: {
          hotelId: h,
          at: { gte: since },
          OR: [
            { entityType: 'reservation', fromStatus: 'HOLD', toStatus: { in: ['CONFIRMED', 'PENDING'] } },
            { entityType: 'reservation', toStatus: 'CANCELLED', fromStatus: { not: 'HOLD' } },
            { entityType: { in: ['service_request', 'restaurant_order'] }, fromStatus: null },
          ],
        },
        orderBy: { at: 'desc' },
        take,
      }),
      this.prisma.$queryRaw<{ id: string; at: Date; body: string; conversationId: string; guestName: string }[]>`
        SELECT m.id, m."createdAt" AS at, m.body, m."conversationId", u."fullName" AS "guestName"
        FROM "Message" m JOIN "Conversation" c ON c.id = m."conversationId" JOIN "User" u ON u.id = c."guestId"
        WHERE c."hotelId" = ${h} AND m."senderId" = c."guestId" AND m."createdAt" >= ${since}
        ORDER BY m."createdAt" DESC LIMIT ${take}`,
      this.prisma.hotel.findUniqueOrThrow({ where: { id: h } }),
    ]);
    const ids = (type: string) => events.filter((e) => e.entityType === type).map((e) => e.entityId);
    const [reservations, requests] = await Promise.all([
      this.prisma.reservation.findMany({ where: { id: { in: ids('reservation') } }, include: { guest: true } }),
      this.prisma.serviceRequest.findMany({ where: { id: { in: ids('service_request') } } }),
    ]);
    const requestGuests = await this.prisma.user.findMany({ where: { id: { in: requests.map((r) => r.guestId) } } });
    const res = new Map(reservations.map((r) => [r.id, r]));
    const req = new Map(requests.map((r) => [r.id, r]));
    const guest = new Map(requestGuests.map((u) => [u.id, u.fullName]));

    const items = [
      ...events.map((e) => {
        if (e.entityType === 'reservation') {
          const r = res.get(e.entityId);
          return {
            id: e.id,
            kind: e.toStatus === 'CANCELLED' ? 'cancelled' : e.toStatus === 'PENDING' ? 'pending' : 'booking',
            at: e.at,
            title: r?.guest.fullName ?? '',
            detail: r?.code ?? '',
            refId: e.entityId,
          };
        }
        if (e.entityType === 'service_request') {
          const r = req.get(e.entityId);
          return {
            id: e.id,
            kind: 'request',
            at: e.at,
            title: (r && guest.get(r.guestId)) ?? '',
            detail: r ? t((r.snapshot as { name?: unknown }).name, locale, hotel.defaultLocale) : '',
            refId: e.entityId,
          };
        }
        return { id: e.id, kind: 'order', at: e.at, title: '', detail: e.entityId.slice(0, 6).toUpperCase(), refId: e.entityId };
      }),
      ...messages.map((x) => ({ id: x.id, kind: 'message', at: x.at, title: x.guestName, detail: x.body.slice(0, 120), refId: x.conversationId })),
    ];
    return items.sort((a, b) => +b.at - +a.at).slice(0, 40);
  }

  // ───────────── dashboards ─────────────

  async staffDashboard(m: Membership, userId: string) {
    const { todayDate } = await this.hotelDay(m.hotelId);
    const h = m.hotelId;
    const [arrivals, departures, inHouse, pending, unreadChats, openTasks, myTasks, openOrders] = await Promise.all([
      this.prisma.reservation.count({ where: { hotelId: h, checkIn: todayDate, status: 'CONFIRMED' } }),
      this.prisma.reservation.count({ where: { hotelId: h, checkOut: todayDate, status: 'CHECKED_IN' } }),
      this.prisma.reservation.count({ where: { hotelId: h, status: 'CHECKED_IN' } }),
      this.prisma.reservation.count({ where: { hotelId: h, status: 'PENDING' } }),
      this.unreadForStaff(h),
      this.prisma.serviceRequest.count({ where: { hotelId: h, status: { notIn: ['completed', 'cancelled'] } } }),
      this.prisma.serviceRequest.count({ where: { hotelId: h, assigneeId: userId, status: { notIn: ['completed', 'cancelled'] } } }),
      this.prisma.restaurantOrder.count({ where: { hotelId: h, status: { in: ['submitted', 'accepted', 'preparing'] } } }),
    ]);
    return { arrivals, departures, inHouse, pending, unreadChats, openTasks, myTasks, openOrders };
  }

  /** Guest messages staff haven't read yet. */
  async unreadForStaff(hotelId: string) {
    const [{ n }] = await this.prisma.$queryRaw<{ n: bigint }[]>`
      SELECT count(*)::bigint AS n FROM "Message" m JOIN "Conversation" c ON c.id = m."conversationId"
      WHERE c."hotelId" = ${hotelId} AND m."senderId" = c."guestId" AND m."readAt" IS NULL`;
    return Number(n);
  }

  async adminDashboard(m: Membership, userId: string) {
    const { hotel, todayDate, start, end } = await this.hotelDay(m.hotelId);
    const h = m.hotelId;
    const [staff, rooms, bookedTonight, money, failedRefunds, failedNotifications] = await Promise.all([
      this.staffDashboard(m, userId),
      this.prisma.room.count({ where: { hotelId: h, active: true } }),
      this.prisma.roomNight.count({ where: { hotelId: h, date: todayDate, kind: 'BOOKED' } }),
      this.prisma.invoiceLine.groupBy({
        by: ['kind'],
        where: { hotelId: h, kind: { in: ['payment', 'refund'] }, createdAt: { gte: start, lt: end } },
        _sum: { amount: true },
      }),
      this.prisma.refund.count({ where: { status: 'failed', payment: { hotelId: h } } }),
      this.prisma.notificationDelivery.count({ where: { hotelId: h, status: 'failed', createdAt: { gte: new Date(Date.now() - DAY_MS) } } }),
    ]);
    const sum = (k: string) => toCents(money.find((x) => x.kind === k)?._sum.amount ?? 0);
    const collected = -sum('payment');
    const refunded = sum('refund');
    return {
      ...staff,
      occupancy: rooms ? Math.round((bookedTonight / rooms) * 100) : 0,
      roomsSold: bookedTonight,
      rooms,
      collectedToday: fromCents(collected),
      refundedToday: fromCents(refunded),
      netToday: fromCents(collected - refunded),
      currency: hotel.currency,
      alerts: { failedRefunds, failedNotifications },
    };
  }
}
