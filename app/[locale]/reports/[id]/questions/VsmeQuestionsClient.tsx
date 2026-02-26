'use client';

import { useEffect, useMemo, useState } from 'react';
import { useParams } from 'next/navigation';
import Link from 'next/link';
import { createSupabaseBrowserClient } from '@/lib/supabase/client';
import type { VsmeQuestion } from '@/types/vsme';
import { VSME_SECTION_META } from '@/config/vsmeSections';

type LocalAnswer = {
  value_text?: string;
  value_numeric?: string;
  value_date?: string;
  na?: boolean;
};

function hasAnyValue(a: LocalAnswer | undefined) {
  if (!a) return false;
  const t = (a.value_text ?? '').toString().trim();
  const n = (a.value_numeric ?? '').toString().trim();
  const d = (a.value_date ?? '').toString().trim();
  return t.length > 0 || n.length > 0 || d.length > 0;
}

export default function VsmeSectionClient() {
  const params = useParams<{ locale: string; id: string; sectionCode: string }>();

  const locale = typeof params.locale === 'string' ? params.locale : 'en';
  const reportId = typeof params.id === 'string' ? params.id : '';
  const sectionCode = typeof params.sectionCode === 'string' ? params.sectionCode : '';

  const sectionMeta = VSME_SECTION_META[sectionCode];
  const sectionTitle = sectionMeta?.title || sectionCode;

  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [sectionQuestions, setSectionQuestions] = useState<VsmeQuestion[]>([]);
  const [answersById, setAnswersById] = useState<Record<string, LocalAnswer>>({});
  const [reportYear, setReportYear] = useState<number | null>(null);

  const saveAnswer = async (questionId: string, answerType: string, value: string | undefined) => {
    if (!reportId) return;

    const supabase = createSupabaseBrowserClient();
    const t = String(answerType ?? '').toLowerCase();

    if (!value || value === '') {
      await supabase.from('disclosure_answer').delete().eq('report_id', reportId).eq('question_id', questionId);
      return;
    }

    const payload: any = {
      report_id: reportId,
      question_id: questionId,
    };

    if (t === 'number' || t === 'integer' || t === 'numeric') {
      payload.value_numeric = Number(value);
    } else if (t === 'date') {
      payload.value_date = value;
    } else {
      payload.value_text = value;
    }

    await supabase.from('disclosure_answer').upsert(payload, { onConflict: 'report_id,question_id' });
  };

  // ✅ MUST be outside saveAnswer / useEffect / return
  const toggleNA = async (questionId: string, nextNa: boolean) => {
    if (!reportId) return;

    // optimistic UI
    setAnswersById((prev) => ({
      ...prev,
      [questionId]: { ...(prev[questionId] ?? {}), na: nextNa },
    }));

    const supabase = createSupabaseBrowserClient();

    if (nextNa) {
      const { error } = await supabase
        .from('disclosure_answer')
        .upsert({ report_id: reportId, question_id: questionId, value_jsonb: { na: true } }, { onConflict: 'report_id,question_id' });

      if (error) console.error('toggle NA on failed', error);
      return;
    }

    // OFF: remove only "na" key (do not overwrite other json keys)
    const { data: existing, error: readErr } = await supabase
      .from('disclosure_answer')
      .select('value_jsonb')
      .eq('report_id', reportId)
      .eq('question_id', questionId)
      .maybeSingle();

    if (readErr) {
      console.error('toggle NA off read failed', readErr);
      return;
    }

    const current = (existing?.value_jsonb ?? {}) as any;
    const next = { ...current };
    delete next.na;

    const { error } = await supabase
      .from('disclosure_answer')
      .update({ value_jsonb: next })
      .eq('report_id', reportId)
      .eq('question_id', questionId);

    if (error) console.error('toggle NA off failed', error);
  };

  useEffect(() => {
    if (!reportId || !sectionCode) return;

    let cancelled = false;

    const run = async () => {
      setLoading(true);
      setError(null);

      try {
        const supabase = createSupabaseBrowserClient();

        // lightweight year fetch (in parallel)
        const yearPromise = supabase.from('report').select('reporting_year').eq('id', reportId).maybeSingle();

        const { data, error: rpcError } = await supabase.rpc('get_vsme_questions_for_report', {
          p_report_id: reportId,
        });

        if (rpcError) {
          if (!cancelled) setError(rpcError.message);
          return;
        }

        const all = (data as VsmeQuestion[]) || [];
        const filtered = all.filter((q: any) => {
          const sc = String(q.section_code ?? q.sectionCode ?? q.section ?? '').toUpperCase();
          return sc === sectionCode.toUpperCase();
        });

        const { data: yearRow, error: yearErr } = await yearPromise;
        if (!cancelled) {
          if (yearErr) {
            console.error('Failed to load report year', yearErr);
            setReportYear(null);
          } else {
            const y = (yearRow as any)?.reporting_year;
            setReportYear(typeof y === 'number' ? y : null);
          }

          setSectionQuestions(filtered);

          setAnswersById(() => {
            const next: Record<string, LocalAnswer> = {};
            for (const q of filtered as any[]) {
              next[q.question_id] = {
                value_text: typeof q.value_text === 'string' ? q.value_text : '',
                value_numeric: q.value_numeric != null ? String(q.value_numeric) : '',
                value_date: typeof q.value_date === 'string' ? q.value_date : '',
                na: q.value_jsonb?.na === true,
              };
            }
            return next;
          });
        }
      } catch (e: any) {
        if (!cancelled) setError(e?.message ?? 'Failed to load questions');
      } finally {
        if (!cancelled) setLoading(false);
      }
    };

    void run();

    return () => {
      cancelled = true;
    };
  }, [reportId, sectionCode]);

  const stats = useMemo(() => {
    const total = sectionQuestions.length;
    let naCount = 0;
    let answeredCount = 0;

    for (const q of sectionQuestions as any[]) {
      const id = q.question_id;
      const a = answersById[id];
      if (!a) continue;

      if (a.na === true) {
        naCount += 1;
        continue;
      }
      if (hasAnyValue(a)) answeredCount += 1;
    }

    const progressPct = total > 0 ? Math.round((answeredCount / total) * 100) : 0;
    return { total, naCount, answeredCount, progressPct };
  }, [sectionQuestions, answersById]);

  return (
    <div className="min-h-screen bg-gray-50 p-8">
      <div className="max-w-3xl mx-auto">
        {/* Page header */}
        <div className="mb-4 flex items-center justify-between">
          <div>
            <h1 className="text-2xl font-bold text-gray-900">
              {sectionCode} — {sectionTitle}
            </h1>
          </div>

          <Link href={`/${locale}/reports/${reportId}/questions`} className="px-3 py-2 bg-gray-700 text-white rounded text-sm">
            Back
          </Link>
        </div>

        {/* Summary box (no "Change question set") */}
        <div className="bg-white rounded-lg border border-gray-200 shadow-sm p-4 mb-4">
          <div className="flex items-start justify-between gap-4">
            <div className="min-w-0">
              <div className="text-xs text-gray-500">Question set</div>
              <div className="text-sm font-semibold text-gray-900">Section view</div>
            </div>

            <div className="text-right shrink-0">
              <div className="text-xs text-gray-500">Year</div>
              <div className="text-sm font-semibold text-gray-900">{reportYear ?? '—'}</div>
            </div>
          </div>

          <div className="mt-3 flex flex-wrap items-center gap-x-6 gap-y-2 text-sm">
            <div>
              <span className="text-gray-500">Questions:</span>{' '}
              <span className="font-semibold text-gray-900">{stats.total}</span>
            </div>
            <div>
              <span className="text-gray-500">Completed:</span>{' '}
              <span className="font-semibold text-gray-900">{stats.answeredCount}</span>
            </div>
            <div>
              <span className="text-gray-500">Progress:</span>{' '}
              <span className="font-semibold text-gray-900">{stats.progressPct}%</span>
            </div>
          </div>

          <div className="mt-3">
            <div className="h-2 rounded bg-gray-100 overflow-hidden">
              <div className="h-2 rounded bg-emerald-500" style={{ width: `${stats.progressPct}%` }} />
            </div>
            <div className="mt-2 text-xs text-gray-500">{stats.naCount} questions marked as Not Applicable</div>
          </div>
        </div>

        {loading ? (
          <div className="text-gray-600">Loading section…</div>
        ) : error ? (
          <div className="bg-red-50 border border-red-200 rounded p-4">
            <div className="font-semibold text-red-800">Error</div>
            <div className="text-red-700 text-sm mt-1">{error}</div>
          </div>
        ) : sectionQuestions.length === 0 ? (
          <div className="bg-yellow-50 border border-yellow-200 rounded p-4 text-yellow-900">No questions matched this section.</div>
        ) : (
          <ul className="space-y-4">
            {sectionQuestions.map((q: any, idx: number) => {
              const total = sectionQuestions.length;
              const t = String(q.answer_type ?? '').toLowerCase();
              const a = answersById[q.question_id] ?? {};
              const allowed = (q.config_jsonb?.allowed_values ?? []) as string[];
              const isNa = a.na === true;

              return (
                <li
                  key={q.question_id}
                  className={[
                    'rounded-lg shadow',
                    'border border-gray-200',
                    'border-l-4',
                    isNa ? 'border-l-amber-400 bg-amber-50/15' : 'border-l-blue-500 bg-white',
                    'p-4 transition-colors',
                  ].join(' ')}
                >
                  <div className="flex items-start justify-between gap-4">
                    <div className="min-w-0">
                      <div className="text-[11px] text-gray-500">
                        {idx + 1} / {total}
                      </div>

                      <div className="mt-1 text-[10px] tracking-wide text-gray-400 uppercase">{q.code ?? ''}</div>

                      <div className="mt-2 text-base font-semibold text-gray-900">
                        {q.question_text ?? q.title ?? 'Untitled question'}
                      </div>
                    </div>

                    {/* NA switch (neutral gray track even when checked) */}
                    <label className="flex items-center gap-3 shrink-0 select-none cursor-pointer">
                      <span className="text-xs text-gray-500">Not applicable</span>

                      <div className="relative">
                        <input
                          type="checkbox"
                          checked={isNa}
                          onChange={(e) => void toggleNA(q.question_id, e.target.checked)}
                          className="sr-only peer"
                        />

                        <div className="w-10 h-5 bg-gray-300 peer-checked:bg-gray-400 rounded-full transition-colors" />
                        <div className="absolute left-0.5 top-0.5 w-4 h-4 bg-white rounded-full shadow transition-transform peer-checked:translate-x-5" />
                      </div>
                    </label>
                  </div>

                  {isNa ? (
                    <div className="mt-2 text-xs text-gray-500">Marked as Not Applicable (answer preserved)</div>
                  ) : (
                    <>
                      {(t === 'text' || t === 'string') && (
                        <div className="mt-3">
                          <input
                            type="text"
                            value={a.value_text ?? ''}
                            onChange={(e) => {
                              const v = e.target.value;
                              setAnswersById((prev) => ({
                                ...prev,
                                [q.question_id]: { ...(prev[q.question_id] ?? {}), value_text: v },
                              }));
                            }}
                            onBlur={(e) => saveAnswer(q.question_id, q.answer_type, e.target.value)}
                            className="w-full px-3 py-2 border border-gray-300 rounded"
                            autoComplete="off"
                            placeholder="Type…"
                          />
                        </div>
                      )}

                      {(t === 'number' || t === 'integer' || t === 'numeric') && (
                        <div className="mt-3">
                          <input
                            type="number"
                            value={a.value_numeric ?? ''}
                            onChange={(e) => {
                              const v = e.target.value;
                              setAnswersById((prev) => ({
                                ...prev,
                                [q.question_id]: { ...(prev[q.question_id] ?? {}), value_numeric: v },
                              }));
                            }}
                            onBlur={(e) => saveAnswer(q.question_id, q.answer_type, e.target.value)}
                            className="w-full px-3 py-2 border border-gray-300 rounded"
                            placeholder="0"
                          />
                        </div>
                      )}

                      {t === 'date' && (
                        <div className="mt-3">
                          <input
                            type="date"
                            value={a.value_date ?? ''}
                            onChange={(e) => {
                              const v = e.target.value;
                              setAnswersById((prev) => ({
                                ...prev,
                                [q.question_id]: { ...(prev[q.question_id] ?? {}), value_date: v },
                              }));
                            }}
                            onBlur={(e) => saveAnswer(q.question_id, q.answer_type, e.target.value)}
                            className="w-full px-3 py-2 border border-gray-300 rounded"
                          />
                        </div>
                      )}

                      {t === 'select' && (
                        <div className="mt-3">
                          {!Array.isArray(allowed) || allowed.length === 0 ? (
                            <input
                              type="text"
                              value={a.value_text ?? ''}
                              onChange={(e) => {
                                const v = e.target.value;
                                setAnswersById((prev) => ({
                                  ...prev,
                                  [q.question_id]: { ...(prev[q.question_id] ?? {}), value_text: v },
                                }));
                              }}
                              onBlur={(e) => saveAnswer(q.question_id, q.answer_type, e.target.value)}
                              className="w-full px-3 py-2 border border-gray-300 rounded"
                              autoComplete="off"
                              placeholder="Type…"
                            />
                          ) : (
                            <select
                              value={a.value_text ?? ''}
                              onChange={(e) => {
                                const v = e.target.value;
                                setAnswersById((prev) => ({
                                  ...prev,
                                  [q.question_id]: { ...(prev[q.question_id] ?? {}), value_text: v },
                                }));
                              }}
                              onBlur={(e) => saveAnswer(q.question_id, q.answer_type, e.target.value)}
                              className="w-full px-3 py-2 border border-gray-300 rounded bg-white"
                            >
                              <option value="">— Select —</option>
                              {allowed.map((v) => (
                                <option key={v} value={v}>
                                  {v}
                                </option>
                              ))}
                            </select>
                          )}
                        </div>
                      )}
                    </>
                  )}
                </li>
              );
            })}
          </ul>
        )}
      </div>
    </div>
  );
}