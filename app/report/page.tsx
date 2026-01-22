"use client";

import { useEffect, useState } from "react";
import { createSupabaseBrowserClient } from "@/lib/supabase/client";

type Company = { id: string; name: string };
type Report = {
  id: string;
  company_id: string;
  reporting_year: number;
  status: string | null;
  created_at?: string;
};

export default function ReportPage() {
  const supabase = createSupabaseBrowserClient();

  const [companies, setCompanies] = useState<Company[]>([]);
  const [companyId, setCompanyId] = useState("");
  const [year, setYear] = useState<number>(2025);
  const [reports, setReports] = useState<Report[]>([]);
  const [err, setErr] = useState<string | null>(null);

  async function loadCompanies() {
    const { data, error } = await supabase.from("company").select("id, name").order("name");
    if (error) setErr(error.message);
    setCompanies((data as Company[]) ?? []);
    if (!companyId && data?.[0]?.id) setCompanyId(data[0].id);
  }

  async function loadReports() {
    const { data, error } = await supabase
      .from("report")
      .select("id, company_id, reporting_year, status, created_at")
      .order("created_at", { ascending: false });

    if (error) setErr(error.message);
    setReports((data as Report[]) ?? []);
  }

  useEffect(() => {
    loadCompanies();
    loadReports();
  }, []);

  async function createReport() {
    setErr(null);
    if (!companyId) {
      setErr("Select company first.");
      return;
    }
    const { error } = await supabase.from("report").insert({
      company_id: companyId,
      reporting_year: year,
      status: "draft",
    });
    if (error) setErr(error.message);
    await loadReports();
  }

  return (
    <div style={{ display: "grid", gap: 12, maxWidth: 1000 }}>
      <h2>Report</h2>

      <div style={{ display: "flex", gap: 8, flexWrap: "wrap" }}>
        <select value={companyId} onChange={(e) => setCompanyId(e.target.value)}>
          <option value="">-- select company --</option>
          {companies.map((c) => (
            <option key={c.id} value={c.id}>
              {c.name}
            </option>
          ))}
        </select>

        <input
          type="number"
          value={year}
          onChange={(e) => setYear(parseInt(e.target.value, 10))}
          style={{ width: 120 }}
        />

        <button onClick={createReport}>Create report</button>
        <button onClick={loadReports}>Refresh</button>
      </div>

      {err && <div style={{ color: "crimson" }}>{err}</div>}

      <table border={1} cellPadding={8}>
        <thead>
          <tr>
            <th>ID</th>
            <th>Company</th>
            <th>Year</th>
            <th>Status</th>
            <th>Created</th>
          </tr>
        </thead>
        <tbody>
          {reports.map((r) => (
            <tr key={r.id}>
              <td style={{ fontFamily: "monospace" }}>{r.id}</td>
              <td style={{ fontFamily: "monospace" }}>{r.company_id}</td>
              <td>{r.reporting_year}</td>
              <td>{r.status ?? ""}</td>
              <td>{r.created_at ?? ""}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
