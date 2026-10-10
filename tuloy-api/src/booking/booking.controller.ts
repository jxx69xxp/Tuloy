import { Body, Controller, Get, Headers, HttpCode, Param, ParseUUIDPipe, Post, Query } from '@nestjs/common';
import { AuthUser, CurrentUser, Public } from '../common/auth';
import { AppError } from '../common/errors';
import { pickLocale } from '../common/i18n';
import { BookingService } from './booking.service';
import { CancelDto, FeedbackDto, HoldDto, PayDto, StayQueryDto } from './dto';

/** Required on POSTs that create bookings or payments, so a retried request can't double-book. */
export function idempotencyKey(key?: string) {
  if (!key || !/^[A-Za-z0-9_-]{8,100}$/.test(key)) throw new AppError('IDEMPOTENCY_KEY_REQUIRED', 400);
  return key;
}

@Controller()
export class BookingController {
  constructor(private readonly booking: BookingService) {}

  @Public()
  @Get('hotels/:hotelId/availability')
  availability(
    @Param('hotelId', ParseUUIDPipe) hotelId: string,
    @Query() q: StayQueryDto,
    @Headers('accept-language') lang?: string,
  ) {
    return this.booking.availability(hotelId, q, pickLocale(lang));
  }

  @Public()
  @Get('room-types/:id')
  roomType(@Param('id', ParseUUIDPipe) id: string, @Headers('accept-language') lang?: string) {
    return this.booking.roomType(id, pickLocale(lang));
  }

  @Post('holds')
  hold(
    @CurrentUser() u: AuthUser,
    @Body() dto: HoldDto,
    @Headers('idempotency-key') key?: string,
    @Headers('accept-language') lang?: string,
  ) {
    return this.booking.hold(u.sub, dto, idempotencyKey(key), pickLocale(lang));
  }

  @Get('me/reservations')
  mine(@CurrentUser() u: AuthUser, @Headers('accept-language') lang?: string) {
    return this.booking.mine(u.sub, pickLocale(lang));
  }

  @Get('reservations/:id')
  get(@CurrentUser() u: AuthUser, @Param('id', ParseUUIDPipe) id: string, @Headers('accept-language') lang?: string) {
    return this.booking.view(id, u.sub, pickLocale(lang));
  }

  @Post('reservations/:id/pay')
  @HttpCode(200)
  pay(
    @CurrentUser() u: AuthUser,
    @Param('id', ParseUUIDPipe) id: string,
    @Body() dto: PayDto,
    @Headers('idempotency-key') key?: string,
  ) {
    return this.booking.pay(u.sub, id, dto.type, idempotencyKey(key));
  }

  @Get('reservations/:id/cancel-quote')
  cancelQuote(@CurrentUser() u: AuthUser, @Param('id', ParseUUIDPipe) id: string) {
    return this.booking.cancelQuote(u.sub, id);
  }

  @Post('reservations/:id/cancel')
  @HttpCode(200)
  cancel(
    @CurrentUser() u: AuthUser,
    @Param('id', ParseUUIDPipe) id: string,
    @Body() dto: CancelDto,
    @Headers('accept-language') lang?: string,
  ) {
    return this.booking.cancel(u.sub, id, pickLocale(lang), dto.reason);
  }

  @Get('reservations/:id/invoice')
  invoice(@CurrentUser() u: AuthUser, @Param('id', ParseUUIDPipe) id: string, @Headers('accept-language') lang?: string) {
    return this.booking.invoice(u.sub, id, pickLocale(lang));
  }

  @Post('feedback')
  @HttpCode(204)
  feedback(@CurrentUser() u: AuthUser, @Body() dto: FeedbackDto) {
    return this.booking.feedback(u.sub, dto);
  }
}
