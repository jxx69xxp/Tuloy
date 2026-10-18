import { Body, Controller, Get, Headers, HttpCode, Injectable, Param, ParseUUIDPipe, Patch, Post, Query } from '@nestjs/common';
import type { Membership, Prisma } from '@prisma/client';
import { Type } from 'class-transformer';
import { ArrayMaxSize, ArrayMinSize, IsArray, IsBoolean, IsIn, IsInt, IsNumber, IsObject, IsOptional, IsString, IsUUID, Length, Max, MaxLength, Min, ValidateNested } from 'class-validator';
import { randomBytes } from 'node:crypto';
import { idempotencyKey } from '../booking/booking.controller';
import { isUnique } from '../booking/booking.service';
import { fromCents, priceStay, toCents } from '../booking/domain';
import { sha256 } from '../auth/password';
import { AuthUser, CurrentMembership, CurrentUser, Public, RESTAURANT, Roles, sameHotel } from '../common/auth';
import { AppError } from '../common/errors';
import { Locale, pickLocale, t } from '../common/i18n';
import { PrismaService } from '../common/prisma.service';
import { assetUrl } from '../common/storage';
import { NotificationsService } from '../notifications/notifications.service';

const ORDER_STEPS = ['submitted', 'accepted', 'preparing', 'served'];

class OutletDto {
  @IsObject() name: Record<string, string>;
  @IsObject() schedule: Record<string, unknown>;
  @IsOptional() @IsString() posRef?: string;
}
class TableDto {
  @IsString() @Length(1, 20) label: string;
  @IsOptional() @IsBoolean() active?: boolean;
}
class MenuItemDto {
  @IsObject() category: Record<string, string>;
  @IsObject() name: Record<string, string>;
  @IsOptional() @IsObject() description?: Record<string, string>;
  @IsOptional() @IsString() imageKey?: string;
  @IsNumber() @Min(0) price: number;
  @IsArray() @IsString({ each: true }) allergens: string[];
  @IsBoolean() available: boolean;
}
class MenuItemPatchDto {
  @IsOptional() @IsObject() category?: Record<string, string>;
  @IsOptional() @IsObject() name?: Record<string, string>;
  @IsOptional() @IsObject() description?: Record<string, string>;
  @IsOptional() @IsString() imageKey?: string;
  @IsOptional() @IsNumber() @Min(0) price?: number;
  @IsOptional() @IsArray() @IsString({ each: true }) allergens?: string[];
  @IsOptional() @IsBoolean() available?: boolean;
}
class LineDto {
  @IsUUID() menuItemId: string;
  @IsInt() @Min(1) @Max(50) qty: number;
  @IsOptional() @IsString() @MaxLength(200) notes?: string;
}
class OrderDto {
  @IsString() @Length(20, 100) token: string;
  @IsArray() @ArrayMinSize(1) @ArrayMaxSize(50) @ValidateNested({ each: true }) @Type(() => LineDto) items: LineDto[];
  @IsOptional() @IsString() @MaxLength(500) allergyNotes?: string;
  @IsIn(['ROOM_CHARGE', 'PAY_AT_OUTLET']) paymentMethod: 'ROOM_CHARGE' | 'PAY_AT_OUTLET';
  @IsOptional() @IsUUID() reservationId?: string;
}
class StatusDto {
  @IsIn([...ORDER_STEPS, 'cancelled']) to: string;
  @IsOptional() @IsString() @MaxLength(300) reason?: string;
}
class MoveDto {
  @IsUUID() tableId: string;
}
class OutletQuery {
  @IsOptional() @IsUUID() outletId?: string;
}

/**
 * Restaurant QR ordering (R-1…R-3). Table QR = opaque random token; only its hash is stored.
 * The guest must explicitly submit the cart — scanning alone never creates an order.
 * R-4: no POS adapter until a vendor is chosen (open decision #9); orders go to the staff queue.
 */
