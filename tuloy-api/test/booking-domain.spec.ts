// Pure rules — no database needed: `npx jest test/booking-domain.spec.ts`
import {
  canTransition,
  depositCents,
  nightsOf,
  priceStay,
  readPolicy,
  refundCents,
  todayIn,
  validateStay,
  zonedToUtc,
} from '../src/booking/domain';

describe('booking domain', () => {
  it('counts nights across month ends', () => {
    expect(nightsOf('2026-10-30', '2026-11-02')).toEqual(['2026-10-30', '2026-10-31', '2026-11-01']);
    expect(nightsOf('2026-10-30', '2026-10-30')).toEqual([]);
  });

  it('validates dates', () => {
    expect(validateStay('2026-10-12', '2026-10-14', '2026-10-10')).toBeNull();
    expect(validateStay('2026-10-09', '2026-10-14', '2026-10-10')).toBe('INVALID_DATES'); // past
    expect(validateStay('2026-10-14', '2026-10-14', '2026-10-10')).toBe('INVALID_DATES'); // zero nights
    expect(validateStay('2026-13-01', '2026-13-02', '2026-10-10')).toBe('INVALID_DATES');
    expect(validateStay('2026-10-12', '2026-12-12', '2026-10-10')).toBe('STAY_TOO_LONG');
  });

  it('prices a stay in centavos: service charge, then VAT on both', () => {
    const p = priceStay(
      [
        { date: '2026-10-12', cents: 350_000 },
        { date: '2026-10-13', cents: 420_050 },
      ],
      0.1,
      0.12,
    );
    expect(p.subtotal).toBe(770_050);
    expect(p.serviceCharge).toBe(77_005);
    expect(p.tax).toBe(Math.round(847_055 * 0.12)); // 101_647 (101646.6 rounded)
    expect(p.total).toBe(770_050 + 77_005 + 101_647);
  });

  it('deposit never exceeds the total', () => {
    expect(depositCents(10_001, 30)).toBe(3_000);
    expect(depositCents(10_001, 100)).toBe(10_001);
  });

  it('refund: full inside the free window, policy percent after', () => {
    const policy = readPolicy({ freeCancelHours: 48, lateCancelRefundPercent: 50 });
    const checkInAt = zonedToUtc('2026-10-20', '14:00', 'Asia/Manila'); // 06:00Z
    expect(checkInAt.toISOString()).toBe('2026-10-20T06:00:00.000Z');
    expect(refundCents(10_000, new Date('2026-10-18T06:00:00Z'), checkInAt, policy)).toBe(10_000); // exactly 48h
    expect(refundCents(10_000, new Date('2026-10-18T06:00:01Z'), checkInAt, policy)).toBe(5_000);
  });

  it('policy defaults and clamps', () => {
    expect(readPolicy(null)).toEqual({
      checkIn: '14:00',
      checkOut: '12:00',
      freeCancelHours: 48,
      lateCancelRefundPercent: 0,
      depositPercent: 100,
      requireApproval: false,
    });
  });

  it('staff transitions', () => {
    expect(canTransition('PENDING', 'CONFIRMED')).toBe(true);
    expect(canTransition('CONFIRMED', 'CHECKED_IN')).toBe(true);
    expect(canTransition('CHECKED_IN', 'CHECKED_OUT')).toBe(true);
    expect(canTransition('HOLD', 'CONFIRMED')).toBe(false); // only payment confirms a hold
    expect(canTransition('CHECKED_OUT', 'CHECKED_IN')).toBe(false);
    expect(canTransition('CANCELLED', 'CONFIRMED')).toBe(false);
    expect(readPolicy({ depositPercent: 0, checkIn: '2pm' })).toMatchObject({ depositPercent: 1, checkIn: '14:00' });
  });

  it('hotel-local today', () => {
    expect(todayIn('Asia/Manila', new Date('2026-10-10T17:00:00Z'))).toBe('2026-10-11'); // 01:00 next day in Manila
  });
});
