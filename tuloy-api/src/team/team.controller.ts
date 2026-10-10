import { Body, Controller, Delete, Get, HttpCode, Param, ParseUUIDPipe, Patch, Post, Query } from '@nestjs/common';
import type { Membership } from '@prisma/client';
import { IsBoolean, IsEmail, IsIn, IsOptional, IsString, IsUUID, Length, Matches, MaxLength, MinLength } from 'class-validator';
import { hashPassword } from '../auth/password';
import { AuthUser, CurrentMembership, CurrentUser, Roles, STAFF } from '../common/auth';
import { AppError } from '../common/errors';
import { PrismaService } from '../common/prisma.service';

/** Every permission string the API checks. ADMIN implicitly has all of them. */
export const PERMISSIONS = [
  'booking.approve',
  'refund.create',
  'service.publish',
  'loyalty.adjust',
] as const;

const DATE = /^\d{4}-\d{2}-\d{2}$/;

class LeaveDto {
  @Matches(DATE) from: string;
  @Matches(DATE) to: string;
  @IsIn(['vacation', 'sick', 'emergency', 'other']) type: string;
  @IsOptional() @IsString() @MaxLength(500) reason?: string;
}
class DecideDto {
  @IsBoolean() approve: boolean;
}
class StatusQuery {
  @IsOptional() @IsIn(['pending', 'approved', 'rejected']) status?: string;
}
class DepartmentDto {
  @IsString() @Length(1, 80) name: string;
}
class StaffDto {
  @IsEmail() email: string;
  @IsString() @Length(1, 120) fullName: string;
  @IsIn(['STAFF', 'ADMIN']) role: 'STAFF' | 'ADMIN';
  @IsOptional() @IsUUID() departmentId?: string;
  @IsOptional() @IsIn(PERMISSIONS, { each: true }) permissions?: string[];
  /** Temporary password, shared with the staff member out of band; they can reset it with a code. */
  @IsString() @MinLength(8) @MaxLength(200) password: string;
}
class StaffPatchDto {
  @IsOptional() @IsIn(['STAFF', 'ADMIN']) role?: 'STAFF' | 'ADMIN';
  @IsOptional() @IsUUID() departmentId?: string;
  @IsOptional() @IsIn(PERMISSIONS, { each: true }) permissions?: string[];
}

/** Leave (T-5, A-5), departments and staff accounts (A-5). */
@Controller()
export class TeamController {
  constructor(private readonly prisma: PrismaService) {}

  // ── staff: own leave ──

  @Roles(...STAFF)
  @Get('me/leave')
  myLeave(@CurrentMembership() m: Membership) {
    return this.prisma.leaveRequest.findMany({ where: { hotelId: m.hotelId, userId: m.userId }, orderBy: { from: 'desc' } });
  }

  @Roles(...STAFF)
  @Post('me/leave')
  applyLeave(@CurrentMembership() m: Membership, @Body() dto: LeaveDto) {
    if (dto.to < dto.from) throw new AppError('INVALID_DATES', 400);
    return this.prisma.leaveRequest.create({
      data: { hotelId: m.hotelId, userId: m.userId, from: new Date(dto.from), to: new Date(dto.to), type: dto.type, reason: dto.reason, status: 'pending' },
    });
  }

  // ── admin: leave approvals ──

  @Roles('ADMIN')
  @Get('admin/leave')
  async leave(@CurrentMembership() m: Membership, @Query() q: StatusQuery) {
    const rows = await this.prisma.leaveRequest.findMany({
      where: { hotelId: m.hotelId, status: q.status },
      orderBy: { from: 'asc' },
      take: 200,
    });
    const users = await this.prisma.user.findMany({ where: { id: { in: rows.map((r) => r.userId) } }, select: { id: true, fullName: true } });
    return rows.map((r) => ({ ...r, fullName: users.find((u) => u.id === r.userId)?.fullName ?? '' }));
  }

  @Roles('ADMIN')
  @Post('admin/leave/:id/decide')
  async decide(@CurrentMembership() m: Membership, @CurrentUser() u: AuthUser, @Param('id', ParseUUIDPipe) id: string, @Body() dto: DecideDto) {
    const ok = await this.prisma.leaveRequest.updateMany({
      where: { id, hotelId: m.hotelId, status: 'pending' },
      data: { status: dto.approve ? 'approved' : 'rejected', decidedBy: u.sub, decidedAt: new Date() },
    });
    if (!ok.count) throw new AppError('NOT_FOUND', 404);
    await this.prisma.audit({ hotelId: m.hotelId, actorId: u.sub, action: 'leave.decide', entityType: 'leave', entityId: id, after: dto });
  }