@Injectable()
export class RestaurantService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly notifications: NotificationsService,
  ) {}

  async byToken(token: string) {
    const qr = await this.prisma.tableQrToken.findUnique({ where: { tokenHash: sha256(token) }, include: { table: { include: { outlet: true } } } });
    if (!qr || qr.revokedAt || !qr.table.active) throw new AppError('QR_INVALID', 404);
    return qr.table;
  }

  async menu(token: string, locale: Locale) {
    const table = await this.byToken(token);
    const hotel = await this.prisma.hotel.findUniqueOrThrow({ where: { id: table.outlet.hotelId } });
    const items = await this.prisma.menuItem.findMany({ where: { outletId: table.outletId, available: true }, orderBy: { price: 'asc' } });
    const tr = (v: unknown) => t(v, locale, hotel.defaultLocale);
    return {
      outlet: { id: table.outlet.id, name: tr(table.outlet.name) },
      table: { id: table.id, label: table.label },
      currency: hotel.currency,
      serviceChargeRate: hotel.serviceCharge,
      taxRate: hotel.taxRate,
      items: items.map((i) => ({
        id: i.id,
        category: tr(i.category),
        name: tr(i.name),
        description: i.description ? tr(i.description) : '',
        imageUrl: i.imageKey ? assetUrl(i.imageKey) : null,
        price: i.price,
        allergens: i.allergens,
      })),
    };
  }

  async order(userId: string, dto: OrderDto, key: string) {
    const prior = await this.prisma.restaurantOrder.findUnique({ where: { idempotencyKey: key } });
    if (prior) return prior;
    const table = await this.byToken(dto.token);
    const hotel = await this.prisma.hotel.findUniqueOrThrow({ where: { id: table.outlet.hotelId } });
    let reservationId: string | undefined;
    if (dto.paymentMethod === 'ROOM_CHARGE') {
      const r = dto.reservationId ? await this.prisma.reservation.findUnique({ where: { id: dto.reservationId } }) : null;
      if (!r || r.guestId !== userId || r.hotelId !== hotel.id || r.status !== 'CHECKED_IN') throw new AppError('ROOM_CHARGE_NOT_ALLOWED', 403);
      reservationId = r.id;
    }
    const menu = await this.prisma.menuItem.findMany({ where: { id: { in: dto.items.map((i) => i.menuItemId) }, outletId: table.outletId, available: true } });
    const lines = dto.items.map((i) => {
      const item = menu.find((x) => x.id === i.menuItemId);
      if (!item) throw new AppError('ITEM_UNAVAILABLE', 409, { menuItemId: i.menuItemId });
      return { menuItemId: item.id, name: item.name, price: fromCents(toCents(item.price)), qty: i.qty, notes: i.notes ?? null, cents: toCents(item.price) * i.qty };
    });
    // Same rules as rooms: service charge on the subtotal, VAT on both.
    const price = priceStay(lines.map((l) => ({ date: '', cents: l.cents })), Number(hotel.serviceCharge), Number(hotel.taxRate));
    try {
      const o = await this.prisma.restaurantOrder.create({
        data: {
          hotelId: hotel.id,
          outletId: table.outletId,
          tableId: table.id,
          guestId: userId,
          reservationId,
          status: 'submitted',
          items: lines.map(({ cents: _c, ...l }) => l) as unknown as Prisma.InputJsonValue,
          allergyNotes: dto.allergyNotes,
          total: fromCents(price.total),
          paymentMethod: dto.paymentMethod,
          idempotencyKey: key,
        },
      });
      await this.event(o.id, hotel.id, null, 'submitted', userId);
      return o;
    } catch (e) {
      if (!isUnique(e)) throw e;
      return this.prisma.restaurantOrder.findUniqueOrThrow({ where: { idempotencyKey: key } });
    }
  }

  async setStatus(m: Membership, id: string, to: string, userId: string, reason?: string) {
    const o = sameHotel(await this.prisma.restaurantOrder.findUnique({ where: { id } }), m);
    const i = ORDER_STEPS.indexOf(o.status);
    const ok = to === 'cancelled' ? o.status !== 'served' && o.status !== 'cancelled' : i >= 0 && ORDER_STEPS[i + 1] === to;
    if (!ok) throw new AppError('INVALID_TRANSITION', 409);
    const done = await this.prisma.restaurantOrder.updateMany({ where: { id, status: o.status }, data: { status: to } });
    if (!done.count) throw new AppError('INVALID_TRANSITION', 409);
    await this.event(id, o.hotelId, o.status, to, userId, reason);
    if (to === 'served' && o.paymentMethod === 'ROOM_CHARGE' && o.reservationId) {
      const outlet = await this.prisma.outlet.findUniqueOrThrow({ where: { id: o.outletId } });
      await this.prisma.invoiceLine.create({
        data: { hotelId: o.hotelId, reservationId: o.reservationId, kind: 'restaurant', description: outlet.name as Prisma.InputJsonValue, amount: o.total, sourceId: o.id },
      });
    }
    if (o.guestId) {
      await this.notifications.notify(o.guestId, 'order.updated', { code: o.id.slice(0, 6).toUpperCase(), status: to, orderId: o.id }, { hotelId: o.hotelId });
    }
  }

  private event(id: string, hotelId: string, from: string | null, to: string, by: string, note?: string) {
    return this.prisma.statusEvent.create({ data: { hotelId, entityType: 'restaurant_order', entityId: id, fromStatus: from, toStatus: to, byUserId: by, note } });
  }
}

