import { Body, Controller, Delete, Get, HttpCode, Param, Patch, Post } from '@nestjs/common';
import { AuthUser, CurrentUser } from '../common/auth';
import { PrismaService } from '../common/prisma.service';
import { USER_SELECT } from '../auth/auth.service';
import { PushTokenDto, UpdateMeDto } from '../auth/dto';

@Controller('me')
export class MeController {
  constructor(private readonly prisma: PrismaService) {}

  @Get()
  get(@CurrentUser() u: AuthUser) {
    return this.prisma.user.findUniqueOrThrow({ where: { id: u.sub }, select: USER_SELECT });
  }

  @Patch()
  update(@CurrentUser() u: AuthUser, @Body() dto: UpdateMeDto) {
    return this.prisma.user.update({ where: { id: u.sub }, data: dto, select: USER_SELECT });
  }

  /** Guest's payments (bookings + paid services). Card details stay with the gateway, so only method/provider show. */
  @Get('payments')
  async payments(@CurrentUser() u: AuthUser) {
    const requests = await this.prisma.serviceRequest.findMany({ where: { guestId: u.sub }, select: { id: true } });
    const rows = await this.prisma.payment.findMany({
      where: { OR: [{ reservation: { guestId: u.sub } }, { serviceReqId: { in: requests.map((r) => r.id) } }] },
      include: { reservation: { select: { code: true } } },
      orderBy: { createdAt: 'desc' },
      take: 50,
    });
    return rows.map((p) => ({
      id: p.id,
      kind: p.kind,
      provider: p.provider,
      status: p.status,
      amount: p.amount,
      refundedAmount: p.refundedAmount,
      currency: p.currency,
      reservationCode: p.reservation?.code ?? null,
      serviceRequestId: p.serviceReqId,
      createdAt: p.createdAt,
    }));
  }

  @Post('push-tokens')
  @HttpCode(204)
  async addPushToken(@CurrentUser() u: AuthUser, @Body() dto: PushTokenDto) {
    // A device token moves to whoever signed in last on that device.
    await this.prisma.pushToken.upsert({
      where: { token: dto.token },
      create: { ...dto, userId: u.sub },
      update: { platform: dto.platform, userId: u.sub },
    });
  }

  @Delete('push-tokens/:token')
  @HttpCode(204)
  async removePushToken(@CurrentUser() u: AuthUser, @Param('token') token: string) {
    await this.prisma.pushToken.deleteMany({ where: { token, userId: u.sub } });
  }
}
