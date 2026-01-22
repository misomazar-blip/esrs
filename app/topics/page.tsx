"use client";

import Link from "next/link";
import { useEffect, useState } from "react";
import { createSupabaseBrowserClient } from "@/lib/supabase/client";

type Topic = { id: string; code: string; name?: string };
type Report = { id: string; reporting_year: number; company_id: string };

export default function TopicsPage() {
  const supabase = createSupabaseBrowserClient();
  const [topics, setTopics] = useState<Topic[]>([]);
  const [reports, setReports] = useState<Report[]>([]);
  const [selectedReportId, setSelectedReportId] = useState<string | null>(null);
  const [err, setErr] = useState<string | null>(null);

  useEffect(() => {
    supabase
      .from("topic")
      .select("id, code, name")
      .order("code")
      .then(({ data, error }) => {
        if (error) {
          setErr(error.message);
          return;
        }
        setTopics((data as Topic[]) ?? []);
      });

    supabase
      .from("report")
      .select("id, reporting_year, company_id")
      .order("created_at", { ascending: false })
      .then(({ data, error }) => {
        if (error) {
          setErr(error.message);
          return;
        }
        setReports((data as Report[]) ?? []);
      });
  }, []);

  const selectedReport = reports.find((r) => r.id === selectedReportId);

  return (
    <div style={{ display: "grid", gap: 12, maxWidth: 900 }}>
      <h2>Topics</h2>

      {err && <div style={{ color: "crimson" }}>{err}</div>}

      <div>
        {!selectedReportId ? (
          <div>
            <h3>Select a Report:</h3>
            {reports.length === 0 ? (
              <p style={{ opacity: 0.6 }}>No reports found. Create one in <Link href="/report">Report</Link> page.</p>
            ) : (
              <ul style={{ listStyle: "none", padding: 0 }}>
                {reports.map((r) => (
                  <li
                    key={r.id}
                    onClick={() => setSelectedReportId(r.id)}
                    style={{
                      padding: "12px",
                      border: "1px solid #ddd",
                      borderRadius: 8,
                      cursor: "pointer",
                      marginBottom: 8,
                      backgroundColor: "#f9f9f9",
                      transition: "all 0.2s",
                    }}
                    onMouseEnter={(e) => (e.currentTarget.style.backgroundColor = "#e8f4f8")}
                    onMouseLeave={(e) => (e.currentTarget.style.backgroundColor = "#f9f9f9")}
                  >
                    <b>Year {r.reporting_year}</b> • {r.id.slice(0, 8)}…
                  </li>
                ))}
              </ul>
            )}
          </div>
        ) : (
          <div>
            <button onClick={() => setSelectedReportId(null)} style={{ marginBottom: 12 }}>
              ← Back to Reports
            </button>
            <h3>
              Report {selectedReport?.reporting_year} — Topics
            </h3>

            {topics.length === 0 ? (
              <p style={{ opacity: 0.6 }}>No topics found.</p>
            ) : (
              <ul style={{ listStyle: "none", padding: 0 }}>
                {topics.map((t) => (
                  <li key={t.id} style={{ marginBottom: 8 }}>
                    <div
                      style={{
                        padding: "12px",
                        border: "1px solid #ddd",
                        borderRadius: 8,
                        backgroundColor: "#f9f9f9",
                        display: "flex",
                        justifyContent: "space-between",
                        alignItems: "center",
                      }}
                    >
                      <div>
                        <b>{t.code}</b> {t.name ? `— ${t.name}` : ""}
                      </div>
                      {t.code.toLowerCase() === "g1" ? (
                        <Link href={`/topics/g1?reportId=${selectedReportId}`}>
                          <button>Open</button>
                        </Link>
                      ) : (
                        <span style={{ opacity: 0.6, fontSize: 12 }}>(MVP only G1)</span>
                      )}
                    </div>
                  </li>
                ))}
              </ul>
            )}
          </div>
        )}
      </div>
    </div>
  );
}
