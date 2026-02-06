"use client";

import { useEffect } from "react";
import { useTranslations, useLocale } from "next-intl";
import { useRouter } from "next/navigation";

export default function CompanyPage() {
  const locale = useLocale();
  const t = useTranslations('common');
  const router = useRouter();

  useEffect(() => {
    // Redirect to profile page where company management is now located
    router.replace(`/${locale}/profile`);
  }, [router, locale]);

  return (
    <div style={{ minHeight: "100vh", display: "flex", alignItems: "center", justifyContent: "center" }}>
      <p>{t('loading')}</p>
    </div>
  );
}