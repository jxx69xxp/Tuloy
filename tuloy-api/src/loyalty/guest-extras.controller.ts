import { Body, Controller, Get, Headers, HttpCode, Param, ParseUUIDPipe, Post, Query } from '@nestjs/common';
import { IsUUID } from 'class-validator';
import { AuthUser, CurrentUser } from '../common/auth';
import { pickLocale } from '../common/i18n';
import { WifiService } from '../wifi/wifi.service';
import { LoyaltyService } from './loyalty.service';

class HotelQuery {
  @IsUUID() hotelId: string;
}
class RedeemDto {
  @IsUUID() rewardId: string;
  @IsUUID() reservationId: string;
}

/** Guest side of loyalty (L-1, L-2) and Wi-Fi (W-1). */
@Controller()
export class GuestExtrasController {
  constructor(
    private readonly loyalty: LoyaltyService,
    private readonly wifi: WifiService,
  ) {}

  @Get('me/loyalty')
  summary(@CurrentUser() u: AuthUser, @Query() q: HotelQuery, @Headers('accept-language') lang?: string) {
    return this.loyalty.summary(u.sub, q.hotelId, pickLocale(lang));
  }

  @Post('me/loyalty/redeem')
  @HttpCode(204)
  redeem(@CurrentUser() u: AuthUser, @Body() dto: RedeemDto) {
    return this.loyalty.redeem(u.sub, dto.rewardId, dto.reservationId);
  }

  @Get('reservations/:id/wifi')
  wifiAccess(@CurrentUser() u: AuthUser, @Param('id', ParseUUIDPipe) id: string) {
    return this.wifi.forGuest(u.sub, id);
  }
}
