import { Body, Controller, Delete, Get, HttpCode, Param, ParseUUIDPipe, Patch, Post, Put, Query } from '@nestjs/common';
import type { Membership, Prisma } from '@prisma/client';
import { Type } from 'class-transformer';
import {
  ArrayMaxSize,
  IsArray,
  IsBoolean,
  IsIn,
  IsInt,
  IsNumber,
  IsObject,
  IsOptional,
  IsString,
  IsUUID,
  Length,
  Matches,
  Max,
  MaxLength,
  Min,
  ValidateNested,
} from 'class-validator';
import { isUnique } from '../booking/booking.service';
import { isoDate, nightsOf } from '../booking/domain';
import { AuthUser, CurrentMembership, CurrentUser, Roles, sameHotel } from '../common/auth';
import { AppError } from '../common/errors';
import { PrismaService } from '../common/prisma.service';
import { assetUrl, presignUpload } from '../common/storage';

const DATE = /^\d{4}-\d{2}-\d{2}$/;
const day = (d: string) => new Date(`${d}T00:00:00Z`);

class RoomTypeDto {
  @IsObject() name: Record<string, string>;
  @IsObject() description: Record<string, string>;
  @IsInt() @Min(1) @Max(20) maxGuests: number;
  @IsNumber() @Min(0) basePrice: number;
  @IsArray() @IsString({ each: true }) @ArrayMaxSize(40) amenities: string[];
  @IsArray() @IsString({ each: true }) @ArrayMaxSize(20) photos: string[];
  @IsOptional() @IsBoolean() active?: boolean;
}
class RoomDto {
  @IsUUID() roomTypeId: string;
  @IsString() @Length(1, 20) number: string;
  @IsOptional() @IsString() @MaxLength(20) floor?: string;
  @IsOptional() @IsBoolean() active?: boolean;
}
class RangeQuery {
  @Matches(DATE) from: string;
  @Matches(DATE) to: string;
}
class RateDto {
  @Matches(DATE) date: string;
  /** null removes the override (back to base price). */
  @IsOptional() @IsNumber() @Min(0) price: number | null;
}
class RatesDto {
  @IsArray() @ArrayMaxSize(400) @ValidateNested({ each: true }) @Type(() => RateDto) rates: RateDto[];
}
class BlockDto extends RangeQuery {
  @IsUUID() roomId: string;
  @IsOptional() @IsString() @MaxLength(200) note?: string;
}
class UploadDto {
  @IsIn(['rooms', 'services', 'menu', 'content']) folder: string;
  @IsIn(['jpg', 'jpeg', 'png', 'webp']) ext: string;
}

/** Rooms, rates, inventory blocks and photo uploads (A-1, A-2). Admin only. */
@Roles('ADMIN')
@Controller('admin')
export class RoomsController {
  constructor(private readonly prisma: PrismaService) {}

  @Get('room-types')
  async roomTypes(@CurrentMembership() m: Membership) {
    const types = await this.prisma.roomType.findMany({
      where: { hotelId: m.hotelId },
      include: { rooms: { orderBy: { number: 'asc' } } },
      orderBy: { basePrice: 'asc' },
    });
    return types.map((t) => ({ ...t, photoUrls: t.photos.map(assetUrl) }));
  }

  @Post('room-types')
  createType(@CurrentMembership() m: Membership, @Body() dto: RoomTypeDto) {
    return this.prisma.roomType.create({ data: { ...dto, hotelId: m.hotelId } });
  }

  @Patch('room-types/:id')
  async updateType(@CurrentMembership() m: Membership, @Param('id', ParseUUIDPipe) id: string, @Body() dto: RoomTypeDto) {
    sameHotel(await this.prisma.roomType.findUnique({ where: { id } }), m);
    return this.prisma.roomType.update({ where: { id }, data: dto });
  }

  @Post('rooms')
  async createRoom(@CurrentMembership() m: Membership, @Body() dto: RoomDto) {
    sameHotel(await this.prisma.roomType.findUnique({ where: { id: dto.roomTypeId } }), m);
    try {
      return await this.prisma.room.create({ data: { ...dto, hotelId: m.hotelId } });
    } catch (e) {
      if (isUnique(e)) throw new AppError('ROOM_NUMBER_TAKEN', 409);
      throw e;
    }
  }

  @Patch('rooms/:id')
  async updateRoom(@CurrentMembership() m: Membership, @Param('id', ParseUUIDPipe) id: string, @Body() dto: RoomDto) {
    sameHotel(await this.prisma.room.findUnique({ where: { id } }), m);
    sameHotel(await this.prisma.roomType.findUnique({ where: { id: dto.roomTypeId } }), m);
    try {
      return await this.prisma.room.update({ where: { id }, data: dto });
    } catch (e) {
      if (isUnique(e)) throw new AppError('ROOM_NUMBER_TAKEN', 409);
      throw e;
    }
  }

