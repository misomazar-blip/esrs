'use client';

import { useEffect } from 'react';
import { useParams, useRouter } from 'next/navigation';

export default function QuestionsRedirectPage() {
  const params = useParams<{ locale: string; id: string }>();
  const router = useRouter();

  const locale = typeof params.locale === 'string' ? params.locale : 'en';
  const reportId = typeof params.id === 'string' ? params.id : '';

  useEffect(() => {
    if (!reportId) return;
    router.replace(`/${locale}/reports/${reportId}/settings`);
  }, [locale, reportId, router]);

  return <div className="p-6 text-sm text-gray-600">Redirecting to settings…</div>;
}
