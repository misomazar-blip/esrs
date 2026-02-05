"use client";

import Link from "next/link";
import { useEffect, useState, useMemo } from "react";
import { createSupabaseBrowserClient } from "@/lib/supabase/client";
import { colors, buttonStyles, inputStyles, cardStyles, fonts, spacing, shadows } from "@/lib/styles";

type Company = { id: string; name: string };
type Report = { id: string; reporting_year: number; status: string; company_id: string };
type Topic = { id: string; code: string; name: string | null };
type Question = { id: string; code: string; question_text: string; topic_id: string; order_index: number };
type Answer = { question_id: string; value_text: string | null; value_numeric: number | null; updated_at: string };
type ComparisonData = {
  question: Question;
  topic: Topic;
  oldAnswer: Answer | null;
  newAnswer: Answer | null;
  status: "unchanged" | "changed" | "added" | "removed";
};

type TopicComparison = {
  topic: Topic;
  status: "both" | "added" | "removed";
};

export default function ComparisonPage() {
  const supabase = createSupabaseBrowserClient();
  const [email, setEmail] = useState<string | null>(null);
  const [loading, setLoading] = useState(true);
  const [comparing, setComparing] = useState(false);
  const [dropdownOpen, setDropdownOpen] = useState(false);

  const [companies, setCompanies] = useState<Company[]>([]);
  const [reports, setReports] = useState<Report[]>([]);
  const [topics, setTopics] = useState<Topic[]>([]);
  
  const [selectedCompanyId, setSelectedCompanyId] = useState<string>("");
  const [oldReportId, setOldReportId] = useState<string>("");
  const [newReportId, setNewReportId] = useState<string>("");
  
  const [comparisonData, setComparisonData] = useState<ComparisonData[]>([]);
  const [topicComparison, setTopicComparison] = useState<TopicComparison[]>([]);
  const [filterStatus, setFilterStatus] = useState<"all" | "changed" | "added" | "removed" | "unchanged">("all");
  const [searchTerm, setSearchTerm] = useState("");

  useEffect(() => {
    supabase.auth.getUser().then(({ data }) => {
      if (data.user?.email) {
        setEmail(data.user.email);
        loadCompanies(data.user.id);
      }
      setLoading(false);
    });
  }, []);

  async function loadCompanies(userId: string) {
    const { data } = await supabase
      .from("company")
      .select("id, name")
      .eq("user_id", userId)
      .order("name");
    
    if (data) setCompanies(data);
  }

  useEffect(() => {
    if (selectedCompanyId) {
      loadReports(selectedCompanyId);
    } else {
      setReports([]);
      setOldReportId("");
      setNewReportId("");
    }
  }, [selectedCompanyId]);

  async function loadReports(companyId: string) {
    const { data } = await supabase
      .from("report")
      .select("id, reporting_year, status, company_id")
      .eq("company_id", companyId)
      .order("reporting_year", { ascending: false });
    
    if (data) setReports(data);
  }

  async function runComparison() {
    if (!oldReportId || !newReportId) {
      alert("Please select both reports to compare");
      return;
    }

    if (oldReportId === newReportId) {
      alert("Please select different reports");
      return;
    }

    setComparing(true);
    setComparisonData([]);
    setTopicComparison([]);

    try {
      // Get active version
      const { data: versionData } = await supabase
        .from("esrs_version")
        .select("id")
        .eq("is_active", true)
        .maybeSingle();

      const versionId = versionData?.id;
      if (!versionId) {
        alert("No active ESRS version found");
        setComparing(false);
        return;
      }

      // Get material topics for both reports
      const { data: oldTopics } = await supabase
        .from("report_topic")
        .select("topic_id")
        .eq("report_id", oldReportId)
        .eq("is_material", true);

      const { data: newTopics } = await supabase
        .from("report_topic")
        .select("topic_id")
        .eq("report_id", newReportId)
        .eq("is_material", true);

      const oldTopicIds = (oldTopics ?? []).map(t => t.topic_id);
      const newTopicIds = (newTopics ?? []).map(t => t.topic_id);
      const allTopicIds = Array.from(new Set([...oldTopicIds, ...newTopicIds]));

      if (allTopicIds.length === 0) {
        alert("No material topics found in selected reports");
        setComparing(false);
        return;
      }

      // Load topics
      const { data: topicsData } = await supabase
        .from("topic")
        .select("id, code, name")
        .in("id", allTopicIds);

      setTopics(topicsData ?? []);

      // Build topic comparison
      const topicComp: TopicComparison[] = [];
      for (const topic of topicsData ?? []) {
        const inOld = oldTopicIds.includes(topic.id);
        const inNew = newTopicIds.includes(topic.id);
        
        let status: "both" | "added" | "removed" = "both";
        if (inOld && !inNew) status = "removed";
        else if (!inOld && inNew) status = "added";
        
        topicComp.push({ topic, status });
      }
      setTopicComparison(topicComp);

      // Load all questions for these topics
      const { data: questionsData } = await supabase
        .from("disclosure_question")
        .select("id, code, question_text, topic_id, order_index")
        .in("topic_id", allTopicIds)
        .eq("version_id", versionId)
        .order("order_index");

      const questions = questionsData ?? [];

      // Load answers for old report
      const { data: oldAnswers } = await supabase
        .from("disclosure_answer")
        .select("question_id, value_text, value_numeric, updated_at")
        .eq("report_id", oldReportId);

      const oldAnswerMap = new Map<string, Answer>();
      (oldAnswers ?? []).forEach((a: any) => {
        oldAnswerMap.set(a.question_id, a);
      });

      // Load answers for new report
      const { data: newAnswers } = await supabase
        .from("disclosure_answer")
        .select("question_id, value_text, value_numeric, updated_at")
        .eq("report_id", newReportId);

      const newAnswerMap = new Map<string, Answer>();
      (newAnswers ?? []).forEach((a: any) => {
        newAnswerMap.set(a.question_id, a);
      });

      // Build comparison data
      const comparison: ComparisonData[] = [];

      for (const question of questions) {
        const topic = topicsData?.find(t => t.id === question.topic_id);
        if (!topic) continue;

        const oldAnswer = oldAnswerMap.get(question.id) ?? null;
        const newAnswer = newAnswerMap.get(question.id) ?? null;

        const oldValue = (oldAnswer?.value_text?.trim() || oldAnswer?.value_numeric?.toString() || "").toLowerCase();
        const newValue = (newAnswer?.value_text?.trim() || newAnswer?.value_numeric?.toString() || "").toLowerCase();

        let status: "unchanged" | "changed" | "added" | "removed" = "unchanged";

        if (!oldValue && !newValue) {
          status = "unchanged"; // Both empty
        } else if (!oldValue && newValue) {
          status = "added"; // New answer added
        } else if (oldValue && !newValue) {
          status = "removed"; // Answer removed
        } else if (oldValue !== newValue) {
          status = "changed"; // Answer changed
        }

        comparison.push({
          question,
          topic,
          oldAnswer,
          newAnswer,
          status,
        });
      }

      setComparisonData(comparison);
    } catch (error: any) {
      console.error("Comparison error:", error);
      alert("Error running comparison: " + error.message);
    } finally {
      setComparing(false);
    }
  }

  const filteredData = useMemo(() => {
    let data = comparisonData;

    // Filter by status
    if (filterStatus !== "all") {
      data = data.filter(d => d.status === filterStatus);
    }

    // Filter by search term
    if (searchTerm.trim()) {
      const term = searchTerm.toLowerCase();
      data = data.filter(d => 
        d.question.question_text?.toLowerCase().includes(term) ||
        d.question.code?.toLowerCase().includes(term) ||
        d.topic.code?.toLowerCase().includes(term) ||
        d.topic.name?.toLowerCase().includes(term)
      );
    }

    return data;
  }, [comparisonData, filterStatus, searchTerm]);

  const stats = useMemo(() => {
    return {
      total: comparisonData.length,
      unchanged: comparisonData.filter(d => d.status === "unchanged").length,
      changed: comparisonData.filter(d => d.status === "changed").length,
      added: comparisonData.filter(d => d.status === "added").length,
      removed: comparisonData.filter(d => d.status === "removed").length,
      topicsAdded: topicComparison.filter(t => t.status === "added").length,
      topicsRemoved: topicComparison.filter(t => t.status === "removed").length,
      topicsBoth: topicComparison.filter(t => t.status === "both").length,
    };
  }, [comparisonData, topicComparison]);

  const oldReport = reports.find(r => r.id === oldReportId);
  const newReport = reports.find(r => r.id === newReportId);

  const getStatusColor = (status: string) => {
    switch (status) {
      case "changed": return colors.warning;
      case "added": return colors.success;
      case "removed": return colors.error;
      default: return colors.textSecondary;
    }
  };

  const getStatusIcon = (status: string) => {
    switch (status) {
      case "changed": return "🔄";
      case "added": return "✅";
      case "removed": return "❌";
      default: return "⚪";
    }
  };

  if (loading) {
    return <div style={{ padding: spacing.xl }}>Loading...</div>;
  }

  if (!email) {
    return (
      <div style={{ padding: spacing.xl, textAlign: "center" }}>
        <p>Please log in to access version comparison</p>
        <Link href="/login">
          <button style={{ ...buttonStyles.primary, marginTop: spacing.md }}>
            Go to Login
          </button>
        </Link>
      </div>
    );
  }

  return (
    <div style={{ minHeight: "100vh", backgroundColor: colors.bgPrimary }}>
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
            maxWidth: "1400px",
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

          <div style={{ display: "flex", alignItems: "center", gap: spacing.lg }}>
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
              <span style={{ fontSize: fonts.size.sm, color: colors.textSecondary, fontWeight: fonts.weight.semibold }}>
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
                  backgroundColor: dropdownOpen ? colors.bgSecondary : "transparent",
                }}
              >
                <span style={{ fontSize: fonts.size.xl }}>▼</span>
              </div>

              {dropdownOpen && (
                <div
                  style={{
                    position: "absolute",
                    top: "100%",
                    right: 0,
                    marginTop: spacing.xs,
                    backgroundColor: colors.white,
                    border: `1px solid ${colors.borderGray}`,
                    borderRadius: "6px",
                    boxShadow: shadows.md,
                    minWidth: "180px",
                    zIndex: 1000,
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
                    }}
                  >
                    Edit Profile
                  </Link>
                  <button
                    onClick={async () => {
                      await supabase.auth.signOut();
                      window.location.href = "/";
                    }}
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
                    }}
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
      <div style={{ maxWidth: "1400px", margin: "0 auto", padding: spacing.xl }}>
        <h1 style={{ fontSize: fonts.size.h1, fontWeight: fonts.weight.bold, marginBottom: spacing.sm }}>
          🔍 Version Comparison
        </h1>
        <p style={{ fontSize: fonts.size.body, color: colors.textSecondary, marginBottom: spacing.xl }}>
          Compare answers between different reporting years to track changes over time
        </p>

        {/* SELECTION CARD */}
        <div style={{ ...cardStyles.base, marginBottom: spacing.xl }}>
          <h3 style={{ fontSize: fonts.size.lg, fontWeight: fonts.weight.bold, marginBottom: spacing.md }}>
            Select Reports to Compare
          </h3>

          {/* Company Selection */}
          <div style={{ marginBottom: spacing.md }}>
            <label style={{ display: "block", marginBottom: spacing.xs, fontSize: fonts.size.sm, color: colors.textSecondary, fontWeight: fonts.weight.semibold }}>
              Company
            </label>
            <select
              value={selectedCompanyId}
              onChange={(e) => setSelectedCompanyId(e.target.value)}
              style={{ ...inputStyles.base, width: "100%" }}
            >
              <option value="">Select company</option>
              {companies.map((c) => (
                <option key={c.id} value={c.id}>
                  {c.name}
                </option>
              ))}
            </select>
          </div>

          <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: spacing.lg, marginBottom: spacing.lg }}>
            {/* Old Report */}
            <div>
              <label style={{ display: "block", marginBottom: spacing.xs, fontSize: fonts.size.sm, color: colors.textSecondary, fontWeight: fonts.weight.semibold }}>
                📅 Older Report (Baseline)
              </label>
              <select
                value={oldReportId}
                onChange={(e) => setOldReportId(e.target.value)}
                disabled={!selectedCompanyId}
                style={{ ...inputStyles.base, width: "100%" }}
              >
                <option value="">Select older report</option>
                {reports.filter(r => r.id !== newReportId).map((r) => (
                  <option key={r.id} value={r.id}>
                    {r.reporting_year} ({r.status})
                  </option>
                ))}
              </select>
            </div>

            {/* New Report */}
            <div>
              <label style={{ display: "block", marginBottom: spacing.xs, fontSize: fonts.size.sm, color: colors.textSecondary, fontWeight: fonts.weight.semibold }}>
                📅 Newer Report (Current)
              </label>
              <select
                value={newReportId}
                onChange={(e) => setNewReportId(e.target.value)}
                disabled={!selectedCompanyId}
                style={{ ...inputStyles.base, width: "100%" }}
              >
                <option value="">Select newer report</option>
                {reports.filter(r => r.id !== oldReportId).map((r) => (
                  <option key={r.id} value={r.id}>
                    {r.reporting_year} ({r.status})
                  </option>
                ))}
              </select>
            </div>
          </div>

          <button
            onClick={runComparison}
            disabled={!oldReportId || !newReportId || comparing}
            style={{
              ...buttonStyles.primary,
              width: "100%",
              padding: spacing.lg,
              opacity: (!oldReportId || !newReportId || comparing) ? 0.5 : 1,
            }}
          >
            {comparing ? "Comparing..." : "🔍 Run Comparison"}
          </button>
        </div>

        {/* RESULTS */}
        {comparisonData.length > 0 && (
          <>
            {/* TOPIC CHANGES CARD */}
            {(stats.topicsAdded > 0 || stats.topicsRemoved > 0) && (
              <div style={{ ...cardStyles.base, marginBottom: spacing.xl }}>
                <h3 style={{ fontSize: fonts.size.lg, fontWeight: fonts.weight.bold, marginBottom: spacing.md }}>
                  📋 Material Topics Changes
                </h3>
                
                <div style={{ display: "grid", gridTemplateColumns: "repeat(auto-fit, minmax(200px, 1fr))", gap: spacing.md, marginBottom: spacing.md }}>
                  <div style={{ textAlign: "center", padding: spacing.md, backgroundColor: colors.bgSecondary, borderRadius: "6px" }}>
                    <div style={{ fontSize: fonts.size.h2, fontWeight: fonts.weight.bold, color: colors.textPrimary }}>
                      {topicComparison.length}
                    </div>
                    <div style={{ fontSize: fonts.size.sm, color: colors.textSecondary }}>Total Topics</div>
                  </div>
                  
                  {stats.topicsAdded > 0 && (
                    <div style={{ textAlign: "center", padding: spacing.md, backgroundColor: colors.successLight, borderRadius: "6px" }}>
                      <div style={{ fontSize: fonts.size.h2, fontWeight: fonts.weight.bold, color: colors.success }}>
                        {stats.topicsAdded}
                      </div>
                      <div style={{ fontSize: fonts.size.sm, color: colors.success }}>✅ Topics Added</div>
                    </div>
                  )}
                  
                  {stats.topicsRemoved > 0 && (
                    <div style={{ textAlign: "center", padding: spacing.md, backgroundColor: colors.errorLight, borderRadius: "6px" }}>
                      <div style={{ fontSize: fonts.size.h2, fontWeight: fonts.weight.bold, color: colors.error }}>
                        {stats.topicsRemoved}
                      </div>
                      <div style={{ fontSize: fonts.size.sm, color: colors.error }}>❌ Topics Removed</div>
                    </div>
                  )}
                  
                  <div style={{ textAlign: "center", padding: spacing.md, backgroundColor: colors.bgSecondary, borderRadius: "6px" }}>
                    <div style={{ fontSize: fonts.size.h2, fontWeight: fonts.weight.bold, color: colors.textPrimary }}>
                      {stats.topicsBoth}
                    </div>
                    <div style={{ fontSize: fonts.size.sm, color: colors.textSecondary }}>Topics in Both</div>
                  </div>
                </div>

                {/* Topic Details */}
                <div style={{ display: "grid", gap: spacing.sm }}>
                  {topicComparison.filter(t => t.status !== "both").map((tc, idx) => (
                    <div
                      key={idx}
                      style={{
                        padding: spacing.sm,
                        backgroundColor: tc.status === "added" ? colors.successLight : colors.errorLight,
                        borderRadius: "6px",
                        display: "flex",
                        alignItems: "center",
                        gap: spacing.sm,
                      }}
                    >
                      <span style={{ fontSize: fonts.size.lg }}>
                        {tc.status === "added" ? "✅" : "❌"}
                      </span>
                      <div style={{ flex: 1 }}>
                        <span style={{ fontWeight: fonts.weight.bold, color: colors.textPrimary }}>
                          {tc.topic.code} — {tc.topic.name}
                        </span>
                      </div>
                      <span
                        style={{
                          padding: `${spacing.xs} ${spacing.sm}`,
                          borderRadius: "4px",
                          backgroundColor: tc.status === "added" ? colors.success : colors.error,
                          color: colors.white,
                          fontSize: fonts.size.xs,
                          fontWeight: fonts.weight.bold,
                          textTransform: "uppercase",
                        }}
                      >
                        {tc.status === "added" ? "NEW MATERIAL" : "NO LONGER MATERIAL"}
                      </span>
                    </div>
                  ))}
                </div>
              </div>
            )}

            {/* STATS CARD */}
            <div style={{ ...cardStyles.base, marginBottom: spacing.xl }}>
              <h3 style={{ fontSize: fonts.size.lg, fontWeight: fonts.weight.bold, marginBottom: spacing.md }}>
                Question-Level Changes: {oldReport?.reporting_year} → {newReport?.reporting_year}
              </h3>
              
              <div style={{ display: "grid", gridTemplateColumns: "repeat(auto-fit, minmax(140px, 1fr))", gap: spacing.md }}>
                <div style={{ textAlign: "center", padding: spacing.md, backgroundColor: colors.bgSecondary, borderRadius: "6px" }}>
                  <div style={{ fontSize: fonts.size.h2, fontWeight: fonts.weight.bold, color: colors.textPrimary }}>
                    {stats.total}
                  </div>
                  <div style={{ fontSize: fonts.size.sm, color: colors.textSecondary }}>Total Questions</div>
                </div>
                
                <div style={{ textAlign: "center", padding: spacing.md, backgroundColor: colors.successLight, borderRadius: "6px", cursor: "pointer" }}
                  onClick={() => setFilterStatus(filterStatus === "added" ? "all" : "added")}>
                  <div style={{ fontSize: fonts.size.h2, fontWeight: fonts.weight.bold, color: colors.success }}>
                    {stats.added}
                  </div>
                  <div style={{ fontSize: fonts.size.sm, color: colors.success }}>✅ Added</div>
                </div>
                
                <div style={{ textAlign: "center", padding: spacing.md, backgroundColor: colors.warningLight, borderRadius: "6px", cursor: "pointer" }}
                  onClick={() => setFilterStatus(filterStatus === "changed" ? "all" : "changed")}>
                  <div style={{ fontSize: fonts.size.h2, fontWeight: fonts.weight.bold, color: colors.warning }}>
                    {stats.changed}
                  </div>
                  <div style={{ fontSize: fonts.size.sm, color: colors.warning }}>🔄 Changed</div>
                </div>
                
                <div style={{ textAlign: "center", padding: spacing.md, backgroundColor: colors.errorLight, borderRadius: "6px", cursor: "pointer" }}
                  onClick={() => setFilterStatus(filterStatus === "removed" ? "all" : "removed")}>
                  <div style={{ fontSize: fonts.size.h2, fontWeight: fonts.weight.bold, color: colors.error }}>
                    {stats.removed}
                  </div>
                  <div style={{ fontSize: fonts.size.sm, color: colors.error }}>❌ Removed</div>
                </div>
                
                <div style={{ textAlign: "center", padding: spacing.md, backgroundColor: colors.bgSecondary, borderRadius: "6px", cursor: "pointer" }}
                  onClick={() => setFilterStatus(filterStatus === "unchanged" ? "all" : "unchanged")}>
                  <div style={{ fontSize: fonts.size.h2, fontWeight: fonts.weight.bold, color: colors.textSecondary }}>
                    {stats.unchanged}
                  </div>
                  <div style={{ fontSize: fonts.size.sm, color: colors.textSecondary }}>⚪ Unchanged</div>
                </div>
              </div>

              {filterStatus !== "all" && (
                <button
                  onClick={() => setFilterStatus("all")}
                  style={{ ...buttonStyles.secondary, marginTop: spacing.md }}
                >
                  Clear Filter
                </button>
              )}
            </div>

            {/* SEARCH & FILTERS */}
            <div style={{ ...cardStyles.base, marginBottom: spacing.xl }}>
              <div style={{ display: "flex", gap: spacing.md, alignItems: "center" }}>
                <div style={{ flex: 1, position: "relative" }}>
                  <input
                    type="text"
                    placeholder="Search questions..."
                    value={searchTerm}
                    onChange={(e) => setSearchTerm(e.target.value)}
                    style={{ ...inputStyles.base, width: "100%", paddingRight: searchTerm ? "40px" : spacing.md }}
                  />
                  {searchTerm && (
                    <button
                      onClick={() => setSearchTerm("")}
                      style={{
                        position: "absolute",
                        right: "8px",
                        top: "50%",
                        transform: "translateY(-50%)",
                        background: "none",
                        border: "none",
                        color: colors.textSecondary,
                        cursor: "pointer",
                        fontSize: fonts.size.lg,
                        padding: "4px 8px",
                      }}
                    >
                      ×
                    </button>
                  )}
                </div>
                <span style={{ fontSize: fonts.size.sm, color: colors.textSecondary, whiteSpace: "nowrap" }}>
                  {filteredData.length} results
                </span>
              </div>
            </div>

            {/* COMPARISON RESULTS */}
            <div style={{ ...cardStyles.base }}>
              <h3 style={{ fontSize: fonts.size.lg, fontWeight: fonts.weight.bold, marginBottom: spacing.md }}>
                Detailed Changes
              </h3>

              {filteredData.length === 0 ? (
                <div style={{ textAlign: "center", padding: spacing.xl, color: colors.textSecondary }}>
                  No results found
                </div>
              ) : (
                <div style={{ display: "flex", flexDirection: "column", gap: spacing.md }}>
                  {filteredData.map((item, idx) => (
                    <div
                      key={idx}
                      style={{
                        border: `2px solid ${getStatusColor(item.status)}`,
                        borderRadius: "8px",
                        padding: spacing.md,
                        backgroundColor: item.status === "unchanged" ? colors.bgSecondary : colors.white,
                      }}
                    >
                      {/* Header */}
                      <div style={{ display: "flex", justifyContent: "space-between", alignItems: "start", marginBottom: spacing.sm }}>
                        <div style={{ flex: 1 }}>
                          <div style={{ display: "flex", alignItems: "center", gap: spacing.sm, marginBottom: spacing.xs }}>
                            <span style={{ fontSize: fonts.size.lg }}>{getStatusIcon(item.status)}</span>
                            <span style={{ fontSize: fonts.size.sm, fontWeight: fonts.weight.bold, color: colors.textSecondary }}>
                              {item.topic.code} — {item.topic.name}
                            </span>
                          </div>
                          <div style={{ fontSize: fonts.size.sm, color: colors.textSecondary, marginBottom: spacing.xs }}>
                            {item.question.code}
                          </div>
                          <div style={{ fontSize: fonts.size.body, color: colors.textPrimary, fontWeight: fonts.weight.medium }}>
                            {item.question.question_text}
                          </div>
                        </div>
                        <div
                          style={{
                            padding: `${spacing.xs} ${spacing.sm}`,
                            borderRadius: "4px",
                            backgroundColor: getStatusColor(item.status),
                            color: colors.white,
                            fontSize: fonts.size.xs,
                            fontWeight: fonts.weight.bold,
                            textTransform: "uppercase",
                          }}
                        >
                          {item.status}
                        </div>
                      </div>

                      {/* Comparison */}
                      <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: spacing.md, marginTop: spacing.md }}>
                        {/* Old Answer */}
                        <div>
                          <div style={{ fontSize: fonts.size.xs, color: colors.textSecondary, fontWeight: fonts.weight.bold, marginBottom: spacing.xs }}>
                            📅 {oldReport?.reporting_year} (Baseline)
                          </div>
                          <div
                            style={{
                              padding: spacing.sm,
                              backgroundColor: item.status === "removed" ? colors.errorLight : colors.bgSecondary,
                              borderRadius: "4px",
                              fontSize: fonts.size.sm,
                              color: colors.textPrimary,
                              minHeight: "60px",
                              whiteSpace: "pre-wrap",
                            }}
                          >
                            {item.oldAnswer?.value_text?.trim() || item.oldAnswer?.value_numeric?.toString() || "[NO ANSWER]"}
                          </div>
                          {item.oldAnswer?.updated_at && (
                            <div style={{ fontSize: fonts.size.xs, color: colors.textSecondary, marginTop: spacing.xs }}>
                              Last updated: {new Date(item.oldAnswer.updated_at).toLocaleString("sk-SK")}
                            </div>
                          )}
                        </div>

                        {/* New Answer */}
                        <div>
                          <div style={{ fontSize: fonts.size.xs, color: colors.textSecondary, fontWeight: fonts.weight.bold, marginBottom: spacing.xs }}>
                            📅 {newReport?.reporting_year} (Current)
                          </div>
                          <div
                            style={{
                              padding: spacing.sm,
                              backgroundColor: item.status === "added" ? colors.successLight : item.status === "changed" ? colors.warningLight : colors.bgSecondary,
                              borderRadius: "4px",
                              fontSize: fonts.size.sm,
                              color: colors.textPrimary,
                              minHeight: "60px",
                              whiteSpace: "pre-wrap",
                            }}
                          >
                            {item.newAnswer?.value_text?.trim() || item.newAnswer?.value_numeric?.toString() || "[NO ANSWER]"}
                          </div>
                          {item.newAnswer?.updated_at && (
                            <div style={{ fontSize: fonts.size.xs, color: colors.textSecondary, marginTop: spacing.xs }}>
                              Last updated: {new Date(item.newAnswer.updated_at).toLocaleString("sk-SK")}
                            </div>
                          )}
                        </div>
                      </div>
                    </div>
                  ))}
                </div>
              )}
            </div>
          </>
        )}
      </div>
    </div>
  );
}
