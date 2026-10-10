export type Locale = 'en' | 'fil' | 'ceb';
export const LOCALES: Locale[] = ['en', 'fil', 'ceb'];

/** First language in an Accept-Language header that we support, else 'en'. */
export function pickLocale(header?: string | string[]): Locale {
  const raw = Array.isArray(header) ? header[0] : header;
  for (const part of (raw ?? '').split(',')) {
    const lang = /^\s*([a-z]+)/i.exec(part)?.[1]?.toLowerCase();
    if (lang && (LOCALES as string[]).includes(lang)) return lang as Locale;
  }
  return 'en';
}

/** Read translated hotel content stored as { en, fil, ceb }. */
export function t(value: unknown, locale: Locale, fallback: Locale = 'en'): string {
  const v = (value ?? {}) as Partial<Record<Locale, string>>;
  return v[locale] ?? v[fallback] ?? v.en ?? '';
}
