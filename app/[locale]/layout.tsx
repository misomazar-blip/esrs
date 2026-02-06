import { NextIntlClientProvider } from 'next-intl';
import { getMessages } from 'next-intl/server';
import Header from "@/components/Header";
import "../globals.css";

type Params = Promise<{ locale: string }>;

export default async function LocaleLayout({
  children,
  params
}: {
  children: React.ReactNode;
  params: Params;
}) {
  const { locale } = await params;
  
  // Explicitly pass the locale to getMessages
  const messages = await getMessages({ locale });

  return (
    <NextIntlClientProvider messages={messages} locale={locale}>
      <Header />
      <main style={{ minHeight: 'calc(100vh - 64px)' }}>
        {children}
      </main>
    </NextIntlClientProvider>
  );
}
