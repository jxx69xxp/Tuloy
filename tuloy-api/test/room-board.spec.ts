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
