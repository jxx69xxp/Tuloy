import { PrismaService } from '../common/prisma.service';
import { DAY_MS, isoDate, nightsOf, toCents, fromCents, zonedToUtc } from '../booking/domain';
import { t } from '../common/i18n';

export const REPORTS = ['occupancy', 'revenue', 'bookings', 'services', 'restaurant', 'loyalty', 'feedback'] as const;
export type ReportName = (typeof REPORTS)[number];
type Row = Record<string, string | number>;

/**
 * P-1. Each report is a few queries aggregated in JS — fine at single-hotel volume.
 * ponytail: move to SQL views / a reporting replica when a year of data makes these slow.
 */
export async function runReport(prisma: PrismaService, hotelId: string, name: ReportName, from: string, to: string): Promise<Row[]> {
  const hotel = await prisma.hotel.findUniqueOrThrow({ where: { id: hotelId } });
  const start = zonedToUtc(from, '00:00', hotel.timezone);
  const end = zonedToUtc(to, '00:00', hotel.timezone);
  const days = nightsOf(from, to).slice(0, 366);
  const localDay = (d: Date) => new Intl.DateTimeFormat('en-CA', { timeZone: hotel.timezone }).format(d);
  const created = { gte: start, lt: end };

  switch (name) {
    case 'occupancy': {
      const rooms = await prisma.room.count({ where: { hotelId, active: true } });
      const nights = await prisma.roomNight.groupBy({
        by: ['date'],
        where: { hotelId, kind: 'BOOKED', date: { gte: new Date(`${from}T00:00:00Z`), lt: new Date(`${to}T00:00:00Z`) } },
        _count: { _all: true },
      });
      return days.map((date) => {
        const sold = nights.find((n) => isoDate(n.date) === date)?._count._all ?? 0;
        return { date, roomsSold: sold, rooms, occupancyPercent: rooms ? Math.round((sold / rooms) * 100) : 0 };
      });
    }
    case 'revenue': {
      const lines = await prisma.invoiceLine.findMany({ where: { hotelId, kind: { in: ['payment', 'refund'] }, createdAt: created } });
      return days.map((date) => {
        const of = (k: string) => lines.filter((l) => l.kind === k && localDay(l.createdAt) === date).reduce((s, l) => s + toCents(l.amount), 0);
        const collected = -of('payment');
        const refunded = of('refund');
        return { date, collected: fromCents(collected), refunded: fromCents(refunded), net: fromCents(collected - refunded) };
      });
    }
    case 'bookings': {
      const g = await prisma.reservation.groupBy({ by: ['status'], where: { hotelId, createdAt: created }, _count: { _all: true }, _sum: { total: true } });
      return g.map((x) => ({ status: x.status, count: x._count._all, total: fromCents(toCents(x._sum.total ?? 0)) }));
    }
    case 'services': {
      const reqs = await prisma.serviceRequest.findMany({ where: { hotelId, createdAt: created }, include: { service: true } });
      const by = new Map<string, Row>();
      for (const r of reqs) {
        const k = r.serviceId;
        const row = by.get(k) ?? { service: t(r.service.name, hotel.defaultLocale), requests: 0, completed: 0, revenue: '0.00' };
        row.requests = Number(row.requests) + 1;
        if (r.status === 'completed') {
          row.completed = Number(row.completed) + 1;
          row.revenue = fromCents(toCents(String(row.revenue)) + toCents(r.total ?? 0));
        }
        by.set(k, row);
      }
      return [...by.values()];
    }
    case 'restaurant': {
      const orders = await prisma.restaurantOrder.findMany({ where: { hotelId, createdAt: created, status: 'served' } });
      const outlets = await prisma.outlet.findMany({ where: { hotelId } });
      return outlets.map((o) => {
        const mine = orders.filter((x) => x.outletId === o.id);
        return { outlet: t(o.name, hotel.defaultLocale), orders: mine.length, revenue: fromCents(mine.reduce((s, x) => s + toCents(x.total), 0)) };
      });
    }
    case 'loyalty': {
      const g = await prisma.loyaltyTransaction.groupBy({
        by: ['kind'],
        where: { createdAt: created, account: { hotelId } },
        _sum: { points: true },
        _count: { _all: true },
      });
      return g.map((x) => ({ kind: x.kind, transactions: x._count._all, points: x._sum.points ?? 0 }));
    }
    case 'feedback': {
      const rows = await prisma.feedback.findMany({ where: { hotelId, createdAt: created }, orderBy: { createdAt: 'asc' } });
      return rows.map((f) => ({ date: localDay(f.createdAt), rating: f.rating, comment: f.comment ?? '' }));
    }
  }
}

/** RFC 4180 CSV. */
export function toCsv(rows: Row[]): string {
  if (!rows.length) return '';
  const cols = Object.keys(rows[0]);
  const cell = (v: unknown) => {
    const s = String(v ?? '');
    return /[",\n\r]/.test(s) ? `"${s.replace(/"/g, '""')}"` : s;
  };
  return [cols.join(','), ...rows.map((r) => cols.map((c) => cell(r[c])).join(','))].join('\r\n') + '\r\n';
}

export const MAX_REPORT_DAYS = 366;
export const reportSpanOk = (from: string, to: string) => {
  const d = (Date.parse(to) - Date.parse(from)) / DAY_MS;
  return d > 0 && d <= MAX_REPORT_DAYS;
};
