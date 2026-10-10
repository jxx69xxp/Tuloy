import { Injectable } from '@nestjs/common';
import { Prisma } from '@prisma/client';
import { randomUUID } from 'node:crypto';
import { AppError } from '../common/errors';
import { Locale, t } from '../common/i18n';
import { PrismaService } from '../common/prisma.service';
import { nextTier, pointsFor, readLoyalty, tierFor } from './domain';

const isUnique = (e: unknown) => e instanceof Prisma.PrismaClientKnownRequestError && e.code === 'P2002';

/**
 * Points ledger. Every change is an immutable LoyaltyTransaction; the account balance is a cache
 * updated in the same transaction. Unique (kind, sourceType, sourceId) stops double earning.
 */
@Injectable()
export class LoyaltyService {
  constructor(private readonly prisma: PrismaService) {}

  private async account(userId: string, hotelId: string) {
    await this.prisma.loyaltyAccount.createMany({ data: [{ userId, hotelId }], skipDuplicates: true });
    return this.prisma.loyaltyAccount.findUniqueOrThrow({ where: { userId_hotelId: { userId, hotelId } } });
  }

  /** Earn for a completed stay or paid service. Calling twice for the same source is a no-op. */
  async earn(userId: string, hotelId: string, cents: number, sourceType: string, sourceId: string) {
    const hotel = await this.prisma.hotel.findUniqueOrThrow({ where: { id: hotelId } });
    const cfg = readLoyalty(hotel.policies);
    const points = pointsFor(cents, cfg);
    if (points <= 0) return 0;
    const acc = await this.account(userId, hotelId);
    try {
      await this.prisma.$transaction([
        this.prisma.loyaltyTransaction.create({ data: { accountId: acc.id, points, kind: 'earn', sourceType, sourceId } }),
        this.prisma.loyaltyAccount.update({
          where: { id: acc.id },
          data: { balance: { increment: points }, lifetime: { increment: points }, tier: tierFor(acc.lifetime + points, cfg) },
        }),
      ]);
      return points;
    } catch (e) {
      if (isUnique(e)) return 0;
      throw e;
    }
  }

  /** Undo what a source earned (refunds). No-op if nothing was earned or already reversed. */
  async reverse(sourceType: string, sourceId: string) {
    const earned = await this.prisma.loyaltyTransaction.findUnique({
      where: { kind_sourceType_sourceId: { kind: 'earn', sourceType, sourceId } },
    });
    if (!earned) return;
    try {
      await this.prisma.$transaction([
        this.prisma.loyaltyTransaction.create({
          data: { accountId: earned.accountId, points: -earned.points, kind: 'reverse', sourceType, sourceId },
        }),
        this.prisma.loyaltyAccount.update({
          where: { id: earned.accountId },
          data: { balance: { decrement: earned.points }, lifetime: { decrement: earned.points } },
        }),
      ]);
    } catch (e) {
      if (!isUnique(e)) throw e;
    }
  }

  /** Spend points as a discount line on a confirmed/in-house booking. */
  async redeem(userId: string, rewardId: string, reservationId: string) {
    const reward = await this.prisma.loyaltyReward.findUnique({ where: { id: rewardId } });
    const r = await this.prisma.reservation.findUnique({ where: { id: reservationId } });
    if (!reward?.active || !r || r.guestId !== userId || r.hotelId !== reward.hotelId) throw new AppError('NOT_FOUND', 404);
    if (r.status !== 'CONFIRMED' && r.status !== 'CHECKED_IN') throw new AppError('CANNOT_REDEEM', 409);
    const hotel = await this.prisma.hotel.findUniqueOrThrow({ where: { id: r.hotelId } });
    const cfg = readLoyalty(hotel.policies);
    const lines = await this.prisma.invoiceLine.findMany({ where: { reservationId, kind: 'loyalty_redemption' } });
    const already = -lines.reduce((s, l) => s + Math.round(Number(l.amount) * 100), 0);
    const valueCents = Math.round(Number(reward.value) * 100);
    if (already + valueCents > Math.round((Number(r.total) * 100 * cfg.maxRedeemPercent) / 100)) {
      throw new AppError('REDEEM_LIMIT', 409);
    }
    const acc = await this.account(userId, r.hotelId);
    const id = randomUUID();
    await this.prisma.$transaction(async (tx) => {
      const taken = await tx.loyaltyAccount.updateMany({
        where: { id: acc.id, balance: { gte: reward.points } },
        data: { balance: { decrement: reward.points } },
      });
      if (!taken.count) throw new AppError('INSUFFICIENT_POINTS', 409);
      await tx.loyaltyTransaction.create({
        data: { accountId: acc.id, points: -reward.points, kind: 'redeem', sourceType: 'redemption', sourceId: id, reason: rewardId },
      });
      await tx.invoiceLine.create({
        data: {
          hotelId: r.hotelId,
          reservationId,
          kind: 'loyalty_redemption',
          description: reward.name as Prisma.InputJsonValue,
          amount: (-valueCents / 100).toFixed(2),
          sourceId: id,
        },
      });
    });
  }

  /** Admin correction. Reason is required and audited. */
  async adjust(accountId: string, hotelId: string, points: number, reason: string, byUserId: string) {
    const acc = await this.prisma.loyaltyAccount.findUnique({ where: { id: accountId } });
    if (!acc || acc.hotelId !== hotelId) throw new AppError('NOT_FOUND', 404);
    const hotel = await this.prisma.hotel.findUniqueOrThrow({ where: { id: hotelId } });
    const lifetime = Math.max(0, acc.lifetime + Math.max(0, points));
    await this.prisma.$transaction([
      this.prisma.loyaltyTransaction.create({
        data: { accountId, points, kind: 'adjust', sourceType: 'adjust', sourceId: randomUUID(), byUserId, reason },
      }),
      this.prisma.loyaltyAccount.update({
        where: { id: accountId },
        data: { balance: { increment: points }, lifetime, tier: tierFor(lifetime, readLoyalty(hotel.policies)) },
      }),
    ]);
    await this.prisma.audit({ hotelId, actorId: byUserId, action: 'loyalty.adjust', entityType: 'loyaltyAccount', entityId: accountId, after: { points, reason } });
  }

  async summary(userId: string, hotelId: string, locale: Locale) {
    const hotel = await this.prisma.hotel.findUniqueOrThrow({ where: { id: hotelId } });
    const cfg = readLoyalty(hotel.policies);
    const acc = await this.account(userId, hotelId);
    const [txns, rewards] = await Promise.all([
      this.prisma.loyaltyTransaction.findMany({ where: { accountId: acc.id }, orderBy: { createdAt: 'desc' }, take: 50 }),
      this.prisma.loyaltyReward.findMany({ where: { hotelId, active: true }, orderBy: { points: 'asc' } }),
    ]);
    return {
      balance: acc.balance,
      lifetime: acc.lifetime,
      tier: tierFor(acc.lifetime, cfg),
      next: nextTier(acc.lifetime, cfg),
      earnPer100: cfg.earnPer100,
      history: txns.map((x) => ({ points: x.points, kind: x.kind, createdAt: x.createdAt })),
      rewards: rewards.map((w) => ({ id: w.id, name: t(w.name, locale, hotel.defaultLocale), points: w.points, value: w.value })),
    };
  }
}
