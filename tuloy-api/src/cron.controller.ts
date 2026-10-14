import { Controller, Get, Headers } from '@nestjs/common';
import { timingSafeEqual } from 'node:crypto';
import { BookingService } from './booking/booking.service';
import { Public } from './common/auth';
import { AppError } from './common/errors';
import { NotificationsService } from './notifications/notifications.service';

/**
 * Background work for serverless hosting, where in-process timers do not run (JOBS=inline):
 * Vercel Cron, or any external pinger, calls this with `Authorization: Bearer $CRON_SECRET`.
 */
@Public()
@Controller('internal')
export class CronController {
  constructor(
    private readonly booking: BookingService,
    private readonly notifications: NotificationsService,
  ) {}

  @Get('cron')
  async run(@Headers('authorization') auth = '') {
    const secret = process.env.CRON_SECRET;
    const want = Buffer.from(`Bearer ${secret}`);
    const got = Buffer.from(auth);
    if (!secret || got.length !== want.length || !timingSafeEqual(got, want)) throw new AppError('UNAUTHENTICATED', 401);
    await this.booking.expireHolds();
    await this.notifications.tick();
    return { ok: true };
  }
}
