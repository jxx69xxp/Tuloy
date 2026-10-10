// Pure booking rules. No Nest, no Prisma: unit-tested in test/booking-domain.spec.ts.
// Money is integer centavos everywhere in here.

export const DAY_MS = 86_400_000;
export const MAX_NIGHTS = 30;

export const toCents = (v: { toString(): string } | number | string) => Math.round(Number(v.toString()) * 100);
export const fromCents = (c: number) => (c / 100).toFixed(2);
export const isoDate = (d: Date) => d.toISOString().slice(0, 10);

/** Hotel policy fields read from Hotel.policies, with defaults until the hotel decides (open decision #3). */
export interface StayPolicy {
  checkIn: string; // "14:00", hotel local time
  checkOut: string;
  freeCancelHours: number;
  lateCancelRefundPercent: number;
  depositPercent: number; // 100 = pay in full to confirm
  requireApproval: boolean; // staff confirm each paid booking (open decision #2)
}

export function readPolicy(policies: unknown): StayPolicy {
  const p = (policies ?? {}) as Partial<Record<keyof StayPolicy, unknown>>;
  const num = (v: unknown, d: number) => (typeof v === 'number' && v >= 0 ? v : d);
  const time = (v: unknown, d: string) => (typeof v === 'string' && /^\d{2}:\d{2}$/.test(v) ? v : d);
  return {
    checkIn: time(p.checkIn, '14:00'),
    checkOut: time(p.checkOut, '12:00'),
    freeCancelHours: num(p.freeCancelHours, 48),
    lateCancelRefundPercent: Math.min(100, num(p.lateCancelRefundPercent, 0)),
    depositPercent: Math.min(100, Math.max(1, num(p.depositPercent, 100))),
    requireApproval: p.requireApproval === true,
  };
}

/** Each night of [checkIn, checkOut) as 'YYYY-MM-DD'. */
export function nightsOf(checkIn: string, checkOut: string): string[] {
  const out: string[] = [];
  const end = Date.parse(`${checkOut}T00:00:00Z`);
  for (let d = Date.parse(`${checkIn}T00:00:00Z`); d < end; d += DAY_MS) out.push(isoDate(new Date(d)));
  return out;
}

/** Error code, or null when the stay is bookable. `today` is the hotel's local date. */
export function validateStay(checkIn: string, checkOut: string, today: string): string | null {
  const re = /^\d{4}-\d{2}-\d{2}$/;
  if (!re.test(checkIn) || !re.test(checkOut) || isNaN(Date.parse(checkIn)) || isNaN(Date.parse(checkOut))) {
    return 'INVALID_DATES';
  }
  if (checkIn < today || checkOut <= checkIn) return 'INVALID_DATES';
  if (nightsOf(checkIn, checkOut).length > MAX_NIGHTS) return 'STAY_TOO_LONG';
  return null;
}

export interface StayPrice {
  nights: { date: string; cents: number }[];
  subtotal: number;
  serviceCharge: number;
  tax: number;
  total: number;
}

/**
 * Service charge on the room subtotal; tax (VAT) on subtotal + service charge.
 * A hotel quoting tax-inclusive rates sets taxRate to 0.
 */
export function priceStay(nights: { date: string; cents: number }[], serviceChargeRate: number, taxRate: number): StayPrice {
  const subtotal = nights.reduce((s, n) => s + n.cents, 0);
  const serviceCharge = Math.round(subtotal * serviceChargeRate);
  const tax = Math.round((subtotal + serviceCharge) * taxRate);
  return { nights, subtotal, serviceCharge, tax, total: subtotal + serviceCharge + tax };
}

export const depositCents = (total: number, percent: number) => Math.min(total, Math.round((total * percent) / 100));

/** Full refund up to `freeCancelHours` before check-in time; after that, `lateCancelRefundPercent` of what was paid. */
export function refundCents(paid: number, now: Date, checkInAt: Date, policy: StayPolicy): number {
  const freeUntil = checkInAt.getTime() - policy.freeCancelHours * 3_600_000;
  return now.getTime() <= freeUntil ? paid : Math.round((paid * policy.lateCancelRefundPercent) / 100);
}

/** Wall-clock time in a time zone → UTC instant. Uses only Intl (no tz library). */
export function zonedToUtc(date: string, time: string, timeZone: string): Date {
  const guess = new Date(`${date}T${time}:00Z`);
  const parts = Object.fromEntries(
    new Intl.DateTimeFormat('en-US', {
      timeZone,
      hourCycle: 'h23',
      year: 'numeric',
      month: '2-digit',
      day: '2-digit',
      hour: '2-digit',
      minute: '2-digit',
      second: '2-digit',
    })
      .formatToParts(guess)
      .map((p) => [p.type, p.value]),
  );
  const shown = Date.UTC(+parts.year, +parts.month - 1, +parts.day, +parts.hour, +parts.minute, +parts.second);
  return new Date(guess.getTime() - (shown - guess.getTime()));
}

/** The hotel's local calendar date, 'YYYY-MM-DD'. */
export const todayIn = (timeZone: string, now = new Date()) => new Intl.DateTimeFormat('en-CA', { timeZone }).format(now);

/** Which status changes staff may make. Payment and expiry moves are not here: the system makes those. */
const TRANSITIONS: Record<string, string[]> = {
  PENDING: ['CONFIRMED', 'DECLINED', 'CANCELLED'],
  CONFIRMED: ['CHECKED_IN', 'NO_SHOW', 'CANCELLED'],
  CHECKED_IN: ['CHECKED_OUT'],
};
export const canTransition = (from: string, to: string) => TRANSITIONS[from]?.includes(to) ?? false;

/** Guest-facing booking code, e.g. TL-7KQ2M9XA. Alphabet skips 0/O/1/I. */
export function bookingCode(random: (n: number) => number): string {
  const abc = '23456789ABCDEFGHJKLMNPQRSTUVWXYZ';
  return 'TL-' + Array.from({ length: 8 }, () => abc[random(abc.length)]).join('');
}
