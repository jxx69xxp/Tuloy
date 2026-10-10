import { Body, Controller, Get, Headers, HttpCode, Param, ParseUUIDPipe, Patch, Post, Put, Query } from '@nestjs/common';
import type { Membership, PaymentMethod } from '@prisma/client';
import { Type } from 'class-transformer';
import {
  ArrayMaxSize,
  IsArray,
  IsBoolean,
  IsIn,
  IsInt,
  IsISO8601,
  IsNumber,
  IsObject,
  IsOptional,
  IsString,
  IsUUID,
  Length,
  Matches,
  Max,
  Min,
  ValidateNested,
} from 'class-validator';
import { idempotencyKey } from '../booking/booking.controller';
import { AuthUser, CurrentMembership, CurrentUser, Perm, Public, Roles, STAFF } from '../common/auth';
import { pickLocale } from '../common/i18n';
import type { FieldDef, PriceModel, Schedule } from './domain';
import { ServicesService } from './services.service';

const PAYMENT_METHODS = ['ONLINE', 'ROOM_CHARGE', 'PAY_AT_OUTLET', 'FREE'] as const;

class ScheduleDto implements Schedule {
  @IsArray() @IsInt({ each: true }) @Min(1, { each: true }) @Max(7, { each: true }) days: number[];
  @Matches(/^\d{2}:\d{2}$/) from: string;
  @Matches(/^\d{2}:\d{2}$/) to: string;
}

/** Drafts may be incomplete; `publish` enforces the full checklist. */
class ServiceDto {
  @IsString() @Length(1, 40) category: string;
  @IsObject() name: Record<string, string>;
  @IsObject() description: Record<string, string>;
  @IsOptional() @IsObject() instructions?: Record<string, string>;
  @IsOptional() @IsString() imageKey?: string;
  @ValidateNested() @Type(() => ScheduleDto) schedule: ScheduleDto;
  @IsInt() @Min(0) @Max(60 * 24 * 14) leadTimeMin: number;
  @IsOptional() @IsInt() @Min(1) capacityPerSlot?: number;
  @IsOptional() @IsInt() @Min(1) etaMin?: number;
  @IsArray() @Matches(/^\d{4}-\d{2}-\d{2}$/, { each: true }) blackoutDates: string[];
  @IsIn(['FIXED', 'PER_ITEM', 'PER_PERSON', 'PER_NIGHT', 'QUOTE']) priceModel: PriceModel;
  @IsOptional() @IsNumber() @Min(0) basePrice?: number;
  @IsString() @Length(3, 3) currency: string;
  @IsBoolean() taxIncluded: boolean;
  @IsArray() @IsIn(PAYMENT_METHODS, { each: true }) paymentMethods: PaymentMethod[];
  @IsArray() @ArrayMaxSize(20) fields: FieldDef[];
  @IsOptional() @IsUUID() departmentId?: string;
  @IsIn(['AUTO', 'STAFF_APPROVAL']) acceptanceMode: 'AUTO' | 'STAFF_APPROVAL';
  @IsArray() @IsString({ each: true }) @ArrayMaxSize(10) statusSteps: string[];
  @IsObject() cancellationPolicy: Record<string, string>;
  @IsBoolean() loyaltyEarn: boolean;
  @IsBoolean() loyaltyRedeem: boolean;
}
class OptionDto {
  @IsOptional() @IsUUID() id?: string;
  @IsObject() name: Record<string, string>;
  @IsNumber() priceDelta: number;
  @IsBoolean() active: boolean;
}
class OptionsDto {
  @IsArray() @ArrayMaxSize(50) @ValidateNested({ each: true }) @Type(() => OptionDto) options: OptionDto[];
}
class RequestDto {
  @IsUUID() serviceId: string;
  @IsOptional() @IsUUID() reservationId?: string;
  @IsArray() @IsUUID('all', { each: true }) optionIds: string[];
  @IsObject() answers: Record<string, unknown>;
  @IsOptional() @IsISO8601() scheduledFor?: string;
  @IsIn(PAYMENT_METHODS) paymentMethod: PaymentMethod;
}
class ScopeQuery {
  @IsOptional() @IsIn(['mine', 'department', 'unassigned', 'all']) scope?: 'mine' | 'department' | 'unassigned' | 'all';
}
class AssignDto {
  @IsUUID() userId: string;
}
class StepDto {
  @IsString() @Length(1, 40) to: string;
}
class QuoteDto {
  @IsNumber() @Min(0) amount: number;
}
class NoteDto {
  @IsString() @Length(1, 300) note: string;
}

@Controller()
export class ServicesController {
  constructor(private readonly services: ServicesService) {}

  // ── S-1 admin builder ──

  @Roles('ADMIN')
  @Get('admin/services')
  adminList(@CurrentMembership() m: Membership) {
    return this.services.adminList(m);
  }

  @Roles('ADMIN')
  @Get('admin/services/:id')
  adminGet(@CurrentMembership() m: Membership, @Param('id', ParseUUIDPipe) id: string) {
    return this.services.adminGet(m, id);
  }

  @Roles('ADMIN')
  @Post('admin/services')
  create(@CurrentMembership() m: Membership, @Body() dto: ServiceDto) {
    return this.services.create(m, dto);
  }

  @Roles('ADMIN')
  @Patch('admin/services/:id')
  update(@CurrentMembership() m: Membership, @CurrentUser() u: AuthUser, @Param('id', ParseUUIDPipe) id: string, @Body() dto: ServiceDto) {
    return this.services.update(m, id, dto, u.sub);
  }

