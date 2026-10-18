import { Body, Controller, Get, Headers, HttpCode, Param, ParseUUIDPipe, Patch, Post, Query } from '@nestjs/common';
import type { Membership } from '@prisma/client';
import { Type } from 'class-transformer';
import { IsEmail, IsIn, IsInt, IsNumber, IsOptional, IsString, IsUUID, Length, Matches, Max, MaxLength, Min, ValidateNested } from 'class-validator';
import { BookingService } from '../booking/booking.service';
import { AuthUser, CurrentMembership, CurrentUser, Perm, Roles, STAFF } from '../common/auth';
import { pickLocale } from '../common/i18n';
import { FrontDeskService, ReservationView } from './frontdesk.service';

class ListQuery {
  @IsOptional() @IsIn(['arrivals', 'departures', 'inhouse', 'pending', 'upcoming', 'all']) view?: ReservationView;
  @IsOptional() @IsString() @MaxLength(100) q?: string;
}
const DATE = /^\d{4}-\d{2}-\d{2}$/;
class DeskGuestDto {
  @IsString() @Length(1, 120) fullName: string;
  @IsOptional() @IsEmail() email?: string;
  @IsOptional() @IsString() @MaxLength(30) phone?: string;
}
class DeskBookDto {
  @IsUUID() roomId: string;
  @Matches(DATE) checkIn: string;
  @Matches(DATE) checkOut: string;
  @IsInt() @Min(1) @Max(20) adults: number;
  @IsOptional() @IsInt() @Min(0) @Max(20) children?: number;
  @IsOptional() @IsString() @MaxLength(500) specialRequests?: string;
  @ValidateNested() @Type(() => DeskGuestDto) guest: DeskGuestDto;
}
class DeskGuestPatchDto {
  @IsOptional() @IsString() @Length(1, 120) fullName?: string;
  @IsOptional() @IsString() @MaxLength(30) phone?: string;
}
class DeskChangeDto {
  @IsOptional() @Matches(DATE) checkIn?: string;
  @IsOptional() @Matches(DATE) checkOut?: string;
  @IsOptional() @IsUUID() roomId?: string;
  @IsOptional() @IsInt() @Min(1) @Max(20) adults?: number;
  @IsOptional() @IsInt() @Min(0) @Max(20) children?: number;
  @IsOptional() @IsString() @MaxLength(500) specialRequests?: string;
  @IsOptional() @ValidateNested() @Type(() => DeskGuestPatchDto) guest?: DeskGuestPatchDto;
}
class DeskPaymentDto {
  @IsNumber({ maxDecimalPlaces: 2 }) @Min(0.01) @Max(10_000_000) amount: number;
  @IsIn(['cash', 'card']) method: 'cash' | 'card';
}
class SearchQuery {
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
  constructor(
    private readonly desk: FrontDeskService,
    private readonly booking: BookingService,
  ) {}

  /** Walk-in or phone booking for a chosen room: confirmed, paid at the hotel. */
  @Post('reservations')
  book(@CurrentMembership() m: Membership, @CurrentUser() u: AuthUser, @Body() dto: DeskBookDto) {
    return this.booking.deskBook(m.hotelId, u.sub, dto);
  }

  @Patch('reservations/:id')
  @HttpCode(204)
  change(@CurrentMembership() m: Membership, @CurrentUser() u: AuthUser, @Param('id', ParseUUIDPipe) id: string, @Body() dto: DeskChangeDto) {
    return this.booking.deskChange(m.hotelId, u.sub, id, dto);
  }

  /** Cash or card taken at the desk. */
  @Post('reservations/:id/payments')
  @HttpCode(204)
  pay(@CurrentMembership() m: Membership, @CurrentUser() u: AuthUser, @Param('id', ParseUUIDPipe) id: string, @Body() dto: DeskPaymentDto) {
    return this.booking.deskPayment(m.hotelId, u.sub, id, dto.amount, dto.method);
  }

  @Get('dashboard')
  dashboard(@CurrentMembership() m: Membership, @CurrentUser() u: AuthUser) {
    return this.desk.staffDashboard(m, u.sub);
  }

  @Get('board')
  board(@CurrentMembership() m: Membership, @Headers('accept-language') lang?: string) {
    return this.desk.board(m, pickLocale(lang));
  }

  @Get('guests')
  guests(@CurrentMembership() m: Membership, @Query() q: SearchQuery) {
    return this.desk.guests(m, q.q);
  }

  @Get('team')
  team(@CurrentMembership() m: Membership) {
    return this.desk.team(m);
  }

  @Get('notifications')
  notifications(@CurrentMembership() m: Membership, @Headers('accept-language') lang?: string) {
    return this.desk.notifications(m, pickLocale(lang));
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
