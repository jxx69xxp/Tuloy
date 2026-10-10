import { Injectable } from '@nestjs/common';
import { Membership, PaymentMethod, Prisma, Service, ServiceOption, ServiceRequest } from '@prisma/client';
import { BookingService, isUnique } from '../booking/booking.service';
import { DAY_MS, fromCents, toCents } from '../booking/domain';
import { sameHotel } from '../common/auth';
import { AppError } from '../common/errors';
import { Locale, t } from '../common/i18n';
import { PrismaService } from '../common/prisma.service';
import { assetUrl } from '../common/storage';
import { LoyaltyService } from '../loyalty/loyalty.service';
import { NotificationsService } from '../notifications/notifications.service';
import { FieldDef, PriceModel, Schedule, invalidAnswer, localParts, missingForPublish, nextStep, priceService, scheduleError } from './domain';

type Json = Record<string, string>;

/** Frozen at order time: later edits to the service never change an existing request. */
interface RequestSnapshot {
  name: Json;
  category: string;
  version: number;
  options: { id: string; name: Json; priceDelta: string }[];
  priceModel: PriceModel;
  units: { quantity: number; persons: number; nights: number };
  subtotal: string | null;
  tax: string | null;
  statusSteps: string[];
  cancellationPolicy: Json;
  departmentId: string | null;
  loyaltyEarn: boolean;
}

export interface ServiceInput {
  category: string;
  name: Json;
  description: Json;
  instructions?: Json;
  imageKey?: string;
  schedule: Schedule;
  leadTimeMin: number;
  capacityPerSlot?: number;
  etaMin?: number;
  blackoutDates: string[];
  priceModel: PriceModel;
  basePrice?: number;
  currency: string;
  taxIncluded: boolean;
  paymentMethods: PaymentMethod[];
  fields: FieldDef[];
  departmentId?: string;
  acceptanceMode: 'AUTO' | 'STAFF_APPROVAL';
  statusSteps: string[];
  cancellationPolicy: Json;
  loyaltyEarn: boolean;
  loyaltyRedeem: boolean;
}

export interface RequestInput {
  serviceId: string;
  reservationId?: string;
  optionIds: string[];
  answers: Record<string, unknown>;
  scheduledFor?: string;
  paymentMethod: PaymentMethod;
}

const snapOf = (r: ServiceRequest) => r.snapshot as unknown as RequestSnapshot;
const OPEN = { notIn: ['completed', 'cancelled'] };