@Controller()
export class RestaurantController {
  constructor(
    private readonly prisma: PrismaService,
    private readonly restaurant: RestaurantService,
  ) {}

  // ── R-1 admin ──

  @Roles(...RESTAURANT)
  @Get('admin/outlets')
  outlets(@CurrentMembership() m: Membership) {
    return this.prisma.outlet.findMany({ where: { hotelId: m.hotelId }, include: { tables: { orderBy: { label: 'asc' } } } });
  }

  @Roles('ADMIN')
  @Post('admin/outlets')
  addOutlet(@CurrentMembership() m: Membership, @Body() dto: OutletDto) {
    return this.prisma.outlet.create({ data: { ...dto, schedule: dto.schedule as Prisma.InputJsonValue, hotelId: m.hotelId } });
  }

  @Roles('ADMIN')
  @Patch('admin/outlets/:id')
  async editOutlet(@CurrentMembership() m: Membership, @Param('id', ParseUUIDPipe) id: string, @Body() dto: OutletDto) {
    sameHotel(await this.prisma.outlet.findUnique({ where: { id } }), m);
    return this.prisma.outlet.update({ where: { id }, data: { ...dto, schedule: dto.schedule as Prisma.InputJsonValue } });
  }

  @Roles('ADMIN')
  @Post('admin/outlets/:id/tables')
  async addTable(@CurrentMembership() m: Membership, @Param('id', ParseUUIDPipe) id: string, @Body() dto: TableDto) {
    sameHotel(await this.prisma.outlet.findUnique({ where: { id } }), m);
    return this.prisma.restaurantTable.create({ data: { outletId: id, label: dto.label, active: dto.active ?? true } });
  }

  @Roles('ADMIN')
  @Patch('admin/tables/:id')
  async editTable(@CurrentMembership() m: Membership, @Param('id', ParseUUIDPipe) id: string, @Body() dto: TableDto) {
    await this.ownTable(m, id);
    return this.prisma.restaurantTable.update({ where: { id }, data: dto });
  }

  /** New QR for a table. The token is returned once; older codes for the table stop working. */
  @Roles('ADMIN')
  @Post('admin/tables/:id/qr')
  async issueQr(@CurrentMembership() m: Membership, @CurrentUser() u: AuthUser, @Param('id', ParseUUIDPipe) id: string) {
    await this.ownTable(m, id);
    const token = randomBytes(24).toString('base64url');
    await this.prisma.$transaction([
      this.prisma.tableQrToken.updateMany({ where: { tableId: id, revokedAt: null }, data: { revokedAt: new Date() } }),
      this.prisma.tableQrToken.create({ data: { tableId: id, tokenHash: sha256(token) } }),
    ]);
    await this.prisma.audit({ hotelId: m.hotelId, actorId: u.sub, action: 'table.qr', entityType: 'table', entityId: id });
    return { token, qrPayload: `tuloy://table/${token}` };
  }

  private async ownTable(m: Membership, id: string) {
    const tbl = await this.prisma.restaurantTable.findUnique({ where: { id }, include: { outlet: true } });
    if (!tbl || tbl.outlet.hotelId !== m.hotelId) throw new AppError('NOT_FOUND', 404);
    return tbl;
  }

  @Roles(...RESTAURANT)
  @Get('admin/outlets/:id/menu')
  async menuAdmin(@CurrentMembership() m: Membership, @Param('id', ParseUUIDPipe) id: string) {
    sameHotel(await this.prisma.outlet.findUnique({ where: { id } }), m);
    return this.prisma.menuItem.findMany({ where: { outletId: id }, orderBy: { price: 'asc' } });
  }

