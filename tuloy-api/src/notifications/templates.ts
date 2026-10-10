import type { Locale } from '../common/i18n';

export type Channel = 'push' | 'email' | 'sms';

/** Which channels each event uses (design pack, notification policy). */
export const CHANNELS: Record<string, Channel[]> = {
  'auth.otp': ['email', 'sms'],
  'booking.confirmed': ['push', 'email', 'sms'],
  'booking.cancelled': ['push', 'email', 'sms'],
  'payment.receipt': ['push', 'email'],
  'refund.issued': ['push', 'email'],
  'booking.received': ['push', 'email'],
  'chat.message': ['push'],
  'service.updated': ['push'],
  'order.updated': ['push'],
  'task.new': ['push'],
};

type Text = Record<Locale, string>;

/**
 * Built-in wording. A hotel overrides any of these with a NotificationTemplate row.
 * Placeholders: {{name}}. Filipino/Bisaya need the hotel's translator review (open decision #13).
 */
export const DEFAULTS: Record<string, { title: Text; body: Text }> = {
  'auth.otp': {
    title: { en: 'Your Tuloy code', fil: 'Ang iyong Tuloy code', ceb: 'Ang imong Tuloy code' },
    body: {
      en: 'Your code is {{otp}}. It expires in 10 minutes. Do not share it.',
      fil: 'Ang iyong code ay {{otp}}. Mag-e-expire ito sa loob ng 10 minuto. Huwag itong ibahagi.',
      ceb: 'Ang imong code kay {{otp}}. Mo-expire kini sulod sa 10 minutos. Ayaw kini ipakigbahin.',
    },
  },
  'booking.confirmed': {
    title: { en: 'Booking confirmed', fil: 'Kumpirmado ang booking', ceb: 'Kumpirmado ang booking' },
    body: {
      en: '{{hotel}}: booking {{code}} is confirmed for {{checkIn}} to {{checkOut}}.',
      fil: '{{hotel}}: kumpirmado ang booking {{code}} mula {{checkIn}} hanggang {{checkOut}}.',
      ceb: '{{hotel}}: kumpirmado ang booking {{code}} gikan {{checkIn}} hangtod {{checkOut}}.',
    },
  },
  'booking.cancelled': {
    title: { en: 'Booking cancelled', fil: 'Nakansela ang booking', ceb: 'Nakansela ang booking' },
    body: {
      en: '{{hotel}}: booking {{code}} ({{checkIn}} to {{checkOut}}) is cancelled. {{reason}}',
      fil: '{{hotel}}: nakansela ang booking {{code}} ({{checkIn}} hanggang {{checkOut}}). {{reason}}',
      ceb: '{{hotel}}: nakansela ang booking {{code}} ({{checkIn}} hangtod {{checkOut}}). {{reason}}',
    },
  },
  'payment.receipt': {
    title: { en: 'Payment received', fil: 'Natanggap ang bayad', ceb: 'Nadawat ang bayad' },
    body: {
      en: 'We received {{amount}} for booking {{code}}. Thank you!',
      fil: 'Natanggap namin ang {{amount}} para sa booking {{code}}. Salamat!',
      ceb: 'Nadawat namo ang {{amount}} para sa booking {{code}}. Salamat!',
    },
  },
  'refund.issued': {
    title: { en: 'Refund on the way', fil: 'Paparating na ang refund', ceb: 'Padulong na ang refund' },
    body: {
      en: '{{amount}} for booking {{code}} is being refunded to your original payment method.',
      fil: 'Ibinabalik ang {{amount}} para sa booking {{code}} sa iyong orihinal na paraan ng pagbayad.',
      ceb: 'Gibalik ang {{amount}} para sa booking {{code}} sa imong orihinal nga paagi sa pagbayad.',
    },
  },
};

Object.assign(DEFAULTS, {
  'booking.received': {
    title: { en: 'Booking received', fil: 'Natanggap ang booking', ceb: 'Nadawat ang booking' },
    body: {
      en: '{{hotel}} received booking {{code}} and will confirm it shortly.',
      fil: 'Natanggap ng {{hotel}} ang booking {{code}} at kukumpirmahin ito sa lalong madaling panahon.',
      ceb: 'Nadawat sa {{hotel}} ang booking {{code}} ug kumpirmahon kini dayon.',
    },
  },
  'chat.message': {
    title: { en: '{{hotel}}', fil: '{{hotel}}', ceb: '{{hotel}}' },
    body: { en: '{{preview}}', fil: '{{preview}}', ceb: '{{preview}}' },
  },
  'service.updated': {
    title: { en: '{{service}}', fil: '{{service}}', ceb: '{{service}}' },
    body: {
      en: 'Your request is now: {{status}}',
      fil: 'Ang iyong request ay: {{status}}',
      ceb: 'Ang imong request karon: {{status}}',
    },
  },
  'order.updated': {
    title: { en: 'Order {{code}}', fil: 'Order {{code}}', ceb: 'Order {{code}}' },
    body: {
      en: 'Your order is now: {{status}}',
      fil: 'Ang iyong order ay: {{status}}',
      ceb: 'Ang imong order karon: {{status}}',
    },
  },
  'task.new': {
    title: { en: 'New task', fil: 'Bagong gawain', ceb: 'Bag-ong buluhaton' },
    body: { en: '{{service}} — {{where}}', fil: '{{service}} — {{where}}', ceb: '{{service}} — {{where}}' },
  },
});

export const render = (text: string, vars: Record<string, string>) =>
  text.replace(/\{\{(\w+)\}\}/g, (_, k: string) => vars[k] ?? '').trim();