@Injectable()
export class ServicesService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly booking: BookingService,
    private readonly notifications: NotificationsService,
    private readonly loyalty: LoyaltyService,
  ) {}

  // ───────────── S-1 builder (admin) ─────────────

  private data(i: ServiceInput) {
    return {
      ...i,
      basePrice: i.basePrice ?? null,
      blackoutDates: i.blackoutDates.map((d) => new Date(`${d}T00:00:00Z`)),
      schedule: i.schedule as unknown as Prisma.InputJsonValue,
      fields: i.fields as unknown as Prisma.InputJsonValue,
    };
  }

  async create(m: Membership, i: ServiceInput) {
    await this.checkDepartment(m, i.departmentId);
    return this.prisma.service.create({ data: { ...this.data(i), hotelId: m.hotelId, status: 'DRAFT' } });
  }

  async update(m: Membership, id: string, i: ServiceInput, userId: string) {
    sameHotel(await this.prisma.service.findUnique({ where: { id } }), m);
    await this.checkDepartment(m, i.departmentId);
    const s = await this.prisma.service.update({ where: { id }, data: { ...this.data(i), version: { increment: 1 } } });
    await this.prisma.audit({ hotelId: m.hotelId, actorId: userId, action: 'service.update', entityType: 'service', entityId: id });
    return s;
  }

  /** Replaces the option list: rows not sent are deactivated (kept, so old snapshots still make sense). */
  async setOptions(m: Membership, id: string, options: { id?: string; name: Json; priceDelta: number; active: boolean }[]) {
    sameHotel(await this.prisma.service.findUnique({ where: { id } }), m);
    const keep: string[] = [];
    for (const o of options) {
      const row = o.id
        ? await this.prisma.serviceOption.update({ where: { id: o.id, serviceId: id }, data: { name: o.name, priceDelta: o.priceDelta, active: o.active } })
        : await this.prisma.serviceOption.create({ data: { serviceId: id, name: o.name, priceDelta: o.priceDelta, active: o.active } });
      keep.push(row.id);
    }
    await this.prisma.serviceOption.updateMany({ where: { serviceId: id, id: { notIn: keep } }, data: { active: false } });
    return this.prisma.serviceOption.findMany({ where: { serviceId: id } });
  }

  async publish(m: Membership, id: string, userId: string) {
    const s = sameHotel(await this.prisma.service.findUnique({ where: { id } }), m);
    const hotel = await this.prisma.hotel.findUniqueOrThrow({ where: { id: m.hotelId } });
    const missing = missingForPublish(s, hotel.locales);
    if (missing.length) throw new AppError('SERVICE_INCOMPLETE', 422, { missing });
    await this.prisma.service.update({ where: { id }, data: { status: 'PUBLISHED' } });
    await this.prisma.audit({ hotelId: m.hotelId, actorId: userId, action: 'service.publish', entityType: 'service', entityId: id });
  }

  async pause(m: Membership, id: string, userId: string) {
    sameHotel(await this.prisma.service.findUnique({ where: { id } }), m);
    await this.prisma.service.update({ where: { id }, data: { status: 'PAUSED' } });
    await this.prisma.audit({ hotelId: m.hotelId, actorId: userId, action: 'service.pause', entityType: 'service', entityId: id });
  }

  adminList(m: Membership) {
    return this.prisma.service.findMany({ where: { hotelId: m.hotelId, status: { not: 'ARCHIVED' } }, include: { options: true }, orderBy: { category: 'asc' } });
  }

  async adminGet(m: Membership, id: string) {
    const s = sameHotel(await this.prisma.service.findUnique({ where: { id }, include: { options: true } }), m);
    const hotel = await this.prisma.hotel.findUniqueOrThrow({ where: { id: m.hotelId } });
    return { ...s, missing: missingForPublish(s, hotel.locales) };
  }

  private async checkDepartment(m: Membership, id?: string) {
    if (id) sameHotel(await this.prisma.department.findUnique({ where: { id } }), m);
  }

  // ───────────── S-2 guest catalog & requests ─────────────

  private view(s: Service & { options: ServiceOption[] }, locale: Locale, fallback: Locale) {
    return {
      id: s.id,
      category: s.category,
      name: t(s.name, locale, fallback),
      description: t(s.description, locale, fallback),
      instructions: s.instructions ? t(s.instructions, locale, fallback) : null,
      imageUrl: s.imageKey ? assetUrl(s.imageKey) : null,
      priceModel: s.priceModel,
      basePrice: s.basePrice,
      currency: s.currency,
      taxIncluded: s.taxIncluded,
      etaMin: s.etaMin,
      leadTimeMin: s.leadTimeMin,
      schedule: s.schedule,
      paymentMethods: s.paymentMethods,
      cancellationPolicy: t(s.cancellationPolicy, locale, fallback),
      options: s.options.filter((o) => o.active).map((o) => ({ id: o.id, name: t(o.name, locale, fallback), priceDelta: o.priceDelta })),
      fields: (s.fields as unknown as FieldDef[]).map((f) => ({
        key: f.key,
        type: f.type,
        required: !!f.required,
        label: t(f.label, locale, fallback),
        options: f.options?.map((o) => ({ value: o.value, label: t(o.label, locale, fallback) })),
      })),
    };
  }

  async catalog(hotelId: string, locale: Locale) {
    const hotel = await this.prisma.hotel.findUnique({ where: { id: hotelId } });
    if (!hotel) throw new AppError('NOT_FOUND', 404);
    const rows = await this.prisma.service.findMany({ where: { hotelId, status: 'PUBLISHED' }, include: { options: true }, orderBy: { category: 'asc' } });
    return rows.map((s) => this.view(s, locale, hotel.defaultLocale));
  }

  async one(id: string, locale: Locale) {
    const s = await this.prisma.service.findUnique({ where: { id }, include: { options: true, } });
    if (!s || s.status !== 'PUBLISHED') throw new AppError('NOT_FOUND', 404);
    const hotel = await this.prisma.hotel.findUniqueOrThrow({ where: { id: s.hotelId } });
    return this.view(s, locale, hotel.defaultLocale);
  }

  async request(userId: string, i: RequestInput, key: string) {
    const prior = await this.prisma.serviceRequest.findUnique({ where: { idempotencyKey: key } });
    if (prior) {
      if (prior.guestId !== userId) throw new AppError('IDEMPOTENCY_CONFLICT', 409);
      return prior;
    }
    const s = await this.prisma.service.findUnique({ where: { id: i.serviceId }, include: { options: true } });
    if (!s || s.status !== 'PUBLISHED') throw new AppError('SERVICE_UNAVAILABLE', 409);
    const hotel = await this.prisma.hotel.findUniqueOrThrow({ where: { id: s.hotelId } });

    if (!s.paymentMethods.includes(i.paymentMethod)) throw new AppError('PAYMENT_METHOD_NOT_ALLOWED', 400);
    const reservation = i.reservationId ? await this.prisma.reservation.findUnique({ where: { id: i.reservationId } }) : null;
    if (i.reservationId && (!reservation || reservation.guestId !== userId || reservation.hotelId !== s.hotelId)) throw new AppError('NOT_FOUND', 404);
    // Room charge: only a verified in-house guest, on their own stay.
    if (i.paymentMethod === 'ROOM_CHARGE' && reservation?.status !== 'CHECKED_IN') throw new AppError('ROOM_CHARGE_NOT_ALLOWED', 403);

    const fields = s.fields as unknown as FieldDef[];
    const bad = invalidAnswer(fields, i.answers);
    if (bad) throw new AppError('VALIDATION', 400, { field: bad });

    let scheduledFor: Date | undefined;
    if (i.scheduledFor) {
      scheduledFor = new Date(i.scheduledFor);
      const err = scheduleError(
        s.schedule as unknown as Schedule,
        s.blackoutDates.map((d) => d.toISOString().slice(0, 10)),
        s.leadTimeMin,
        scheduledFor,
        new Date(),
        localParts(scheduledFor, hotel.timezone),
      );
      if (err) throw new AppError(err, 409);
      if (s.capacityPerSlot) {
        const slot = 30 * 60_000;
        const from = new Date(Math.floor(scheduledFor.getTime() / slot) * slot);
        const taken = await this.prisma.serviceRequest.count({
          where: { serviceId: s.id, status: OPEN, scheduledFor: { gte: from, lt: new Date(from.getTime() + slot) } },
        });
        if (taken >= s.capacityPerSlot) throw new AppError('SLOT_FULL', 409);
      }
    }

    const options = s.options.filter((o) => o.active && i.optionIds.includes(o.id));
    if (options.length !== new Set(i.optionIds).size) throw new AppError('VALIDATION', 400, { field: 'optionIds' });
    const num = (k: string) => (typeof i.answers[k] === 'number' ? (i.answers[k] as number) : 1);
    const units = {
      quantity: num('quantity'),
      persons: num('persons'),
      nights: reservation ? Math.round((reservation.checkOut.getTime() - reservation.checkIn.getTime()) / DAY_MS) : 1,
    };
    const subtotal = priceService(s.priceModel, toCents(s.basePrice ?? 0), options.map((o) => toCents(o.priceDelta)), units);
    const tax = subtotal == null || s.taxIncluded ? 0 : Math.round(subtotal * Number(hotel.taxRate));
    const snapshot: RequestSnapshot = {
      name: s.name as Json,
      category: s.category,
      version: s.version,
      options: options.map((o) => ({ id: o.id, name: o.name as Json, priceDelta: fromCents(toCents(o.priceDelta)) })),
      priceModel: s.priceModel,
      units,
      subtotal: subtotal == null ? null : fromCents(subtotal),
      tax: subtotal == null ? null : fromCents(tax),
      statusSteps: s.statusSteps,
      cancellationPolicy: s.cancellationPolicy as Json,
      departmentId: s.departmentId,
      loyaltyEarn: s.loyaltyEarn,
    };
    const status = s.acceptanceMode === 'AUTO' && subtotal != null ? s.statusSteps[1] : s.statusSteps[0];

    let req: ServiceRequest;
    try {
      req = await this.prisma.serviceRequest.create({
        data: {
          hotelId: s.hotelId,
          serviceId: s.id,
          guestId: userId,
          reservationId: reservation?.id,
          status,
          snapshot: snapshot as unknown as Prisma.InputJsonValue,
          answers: i.answers as Prisma.InputJsonValue,
          scheduledFor,
          total: subtotal == null ? null : fromCents(subtotal + tax),
          paymentMethod: i.paymentMethod,
          paidAt: i.paymentMethod === 'FREE' ? new Date() : null,
          idempotencyKey: key,
        },
      });
    } catch (e) {
      if (!isUnique(e, 'idempotencyKey')) throw e;
      return this.prisma.serviceRequest.findUniqueOrThrow({ where: { idempotencyKey: key } });
    }
    await this.event(req, null, status, userId);
    await this.alertStaff(req, s);
    return req;
  }

  async mine(userId: string, locale: Locale) {
    const rows = await this.prisma.serviceRequest.findMany({ where: { guestId: userId }, orderBy: { createdAt: 'desc' }, take: 100 });
    return rows.map((r) => this.requestView(r, locale));
  }

  async get(userId: string, id: string, locale: Locale) {
    const r = await this.prisma.serviceRequest.findUnique({ where: { id } });
    if (!r) throw new AppError('NOT_FOUND', 404);
    if (r.guestId !== userId) {
      const m = await this.prisma.membership.findUnique({ where: { userId_hotelId: { userId, hotelId: r.hotelId } } });
      if (!m || m.role === 'GUEST') throw new AppError('NOT_FOUND', 404);
    }
    const history = await this.prisma.statusEvent.findMany({ where: { entityType: 'service_request', entityId: id }, orderBy: { at: 'asc' } });
    return { ...this.requestView(r, locale), answers: r.answers, history: history.map((h) => ({ to: h.toStatus, at: h.at, note: h.note })) };
  }

  private requestView(r: ServiceRequest, locale: Locale) {
    const s = snapOf(r);
    return {
      id: r.id,
      serviceId: r.serviceId,
      name: t(s.name, locale),
      status: r.status,
      steps: s.statusSteps,
      options: s.options.map((o) => t(o.name, locale)),
      scheduledFor: r.scheduledFor,
      total: r.total,
      paymentMethod: r.paymentMethod,
      paid: !!r.paidAt,
      needsQuoteAcceptance: r.status === s.statusSteps[0] && r.total != null && s.priceModel === 'QUOTE',
      cancellationPolicy: t(s.cancellationPolicy, locale),
      reservationId: r.reservationId,
      assigneeId: r.assigneeId,
      createdAt: r.createdAt,
    };
  }

  /** Guest accepts a staff quote → request moves to the next step. */
  async acceptQuote(userId: string, id: string) {
    const r = await this.own(userId, id);
    const steps = snapOf(r).statusSteps;
    if (r.total == null || r.status !== steps[0]) throw new AppError('INVALID_TRANSITION', 409);
    await this.advance(r, steps[1], userId, 'Quote accepted');
  }

  /** Guest cancels before work starts. An online payment is refunded in full. */
  async cancelByGuest(userId: string, id: string) {
    const r = await this.own(userId, id);
    const steps = snapOf(r).statusSteps;
    if (!steps.slice(0, 2).includes(r.status)) throw new AppError('CANNOT_CANCEL', 409);
    await this.advance(r, 'cancelled', userId, 'Cancelled by guest');
    await this.refundOnline(r, userId);
  }

  /** Online payment for a priced request. */
  async pay(userId: string, id: string, key: string) {
    const r = await this.own(userId, id);
    if (r.paymentMethod !== 'ONLINE' || r.total == null || r.paidAt || r.status === 'cancelled') throw new AppError('NOTHING_TO_PAY', 409);
    const hotel = await this.prisma.hotel.findUniqueOrThrow({ where: { id: r.hotelId } });
    return this.booking.startCheckout({
      hotelId: r.hotelId,
      serviceReqId: r.id,
      kind: 'SERVICE',
      amountCents: toCents(r.total),
      currency: hotel.currency,
      key,
      description: `${hotel.name} · ${t(snapOf(r).name, hotel.defaultLocale)}`,
    });
  }

  private async own(userId: string, id: string) {
    const r = await this.prisma.serviceRequest.findUnique({ where: { id } });
    if (!r || r.guestId !== userId) throw new AppError('NOT_FOUND', 404);
    return r;
  }

  // ───────────── S-3 staff tasks ─────────────

  async tasks(m: Membership, userId: string, scope: 'mine' | 'department' | 'unassigned' | 'all', locale: Locale) {
    const where: Prisma.ServiceRequestWhereInput = { hotelId: m.hotelId, status: OPEN };
    if (scope === 'mine') where.assigneeId = userId;
    if (scope === 'unassigned') where.assigneeId = null;
    if (scope === 'department') where.snapshot = { path: ['departmentId'], equals: m.departmentId ?? '' };
    const rows = await this.prisma.serviceRequest.findMany({ where, orderBy: [{ scheduledFor: 'asc' }, { createdAt: 'asc' }], take: 200 });
    const rooms = await this.roomsFor(rows.map((r) => r.reservationId).filter((x): x is string => !!x));
    return rows.map((r) => ({ ...this.requestView(r, locale), room: r.reservationId ? (rooms.get(r.reservationId) ?? null) : null, answers: r.answers }));
  }

  private async roomsFor(reservationIds: string[]) {
    const nights = await this.prisma.roomNight.findMany({ where: { reservationId: { in: reservationIds } }, include: { room: true }, distinct: ['reservationId'] });
    return new Map(nights.map((n) => [n.reservationId!, n.room.number]));
  }

  private async task(m: Membership, id: string) {
    return sameHotel(await this.prisma.serviceRequest.findUnique({ where: { id } }), m);
  }

  async accept(m: Membership, id: string, userId: string) {
    const r = await this.task(m, id);
    const steps = snapOf(r).statusSteps;
    if (r.status !== steps[0] || r.total == null) throw new AppError('INVALID_TRANSITION', 409);
    await this.prisma.serviceRequest.update({ where: { id }, data: { assigneeId: r.assigneeId ?? userId } });
    await this.advance(r, steps[1], userId);
  }

  async assign(m: Membership, id: string, assigneeId: string, userId: string) {
    const r = await this.task(m, id);
    const staff = await this.prisma.membership.findUnique({ where: { userId_hotelId: { userId: assigneeId, hotelId: m.hotelId } } });
    if (!staff || staff.role === 'GUEST') throw new AppError('NOT_FOUND', 404);
    await this.prisma.serviceRequest.update({ where: { id }, data: { assigneeId } });
    await this.event(r, r.status, r.status, userId, `Assigned to ${assigneeId}`);
  }

  /** One step forward. The last step is completion. */
  async step(m: Membership, id: string, to: string, userId: string) {
    const r = await this.task(m, id);
    const steps = snapOf(r).statusSteps;
    if (r.status === steps[0] || nextStep(steps, r.status) !== to) throw new AppError('INVALID_TRANSITION', 409);
    await this.advance(r, to, userId);
    if (to === steps[steps.length - 1]) await this.completed(r);
  }

  async quote(m: Membership, id: string, amount: number, userId: string) {
    const r = await this.task(m, id);
    if (snapOf(r).priceModel !== 'QUOTE' || r.status !== snapOf(r).statusSteps[0]) throw new AppError('INVALID_TRANSITION', 409);
    await this.prisma.serviceRequest.update({ where: { id }, data: { total: amount.toFixed(2) } });
    await this.event(r, r.status, r.status, userId, `Quoted ${amount.toFixed(2)}`);
    await this.notifyGuest(r, 'quote');
  }

  /** Flags the task for a manager; status unchanged. */
  async escalate(m: Membership, id: string, note: string, userId: string) {
    const r = await this.task(m, id);
    await this.event(r, r.status, r.status, userId, `ESCALATED: ${note}`);
    await this.prisma.audit({ hotelId: r.hotelId, actorId: userId, action: 'service.escalate', entityType: 'service_request', entityId: id, after: { note } });
  }

  async cancelByStaff(m: Membership, id: string, reason: string, userId: string) {
    const r = await this.task(m, id);
    if (r.status === 'completed' || r.status === 'cancelled') throw new AppError('INVALID_TRANSITION', 409);
    await this.advance(r, 'cancelled', userId, reason);
    await this.refundOnline(r, userId);
  }

  // ───────────── helpers ─────────────

  /** Room charge posts to the folio and loyalty is earned once the work is done. */
  private async completed(r: ServiceRequest) {
    const s = snapOf(r);
    if (r.paymentMethod === 'ROOM_CHARGE' && r.reservationId && r.total != null) {
      await this.prisma.invoiceLine.create({
        data: { hotelId: r.hotelId, reservationId: r.reservationId, kind: 'service', description: s.name, amount: r.total, sourceId: r.id },
      });
      await this.prisma.serviceRequest.update({ where: { id: r.id }, data: { paidAt: new Date() } });
    }
    const paid = r.paidAt || r.paymentMethod === 'ROOM_CHARGE';
    if (s.loyaltyEarn && paid && r.total != null) await this.loyalty.earn(r.guestId, r.hotelId, toCents(r.total), 'service_request', r.id);
  }

  private async refundOnline(r: ServiceRequest, actorId: string) {
    if (r.paymentMethod !== 'ONLINE' || !r.paidAt) return;
    const payments = await this.prisma.payment.findMany({ where: { serviceReqId: r.id, status: 'SUCCEEDED' } });
    for (const p of payments) {
      await this.booking.refundPayment(p, toCents(p.amount) - toCents(p.refundedAmount), 'Service cancelled', actorId);
    }
    await this.loyalty.reverse('service_request', r.id);
  }

  /** Conditional update: two staff tapping at once can't skip or repeat a step. */
  private async advance(r: ServiceRequest, to: string, userId: string, note?: string) {
    const ok = await this.prisma.serviceRequest.updateMany({ where: { id: r.id, status: r.status }, data: { status: to } });
    if (!ok.count) throw new AppError('INVALID_TRANSITION', 409);
    await this.event(r, r.status, to, userId, note);
    await this.notifyGuest({ ...r, status: to }, to);
  }

  private event(r: ServiceRequest, from: string | null, to: string, by: string, note?: string) {
    return this.prisma.statusEvent.create({
      data: { hotelId: r.hotelId, entityType: 'service_request', entityId: r.id, fromStatus: from, toStatus: to, byUserId: by, note },
    });
  }

  private async notifyGuest(r: ServiceRequest, status: string) {
    const user = await this.prisma.user.findUnique({ where: { id: r.guestId } });
    const service = t(snapOf(r).name, (user?.locale ?? 'en') as Locale);
    await this.notifications.notify(r.guestId, 'service.updated', { service, status, requestId: r.id }, { hotelId: r.hotelId });
  }

  /** Push to the service's department (or all staff when none). */
  private async alertStaff(r: ServiceRequest, s: Service) {
    const staff = await this.prisma.membership.findMany({
      where: { hotelId: r.hotelId, role: { in: ['STAFF', 'ADMIN'] }, ...(s.departmentId ? { departmentId: s.departmentId } : {}) },
      take: 50,
    });
    const room = r.reservationId ? (await this.roomsFor([r.reservationId])).get(r.reservationId) : undefined;
    for (const m of staff) {
      await this.notifications.notify(m.userId, 'task.new', { service: t(s.name, 'en'), where: room ? `Room ${room}` : '', requestId: r.id }, { hotelId: r.hotelId });
    }
  }
}
