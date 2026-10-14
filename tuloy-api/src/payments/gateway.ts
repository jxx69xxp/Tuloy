import { createHmac, randomUUID, timingSafeEqual } from 'node:crypto';
import { AppError } from '../common/errors';

export interface CheckoutInput {
  reference: string; // our Payment.id
  amountCents: number;
  currency: string;
  description: string;
  successUrl: string;
  cancelUrl: string;
}

export interface GatewayEvent {
  eventId: string;
  type: 'paid' | 'ignored';
  providerRef?: string; // checkout session id
  providerPaymentId?: string;
}

/** Hosted checkout only: card/e-wallet details never touch our servers. */
export interface PaymentGateway {
  readonly name: string;
  createCheckout(input: CheckoutInput): Promise<{ id: string; url: string }>;
  /** Verifies the signature; throws INVALID_SIGNATURE. */
  parseWebhook(rawBody: Buffer, headers: Record<string, string | string[] | undefined>): GatewayEvent;
  refund(input: { providerPaymentId: string; amountCents: number; reason: string }): Promise<{ id: string; status: string }>;
}

export const PAYMENT_GATEWAY = Symbol('PAYMENT_GATEWAY');

export function gatewayFromEnv(): PaymentGateway {
  const provider = process.env.PAYMENT_PROVIDER ?? 'mock';
  if (provider === 'paymongo') {
    const { PAYMONGO_SECRET_KEY: key, PAYMONGO_WEBHOOK_SECRET: hook } = process.env;
    if (!key || !hook) throw new Error('Set PAYMONGO_SECRET_KEY and PAYMONGO_WEBHOOK_SECRET');
    return new PayMongoGateway(key, hook);
  }
  if (provider === 'mock') {
    // Fake checkout moves no money: refused in production unless a demo deployment opts in explicitly.
    if (process.env.NODE_ENV === 'production' && process.env.ALLOW_MOCK_PAYMENTS !== '1') {
      throw new Error('PAYMENT_PROVIDER=mock is not allowed in production (set ALLOW_MOCK_PAYMENTS=1 for a demo)');
    }
    return new MockGateway();
  }
  throw new Error(`Unknown PAYMENT_PROVIDER ${provider}`);
}

export const publicApiUrl = () => (process.env.PUBLIC_API_URL ?? 'http://localhost:3000').replace(/\/$/, '');

/**
 * PayMongo Checkout Sessions (cards, GCash, Maya, GrabPay).
 * Verify field names against https://developers.paymongo.com before going live.
 */
export class PayMongoGateway implements PaymentGateway {
  readonly name = 'paymongo';
  private static readonly API = 'https://api.paymongo.com/v1';
  private static readonly MAX_SIGNATURE_AGE_S = 300;

  constructor(
    private readonly secretKey: string,
    private readonly webhookSecret: string,
  ) {}

  private async call(path: string, attributes: object) {
    const res = await fetch(`${PayMongoGateway.API}${path}`, {
      method: 'POST',
      headers: {
        Authorization: 'Basic ' + Buffer.from(`${this.secretKey}:`).toString('base64'),
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ data: { attributes } }),
    });
    const body = (await res.json()) as { data?: { id: string; attributes: Record<string, unknown> }; errors?: unknown };
    if (!res.ok || !body.data) throw new Error(`PayMongo ${path} ${res.status}: ${JSON.stringify(body.errors)}`);
    return body.data;
  }

  async createCheckout(i: CheckoutInput) {
    const data = await this.call('/checkout_sessions', {
      line_items: [{ name: i.description, amount: i.amountCents, currency: i.currency, quantity: 1 }],
      payment_method_types: ['card', 'gcash', 'paymaya', 'grab_pay'],
      reference_number: i.reference,
      description: i.description,
      success_url: i.successUrl,
      cancel_url: i.cancelUrl,
    });
    return { id: data.id, url: String(data.attributes.checkout_url) };
  }

  parseWebhook(raw: Buffer, headers: Record<string, string | string[] | undefined>): GatewayEvent {
    const header = String(headers['paymongo-signature'] ?? '');
    const parts = Object.fromEntries(header.split(',').map((kv) => kv.split('=', 2) as [string, string]));
    const expected = createHmac('sha256', this.webhookSecret).update(`${parts.t}.${raw.toString('utf8')}`).digest();
    const matches = [parts.te, parts.li].some((sig) => {
      const given = Buffer.from(sig ?? '', 'hex');
      return given.length === expected.length && timingSafeEqual(given, expected);
    });
    const age = Date.now() / 1000 - Number(parts.t);
    if (!matches || !(age < PayMongoGateway.MAX_SIGNATURE_AGE_S)) throw new AppError('INVALID_SIGNATURE', 401);

    const event = JSON.parse(raw.toString('utf8')).data;
    const type: string = event?.attributes?.type;
    const resource = event?.attributes?.data;
    if (type === 'checkout_session.payment.paid') {
      return {
        eventId: event.id,
        type: 'paid',
        providerRef: resource?.id,
        providerPaymentId: resource?.attributes?.payments?.[0]?.id,
      };
    }
    return { eventId: event.id, type: 'ignored' }; // failed attempts: checkout lets the guest retry
  }

  async refund(i: { providerPaymentId: string; amountCents: number; reason: string }) {
    const data = await this.call('/refunds', {
      amount: i.amountCents,
      payment_id: i.providerPaymentId,
      reason: 'requested_by_customer',
      notes: i.reason.slice(0, 255),
    });
    return { id: data.id, status: String(data.attributes.status) };
  }
}

/** Dev/test only: checkout is a page on this API with a "Pay" button. */
export class MockGateway implements PaymentGateway {
  readonly name = 'mock';

  async createCheckout(i: CheckoutInput) {
    return { id: `mock_${i.reference}`, url: `${publicApiUrl()}/v1/payments/mock/${i.reference}` };
  }

  parseWebhook(): GatewayEvent {
    throw new AppError('NOT_FOUND', 404);
  }

  async refund() {
    return { id: `mock_refund_${randomUUID()}`, status: 'succeeded' };
  }
}
