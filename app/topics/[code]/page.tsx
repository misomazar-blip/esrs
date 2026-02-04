"use client";

import Link from "next/link";
import { useEffect, useMemo, useState } from "react";
import { useSearchParams, useParams } from "next/navigation";
import { createSupabaseBrowserClient } from "@/lib/supabase/client";
import { colors, buttonStyles, cardStyles, fonts, inputStyles, spacing, shadows, headingStyles, borderRadius } from "@/lib/styles";

type Topic = { id: string; code: string; name?: string };
type Question = {
  id: string;
  code: string;
  question_text: string;
  help_text: string | null;
  order_index: number | null;
};
type AnswerRow = { question_id: string; value_text: string | null };
type Report = { id: string; report_year: number; status: string };

export default function TopicPage() {
  const supabase = createSupabaseBrowserClient();
  const params = useParams();
  const searchParams = useSearchParams();
  const topicCode = (params.code as string)?.toUpperCase() ?? "";
  const reportId = searchParams.get("reportId") ?? "";

  const [email, setEmail] = useState<string | null>(null);
  const [topic, setTopic] = useState<Topic | null>(null);
  const [report, setReport] = useState<Report | null>(null);
  const [questions, setQuestions] = useState<Question[]>([]);
  const [answers, setAnswers] = useState<Record<string, string>>({});
  const [err, setErr] = useState<string | null>(null);
  const [saving, setSaving] = useState(false);
  const [loading, setLoading] = useState(true);
  const [dropdownOpen, setDropdownOpen] = useState(false);

  const orderedQuestions = useMemo(() => {
    return [...questions].sort((a, b) => (a.order_index ?? 0) - (b.order_index ?? 0));
  }, [questions]);

  async function loadAll() {
    setErr(null);
    if (!reportId) {
      setErr(`Missing reportId in URL. Open via /topics/${topicCode.toLowerCase()}?reportId=...`);
      return;
    }

    if (!topicCode) {
      setErr("Invalid topic code");
      return;
    }

    const topicRes = await supabase
      .from("topic")
      .select("id, code, name")
      .eq("code", topicCode)
      .maybeSingle();

    if (topicRes.error) return setErr(topicRes.error.message);
    if (!topicRes.data) return setErr(`Topic ${topicCode} not found`);
    setTopic(topicRes.data as Topic);

    const qRes = await supabase
      .from("disclosure_question")
      .select("id, code, question_text, help_text, order_index")
      .eq("topic_id", topicRes.data.id)
      .order("order_index", { ascending: true });

    if (qRes.error) return setErr(qRes.error.message);
    setQuestions((qRes.data as Question[]) ?? []);

    const qIds = (qRes.data ?? []).map((q: any) => q.id);
    if (qIds.length === 0) {
      setAnswers({});
      return;
    }

    const aRes = await supabase
      .from("disclosure_answer")
      .select("question_id, value_text")
      .eq("report_id", reportId)
      .in("question_id", qIds);

    if (aRes.error) return setErr(aRes.error.message);

    const map: Record<string, string> = {};
    (aRes.data as AnswerRow[] | null)?.forEach((a) => {
      map[a.question_id] = a.value_text ?? "";
    });
    setAnswers(map);
  }

  useEffect(() => {
    async function checkAuth() {
      const { data: { user } } = await supabase.auth.getUser();
      if (user?.email) setEmail(user.email);
    }
    checkAuth();
  }, []);

  useEffect(() => {
    async function loadReport() {
      if (!reportId) return;
      const { data, error } = await supabase
        .from("report")
        .select("id, company_id, report_year, status")
        .eq("id", reportId)
        .maybeSingle();
      if (!error && data) setReport(data as Report);
    }
    loadReport();
  }, [reportId]);

  useEffect(() => {
    setLoading(true);
    loadAll().finally(() => setLoading(false));
  }, [reportId, topicCode]);

  function setAnswer(qId: string, value: string) {
    setAnswers((prev) => ({ ...prev, [qId]: value }));
  }

  async function saveAll() {
    if (!reportId) return;
    setSaving(true);
    setErr(null);

    try {
      const rows = orderedQuestions.map((q) => ({
        report_id: reportId,
        question_id: q.id,
        value_text: answers[q.id] ?? "",
      }));

      const { error } = await supabase
        .from("disclosure_answer")
        .upsert(rows, { onConflict: "report_id,question_id" });

      if (error) throw error;

      await loadAll();
    } catch (e: any) {
      setErr(e.message ?? "Save failed");
    } finally {
      setSaving(false);
    }
  }

  async function exportTxt() {
    if (!reportId) return;
    window.location.href = `/api/export/${topicCode.toLowerCase()}?reportId=${reportId}`;
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
                <span style={{ fontSize: fonts.size.sm, color: colors.textPrimary }}>
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

      {/* Main Content */}
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
            {topicCode} {topic?.name ? `— ${topic.name}` : ""}
          </h1>
          <Link href="/report" style={{ ...buttonStyles.secondary, textDecoration: "none", display: "inline-flex", alignItems: "center" }}>
            ← Back to Report
          </Link>
        </div>

        {/* Error Display */}
        {err && (
          <div
            style={{
              backgroundColor: "#fee",
              border: `1px solid ${colors.error}`,
              color: colors.error,
              padding: 16,
              borderRadius: borderRadius.md,
              marginBottom: 24,
              fontSize: fonts.size.sm,
            }}
          >
            {err}
          </div>
        )}

        {/* Action Buttons */}
        <div style={{ display: "flex", gap: 12, marginBottom: 32, flexWrap: "wrap" }}>
          <button
            onClick={saveAll}
            disabled={saving || !reportId}
            style={{
              ...buttonStyles.primary,
              opacity: saving || !reportId ? 0.5 : 1,
              cursor: saving || !reportId ? "not-allowed" : "pointer",
            }}
          >
            {saving ? "Saving..." : "Save"}
          </button>
          <button
            onClick={exportTxt}
            disabled={!reportId}
            style={{
              ...buttonStyles.secondary,
              opacity: !reportId ? 0.5 : 1,
              cursor: !reportId ? "not-allowed" : "pointer",
            }}
          >
            Export
          </button>
          <button
            onClick={loadAll}
            disabled={!reportId}
            style={{
              ...buttonStyles.secondary,
              opacity: !reportId ? 0.5 : 1,
              cursor: !reportId ? "not-allowed" : "pointer",
            }}
          >
            Reload
          </button>
        </div>

        {/* Questions List */}
        {loading ? (
          <p style={{ color: colors.textSecondary }}>Loading questions...</p>
        ) : orderedQuestions.length === 0 ? (
          <p style={{ color: colors.textSecondary }}>No questions found for {topicCode}.</p>
        ) : (
          <div style={{ display: "grid", gap: 24 }}>
            {orderedQuestions.map((q, idx) => (
              <div key={q.id} style={cardStyles.base}>
                <div style={{ marginBottom: 12 }}>
                  <div style={{ ...headingStyles.h3, marginBottom: 8 }}>
                    {idx + 1}. {q.code} — {q.question_text}
                  </div>
                  {q.help_text && (
                    <p
                      style={{
                        color: colors.textSecondary,
                        fontSize: fonts.size.sm,
                        lineHeight: "1.5",
                        margin: 0,
                      }}
                    >
                      {q.help_text}
                    </p>
                  )}
                </div>
                <textarea
                  value={answers[q.id] ?? ""}
                  onChange={(e) => setAnswer(q.id, e.target.value)}
                  rows={4}
                  placeholder="Enter your answer here..."
                  style={{
                    ...inputStyles.base,
                    fontFamily: "monospace",
                    padding: 12,
                  }}
                />
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
}
