import { Inject, Injectable, OnModuleDestroy, OnModuleInit } from '@nestjs/common';
import { Hotel, Payment, PaymentStatus, Prisma, Reservation, RoomRate, RoomType } from '@prisma/client';
import { randomInt } from 'node:crypto';
import { AppError } from '../common/errors';
import { Locale, t } from '../common/i18n';
import { PrismaService } from '../common/prisma.service';
import { assetUrl } from '../common/storage';
import { LoyaltyService } from '../loyalty/loyalty.service';
import { NotificationsService } from '../notifications/notifications.service';
import { GatewayEvent, PAYMENT_GATEWAY, PaymentGateway, publicApiUrl } from '../payments/gateway';
import {
  StayPolicy,
  bookingCode,
  depositCents,
  fromCents,
  isoDate,
  nightsOf,
  priceStay,
  readPolicy,
  refundCents,
  toCents,
  todayIn,
  validateStay,
  zonedToUtc,
} from './domain';
import { FeedbackDto, HoldDto, StayQueryDto } from './dto';

const HOLD_MS = 15 * 60_000; // time to review and start paying
const PAY_MS = 30 * 60_000; // hold extended once the guest opens checkout
const EXPIRE_TICK_MS = 60_000;
const OPEN_STATUSES = ['HOLD', 'PENDING', 'CONFIRMED'];
export const PAID_STATUSES: PaymentStatus[] = ['SUCCEEDED', 'PARTIALLY_REFUNDED', 'REFUNDED'];

type Json = Record<string, string>;

/** Stored on the reservation at hold time; prices and terms never change afterwards. */
interface Snapshot {
  roomType: { id: string; name: Json };
  nights: { date: string; price: string }[];
  subtotal: string;
  serviceCharge: string;
  tax: string;
  total: string;
  policy: StayPolicy;
  terms: Record<string, unknown>; // hotel policies as shown to the guest (cancellation text etc.)
}

export const day = (d: string) => new Date(`${d}T00:00:00Z`);
export const snap = (r: Reservation) => r.priceSnapshot as unknown as Snapshot;
export const money = (cents: number, currency: string) =>
  new Intl.NumberFormat('en-PH', { style: 'currency', currency }).format(cents / 100);

export const isUnique = (e: unknown, field?: string) =>
  e instanceof Prisma.PrismaClientKnownRequestError &&
  e.code === 'P2002' &&
  (!field || JSON.stringify(e.meta?.target ?? '').includes(field));

/** Rooms with no live night — booked, blocked, or an unexpired hold — in [from, to). */
const freeRooms = (from: Date, to: Date): Prisma.RoomWhereInput => ({
  active: true,
  nights: {
    none: { date: { gte: from, lt: to }, OR: [{ kind: { not: 'HOLD' } }, { holdExpiresAt: { gt: new Date() } }] },
  },
});

export const paidCents = (payments: Payment[]) =>
  payments
    .filter((p) => PAID_STATUSES.includes(p.status))
    .reduce((s, p) => s + toCents(p.amount) - toCents(p.refundedAmount), 0);

/** Loyalty redemptions lower what the guest owes. */
export const discountCents = (lines: { kind: string; amount: Prisma.Decimal }[]) =>
  -lines.filter((l) => l.kind === 'loyalty_redemption').reduce((s, l) => s + toCents(l.amount), 0);

// Folio line descriptions, stored translated like all hotel content.
export const TEXT = {
  serviceCharge: { en: 'Service charge', fil: 'Service charge', ceb: 'Service charge' },
  tax: { en: 'VAT', fil: 'VAT', ceb: 'VAT' },
  payment: { en: 'Payment received', fil: 'Natanggap na bayad', ceb: 'Nadawat nga bayad' },
  refund: { en: 'Refund', fil: 'Refund', ceb: 'Refund' },
  nights: (n: number, name: Json) => ({
    en: `${n} ${n === 1 ? 'night' : 'nights'} · ${t(name, 'en')}`,
    fil: `${n} gabi · ${t(name, 'fil')}`,
    ceb: `${n} ka gabii · ${t(name, 'ceb')}`,
  }),
};

@Injectable()
export class BookingService implements OnModuleInit, OnModuleDestroy {
  private timer?: NodeJS.Timeout;