  @Roles('ADMIN')
  @Post('admin/outlets/:id/menu')
  async addItem(@CurrentMembership() m: Membership, @Param('id', ParseUUIDPipe) id: string, @Body() dto: MenuItemDto) {
    sameHotel(await this.prisma.outlet.findUnique({ where: { id } }), m);
    return this.prisma.menuItem.create({ data: { ...dto, outletId: id } });
  }

  /** Staff can toggle `available` (86 an item); admins edit everything. */
  @Roles(...RESTAURANT)
  @Patch('admin/menu-items/:id')
  async editItem(@CurrentMembership() m: Membership, @Param('id', ParseUUIDPipe) id: string, @Body() dto: MenuItemPatchDto) {
    const item = await this.prisma.menuItem.findUnique({ where: { id }, include: { outlet: true } });
    if (!item || item.outlet.hotelId !== m.hotelId) throw new AppError('NOT_FOUND', 404);
    const data = m.role === 'ADMIN' ? dto : { available: dto.available };
    return this.prisma.menuItem.update({ where: { id }, data });
  }

  // ── R-2 guest ──

  @Public()
  @Get('qr/:token')
  menu(@Param('token') token: string, @Headers('accept-language') lang?: string) {
    if (!/^[A-Za-z0-9_-]{20,100}$/.test(token)) throw new AppError('QR_INVALID', 404);
    return this.restaurant.menu(token, pickLocale(lang));
  }

  @Post('restaurant-orders')
  order(@CurrentUser() u: AuthUser, @Body() dto: OrderDto, @Headers('idempotency-key') key?: string) {
    return this.restaurant.order(u.sub, dto, idempotencyKey(key));
  }

  @Get('me/restaurant-orders')
  mine(@CurrentUser() u: AuthUser) {
    return this.prisma.restaurantOrder.findMany({ where: { guestId: u.sub }, orderBy: { createdAt: 'desc' }, take: 50 });
  }

  @Get('restaurant-orders/:id')
  async get(@CurrentUser() u: AuthUser, @Param('id', ParseUUIDPipe) id: string) {
    const o = await this.prisma.restaurantOrder.findUnique({ where: { id } });
    if (!o || o.guestId !== u.sub) throw new AppError('NOT_FOUND', 404);
    return o;
  }

  // ── R-3 staff queue ──

  @Roles(...RESTAURANT)
  @Get('staff/restaurant-orders')
  async queue(@CurrentMembership() m: Membership, @Query() q: OutletQuery) {
    const orders = await this.prisma.restaurantOrder.findMany({
      where: { hotelId: m.hotelId, outletId: q.outletId, status: { in: ['submitted', 'accepted', 'preparing'] } },
      orderBy: { createdAt: 'asc' },
      take: 200,
    });
    const tables = await this.prisma.restaurantTable.findMany({ where: { id: { in: orders.map((o) => o.tableId) } } });
    return orders.map((o) => ({ ...o, table: tables.find((x) => x.id === o.tableId)?.label ?? '' }));
  }

  @Roles(...RESTAURANT)
  @Post('staff/restaurant-orders/:id/status')
  @HttpCode(204)
  status(@CurrentMembership() m: Membership, @CurrentUser() u: AuthUser, @Param('id', ParseUUIDPipe) id: string, @Body() dto: StatusDto) {
    return this.restaurant.setStatus(m, id, dto.to, u.sub, dto.reason);
  }

  /** Correction when the guest scanned the wrong table. */
  @Roles(...RESTAURANT)
  @Post('staff/restaurant-orders/:id/move-table')
  @HttpCode(204)
  async move(@CurrentMembership() m: Membership, @CurrentUser() u: AuthUser, @Param('id', ParseUUIDPipe) id: string, @Body() dto: MoveDto) {
    const o = sameHotel(await this.prisma.restaurantOrder.findUnique({ where: { id } }), m);
    const tbl = await this.ownTable(m, dto.tableId);
    if (tbl.outletId !== o.outletId) throw new AppError('VALIDATION', 400);
    await this.prisma.restaurantOrder.update({ where: { id }, data: { tableId: dto.tableId } });
    await this.prisma.audit({ hotelId: m.hotelId, actorId: u.sub, action: 'order.move', entityType: 'restaurant_order', entityId: id, after: dto });
  }
}
