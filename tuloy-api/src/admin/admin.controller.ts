import { Body, Controller, Delete, Get, HttpCode, Param, ParseUUIDPipe, Patch, Post, Query, Res } from '@nestjs/common';
import type { Membership, Prisma } from '@prisma/client';
import type { Response } from 'express';
import { Type } from 'class-transformer';
import { IsIn, IsInt, IsNumber, IsObject, IsOptional, IsString, IsUUID, Length, Matches, Max, MaxLength, Min } from 'class-validator';
import { BookingService } from '../booking/booking.service';
import { toCents } from '../booking/domain';
import { AuthUser, CurrentMembership, CurrentUser, Perm, Roles, sameHotel } from '../common/auth';
import { AppError } from '../common/errors';
import { PrismaService } from '../common/prisma.service';
import { FrontDeskService } from '../frontdesk/frontdesk.service';
import { LoyaltyService } from '../loyalty/loyalty.service';
import { REPORTS, ReportName, reportSpanOk, runReport, toCsv } from './reports';

const DATE = /^\d{4}-\d{2}-\d{2}$/;

class RefundDto {
  @IsNumber() @Min(0.01) amount: number;
  @IsString() @Length(3, 300) reason: string;
}
class PaymentsQuery {
  @IsOptional() @IsIn(['PENDING', 'SUCCEEDED', 'FAILED', 'REFUNDED', 'PARTIALLY_REFUNDED']) status?: string;
}
class AuditQuery {
  @IsOptional() @IsString() @MaxLength(40) entityType?: string;
  @IsOptional() @IsUUID() entityId?: string;
}
class ReportQuery {
  @Matches(DATE) from: string;
  @Matches(DATE) to: string;
  @IsOptional() @IsIn(['json', 'csv']) format?: 'json' | 'csv';
}
class ContentDto {
  @IsIn(['guide', 'promotion', 'banner']) kind: string;
  @IsObject() title: Record<string, string>;
  @IsObject() body: Record<string, string>;
  @IsOptional() @IsString() imageKey?: string;
  @IsOptional() @IsString() publishedAt?: string | null;
  @IsOptional() @IsString() expiresAt?: string | null;
}
class RewardDto {
  @IsObject() name: Record<string, string>;
  @IsInt() @Min(1) points: number;
  @IsNumber() @Min(0) value: number;
  @IsOptional() active?: boolean;
}
class AdjustDto {
  @Type(() => Number) @IsInt() @Min(-1_000_000) @Max(1_000_000) points: number;
  @IsString() @Length(3, 300) reason: string;
}
class AccountsQuery {
  @IsOptional() @IsString() @MaxLength(100) q?: string;
}

/** Admin-only reads and money actions (A-3, A-4, A-6, P-1, L-2 admin side, content). */
@Roles('ADMIN')
@Controller('admin')
export class AdminController {
  constructor(
    private readonly prisma: PrismaService,
    private readonly booking: BookingService,
    private readonly desk: FrontDeskService,
    private readonly loyalty: LoyaltyService,
  ) {}

  @Get('dashboard')
  dashboard(@CurrentMembership() m: Membership, @CurrentUser() u: AuthUser) {
    return this.desk.adminDashboard(m, u.sub);
  }

  // ── A-3 payments & refunds ──

  @Get('payments')
  payments(@CurrentMembership() m: Membership, @Query() q: PaymentsQuery) {
    return this.prisma.payment.findMany({
      where: { hotelId: m.hotelId, status: q.status as never },
      include: { refunds: true },
      orderBy: { createdAt: 'desc' },
      take: 200,
    });
  }

  /** Manual refund, also how finance retries a failed one. */
  @Perm('refund.create')
  @Post('payments/:id/refunds')
  async refund(@CurrentMembership() m: Membership, @CurrentUser() u: AuthUser, @Param('id', ParseUUIDPipe) id: string, @Body() dto: RefundDto) {
    const p = sameHotel(await this.prisma.payment.findUnique({ where: { id } }), m);
    const left = toCents(p.amount) - toCents(p.refundedAmount);
    const cents = Math.round(dto.amount * 100);
    if (cents > left) throw new AppError('REFUND_TOO_LARGE', 409);
    if (!p.reservationId) throw new AppError('NOT_FOUND', 404);
    const r = await this.prisma.reservation.findUniqueOrThrow({ where: { id: p.reservationId } });
    const done = await this.booking.refundAndNotify(r, [p.id], cents, dto.reason, u.sub);
    await this.prisma.audit({ hotelId: m.hotelId, actorId: u.sub, action: 'refund.create', entityType: 'payment', entityId: id, after: { cents, reason: dto.reason, done } });
    if (!done) throw new AppError('REFUND_FAILED', 502);
    return { refunded: (done / 100).toFixed(2) };
  }

