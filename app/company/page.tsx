"use client";

import Link from "next/link";
import { useEffect, useState } from "react";
import { createSupabaseBrowserClient } from "@/lib/supabase/client";
import { colors, buttonStyles, inputStyles, cardStyles, fonts, spacing, shadows } from "@/lib/styles";

type Company = {
  id: string;
  name: string;
  country_code: string | null;
  industry_code: string | null;
  created_at?: string;
};

export default function CompanyPage() {
  const supabase = createSupabaseBrowserClient();
  const [userId, setUserId] = useState<string | null>(null);
  const [email, setEmail] = useState<string | null>(null);
  const [companies, setCompanies] = useState<Company[]>([]);
  const [reportCounts, setReportCounts] = useState<Record<string, number>>({});
  const [name, setName] = useState("");
  const [country, setCountry] = useState("");
  const [industry, setIndustry] = useState("");
  const [err, setErr] = useState<string | null>(null);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);

  useEffect(() => {
    supabase.auth.getUser().then(({ data }) => {
      if (data.user?.id) {
        setUserId(data.user.id);
        setEmail(data.user.email ?? null);
        loadCompanies(data.user.id);
      } else {
        setErr("Please sign in to manage companies.");
        setLoading(false);
      }
    });
  }, []);

  async function loadCompanies(uid: string) {
    setErr(null);
    setLoading(true);
    const { data, error } = await supabase
      .from("company")
      .select("id, name, country_code, industry_code, created_at")
      .eq("user_id", uid)
      .order("created_at", { ascending: false });

    if (error) setErr(error.message);
    setCompanies((data as Company[]) ?? []);
    const ids = ((data as Company[]) ?? []).map((c) => c.id);
    if (ids.length > 0) await loadReportCounts(ids);
    else setReportCounts({});
    setLoading(false);
  }

  async function loadReportCounts(companyIds: string[]) {
    const { data, error } = await supabase
      .from("report")
      .select("company_id, reporting_year")
      .in("company_id", companyIds);

    if (error) return;
    const counts: Record<string, number> = {};
    (data ?? []).forEach((r: any) => {
      const cid = r.company_id as string;
      if (!counts[cid]) counts[cid] = 0;
      counts[cid] += 1;
    });
    setReportCounts(counts);
  }

  async function createCompany() {
    setErr(null);
    if (!userId) {
      setErr("Please sign in first.");
      return;
    }
    if (!name.trim()) {
      setErr("Name is required.");
      return;
    }

    setSaving(true);
    const { error } = await supabase.from("company").insert({
      name: name.trim(),
      country_code: country.trim() || null,
      industry_code: industry.trim() || null,
      user_id: userId,
    });
    setSaving(false);

    if (error) {
      setErr(error.message);
      return;
    }

    setName("");
    setCountry("");
    setIndustry("");
    await loadCompanies(userId);
  }

  const tableHeaderCell = {
    textAlign: "left" as const,
    fontSize: fonts.size.sm,
    color: colors.textSecondary,
    padding: `${spacing.sm} ${spacing.md}`,
    borderBottom: `1px solid ${colors.borderGray}`,
  };

  const tableCell = {
    fontSize: fonts.size.body,
    color: colors.textPrimary,
    padding: `${spacing.sm} ${spacing.md}`,
    borderBottom: `1px solid ${colors.borderGray}`,
  };

  return (
    <div
      style={{
        minHeight: "100vh",
        backgroundColor: colors.bgPrimary,
      }}
    >
      {/* TOP NAVIGATION (shared look) */}
      <div
        style={{
          borderBottom: `1px solid ${colors.borderGray}`,
          boxShadow: shadows.sm,
          backgroundColor: colors.white,
        }}
      >
        <div
          style={{
            display: "flex",
            justifyContent: "space-between",
            alignItems: "center",
            padding: `${spacing.md} ${spacing.xl}`,
            maxWidth: "1200px",
            margin: "0 auto",
          }}
        >
          <Link
            href="/"
            style={{
              fontSize: fonts.size.h3,
              fontWeight: fonts.weight.bold,
              margin: 0,
              color: colors.primary,
              textDecoration: "none",
            }}
          >
            ESRS
          </Link>

          <div
            style={{
              display: "flex",
              alignItems: "center",
              gap: spacing.lg,
            }}
          >
            {/* USER INFO */}
            <div
              style={{
                display: "flex",
                alignItems: "center",
                gap: spacing.sm,
                padding: `${spacing.sm} ${spacing.md}`,
                borderRadius: "6px",
                backgroundColor: colors.bgSecondary,
              }}
            >
              <span
                style={{
                  fontSize: fonts.size.sm,
                  color: colors.textSecondary,
                  fontWeight: fonts.weight.semibold,
                }}
              >
                User
              </span>
              <div
                style={{
                  width: "32px",
                  height: "32px",
                  borderRadius: "50%",
                  backgroundColor: colors.primary,
                  display: "flex",
                  alignItems: "center",
                  justifyContent: "center",
                  color: colors.white,
                  fontWeight: fonts.weight.bold,
                  fontSize: fonts.size.sm,
                }}
              >
                {email?.[0]?.toUpperCase()}
              </div>
              <span
                style={{
                  fontSize: fonts.size.sm,
                  color: colors.textPrimary,
                  fontWeight: fonts.weight.medium,
                  maxWidth: "150px",
                  overflow: "hidden",
                  textOverflow: "ellipsis",
                  whiteSpace: "nowrap",
                }}
              >
                {email}
              </span>
            </div>

            {/* SIGN OUT BUTTON */}
            <button
              onClick={async () => {
                await supabase.auth.signOut();
                window.location.href = "/";
              }}
              style={buttonStyles.danger}
            >
              Sign Out
            </button>
          </div>
        </div>
      </div>

      <div
        style={{
          maxWidth: "1200px",
          margin: "0 auto",
          display: "flex",
          flexDirection: "column",
          gap: spacing.xl,
          padding: `${spacing.xl} ${spacing.xl}`,
        }}
      >
        <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center" }}>
          <h1 style={{ fontSize: fonts.size.h2, fontWeight: fonts.weight.bold, margin: 0, color: colors.textPrimary }}>
            Companies
          </h1>
          <Link href="/" style={{ ...buttonStyles.secondary, textDecoration: "none", display: "inline-flex", alignItems: "center" }}>
            ← Back to Dashboard
          </Link>
        </div>

        <div style={{ display: "grid", gridTemplateColumns: "repeat(auto-fit, minmax(320px, 1fr))", gap: spacing.lg }}>
          {/* Create form */}
          <div style={{ ...cardStyles.base }}>
            <h3 style={{ fontSize: fonts.size.lg, fontWeight: fonts.weight.bold, margin: `0 0 ${spacing.md} 0` }}>
              Add a company
            </h3>
            <div style={{ display: "flex", flexDirection: "column", gap: spacing.md }}>
              <div style={{ display: "flex", flexDirection: "column", gap: spacing.xs }}>
                <label style={{ fontSize: fonts.size.sm, color: colors.textSecondary }}>Name *</label>
                <input
                  value={name}
                  onChange={(e) => setName(e.target.value)}
                  placeholder="Company name"
                  style={inputStyles.base}
                />
              </div>
              <div style={{ display: "flex", gap: spacing.md }}>
                <div style={{ flex: 1, display: "flex", flexDirection: "column", gap: spacing.xs }}>
                  <label style={{ fontSize: fonts.size.sm, color: colors.textSecondary }}>Country code</label>
                  <input
                    value={country}
                    onChange={(e) => setCountry(e.target.value.toUpperCase())}
                    placeholder="e.g. SK"
                    maxLength={2}
                    style={{ ...inputStyles.base, textTransform: "uppercase" }}
                  />
                </div>
                <div style={{ flex: 1, display: "flex", flexDirection: "column", gap: spacing.xs }}>
                  <label style={{ fontSize: fonts.size.sm, color: colors.textSecondary }}>Industry code</label>
                  <input
                    value={industry}
                    onChange={(e) => setIndustry(e.target.value)}
                    placeholder="e.g. C10"
                    style={inputStyles.base}
                  />
                </div>
              </div>
              <div style={{ display: "flex", gap: spacing.sm }}>
                <button onClick={createCompany} style={{ ...buttonStyles.primary, flex: 1 }} disabled={saving}>
                  {saving ? "Creating..." : "+ Create company"}
                </button>
                <button
                  onClick={() => userId && loadCompanies(userId)}
                  style={buttonStyles.secondary}
                  disabled={loading}
                >
                  Refresh
                </button>
              </div>
              {err && <div style={{ color: "crimson", fontSize: fonts.size.sm }}>{err}</div>}
            </div>
          </div>

          {/* List */}
          <div style={{ ...cardStyles.base }}>
            <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: spacing.md }}>
              <h3 style={{ fontSize: fonts.size.lg, fontWeight: fonts.weight.bold, margin: 0 }}>Your companies</h3>
              <span style={{ fontSize: fonts.size.sm, color: colors.textSecondary }}>
                {loading ? "Loading..." : `${companies.length} total`}
              </span>
            </div>

            {companies.length === 0 && !loading ? (
              <p style={{ color: colors.textSecondary, margin: 0 }}>No companies yet. Create one to get started.</p>
            ) : (
              <div style={{ overflowX: "auto" }}>
                <table style={{ width: "100%", borderCollapse: "collapse" }}>
                  <thead>
                    <tr>
                      <th style={tableHeaderCell}>Name</th>
                      <th style={tableHeaderCell}>Country</th>
                      <th style={tableHeaderCell}>Reports (years)</th>
                    </tr>
                  </thead>
                  <tbody>
                    {companies.map((c) => (
                      <tr key={c.id}>
                        <td style={{ ...tableCell, fontWeight: fonts.weight.semibold }}>{c.name}</td>
                        <td style={tableCell}>{c.country_code ?? "—"}</td>
                        <td style={tableCell}>{reportCounts[c.id] ?? 0}</td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            )}
          </div>
        </div>
      </div>
    </div>
  );
}
