"use client";

import Link from "next/link";
import { useEffect, useState } from "react";
import { createSupabaseBrowserClient } from "@/lib/supabase/client";
import { colors, buttonStyles, inputStyles, cardStyles, fonts, spacing, shadows, layouts } from "@/lib/styles";

type Company = { id: string; name: string; country_code: string | null; industry_code: string | null };
type Report = { id: string; reporting_year: number; status: string };
type ReportTopic = { topic_id: string; is_material: boolean };

export default function HomePage() {
  const supabase = createSupabaseBrowserClient();
  const [email, setEmail] = useState<string | null>(null);
  const [userId, setUserId] = useState<string | null>(null);
  const [isAuthenticated, setIsAuthenticated] = useState(false);
  const [loading, setLoading] = useState(true);

  const [companies, setCompanies] = useState<Company[]>([]);
  const [selectedCompanyId, setSelectedCompanyId] = useState<string | null>(null);
  const [company, setCompany] = useState<Company | null>(null);
  const [report, setReport] = useState<Report | null>(null);
  const [reports, setReports] = useState<Report[]>([]);
  const [selectedReportId, setSelectedReportId] = useState<string | null>(null);
  const [materialTopics, setMaterialTopics] = useState(0);
  const [g1Progress, setG1Progress] = useState({ answered: 0, total: 0 });

  const [loginEmail, setLoginEmail] = useState("");
  const [loginPassword, setLoginPassword] = useState("");
  const [registerEmail, setRegisterEmail] = useState("");
  const [registerPassword, setRegisterPassword] = useState("");
  const [msg, setMsg] = useState<string | null>(null);
  const [mode, setMode] = useState<"login" | "register">("login");

  useEffect(() => {
    supabase.auth.getUser().then(({ data }) => {
      if (data.user?.email) {
        setEmail(data.user.email);
        setUserId(data.user.id);
        setIsAuthenticated(true);
        loadCompanies(data.user.id);
      }
      setLoading(false);
    });
  }, []);

  async function loadCompanies(uid: string) {
    const { data } = await supabase
      .from("company")
      .select("id, name, country_code, industry_code")
      .eq("user_id", uid)
      .order("created_at", { ascending: false });

    const list = (data as Company[] | null) ?? [];
    setCompanies(list);

    const stored = typeof window !== "undefined" ? localStorage.getItem("selectedCompanyId") : null;
    const initial = stored && list.find((c) => c.id === stored) ? stored : list[0]?.id ?? null;

    if (initial) {
      setSelectedCompanyId(initial);
      if (typeof window !== "undefined") localStorage.setItem("selectedCompanyId", initial);
      await loadDashboardData(initial, list);
    } else {
      setCompany(null);
      setReport(null);
      setReports([]);
      setSelectedReportId(null);
      setMaterialTopics(0);
      setG1Progress({ answered: 0, total: 0 });
    }
  }

  async function loadDashboardData(companyId: string, companyListOverride?: Company[]) {
    const companyList = companyListOverride ?? companies;

    // Active company (fallback fetch if not in memory)
    let selected = companyList.find((c) => c.id === companyId) ?? null;
    if (!selected) {
      const { data: oneCompany } = await supabase
        .from("company")
        .select("id, name, country_code, industry_code")
        .eq("id", companyId)
        .maybeSingle();
      selected = (oneCompany as Company) ?? null;
    }
    setCompany(selected);

    // All reports for this company (sorted by year desc for UX)
    const { data: reportsData } = await supabase
      .from("report")
      .select("id, reporting_year, status")
      .eq("company_id", companyId)
      .order("reporting_year", { ascending: false });

    const reportList = (reportsData as Report[] | null) ?? [];
    setReports(reportList);

    const storageKey = `selectedReportId:${companyId}`;
    const storedReportId = typeof window !== "undefined" ? localStorage.getItem(storageKey) : null;
    const initialReportId =
      (storedReportId && reportList.find((r) => r.id === storedReportId)?.id) ?? reportList[0]?.id ?? null;

    setSelectedReportId(initialReportId);
    if (initialReportId && typeof window !== "undefined") localStorage.setItem(storageKey, initialReportId);

    const activeReport = initialReportId ? reportList.find((r) => r.id === initialReportId) ?? null : null;
    await loadReportDetails(activeReport);
  }

  async function loadReportDetails(activeReport: Report | null) {
    setReport(activeReport ?? null);

    if (!activeReport) {
      setMaterialTopics(0);
      setG1Progress({ answered: 0, total: 0 });
      return;
    }

    // Material topics count
    const { data: reportTopics } = await supabase
      .from("report_topic")
      .select("topic_id, is_material")
      .eq("report_id", activeReport.id);
    const materialCount = (reportTopics ?? []).filter((rt) => rt.is_material).length;
    setMaterialTopics(materialCount);

    // G1 progress: fetch questions for G1, then answers for those question_ids
    const { data: g1Topic } = await supabase
      .from("topic")
      .select("id")
      .eq("code", "G1")
      .maybeSingle();

    if (!g1Topic) {
      setG1Progress({ answered: 0, total: 0 });
      return;
    }

    const { data: questions } = await supabase
      .from("disclosure_question")
      .select("id")
      .eq("topic_id", g1Topic.id);

    const questionIds = (questions ?? []).map((q: any) => q.id);
    if (questionIds.length === 0) {
      setG1Progress({ answered: 0, total: 0 });
      return;
    }

    const { data: answers } = await supabase
      .from("disclosure_answer")
      .select("question_id")
      .eq("report_id", activeReport.id)
      .in("question_id", questionIds);

    const answeredCount = (answers ?? []).length;
    const totalCount = questionIds.length;
    setG1Progress({ answered: answeredCount, total: totalCount });
  }

  async function handleSignIn() {
    setMsg(null);
    const { error } = await supabase.auth.signInWithPassword({
      email: loginEmail,
      password: loginPassword,
    });
    if (error) {
      setMsg(`Sign in failed: ${error.message}`);
      return;
    }
    window.location.href = "/";
  }

  async function handleSignUp() {
    setMsg(null);
    const { error } = await supabase.auth.signUp({
      email: registerEmail,
      password: registerPassword,
    });
    if (error) {
      setMsg(`Sign up failed: ${error.message}`);
      return;
    }
    setMsg("Sign up successful! Check your email to confirm.");
    setRegisterEmail("");
    setRegisterPassword("");
  }

  async function signOut() {
    await supabase.auth.signOut();
    window.location.href = "/";
  }

  if (loading) {
    return (
      <div
        style={{
          padding: spacing.xl,
          fontSize: fonts.size.body,
          color: colors.textSecondary,
        }}
      >
        Loading...
      </div>
    );
  }

  // Prihláseného usera
  if (isAuthenticated) {
    return (
      <div
        style={{
          minHeight: "100vh",
          backgroundColor: colors.bgPrimary,
        }}
      >
        {/* TOP NAVIGATION */}
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
            <h1
              style={{
                fontSize: fonts.size.h3,
                fontWeight: fonts.weight.bold,
                margin: 0,
                color: colors.primary,
              }}
            >
              ESRS
            </h1>

            <div
              style={{
                display: "flex",
                alignItems: "center",
                gap: spacing.lg,
              }}
            >
              {/* COMPANY SELECTOR */}
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
                  Company
                </span>
                <select
                  value={selectedCompanyId ?? ""}
                  onChange={(e) => {
                    const val = e.target.value || null;
                    if (val === "__new__") {
                      window.location.href = "/company";
                      return;
                    }
                    setSelectedCompanyId(val);
                    if (val) {
                      if (typeof window !== "undefined") localStorage.setItem("selectedCompanyId", val);
                      loadDashboardData(val);
                    }
                  }}
                  style={{
                    padding: `${spacing.sm} ${spacing.md}`,
                    border: `1px solid ${colors.borderGray}`,
                    borderRadius: "6px",
                    fontSize: fonts.size.body,
                    backgroundColor: colors.white,
                    minWidth: "200px",
                  }}
                >
                  {companies.length === 0 && <option value="">No company</option>}
                  {companies.map((c) => (
                    <option key={c.id} value={c.id}>
                      {c.name}
                    </option>
                  ))}
                  <option value="__new__">+ New company…</option>
                </select>
              </div>

              {/* REPORT YEAR SELECTOR */}
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
                  Report year
                </span>
                <select
                  value={selectedReportId ?? ""}
                  onChange={(e) => {
                    const val = e.target.value || null;
                    if (val === "__new_report__") {
                      const target = selectedCompanyId
                        ? `/report?companyId=${selectedCompanyId}`
                        : "/report";
                      window.location.href = target;
                      return;
                    }
                    setSelectedReportId(val);
                    if (selectedCompanyId && val && typeof window !== "undefined") {
                      localStorage.setItem(`selectedReportId:${selectedCompanyId}`, val);
                    }
                    const nextReport = reports.find((r) => r.id === val) ?? null;
                    loadReportDetails(nextReport);
                  }}
                  style={{
                    padding: `${spacing.sm} ${spacing.md}`,
                    border: `1px solid ${colors.borderGray}`,
                    borderRadius: "6px",
                    fontSize: fonts.size.body,
                    backgroundColor: colors.white,
                    minWidth: "160px",
                  }}
                >
                  {reports.length === 0 && (
                    <option value="" disabled>
                      No reports yet
                    </option>
                  )}
                  {reports.map((r) => (
                    <option key={r.id} value={r.id}>
                      {r.reporting_year} ({r.status})
                    </option>
                  ))}
                  <option value="__new_report__">+ New year…</option>
                </select>
              </div>

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
              <button onClick={signOut} style={buttonStyles.danger}>
                Sign Out
              </button>
            </div>
          </div>
        </div>

        {/* MAIN CONTENT */}
        <div
          style={{
            padding: spacing.xl,
            maxWidth: "1200px",
            margin: "0 auto",
          }}
        >
          <h2
            style={{
              fontSize: fonts.size.h2,
              fontWeight: fonts.weight.bold,
              marginBottom: spacing.xl,
              color: colors.textPrimary,
            }}
          >
            Dashboard
          </h2>

          {/* QUICK OVERVIEW CARDS */}
          <div
            style={{
              display: "grid",
              gridTemplateColumns: "repeat(auto-fit, minmax(280px, 1fr))",
              gap: spacing.lg,
              marginBottom: spacing.xxl,
            }}
          >
            {/* COMPANY CARD */}
            <div style={{ ...cardStyles.base, display: "flex", flexDirection: "column" }}>
              <h3 style={{ fontSize: fonts.size.lg, fontWeight: fonts.weight.bold, margin: `0 0 ${spacing.md} 0` }}>
                📋 Company
              </h3>
              {company ? (
                <div style={{ display: "flex", flexDirection: "column", flex: 1 }}>
                  <div style={{ flex: 1 }}>
                    <p style={{ margin: `0 0 ${spacing.sm} 0`, color: colors.textSecondary, fontSize: fonts.size.sm }}>
                      Name
                    </p>
                    <p style={{ margin: 0, fontSize: fonts.size.body, fontWeight: fonts.weight.semibold, color: colors.textPrimary }}>
                      {company.name}
                    </p>
                    {company.country_code && (
                      <p style={{ margin: `${spacing.sm} 0 0 0`, color: colors.textSecondary, fontSize: fonts.size.sm }}>
                        Country: {company.country_code}
                      </p>
                    )}
                  </div>
                  <Link href="/company">
                    <button style={{ ...buttonStyles.secondary, width: "100%", marginTop: spacing.md }}>
                      View All
                    </button>
                  </Link>
                </div>
              ) : (
                <p style={{ color: colors.textSecondary }}>No company yet</p>
              )}
            </div>

            {/* REPORT CARD */}
            <div style={{ ...cardStyles.base, display: "flex", flexDirection: "column" }}>
              <h3 style={{ fontSize: fonts.size.lg, fontWeight: fonts.weight.bold, margin: `0 0 ${spacing.md} 0` }}>
                📊 Report
              </h3>
              {report ? (
                <div style={{ display: "flex", flexDirection: "column", flex: 1 }}>
                  <div style={{ flex: 1 }}>
                    <p style={{ margin: `0 0 ${spacing.sm} 0`, color: colors.textSecondary, fontSize: fonts.size.sm }}>
                      Reporting Year
                    </p>
                    <p style={{ margin: 0, fontSize: fonts.size.body, fontWeight: fonts.weight.semibold, color: colors.textPrimary }}>
                      {report.reporting_year}
                    </p>
                    <p style={{ margin: `${spacing.sm} 0 0 0`, color: colors.textSecondary, fontSize: fonts.size.sm }}>
                      Status: <b>{report.status}</b>
                    </p>
                    <p style={{ margin: `${spacing.sm} 0 0 0`, color: colors.textSecondary, fontSize: fonts.size.sm }}>
                      Material topics: <b style={{ color: colors.primary }}>{materialTopics}</b>
                    </p>
                  </div>
                  <Link href="/report">
                    <button style={{ ...buttonStyles.secondary, width: "100%", marginTop: spacing.md }}>
                      View report
                    </button>
                  </Link>
                </div>
              ) : (
                <p style={{ color: colors.textSecondary }}>No report yet</p>
              )}
            </div>

            {/* G1 PROGRESS CARD */}
            <div style={{ ...cardStyles.base, display: "flex", flexDirection: "column" }}>
              <h3 style={{ fontSize: fonts.size.lg, fontWeight: fonts.weight.bold, margin: `0 0 ${spacing.md} 0` }}>
                📚 G1 Progress
              </h3>
              {report && g1Progress.total > 0 ? (
                <div style={{ display: "flex", flexDirection: "column", flex: 1 }}>
                  <div style={{ flex: 1 }}>
                    <p style={{ margin: `0 0 ${spacing.sm} 0`, color: colors.textSecondary, fontSize: fonts.size.sm }}>
                      Questions Answered
                    </p>
                    <p style={{ margin: 0, fontSize: fonts.size.h3, fontWeight: fonts.weight.bold, color: colors.success }}>
                      {g1Progress.answered}/{g1Progress.total}
                    </p>
                    <div
                      style={{
                        width: "100%",
                        height: "8px",
                        backgroundColor: colors.borderGray,
                        borderRadius: "4px",
                        marginTop: spacing.md,
                        overflow: "hidden",
                      }}
                    >
                      <div
                        style={{
                          height: "100%",
                          backgroundColor: colors.success,
                          width: `${g1Progress.total > 0 ? (g1Progress.answered / g1Progress.total) * 100 : 0}%`,
                          transition: "width 0.3s ease",
                        }}
                      />
                    </div>
                  </div>
                  <Link href="/topics">
                    <button style={{ ...buttonStyles.secondary, width: "100%", marginTop: spacing.md }}>
                      Complete
                    </button>
                  </Link>
                </div>
              ) : (
                <p style={{ color: colors.textSecondary }}>No report yet</p>
              )}
            </div>
          </div>

          {/* ACTION BUTTONS */}
          <h3 style={{ fontSize: fonts.size.lg, fontWeight: fonts.weight.bold, marginBottom: spacing.lg }}>
            Quick Actions
          </h3>
          <div style={{ display: "grid", gridTemplateColumns: "repeat(auto-fit, minmax(200px, 1fr))", gap: spacing.lg }}>
            <Link href="/company">
              <button style={{ ...buttonStyles.primary, width: "100%", padding: spacing.lg }}>
                + New Company
              </button>
            </Link>
            <Link href="/report">
              <button style={{ ...buttonStyles.primary, width: "100%", padding: spacing.lg }}>
                + New Report
              </button>
            </Link>
            <Link href="/materiality">
              <button style={{ ...buttonStyles.primary, width: "100%", padding: spacing.lg }}>
                Assess Materiality
              </button>
            </Link>
            <Link href="/topics">
              <button style={{ ...buttonStyles.primary, width: "100%", padding: spacing.lg }}>
                Fill Topics
              </button>
            </Link>
          </div>
        </div>
      </div>
    );
  }

  // Neprihlásený user - Login/Register forma
  return (
    <div
      style={{
        display: "flex",
        justifyContent: "center",
        alignItems: "center",
        minHeight: "100vh",
        padding: spacing.xl,
        backgroundColor: colors.bgSecondary,
      }}
    >
      <div
        style={{
          ...cardStyles.base,
          maxWidth: "400px",
          width: "100%",
          padding: spacing.xxl,
        }}
      >
        {mode === "login" ? (
          <>
            <div style={{ textAlign: "center", marginBottom: spacing.xxl }}>
              <p
                style={{
                  fontSize: fonts.size.body,
                  fontWeight: fonts.weight.normal,
                  color: colors.textPrimary,
                  margin: `0 0 ${spacing.md} 0`,
                  opacity: 0.75,
                }}
              >
                Make ESRS simple
              </p>
              <h2
                style={{
                  fontSize: fonts.size.h2,
                  fontWeight: fonts.weight.bold,
                  margin: 0,
                  color: colors.textPrimary,
                }}
              >
                Please Sign In
              </h2>
            </div>

            <div style={{ display: "grid", gap: spacing.md, marginBottom: spacing.xl }}>
              <input
                value={loginEmail}
                onChange={(e) => setLoginEmail(e.target.value)}
                placeholder="Email"
                type="email"
                style={inputStyles.base}
              />
              <input
                value={loginPassword}
                onChange={(e) => setLoginPassword(e.target.value)}
                onKeyDown={(e) => {
                  if (e.key === "Enter") {
                    handleSignIn();
                  }
                }}
                placeholder="Password"
                type="password"
                style={inputStyles.base}
              />
              <button onClick={handleSignIn} style={buttonStyles.primary}>
                Sign In
              </button>
            </div>

            <div style={{ textAlign: "center", fontSize: fonts.size.sm, color: colors.textSecondary }}>
              Don't have an account?{" "}
              <button
                onClick={() => {
                  setMode("register");
                  setMsg(null);
                }}
                style={{
                  background: "none",
                  border: "none",
                  color: colors.primary,
                  fontWeight: fonts.weight.semibold,
                  cursor: "pointer",
                  textDecoration: "underline",
                  fontSize: "inherit",
                }}
              >
                Register
              </button>
            </div>
          </>
        ) : (
          <>
            <div style={{ textAlign: "center", marginBottom: spacing.xxl }}>
              <p
                style={{
                  fontSize: fonts.size.body,
                  fontWeight: fonts.weight.normal,
                  color: colors.textPrimary,
                  margin: `0 0 ${spacing.md} 0`,
                  opacity: 0.75,
                }}
              >
                Make ESRS simple
              </p>
              <h2
                style={{
                  fontSize: fonts.size.h2,
                  fontWeight: fonts.weight.bold,
                  margin: 0,
                  color: colors.textPrimary,
                }}
              >
                Create Account
              </h2>
            </div>

            <div style={{ display: "grid", gap: spacing.md, marginBottom: spacing.xl }}>
              <input
                value={registerEmail}
                onChange={(e) => setRegisterEmail(e.target.value)}
                placeholder="Email"
                type="email"
                style={inputStyles.base}
              />
              <input
                value={registerPassword}
                onChange={(e) => setRegisterPassword(e.target.value)}
                onKeyDown={(e) => {
                  if (e.key === "Enter") {
                    handleSignUp();
                  }
                }}
                placeholder="Password"
                type="password"
                style={inputStyles.base}
              />
              <button onClick={handleSignUp} style={buttonStyles.primary}>
                Register
              </button>
            </div>

            <div style={{ textAlign: "center", fontSize: fonts.size.sm, color: colors.textSecondary }}>
              Already have an account?{" "}
              <button
                onClick={() => {
                  setMode("login");
                  setMsg(null);
                }}
                style={{
                  background: "none",
                  border: "none",
                  color: colors.primary,
                  fontWeight: fonts.weight.semibold,
                  cursor: "pointer",
                  textDecoration: "underline",
                  fontSize: "inherit",
                }}
              >
                Sign In
              </button>
            </div>
          </>
        )}

        {msg && (
          <div
            style={{
              marginTop: spacing.lg,
              padding: spacing.md,
              backgroundColor: msg.includes("failed") ? colors.errorLight : colors.successLight,
              color: msg.includes("failed") ? colors.error : colors.success,
              borderRadius: "6px",
              fontSize: fonts.size.sm,
            }}
          >
            {msg}
          </div>
        )}
      </div>
    </div>
  );
}