  constructor(
    private readonly prisma: PrismaService,
    @Inject(PAYMENT_GATEWAY) private readonly gateway: PaymentGateway,
    private readonly notifications: NotificationsService,
    private readonly loyalty: LoyaltyService,
  ) {}

  onModuleInit() {
    // JOBS=off: no background work here; JOBS=inline: serverless, /v1/internal/cron runs it instead.
    if (process.env.JOBS !== 'off' && process.env.JOBS !== 'inline') {
      this.timer = setInterval(() => void this.expireHolds().catch((e) => console.error('[expire]', e)), EXPIRE_TICK_MS);
    }
  }

  onModuleDestroy() {
    clearInterval(this.timer);
  }

  // ───────────── B-1 availability ─────────────

  async availability(hotelId: string, q: StayQueryDto, locale: Locale) {
    const hotel = await this.hotel(hotelId);
    this.checkDates(q.checkIn, q.checkOut, hotel);
    const from = day(q.checkIn);
    const to = day(q.checkOut);
    const types = await this.prisma.roomType.findMany({
      where: { hotelId, active: true, maxGuests: { gte: q.adults + (q.children ?? 0) } },
      include: { rooms: { where: freeRooms(from, to), select: { id: true } }, rates: { where: { date: { gte: from, lt: to } } } },
      orderBy: { basePrice: 'asc' },
    });
    return types
      .filter((rt) => rt.rooms.length > 0)
      .map((rt) => {
        const price = this.quote(rt, q.checkIn, q.checkOut, hotel);
        return {
          ...this.roomTypeView(rt, hotel, locale),
          roomsLeft: rt.rooms.length,
          nights: price.nights.length,
          perNight: fromCents(Math.round(price.subtotal / price.nights.length)),
          total: fromCents(price.total),
        };
      });
  }

  async roomType(id: string, locale: Locale) {
    const rt = await this.prisma.roomType.findUnique({ where: { id }, include: { hotel: true } });
    if (!rt || !rt.active) throw new AppError('NOT_FOUND', 404);
    return { ...this.roomTypeView(rt, rt.hotel, locale), policy: this.policyView(rt.hotel.policies, rt.hotel, locale) };
  }

  // ───────────── B-2 hold ─────────────

  /**
   * Holds one physical room for every night. The RoomNight primary key (roomId, date) makes the
   * database refuse a double sale, so two guests racing for the last room: one wins, one tries the
   * next room or gets ROOM_UNAVAILABLE.
   */
  async hold(userId: string, dto: HoldDto, key: string, locale: Locale) {
    const prior = await this.prisma.reservation.findUnique({ where: { idempotencyKey: key } });
    if (prior) return this.replay(prior, userId, locale);

    const hotel = await this.hotel(dto.hotelId);
    this.checkDates(dto.checkIn, dto.checkOut, hotel);
    const from = day(dto.checkIn);
    const to = day(dto.checkOut);
    const rt = await this.prisma.roomType.findFirst({
      where: { id: dto.roomTypeId, hotelId: hotel.id, active: true },
      include: { rates: { where: { date: { gte: from, lt: to } } } },
    });
    if (!rt) throw new AppError('NOT_FOUND', 404);
    if (dto.adults + (dto.children ?? 0) > rt.maxGuests) throw new AppError('TOO_MANY_GUESTS', 400);

    // First booking at this hotel makes the user its guest (ON CONFLICT DO NOTHING: safe on double taps).
    await this.prisma.membership.createMany({
      data: [{ userId, hotelId: hotel.id, role: 'GUEST' }],
      skipDuplicates: true,
    });

    const price = this.quote(rt, dto.checkIn, dto.checkOut, hotel);
    const snapshot: Snapshot = {
      roomType: { id: rt.id, name: rt.name as Json },
      nights: price.nights.map((n) => ({ date: n.date, price: fromCents(n.cents) })),
      subtotal: fromCents(price.subtotal),
      serviceCharge: fromCents(price.serviceCharge),
      tax: fromCents(price.tax),
      total: fromCents(price.total),
      policy: readPolicy(hotel.policies),
      terms: (hotel.policies ?? {}) as Record<string, unknown>,
    };
    const holdUntil = new Date(Date.now() + HOLD_MS);

    for (const roomId of await this.freeRoomIds(rt.id, hotel.id, from, to)) {
      try {
        const r = await this.prisma.reservation.create({
          data: {
            hotelId: hotel.id,
            code: bookingCode((n) => randomInt(n)),
            guestId: userId,
            roomTypeId: rt.id,
            status: 'HOLD',
            holdExpiresAt: holdUntil,
            checkIn: from,
            checkOut: to,
            adults: dto.adults,
            children: dto.children ?? 0,
            specialRequests: dto.specialRequests,
            priceSnapshot: snapshot as unknown as Prisma.InputJsonValue,
            total: snapshot.total,
            currency: hotel.currency,
            idempotencyKey: key,
            nights: {
              createMany: {
                data: price.nights.map((n) => ({
                  roomId,
                  date: day(n.date),
                  hotelId: hotel.id,
                  kind: 'HOLD' as const,
                  holdExpiresAt: holdUntil,
                })),
              },
            },
          },
        });
        await this.statusEvent(r, null, 'HOLD', userId);
        return this.view(r.id, userId, locale);
      } catch (e) {
        if (isUnique(e, 'idempotencyKey')) {
          return this.replay(await this.prisma.reservation.findUniqueOrThrow({ where: { idempotencyKey: key } }), userId, locale);
        }
        if (isUnique(e)) continue; // someone took a night in this room a moment ago: try the next room
        throw e;
      }
    }
    throw new AppError('ROOM_UNAVAILABLE', 409);
  }

