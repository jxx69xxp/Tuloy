// Pure rules for hotel-defined services (S-1…S-4). Unit-tested in test/p3-6-domain.spec.ts.

export type PriceModel = 'FIXED' | 'PER_ITEM' | 'PER_PERSON' | 'PER_NIGHT' | 'QUOTE';
export type FieldType = 'text' | 'number' | 'select' | 'datetime' | 'location' | 'file' | 'checkbox';
export const FIELD_TYPES: FieldType[] = ['text', 'number', 'select', 'datetime', 'location', 'file', 'checkbox'];

export interface FieldDef {
  key: string;
  type: FieldType;
  label: Record<string, string>;
  required?: boolean;
  options?: { value: string; label: Record<string, string> }[];
}

export interface Schedule {
  days: number[]; // 1 = Monday … 7 = Sunday
  from: string; // "07:00"
  to: string; // "22:00"
}

export interface ServiceDraft {
  name: unknown;
  description: unknown;
  category?: string | null;
  schedule: unknown;
  priceModel?: string | null;
  basePrice?: unknown;
  currency?: string | null;
  paymentMethods: string[];
  fields: unknown;
  departmentId?: string | null;
  statusSteps: string[];
  cancellationPolicy: unknown;
  etaMin?: number | null;
}

const text = (v: unknown, locale: string) => typeof (v as Record<string, unknown>)?.[locale] === 'string' && !!(v as Record<string, string>)[locale].trim();
const TIME = /^([01]\d|2[0-3]):[0-5]\d$/;

/**
 * Everything the brief requires before a guest can order. Returns the missing/invalid field names;
 * empty = publishable. `locales` = the hotel's enabled languages (each needs a translation).
 */
export function missingForPublish(s: ServiceDraft, locales: string[]): string[] {
  const out: string[] = [];
  for (const l of locales) {
    if (!text(s.name, l)) out.push(`name.${l}`);
    if (!text(s.description, l)) out.push(`description.${l}`);
    if (!text(s.cancellationPolicy, l)) out.push(`cancellationPolicy.${l}`);
  }
  if (!s.category) out.push('category');
  const sch = s.schedule as Partial<Schedule> | null;
  if (!sch || !Array.isArray(sch.days) || !sch.days.length || !sch.days.every((d) => d >= 1 && d <= 7) || !TIME.test(sch.from ?? '') || !TIME.test(sch.to ?? '') || sch.from! >= sch.to!) {
    out.push('schedule');
  }
  if (!s.priceModel) out.push('priceModel');
  if (s.priceModel && s.priceModel !== 'QUOTE' && (s.basePrice == null || Number(s.basePrice) < 0)) out.push('basePrice');
  if (!s.currency) out.push('currency');
  if (!s.paymentMethods.length) out.push('paymentMethods');
  if (s.etaMin == null) out.push('etaMin');
  if (!s.departmentId) out.push('departmentId');
  if (s.statusSteps.length < 3 || s.statusSteps[0] !== 'requested' || s.statusSteps[s.statusSteps.length - 1] !== 'completed') {
    out.push('statusSteps');
  }
  const fields = s.fields as FieldDef[] | null;
  if (
    !Array.isArray(fields) ||
    new Set(fields.map((f) => f?.key)).size !== fields.length ||
    !fields.every((f) => /^[a-z][a-zA-Z0-9_]{0,39}$/.test(f?.key ?? '') && FIELD_TYPES.includes(f.type) && locales.every((l) => text(f.label, l)) && (f.type !== 'select' || (f.options?.length ?? 0) > 0))
  ) {
    out.push('fields');
  }
  return out;
}

/** Guest answers against the form definition. Returns the first bad key, or null. */
export function invalidAnswer(fields: FieldDef[], answers: Record<string, unknown>): string | null {
  for (const f of fields) {
    const v = answers[f.key];
    if (v == null || v === '') {
      if (f.required) return f.key;
      continue;
    }
    const ok =
      f.type === 'number' ? typeof v === 'number' && isFinite(v) && v >= 0
      : f.type === 'checkbox' ? typeof v === 'boolean'
      : f.type === 'select' ? f.options!.some((o) => o.value === v)
      : f.type === 'datetime' ? typeof v === 'string' && !isNaN(Date.parse(v))
      : typeof v === 'string' && v.length <= 2000;
    if (!ok) return f.key;
  }
  const known = new Set(fields.map((f) => f.key));
  return Object.keys(answers).find((k) => !known.has(k)) ?? null;
}

/** Centavos before tax, or null for QUOTE (staff sets it). */
export function priceService(model: PriceModel, baseCents: number, optionCents: number[], units: { quantity: number; persons: number; nights: number }): number | null {
  if (model === 'QUOTE') return null;
  const unit = baseCents + optionCents.reduce((s, c) => s + c, 0);
  const times = model === 'PER_ITEM' ? units.quantity : model === 'PER_PERSON' ? units.persons : model === 'PER_NIGHT' ? units.nights : 1;
  return unit * Math.max(1, Math.floor(times));
}

/**
 * Is `when` bookable? `local` = that instant as hotel wall-clock: weekday 1–7, "HH:mm", "YYYY-MM-DD".
 * Returns an error code or null.
 */
export function scheduleError(
  s: Schedule,
  blackout: string[],
  leadTimeMin: number,
  when: Date,
  now: Date,
  local: { weekday: number; time: string; date: string },
): string | null {
  if (when.getTime() < now.getTime() + leadTimeMin * 60_000) return 'TOO_SOON';
  if (blackout.includes(local.date)) return 'SERVICE_UNAVAILABLE';
  if (!s.days.includes(local.weekday) || local.time < s.from || local.time >= s.to) return 'OUTSIDE_HOURS';
  return null;
}

/** Wall-clock parts of an instant in a time zone. */
export function localParts(d: Date, timeZone: string) {
  const p = Object.fromEntries(
    new Intl.DateTimeFormat('en-US', { timeZone, weekday: 'short', year: 'numeric', month: '2-digit', day: '2-digit', hour: '2-digit', minute: '2-digit', hourCycle: 'h23' })
      .formatToParts(d)
      .map((x) => [x.type, x.value]),
  );
  const weekday = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'].indexOf(p.weekday) + 1;
  return { weekday, time: `${p.hour}:${p.minute}`, date: `${p.year}-${p.month}-${p.day}` };
}

/** Steps move strictly forward one at a time; 'cancelled' and 'escalated' are side exits. */
export function nextStep(steps: string[], current: string): string | null {
  const i = steps.indexOf(current);
  return i >= 0 && i < steps.length - 1 ? steps[i + 1] : null;
}
