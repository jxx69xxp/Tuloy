import { Body, Controller, Get, Headers, HttpCode, Param, ParseUUIDPipe, Patch, Post, Query } from '@nestjs/common';
import type { Membership } from '@prisma/client';
import { IsIn, IsOptional, IsString, MaxLength } from 'class-validator';
import { AuthUser, CurrentMembership, CurrentUser, Perm, Roles, STAFF } from '../common/auth';
import { pickLocale } from '../common/i18n';
import { FrontDeskService, ReservationView } from './frontdesk.service';

class ListQuery {
  @IsOptional() @IsIn(['arrivals', 'departures', 'inhouse', 'pending', 'upcoming', 'all']) view?: ReservationView;
  @IsOptional() @IsString() @MaxLength(100) q?: string;
}
class NoteDto {
  @IsOptional() @IsString() @MaxLength(300) reason?: string;
}
class NotesDto {
  @IsString() @MaxLength(4000) internalNotes: string;
}

/** Staff app. Hotel comes from the x-hotel-id header; ADMIN can do everything STAFF can. */
@Roles(...STAFF)
@Controller('staff')
export class FrontDeskController {
  constructor(private readonly desk: FrontDeskService) {}

  @Get('dashboard')
  dashboard(@CurrentMembership() m: Membership, @CurrentUser() u: AuthUser) {
    return this.desk.staffDashboard(m, u.sub);
  }

  @Get('reservations')
  list(@CurrentMembership() m: Membership, @Query() q: ListQuery, @Headers('accept-language') lang?: string) {
    return this.desk.list(m, q.view, q.q, pickLocale(lang));
  }

  @Get('reservations/:id')
  detail(
    @CurrentMembership() m: Membership,
    @CurrentUser() u: AuthUser,
    @Param('id', ParseUUIDPipe) id: string,
    @Headers('accept-language') lang?: string,
  ) {
    return this.desk.detail(m, id, u.sub, pickLocale(lang));
  }

  @Patch('reservations/:id/notes')
  @HttpCode(204)
  notes(@CurrentMembership() m: Membership, @Param('id', ParseUUIDPipe) id: string, @Body() dto: NotesDto) {
    return this.desk.notes(m, id, dto.internalNotes);
  }

  @Perm('booking.approve')
  @Post('reservations/:id/approve')
  @HttpCode(204)
  approve(@CurrentMembership() m: Membership, @CurrentUser() u: AuthUser, @Param('id', ParseUUIDPipe) id: string) {
    return this.desk.approve(m, id, u.sub);
  }

  @Perm('booking.approve')
  @Post('reservations/:id/decline')
  @HttpCode(204)
  decline(@CurrentMembership() m: Membership, @CurrentUser() u: AuthUser, @Param('id', ParseUUIDPipe) id: string, @Body() dto: NoteDto) {
    return this.desk.decline(m, id, u.sub, dto.reason);
  }

  @Post('reservations/:id/check-in')
  @HttpCode(204)
  checkIn(@CurrentMembership() m: Membership, @CurrentUser() u: AuthUser, @Param('id', ParseUUIDPipe) id: string) {
    return this.desk.checkIn(m, id, u.sub);
  }

  @Post('reservations/:id/check-out')
  @HttpCode(204)
  checkOut(@CurrentMembership() m: Membership, @CurrentUser() u: AuthUser, @Param('id', ParseUUIDPipe) id: string) {
    return this.desk.checkOut(m, id, u.sub);
  }

  @Post('reservations/:id/no-show')
  @HttpCode(204)
  noShow(@CurrentMembership() m: Membership, @CurrentUser() u: AuthUser, @Param('id', ParseUUIDPipe) id: string) {
    return this.desk.noShow(m, id, u.sub);
  }

  @Post('reservations/:id/wifi')
  @HttpCode(204)
  wifi(@CurrentMembership() m: Membership, @Param('id', ParseUUIDPipe) id: string) {
    return this.desk.reissueWifi(m, id);
  }
}
