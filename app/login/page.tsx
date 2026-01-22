"use client";

import { useState } from "react";
import { createSupabaseBrowserClient } from "@/lib/supabase/client";

export default function LoginPage() {
  const supabase = createSupabaseBrowserClient();
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [msg, setMsg] = useState<string | null>(null);

  async function signIn() {
    setMsg(null);
    const { error } = await supabase.auth.signInWithPassword({ email, password });
    if (error) {
      setMsg(error.message);
      return;
    }
    window.location.href = "/";
  }

  return (
    <div style={{ display: "grid", gap: 10, maxWidth: 360 }}>
      <h2>Login</h2>

      <input value={email} onChange={(e) => setEmail(e.target.value)} placeholder="email" />
      <input
        value={password}
        onChange={(e) => setPassword(e.target.value)}
        placeholder="password"
        type="password"
      />

      <button onClick={signIn}>Sign in</button>
      {msg && <div style={{ color: "crimson" }}>{msg}</div>}
    </div>
  );
}