  // ── A-6 audit ──

  @Get('audit')
  audit(@CurrentMembership() m: Membership, @Query() q: AuditQuery) {
    return this.prisma.auditLog.findMany({
      where: { hotelId: m.hotelId, entityType: q.entityType, entityId: q.entityId },
      orderBy: { at: 'desc' },
      take: 200,
    });
  }

  // ── P-1 reports ──

  @Get('reports')
  reports() {
    return REPORTS;
  }

  @Get('reports/:name')
  async report(@CurrentMembership() m: Membership, @Param('name') name: string, @Query() q: ReportQuery, @Res({ passthrough: true }) res: Response) {
    if (!(REPORTS as readonly string[]).includes(name)) throw new AppError('NOT_FOUND', 404);
    if (!reportSpanOk(q.from, q.to)) throw new AppError('INVALID_DATES', 400);
    const rows = await runReport(this.prisma, m.hotelId, name as ReportName, q.from, q.to);
    if (q.format !== 'csv') return rows;
    res.setHeader('Content-Type', 'text/csv; charset=utf-8');
    res.setHeader('Content-Disposition', `attachment; filename="${name}-${q.from}-${q.to}.csv"`);
    return toCsv(rows);
  }

  // ── content: guides, promotions ──

  @Get('content')
  content(@CurrentMembership() m: Membership) {
    return this.prisma.contentItem.findMany({ where: { hotelId: m.hotelId }, orderBy: { publishedAt: 'desc' } });
  }

  @Post('content')
  addContent(@CurrentMembership() m: Membership, @Body() dto: ContentDto) {
    return this.prisma.contentItem.create({ data: this.contentData(dto, m.hotelId) });
  }

  @Patch('content/:id')
  async editContent(@CurrentMembership() m: Membership, @Param('id', ParseUUIDPipe) id: string, @Body() dto: ContentDto) {
    sameHotel(await this.prisma.contentItem.findUnique({ where: { id } }), m);
    return this.prisma.contentItem.update({ where: { id }, data: this.contentData(dto, m.hotelId) });
  }

  @Delete('content/:id')
  @HttpCode(204)
  async deleteContent(@CurrentMembership() m: Membership, @Param('id', ParseUUIDPipe) id: string) {
    sameHotel(await this.prisma.contentItem.findUnique({ where: { id } }), m);
    await this.prisma.contentItem.delete({ where: { id } });
  }

  private contentData(dto: ContentDto, hotelId: string): Prisma.ContentItemUncheckedCreateInput {
    const when = (v?: string | null) => (v ? new Date(v) : null);
    return { ...dto, hotelId, publishedAt: when(dto.publishedAt), expiresAt: when(dto.expiresAt) };
  }

  // ── L-2 loyalty admin ──

  @Get('loyalty/rewards')
  rewards(@CurrentMembership() m: Membership) {
    return this.prisma.loyaltyReward.findMany({ where: { hotelId: m.hotelId }, orderBy: { points: 'asc' } });
  }

  @Post('loyalty/rewards')
  addReward(@CurrentMembership() m: Membership, @Body() dto: RewardDto) {
    return this.prisma.loyaltyReward.create({ data: { ...dto, hotelId: m.hotelId } });
  }

  @Patch('loyalty/rewards/:id')
  async editReward(@CurrentMembership() m: Membership, @Param('id', ParseUUIDPipe) id: string, @Body() dto: RewardDto) {
    sameHotel(await this.prisma.loyaltyReward.findUnique({ where: { id } }), m);
    return this.prisma.loyaltyReward.update({ where: { id }, data: dto });
  }

  @Get('loyalty/accounts')
  async accounts(@CurrentMembership() m: Membership, @Query() q: AccountsQuery) {
    const rows = await this.prisma.loyaltyAccount.findMany({
      where: {
        hotelId: m.hotelId,
        user: q.q ? { OR: [{ fullName: { contains: q.q, mode: 'insensitive' } }, { email: { contains: q.q, mode: 'insensitive' } }] } : undefined,
      },
      include: { user: { select: { fullName: true, email: true } } },
      orderBy: { lifetime: 'desc' },
      take: 100,
    });
    return rows.map((a) => ({ id: a.id, fullName: a.user.fullName, email: a.user.email, balance: a.balance, lifetime: a.lifetime, tier: a.tier }));
  }

  @Perm('loyalty.adjust')
  @Post('loyalty/accounts/:id/adjust')
  @HttpCode(204)
  adjust(@CurrentMembership() m: Membership, @CurrentUser() u: AuthUser, @Param('id', ParseUUIDPipe) id: string, @Body() dto: AdjustDto) {
    return this.loyalty.adjust(id, m.hotelId, dto.points, dto.reason, u.sub);
  }
}
