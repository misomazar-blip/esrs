"use client";

import Link from "next/link";
import React, { useEffect, useMemo, useState } from "react";
import { createSupabaseBrowserClient } from "@/lib/supabase/client";
import { colors, buttonStyles, inputStyles, cardStyles, fonts, spacing, shadows } from "@/lib/styles";

type Company = { id: string; name: string };
type Report = {
  id: string;
  company_id: string;
  reporting_year: number;
  status: string | null;
  created_at?: string;
};

type Topic = { id: string; code: string; name?: string };
type ReportTopic = {
  report_id: string;
  topic_id: string;
  is_material: boolean;
  materiality: string | null;
  rationale: string | null;
};

const STATUS_OPTIONS = ["draft", "submitted", "published"] as const;

export default function ReportPage() {
  const supabase = createSupabaseBrowserClient();

  const [email, setEmail] = useState<string | null>(null);
  const [userId, setUserId] = useState<string | null>(null);
  const [companies, setCompanies] = useState<Company[]>([]);
  const [companyId, setCompanyId] = useState<string>("");
  const [year, setYear] = useState<number>(new Date().getFullYear());
  const [status, setStatus] = useState<string>("draft");
  const [reports, setReports] = useState<Report[]>([]);
  const [selectedReportId, setSelectedReportId] = useState<string>("");
  const [topics, setTopics] = useState<Topic[]>([]);
  const [reportTopics, setReportTopics] = useState<ReportTopic[]>([]);
  const [err, setErr] = useState<string | null>(null);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [expandedTopicId, setExpandedTopicId] = useState<string | null>(null);
  const [rationaleText, setRationaleText] = useState<string>("");
  const [dropdownOpen, setDropdownOpen] = useState(false);

  useEffect(() => {
    supabase.auth.getUser().then(({ data }) => {
      if (data.user?.id) {
        setUserId(data.user.id);
        setEmail(data.user.email ?? null);
        loadCompanies(data.user.id);
      } else {
        setErr("Please sign in to manage reports.");
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
    
    const stored = typeof window !== "undefined" ? localStorage.getItem("selectedCompanyId") : null;
    const initialCompany = (stored && list.find((c) => c.id === stored)?.id) || list[0]?.id || "";
    setCompanyId(initialCompany);
    if (initialCompany && typeof window !== "undefined") localStorage.setItem("selectedCompanyId", initialCompany);
    
    await loadReports(initialCompany, list);
    await loadTopics();
  }

  async function loadReports(activeCompanyId: string, companyList?: Company[]) {
    setLoading(true);
    setErr(null);
    const list = companyList ?? companies;
    const { data, error } = await supabase
      .from("report")
      .select("id, company_id, reporting_year, status, created_at")
      .in("company_id", list.length > 0 ? list.map((c) => c.id) : ["dummy"])
      .order("reporting_year", { ascending: false });

    if (error) setErr(error.message);
    const reportList = (data as Report[]) ?? [];
    setReports(reportList);

    const storageKey = `selectedReportId:${activeCompanyId}`;
    const storedReportId = typeof window !== "undefined" ? localStorage.getItem(storageKey) : null;
    const initialReport =
      (storedReportId && reportList.find((r) => r.id === storedReportId)?.id) ??
      reportList.find((r) => r.company_id === activeCompanyId)?.id ?? reportList[0]?.id ?? "";

    setSelectedReportId(initialReport);
    if (initialReport && typeof window !== "undefined") localStorage.setItem(storageKey, initialReport);
    if (initialReport) await loadReportTopics(initialReport);
    setLoading(false);
  }

  async function loadTopics() {
    const { data, error } = await supabase.from("topic").select("id, code, name").order("code");
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

  async function createReport() {
    setErr(null);
    if (!userId) {
      setErr("Please sign in first.");
      return;
    }
    if (!companyId) {
      setErr("Select company first.");
      return;
    }
    if (!year || Number.isNaN(year)) {
      setErr("Year is required.");
      return;
    }

    setSaving(true);
    const { error } = await supabase.from("report").insert({
      company_id: companyId,
      reporting_year: year,
      status,
    });
    setSaving(false);

    if (error) {
      setErr(error.message);
      return;
    }

    await loadReports(companyId || "", companies);
    setIsModalOpen(false);
    setYear(new Date().getFullYear());
    setStatus("draft");
  }

  const filteredReports = useMemo(() => {
    if (!companyId) return reports;
    return reports.filter((r) => r.company_id === companyId);
  }, [reports, companyId]);

  useEffect(() => {
    if (filteredReports.length === 0) {
      setSelectedReportId("");
      setReportTopics([]);
      return;
    }
    if (!selectedReportId || !filteredReports.find((r) => r.id === selectedReportId)) {
      const first = filteredReports[0].id;
      setSelectedReportId(first);
      loadReportTopics(first);
    }
  }, [filteredReports]);

  const rtMap = useMemo(() => {
    const m = new Map<string, ReportTopic>();
    reportTopics.forEach((rt) => m.set(rt.topic_id, rt));
    return m;
  }, [reportTopics]);

  async function setMaterialityStatus(topicId: string, isMaterial: boolean | null, rationale?: string) {
    if (!selectedReportId) return;
    setSaving(true);
    const existing = rtMap.get(topicId);

    try {
      if (isMaterial === null) {
        // Not assessed - delete via API endpoint (bypasses RLS)
        const response = await fetch("/api/report-topic/delete", {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({ reportId: selectedReportId, topicId }),
        });
        const result = await response.json();
        if (!response.ok) {
          setErr(result.error || "Failed to delete");
        }
      } else if (!existing) {
        const { error } = await supabase.from("report_topic").insert({
          report_id: selectedReportId,
          topic_id: topicId,
          is_material: isMaterial,
          materiality: isMaterial ? "impact" : "not_material",
          rationale: rationale || null,
        });
        if (error) {
          setErr(error.message);
        }
      } else {
        const { error } = await supabase
          .from("report_topic")
          .update({ 
            is_material: isMaterial,
            rationale: rationale !== undefined ? rationale : existing.rationale,
          })
          .eq("report_id", selectedReportId)
          .eq("topic_id", topicId);
        if (error) {
          setErr(error.message);
        }
      }
    } catch (err) {
      setErr("An error occurred");
    }

    await loadReportTopics(selectedReportId);
    setSaving(false);
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
                value={companyId}
                onChange={(e) => {
                  const val = e.target.value;
                  setCompanyId(val);
                  if (val) {
                    if (typeof window !== "undefined") localStorage.setItem("selectedCompanyId", val);
                    loadReports(val);
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
                <option value="">Select company...</option>
                {companies.map((c) => (
                  <option key={c.id} value={c.id}>
                    {c.name}
                  </option>
                ))}
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
                value={selectedReportId}
                onChange={(e) => {
                  const rid = e.target.value;
                  setSelectedReportId(rid);
                  if (rid) {
                    if (companyId && typeof window !== "undefined") {
                      localStorage.setItem(`selectedReportId:${companyId}`, rid);
                    }
                    loadReportTopics(rid);
                  }
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
                <option value="">Select report...</option>
                {filteredReports.map((r) => (
                  <option key={r.id} value={r.id}>
                    {r.reporting_year}
                  </option>
                ))}
              </select>
            </div>

            {/* USER INFO */}
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
            Reports
          </h1>
          <Link href="/" style={{ ...buttonStyles.secondary, textDecoration: "none", display: "inline-flex", alignItems: "center" }}>
            ← Back to Dashboard
          </Link>
        </div>

        {/* Add Report Button */}
        <button
          onClick={() => setIsModalOpen(true)}
          style={{
            ...buttonStyles.success,
            alignSelf: "flex-start",
            fontSize: fonts.size.body,
            fontWeight: fonts.weight.semibold,
          }}
        >
          + Add New Report
        </button>

        {/* Reports List */}
        <div style={{ ...cardStyles.base }}>
          <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: spacing.md }}>
            <h3 style={{ fontSize: fonts.size.lg, fontWeight: fonts.weight.bold, margin: 0 }}>Your reports</h3>
            <span style={{ fontSize: fonts.size.sm, color: colors.textSecondary }}>
              {loading ? "Loading..." : `${filteredReports.length} shown`}
            </span>
          </div>

          {filteredReports.length === 0 && !loading ? (
            <p style={{ color: colors.textSecondary, margin: 0 }}>No reports yet. Create one to get started.</p>
          ) : (
            <div style={{ overflowX: "auto" }}>
              <table style={{ width: "100%", borderCollapse: "collapse" }}>
                <thead>
                  <tr>
                    <th style={tableHeaderCell}>Company</th>
                    <th style={tableHeaderCell}>Year</th>
                    <th style={tableHeaderCell}>Status</th>
                    <th style={tableHeaderCell}>Created</th>
                  </tr>
                </thead>
                <tbody>
                  {filteredReports.map((r) => (
                    <tr
                      key={r.id}
                      style={{
                        backgroundColor: selectedReportId === r.id ? colors.bgSecondary : "transparent",
                        cursor: "pointer",
                      }}
                      onClick={() => {
                        setSelectedReportId(r.id);
                        loadReportTopics(r.id);
                      }}
                    >
                      <td style={{ ...tableCell, fontWeight: fonts.weight.semibold }}>
                        {companies.find((c) => c.id === r.company_id)?.name ?? r.company_id}
                      </td>
                      <td style={tableCell}>{r.reporting_year}</td>
                      <td style={tableCell}>{r.status ?? ""}</td>
                      <td style={tableCell}>{r.created_at ? new Date(r.created_at).toLocaleDateString() : ""}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          )}
        </div>

        {/* Materiality */}
        <div style={{ ...cardStyles.base }}>
          <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: spacing.md }}>
            <h3 style={{ fontSize: fonts.size.lg, fontWeight: fonts.weight.bold, margin: 0 }}>Materiality</h3>
            <span style={{ fontSize: fonts.size.sm, color: colors.textSecondary }}>
              {selectedReportId ? `${reportTopics.length} marked` : "Select a report"}
            </span>
          </div>

          <div style={{ display: "flex", gap: spacing.sm, marginBottom: spacing.md, alignItems: "center", flexWrap: "wrap" }}>
            <span style={{ fontSize: fonts.size.sm, color: colors.textSecondary }}>Report:</span>
            <select
              value={selectedReportId}
              onChange={(e) => {
                const rid = e.target.value;
                setSelectedReportId(rid);
                if (rid) loadReportTopics(rid);
              }}
              style={{ ...inputStyles.base, width: "260px", paddingRight: spacing.lg }}
            >
              <option value="">Select report</option>
              {filteredReports.map((r) => (
                <option key={r.id} value={r.id}>
                  {r.reporting_year} — {companies.find((c) => c.id === r.company_id)?.name ?? r.company_id}
                </option>
              ))}
            </select>
          </div>

          {!selectedReportId ? (
            <p style={{ color: colors.textSecondary, margin: 0 }}>Select a report to manage material topics.</p>
          ) : topics.length === 0 ? (
            <p style={{ color: colors.textSecondary, margin: 0 }}>No topics available.</p>
          ) : (
            <div style={{ overflowX: "auto" }}>
              <table style={{ width: "100%", borderCollapse: "collapse" }}>
                <thead>
                  <tr>
                    <th style={tableHeaderCell}>Topic</th>
                    <th style={{ ...tableHeaderCell, minWidth: "300px" }}>Assessment</th>
                  </tr>
                </thead>
                <tbody>
                  {topics.map((t) => {
                    const rt = rtMap.get(t.id);
                    const status = !rt ? null : rt.is_material === true ? "material" : "not-material";
                    const isExpanded = expandedTopicId === t.id;
                    
                    return (
                      <React.Fragment key={t.id}>
                        <tr>
                          <td style={{ ...tableCell, fontWeight: fonts.weight.semibold }}>
                            {status === "material" ? (
                              <Link 
                                href={`/topics/${t.code.toLowerCase()}?reportId=${selectedReportId}`}
                                style={{ 
                                  color: colors.primary, 
                                  textDecoration: "none",
                                  display: "inline-block"
                                }}
                              >
                                <span style={{ fontFamily: "monospace" }}>{t.code}</span> {t.name ?? ""}
                              </Link>
                            ) : (
                              <>
                                <span style={{ fontFamily: "monospace", color: colors.textSecondary }}>{t.code}</span> {t.name ?? ""}
                              </>
                            )}
                          </td>
                          <td style={tableCell}>
                            <div style={{ display: "flex", gap: spacing.sm, flexWrap: "wrap", alignItems: "center" }}>
                              <div style={{ display: "flex", gap: spacing.xs }}>
                                <button
                                  onClick={async () => {
                                    await setMaterialityStatus(t.id, true);
                                    setExpandedTopicId(null);
                                  }}
                                  disabled={saving}
                                  style={{
                                    padding: `${spacing.xs} ${spacing.sm}`,
                                    fontSize: fonts.size.sm,
                                    border: `1px solid ${status === "material" ? colors.success : colors.borderGray}`,
                                    borderRadius: "4px",
                                    backgroundColor: status === "material" ? colors.success : colors.white,
                                    color: status === "material" ? colors.white : colors.textPrimary,
                                    cursor: saving ? "not-allowed" : "pointer",
                                    fontWeight: status === "material" ? fonts.weight.semibold : fonts.weight.normal,
                                  }}
                                >
                                  Material
                                </button>
                                <button
                                  onClick={async () => {
                                    // Always show rationale editor when clicking Not material
                                    if (status !== "not-material") {
                                      // Set to not-material first, then open editor
                                      await setMaterialityStatus(t.id, false, rt?.rationale || "");
                                    }
                                    setExpandedTopicId(isExpanded ? null : t.id);
                                    setRationaleText(rt?.rationale || "");
                                  }}
                                  disabled={saving}
                                  style={{
                                    padding: `${spacing.xs} ${spacing.sm}`,
                                    fontSize: fonts.size.sm,
                                    border: `1px solid ${status === "not-material" ? "#64748b" : colors.borderGray}`,
                                    borderRadius: "4px",
                                    backgroundColor: status === "not-material" ? "#64748b" : colors.white,
                                    color: status === "not-material" ? colors.white : colors.textPrimary,
                                    cursor: saving ? "not-allowed" : "pointer",
                                    fontWeight: status === "not-material" ? fonts.weight.semibold : fonts.weight.normal,
                                  }}
                                >
                                  Not material
                                </button>
                                <button
                                  onClick={async () => {
                                    await setMaterialityStatus(t.id, null);
                                    setExpandedTopicId(null);
                                  }}
                                  disabled={saving}
                                  style={{
                                    padding: `${spacing.xs} ${spacing.sm}`,
                                    fontSize: fonts.size.sm,
                                    border: `1px solid ${status === null ? colors.textSecondary : colors.borderGray}`,
                                    borderRadius: "4px",
                                    backgroundColor: status === null ? colors.bgSecondary : colors.white,
                                    color: colors.textPrimary,
                                    cursor: saving ? "not-allowed" : "pointer",
                                    fontWeight: status === null ? fonts.weight.semibold : fonts.weight.normal,
                                  }}
                                >
                                  Not assessed
                                </button>
                              </div>
                              {status === null && (
                                <span style={{ fontSize: fonts.size.sm, color: colors.textSecondary, fontStyle: "italic" }}>
                                  ⚠️ Assessment status required
                                </span>
                              )}
                              {status === "not-material" && !rt?.rationale && (
                                <span 
                                  onClick={() => {
                                    setExpandedTopicId(t.id);
                                    setRationaleText(rt?.rationale || "");
                                  }}
                                  style={{ 
                                    fontSize: fonts.size.sm, 
                                    color: "#64748b", 
                                    fontStyle: "italic",
                                    cursor: "pointer",
                                    textDecoration: "underline",
                                  }}
                                >
                                  ⚠️ Rationale recommended (click to add)
                                </span>
                              )}
                            </div>
                          </td>
                        </tr>
                        {isExpanded && (
                          <tr>
                            <td colSpan={2} style={{ ...tableCell, backgroundColor: colors.bgSecondary }}>
                              <div style={{ padding: spacing.md }}>
                                <label style={{ fontSize: fonts.size.sm, color: colors.textSecondary, display: "block", marginBottom: spacing.xs }}>
                                  Rationale for "Not material":
                                </label>
                                <textarea
                                  value={rationaleText}
                                  onChange={(e) => setRationaleText(e.target.value)}
                                  placeholder="Explain why this topic is not material..."
                                  rows={3}
                                  style={{
                                    ...inputStyles.base,
                                    width: "100%",
                                    resize: "vertical",
                                    fontFamily: fonts.family,
                                  }}
                                />
                                <div style={{ display: "flex", gap: spacing.sm, marginTop: spacing.sm }}>
                                  <button
                                    onClick={() => {
                                      setMaterialityStatus(t.id, false, rationaleText);
                                      setExpandedTopicId(null);
                                      setRationaleText("");
                                    }}
                                    disabled={saving}
                                    style={{
                                      ...buttonStyles.primary,
                                      fontSize: fonts.size.sm,
                                      padding: `${spacing.xs} ${spacing.md}`,
                                    }}
                                  >
                                    Save
                                  </button>
                                  <button
                                    onClick={() => {
                                      setExpandedTopicId(null);
                                      setRationaleText("");
                                    }}
                                    style={{
                                      ...buttonStyles.secondary,
                                      fontSize: fonts.size.sm,
                                      padding: `${spacing.xs} ${spacing.md}`,
                                    }}
                                  >
                                    Cancel
                                  </button>
                                </div>
                              </div>
                            </td>
                          </tr>
                        )}
                      </React.Fragment>
                    );
                  })}
                </tbody>
              </table>
            </div>
          )}
        </div>
      </div>

      {/* MODAL - Add Report */}
      {isModalOpen && (
        <div
          style={{
            position: "fixed",
            top: 0,
            left: 0,
            width: "100%",
            height: "100%",
            backgroundColor: "rgba(0, 0, 0, 0.5)",
            display: "flex",
            alignItems: "center",
            justifyContent: "center",
            zIndex: 1000,
          }}
          onClick={() => setIsModalOpen(false)}
        >
          <div
            style={{
              backgroundColor: colors.white,
              borderRadius: "8px",
              boxShadow: shadows.lg,
              padding: spacing.xl,
              maxWidth: "500px",
              width: "90%",
            }}
            onClick={(e) => e.stopPropagation()}
          >
            <h2 style={{ fontSize: fonts.size.h2, fontWeight: fonts.weight.bold, margin: `0 0 ${spacing.md} 0` }}>
              Add a Report
            </h2>

            <div style={{ display: "flex", flexDirection: "column", gap: spacing.md }}>
              <div style={{ display: "flex", flexDirection: "column", gap: spacing.xs }}>
                <label style={{ fontSize: fonts.size.sm, color: colors.textSecondary }}>Company *</label>
                <select
                  value={companyId}
                  onChange={(e) => setCompanyId(e.target.value)}
                  style={{ ...inputStyles.base, paddingRight: spacing.lg }}
                >
                  <option value="">Select company</option>
                  {companies.map((c) => (
                    <option key={c.id} value={c.id}>
                      {c.name}
                    </option>
                  ))}
                </select>
              </div>

              <div style={{ display: "flex", gap: spacing.md }}>
                <div style={{ flex: 1, display: "flex", flexDirection: "column", gap: spacing.xs }}>
                  <label style={{ fontSize: fonts.size.sm, color: colors.textSecondary }}>Reporting year *</label>
                  <input
                    type="number"
                    value={year}
                    onChange={(e) => setYear(parseInt(e.target.value, 10))}
                    placeholder="2025"
                    style={inputStyles.base}
                  />
                </div>
                <div style={{ flex: 1, display: "flex", flexDirection: "column", gap: spacing.xs }}>
                  <label style={{ fontSize: fonts.size.sm, color: colors.textSecondary }}>Status</label>
                  <select value={status} onChange={(e) => setStatus(e.target.value)} style={{ ...inputStyles.base, paddingRight: spacing.lg }}>
                    {STATUS_OPTIONS.map((s) => (
                      <option key={s} value={s}>
                        {s}
                      </option>
                    ))}
                  </select>
                </div>
              </div>

              {err && (
                <div style={{ color: colors.error, fontSize: fonts.size.sm, backgroundColor: colors.errorLight, padding: spacing.md, borderRadius: "4px" }}>
                  {err}
                </div>
              )}

              <div style={{ display: "flex", gap: spacing.sm }}>
                <button
                  onClick={() => createReport()}
                  style={{ ...buttonStyles.success, flex: 1 }}
                  disabled={saving}
                >
                  {saving ? "Creating..." : "Create"}
                </button>
                <button
                  onClick={() => setIsModalOpen(false)}
                  style={{ ...buttonStyles.secondary, flex: 1 }}
                  disabled={saving}
                >
                  Cancel
                </button>
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
