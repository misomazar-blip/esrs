"use client";

import Link from "next/link";
import { useEffect, useMemo, useState } from "react";
import { useSearchParams } from "next/navigation";
import { createSupabaseBrowserClient } from "@/lib/supabase/client";
import { colors, buttonStyles, inputStyles, cardStyles, fonts, spacing, shadows } from "@/lib/styles";

type Topic = { id: string; code: string; name?: string };
type Company = { id: string; name: string };
type Report = { id: string; reporting_year: number; company_id: string };
type ReportTopic = {
  report_id: string;
  topic_id: string;
  is_material: boolean;
  materiality: string | null;
  rationale: string | null;
};

export default function MaterialityPage() {
  const supabase = createSupabaseBrowserClient();
  const searchParams = useSearchParams();
  const reportIdFromUrl = searchParams.get("reportId");

  const [email, setEmail] = useState<string | null>(null);
  const [userId, setUserId] = useState<string | null>(null);
  const [companies, setCompanies] = useState<Company[]>([]);
  const [companyId, setCompanyId] = useState<string>("");
  const [reports, setReports] = useState<Report[]>([]);
  const [reportId, setReportId] = useState<string>(reportIdFromUrl ?? "");
  const [topics, setTopics] = useState<Topic[]>([]);
  const [reportTopics, setReportTopics] = useState<ReportTopic[]>([]);
  const [err, setErr] = useState<string | null>(null);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);

  const rtMap = useMemo(() => {
    const m = new Map<string, ReportTopic>();
    reportTopics.forEach((rt) => m.set(rt.topic_id, rt));
    return m;
  }, [reportTopics]);

  useEffect(() => {
    supabase.auth.getUser().then(({ data }) => {
      if (data.user?.id) {
        setUserId(data.user.id);
        setEmail(data.user.email ?? null);
        loadCompanies(data.user.id);
      } else {
        setErr("Please sign in to manage materiality.");
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
    await loadReports(initialCompany, list);
    await loadTopics();
  }

  async function loadReports(activeCompanyId: string, companyList?: Company[]) {
    const list = companyList ?? companies;
    const companyIds = list.map((c) => c.id);
    setLoading(true);
    const { data, error } = await supabase
      .from("report")
      .select("id, reporting_year, company_id")
      .in("company_id", companyIds.length > 0 ? companyIds : ["dummy"])
      .order("reporting_year", { ascending: false });
    if (error) setErr(error.message);
    const reportList = (data as Report[]) ?? [];
    setReports(reportList);

    const initialReport =
      reportIdFromUrl && reportList.find((r) => r.id === reportIdFromUrl)
        ? reportIdFromUrl
        : reportList.find((r) => r.company_id === activeCompanyId)?.id ?? reportList[0]?.id ?? "";

    setReportId(initialReport);
    if (initialReport) await loadReportTopics(initialReport);
    setLoading(false);
  }

  async function loadTopics() {
    const { data, error } = await supabase
      .from("topic")
      .select("id, code, name")
      .order("code");
    if (error) setErr(error.message);
    setTopics((data as Topic[]) ?? []);
  }

  async function loadReportTopics(rid: string) {
    if (!rid) return;
    const { data, error } = await supabase
      .from("report_topic")
      .select("report_id, topic_id, is_material, materiality, rationale")
      .eq("report_id", rid);
    if (error) setErr(error.message);
    setReportTopics((data as ReportTopic[]) ?? []);
  }

  async function setMaterial(topicId: string, isMaterial: boolean) {
    if (!reportId) return;
    setSaving(true);
    const existing = rtMap.get(topicId);

    if (!existing) {
      const { error } = await supabase.from("report_topic").insert({
        report_id: reportId,
        topic_id: topicId,
        is_material: isMaterial,
        materiality: isMaterial ? "impact" : null,
        rationale: null,
      });
      if (error) setErr(error.message);
    } else {
      const { error } = await supabase
        .from("report_topic")
        .update({ is_material: isMaterial })
        .eq("report_id", reportId)
        .eq("topic_id", topicId);
      if (error) setErr(error.message);
    }

    await loadReportTopics(reportId);
    setSaving(false);
  }

  const filteredReports = useMemo(() => {
    if (!companyId) return reports;
    return reports.filter((r) => r.company_id === companyId);
  }, [reports, companyId]);

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
            Materiality
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
                    setReportId(nextReport);
                    if (nextReport) loadReportTopics(nextReport);
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
                  value={reportId}
                  onChange={(e) => {
                    const rid = e.target.value;
                    setReportId(rid);
                    if (rid) loadReportTopics(rid);
                  }}
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
                <button
                  onClick={() => reportId && loadReportTopics(reportId)}
                  style={{ ...buttonStyles.secondary, flex: 1 }}
                  disabled={!reportId || loading}
                >
                  Refresh
                </button>
                <Link
                  href="/report"
                  style={{ ...buttonStyles.primary, textDecoration: "none", display: "inline-flex", justifyContent: "center", alignItems: "center", flex: 1 }}
                >
                  + New report
                </Link>
              </div>
              {err && <div style={{ color: "crimson", fontSize: fonts.size.sm }}>{err}</div>}
            </div>
          </div>

          {/* Topics list */}
          <div style={{ ...cardStyles.base }}>
            <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: spacing.md }}>
              <h3 style={{ fontSize: fonts.size.lg, fontWeight: fonts.weight.bold, margin: 0 }}>Topics</h3>
              <span style={{ fontSize: fonts.size.sm, color: colors.textSecondary }}>
                {reportId ? `${reportTopics.length} marked` : "Select report"}
              </span>
            </div>

            {!reportId ? (
              <p style={{ color: colors.textSecondary, margin: 0 }}>Choose a report to manage materiality.</p>
            ) : topics.length === 0 ? (
              <p style={{ color: colors.textSecondary, margin: 0 }}>No topics available.</p>
            ) : (
              <div style={{ overflowX: "auto" }}>
                <table style={{ width: "100%", borderCollapse: "collapse" }}>
                  <thead>
                    <tr>
                      <th style={tableHeaderCell}>Topic</th>
                      <th style={tableHeaderCell}>Material?</th>
                    </tr>
                  </thead>
                  <tbody>
                    {topics.map((t) => {
                      const rt = rtMap.get(t.id);
                      const checked = rt?.is_material ?? false;
                      return (
                        <tr key={t.id}>
                          <td style={{ ...tableCell, fontWeight: fonts.weight.semibold }}>
                            <span style={{ fontFamily: "monospace", color: colors.textSecondary }}>{t.code}</span> {t.name ?? ""}
                          </td>
                          <td style={tableCell}>
                            <input
                              type="checkbox"
                              checked={checked}
                              onChange={(e) => setMaterial(t.id, e.target.checked)}
                              disabled={saving}
                            />
                          </td>
                        </tr>
                      );
                    })}
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
