import { Injectable } from '@nestjs/common';
import { Membership, Prisma } from '@prisma/client';
import { BookingService, PAID_STATUSES, discountCents, paidCents, snap } from '../booking/booking.service';
import { DAY_MS, canTransition, fromCents, isoDate, toCents, todayIn, zonedToUtc } from '../booking/domain';
import { sameHotel } from '../common/auth';
import { AppError } from '../common/errors';
import { Locale, t } from '../common/i18n';
import { PrismaService } from '../common/prisma.service';
import { LoyaltyService } from '../loyalty/loyalty.service';
import { WifiService } from '../wifi/wifi.service';

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
      currency: r.currency,
    }));
  }

  /** Booking detail + guest contact and internal notes (staff only). */
  async detail(m: Membership, id: string, userId: string, locale: Locale) {
    const r = sameHotel(await this.prisma.reservation.findUnique({ where: { id }, include: { guest: true } }), m);
    const history = await this.prisma.statusEvent.findMany({ where: { entityType: 'reservation', entityId: id }, orderBy: { at: 'asc' } });
    return {
      ...(await this.booking.view(id, userId, locale)),
      guest: { id: r.guest.id, fullName: r.guest.fullName, email: r.guest.email, phone: r.guest.phone },
      internalNotes: r.internalNotes,
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