  // ── admin: departments ──

  @Roles(...STAFF)
  @Get('admin/departments')
  departments(@CurrentMembership() m: Membership) {
    return this.prisma.department.findMany({ where: { hotelId: m.hotelId }, orderBy: { name: 'asc' } });
  }

  @Roles('ADMIN')
  @Post('admin/departments')
  addDepartment(@CurrentMembership() m: Membership, @Body() dto: DepartmentDto) {
    return this.prisma.department.create({ data: { hotelId: m.hotelId, name: dto.name } });
  }

  // ── admin: staff accounts ──

  @Roles('ADMIN')
  @Get('admin/permissions')
  permissions() {
    return PERMISSIONS;
  }

  @Roles(...STAFF)
  @Get('admin/staff')
  async staff(@CurrentMembership() m: Membership) {
    const rows = await this.prisma.membership.findMany({
      where: { hotelId: m.hotelId, role: { in: ['STAFF', 'ADMIN'] } },
      include: { user: { select: { id: true, fullName: true, email: true, phone: true, disabledAt: true } }, department: true },
      orderBy: { createdAt: 'asc' },
    });
    return rows.map((r) => ({
      userId: r.userId,
      fullName: r.user.fullName,
      email: r.user.email,
      role: r.role,
      department: r.department ? { id: r.department.id, name: r.department.name } : null,
      permissions: r.permissions,
      disabled: !!r.user.disabledAt,
    }));
  }

  /** Creates the account, or adds an existing user to this hotel as staff. */
  @Roles('ADMIN')
  @Post('admin/staff')
  async addStaff(@CurrentMembership() m: Membership, @CurrentUser() u: AuthUser, @Body() dto: StaffDto) {
    await this.department(m, dto.departmentId);
    const email = dto.email.toLowerCase();
    const user =
      (await this.prisma.user.findUnique({ where: { email } })) ??
      (await this.prisma.user.create({ data: { email, fullName: dto.fullName, passwordHash: await hashPassword(dto.password) } }));
    const data = { role: dto.role, departmentId: dto.departmentId, permissions: dto.permissions ?? [] };
    await this.prisma.membership.upsert({
      where: { userId_hotelId: { userId: user.id, hotelId: m.hotelId } },
      create: { ...data, userId: user.id, hotelId: m.hotelId },
      update: data,
    });
    await this.prisma.audit({ hotelId: m.hotelId, actorId: u.sub, action: 'staff.add', entityType: 'user', entityId: user.id, after: data });
    return { userId: user.id };
  }

  @Roles('ADMIN')
  @Patch('admin/staff/:userId')
  @HttpCode(204)
  async updateStaff(@CurrentMembership() m: Membership, @CurrentUser() u: AuthUser, @Param('userId', ParseUUIDPipe) userId: string, @Body() dto: StaffPatchDto) {
    if (userId === u.sub && dto.role && dto.role !== 'ADMIN') throw new AppError('CANNOT_DEMOTE_SELF', 409);
    await this.department(m, dto.departmentId);
    const ok = await this.prisma.membership.updateMany({ where: { userId, hotelId: m.hotelId, role: { not: 'GUEST' } }, data: dto });
    if (!ok.count) throw new AppError('NOT_FOUND', 404);
    await this.prisma.audit({ hotelId: m.hotelId, actorId: u.sub, action: 'staff.update', entityType: 'user', entityId: userId, after: dto });
  }

  /** Removes staff access at this hotel and signs them out everywhere. */
  @Roles('ADMIN')
  @Delete('admin/staff/:userId')
  @HttpCode(204)
  async removeStaff(@CurrentMembership() m: Membership, @CurrentUser() u: AuthUser, @Param('userId', ParseUUIDPipe) userId: string) {
    if (userId === u.sub) throw new AppError('CANNOT_DEMOTE_SELF', 409);
    const ok = await this.prisma.membership.updateMany({
      where: { userId, hotelId: m.hotelId, role: { not: 'GUEST' } },
      data: { role: 'GUEST', permissions: [], departmentId: null },
    });
    if (!ok.count) throw new AppError('NOT_FOUND', 404);
    await this.prisma.refreshToken.updateMany({ where: { userId, revokedAt: null }, data: { revokedAt: new Date() } });
    await this.prisma.audit({ hotelId: m.hotelId, actorId: u.sub, action: 'staff.remove', entityType: 'user', entityId: userId });
  }

  private async department(m: Membership, id?: string) {
    if (!id) return;
    const d = await this.prisma.department.findUnique({ where: { id } });
    if (!d || d.hotelId !== m.hotelId) throw new AppError('NOT_FOUND', 404);
  }
}
