/**
 * Booking end to end against a real Postgres (DATABASE_URL), mock payment provider.
 * Phase 2 gates: last room can't be double-sold, duplicate webhook is processed once,
 * cancel refunds by policy and frees the room, notifications are queued.
 */
import { INestApplication } from '@nestjs/common';
import { Test } from '@nestjs/testing';
import { randomUUID } from 'node:crypto';
import request from 'supertest';
import { AppModule, setupApp } from '../src/app.module';
import { BookingService } from '../src/booking/booking.service';
import { DAY_MS, isoDate } from '../src/booking/domain';
import { PrismaService } from '../src/common/prisma.service';

describe('booking', () => {
  let app: INestApplication;
  let prisma: PrismaService;
  let hotelId: string;
  let roomTypeId: string;
  let token: string;
  const checkIn = isoDate(new Date(Date.now() + 60 * DAY_MS));
  const checkOut = isoDate(new Date(Date.now() + 62 * DAY_MS));
  const http = () => request(app.getHttpServer());
  const auth = () => ({ Authorization: `Bearer ${token}` });

  beforeAll(async () => {
    try {
      process.loadEnvFile();
    } catch {}
    process.env.JWT_SECRET ??= 'test-secret-not-for-prod';
    process.env.PAYMENT_PROVIDER = 'mock';
    process.env.JOBS = 'off';
    const mod = await Test.createTestingModule({ imports: [AppModule] }).compile();
    app = setupApp(mod.createNestApplication({ rawBody: true }));
    await app.init();
    prisma = app.get(PrismaService);

    const hotel = await prisma.hotel.create({
      data: { name: 'Booking Test Hotel', policies: { freeCancelHours: 48, depositPercent: 30 } },
    });
    hotelId = hotel.id;
    const rt = await prisma.roomType.create({
      data: {
        hotelId,
        name: { en: 'Only Room' },
        description: {},
        maxGuests: 2,
        basePrice: 1000,
        rooms: { create: [{ hotelId, number: '101' }] }, // exactly one room
      },
    });
    roomTypeId = rt.id;
    const reg = await http()
      .post('/v1/auth/register')
      .send({ fullName: 'B', login: `b-${randomUUID()}@tuloy.test`, password: 'Sup3rSecret!', hotelId })
      .expect(201);
    token = reg.body.accessToken;
  });

  afterAll(() => app.close());

  const hold = (key = randomUUID()) =>
    http()
      .post('/v1/holds')
      .set(auth())
      .set('Idempotency-Key', key)
      .send({ hotelId, roomTypeId, checkIn, checkOut, adults: 2 });

  it('prices the stay: 2 nights × 1000 + 10% service + 12% VAT', async () => {
    const res = await http().get(`/v1/hotels/${hotelId}/availability`).query({ checkIn, checkOut, adults: 2 }).expect(200);
    expect(res.body).toHaveLength(1);
    expect(res.body[0]).toMatchObject({ roomsLeft: 1, nights: 2, total: '2464.00' }); // (2000 + 200) × 1.12
  });

  it('20 guests race for the last room: exactly one hold succeeds', async () => {
    const results = await Promise.all(Array.from({ length: 20 }, () => hold()));
    const ok = results.filter((r) => r.status === 201);
    expect(ok).toHaveLength(1);
    expect(results.filter((r) => r.status === 409).every((r) => r.body.error.code === 'ROOM_UNAVAILABLE')).toBe(true);
    await prisma.reservation.update({ where: { id: ok[0].body.id }, data: { status: 'CANCELLED' } });
    await prisma.roomNight.deleteMany({ where: { reservationId: ok[0].body.id } });
  });

  it('same Idempotency-Key returns the same hold', async () => {
    const key = randomUUID();
    const a = await hold(key).expect(201);
    const b = await hold(key).expect(201);
    expect(b.body.id).toBe(a.body.id);
    await http().post(`/v1/reservations/${a.body.id}/cancel`).set(auth()).send({}).expect(200);
  });

  it('hold → deposit → duplicate webhook → confirmed once → cancel refunds and frees the room', async () => {
    const h = await hold().expect(201);
    expect(h.body).toMatchObject({ status: 'HOLD', depositAmount: '739.20' });

    const pay = await http()
      .post(`/v1/reservations/${h.body.id}/pay`)
      .set(auth())
      .set('Idempotency-Key', randomUUID())
      .send({ type: 'DEPOSIT' })
      .expect(200);
    expect(pay.body.checkoutUrl).toContain(`/v1/payments/mock/${pay.body.paymentId}`);

    await http().post(`/v1/payments/mock/${pay.body.paymentId}`).expect(200);
    await http().post(`/v1/payments/mock/${pay.body.paymentId}`).expect(200); // webhook retried

    const r = await http().get(`/v1/reservations/${h.body.id}`).set(auth()).expect(200);
    expect(r.body).toMatchObject({ status: 'CONFIRMED', room: '101', paid: '739.20', balance: '1724.80' });

    const inv = await http().get(`/v1/reservations/${h.body.id}/invoice`).set(auth()).expect(200);
    expect(inv.body.lines.filter((l: { kind: string }) => l.kind === 'payment')).toHaveLength(1);
    expect(inv.body).toMatchObject({ charges: '2464.00', paid: '739.20', balance: '1724.80' });

    const queued = await prisma.notificationDelivery.findMany({ where: { event: 'booking.confirmed' } });
    expect(queued.length).toBeGreaterThan(0);

    const quote = await http().get(`/v1/reservations/${h.body.id}/cancel-quote`).set(auth()).expect(200);
    expect(quote.body).toMatchObject({ paid: '739.20', refund: '739.20' }); // 60 days out: free window

    const c = await http().post(`/v1/reservations/${h.body.id}/cancel`).set(auth()).send({}).expect(200);
    expect(c.body).toMatchObject({ status: 'CANCELLED', paid: '0.00' });
    expect(c.body.payments[0]).toMatchObject({ status: 'REFUNDED' });

    const again = await http().get(`/v1/hotels/${hotelId}/availability`).query({ checkIn, checkOut, adults: 1 }).expect(200);
    expect(again.body[0].roomsLeft).toBe(1);
  });

  it('expired hold frees the room; a late payment still confirms if the room is free', async () => {
    const h = await hold().expect(201);
    const pay = await http()
      .post(`/v1/reservations/${h.body.id}/pay`)
      .set(auth())
      .set('Idempotency-Key', randomUUID())
      .send({ type: 'FULL' })
      .expect(200);
    await prisma.reservation.update({ where: { id: h.body.id }, data: { holdExpiresAt: new Date(Date.now() - 1000) } });
    await prisma.roomNight.updateMany({ where: { reservationId: h.body.id }, data: { holdExpiresAt: new Date(Date.now() - 1000) } });
    await app.get(BookingService).expireHolds();
    expect((await prisma.reservation.findUniqueOrThrow({ where: { id: h.body.id } })).status).toBe('EXPIRED');

    await http().post(`/v1/payments/mock/${pay.body.paymentId}`).expect(200);
    const r = await http().get(`/v1/reservations/${h.body.id}`).set(auth()).expect(200);
    expect(r.body.status).toBe('CONFIRMED');
  });
});
