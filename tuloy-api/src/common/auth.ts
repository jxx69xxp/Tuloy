import {
  CanActivate,
  ExecutionContext,
  Injectable,
  SetMetadata,
  createParamDecorator,
} from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { JwtService } from '@nestjs/jwt';
import type { Membership, Role } from '@prisma/client';
import { AppError } from './errors';
import { PrismaService } from './prisma.service';

export interface AuthUser {
  sub: string;
}

/** Route needs no access token. */
export const Public = () => SetMetadata('public', true);
/** Caller must hold one of these roles at the route's hotel. */
export const Roles = (...roles: Role[]) => SetMetadata('roles', roles);
/** Caller must hold this permission at the route's hotel (ADMIN holds all). */
export const Perm = (perm: string) => SetMetadata('perm', perm);

export const CurrentUser = createParamDecorator(
  (_: unknown, ctx: ExecutionContext): AuthUser => ctx.switchToHttp().getRequest().user,
);
export const CurrentMembership = createParamDecorator(
  (_: unknown, ctx: ExecutionContext): Membership => ctx.switchToHttp().getRequest().membership,
);

/**
 * Global guard: verifies the access JWT, then — when the route has :hotelId (or an
 * x-hotel-id header) or declares @Roles/@Perm — loads the caller's membership at that
 * hotel and enforces role/permission. This is the hotel scope: handlers can trust hotelId.
 */
@Injectable()
export class AuthGuard implements CanActivate {
  constructor(
    private readonly reflector: Reflector,
    private readonly jwt: JwtService,
    private readonly prisma: PrismaService,
  ) {}

  async canActivate(ctx: ExecutionContext): Promise<boolean> {
    const meta = <T>(key: string) =>
      this.reflector.getAllAndOverride<T | undefined>(key, [ctx.getHandler(), ctx.getClass()]);
    if (meta<boolean>('public')) return true;

    const req = ctx.switchToHttp().getRequest();
    const token = /^Bearer (.+)$/.exec(req.headers.authorization ?? '')?.[1];
    if (!token) throw new AppError('UNAUTHENTICATED', 401);
    try {
      req.user = await this.jwt.verifyAsync<AuthUser>(token);
    } catch {
      throw new AppError('UNAUTHENTICATED', 401);
    }

    const roles = meta<Role[]>('roles');
    const perm = meta<string>('perm');
    // Staff/admin routes without :hotelId take the hotel from the x-hotel-id header.
    const hotelId: string | undefined = req.params?.hotelId ?? (roles || perm ? req.headers['x-hotel-id'] : undefined);
    if (!roles && !perm && !hotelId) return true;
    if (!hotelId) throw new AppError('HOTEL_REQUIRED', 400);

    const m = await this.prisma.membership.findUnique({
      where: { userId_hotelId: { userId: req.user.sub, hotelId } },
    });
    if (!m) throw new AppError('FORBIDDEN', 403);
    if (roles && !roles.includes(m.role)) throw new AppError('FORBIDDEN', 403);
    if (perm && m.role !== 'ADMIN' && !m.permissions.includes(perm)) throw new AppError('FORBIDDEN', 403);
    req.membership = m;
    return true;
  }
}

/** Entities loaded by id must belong to the caller's hotel; anything else looks like it doesn't exist. */
export function sameHotel<T extends { hotelId: string } | null>(entity: T, m: Membership): NonNullable<T> {
  if (!entity || entity.hotelId !== m.hotelId) throw new AppError('NOT_FOUND', 404);
  return entity as NonNullable<T>;
}

/** Staff-facing roles (front desk and back office). */
export const STAFF = ['STAFF', 'ADMIN'] as const;
/** Restaurant routes: restaurant staff plus everyone in STAFF. */
export const RESTAURANT = ['RESTAURANT', ...STAFF] as const;
/** Front desk or admin at this hotel; restaurant staff and guests are not. */
export const isStaff = (m: { role: string } | null | undefined): m is Membership => !!m && (STAFF as readonly string[]).includes(m.role);
