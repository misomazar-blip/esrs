"use client";

import { useEffect } from "react";
import { useRouter } from "next/navigation";
import { useLocale } from "next-intl";
import { createSupabaseBrowserClient } from "@/lib/supabase/client";

export default function HomePage() {
  const locale = useLocale();
  const router = useRouter();
  const supabase = createSupabaseBrowserClient();

  useEffect(() => {
    async function init() {
      const { data } = await supabase.auth.getUser();
      if (data.user?.email) {
        router.push(`/${locale}/dashboard`);
      } else {
        router.push(`/${locale}/login`);
      }
    }
    
    void init();
  }, [locale, router, supabase]);

  return (
    <div className="min-h-screen bg-gray-50 flex items-center justify-center">
      <div className="text-center">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600 mx-auto mb-4"></div>
        <p className="text-gray-600">Redirecting...</p>
      </div>
    </div>
  );
}
