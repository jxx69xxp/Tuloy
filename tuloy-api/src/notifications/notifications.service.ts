import { Injectable, OnModuleDestroy, OnModuleInit } from '@nestjs/common';
import { Prisma } from '@prisma/client';
import { Locale } from '../common/i18n';
import { PrismaService } from '../common/prisma.service';
import { send } from './providers';
import { CHANNELS, Channel, DEFAULTS, render } from './templates';

const MAX_ATTEMPTS = 5;
const TICK_MS = 5_000;
const STUCK_MS = 10 * 60_000;

/**
 * Unified notifications: `notify()` writes one queued NotificationDelivery per recipient
 * (that row is also the delivery log); a worker sends them with retries and backoff.
 * ponytail: Postgres is the queue (FOR UPDATE SKIP LOCKED, safe with several API instances).
 * Move to BullMQ/Redis when volume makes polling every 5 s a problem.
 */
@Injectable()
export class NotificationsService implements OnModuleInit, OnModuleDestroy {
  private timer?: NodeJS.Timeout;
  private running = false;

  constructor(private readonly prisma: PrismaService) {}

  onModuleInit() {
    if (process.env.JOBS !== 'off') this.timer = setInterval(() => void this.tick(), TICK_MS);
  }

  onModuleDestroy() {
    clearInterval(this.timer);
  }

  /** Queue an event for a user. Channels follow CHANNELS[event], the user's prefs and their contacts. */
  async notify(
    userId: string,
    event: string,
    vars: Record<string, string>,
    opts: { hotelId?: string; only?: Channel[] } = {},
  ) {
    const user = await this.prisma.user.findUnique({ where: { id: userId }, include: { pushTokens: true } });
    if (!user) return;
    const prefs = (user.notifyPrefs ?? {}) as Partial<Record<Channel, boolean>>;
    const security = event === 'auth.otp'; // always delivered, ignores preferences
    const rows: Prisma.NotificationDeliveryCreateManyInput[] = [];
    for (const channel of CHANNELS[event] ?? []) {
      if (opts.only && !opts.only.includes(channel)) continue;
      if (!security && prefs[channel] === false) continue;
      const to =
        channel === 'push'
          ? user.pushTokens.map((t) => t.token)
          : channel === 'email'
            ? [user.email]
            : [security || user.phoneVerified ? user.phone : null]; // SMS costs money: verified numbers only
      for (const recipient of to) {
        if (recipient) {
          rows.push({
            hotelId: opts.hotelId,
            userId,
            event,
            channel,
            recipient,
            payload: { vars, locale: user.locale },
          });
        }
      }
    }
    if (rows.length) await this.prisma.notificationDelivery.createMany({ data: rows });
  }

  /** Exposed for tests: process one batch now. */
  async tick() {
    if (this.running) return;
    this.running = true;
    try {
      await this.prisma.notificationDelivery.updateMany({
        where: { status: 'sending', nextAttemptAt: { lt: new Date(Date.now() - STUCK_MS) } },
        data: { status: 'queued' },
      });
      const claimed = await this.prisma.$queryRaw<{ id: string }[]>`
        UPDATE "NotificationDelivery" SET status = 'sending', attempts = attempts + 1, "nextAttemptAt" = now()
        WHERE id IN (
          SELECT id FROM "NotificationDelivery"
          WHERE status = 'queued' AND "nextAttemptAt" <= now()
          ORDER BY "createdAt" LIMIT 20
          FOR UPDATE SKIP LOCKED)
        RETURNING id`;
      for (const { id } of claimed) await this.deliver(id);
    } catch (e) {
      console.error('[notify] tick failed', e);
    } finally {
      this.running = false;
    }
  }

  private async deliver(id: string) {
    const d = await this.prisma.notificationDelivery.findUniqueOrThrow({ where: { id } });
    const { vars, locale } = d.payload as { vars: Record<string, string>; locale: Locale };
    const custom = d.hotelId
      ? await this.prisma.notificationTemplate.findUnique({
          where: { hotelId_event_channel: { hotelId: d.hotelId, event: d.event, channel: d.channel } },
        })
      : null;
    const pick = (v: unknown) => (v as Partial<Record<Locale, string>> | null)?.[locale];
    const base = DEFAULTS[d.event];
    const title = render(pick(custom?.subject) ?? base?.title[locale] ?? base?.title.en ?? d.event, vars);
    const body = render(pick(custom?.body) ?? base?.body[locale] ?? base?.body.en ?? '', vars);

    const result = await send(d.channel as Channel, d.recipient, { title, body, data: { event: d.event, ...vars } });
    if (result.ok) {
      await this.prisma.notificationDelivery.update({
        where: { id },
        data: { status: 'sent', sentAt: new Date(), providerRef: result.ref, error: null },
      });
      return;
    }
    const giveUp = result.permanent || d.attempts >= MAX_ATTEMPTS;
    await this.prisma.notificationDelivery.update({
      where: { id },
      data: {
        status: giveUp ? 'failed' : 'queued',
        error: result.error.slice(0, 500),
        nextAttemptAt: new Date(Date.now() + 30_000 * 2 ** d.attempts), // 1, 2, 4, 8 min
      },
    });
    if (result.permanent && d.channel === 'push') {
      await this.prisma.pushToken.deleteMany({ where: { token: d.recipient } });
    }
  }
}