  // ── A-2: per-date rates ──

  @Get('room-types/:id/rates')
  async rates(@CurrentMembership() m: Membership, @Param('id', ParseUUIDPipe) id: string, @Query() q: RangeQuery) {
    const rt = sameHotel(await this.prisma.roomType.findUnique({ where: { id } }), m);
    const rows = await this.prisma.roomRate.findMany({ where: { roomTypeId: id, date: { gte: day(q.from), lt: day(q.to) } } });
    const byDate = new Map(rows.map((r) => [isoDate(r.date), r.price]));
    return nightsOf(q.from, q.to).slice(0, 400).map((date) => ({ date, price: byDate.get(date) ?? rt.basePrice, override: byDate.has(date) }));
  }

  @Put('room-types/:id/rates')
  @HttpCode(204)
  async setRates(@CurrentMembership() m: Membership, @CurrentUser() u: AuthUser, @Param('id', ParseUUIDPipe) id: string, @Body() dto: RatesDto) {
    sameHotel(await this.prisma.roomType.findUnique({ where: { id } }), m);
    await this.prisma.$transaction(
      dto.rates.map((r) =>
        r.price == null
          ? this.prisma.roomRate.deleteMany({ where: { roomTypeId: id, date: day(r.date) } })
          : this.prisma.roomRate.upsert({
              where: { roomTypeId_date: { roomTypeId: id, date: day(r.date) } },
              create: { roomTypeId: id, date: day(r.date), price: r.price },
              update: { price: r.price },
            }),
      ),
    );
    await this.prisma.audit({ hotelId: m.hotelId, actorId: u.sub, action: 'rates.set', entityType: 'roomType', entityId: id, after: dto.rates as unknown as Prisma.InputJsonValue });
  }

  // ── A-2: inventory blocks (maintenance, owner use) ──

  @Get('blocks')
  async blocks(@CurrentMembership() m: Membership, @Query() q: RangeQuery) {
    const rows = await this.prisma.roomNight.findMany({
      where: { hotelId: m.hotelId, kind: 'BLOCKED', date: { gte: day(q.from), lt: day(q.to) } },
      include: { room: { select: { number: true } } },
      orderBy: [{ date: 'asc' }],
    });
    return rows.map((r) => ({ roomId: r.roomId, room: r.room.number, date: isoDate(r.date), note: r.note }));
  }

  /** Blocks every night in [from, to). Fails with ROOM_UNAVAILABLE if any night is already sold or held. */
  @Post('blocks')
  @HttpCode(204)
  async block(@CurrentMembership() m: Membership, @CurrentUser() u: AuthUser, @Body() dto: BlockDto) {
    sameHotel(await this.prisma.room.findUnique({ where: { id: dto.roomId } }), m);
    const nights = nightsOf(dto.from, dto.to);
    if (!nights.length || nights.length > 366) throw new AppError('INVALID_DATES', 400);
    await this.prisma.roomNight.deleteMany({
      where: { roomId: dto.roomId, kind: 'HOLD', holdExpiresAt: { lte: new Date() }, date: { gte: day(dto.from), lt: day(dto.to) } },
    });
    try {
      await this.prisma.roomNight.createMany({
        data: nights.map((d) => ({ roomId: dto.roomId, date: day(d), hotelId: m.hotelId, kind: 'BLOCKED' as const, note: dto.note })),
      });
    } catch (e) {
      if (isUnique(e)) throw new AppError('ROOM_UNAVAILABLE', 409);
      throw e;
    }
    await this.prisma.audit({ hotelId: m.hotelId, actorId: u.sub, action: 'room.block', entityType: 'room', entityId: dto.roomId, after: { ...dto } });
  }

  @Delete('blocks')
  @HttpCode(204)
  async unblock(@CurrentMembership() m: Membership, @CurrentUser() u: AuthUser, @Body() dto: BlockDto) {
    sameHotel(await this.prisma.room.findUnique({ where: { id: dto.roomId } }), m);
    await this.prisma.roomNight.deleteMany({ where: { roomId: dto.roomId, kind: 'BLOCKED', date: { gte: day(dto.from), lt: day(dto.to) } } });
    await this.prisma.audit({ hotelId: m.hotelId, actorId: u.sub, action: 'room.unblock', entityType: 'room', entityId: dto.roomId, after: { ...dto } });
  }

  // ── uploads ──

  /** Presigned PUT: the app uploads the file straight to storage, then saves `key` on the entity. */
  @Post('uploads')
  upload(@Body() dto: UploadDto) {
    return presignUpload(dto.folder, dto.ext);
  }
}