  /** Runs every minute: holds past their time free their rooms. */
  async expireHolds() {
    const now = new Date();
    await this.prisma.reservation.updateMany({
      where: { status: 'HOLD', holdExpiresAt: { lt: now } },
      data: { status: 'EXPIRED' },
    });
    await this.prisma.roomNight.deleteMany({ where: { kind: 'HOLD', holdExpiresAt: { lt: now } } });
  }

  // ───────────── B-3 pay ─────────────

  async pay(userId: string, id: string, type: 'DEPOSIT' | 'FULL', key: string) {
    const prior = await this.prisma.payment.findUnique({ where: { idempotencyKey: key } });
    if (prior) {
      if (prior.reservationId !== id) throw new AppError('IDEMPOTENCY_CONFLICT', 409);
      return { paymentId: prior.id, checkoutUrl: prior.checkoutUrl };
    }
    const r = await this.load(id, userId);
    if (r.guestId !== userId) throw new AppError('FORBIDDEN', 403);
    const hotel = await this.hotel(r.hotelId);
    const total = toCents(r.total);

    let amount: number;
    let kind: string;
    if (r.status === 'HOLD') {
      if (!r.holdExpiresAt || r.holdExpiresAt <= new Date()) throw new AppError('HOLD_EXPIRED', 409);
      amount = type === 'DEPOSIT' ? depositCents(total, snap(r).policy.depositPercent) : total;
      kind = type;
      const until = new Date(Date.now() + PAY_MS);
      await this.prisma.$transaction([
        this.prisma.reservation.update({ where: { id }, data: { holdExpiresAt: until } }),
        this.prisma.roomNight.updateMany({ where: { reservationId: id, kind: 'HOLD' }, data: { holdExpiresAt: until } }),
      ]);
    } else if (r.status === 'CONFIRMED' || r.status === 'CHECKED_IN') {
      amount = total - discountCents(r.invoiceLines) - paidCents(r.payments);
      kind = 'BALANCE';
    } else {
      throw new AppError('NOTHING_TO_PAY', 409);
    }
    if (amount <= 0) throw new AppError('NOTHING_TO_PAY', 409);

    return this.startCheckout({
      hotelId: r.hotelId,
      reservationId: id,
      kind,
      amountCents: amount,
      currency: r.currency,
      key,
      description: `${hotel.name} · ${r.code}`,
    });
  }

