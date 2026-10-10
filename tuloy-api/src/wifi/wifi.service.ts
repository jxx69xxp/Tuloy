import { Injectable } from '@nestjs/common';
import { Reservation } from '@prisma/client';
import { createCipheriv, createDecipheriv, createHash, randomBytes } from 'node:crypto';
import { AppError } from '../common/errors';
import { PrismaService } from '../common/prisma.service';
import { isoDate, readPolicy, zonedToUtc } from '../booking/domain';

/** AES-256-GCM for secrets at rest. DATA_KEY = 32 random bytes, base64. Dev falls back to a key derived from JWT_SECRET. */
function key() {
  const k = process.env.DATA_KEY;
  if (k) return Buffer.from(k, 'base64');
  if (process.env.NODE_ENV === 'production') throw new Error('Set DATA_KEY');
  return createHash('sha256').update(`dev-data-key:${process.env.JWT_SECRET}`).digest();
}
export function encrypt(text: string) {
  const iv = randomBytes(12);
  const c = createCipheriv('aes-256-gcm', key(), iv);
  const data = Buffer.concat([c.update(text, 'utf8'), c.final()]);
  return [iv, c.getAuthTag(), data].map((b) => b.toString('base64url')).join('.');
}
export function decrypt(blob: string) {
  const [iv, tag, data] = blob.split('.').map((s) => Buffer.from(s, 'base64url'));
  const d = createDecipheriv('aes-256-gcm', key(), iv);
  d.setAuthTag(tag);
  return Buffer.concat([d.update(data), d.final()]).toString('utf8');
}

/** Wi-Fi QR format reserves \\ ; , : " */
export const qrEscape = (v: string) => v.replace(/([\\;,:"])/g, '\\$1');

interface WifiSettings {
  ssid?: string;
  mode?: 'portal' | 'psk'; // portal = captive-portal login with username/password; psk = shared password
  psk?: string;
}

/**
 * Per-stay Wi-Fi access, valid until check-out time.
 * WIFI_PROVIDER=log (default) | webhook: POSTs {action, username, password, validUntil, room} to WIFI_WEBHOOK_URL,
 * so a RADIUS bridge or the vendor's API can create/revoke the voucher (open decision #10).
 */
@Injectable()
export class WifiService {
  constructor(private readonly prisma: PrismaService) {}

  private async push(action: 'create' | 'revoke', body: Record<string, unknown>) {
    if ((process.env.WIFI_PROVIDER ?? 'log') !== 'webhook') {
      console.log(`[wifi] ${action}`, body.username);
      return;
    }
    const res = await fetch(process.env.WIFI_WEBHOOK_URL!, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json', Authorization: `Bearer ${process.env.WIFI_WEBHOOK_TOKEN ?? ''}` },
      body: JSON.stringify({ action, ...body }),
    });
    if (!res.ok) throw new Error(`wifi webhook ${res.status}`);
  }

  /** On check-in. Idempotent. A provider failure doesn't block check-in: staff can re-issue. */
  async issue(r: Reservation, room: string | null) {
    const existing = await this.prisma.wifiCredential.findFirst({ where: { reservationId: r.id, status: 'active' } });
    if (existing) return existing;
    const hotel = await this.prisma.hotel.findUniqueOrThrow({ where: { id: r.hotelId } });
    const policy = readPolicy(hotel.policies);
    const validUntil = zonedToUtc(isoDate(r.checkOut), policy.checkOut, hotel.timezone);
    const username = `${room ?? 'g'}-${r.code.slice(-4)}`.toLowerCase();
    const password = randomBytes(6).toString('base64url'); // 8 chars
    const cred = await this.prisma.wifiCredential.create({
      data: {
        hotelId: r.hotelId,
        reservationId: r.id,
        username,
        secretEnc: encrypt(password),
        validFrom: new Date(),
        validUntil,
        status: 'active',
      },
    });
    try {
      await this.push('create', { username, password, validUntil, room });
    } catch (e) {
      console.error('[wifi] provider create failed', e);
    }
    return cred;
  }

  async revoke(reservationId: string) {
    const creds = await this.prisma.wifiCredential.findMany({ where: { reservationId, status: 'active' } });
    for (const c of creds) {
      await this.prisma.wifiCredential.update({ where: { id: c.id }, data: { status: 'revoked', validUntil: new Date() } });
      await this.push('revoke', { username: c.username }).catch((e) => console.error('[wifi] provider revoke failed', e));
    }
  }

  /** Guest view. Only for their own in-house stay. */
  async forGuest(userId: string, reservationId: string) {
    const r = await this.prisma.reservation.findUnique({ where: { id: reservationId } });
    if (!r || r.guestId !== userId) throw new AppError('NOT_FOUND', 404);
    if (r.status !== 'CHECKED_IN') throw new AppError('WIFI_NOT_READY', 409);
    const c = await this.prisma.wifiCredential.findFirst({
      where: { reservationId, status: 'active', validUntil: { gt: new Date() } },
    });
    if (!c) throw new AppError('WIFI_NOT_READY', 409);
    const hotel = await this.prisma.hotel.findUniqueOrThrow({ where: { id: r.hotelId } });
    const w = ((hotel.integrations ?? {}) as { wifi?: WifiSettings }).wifi ?? {};
    const password = w.mode === 'psk' && w.psk ? w.psk : decrypt(c.secretEnc);
    return {
      ssid: w.ssid ?? null,
      mode: w.mode ?? 'portal',
      username: w.mode === 'psk' ? null : c.username,
      password,
      validUntil: c.validUntil,
      // Standard Wi-Fi QR (phones join by scanning). Only meaningful for a shared password network.
      joinQr: w.mode === 'psk' && w.ssid ? `WIFI:T:WPA;S:${qrEscape(w.ssid)};P:${qrEscape(password)};;` : null,
    };
  }
}
