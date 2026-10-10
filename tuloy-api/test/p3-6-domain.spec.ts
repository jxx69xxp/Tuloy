// Pure rules from phases 3–6 — no database needed: `npx jest test/p3-6-domain.spec.ts`
import { toCsv } from '../src/admin/reports';
import { signV4Query } from '../src/common/storage';
import { nextTier, pointsFor, readLoyalty, tierFor } from '../src/loyalty/domain';
import { FieldDef, invalidAnswer, localParts, missingForPublish, nextStep, priceService, scheduleError } from '../src/services/domain';
import { decrypt, encrypt, qrEscape } from '../src/wifi/wifi.service';

const L = (s: string) => ({ en: s, fil: s, ceb: s });

describe('services', () => {
  const complete = {
    name: L('Laundry'),
    description: L('Wash'),
    category: 'laundry',
    schedule: { days: [1, 2, 3], from: '07:00', to: '20:00' },
    priceModel: 'PER_ITEM',
    basePrice: 120,
    currency: 'PHP',
    paymentMethods: ['ROOM_CHARGE'],
    fields: [{ key: 'quantity', type: 'number', label: L('Kilos'), required: true }],
    departmentId: 'd1',
    statusSteps: ['requested', 'accepted', 'completed'],
    cancellationPolicy: L('Free before pickup'),
    etaMin: 60,
  };

  it('publish checklist', () => {
    expect(missingForPublish(complete, ['en', 'fil', 'ceb'])).toEqual([]);
    const draft = { ...complete, name: { en: 'Laundry' }, basePrice: null, paymentMethods: [], statusSteps: ['requested'], schedule: { days: [], from: '20:00', to: '07:00' } };
    expect(missingForPublish(draft, ['en', 'fil'])).toEqual(['name.fil', 'schedule', 'basePrice', 'paymentMethods', 'statusSteps']);
    expect(missingForPublish({ ...complete, priceModel: 'QUOTE', basePrice: null }, ['en'])).toEqual([]);
    expect(missingForPublish({ ...complete, fields: [{ key: 'a', type: 'select', label: L('x') }] }, ['en'])).toEqual(['fields']);
  });

  it('validates guest answers', () => {
    const fields: FieldDef[] = [
      { key: 'quantity', type: 'number', label: L('q'), required: true },
      { key: 'size', type: 'select', label: L('s'), options: [{ value: 'S', label: L('S') }] },
    ];
    expect(invalidAnswer(fields, { quantity: 3, size: 'S' })).toBeNull();
    expect(invalidAnswer(fields, {})).toBe('quantity');
    expect(invalidAnswer(fields, { quantity: -1 })).toBe('quantity');
    expect(invalidAnswer(fields, { quantity: 1, size: 'XL' })).toBe('size');
    expect(invalidAnswer(fields, { quantity: 1, hack: 1 })).toBe('hack');
  });

  it('prices by model', () => {
    const u = { quantity: 3, persons: 2, nights: 4 };
    expect(priceService('FIXED', 1000, [200], u)).toBe(1200);
    expect(priceService('PER_ITEM', 1000, [200], u)).toBe(3600);
    expect(priceService('PER_PERSON', 1000, [], u)).toBe(2000);
    expect(priceService('PER_NIGHT', 1000, [], u)).toBe(4000);
    expect(priceService('QUOTE', 1000, [], u)).toBeNull();
    expect(priceService('PER_ITEM', 1000, [], { ...u, quantity: 0 })).toBe(1000); // at least one
  });

  it('schedule, lead time, blackout', () => {
    const s = { days: [1, 2, 3, 4, 5], from: '07:00', to: '20:00' };
    const now = new Date('2026-10-12T00:00:00Z'); // Mon 08:00 Manila
    const at = (iso: string) => {
      const d = new Date(iso);
      return scheduleError(s, ['2026-10-14'], 60, d, now, localParts(d, 'Asia/Manila'));
    };
    expect(at('2026-10-12T02:00:00Z')).toBeNull(); // Mon 10:00
    expect(at('2026-10-12T00:30:00Z')).toBe('TOO_SOON'); // within lead time
    expect(at('2026-10-12T12:00:00Z')).toBe('OUTSIDE_HOURS'); // Mon 20:00 (end exclusive)
    expect(at('2026-10-17T02:00:00Z')).toBe('OUTSIDE_HOURS'); // Saturday
    expect(at('2026-10-14T02:00:00Z')).toBe('SERVICE_UNAVAILABLE'); // blackout
  });

  it('steps go forward one at a time', () => {
    const steps = ['requested', 'accepted', 'picked_up', 'completed'];
    expect(nextStep(steps, 'accepted')).toBe('picked_up');
    expect(nextStep(steps, 'completed')).toBeNull();
    expect(nextStep(steps, 'cancelled')).toBeNull();
  });
});

describe('loyalty', () => {
  const cfg = readLoyalty({ loyalty: { earnPer100: 2 } });
  it('earns whole points per ₱100', () => {
    expect(pointsFor(19_999, cfg)).toBe(2); // ₱199.99 → 1 × 2
    expect(pointsFor(9_999, cfg)).toBe(0);
  });
  it('tiers by lifetime points', () => {
    expect(tierFor(0, cfg)).toBe('member');
    expect(tierFor(1_000, cfg)).toBe('silver');
    expect(tierFor(99_999, cfg)).toBe('gold');
    expect(nextTier(400, cfg)).toEqual({ name: 'silver', pointsNeeded: 600 });
    expect(nextTier(6_000, cfg)).toBeNull();
  });
});

describe('storage', () => {
  it('SigV4 query signing matches the AWS documentation example', () => {
    const qs = signV4Query({
      method: 'GET',
      host: 'examplebucket.s3.amazonaws.com',
      path: '/test.txt',
      region: 'us-east-1',
      accessKey: 'AKIAIOSFODNN7EXAMPLE',
      secretKey: 'wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY',
      expires: 86400,
      now: new Date('2013-05-24T00:00:00Z'),
    });
    expect(qs).toContain('X-Amz-Signature=aeeed9bbccd4d02ee5c0109b86d86835f995330da4c265957d157751f604d404');
  });
});

describe('misc', () => {
  it('CSV escapes quotes, commas and newlines', () => {
    expect(toCsv([{ a: 'x', b: 'say "hi", ok' }, { a: 'line\nbreak', b: 2 }])).toBe('a,b\r\nx,"say ""hi"", ok"\r\n"line\nbreak",2\r\n');
  });
  it('Wi-Fi QR escaping and secret round trip', () => {
    expect(qrEscape('My;Net:"1"')).toBe('My\\;Net\\:\\"1\\"');
    process.env.JWT_SECRET = 'x';
    const blob = encrypt('s3cret');
    expect(blob).not.toContain('s3cret');
    expect(decrypt(blob)).toBe('s3cret');
  });
});
