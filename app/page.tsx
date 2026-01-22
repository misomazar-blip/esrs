"use client";

import Link from "next/link";
import { useEffect, useState } from "react";
import { createSupabaseBrowserClient } from "@/lib/supabase/client";

export default function HomePage() {
  const supabase = createSupabaseBrowserClient();
  const [email, setEmail] = useState<string | null>(null);

  useEffect(() => {
    supabase.auth.getUser().then(({ data }) => setEmail(data.user?.email ?? null));
  }, []);

  async function signOut() {
    await supabase.auth.signOut();
    window.location.href = "/login";
  }

  return (
    <div style={{ display: "grid", gap: 12, maxWidth: 900 }}>
      <h1>ESRS SME Platform (MVP)</h1>

      <div>
        Session: <b>{email ? `Yes (${email})` : "No"}</b>
      </div>

      <div style={{ display: "flex", gap: 12, flexWrap: "wrap" }}>
        <Link href="/company">Company</Link>
        <Link href="/report">Report</Link>
        <Link href="/materiality">Materiality</Link>
        <Link href="/topics">Topics</Link>
        <Link href="/login">Login</Link>
        <button onClick={signOut}>Sign out</button>
      </div>

      <p style={{ opacity: 0.8 }}>
        Tip: ak si neprihlásený, choď na Login.
      </p>
    </div>
  );
}
