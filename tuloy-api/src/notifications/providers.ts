import { createSign } from 'node:crypto';
import type { Channel } from './templates';

export interface Message {
  title: string;
  body: string;
  data?: Record<string, string>;
}

/** `permanent` = retrying won't help (bad token/number); the worker stops and may clean up. */
export type SendResult = { ok: true; ref?: string } | { ok: false; error: string; permanent?: boolean };

/**
 * One sender per channel, chosen by env: EMAIL_PROVIDER=log|resend, SMS_PROVIDER=log|semaphore,
 * PUSH_PROVIDER=log|fcm. `log` (default) prints instead of sending, for development.
 * Providers are open decision #12; each is a few lines of fetch, swap freely.
 */
export async function send(channel: Channel, to: string, m: Message): Promise<SendResult> {
  const provider = process.env[`${channel.toUpperCase()}_PROVIDER`] ?? 'log';
  try {
    if (provider === 'log') {
      console.log(`[notify:${channel}] to=${to} | ${m.title} | ${m.body}`);
      return { ok: true };
    }
    if (channel === 'email' && provider === 'resend') return await resend(to, m);
    if (channel === 'sms' && provider === 'semaphore') return await semaphore(to, m);
    if (channel === 'push' && provider === 'fcm') return await fcm(to, m);
    return { ok: false, error: `No ${channel} provider "${provider}"`, permanent: true };
  } catch (e) {
    return { ok: false, error: String(e) };
  }
}

async function resend(to: string, m: Message): Promise<SendResult> {
  const res = await fetch('https://api.resend.com/emails', {
    method: 'POST',
    headers: { Authorization: `Bearer ${process.env.RESEND_API_KEY}`, 'Content-Type': 'application/json' },
    body: JSON.stringify({ from: process.env.EMAIL_FROM, to, subject: m.title, text: m.body }),
  });
  const body = (await res.json().catch(() => ({}))) as { id?: string; message?: string };
  if (res.ok) return { ok: true, ref: body.id };
  return { ok: false, error: `resend ${res.status} ${body.message ?? ''}`, permanent: res.status === 422 };
}

/** Semaphore (PH SMS). Sender name must be approved by Semaphore first. */
async function semaphore(to: string, m: Message): Promise<SendResult> {
  const res = await fetch('https://api.semaphore.co/api/v4/messages', {
    method: 'POST',
    body: new URLSearchParams({
      apikey: process.env.SEMAPHORE_API_KEY ?? '',
      number: to,
      message: m.body,
      sendername: process.env.SMS_SENDER_NAME ?? '',
    }),
  });
  const body = (await res.json().catch(() => null)) as Array<{ message_id?: number }> | null;
  if (res.ok && Array.isArray(body)) return { ok: true, ref: String(body[0]?.message_id ?? '') };
  return { ok: false, error: `semaphore ${res.status} ${JSON.stringify(body)}` };
}

// ── FCM HTTP v1 with a service account (FCM_SERVICE_ACCOUNT = the JSON key, as one line) ──

let fcmToken: { value: string; expires: number } | undefined;

async function fcmAccessToken(sa: { client_email: string; private_key: string }): Promise<string> {
  if (fcmToken && fcmToken.expires > Date.now() + 60_000) return fcmToken.value;
  const now = Math.floor(Date.now() / 1000);
  const b64 = (o: object) => Buffer.from(JSON.stringify(o)).toString('base64url');
  const unsigned = `${b64({ alg: 'RS256', typ: 'JWT' })}.${b64({
    iss: sa.client_email,
    scope: 'https://www.googleapis.com/auth/firebase.messaging',
    aud: 'https://oauth2.googleapis.com/token',
    iat: now,
    exp: now + 3600,
  })}`;
  const signature = createSign('RSA-SHA256').update(unsigned).sign(sa.private_key, 'base64url');
  const res = await fetch('https://oauth2.googleapis.com/token', {
    method: 'POST',
    body: new URLSearchParams({
      grant_type: 'urn:ietf:params:oauth:grant-type:jwt-bearer',
      assertion: `${unsigned}.${signature}`,
    }),
  });
  const body = (await res.json()) as { access_token?: string; expires_in?: number };
  if (!body.access_token) throw new Error(`FCM auth failed: ${res.status}`);
  fcmToken = { value: body.access_token, expires: Date.now() + (body.expires_in ?? 3600) * 1000 };
  return fcmToken.value;
}

async function fcm(token: string, m: Message): Promise<SendResult> {
  const sa = JSON.parse(process.env.FCM_SERVICE_ACCOUNT ?? '{}');
  const res = await fetch(`https://fcm.googleapis.com/v1/projects/${sa.project_id}/messages:send`, {
    method: 'POST',
    headers: { Authorization: `Bearer ${await fcmAccessToken(sa)}`, 'Content-Type': 'application/json' },
    body: JSON.stringify({ message: { token, notification: { title: m.title, body: m.body }, data: m.data } }),
  });
  const body = (await res.json().catch(() => ({}))) as { name?: string; error?: { status?: string } };
  if (res.ok) return { ok: true, ref: body.name };
  const gone = res.status === 404 || body.error?.status === 'UNREGISTERED' || body.error?.status === 'INVALID_ARGUMENT';
  return { ok: false, error: `fcm ${res.status} ${body.error?.status ?? ''}`, permanent: gone };
}