  /** Creates a PENDING payment and a hosted checkout for it. Used for bookings and paid services. */
  async startCheckout(i: {
    hotelId: string;
    reservationId?: string;
    serviceReqId?: string;
    kind: string;
    amountCents: number;
    currency: string;
    key: string;
    description: string;
  }) {
    let payment: Payment;
    try {
      payment = await this.prisma.payment.create({
        data: {
          hotelId: i.hotelId,
          reservationId: i.reservationId,
          serviceReqId: i.serviceReqId,
          provider: this.gateway.name,
          kind: i.kind,
          amount: fromCents(i.amountCents),
          currency: i.currency,
          status: 'PENDING',
          idempotencyKey: i.key,
        },
      });
    } catch (e) {
      if (!isUnique(e, 'idempotencyKey')) throw e;
      const p = await this.prisma.payment.findUniqueOrThrow({ where: { idempotencyKey: i.key } });
      return { paymentId: p.id, checkoutUrl: p.checkoutUrl };
    }

    const base = publicApiUrl();
    try {
      const co = await this.gateway.createCheckout({
        reference: payment.id,
        amountCents: i.amountCents,
        currency: i.currency,
        description: i.description,
        successUrl: `${base}/v1/payments/return?status=success`,
        cancelUrl: `${base}/v1/payments/return?status=cancel`,
      });
      await this.prisma.payment.update({ where: { id: payment.id }, data: { providerRef: co.id, checkoutUrl: co.url } });
      return { paymentId: payment.id, checkoutUrl: co.url };
    } catch (e) {
      console.error('[pay] checkout failed', e);
      await this.prisma.payment.update({ where: { id: payment.id }, data: { status: 'FAILED' } });
      throw new AppError('PAYMENT_UNAVAILABLE', 502);
    }
  }

  /**
   * Webhook entry point (also used by the mock checkout). Safe to receive the same event twice:
   * the event is logged once, and the payment flips PENDING→SUCCEEDED only once.
   */
  async onGatewayEvent(provider: string, ev: GatewayEvent, payload: unknown) {
    const where = { provider_providerEventId: { provider, providerEventId: ev.eventId } };
    const rec = await this.prisma.paymentProviderEvent.upsert({
      where,
      create: { provider, providerEventId: ev.eventId, payload: payload as Prisma.InputJsonValue },
      update: {},
    });
    if (rec.processedAt) return;
    if (ev.type === 'paid' && ev.providerRef) await this.paymentSucceeded(ev.providerRef, ev.providerPaymentId);
    await this.prisma.paymentProviderEvent.update({ where, data: { processedAt: new Date() } });
  }

  private async paymentSucceeded(providerRef: string, providerPaymentId?: string) {
    const p = await this.prisma.payment.findUnique({ where: { providerRef } });
    if (!p) return;
    const claimed = await this.prisma.payment.updateMany({
      where: { id: p.id, status: { in: ['PENDING', 'FAILED'] } },
      data: { status: 'SUCCEEDED', providerPaymentId },
    });
    if (claimed.count === 0) return; // already handled

    if (p.serviceReqId) {
      const sr = await this.prisma.serviceRequest.update({ where: { id: p.serviceReqId }, data: { paidAt: new Date() } });
      await this.notifications.notify(sr.guestId, 'payment.receipt', { code: sr.id.slice(0, 8).toUpperCase(), amount: money(toCents(p.amount), p.currency) }, { hotelId: p.hotelId });
      return;
    }
    if (!p.reservationId) return;

    const r = await this.prisma.reservation.findUniqueOrThrow({ where: { id: p.reservationId } });
    const hotel = await this.hotel(r.hotelId);
    const cents = toCents(p.amount);
    await this.prisma.invoiceLine.create({
      data: { hotelId: r.hotelId, reservationId: r.id, kind: 'payment', description: TEXT.payment, amount: fromCents(-cents), sourceId: p.id },
    });
    const vars = this.vars(r, hotel);
    await this.notifications.notify(r.guestId, 'payment.receipt', { ...vars, amount: money(cents, r.currency) }, { hotelId: r.hotelId });

    if (r.status === 'HOLD' || r.status === 'EXPIRED') {
      if (await this.bookNights(r)) {
        // Hotels that review every booking (policy.requireApproval) get it as PENDING in the staff queue.
        const next = snap(r).policy.requireApproval ? 'PENDING' : 'CONFIRMED';
        const ok = await this.prisma.reservation.updateMany({
          where: { id: r.id, status: { in: ['HOLD', 'EXPIRED'] } },
          data: { status: next, holdExpiresAt: null },
        });
        if (ok.count) {
          await this.statusEvent(r, r.status, next, null);
          if (next === 'CONFIRMED') await this.confirmed(r, hotel);
          else await this.notifications.notify(r.guestId, 'booking.received', vars, { hotelId: r.hotelId });
        }
        return;
      }
      // Hold lapsed and someone else took the room before the payment landed.
      await this.prisma.reservation.update({ where: { id: r.id }, data: { status: 'CANCELLED', holdExpiresAt: null } });
      await this.statusEvent(r, r.status, 'CANCELLED', null, 'Sold out before payment completed');
      await this.refundAndNotify(r, [p.id], cents, 'Room sold out before payment completed', 'system');
      await this.notifications.notify(r.guestId, 'booking.cancelled', { ...vars, reason: '' }, { hotelId: r.hotelId });
    } else if (!['CONFIRMED', 'CHECKED_IN', 'CHECKED_OUT'].includes(r.status)) {
      // Paid after the booking was cancelled/declined: give it back.
      await this.refundAndNotify(r, [p.id], cents, `Paid after booking was ${r.status.toLowerCase()}`, 'system');
    }
  }

