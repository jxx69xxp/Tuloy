import { Body, Controller, Get, Param, ParseUUIDPipe, Post, Query } from '@nestjs/common';
import type { Membership } from '@prisma/client';
import { IsISO8601, IsOptional, IsString, IsUUID, Length } from 'class-validator';
import { AuthUser, CurrentMembership, CurrentUser, Roles, STAFF } from '../common/auth';
import { AppError } from '../common/errors';
import { PrismaService } from '../common/prisma.service';
import { NotificationsService } from '../notifications/notifications.service';

class OpenDto {
  @IsUUID() hotelId: string;
  @IsOptional() @IsUUID() reservationId?: string;
  @IsOptional() @IsUUID() serviceRequestId?: string;
}
class SendDto {
  @IsString() @Length(1, 4000) body: string;
}
class AfterQuery {
  @IsOptional() @IsISO8601() after?: string;
}

/**
 * Guest ↔ staff chat (T-4). Messages are stored as written; translation can come later.
 * ponytail: clients poll `?after=` every few seconds. Add a WebSocket gateway when polling load shows up.
 */
@Controller()
export class ChatController {
  constructor(
    private readonly prisma: PrismaService,
    private readonly notifications: NotificationsService,
  ) {}

  /** Owner guest, or staff/admin of the conversation's hotel. */
  private async access(id: string, userId: string) {
    const c = await this.prisma.conversation.findUnique({ where: { id } });
    if (!c) throw new AppError('NOT_FOUND', 404);
    if (c.guestId === userId) return { c, staff: false };
    const m = await this.prisma.membership.findUnique({ where: { userId_hotelId: { userId, hotelId: c.hotelId } } });
    if (!m || m.role === 'GUEST') throw new AppError('NOT_FOUND', 404);
    return { c, staff: true };
  }

  /** Returns the guest's open conversation for this context, creating it if needed. */
  @Post('conversations')
  async open(@CurrentUser() u: AuthUser, @Body() dto: OpenDto) {
    if (dto.reservationId) {
      const r = await this.prisma.reservation.findUnique({ where: { id: dto.reservationId } });
      if (!r || r.guestId !== u.sub || r.hotelId !== dto.hotelId) throw new AppError('NOT_FOUND', 404);
    }
    const where = { hotelId: dto.hotelId, guestId: u.sub, reservationId: dto.reservationId ?? null, closedAt: null };
    return (
      (await this.prisma.conversation.findFirst({ where })) ??
      this.prisma.conversation.create({
        data: { hotelId: dto.hotelId, guestId: u.sub, reservationId: dto.reservationId, serviceReqId: dto.serviceRequestId },
      })
    );
  }

  @Get('me/conversations')
  mine(@CurrentUser() u: AuthUser) {
    return this.prisma.conversation.findMany({ where: { guestId: u.sub }, orderBy: { lastMessageAt: 'desc' }, take: 50 });
  }

  /** Messages after a timestamp; marks the other side's messages as read. */
  @Get('conversations/:id/messages')
  async messages(@CurrentUser() u: AuthUser, @Param('id', ParseUUIDPipe) id: string, @Query() q: AfterQuery) {
    await this.access(id, u.sub);
    await this.prisma.message.updateMany({
      where: { conversationId: id, senderId: { not: u.sub }, readAt: null },
      data: { readAt: new Date() },
    });
    return this.prisma.message.findMany({
      where: { conversationId: id, createdAt: q.after ? { gt: new Date(q.after) } : undefined },
      orderBy: { createdAt: 'asc' },
      take: 200,
    });
  }

  @Post('conversations/:id/messages')
  async send(@CurrentUser() u: AuthUser, @Param('id', ParseUUIDPipe) id: string, @Body() dto: SendDto) {
    const { c, staff } = await this.access(id, u.sub);
    if (c.closedAt) throw new AppError('CONVERSATION_CLOSED', 409);
    const [msg] = await this.prisma.$transaction([
      this.prisma.message.create({ data: { conversationId: id, senderId: u.sub, body: dto.body } }),
      this.prisma.conversation.update({ where: { id }, data: { lastMessageAt: new Date() } }),
    ]);
    if (staff) {
      const hotel = await this.prisma.hotel.findUniqueOrThrow({ where: { id: c.hotelId } });
      await this.notifications.notify(c.guestId, 'chat.message', { hotel: hotel.name, preview: dto.body.slice(0, 120), conversationId: id }, { hotelId: c.hotelId });
    }
    return msg;
  }

  /** Staff inbox: open conversations with the guest's name and unread count. */
  @Roles(...STAFF)
  @Get('staff/conversations')
  async inbox(@CurrentMembership() m: Membership) {
    const convs = await this.prisma.conversation.findMany({
      where: { hotelId: m.hotelId, closedAt: null },
      orderBy: { lastMessageAt: 'desc' },
      take: 100,
    });
    const users = await this.prisma.user.findMany({ where: { id: { in: convs.map((c) => c.guestId) } }, select: { id: true, fullName: true } });
    const unread = await this.prisma.message.groupBy({
      by: ['conversationId'],
      where: { conversationId: { in: convs.map((c) => c.id) }, readAt: null, senderId: { in: convs.map((c) => c.guestId) } },
      _count: { _all: true },
    });
    return convs.map((c) => ({
      id: c.id,
      guestName: users.find((x) => x.id === c.guestId)?.fullName ?? '',
      reservationId: c.reservationId,
      lastMessageAt: c.lastMessageAt,
      unread: unread.find((x) => x.conversationId === c.id)?._count._all ?? 0,
    }));
  }

  @Roles(...STAFF)
  @Post('staff/conversations/:id/close')
  async close(@CurrentMembership() m: Membership, @Param('id', ParseUUIDPipe) id: string) {
    const c = await this.prisma.conversation.findUnique({ where: { id } });
    if (!c || c.hotelId !== m.hotelId) throw new AppError('NOT_FOUND', 404);
    return this.prisma.conversation.update({ where: { id }, data: { closedAt: new Date() } });
  }
}
