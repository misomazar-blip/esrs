"use client";

import Link from "next/link";
import { useEffect, useMemo, useState } from "react";
import { createSupabaseBrowserClient } from "@/lib/supabase/client";
import { colors, buttonStyles, cardStyles, fonts, inputStyles, spacing, shadows } from "@/lib/styles";

type Topic = { id: string; code: string; name?: string };
type Company = { id: string; name: string };
type Report = { id: string; reporting_year: number; company_id: string };

export default function TopicsPage() {
  const supabase = createSupabaseBrowserClient();
  const [email, setEmail] = useState<string | null>(null);
  const [userId, setUserId] = useState<string | null>(null);
  const [companies, setCompanies] = useState<Company[]>([]);
  const [companyId, setCompanyId] = useState<string>("");
  const [reports, setReports] = useState<Report[]>([]);
  const [selectedReportId, setSelectedReportId] = useState<string>("");
  const [topics, setTopics] = useState<Topic[]>([]);
  const [err, setErr] = useState<string | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    supabase.auth.getUser().then(({ data }) => {
      if (data.user?.id) {
        setUserId(data.user.id);
        setEmail(data.user.email ?? null);
        loadCompanies(data.user.id);
      } else {
        setErr("Please sign in to view topics.");
        setLoading(false);
      }
    });
  }, []);

  async function loadCompanies(uid: string) {
    setErr(null);
    const { data, error } = await supabase
      .from("company")
      .select("id, name")
      .eq("user_id", uid)
      .order("name");
    if (error) setErr(error.message);
    const list = (data as Company[]) ?? [];
    setCompanies(list);
    const initialCompany = companyId || list[0]?.id || "";
    setCompanyId(initialCompany);
    await Promise.all([loadReports(initialCompany, list), loadTopics()]);
  }

  async function loadReports(activeCompanyId: string, companyList?: Company[]) {
    setLoading(true);
    const list = companyList ?? companies;
    const companyIds = list.map((c) => c.id);
    const { data, error } = await supabase
      .from("report")
      .select("id, reporting_year, company_id")
      .in("company_id", companyIds.length > 0 ? companyIds : ["dummy"])
      .order("reporting_year", { ascending: false });
    if (error) setErr(error.message);
    const reportList = (data as Report[]) ?? [];
    setReports(reportList);
    const initialReport = reportList.find((r) => r.company_id === activeCompanyId)?.id ?? reportList[0]?.id ?? "";
    setSelectedReportId(initialReport);
    setLoading(false);
  }

  async function loadTopics() {
    const { data, error } = await supabase.from("topic").select("id, code, name").order("code");
    if (error) setErr(error.message);
    setTopics((data as Topic[]) ?? []);
  }

  const filteredReports = useMemo(() => {
    if (!companyId) return reports;
    return reports.filter((r) => r.company_id === companyId);
  }, [reports, companyId]);

  const selectedReport = filteredReports.find((r) => r.id === selectedReportId) ?? null;

  useEffect(() => {
    if (filteredReports.length === 0) {
      setSelectedReportId("");
      return;
    }
    if (!selectedReportId || !filteredReports.find((r) => r.id === selectedReportId)) {
      const first = filteredReports[0].id;
      setSelectedReportId(first);
    }
  }, [filteredReports, selectedReportId]);

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
            Topics
          </h1>
          <Link href="/" style={{ ...buttonStyles.secondary, textDecoration: "none", display: "inline-flex", alignItems: "center" }}>
            ← Back to Dashboard
          </Link>
        </div>

        <div style={{ display: "grid", gridTemplateColumns: "repeat(auto-fit, minmax(340px, 1fr))", gap: spacing.lg }}>
          {/* Report selection */}
          <div style={{ ...cardStyles.base }}>
            <h3 style={{ fontSize: fonts.size.lg, fontWeight: fonts.weight.bold, margin: `0 0 ${spacing.md} 0` }}>
              Choose report
            </h3>
            <div style={{ display: "flex", flexDirection: "column", gap: spacing.md }}>
              <div style={{ display: "flex", flexDirection: "column", gap: spacing.xs }}>
                <label style={{ fontSize: fonts.size.sm, color: colors.textSecondary }}>Company</label>
                <select
                  value={companyId}
                  onChange={(e) => {
                    const cid = e.target.value;
                    setCompanyId(cid);
                    const nextReport = reports.find((r) => r.company_id === cid)?.id ?? "";
                    setSelectedReportId(nextReport);
                  }}
                  style={{ ...inputStyles.base, paddingRight: spacing.lg }}
                >
                  <option value="">All companies</option>
                  {companies.map((c) => (
                    <option key={c.id} value={c.id}>
                      {c.name}
                    </option>
                  ))}
                </select>
              </div>

              <div style={{ display: "flex", flexDirection: "column", gap: spacing.xs }}>
                <label style={{ fontSize: fonts.size.sm, color: colors.textSecondary }}>Report</label>
                <select
                  value={selectedReportId}
                  onChange={(e) => setSelectedReportId(e.target.value)}
                  style={{ ...inputStyles.base, paddingRight: spacing.lg }}
                >
                  <option value="">Select report</option>
                  {filteredReports.map((r) => (
                    <option key={r.id} value={r.id}>
                      {r.reporting_year} — {companies.find((c) => c.id === r.company_id)?.name ?? r.company_id}
                    </option>
                  ))}
                </select>
              </div>

              <div style={{ display: "flex", gap: spacing.sm }}>
                <Link
                  href="/report"
                  style={{ ...buttonStyles.secondary, textDecoration: "none", display: "inline-flex", justifyContent: "center", alignItems: "center", flex: 1 }}
                >
                  Manage reports
                </Link>
                <button
                  onClick={() => loadReports(companyId || "", companies)}
                  style={{ ...buttonStyles.secondary, flex: 1 }}
                  disabled={loading}
                >
                  Refresh
                </button>
              </div>
              {err && <div style={{ color: "crimson", fontSize: fonts.size.sm }}>{err}</div>}
            </div>
          </div>

          {/* Topics list */}
          <div style={{ ...cardStyles.base, gridColumn: "1 / -1" }}>
            <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: spacing.md }}>
              <h3 style={{ fontSize: fonts.size.lg, fontWeight: fonts.weight.bold, margin: 0 }}>Topics</h3>
              <span style={{ fontSize: fonts.size.sm, color: colors.textSecondary }}>
                {selectedReportId ? `${topics.length} topics` : "Select report"}
              </span>
            </div>

            {!selectedReportId ? (
              <p style={{ color: colors.textSecondary, margin: 0 }}>Choose a report to open topics.</p>
            ) : topics.length === 0 ? (
              <p style={{ color: colors.textSecondary, margin: 0 }}>No topics available.</p>
            ) : (
              <div style={{ overflowX: "auto" }}>
                <table style={{ width: "100%", borderCollapse: "collapse" }}>
                  <thead>
                    <tr>
                      <th style={tableHeaderCell}>Code</th>
                      <th style={tableHeaderCell}>Name</th>
                      <th style={tableHeaderCell}>Action</th>
                    </tr>
                  </thead>
                  <tbody>
                    {topics.map((t) => (
                      <tr key={t.id}>
                        <td style={{ ...tableCell, fontWeight: fonts.weight.semibold }}>
                          <span style={{ fontFamily: "monospace", color: colors.textSecondary }}>{t.code}</span>
                        </td>
                        <td style={tableCell}>{t.name ?? ""}</td>
                        <td style={tableCell}>
                          {t.code.toLowerCase() === "g1" ? (
                            <Link href={`/topics/g1?reportId=${selectedReportId}`} style={{ ...buttonStyles.secondary, textDecoration: "none", padding: `${spacing.xs} ${spacing.md}` }}>
                              Open
                            </Link>
                          ) : (
                            <span style={{ color: colors.textSecondary, fontSize: fonts.size.sm }}>(MVP only G1)</span>
                          )}
                        </td>
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
