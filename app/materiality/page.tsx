"use client";

import { useEffect, useMemo, useState } from "react";
import { useSearchParams } from "next/navigation";
import { createSupabaseBrowserClient } from "@/lib/supabase/client";

type Topic = { id: string; code: string; name?: string };
type Report = { id: string; reporting_year: number };
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

  const [reports, setReports] = useState<Report[]>([]);
  const [reportId, setReportId] = useState<string>(reportIdFromUrl ?? "");
  const [topics, setTopics] = useState<Topic[]>([]);
  const [reportTopics, setReportTopics] = useState<ReportTopic[]>([]);
  const [err, setErr] = useState<string | null>(null);

  const rtMap = useMemo(() => {
    const m = new Map<string, ReportTopic>();
    reportTopics.forEach((rt) => m.set(rt.topic_id, rt));
    return m;
  }, [reportTopics]);

  async function loadReports() {
    const { data, error } = await supabase
      .from("report")
      .select("id, reporting_year")
      .order("created_at", { ascending: false });
    if (error) setErr(error.message);
    setReports((data as Report[]) ?? []);
    if (!reportId && data?.[0]?.id) setReportId(data[0].id);
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

  useEffect(() => {
    loadReports();
    loadTopics();
  }, []);

  useEffect(() => {
    if (reportId) loadReportTopics(reportId);
  }, [reportId]);

  async function setMaterial(topicId: string, isMaterial: boolean) {
    if (!reportId) return;

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
  }

  return (
    <div style={{ display: "grid", gap: 12, maxWidth: 1000 }}>
      <h2>Materiality</h2>

      <div style={{ display: "flex", gap: 8, flexWrap: "wrap" }}>
        <select value={reportId} onChange={(e) => setReportId(e.target.value)}>
          <option value="">-- select report --</option>
          {reports.map((r) => (
            <option key={r.id} value={r.id}>
              {r.reporting_year} — {r.id.slice(0, 8)}…
            </option>
          ))}
        </select>
        <button onClick={() => reportId && loadReportTopics(reportId)}>Refresh</button>
      </div>

      {err && <div style={{ color: "crimson" }}>{err}</div>}

      {!reportId ? (
        <div>Select report first.</div>
      ) : (
        <table border={1} cellPadding={8}>
          <thead>
            <tr>
              <th>Topic</th>
              <th>Material?</th>
            </tr>
          </thead>
          <tbody>
            {topics.map((t) => {
              const rt = rtMap.get(t.id);
              const checked = rt?.is_material ?? false;
              return (
                <tr key={t.id}>
                  <td>
                    <b>{t.code}</b> {t.name ?? ""}
                  </td>
                  <td>
                    <input
                      type="checkbox"
                      checked={checked}
                      onChange={(e) => setMaterial(t.id, e.target.checked)}
                    />
                  </td>
                </tr>
              );
            })}
          </tbody>
        </table>
      )}
    </div>
  );
}
