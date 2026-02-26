'use client';

import { useEffect, useMemo, useState, useCallback } from 'react';
import { useParams } from 'next/navigation';
import Link from 'next/link';
import { createSupabaseBrowserClient } from '@/lib/supabase/client';
import type { VsmeQuestion } from '@/types/vsme';
import { VSME_SECTION_META } from '@/config/vsmeSections';

function hasAnyValue(a: any) {
  if (!a) return false;
  const t = (a.value_text ?? '').toString().trim();
  const n = (a.value_numeric ?? '').toString().trim();
  const d = (a.value_date ?? '').toString().trim();
  return t.length > 0 || n.length > 0 || d.length > 0;
}

type LocalAnswer = {
  value_text?: string;
  value_numeric?: string; // stored as string in UI
  value_date?: string;
  na?: boolean;
};

type SectionGroup = 'General Information' | 'Environment' | 'Social' | 'Governance';
const GROUP_ORDER = ['General Information', 'Environment', 'Social', 'Governance'] as const;
const SECTION_GROUP_OVERRIDE: Record<string, SectionGroup> = {
  B1: 'General Information',
  B2: 'General Information',
  C1: 'General Information',
  C2: 'General Information',

  B3: 'Environment',
  B4: 'Environment',
  B5: 'Environment',
  B6: 'Environment',
  B7: 'Environment',
  C3: 'Environment',
  C4: 'Environment',

  B8: 'Social',
  B9: 'Social',
  B10: 'Social',
  C5: 'Social',
  C6: 'Social',
  C7: 'Social',
  B11: 'Governance',
  C8: 'Governance',
  C9: 'Governance',
};

function isSectionGroup(value: string): value is SectionGroup {
  return value === 'General Information' || value === 'Environment' || value === 'Social' || value === 'Governance';
}

function resolveSectionGroup(sc: string): SectionGroup {
  const normalized = String(sc || '').toUpperCase();
  const override = SECTION_GROUP_OVERRIDE[normalized];
  if (override) return override;

  if (normalized.startsWith('B')) return 'Environment';
  if (normalized.startsWith('C')) return 'Social';
  if (normalized.startsWith('G')) return 'Governance';
  return 'General Information';
}