  /** Turn the hold into a booking; if the hold lapsed, try to get a room of the same type again. */
  private async bookNights(r: Reservation): Promise<boolean> {
    const nights = nightsOf(isoDate(r.checkIn), isoDate(r.checkOut));
    const flipped = await this.prisma.roomNight.updateMany({
      where: { reservationId: r.id, kind: 'HOLD' },
      data: { kind: 'BOOKED', holdExpiresAt: null },
    });
    if (flipped.count === nights.length) return true;
    await this.prisma.roomNight.deleteMany({ where: { reservationId: r.id } });
    for (const roomId of await this.freeRoomIds(r.roomTypeId, r.hotelId, r.checkIn, r.checkOut)) {
      try {
        await this.prisma.roomNight.createMany({
          data: nights.map((d) => ({ roomId, date: day(d), hotelId: r.hotelId, kind: 'BOOKED' as const, reservationId: r.id })),
        });
        return true;
      } catch (e) {
        if (isUnique(e)) continue;
        throw e;
      }
    }
    return false;
  }

  async notifyCancelled(r: Reservation, reason?: string) {
    const hotel = await this.hotel(r.hotelId);
    await this.notifications.notify(r.guestId, 'booking.cancelled', { ...this.vars(r, hotel), reason: reason ?? '' }, { hotelId: r.hotelId });
  }

  /** Folio charges + guest notice. Called on instant confirmation and on staff approval. */
  async confirmed(r: Reservation, hotel: Hotel) {
    await this.chargeRoom(r);
    await this.notifications.notify(r.guestId, 'booking.confirmed', this.vars(r, hotel), { hotelId: r.hotelId });
  }

  /** Room, service charge and tax go on the folio when the booking is confirmed. */
  private async chargeRoom(r: Reservation) {
    const s = snap(r);
    const lines = [
      { kind: 'room', description: TEXT.nights(s.nights.length, s.roomType.name), amount: s.subtotal },
      { kind: 'service_charge', description: TEXT.serviceCharge, amount: s.serviceCharge },
      { kind: 'tax', description: TEXT.tax, amount: s.tax },
    ].filter((l) => toCents(l.amount) > 0);
    await this.prisma.invoiceLine.createMany({
      data: lines.map((l) => ({ ...l, hotelId: r.hotelId, reservationId: r.id, sourceId: r.id })),
    });
  }

  // ───────────── B-5 view, list, cancel ─────────────

