import { Body, Controller, Get, Headers, Param, ParseUUIDPipe, Patch, Query } from '@nestjs/common';
import { Prisma } from '@prisma/client';
import { IsIn, IsNumber, IsObject, IsOptional, IsString, Length, Max, Min } from 'class-validator';
import { AuthUser, CurrentUser, Public, Roles } from '../common/auth';
import { AppError } from '../common/errors';
import { LOCALES, Locale, pickLocale, t } from '../common/i18n';
import { PrismaService } from '../common/prisma.service';

class UpdateHotelDto {
  @IsOptional() @IsString() @Length(1, 120) name?: string;
  @IsOptional() @IsString() timezone?: string;
  @IsOptional() @IsString() @Length(3, 3) currency?: string;
  @IsOptional() @IsString() @Length(1, 300) address?: string;
  @IsOptional() @IsNumber() @Min(-90) @Max(90) latitude?: number;
  @IsOptional() @IsNumber() @Min(-180) @Max(180) longitude?: number;
  @IsOptional() @IsIn(LOCALES) defaultLocale?: Locale;
  @IsOptional() @IsIn(LOCALES, { each: true }) locales?: Locale[];
  @IsOptional() @IsNumber() @Min(0) @Max(1) taxRate?: number;
  @IsOptional() @IsNumber() @Min(0) @Max(1) serviceCharge?: number;
  /** { checkIn: "14:00", checkOut: "12:00", cancellation: { en, fil, ceb }, ... } */
  @IsOptional() @IsObject() policies?: Record<string, unknown>;
  /** Non-secret provider settings, e.g. { wifi: { ssid, mode, psk } }. API keys stay in env/Secrets Manager. */
  @IsOptional() @IsObject() integrations?: Record<string, unknown>;
}

@Controller()
export class HotelsController {
  constructor(private readonly prisma: PrismaService) {}

  @Public()
  @Get('hotels/:hotelId')
  async get(@Param('hotelId', ParseUUIDPipe) id: string, @Headers('accept-language') lang?: string) {
    const h = await this.prisma.hotel.findUnique({ where: { id } });
    if (!h) throw new AppError('NOT_FOUND', 404);
    const locale = pickLocale(lang);
    const policies = Object.fromEntries(
      Object.entries((h.policies ?? {}) as Record<string, unknown>).map(([k, v]) => [
        k,
        v && typeof v === 'object' ? t(v, locale, h.defaultLocale) : v,
      ]),
    );
    return {
      id: h.id,
      name: h.name,
      timezone: h.timezone,
      currency: h.currency,
      address: h.address,
      latitude: h.latitude,
      longitude: h.longitude,
      locales: h.locales,
      defaultLocale: h.defaultLocale,
      taxRate: h.taxRate,
      serviceCharge: h.serviceCharge,
      policies,
    };
  }

  /** Hotel guide, promotions. G13. */
  @Public()
  @Get('hotels/:hotelId/content')
  async content(
    @Param('hotelId', ParseUUIDPipe) hotelId: string,
    @Query('kind') kind?: string,
    @Headers('accept-language') lang?: string,
  ) {
    const h = await this.prisma.hotel.findUnique({ where: { id: hotelId } });
    if (!h) throw new AppError('NOT_FOUND', 404);
    const now = new Date();
    const items = await this.prisma.contentItem.findMany({
      where: {
        hotelId,
        kind: kind || undefined,
        publishedAt: { lte: now },
        OR: [{ expiresAt: null }, { expiresAt: { gt: now } }],
      },
      orderBy: { publishedAt: 'asc' },
    });
    const locale = pickLocale(lang);
    return items.map((i) => ({
      id: i.id,
      kind: i.kind,
      title: t(i.title, locale, h.defaultLocale),
      body: t(i.body, locale, h.defaultLocale),
      imageKey: i.imageKey,
    }));
  }

  /** Raw (untranslated) settings for the admin editor. */
  @Roles('ADMIN')
  @Get('admin/hotels/:hotelId')
  raw(@Param('hotelId', ParseUUIDPipe) id: string) {
    return this.prisma.hotel.findUniqueOrThrow({ where: { id } });
  }

  @Roles('ADMIN')
  @Patch('admin/hotels/:hotelId')
  async update(
    @Param('hotelId', ParseUUIDPipe) id: string,
    @Body() dto: UpdateHotelDto,
    @CurrentUser() u: AuthUser,
  ) {
    const before = await this.prisma.hotel.findUniqueOrThrow({ where: { id } });
    const after = await this.prisma.hotel.update({
      where: { id },
      data: {
        ...dto,
        policies: dto.policies as Prisma.InputJsonValue | undefined,
        integrations: dto.integrations as Prisma.InputJsonValue | undefined,
      },
    });
    await this.prisma.audit({ hotelId: id, actorId: u.sub, action: 'hotel.update', entityType: 'hotel', entityId: id, before, after });
    return after;
  }
}