export default function VsmeSectionClient() {
  // Params
  const params = useParams<{ locale: string; id: string; sectionCode: string }>();
  const locale = typeof params.locale === 'string' ? params.locale : 'en';
  const reportId = typeof params.id === 'string' ? params.id : '';
  const sectionCode = typeof params.sectionCode === 'string' ? params.sectionCode : '';
  const normalizedSectionCode = sectionCode.toUpperCase();

  const currentGroup: SectionGroup = useMemo(() => {
    return resolveSectionGroup(normalizedSectionCode);
  }, [normalizedSectionCode]);

  const sectionMeta = VSME_SECTION_META[sectionCode];
  const sectionTitle = sectionMeta?.title || sectionCode;

  // State
  const [allQuestions, setAllQuestions] = useState<VsmeQuestion[]>([]);
  const [loadingHeader, setLoadingHeader] = useState(false);
  const [errorHeader, setErrorHeader] = useState<string | null>(null);
  const [cta, setCta] = useState<any>(null);

  const refreshCta = useCallback(async () => {
    if (!reportId) return;

   const supabase = createSupabaseBrowserClient();

   const { data, error } = await supabase.rpc('get_vsme_ctas_for_report', {
    p_report_id: reportId,
  });

  if (error) {
    console.error('CTA refresh failed', error);
    return;
  }

   setCta(data);
  }, [reportId]);

  const [reportInfo, setReportInfo] = useState<{
    companyName?: string | null;
    reportingYear?: number | null;
    vsmeMode?: string | null;
  }>({});

  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [sectionQuestions, setSectionQuestions] = useState<VsmeQuestion[]>([]);
  const [answersById, setAnswersById] = useState<Record<string, LocalAnswer>>({});
  const [showStickyNav, setShowStickyNav] = useState(false);

  // Sections panel state
  const [openGroup, setOpenGroup] = useState<SectionGroup>(currentGroup);

  useEffect(() => {
    setOpenGroup(currentGroup);
  }, [currentGroup]);

  // Load report header info + all questions (for report-wide stats + sections aggregates)
  useEffect(() => {
    if (!reportId) return;

    let cancelled = false;

    const run = async () => {
      setLoadingHeader(true);
      setErrorHeader(null);

      try {
        const supabase = createSupabaseBrowserClient();
        
        const { data: reportRow, error: reportErr } = await supabase
          .from('report')
          .select('reporting_year, vsme_mode, company:company_id(name)')
          .eq('id', reportId)
          .maybeSingle();

        if (reportErr) throw reportErr;

        if (!cancelled) {
          setReportInfo({
            companyName: (reportRow as any)?.company?.name ?? null,
            reportingYear: (reportRow as any)?.reporting_year ?? null,
            vsmeMode: (reportRow as any)?.vsme_mode ?? null,
          });
        }

        const { data: allQs, error: allQsErr } = await supabase.rpc('get_vsme_questions_for_report', {
          p_report_id: reportId,
        });

        if (allQsErr) throw allQsErr;

        if (!cancelled) {
          setAllQuestions((allQs as VsmeQuestion[]) || []);
        }

        await refreshCta();
      } catch (e: any) {
        if (!cancelled) setErrorHeader(e?.message ?? 'Failed to load report summary');
      } finally {
        if (!cancelled) setLoadingHeader(false);
      }
    };

    void run();

    return () => {
      cancelled = true;
    };
  }, [reportId]);

  // Load section questions + initial answersById (from RPC rows)
  useEffect(() => {
    if (!reportId || !sectionCode) return;

    let cancelled = false;

    const run = async () => {
      setLoading(true);
      setError(null);

      try {
        const supabase = createSupabaseBrowserClient();
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

        if (!cancelled) {
          setSectionQuestions(filtered);

          setAnswersById(() => {
            const next: Record<string, LocalAnswer> = {};
            for (const q of filtered as any[]) {
              const id = q.question_id;
              if (!id) continue;
              next[id] = {
                value_text: typeof q.value_text === 'string' ? q.value_text : '',
                value_numeric: q.value_numeric != null ? String(q.value_numeric) : '',
                value_date: typeof q.value_date === 'string' ? q.value_date : '',
                na: q.value_jsonb?.na === true,
              };
            }
            return next;
          });
          await refreshCta();
        }
      } catch (e: any) {
        console.error('Load section failed:', e);
        if (!cancelled) setError(JSON.stringify(e, Object.getOwnPropertyNames(e)));
      } finally {
        if (!cancelled) setLoading(false);
      }
    };

    void run();

    return () => {
      cancelled = true;
    };
  }, [reportId, sectionCode]);

  // Report-wide stats (NA included in Completed)  ✅
  const reportStats = useMemo(() => {
    const total = allQuestions.length;
    let naCount = 0;
    let completedCount = 0;

    for (const q of allQuestions as any[]) {
      const isNA = q?.value_jsonb?.na === true;
      const hasValue = hasAnyValue(q);
      if (isNA) naCount += 1;
      if (isNA || hasValue) completedCount += 1;
    }

    const progressPct = total > 0 ? Math.round((completedCount / total) * 100) : 0;
    return { total, naCount, completedCount, progressPct };
  }, [allQuestions]);

  // Section aggregates for Sections panel
  const sectionAggregates = useMemo(() => {
    const totalBySection: Record<string, number> = {};
    const completedBySection: Record<string, number> = {};

    for (const q of allQuestions as any[]) {
      const sc = String(q.section_code ?? q.sectionCode ?? q.section ?? '').toUpperCase();
      if (!sc) continue;

      totalBySection[sc] = (totalBySection[sc] || 0) + 1;

      if (q.value_jsonb?.na === true || hasAnyValue(q)) {
        completedBySection[sc] = (completedBySection[sc] || 0) + 1;
      }
    }

    return { totalBySection, completedBySection };
  }, [allQuestions]);

  const groupAggregates = useMemo(() => {
    const totalByGroup: Record<SectionGroup, number> = {
      'General Information': 0,
      Environment: 0,
      Social: 0,
      Governance: 0,
    };
    const completedByGroup: Record<SectionGroup, number> = {
      'General Information': 0,
      Environment: 0,
      Social: 0,
      Governance: 0,
    };

    for (const q of allQuestions as any[]) {
      const sc = String(q.section_code ?? q.sectionCode ?? q.section ?? '').toUpperCase();
      if (!sc) continue;

      const group = resolveSectionGroup(sc);
      totalByGroup[group] += 1;

      if (q.value_jsonb?.na === true || hasAnyValue(q)) {
        completedByGroup[group] += 1;
      }
    }

    return { totalByGroup, completedByGroup };
  }, [allQuestions]);

  const groupedSections = useMemo(() => {
    const groups: Record<
      SectionGroup,
      Array<{ code: string; title: string; completed: number; total: number; pct: number }>
    > = {
      'General Information': [],
      Environment: [],
      Social: [],
      Governance: [],
    };

    for (const code in VSME_SECTION_META) {
      const meta = (VSME_SECTION_META as any)[code];
      const sc = String(code).toUpperCase();
      const group = resolveSectionGroup(sc);

      const total = sectionAggregates.totalBySection[sc] || 0;
      const completed = sectionAggregates.completedBySection[sc] || 0;
      const pct = total > 0 ? Math.round((completed / total) * 100) : 0;

      if (total === 0 && sc !== normalizedSectionCode) continue;

      groups[group].push({ code: sc, title: meta?.title || sc, completed, total, pct });
    }

    return groups;
  }, [sectionAggregates, normalizedSectionCode]);

  const orderedInScopeChapterCodes = useMemo(
    () =>
      GROUP_ORDER.flatMap((group) =>
        (groupedSections[group] ?? [])
          .filter((section) => section.total > 0)
          .map((section) => section.code),
      ),
    [groupedSections],
  );

  const currentChapterIndex = orderedInScopeChapterCodes.indexOf(normalizedSectionCode);
  const prevChapterCode = currentChapterIndex > 0 ? orderedInScopeChapterCodes[currentChapterIndex - 1] : undefined;
  const nextChapterCode =
    currentChapterIndex >= 0 && currentChapterIndex < orderedInScopeChapterCodes.length - 1
      ? orderedInScopeChapterCodes[currentChapterIndex + 1]
      : undefined;
  const prevChapterTitle = prevChapterCode ? VSME_SECTION_META[prevChapterCode]?.title || prevChapterCode : '';
  const nextChapterTitle = nextChapterCode ? VSME_SECTION_META[nextChapterCode]?.title || nextChapterCode : '';

  useEffect(() => {
    const onScroll = () => {
      const y = window.scrollY;
      const viewportBottom = y + window.innerHeight;
      const documentHeight = document.documentElement.scrollHeight;
      const nearBottom = documentHeight - viewportBottom <= 250;
      setShowStickyNav(y > 300 && !nearBottom);
    };

    onScroll();
    window.addEventListener('scroll', onScroll, { passive: true });
    return () => window.removeEventListener('scroll', onScroll);
  }, []);

  const saveAnswer = async (questionId: string, answerType: string, value: string | undefined) => {
    if (!reportId) return;

    const supabase = createSupabaseBrowserClient();
    const t = String(answerType ?? '').toLowerCase();

    if (!value || value === '') {
      await supabase.from('disclosure_answer').delete().eq('report_id', reportId).eq('question_id', questionId);
      await refreshCta();
      return;
    }

    const payload: any = { report_id: reportId, question_id: questionId };

    if (t === 'number' || t === 'integer' || t === 'numeric') {
      payload.value_numeric = Number(value);
    } else if (t === 'date') {
      payload.value_date = value;
    } else {
      payload.value_text = value;
    }

    await supabase.from('disclosure_answer').upsert(payload, { onConflict: 'report_id,question_id' });
    await refreshCta();
  };

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
    else await refreshCta();
      
      return;
    }

    // OFF: remove only "na" key
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
    else await refreshCta();
  };

  const targetSectionCode = String(cta?.continue_section_code || cta?.suggested_section_code || '').toUpperCase();
  const targetSectionTitle = VSME_SECTION_META[targetSectionCode]?.title || targetSectionCode;

  return (
    <div className="min-h-screen bg-gray-50 p-8">
      <div className="max-w-3xl mx-auto">
        {/* REPORT BOX (must be on top) */}
        <div className="bg-white rounded-lg border border-gray-200 border-t-4 border-t-blue-500 shadow-sm p-4 mb-6">
          <div>
            <div className="text-lg font-semibold text-gray-900">Report status</div>
          </div>

          <div className="mt-3 flex flex-wrap items-start gap-x-14 gap-y-4 max-w-[520px]">
            <div className="min-w-0">
              <div className="text-xs text-gray-500">Company</div>
              <div className="text-base font-semibold text-gray-900">{reportInfo.companyName || '—'}</div>
            </div>

            <div className="min-w-0">
              <div className="text-xs text-gray-500">Year</div>
              <div className="text-base font-semibold text-gray-900">{reportInfo.reportingYear || '—'}</div>
            </div>

            <div className="min-w-0">
              <div className="text-xs text-gray-500">Question set</div>
              <div className="text-base font-semibold text-gray-900">{reportInfo.vsmeMode || 'Core'}</div>
            </div>
          </div>

          <div className="mt-4 flex flex-wrap items-center gap-x-6 gap-y-2 text-sm">
            <div>
              <span className="text-gray-500">Questions:</span>{' '}
              <span className="font-semibold text-gray-900">{reportStats.total}</span>
            </div>
            <div>
              <span className="text-gray-500">Completed:</span>{' '}
              <span className="font-semibold text-gray-900">{reportStats.completedCount}</span>
            </div>
            <div>
              <span className="text-gray-500">Progress:</span>{' '}
              <span className="font-semibold text-emerald-600">{reportStats.progressPct}%</span>
            </div>
          </div>

          <div className="mt-3">
            <div className="h-2 rounded bg-gray-100 overflow-hidden">
              <div
                className="h-2 rounded bg-emerald-500 transition-all"
                style={{ width: `${reportStats.progressPct}%` }}
              />
            </div>

            <div className="mt-2 text-xs text-gray-500">
              {reportStats.naCount} questions marked as Not Applicable (included in Completed)
            </div>

            {errorHeader ? <div className="mt-2 text-xs text-red-600">{errorHeader}</div> : null}
            {loadingHeader ? <div className="mt-2 text-xs text-gray-400">Loading report summary…</div> : null}
          </div>
        </div>

        {targetSectionCode && targetSectionCode !== normalizedSectionCode ? (
          <div className="flex justify-center mt-6 mb-4">
            <Link
              href={`/${locale}/reports/${reportId}/sections/${targetSectionCode}`}
              className="inline-flex items-center rounded-full bg-blue-600 hover:bg-blue-700 text-white text-sm font-medium px-5 py-2.5 transition shadow-sm"
            >
              Continue {targetSectionCode} — {targetSectionTitle}
            </Link>
          </div>
        ) : null}

        {/* SECTIONS PANEL */}
        <div className="mb-6 bg-white rounded-xl border border-gray-200 shadow-sm p-3">
          <div className="text-lg font-bold text-gray-900 mb-2">Sections</div>

          <div className="space-y-2">
          {GROUP_ORDER.map((group) => {
            const sections = groupedSections[group] ?? [];
            const groupCompleted = groupAggregates.completedByGroup[group] || 0;
            const groupTotal = groupAggregates.totalByGroup[group] || 0;
            const groupPct = groupTotal > 0 ? Math.round((groupCompleted / groupTotal) * 100) : 0;
            return (
            <div key={group}>
              <button
                type="button"
                data-open={openGroup === group}
                className={[
                  'w-full flex items-center justify-between px-3 py-2 rounded-lg cursor-pointer transition-colors hover:bg-gray-50 border',
                  'focus:outline-none',
                  group === openGroup ? 'bg-blue-50/40 border-blue-200' : 'bg-gray-50 border-gray-200',
                ].join(' ')}
                onClick={() => setOpenGroup(group as SectionGroup)}
              >
                <div className="min-w-0 flex-1 flex items-center gap-2">
                  <span className={[
                    'leading-tight',
                    'text-sm font-semibold',
                    group === currentGroup ? 'text-blue-700' : 'text-gray-900',
                  ].join(' ')}>{group}</span>
                  <span className="text-gray-400 text-xs">{group === openGroup ? '▾' : '▸'}</span>
                </div>
                <div className="grid grid-cols-[64px_40px] gap-x-2 shrink-0 text-right tabular-nums">
                  <div className="text-sm font-medium text-gray-600">
                    {groupCompleted}/{groupTotal}
                  </div>
                  <div className="text-sm font-normal text-gray-500">
                    {groupPct}%
                  </div>
                </div>
              </button>

              {openGroup === group && (
                <ul className="mt-1 ml-2 pl-2 border-l border-gray-200 space-y-1">
                  {sections.length === 0 ? (
                    <li className="text-xs text-gray-500 px-3 py-2">No sections in this theme</li>
                  ) : (
                    sections.map((section) => {
                      const isCurrent = section.code === normalizedSectionCode;
                      return (
                        <li
                          key={section.code}
                          className={[
                            'flex items-center justify-between px-3 py-2 transition-colors',
                            isCurrent
                              ? 'bg-blue-50 border border-blue-200 rounded-lg'
                              : 'rounded-md hover:bg-gray-50',
                          ].join(' ')}
                        >
                          <Link
                            href={`/${locale}/reports/${reportId}/sections/${section.code}`}
                            className="min-w-0 flex-1 truncate"
                          >
                            <span className={[
                              'leading-tight',
                              isCurrent ? 'text-sm font-semibold text-blue-700' : 'text-sm font-normal text-gray-900',
                            ].join(' ')}>{section.code} — {section.title}</span>
                          </Link>
                          <div className="grid grid-cols-[64px_40px] gap-x-2 shrink-0 text-right tabular-nums">
                            <div className="text-xs font-normal text-gray-400">{section.completed}/{section.total}</div>
                            <div></div>
                          </div>
                        </li>
                      );
                    })
                  )}
                </ul>
              )}
            </div>
            );
          })}
          </div>
        </div>

        <div className="mb-4 flex items-center justify-between">
          <div>
            <h1 className="text-2xl font-bold text-gray-900">
              {sectionCode} — {sectionTitle}
            </h1>
          </div>

          <Link
            href={`/${locale}/reports/${reportId}/questions`}
            className="px-3 py-2 bg-gray-700 text-white rounded text-sm"
          >
            Back
          </Link>
        </div>

        {/* SECTION QUESTIONS */}
        {loading ? (
          <div className="text-gray-600">Loading section…</div>
        ) : error ? (
          <div className="bg-red-50 border border-red-200 rounded p-4">
            <div className="font-semibold text-red-800">Error</div>
            <div className="text-red-700 text-sm mt-1">{error}</div>
          </div>
        ) : sectionQuestions.length === 0 ? (
          <div className="bg-yellow-50 border border-yellow-200 rounded p-4 text-yellow-900">
            No questions matched this section.
          </div>
        ) : (
          <>
            <ul className="space-y-2">
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
                      isNa ? 'border-l-amber-400 bg-amber-50/25' : 'border-l-blue-500 bg-white',
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
                      <div className="mt-3 text-xs text-gray-500">Marked as Not applicable (answer preserved)</div>
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

            {(prevChapterCode || nextChapterCode) ? (
              <div className="max-w-3xl mx-auto mt-10">
                <div className="flex gap-4">
                  {prevChapterCode ? (
                    <Link
                      href={`/${locale}/reports/${reportId}/sections/${prevChapterCode}`}
                      className="h-full flex flex-col justify-center flex-1 px-4 py-3 rounded-lg border border-gray-300 bg-white hover:bg-gray-50 text-gray-800 text-sm font-medium leading-tight transition shadow-sm"
                    >
                      <span className="text-gray-500 text-xs">← Previous</span>
                      <span className="truncate">
                        {prevChapterCode} — {prevChapterTitle}
                      </span>
                    </Link>
                  ) : (
                    <div className="flex-1" />
                  )}

                  {nextChapterCode ? (
                    <Link
                      href={`/${locale}/reports/${reportId}/sections/${nextChapterCode}`}
                      className="h-full flex flex-col justify-center flex-1 px-4 py-3 rounded-lg bg-blue-600 hover:bg-blue-700 text-white text-sm font-medium leading-tight transition shadow-sm"
                    >
                      <span className="text-blue-100 text-xs">Next →</span>
                      <span className="truncate">
                        {nextChapterCode} — {nextChapterTitle}
                      </span>
                    </Link>
                  ) : (
                    <div className="flex-1" />
                  )}
                </div>
              </div>
            ) : null}
          </>
        )}

        {showStickyNav && sectionQuestions.length > 0 && !loading && !error && (prevChapterCode || nextChapterCode) ? (
          <div className="fixed bottom-6 left-1/2 -translate-x-1/2 z-40 flex items-stretch gap-2 bg-white/95 backdrop-blur border border-gray-200 rounded-xl shadow-lg p-2">
            <div className="flex gap-2 items-stretch">
              {prevChapterCode ? (
                <Link
                  href={`/${locale}/reports/${reportId}/sections/${prevChapterCode}`}
                  className="h-full flex flex-col justify-center rounded-lg border border-gray-300 bg-white hover:bg-gray-50 text-gray-800 text-xs font-medium px-4 py-2 leading-tight transition min-w-[200px]"
                >
                  <span className="text-gray-500">← Previous</span>
                  <span className="truncate">
                    {prevChapterCode} — {prevChapterTitle}
                  </span>
                </Link>
              ) : (
                <div className="flex-1" />
              )}

              {nextChapterCode ? (
                <Link
                  href={`/${locale}/reports/${reportId}/sections/${nextChapterCode}`}
                  className="h-full flex flex-col justify-center rounded-lg bg-blue-600 hover:bg-blue-700 text-white text-xs font-medium px-4 py-2 leading-tight transition min-w-[200px]"
                >
                  <span className="text-blue-100">Next →</span>
                  <span className="truncate">
                    {nextChapterCode} — {nextChapterTitle}
                  </span>
                </Link>
              ) : (
                <div className="flex-1" />
              )}
            </div>
          </div>
        ) : null}
      </div>
    </div>
  );
}