  async view(id: string, userId: string, locale: Locale) {
    const r = await this.load(id, userId);
    const hotel = await this.hotel(r.hotelId);
    const s = snap(r);
    const total = toCents(r.total);
    const paid = paidCents(r.payments);
    const discount = discountCents(r.invoiceLines);
    const confirmed = ['CONFIRMED', 'CHECKED_IN', 'CHECKED_OUT'].includes(r.status);
    return {
      id: r.id,
      code: r.code,
      status: r.status,
      checkIn: isoDate(r.checkIn),
      checkOut: isoDate(r.checkOut),
      adults: r.adults,
      children: r.children,
      specialRequests: r.specialRequests,
      holdExpiresAt: r.status === 'HOLD' ? r.holdExpiresAt : null,
      hotel: { id: hotel.id, name: hotel.name },
      roomType: { id: s.roomType.id, name: t(s.roomType.name, locale, hotel.defaultLocale) },
      room: confirmed ? (r.nights[0]?.room.number ?? null) : null,
      price: { nights: s.nights, subtotal: s.subtotal, serviceCharge: s.serviceCharge, tax: s.tax, total: s.total },
      currency: r.currency,
      paid: fromCents(paid),
      discount: fromCents(discount),
      balance: fromCents(Math.max(0, total - discount - paid)),
      depositAmount: fromCents(depositCents(total, s.policy.depositPercent)),
      payments: r.payments.map((p) => ({
        id: p.id,
        kind: p.kind,
        status: p.status,
        amount: p.amount,
        refundedAmount: p.refundedAmount,
        createdAt: p.createdAt,
      })),
      policy: this.policyView(s.terms, hotel, locale, s.policy),
      canCancel: OPEN_STATUSES.includes(r.status),
      createdAt: r.createdAt,
    };
  }

  async mine(userId: string, locale: Locale) {
    const rows = await this.prisma.reservation.findMany({
      where: { guestId: userId, status: { not: 'EXPIRED' } },
      orderBy: { checkIn: 'desc' },
      take: 100,
    });
    const hotels = new Map(
      (await this.prisma.hotel.findMany({ where: { id: { in: [...new Set(rows.map((r) => r.hotelId))] } } })).map((h) => [h.id, h]),
    );
    return rows.map((r) => {
      const hotel = hotels.get(r.hotelId)!;
      return {
        id: r.id,
        code: r.code,
        status: r.status,
        checkIn: isoDate(r.checkIn),
        checkOut: isoDate(r.checkOut),
        hotel: { id: hotel.id, name: hotel.name },
        roomType: { id: r.roomTypeId, name: t(snap(r).roomType.name, locale, hotel.defaultLocale) },
        total: r.total,
        currency: r.currency,
      };
    });
  }

  async cancelQuote(userId: string, id: string) {
    const r = await this.load(id, userId);
    const q = this.quoteCancel(r, await this.hotel(r.hotelId));
    return { paid: fromCents(q.paid), refund: fromCents(q.refund), freeCancelUntil: q.freeUntil, currency: r.currency };
  }

  async cancel(userId: string, id: string, locale: Locale, reason?: string) {
    const r = await this.load(id, userId);
    if (!OPEN_STATUSES.includes(r.status)) throw new AppError('CANNOT_CANCEL', 409);
    const hotel = await this.hotel(r.hotelId);
    const q = this.quoteCancel(r, hotel);

    const done = await this.prisma.reservation.updateMany({
      where: { id, status: r.status },
      data: { status: 'CANCELLED', holdExpiresAt: null },
    });
    if (!done.count) throw new AppError('CANNOT_CANCEL', 409); // changed under us
    await this.prisma.roomNight.deleteMany({ where: { reservationId: id } });
    await this.statusEvent(r, r.status, 'CANCELLED', userId, reason);
    if (r.guestId !== userId) {
      await this.prisma.audit({ hotelId: r.hotelId, actorId: userId, action: 'reservation.cancel', entityType: 'reservation', entityId: id, after: { reason, refund: q.refund } });
    }

    const paidIds = r.payments.filter((p) => PAID_STATUSES.includes(p.status)).map((p) => p.id);
    await this.refundAndNotify(r, paidIds, q.refund, reason ?? 'Cancelled', userId);
    if (r.status !== 'HOLD') {
      await this.notifications.notify(r.guestId, 'booking.cancelled', { ...this.vars(r, hotel), reason: reason ?? '' }, { hotelId: r.hotelId });
    }
    return this.view(id, userId, locale);
  }

  // ───────────── B-7 invoice, feedback ─────────────

