// Pure loyalty rules (unit-tested in test/p3-6-domain.spec.ts).

export interface LoyaltyConfig {
  earnPer100: number; // points per ₱100 spent
  pointValue: number; // ₱ per point when redeemed
  maxRedeemPercent: number; // of the booking total
  tiers: { name: string; min: number }[]; // by lifetime points, ascending
}

/** From Hotel.policies.loyalty, with defaults until the hotel decides (open decision #9). */
export function readLoyalty(policies: unknown): LoyaltyConfig {
  const l = ((policies ?? {}) as { loyalty?: Partial<LoyaltyConfig> }).loyalty ?? {};
  const n = (v: unknown, d: number) => (typeof v === 'number' && v >= 0 ? v : d);
  const tiers =
    Array.isArray(l.tiers) && l.tiers.length
      ? [...l.tiers].sort((a, b) => a.min - b.min)
      : [
          { name: 'member', min: 0 },
          { name: 'silver', min: 1_000 },
          { name: 'gold', min: 5_000 },
        ];
  return {
    earnPer100: n(l.earnPer100, 1),
    pointValue: n(l.pointValue, 1),
    maxRedeemPercent: Math.min(100, n(l.maxRedeemPercent, 50)),
    tiers,
  };
}

/** Whole points only; partial ₱100 earns nothing. */
export const pointsFor = (cents: number, c: LoyaltyConfig) => Math.floor(cents / 10_000) * c.earnPer100;

export const tierFor = (lifetime: number, c: LoyaltyConfig) =>
  c.tiers.reduce((best, t) => (lifetime >= t.min ? t.name : best), c.tiers[0]?.name ?? 'member');

export function nextTier(lifetime: number, c: LoyaltyConfig) {
  const t = c.tiers.find((x) => x.min > lifetime);
  return t ? { name: t.name, pointsNeeded: t.min - lifetime } : null;
}
