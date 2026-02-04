"use client";

import Link from "next/link";
import { useEffect, useState } from "react";
import { createSupabaseBrowserClient } from "@/lib/supabase/client";
import { colors, buttonStyles, inputStyles, cardStyles, fonts, spacing, shadows, layouts } from "@/lib/styles";

type Company = { id: string; name: string; country_code: string | null; industry_code: string | null; address: string | null; city: string | null; postal_code: string | null; identification_number: string | null };
type Report = { id: string; reporting_year: number; status: string };
type ReportTopic = { topic_id: string; is_material: boolean };
type Topic = { id: string; code: string; name: string | null };
type MaterialTopicProgress = { topicId: string; code: string; name: string | null; answered: number; total: number; mandatoryAnswered: number; mandatoryTotal: number };

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
  const [materialTopicsProgress, setMaterialTopicsProgress] = useState<MaterialTopicProgress[]>([]);
  const [activeVersion, setActiveVersion] = useState<string | null>(null);
  const [dropdownOpen, setDropdownOpen] = useState(false);

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
      .select("id, name, country_code, industry_code, address, city, postal_code, identification_number")
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
      setMaterialTopicsProgress([]);
    }
  }

  async function loadDashboardData(companyId: string, companyListOverride?: Company[]) {
    const companyList = companyListOverride ?? companies;

    // Active company (fallback fetch if not in memory)
    let selected = companyList.find((c) => c.id === companyId) ?? null;
    if (!selected) {
      const { data: oneCompany } = await supabase
        .from("company")
        .select("id, name, country_code, industry_code, address, city, postal_code, identification_number")
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
      setMaterialTopicsProgress([]);
      setActiveVersion(null);
      return;
    }

    // Get active ESRS version
    const { data: versionData } = await supabase
      .from("esrs_version")
      .select("id, version_name")
      .eq("is_active", true)
      .maybeSingle();

    const activeVersionId = versionData?.id;
    setActiveVersion(versionData?.version_name ?? null);

    // Get material topics with details
    const { data: reportTopics } = await supabase
      .from("report_topic")
      .select("topic_id, is_material")
      .eq("report_id", activeReport.id)
      .eq("is_material", true);

    const materialTopicIds = (reportTopics ?? []).map((rt) => rt.topic_id);
    setMaterialTopics(materialTopicIds.length);

    if (materialTopicIds.length === 0) {
      setMaterialTopicsProgress([]);
      return;
    }

    // Get topic details
    const { data: topics } = await supabase
      .from("topic")
      .select("id, code, name")
      .in("id", materialTopicIds);

    const topicsList = (topics as Topic[]) ?? [];

    // Calculate progress for each material topic
    const progressPromises = topicsList.map(async (topic) => {
      // Get questions for this topic (filtered by active version)
      const { data: questions } = await supabase
        .from("disclosure_question")
        .select("id, is_mandatory")
        .eq("topic_id", topic.id)
        .eq("version_id", activeVersionId);

      const allQuestions = questions ?? [];
      const questionIds = allQuestions.map((q: any) => q.id);
      const mandatoryQuestions = allQuestions.filter((q: any) => q.is_mandatory);
      
      if (questionIds.length === 0) {
        return {
          topicId: topic.id,
          code: topic.code,
          name: topic.name,
          answered: 0,
          total: 0,
          mandatoryAnswered: 0,
          mandatoryTotal: 0,
        };
      }

      // Get answers for these questions (check if has any value)
      const { data: answers } = await supabase
        .from("disclosure_answer")
        .select("question_id, value_text, value_numeric, value_boolean, value_date")
        .eq("report_id", activeReport.id)
        .in("question_id", questionIds);

      // Count answered (has any value set)
      const answeredCount = (answers ?? []).filter((a: any) => 
        (a.value_text && a.value_text.trim()) || 
        a.value_numeric !== null || 
        a.value_boolean !== null || 
        a.value_date
      ).length;

      const mandatoryAnswered = (answers ?? []).filter((a: any) => 
        mandatoryQuestions.some((q: any) => q.id === a.question_id) &&
        ((a.value_text && a.value_text.trim()) || 
         a.value_numeric !== null || 
         a.value_boolean !== null || 
         a.value_date)
      ).length;

      return {
        topicId: topic.id,
        code: topic.code,
        name: topic.name,
        answered: answeredCount,
        total: questionIds.length,
        mandatoryAnswered,
        mandatoryTotal: mandatoryQuestions.length,
      };
    });

    const progress = await Promise.all(progressPromises);
    setMaterialTopicsProgress(progress);
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
              {/* Selectors moved to respective cards below */}
              
              {/* USER DROPDOWN */}
              <div style={{ position: "relative" }}>
                <div
                  onClick={() => setDropdownOpen(!dropdownOpen)}
                  style={{
                    display: "flex",
                    alignItems: "center",
                    gap: spacing.md,
                    cursor: "pointer",
                    padding: spacing.sm,
                    borderRadius: "8px",
                    transition: "background-color 0.2s",
                    backgroundColor: dropdownOpen ? colors.bgSecondary : "transparent",
                  }}
                  onMouseEnter={(e) => {
                    if (!dropdownOpen) e.currentTarget.style.backgroundColor = colors.bgSecondary;
                  }}
                  onMouseLeave={(e) => {
                    if (!dropdownOpen) e.currentTarget.style.backgroundColor = "transparent";
                  }}
                >
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
                  <span style={{ fontSize: "10px", color: colors.textSecondary }}>▼</span>
                </div>

                {/* DROPDOWN MENU */}
                {dropdownOpen && (
                  <div
                    style={{
                      position: "absolute",
                      top: "calc(100% + 8px)",
                      right: 0,
                      backgroundColor: colors.white,
                      border: `1px solid ${colors.borderGray}`,
                      borderRadius: "8px",
                      boxShadow: shadows.md,
                      minWidth: "180px",
                      zIndex: 1000,
                      overflow: "hidden",
                    }}
                  >
                    <Link
                      href="/profile"
                      style={{
                        display: "block",
                        padding: `${spacing.sm} ${spacing.md}`,
                        fontSize: fonts.size.sm,
                        color: colors.textPrimary,
                        textDecoration: "none",
                        transition: "background-color 0.2s",
                      }}
                      onMouseEnter={(e) => (e.currentTarget.style.backgroundColor = colors.bgSecondary)}
                      onMouseLeave={(e) => (e.currentTarget.style.backgroundColor = "transparent")}
                    >
                      Edit Profile
                    </Link>
                    <button
                      onClick={signOut}
                      style={{
                        display: "block",
                        width: "100%",
                        padding: `${spacing.sm} ${spacing.md}`,
                        fontSize: fonts.size.sm,
                        color: colors.error,
                        textAlign: "left",
                        border: "none",
                        backgroundColor: "transparent",
                        cursor: "pointer",
                        transition: "background-color 0.2s",
                      }}
                      onMouseEnter={(e) => (e.currentTarget.style.backgroundColor = colors.bgSecondary)}
                      onMouseLeave={(e) => (e.currentTarget.style.backgroundColor = "transparent")}
                    >
                      Sign Out
                    </button>
                  </div>
                )}
              </div>
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
              
              {/* Company Selector */}
              <div style={{ marginBottom: spacing.md }}>
                <label style={{ display: "block", marginBottom: spacing.xs, fontSize: fonts.size.sm, color: colors.textSecondary, fontWeight: fonts.weight.semibold }}>
                  Select Company
                </label>
                <select
                  value={selectedCompanyId ?? ""}
                  onChange={(e) => {
                    const val = e.target.value || null;
                    setSelectedCompanyId(val);
                    if (val) {
                      if (typeof window !== "undefined") localStorage.setItem("selectedCompanyId", val);
                      loadDashboardData(val);
                    }
                  }}
                  style={{
                    ...inputStyles.base,
                    width: "100%",
                  }}
                >
                  {companies.length === 0 && <option value="">No company</option>}
                  {companies.map((c) => (
                    <option key={c.id} value={c.id}>
                      {c.name}
                    </option>
                  ))}
                </select>
              </div>

              {company ? (
                <div style={{ display: "flex", flexDirection: "column", flex: 1 }}>
                  <div style={{ flex: 1 }}>
                    <h4 style={{ 
                      margin: `0 0 ${spacing.md} 0`, 
                      fontSize: fonts.size.lg, 
                      fontWeight: fonts.weight.bold, 
                      color: colors.textPrimary 
                    }}>
                      {company.name}
                    </h4>
                    
                    {/* Company ID */}
                    <div style={{ marginBottom: spacing.sm }}>
                      <span style={{ fontSize: fonts.size.sm, color: colors.textSecondary }}>ID: </span>
                      <span style={{ fontSize: fonts.size.sm, color: colors.textPrimary, fontWeight: fonts.weight.medium }}>
                        {company.identification_number || "—"}
                      </span>
                    </div>
                    
                    {/* Address */}
                    <div style={{ marginBottom: spacing.sm }}>
                      <span style={{ fontSize: fonts.size.sm, color: colors.textSecondary }}>📍 Address: </span>
                      <span style={{ fontSize: fonts.size.sm, color: colors.textPrimary }}>
                        {company.address || "—"}
                        {company.city && `, ${company.city}`}
                        {company.postal_code && ` ${company.postal_code}`}
                      </span>
                    </div>
                    
                    {/* Country */}
                    <div style={{ marginBottom: spacing.sm }}>
                      <span style={{ fontSize: fonts.size.sm, color: colors.textSecondary }}>Country: </span>
                      <span style={{ fontSize: fonts.size.sm, color: colors.textPrimary }}>
                        {company.country_code || "—"}
                      </span>
                    </div>
                  </div>
                  <Link href="/company">
                    <button style={{ ...buttonStyles.secondary, width: "100%", marginTop: spacing.md }}>
                      Manage Companies
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
              
              {/* Report Year Selector */}
              <div style={{ marginBottom: spacing.md }}>
                <label style={{ display: "block", marginBottom: spacing.xs, fontSize: fonts.size.sm, color: colors.textSecondary, fontWeight: fonts.weight.semibold }}>
                  Select Report Year
                </label>
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
                    ...inputStyles.base,
                    width: "100%",
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
                  <option value="__new_report__">+ Create New Report</option>
                </select>
              </div>

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
                    {activeVersion && (
                      <p style={{ margin: `${spacing.sm} 0 0 0`, color: colors.textSecondary, fontSize: fonts.size.sm }}>
                        ESRS Version: <b style={{ color: colors.primary }}>{activeVersion}</b>
                      </p>
                    )}
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
          </div>

          {/* MATERIAL TOPICS SECTION */}
          {materialTopicsProgress.length > 0 && (
            <>
              <h3 style={{ fontSize: fonts.size.lg, fontWeight: fonts.weight.bold, marginTop: spacing.xl, marginBottom: spacing.lg }}>
                � Overall Progress
              </h3>
              
              {/* Overall Progress Card */}
              <div style={{ ...cardStyles.base, marginBottom: spacing.xl }}>
                <div style={{ display: "grid", gridTemplateColumns: "repeat(auto-fit, minmax(200px, 1fr))", gap: spacing.lg }}>
                  {(() => {
                    const totalAnswered = materialTopicsProgress.reduce((sum, t) => sum + t.answered, 0);
                    const totalQuestions = materialTopicsProgress.reduce((sum, t) => sum + t.total, 0);
                    const totalMandatoryAnswered = materialTopicsProgress.reduce((sum, t) => sum + t.mandatoryAnswered, 0);
                    const totalMandatory = materialTopicsProgress.reduce((sum, t) => sum + t.mandatoryTotal, 0);
                    const overallPercent = totalQuestions > 0 ? Math.round((totalAnswered / totalQuestions) * 100) : 0;
                    const mandatoryPercent = totalMandatory > 0 ? Math.round((totalMandatoryAnswered / totalMandatory) * 100) : 100;

                    return (
                      <>
                        {/* All Questions */}
                        <div>
                          <p style={{ margin: `0 0 ${spacing.xs} 0`, fontSize: fonts.size.sm, color: colors.textSecondary }}>
                            All Questions
                          </p>
                          <p style={{ margin: `0 0 ${spacing.sm} 0`, fontSize: fonts.size.h2, fontWeight: fonts.weight.bold, color: colors.textPrimary }}>
                            {totalAnswered}/{totalQuestions}
                          </p>
                          <div style={{ 
                            width: "100%", 
                            height: "8px", 
                            backgroundColor: colors.borderGray, 
                            borderRadius: "4px", 
                            overflow: "hidden" 
                          }}>
                            <div style={{ 
                              height: "100%", 
                              backgroundColor: colors.primary, 
                              width: `${overallPercent}%`,
                              transition: "width 0.3s ease" 
                            }} />
                          </div>
                          <p style={{ margin: `${spacing.xs} 0 0 0`, fontSize: fonts.size.sm, color: colors.textSecondary }}>
                            {overallPercent}% complete
                          </p>
                        </div>

                        {/* Mandatory Questions */}
                        <div>
                          <p style={{ margin: `0 0 ${spacing.xs} 0`, fontSize: fonts.size.sm, color: colors.textSecondary }}>
                            ★ Mandatory Questions
                          </p>
                          <p style={{ margin: `0 0 ${spacing.sm} 0`, fontSize: fonts.size.h2, fontWeight: fonts.weight.bold, color: mandatoryPercent === 100 ? colors.success : colors.error }}>
                            {totalMandatoryAnswered}/{totalMandatory}
                          </p>
                          <div style={{ 
                            width: "100%", 
                            height: "8px", 
                            backgroundColor: colors.borderGray, 
                            borderRadius: "4px", 
                            overflow: "hidden" 
                          }}>
                            <div style={{ 
                              height: "100%", 
                              backgroundColor: mandatoryPercent === 100 ? colors.success : colors.error, 
                              width: `${mandatoryPercent}%`,
                              transition: "width 0.3s ease" 
                            }} />
                          </div>
                          <p style={{ margin: `${spacing.xs} 0 0 0`, fontSize: fonts.size.sm, color: colors.textSecondary }}>
                            {mandatoryPercent}% complete
                          </p>
                        </div>

                        {/* Material Topics */}
                        <div>
                          <p style={{ margin: `0 0 ${spacing.xs} 0`, fontSize: fonts.size.sm, color: colors.textSecondary }}>
                            Material Topics
                          </p>
                          <p style={{ margin: `0 0 ${spacing.sm} 0`, fontSize: fonts.size.h2, fontWeight: fonts.weight.bold, color: colors.primary }}>
                            {materialTopics}
                          </p>
                          <p style={{ margin: `${spacing.sm} 0 0 0`, fontSize: fonts.size.sm, color: colors.textSecondary }}>
                            topics assessed
                          </p>
                        </div>
                      </>
                    );
                  })()}
                </div>
              </div>

              <h3 style={{ fontSize: fonts.size.lg, fontWeight: fonts.weight.bold, marginBottom: spacing.lg }}>
                📋 Material Topics
              </h3>
              <div style={{ display: "grid", gridTemplateColumns: "repeat(auto-fit, minmax(280px, 1fr))", gap: spacing.lg }}>
                {materialTopicsProgress.map((topicProgress) => {
                  const percent = topicProgress.total > 0 ? Math.round((topicProgress.answered / topicProgress.total) * 100) : 0;
                  const mandatoryPercent = topicProgress.mandatoryTotal > 0 ? Math.round((topicProgress.mandatoryAnswered / topicProgress.mandatoryTotal) * 100) : 100;
                  const isComplete = topicProgress.answered === topicProgress.total;
                  const mandatoryComplete = topicProgress.mandatoryAnswered === topicProgress.mandatoryTotal;

                  return (
                    <Link
                      key={topicProgress.topicId}
                      href={`/topics/${topicProgress.code.toLowerCase()}?reportId=${selectedReportId}`}
                      style={{ textDecoration: "none" }}
                    >
                      <div
                        style={{
                          ...cardStyles.base,
                          display: "flex",
                          flexDirection: "column",
                          cursor: "pointer",
                          transition: "transform 0.2s ease, box-shadow 0.2s ease",
                          borderLeft: `4px solid ${isComplete ? colors.success : mandatoryComplete ? colors.primary : colors.error}`,
                        }}
                        onMouseEnter={(e) => {
                          e.currentTarget.style.transform = "translateY(-2px)";
                          e.currentTarget.style.boxShadow = shadows.md;
                        }}
                        onMouseLeave={(e) => {
                          e.currentTarget.style.transform = "translateY(0)";
                          e.currentTarget.style.boxShadow = shadows.sm;
                        }}
                      >
                        <h4 style={{ fontSize: fonts.size.md, fontWeight: fonts.weight.bold, margin: `0 0 ${spacing.sm} 0`, color: colors.primary }}>
                          <span style={{ fontFamily: "monospace" }}>{topicProgress.code}</span> {topicProgress.name}
                        </h4>
                        
                        {/* All Questions */}
                        <div style={{ marginBottom: spacing.md }}>
                          <p style={{ margin: `0 0 ${spacing.xs} 0`, color: colors.textSecondary, fontSize: fonts.size.sm }}>
                            All Questions
                          </p>
                          <p style={{ margin: 0, fontSize: fonts.size.h3, fontWeight: fonts.weight.bold, color: isComplete ? colors.success : colors.textPrimary }}>
                            {topicProgress.answered}/{topicProgress.total}
                          </p>
                          <div
                            style={{
                              width: "100%",
                              height: "8px",
                              backgroundColor: colors.borderGray,
                              borderRadius: "4px",
                              marginTop: spacing.sm,
                              overflow: "hidden",
                            }}
                          >
                            <div
                              style={{
                                height: "100%",
                                backgroundColor: isComplete ? colors.success : colors.primary,
                                width: `${percent}%`,
                                transition: "width 0.3s ease",
                              }}
                            />
                          </div>
                          <p style={{ margin: `${spacing.xs} 0 0 0`, fontSize: fonts.size.xs, color: colors.textSecondary }}>
                            {percent}%
                          </p>
                        </div>

                        {/* Mandatory Questions */}
                        {topicProgress.mandatoryTotal > 0 && (
                          <div>
                            <p style={{ margin: `0 0 ${spacing.xs} 0`, color: colors.textSecondary, fontSize: fonts.size.sm }}>
                              ★ Mandatory
                            </p>
                            <p style={{ margin: 0, fontSize: fonts.size.body, fontWeight: fonts.weight.semibold, color: mandatoryComplete ? colors.success : colors.error }}>
                              {topicProgress.mandatoryAnswered}/{topicProgress.mandatoryTotal}
                            </p>
                            <div
                              style={{
                                width: "100%",
                                height: "6px",
                                backgroundColor: colors.borderGray,
                                borderRadius: "4px",
                                marginTop: spacing.xs,
                                overflow: "hidden",
                              }}
                            >
                              <div
                                style={{
                                  height: "100%",
                                  backgroundColor: mandatoryComplete ? colors.success : colors.error,
                                  width: `${mandatoryPercent}%`,
                                  transition: "width 0.3s ease",
                                }}
                              />
                            </div>
                            {!mandatoryComplete && (
                              <p style={{ margin: `${spacing.xs} 0 0 0`, fontSize: fonts.size.xs, color: colors.error, fontWeight: fonts.weight.semibold }}>
                                ⚠️ Missing mandatory fields
                              </p>
                            )}
                          </div>
                        )}
                      </div>
                    </Link>
                  );
                })}
              </div>
            </>
          )}

          {/* ACTION BUTTONS */}
          <h3 style={{ fontSize: fonts.size.lg, fontWeight: fonts.weight.bold, marginTop: spacing.xl, marginBottom: spacing.lg }}>
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
            <Link href="/report">
              <button style={{ ...buttonStyles.primary, width: "100%", padding: spacing.lg }}>
                View Report
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