  async invoice(userId: string, id: string, locale: Locale) {
    const r = await this.load(id, userId);
    const hotel = await this.hotel(r.hotelId);
    const lines = [...r.invoiceLines].sort((a, b) => a.createdAt.getTime() - b.createdAt.getTime());
    const sum = (kinds: (k: string) => boolean) =>
      lines.filter((l) => kinds(l.kind)).reduce((s, l) => s + toCents(l.amount), 0);
    const isMoney = (k: string) => k === 'payment' || k === 'refund';
    return {
      code: r.code,
      hotel: { name: hotel.name },
      currency: r.currency,
      lines: lines.map((l) => ({
        kind: l.kind,
        description: t(l.description, locale, hotel.defaultLocale),
        amount: l.amount,
        createdAt: l.createdAt,
      })),
      charges: fromCents(sum((k) => !isMoney(k))),
      paid: fromCents(-sum(isMoney)),
      balance: fromCents(sum(() => true)),
    };
  }

  async feedback(userId: string, dto: FeedbackDto) {
    const r = await this.load(dto.reservationId, userId);
    if (r.guestId !== userId) throw new AppError('FORBIDDEN', 403);
    if (!['CONFIRMED', 'CHECKED_IN', 'CHECKED_OUT'].includes(r.status)) throw new AppError('CANNOT_REVIEW', 409);
    const existing = await this.prisma.feedback.findFirst({ where: { reservationId: r.id, guestId: userId } });
    const data = { rating: dto.rating, comment: dto.comment };
    if (existing) await this.prisma.feedback.update({ where: { id: existing.id }, data });
    else await this.prisma.feedback.create({ data: { ...data, hotelId: r.hotelId, guestId: userId, reservationId: r.id } });
  }

  // ───────────── helpers ─────────────

  /** Owner, or staff/admin at the reservation's hotel. Everyone else gets NOT_FOUND. */
  private async load(id: string, userId: string) {
    const r = await this.prisma.reservation.findUnique({
      where: { id },
      include: {
        nights: { include: { room: true }, orderBy: { date: 'asc' } },
        payments: { orderBy: { createdAt: 'asc' } },
        invoiceLines: true,
      },
    });
    if (!r) throw new AppError('NOT_FOUND', 404);
    if (r.guestId !== userId) {
      const m = await this.prisma.membership.findUnique({ where: { userId_hotelId: { userId, hotelId: r.hotelId } } });
      if (!m || m.role === 'GUEST') throw new AppError('NOT_FOUND', 404);
    }
    return r;
  }

  private async replay(prior: Reservation, userId: string, locale: Locale) {
    if (prior.guestId !== userId) throw new AppError('IDEMPOTENCY_CONFLICT', 409);
    return this.view(prior.id, userId, locale);
  }

  async hotel(id: string) {
    const h = await this.prisma.hotel.findUnique({ where: { id } });
    if (!h) throw new AppError('NOT_FOUND', 404);
    return h;
  }

  private checkDates(checkIn: string, checkOut: string, hotel: Hotel) {
    const err = validateStay(checkIn, checkOut, todayIn(hotel.timezone));
    if (err) throw new AppError(err, 400);
  }

  private quote(rt: RoomType & { rates: RoomRate[] }, checkIn: string, checkOut: string, hotel: Hotel) {
    const rates = new Map(rt.rates.map((r) => [isoDate(r.date), toCents(r.price)]));
    const nights = nightsOf(checkIn, checkOut).map((date) => ({ date, cents: rates.get(date) ?? toCents(rt.basePrice) }));
    return priceStay(nights, Number(hotel.serviceCharge), Number(hotel.taxRate));
  }

  /** Clears lapsed holds on these dates (so they can't block the unique key), then lists free rooms. */
  async freeRoomIds(roomTypeId: string, hotelId: string, from: Date, to: Date) {
    await this.prisma.roomNight.deleteMany({
      where: { hotelId, kind: 'HOLD', holdExpiresAt: { lte: new Date() }, date: { gte: from, lt: to } },
    });
    const rooms = await this.prisma.room.findMany({
      where: { roomTypeId, ...freeRooms(from, to) },
      select: { id: true },
      orderBy: { number: 'asc' },
    });
    return rooms.map((r) => r.id);
  }

  private quoteCancel(r: Reservation & { payments: Payment[] }, hotel: Hotel) {
    const policy = snap(r).policy;
    const checkInAt = zonedToUtc(isoDate(r.checkIn), policy.checkIn, hotel.timezone);
    const paid = paidCents(r.payments);
    return {
      paid,
      refund: refundCents(paid, new Date(), checkInAt, policy),
      freeUntil: new Date(checkInAt.getTime() - policy.freeCancelHours * 3_600_000),
    };
  }

