import type { Payment } from '@prisma/client';
import { paymentState } from '../src/booking/booking.service';
import { roomStatus } from '../src/frontdesk/frontdesk.service';

describe('roomStatus', () => {
  it('ranks blocked, occupied, departing, arriving, reserved, free', () => {
    expect(roomStatus('BLOCKED', undefined, false, true)).toBe('blocked');
    expect(roomStatus('BOOKED', 'CHECKED_IN', false, true)).toBe('occupied');
    expect(roomStatus('BOOKED', 'CONFIRMED', true, true)).toBe('departing');
    expect(roomStatus('BOOKED', 'CONFIRMED', true)).toBe('arriving');
    expect(roomStatus('BOOKED', 'CONFIRMED', false)).toBe('reserved');
    expect(roomStatus('HOLD', 'HOLD', true)).toBe('reserved');
    expect(roomStatus(undefined, undefined, false, true)).toBe('departing');
    expect(roomStatus()).toBe('free');
  });
});

describe('paymentState', () => {
  const pay = (amount: number, kind = 'FULL', status = 'SUCCEEDED', refunded = 0) =>
    ({ amount, kind, status, refundedAmount: refunded }) as unknown as Payment;
  it('reads unpaid, deposit, partial and paid from what actually came in', () => {
    expect(paymentState([], 100_000)).toBe('unpaid');
    expect(paymentState([pay(300, 'DEPOSIT', 'PENDING')], 100_000)).toBe('unpaid'); // checkout opened, not paid
    expect(paymentState([pay(300, 'DEPOSIT')], 100_000)).toBe('deposit');
    expect(paymentState([pay(400, 'BALANCE')], 100_000)).toBe('partial');
    expect(paymentState([pay(300, 'DEPOSIT'), pay(700, 'BALANCE')], 100_000)).toBe('paid');
    expect(paymentState([pay(1000, 'FULL', 'PARTIALLY_REFUNDED', 500)], 100_000)).toBe('partial');
  });
});
