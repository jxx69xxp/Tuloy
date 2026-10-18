/**
 * Front-desk bookings against a real Postgres (DATABASE_URL): a walk-in takes a chosen room,
 * the same room can't be sold twice, changes re-price the folio, desk payments reduce the balance.
 */
import { INestApplication } from '@nestjs/common';
import { Test } from '@nestjs/testing';
import { randomUUID } from 'node:crypto';
import { AppModule, setupApp } from '../src/app.module';
import { BookingService } from '../src/booking/booking.service';
import { DAY_MS, isoDate } from '../src/booking/domain';
import { PrismaService } from '../src/common/prisma.service';

describe('front desk', () => {
  let app: INestApplication;
  let prisma: PrismaService;
  let booking: BookingService;
  let hotelId: string;
  let rooms: string[];
  const staffId = randomUUID();
  const d = (n: number) => isoDate(new Date(Date.now() + n * DAY_MS));
  /** Folio balance in cents: charges minus payments. */
  const balance = async (id: string) =>
    (await prisma.invoiceLine.findMany({ where: { reservationId: id } })).reduce((s, l) => s + Math.round(Number(l.amount) * 100), 0);

  beforeAll(async () => {
    try {
      process.loadEnvFile();
    } catch {}
    process.env.JWT_SECRET ??= 'test-secret-not-for-prod';
    process.env.PAYMENT_PROVIDER = 'mock';
    process.env.JOBS = 'off';
    const mod = await Test.createTestingModule({ imports: [AppModule] }).compile();
    app = setupApp(mod.createNestApplication());
    await app.init();
    prisma = app.get(PrismaService);
    booking = app.get(BookingService);
    // No service charge or tax, so totals are nights × 1000.
    const hotel = await prisma.hotel.create({ data: { name: 'Desk Test Hotel', serviceCharge: 0, taxRate: 0 } });
    hotelId = hotel.id;
    const rt = await prisma.roomType.create({
      data: {
        hotelId,
        name: { en: 'Desk Room' },
        description: {},
        maxGuests: 2,
        basePrice: 1000,
        rooms: { create: [{ hotelId, number: '101' }, { hotelId, number: '102' }] },
      },
      include: { rooms: { orderBy: { number: 'asc' } } },
    });
    rooms = rt.rooms.map((r) => r.id);
  });

  afterAll(() => app.close());

  it('books, refuses a clash, extends, moves room and takes a desk payment', async () => {
    const guest = { fullName: 'Walk In', phone: `0917${Date.now() % 10_000_000}` };
    const { id } = await booking.deskBook(hotelId, staffId, { roomId: rooms[0], checkIn: d(10), checkOut: d(12), adults: 2, guest });
    expect((await prisma.reservation.findUniqueOrThrow({ where: { id } })).status).toBe('CONFIRMED');
    expect(await balance(id)).toBe(200_000); // 2 nights × 1000, due at the hotel

    await expect(
      booking.deskBook(hotelId, staffId, { roomId: rooms[0], checkIn: d(11), checkOut: d(13), adults: 1, guest: { fullName: 'X', phone: '09' + Date.now() } }),
    ).rejects.toMatchObject({ code: 'ROOM_UNAVAILABLE' });

    await booking.deskChange(hotelId, staffId, id, { checkOut: d(13) }); // 3 nights
    expect(await balance(id)).toBe(300_000);

    await booking.deskChange(hotelId, staffId, id, { roomId: rooms[1] });
    const nights = await prisma.roomNight.findMany({ where: { reservationId: id } });
    expect(nights).toHaveLength(3);
    expect(nights.every((n) => n.roomId === rooms[1])).toBe(true);

    await booking.deskPayment(hotelId, staffId, id, 1000, 'cash');
    expect(await balance(id)).toBe(200_000);
  });
});
