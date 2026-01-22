"use client";

import { useEffect, useMemo, useState } from "react";
import { useSearchParams } from "next/navigation";
import { createSupabaseBrowserClient } from "@/lib/supabase/client";

type Topic = { id: string; code: string; name?: string };
type Question = {
  id: string;
  code: string;
  question_text: string;
  help_text: string | null;
  order_index: number | null;
};
type AnswerRow = { question_id: string; value_text: string | null };

export default function G1Page() {
  const supabase = createSupabaseBrowserClient();
  const searchParams = useSearchParams();
  const reportId = searchParams.get("reportId") ?? "";

  const [topic, setTopic] = useState<Topic | null>(null);
  const [questions, setQuestions] = useState<Question[]>([]);
  const [answers, setAnswers] = useState<Record<string, string>>({});
  const [err, setErr] = useState<string | null>(null);
  const [saving, setSaving] = useState(false);

  const orderedQuestions = useMemo(() => {
    return [...questions].sort((a, b) => (a.order_index ?? 0) - (b.order_index ?? 0));
  }, [questions]);

  async function loadAll() {
    setErr(null);
    if (!reportId) {
      setErr("Missing reportId in URL. Open via /topics/g1?reportId=...");
      return;
    }

    const topicRes = await supabase
      .from("topic")
      .select("id, code, name")
      .eq("code", "G1")
      .maybeSingle();

    if (topicRes.error) return setErr(topicRes.error.message);
    if (!topicRes.data) return setErr("Topic G1 not found");
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
    loadAll();
  }, [reportId]);

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

      // upsert potrebuje unique(report_id, question_id) v DB (odporúčané)
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
    window.location.href = `/api/export/g1?reportId=${reportId}`;
  }

  return (
    <div style={{ display: "grid", gap: 12, maxWidth: 1000 }}>
      <h2>G1 {topic?.name ? `— ${topic.name}` : ""}</h2>

      {!reportId && (
        <div style={{ color: "crimson" }}>
          Missing reportId. Open via <code>/topics/g1?reportId=...</code>
        </div>
      )}

      <div style={{ display: "flex", gap: 8, flexWrap: "wrap" }}>
        <button onClick={saveAll} disabled={saving || !reportId}>
          {saving ? "Saving..." : "Save"}
        </button>
        <button onClick={exportTxt} disabled={!reportId}>
          Export
        </button>
        <button onClick={loadAll} disabled={!reportId}>
          Reload
        </button>
      </div>

      {err && <div style={{ color: "crimson" }}>{err}</div>}

      {orderedQuestions.map((q) => (
        <div key={q.id} style={{ border: "1px solid #ddd", padding: 12, borderRadius: 8 }}>
          <div style={{ fontWeight: 700 }}>
            {q.code} — {q.question_text}
          </div>
          {q.help_text && <div style={{ opacity: 0.75, marginTop: 4 }}>{q.help_text}</div>}
          <textarea
            value={answers[q.id] ?? ""}
            onChange={(e) => setAnswer(q.id, e.target.value)}
            rows={4}
            style={{ width: "100%", marginTop: 8 }}
          />
        </div>
      ))}
    </div>
  );
}
