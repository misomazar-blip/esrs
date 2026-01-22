"use client";

import { useEffect, useState } from "react";
import { createSupabaseBrowserClient } from "@/lib/supabase/client";

type Company = {
  id: string;
  name: string;
  created_at?: string;
};

export default function CompanyPage() {
  const supabase = createSupabaseBrowserClient();
  const [name, setName] = useState("");
  const [companies, setCompanies] = useState<Company[]>([]);
  const [err, setErr] = useState<string | null>(null);

  async function load() {
    setErr(null);
    const { data, error } = await supabase
      .from("company")
      .select("id, name, created_at")
      .order("created_at", { ascending: false });

    if (error) setErr(error.message);
    setCompanies((data as Company[]) ?? []);
  }

  useEffect(() => {
    load();
  }, []);

  async function createCompany() {
    setErr(null);
    if (!name.trim()) return;

    const { data: authData } = await supabase.auth.getUser();
    if (!authData?.user) {
      setErr("Not authenticated");
      return;
    }

    const { error } = await supabase.from("company").insert({
      name: name.trim(),
      user_id: authData.user.id,
    });
    if (error) {
      setErr(error.message);
      return;
    }

    setName("");
    await load();
  }

  return (
    <div style={{ display: "grid", gap: 12, maxWidth: 900 }}>
      <h2>Company</h2>

      <div style={{ display: "flex", gap: 8 }}>
        <input
          value={name}
          onChange={(e) => setName(e.target.value)}
          placeholder="Company name"
          style={{ flex: 1 }}
        />
        <button onClick={createCompany}>Create</button>
        <button onClick={load}>Refresh</button>
      </div>

      {err && <div style={{ color: "crimson" }}>{err}</div>}

      <table border={1} cellPadding={8}>
        <thead>
          <tr>
            <th>ID</th>
            <th>Name</th>
            <th>Created</th>
          </tr>
        </thead>
        <tbody>
          {companies.map((c) => (
            <tr key={c.id}>
              <td style={{ fontFamily: "monospace" }}>{c.id}</td>
              <td>{c.name}</td>
              <td>{c.created_at ?? ""}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
