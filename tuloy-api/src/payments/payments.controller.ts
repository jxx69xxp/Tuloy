import { Controller, Get, Header, HttpCode, Inject, Param, ParseUUIDPipe, Post, Query, RawBodyRequest, Req } from '@nestjs/common';
import type { Request } from 'express';
import { BookingService } from '../booking/booking.service';
import { Public } from '../common/auth';
import { AppError } from '../common/errors';
import { PrismaService } from '../common/prisma.service';
import { PAYMENT_GATEWAY, PaymentGateway } from './gateway';

const page = (title: string, body: string) =>
  `<!doctype html><html><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">` +
  `<title>${title}</title><style>body{font-family:system-ui,sans-serif;max-width:420px;margin:15vh auto;padding:0 20px;text-align:center}` +
  `button{font-size:18px;padding:12px 28px;border-radius:8px;border:0;background:#0F6E6E;color:#fff}</style></head>` +
  `<body><h1>${title}</h1>${body}</body></html>`;

@Public()
@Controller()
export class PaymentsController {
  constructor(
    @Inject(PAYMENT_GATEWAY) private readonly gateway: PaymentGateway,
    private readonly booking: BookingService,
    private readonly prisma: PrismaService,
  ) {}

  /** Gateway → us. The only way a payment becomes SUCCEEDED (besides the dev mock below). */
  @Post('webhooks/payments/:provider')
  @HttpCode(200)
  async webhook(@Param('provider') provider: string, @Req() req: RawBodyRequest<Request>) {
    if (provider !== this.gateway.name || !req.rawBody) throw new AppError('NOT_FOUND', 404);
    const event = this.gateway.parseWebhook(req.rawBody, req.headers);
    await this.booking.onGatewayEvent(provider, event, JSON.parse(req.rawBody.toString('utf8')));
    return { received: true };
  }

  /** Where hosted checkout sends the guest back. The app polls the reservation, so this just says "go back". */
  @Get('payments/return')
  @Header('Content-Type', 'text/html; charset=utf-8')
  returned(@Query('status') status?: string) {
    return status === 'success'
      ? page('Payment sent', '<p>You can close this page and go back to the Tuloy app.</p>')
      : page('Payment not completed', '<p>Go back to the Tuloy app to try again.</p>');
  }

  // ── Dev only (PAYMENT_PROVIDER=mock): a fake checkout page ──

  @Get('payments/mock/:paymentId')
  @Header('Content-Type', 'text/html; charset=utf-8')
  async mockCheckout(@Param('paymentId', ParseUUIDPipe) id: string) {
    const p = await this.mockPayment(id);
    return page(
      'Test checkout',
      `<p>${p.currency} ${p.amount} — no real money moves.</p>` +
        `<form method="post"><button type="submit">Pay (test)</button></form>`,
    );
  }

  @Post('payments/mock/:paymentId')
  @HttpCode(200)
  @Header('Content-Type', 'text/html; charset=utf-8')
  async mockPay(@Param('paymentId', ParseUUIDPipe) id: string) {
    await this.mockPayment(id);
    await this.booking.onGatewayEvent(
      'mock',
      { eventId: `mock_evt_${id}`, type: 'paid', providerRef: `mock_${id}`, providerPaymentId: `mock_pay_${id}` },
      { mock: true, paymentId: id },
    );
    return page('Payment sent', '<p>Test payment done. Go back to the Tuloy app.</p>');
  }

  private async mockPayment(id: string) {
    if (this.gateway.name !== 'mock') throw new AppError('NOT_FOUND', 404);
    const p = await this.prisma.payment.findUnique({ where: { id } });
    if (!p) throw new AppError('NOT_FOUND', 404);
    return p;
  }
}
