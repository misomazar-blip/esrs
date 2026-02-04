"use client";

import { useEffect } from "react";
import { useRouter } from "next/navigation";

export default function CompanyPage() {
  const router = useRouter();

  useEffect(() => {
    // Redirect to profile page where company management is now located
    router.replace("/profile");
  }, [router]);

  return (
    <div style={{ minHeight: "100vh", display: "flex", alignItems: "center", justifyContent: "center" }}>
      <p>Redirecting to profile...</p>
    </div>
  );
}