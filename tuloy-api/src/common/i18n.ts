/** App languages. Hotel content falls back to English where a translation is missing. */
export const LOCALES = ['en', 'fil', 'ceb', 'zh', 'ja', 'ko', 'es', 'fr', 'de', 'it', 'ru', 'ar', 'hi', 'id', 'vi', 'th', 'ms'] as const;
export type Locale = (typeof LOCALES)[number];

/** First language in an Accept-Language header that we support, else 'en'. */
export function pickLocale(header?: string | string[]): Locale {
  const raw = Array.isArray(header) ? header[0] : header;
  for (const part of (raw ?? '').split(',')) {
    const lang = /^\s*([a-z]+)/i.exec(part)?.[1]?.toLowerCase();
    if (lang && (LOCALES as readonly string[]).includes(lang)) return lang as Locale;
  }
  return 'en';
}

/** Read translated hotel content stored as { en, fil, … }; a missing or blank translation falls back. */
export function t(value: unknown, locale: Locale, fallback: Locale = 'en'): string {
  const v = (value ?? {}) as Partial<Record<Locale, string>>;
  return v[locale]?.trim() || v[fallback]?.trim() || v.en || '';
}