  @Roles('ADMIN')
  @Put('admin/services/:id/options')
  options(@CurrentMembership() m: Membership, @Param('id', ParseUUIDPipe) id: string, @Body() dto: OptionsDto) {
    return this.services.setOptions(m, id, dto.options);
  }

  @Perm('service.publish')
  @Post('admin/services/:id/publish')
  @HttpCode(204)
  publish(@CurrentMembership() m: Membership, @CurrentUser() u: AuthUser, @Param('id', ParseUUIDPipe) id: string) {
    return this.services.publish(m, id, u.sub);
  }

  @Perm('service.publish')
  @Post('admin/services/:id/pause')
  @HttpCode(204)
  pause(@CurrentMembership() m: Membership, @CurrentUser() u: AuthUser, @Param('id', ParseUUIDPipe) id: string) {
    return this.services.pause(m, id, u.sub);
  }

  // ── S-2 guest ──

  @Public()
  @Get('hotels/:hotelId/services')
  catalog(@Param('hotelId', ParseUUIDPipe) hotelId: string, @Headers('accept-language') lang?: string) {
    return this.services.catalog(hotelId, pickLocale(lang));
  }

  @Public()
  @Get('services/:id')
  one(@Param('id', ParseUUIDPipe) id: string, @Headers('accept-language') lang?: string) {
    return this.services.one(id, pickLocale(lang));
  }

  @Post('service-requests')
  request(@CurrentUser() u: AuthUser, @Body() dto: RequestDto, @Headers('idempotency-key') key?: string) {
    return this.services.request(u.sub, dto, idempotencyKey(key));
  }

  @Get('me/service-requests')
  mine(@CurrentUser() u: AuthUser, @Headers('accept-language') lang?: string) {
    return this.services.mine(u.sub, pickLocale(lang));
  }

  @Get('service-requests/:id')
  get(@CurrentUser() u: AuthUser, @Param('id', ParseUUIDPipe) id: string, @Headers('accept-language') lang?: string) {
    return this.services.get(u.sub, id, pickLocale(lang));
  }

  @Post('service-requests/:id/accept-quote')
  @HttpCode(204)
  acceptQuote(@CurrentUser() u: AuthUser, @Param('id', ParseUUIDPipe) id: string) {
    return this.services.acceptQuote(u.sub, id);
  }

  @Post('service-requests/:id/cancel')
  @HttpCode(204)
  cancel(@CurrentUser() u: AuthUser, @Param('id', ParseUUIDPipe) id: string) {
    return this.services.cancelByGuest(u.sub, id);
  }

  @Post('service-requests/:id/pay')
  @HttpCode(200)
  pay(@CurrentUser() u: AuthUser, @Param('id', ParseUUIDPipe) id: string, @Headers('idempotency-key') key?: string) {
    return this.services.pay(u.sub, id, idempotencyKey(key));
  }

  // ── S-3 staff tasks ──

  @Roles(...STAFF)
  @Get('staff/tasks')
  tasks(@CurrentMembership() m: Membership, @CurrentUser() u: AuthUser, @Query() q: ScopeQuery, @Headers('accept-language') lang?: string) {
    return this.services.tasks(m, u.sub, q.scope ?? 'all', pickLocale(lang));
  }

  @Roles(...STAFF)
  @Post('staff/tasks/:id/accept')
  @HttpCode(204)
  accept(@CurrentMembership() m: Membership, @CurrentUser() u: AuthUser, @Param('id', ParseUUIDPipe) id: string) {
    return this.services.accept(m, id, u.sub);
  }

  @Roles(...STAFF)
  @Post('staff/tasks/:id/assign')
  @HttpCode(204)
  assign(@CurrentMembership() m: Membership, @CurrentUser() u: AuthUser, @Param('id', ParseUUIDPipe) id: string, @Body() dto: AssignDto) {
    return this.services.assign(m, id, dto.userId, u.sub);
  }

  @Roles(...STAFF)
  @Post('staff/tasks/:id/step')
  @HttpCode(204)
  step(@CurrentMembership() m: Membership, @CurrentUser() u: AuthUser, @Param('id', ParseUUIDPipe) id: string, @Body() dto: StepDto) {
    return this.services.step(m, id, dto.to, u.sub);
  }

  @Roles(...STAFF)
  @Post('staff/tasks/:id/quote')
  @HttpCode(204)
  quote(@CurrentMembership() m: Membership, @CurrentUser() u: AuthUser, @Param('id', ParseUUIDPipe) id: string, @Body() dto: QuoteDto) {
    return this.services.quote(m, id, dto.amount, u.sub);
  }

  @Roles(...STAFF)
  @Post('staff/tasks/:id/escalate')
  @HttpCode(204)
  escalate(@CurrentMembership() m: Membership, @CurrentUser() u: AuthUser, @Param('id', ParseUUIDPipe) id: string, @Body() dto: NoteDto) {
    return this.services.escalate(m, id, dto.note, u.sub);
  }

  @Roles(...STAFF)
  @Post('staff/tasks/:id/cancel')
  @HttpCode(204)
  staffCancel(@CurrentMembership() m: Membership, @CurrentUser() u: AuthUser, @Param('id', ParseUUIDPipe) id: string, @Body() dto: NoteDto) {
    return this.services.cancelByStaff(m, id, dto.note, u.sub);
  }
}

