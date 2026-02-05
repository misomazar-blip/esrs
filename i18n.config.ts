import { getRequestConfig } from 'next-intl/server';

// Supported locales
export const locales = ['sk', 'en'] as const;
export type Locale = typeof locales[number];

export const defaultLocale: Locale = 'sk';

export default getRequestConfig(async ({ requestLocale }) => {
  let locale = await requestLocale;
  
  // Ensure the locale is valid
  if (!locale || !locales.includes(locale as Locale)) {
    locale = defaultLocale;
  }

  return {
    locale,
    messages: (await import(`./messages/${locale}.json`)).default
  };
});