  /** Spread `cents` over the given payments, newest refundable first. Returns what was refunded. */
  async refundAndNotify(r: Reservation, paymentIds: string[], cents: number, reason: string, actorId: string) {
    let left = cents;
    let refunded = 0;
    for (const id of [...paymentIds].reverse()) {
      if (left <= 0) break;
      const p = await this.prisma.payment.findUniqueOrThrow({ where: { id } });
      const portion = Math.min(left, toCents(p.amount) - toCents(p.refundedAmount));
      if (portion <= 0) continue;
      const got = await this.refundPayment(p, portion, reason, actorId);
      refunded += got;
      left -= got;
    }
    if (refunded > 0) {
      await this.loyalty.reverse('reservation', r.id);
      const hotel = await this.hotel(r.hotelId);
      await this.notifications.notify(r.guestId, 'refund.issued', { ...this.vars(r, hotel), amount: money(refunded, r.currency) }, { hotelId: r.hotelId });
    }
    return refunded;
  }

  async refundPayment(p: Payment, cents: number, reason: string, actorId: string): Promise<number> {
    const row = await this.prisma.refund.create({
      data: { paymentId: p.id, amount: fromCents(cents), reason, status: 'pending', byUserId: actorId },
    });
    try {
      if (!p.providerPaymentId) throw new Error('payment has no provider payment id');
      const res = await this.gateway.refund({ providerPaymentId: p.providerPaymentId, amountCents: cents, reason });
      const fullyRefunded = toCents(p.refundedAmount) + cents >= toCents(p.amount);
      await this.prisma.$transaction([
        this.prisma.refund.update({ where: { id: row.id }, data: { providerRef: res.id, status: res.status } }),
        this.prisma.payment.update({
          where: { id: p.id },
          data: { refundedAmount: { increment: fromCents(cents) }, status: fullyRefunded ? 'REFUNDED' : 'PARTIALLY_REFUNDED' },
        }),
        this.prisma.invoiceLine.create({
          data: { hotelId: p.hotelId, reservationId: p.reservationId!, kind: 'refund', description: TEXT.refund, amount: fromCents(cents), sourceId: row.id },
        }),
      ]);
      return cents;
    } catch (e) {
      // Money is not lost: the failed Refund row + audit entry is the to-do for finance (admin retry: Phase 4).
      console.error('[refund] failed', e);
      await this.prisma.refund.update({ where: { id: row.id }, data: { status: 'failed' } });
      await this.prisma.audit({
        hotelId: p.hotelId,
        actorId,
        action: 'refund.failed',
        entityType: 'payment',
        entityId: p.id,
        after: { cents, error: String(e) },
      });
      return 0;
    }
  }

  statusEvent(r: Reservation, from: string | null, to: string, byUserId: string | null, note?: string) {
    return this.prisma.statusEvent.create({
      data: { hotelId: r.hotelId, entityType: 'reservation', entityId: r.id, fromStatus: from, toStatus: to, byUserId, note },
    });
  }

  vars(r: Reservation, hotel: Hotel) {
    return { hotel: hotel.name, code: r.code, checkIn: isoDate(r.checkIn), checkOut: isoDate(r.checkOut) };
  }

  private roomTypeView(rt: RoomType, hotel: Hotel, locale: Locale) {
    return {
      id: rt.id,
      name: t(rt.name, locale, hotel.defaultLocale),
      description: t(rt.description, locale, hotel.defaultLocale),
      photos: rt.photos.map(assetUrl),
      amenities: rt.amenities,
      maxGuests: rt.maxGuests,
      basePrice: rt.basePrice,
      currency: hotel.currency,
    };
  }

  private policyView(terms: unknown, hotel: Hotel, locale: Locale, policy = readPolicy(terms)) {
    const raw = (terms ?? {}) as Record<string, unknown>;
    return {
      checkIn: policy.checkIn,
      checkOut: policy.checkOut,
      freeCancelHours: policy.freeCancelHours,
      depositPercent: policy.depositPercent,
      cancellation: t(raw.cancellation, locale, hotel.defaultLocale),
    };
  }
}
