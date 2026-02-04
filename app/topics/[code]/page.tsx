"use client";

import Link from "next/link";
import { useEffect, useMemo, useState } from "react";
import { useSearchParams, useParams } from "next/navigation";
import { createSupabaseBrowserClient } from "@/lib/supabase/client";
import { colors, buttonStyles, cardStyles, fonts, inputStyles, spacing, shadows, headingStyles, borderRadius } from "@/lib/styles";
import DynamicQuestionInput from "@/components/DynamicQuestionInput";
import VersionSelector from "@/components/VersionSelector";
import { VersionedQuestion, VersionedAnswer } from "@/types/esrs";

type Topic = { id: string; code: string; name?: string };
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
  const [questions, setQuestions] = useState<VersionedQuestion[]>([]);
  const [answers, setAnswers] = useState<Record<string, VersionedAnswer>>({});
  const [err, setErr] = useState<string | null>(null);
  const [saving, setSaving] = useState(false);
  const [loading, setLoading] = useState(true);
  const [dropdownOpen, setDropdownOpen] = useState(false);
  const [searchTerm, setSearchTerm] = useState("");
  const [showValidation, setShowValidation] = useState(false);

  const orderedQuestions = useMemo(() => {
    return [...questions].sort((a, b) => (a.order_index ?? 0) - (b.order_index ?? 0));
  }, [questions]);

  const filteredQuestions = useMemo(() => {
    if (!searchTerm.trim()) return orderedQuestions;
    
    const term = searchTerm.toLowerCase();
    return orderedQuestions.filter((q) => {
      return (
        q.question_text?.toLowerCase().includes(term) ||
        q.code?.toLowerCase().includes(term) ||
        q.datapoint_id?.toLowerCase().includes(term) ||
        q.disclosure_requirement?.toLowerCase().includes(term) ||
        q.esrs_paragraph?.toLowerCase().includes(term)
      );
    });
  }, [orderedQuestions, searchTerm]);

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

    // Get active ESRS version
    const versionRes = await supabase
      .from("esrs_version")
      .select("id")
      .eq("is_active", true)
      .maybeSingle();

    const activeVersionId = versionRes.data?.id;

    // Load questions for this topic and active version
    const qRes = await supabase
      .from("disclosure_question")
      .select("*")
      .eq("topic_id", topicRes.data.id)
      .eq("version_id", activeVersionId)
      .order("order_index", { ascending: true });

    if (qRes.error) return setErr(qRes.error.message);
    setQuestions((qRes.data as VersionedQuestion[]) ?? []);

    const qIds = (qRes.data ?? []).map((q: any) => q.id);
    if (qIds.length === 0) {
      setAnswers({});
      return;
    }

    // Load existing answers
    const aRes = await supabase
      .from("disclosure_answer")
      .select("*")
      .eq("report_id", reportId)
      .in("question_id", qIds);

    if (aRes.error) return setErr(aRes.error.message);

    const map: Record<string, VersionedAnswer> = {};
    (aRes.data as VersionedAnswer[] | null)?.forEach((a) => {
      map[a.question_id] = a;
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

  function updateAnswer(qId: string, updates: Partial<VersionedAnswer>) {
    setAnswers((prev) => ({
      ...prev,
      [qId]: {
        ...(prev[qId] || {}),
        ...updates,
        question_id: qId,
        report_id: reportId,
      } as VersionedAnswer,
    }));
  }

  async function saveAll() {
    if (!reportId) return;
    
    // Show validation errors
    setShowValidation(true);
    
    // Check for mandatory field violations
    const mandatoryErrors: string[] = [];
    orderedQuestions.forEach((q) => {
      if (q.is_mandatory) {
        const answer = answers[q.id];
        const hasValue = answer && (
          (answer.value_text && answer.value_text.trim()) ||
          answer.value_numeric !== null ||
          answer.value_boolean !== null ||
          answer.value_date
        );
        
        if (!hasValue) {
          mandatoryErrors.push(`${q.code}: ${q.question_text?.substring(0, 50)}...`);
        }
      }
    });
    
    if (mandatoryErrors.length > 0) {
      setErr(`Vyplňte všetky povinné polia (${mandatoryErrors.length}). Skrolujte dole a pozrite si červené označenia.`);
      // Scroll to first error
      setTimeout(() => {
        const firstError = document.querySelector('.border-red-500');
        if (firstError) {
          firstError.scrollIntoView({ behavior: 'smooth', block: 'center' });
        }
      }, 100);
      return;
    }
    
    setSaving(true);
    setErr(null);

    try {
      const rows = Object.values(answers).map((answer) => ({
        report_id: reportId,
        question_id: answer.question_id,
        // Save all value fields
        value_text: answer.value_text || null,
        value_numeric: answer.value_numeric ?? null,
        value_boolean: answer.value_boolean ?? null,
        value_date: answer.value_date || null,
        value_json: answer.value_json || null,
        answer_text: answer.answer_text || answer.value_text || null, // Backwards compatibility
        unit: answer.unit || null,
        notes: answer.notes || null,
      }));

      const { error } = await supabase
        .from("disclosure_answer")
        .upsert(rows, { onConflict: "report_id,question_id" });

      if (error) throw error;

      await loadAll();
      setShowValidation(false); // Hide validation after successful save
      window.scrollTo({ top: 0, behavior: 'smooth' });
    } catch (e: any) {
      setErr(e.message ?? "Save failed");
    } finally {
      setSaving(false);
    }
  }

  async function exportTxt() {
    if (!reportId) return;
    window.location.href = `/api/export/${topicCode}?reportId=${reportId}`;
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
            {/* VERSION SELECTOR */}
            <VersionSelector />
            
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

        {/* Search Box */}
        <div style={{ marginBottom: spacing.lg }}>
          <div style={{ display: "flex", alignItems: "center", gap: spacing.md }}>
            <label 
              htmlFor="question-search"
              style={{ 
                fontSize: fonts.size.md, 
                fontWeight: fonts.weight.semibold,
                color: colors.textPrimary,
                whiteSpace: "nowrap"
              }}
            >
              🔍 Search:
            </label>
            <div style={{ flex: 1, position: "relative" }}>
              <input
                id="question-search"
                type="text"
                placeholder="Search questions by text, code, datapoint ID, DR, or paragraph..."
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                style={{
                  ...inputStyles.base,
                  width: "100%",
                  paddingRight: searchTerm ? "40px" : spacing.md,
                }}
              />
              {searchTerm && (
                <button
                  onClick={() => setSearchTerm("")}
                  style={{
                    position: "absolute",
                    right: "12px",
                    top: "50%",
                    transform: "translateY(-50%)",
                    background: "none",
                    border: "none",
                    color: colors.textSecondary,
                    cursor: "pointer",
                    fontSize: fonts.size.lg,
                    padding: "4px 8px",
                  }}
                  title="Clear search"
                >
                  ×
                </button>
              )}
            </div>
            <div style={{ 
              fontSize: fonts.size.sm, 
              color: colors.textSecondary,
              whiteSpace: "nowrap" 
            }}>
              {filteredQuestions.length} / {orderedQuestions.length} questions
            </div>
          </div>
        </div>

        {/* Questions List */}
        {loading ? (
          <p style={{ color: colors.textSecondary }}>Loading questions...</p>
        ) : orderedQuestions.length === 0 ? (
          <p style={{ color: colors.textSecondary }}>No questions found for {topicCode}.</p>
        ) : filteredQuestions.length === 0 ? (
          <div style={{ 
            textAlign: "center", 
            padding: spacing.xl, 
            color: colors.textSecondary 
          }}>
            <p style={{ fontSize: fonts.size.lg, marginBottom: spacing.sm }}>
              No questions match "{searchTerm}"
            </p>
            <button
              onClick={() => setSearchTerm("")}
              style={{
                ...buttonStyles.secondary,
                marginTop: spacing.md,
              }}
            >
              Clear search
            </button>
          </div>
        ) : (
          <div style={{ display: "grid", gap: 24 }}>
            {filteredQuestions.map((q, idx) => (
              <div key={q.id} style={cardStyles.base}>
                <div style={{ marginBottom: 16 }}>
                  <div style={{ ...headingStyles.h3, marginBottom: 4 }}>
                    {idx + 1}. {q.code}
                  </div>
                </div>
                <DynamicQuestionInput
                  question={q}
                  value={answers[q.id]}
                  onChange={(updates) => updateAnswer(q.id, updates)}
                  disabled={saving}
                  showValidation={showValidation}
                />
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
}