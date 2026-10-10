import { Injectable } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { randomBytes, randomInt, randomUUID } from 'node:crypto';
import { AppError } from '../common/errors';
import { PrismaService } from '../common/prisma.service';
import { NotificationsService } from '../notifications/notifications.service';
import { LoginDto, PasswordResetDto, RegisterDto } from './dto';
import { hashPassword, sha256, verifyPassword } from './password';

const REFRESH_TTL_MS = 30 * 24 * 3600 * 1000;
const OTP_TTL_MS = 10 * 60 * 1000;
const OTP_RESEND_MS = 60 * 1000;
const OTP_MAX_ATTEMPTS = 5;

/** Fields safe to return to the client. */
export const USER_SELECT = {
  id: true,
  email: true,
  phone: true,
  fullName: true,
  locale: true,
  notifyPrefs: true,
  memberships: { select: { hotelId: true, role: true, permissions: true, departmentId: true } },
} as const;

const byLogin = (login: string) => {
  const v = login.trim();
  return v.includes('@') ? { email: v.toLowerCase() } : { phone: v.replace(/[\s-]/g, '') };
};

@Injectable()
export class AuthService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly jwt: JwtService,
    private readonly notifications: NotificationsService,
  ) {}

  async register(dto: RegisterDto) {
    const where = byLogin(dto.login);
    if (await this.prisma.user.findFirst({ where })) throw new AppError('ACCOUNT_EXISTS', 409);
    const hotel = await this.prisma.hotel.findUnique({ where: { id: dto.hotelId } });
    if (!hotel) throw new AppError('NOT_FOUND', 404);
    const user = await this.prisma.user.create({
      data: {
        ...where,
        fullName: dto.fullName,
        passwordHash: await hashPassword(dto.password),
        locale: dto.locale ?? 'en',
        memberships: { create: { hotelId: hotel.id, role: 'GUEST' } },
      },
    });
    return this.issue(user.id);
  }

  async login(dto: LoginDto) {
    const user = await this.prisma.user.findFirst({ where: byLogin(dto.login) });
    if (!user || user.disabledAt || !(await verifyPassword(dto.password, user.passwordHash))) {
      throw new AppError('INVALID_CREDENTIALS', 401);
    }
    return this.issue(user.id);
  }

  /**
   * Rotate: each refresh token works once. Presenting a used/revoked token means it was
   * stolen or replayed, so the whole family (this login session) is revoked.
   */
  async refresh(token: string) {
    const row = await this.prisma.refreshToken.findUnique({ where: { tokenHash: sha256(token) } });
    if (!row) throw new AppError('UNAUTHENTICATED', 401);
    const claimed = await this.prisma.refreshToken.updateMany({
      where: { id: row.id, revokedAt: null },
      data: { revokedAt: new Date() },
    });
    if (claimed.count === 0) {
      await this.revokeFamily(row.familyId);
      throw new AppError('UNAUTHENTICATED', 401);
    }
    const user = await this.prisma.user.findUnique({ where: { id: row.userId } });
    if (row.expiresAt < new Date() || !user || user.disabledAt) throw new AppError('UNAUTHENTICATED', 401);
    return this.issue(row.userId, row.familyId);
  }

  async logout(token: string) {
    const row = await this.prisma.refreshToken.findUnique({ where: { tokenHash: sha256(token) } });
    if (row) await this.revokeFamily(row.familyId);
  }

  /** Always succeeds silently so the endpoint can't be used to discover accounts. */
  async requestOtp(login: string) {
    const user = await this.prisma.user.findFirst({ where: byLogin(login) });
    if (!user || user.disabledAt) return;
    const last = await this.prisma.otpCode.findFirst({
      where: { userId: user.id, purpose: 'reset' },
      orderBy: { createdAt: 'desc' },
    });
    if (last && Date.now() - last.createdAt.getTime() < OTP_RESEND_MS) return;
    const code = randomInt(0, 1_000_000).toString().padStart(6, '0');
    await this.prisma.otpCode.create({
      data: { userId: user.id, purpose: 'reset', codeHash: sha256(code), expiresAt: new Date(Date.now() + OTP_TTL_MS) },
    });
    // Sent to whichever contact they typed. With the default `log` providers it is printed in the API log.
    await this.notifications.notify(user.id, 'auth.otp', { otp: code }, { only: [login.includes('@') ? 'email' : 'sms'] });
  }

  async resetPassword(dto: PasswordResetDto) {
    const user = await this.prisma.user.findFirst({ where: byLogin(dto.login) });
    const otp =
      user &&
      (await this.prisma.otpCode.findFirst({
        where: { userId: user.id, purpose: 'reset', usedAt: null, expiresAt: { gt: new Date() } },
        orderBy: { createdAt: 'desc' },
      }));
    if (!user || !otp || otp.attempts >= OTP_MAX_ATTEMPTS) throw new AppError('INVALID_OTP', 400);
    if (otp.codeHash !== sha256(dto.code)) {
      await this.prisma.otpCode.update({ where: { id: otp.id }, data: { attempts: { increment: 1 } } });
      throw new AppError('INVALID_OTP', 400);
    }
    await this.prisma.$transaction([
      this.prisma.otpCode.update({ where: { id: otp.id }, data: { usedAt: new Date() } }),
      this.prisma.user.update({ where: { id: user.id }, data: { passwordHash: await hashPassword(dto.newPassword) } }),
      this.prisma.refreshToken.updateMany({ where: { userId: user.id, revokedAt: null }, data: { revokedAt: new Date() } }),
    ]);
  }

  private revokeFamily(familyId: string) {
    return this.prisma.refreshToken.updateMany({ where: { familyId, revokedAt: null }, data: { revokedAt: new Date() } });
  }

  private async issue(userId: string, familyId: string = randomUUID()) {
    const refreshToken = randomBytes(32).toString('base64url');
    await this.prisma.refreshToken.create({
      data: { userId, familyId, tokenHash: sha256(refreshToken), expiresAt: new Date(Date.now() + REFRESH_TTL_MS) },
    });
    const user = await this.prisma.user.findUniqueOrThrow({ where: { id: userId }, select: USER_SELECT });
    return { accessToken: await this.jwt.signAsync({ sub: userId }), refreshToken, user };
  }
}
