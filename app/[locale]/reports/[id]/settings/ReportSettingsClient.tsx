'use client';

import { useCallback, useEffect, useMemo, useState } from 'react';
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

type SectionGroup = 'General Information' | 'Environment' | 'Social' | 'Governance';
type ReportMode = 'core' | 'core_plus' | 'comprehensive';
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

function resolveSectionGroup(sc: string): SectionGroup {
  const normalized = String(sc || '').toUpperCase();
  const override = SECTION_GROUP_OVERRIDE[normalized];
  if (override) return override;

  if (normalized.startsWith('B')) return 'Environment';
  if (normalized.startsWith('C')) return 'Social';
  if (normalized.startsWith('G')) return 'Governance';
  return 'General Information';
}

function questionState(q: any): 'Answered' | 'N/A' | 'Missing' {
  if (q?.value_jsonb?.na === true) return 'N/A';
  if (hasAnyValue(q)) return 'Answered';
  return 'Missing';
}

export default function ReportSettingsClient() {
  const params = useParams<{ locale: string; id: string }>();
  const locale = typeof params.locale === 'string' ? params.locale : 'en';
  const reportId = typeof params.id === 'string' ? params.id : '';

  useEffect(() => {
    console.log('@@@ ReportSettingsClient rendered @@@');
  }, []);

  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const [reportInfo, setReportInfo] = useState<{
    companyName?: string | null;
    reportingYear?: number | null;
    vsmeMode?: string | null;
  }>({});

  const [allQuestions, setAllQuestions] = useState<VsmeQuestion[]>([]);
  const [packs, setPacks] = useState<Array<{ code: string; name: string; description: string | null }>>([]);
  const [selectedMode, setSelectedMode] = useState<ReportMode>('core');
  const [selectedPacks, setSelectedPacks] = useState<string[]>([]);
  const [savingScope, setSavingScope] = useState(false);
  const [scopeMessage, setScopeMessage] = useState<{ type: 'success' | 'error'; text: string } | null>(null);

  const [qSearch, setQSearch] = useState('');
  const [onlyState, setOnlyState] = useState<'all' | 'missing' | 'answered' | 'na'>('all');

  const loadAll = useCallback(async () => {
    if (!reportId) return;

    setLoading(true);
    setError(null);

    try {
      const supabase = createSupabaseBrowserClient();

      const { data: reportRow, error: reportErr } = await supabase
        .from('report')
        .select('reporting_year, vsme_mode, vsme_pack_codes, company:company_id(name)')
        .eq('id', reportId)
        .maybeSingle();

      if (reportErr) throw reportErr;

      setReportInfo({
        companyName: (reportRow as any)?.company?.name ?? null,
        reportingYear: (reportRow as any)?.reporting_year ?? null,
        vsmeMode: (reportRow as any)?.vsme_mode ?? null,
      });

      const rowModeRaw = String((reportRow as any)?.vsme_mode ?? '').toLowerCase();
      const nextMode: ReportMode =
        rowModeRaw === 'core_plus' || rowModeRaw === 'comprehensive' || rowModeRaw === 'core'
          ? (rowModeRaw as ReportMode)
          : 'core';
      const rowPacks = Array.isArray((reportRow as any)?.vsme_pack_codes)
        ? ((reportRow as any).vsme_pack_codes as unknown[])
            .map((v) => String(v ?? '').trim())
            .filter(Boolean)
        : [];

      setSelectedMode(nextMode);
      setSelectedPacks(nextMode === 'core_plus' ? rowPacks : []);

      const { data: packRows, error: packsErr } = await supabase
        .from('report_pack')
        .select('code, name, description')
        .order('name', { ascending: true });

      if (packsErr) throw packsErr;

      setPacks(
        ((packRows as any[]) || []).map((p) => ({
          code: String(p?.code ?? ''),
          name: String(p?.name ?? ''),
          description: p?.description == null ? null : String(p.description),
        })),
      );

      const { data, error: rpcError } = await supabase.rpc('get_vsme_questions_for_report_v2', {
        p_report_id: reportId,
      });

      if (rpcError) throw rpcError;

      setAllQuestions((data as VsmeQuestion[]) || []);
    } catch (e: any) {
      setError(e?.message ?? 'Failed to load questions');
      setAllQuestions([]);
    } finally {
      setLoading(false);
    }
  }, [reportId]);

  const saveScope = useCallback(async () => {
    if (!reportId) return;

    setSavingScope(true);
    setScopeMessage(null);

    try {
      const supabase = createSupabaseBrowserClient();
      const nextPackCodes = selectedMode === 'core_plus' ? selectedPacks : [];

      const { error: updateError } = await supabase
        .from('report')
        .update({
          vsme_mode: selectedMode,
          vsme_pack_codes: nextPackCodes,
        })
        .eq('id', reportId);

      if (updateError) throw updateError;

      setScopeMessage({ type: 'success', text: 'Scope saved.' });
      await loadAll();
    } catch (e: any) {
      setScopeMessage({ type: 'error', text: e?.message ?? 'Failed to save scope' });
    } finally {
      setSavingScope(false);
    }
  }, [reportId, selectedMode, selectedPacks, loadAll]);

  useEffect(() => {
    if (!reportId) {
      setLoading(false);
      return;
    }
    void loadAll();
  }, [reportId, loadAll]);

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

      groups[group].push({ code: sc, title: meta?.title || sc, completed, total, pct });
    }

    return groups;
  }, [sectionAggregates]);

  const visibleQuestions = useMemo(() => {
    const s = qSearch.trim().toLowerCase();

    return (allQuestions as any[]).filter((q) => {
      const state = questionState(q);
      if (onlyState === 'missing' && state !== 'Missing') return false;
      if (onlyState === 'answered' && state !== 'Answered') return false;
      if (onlyState === 'na' && state !== 'N/A') return false;

      if (!s) return true;

      const hay = [
        q.question_text,
        q.code,
        q.vsme_datapoint_id,
        q.section_code,
      ]
        .map((x) => String(x ?? '').toLowerCase())
        .join(' | ');

      return hay.includes(s);
    });
  }, [allQuestions, qSearch, onlyState]);

  return (
    <div className="min-h-screen bg-gray-50 p-8 pb-24">
      <div className="max-w-4xl mx-auto">
        <div className="mb-4 rounded-lg border border-yellow-300 bg-yellow-100 px-4 py-3 text-sm font-semibold text-yellow-900">
          DEBUG: VsmeQuestionsClient.tsx is rendering (Questions page)
        </div>

        <div className="bg-white rounded-lg border border-gray-200 border-t-4 border-t-blue-500 shadow-sm p-4 mb-6">
          <div className="flex items-center justify-between gap-3">
            <div className="text-lg font-semibold text-gray-900">Report status</div>

            <div className="flex items-center gap-2">
              <button
                type="button"
                disabled
                title="TODO: scope UI"
                className="shrink-0 inline-flex items-center rounded-md bg-blue-600 px-3 py-1.5 text-xs font-medium text-white opacity-60 cursor-not-allowed"
              >
                Change scope
              </button>

              <button
                type="button"
                onClick={() => void loadAll()}
                className="shrink-0 inline-flex items-center rounded-md border border-gray-300 bg-white px-3 py-1.5 text-xs font-medium text-gray-600 hover:bg-gray-50"
              >
                Reload questions
              </button>
            </div>
          </div>

          <div className="mt-1 text-xs text-gray-500">TODO: scope UI</div>

          <div className="mt-3 flex flex-wrap items-start gap-x-14 gap-y-4 max-w-[620px]">
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
              <div className="h-2 rounded bg-emerald-500 transition-all" style={{ width: `${reportStats.progressPct}%` }} />
            </div>
            <div className="mt-2 text-xs text-gray-500">
              {reportStats.naCount} questions marked as Not Applicable (included in Completed)
            </div>
          </div>

          <div className="mt-4 rounded-lg border border-slate-200 bg-slate-50 p-3">
            <div className="text-sm font-semibold text-slate-900">Scope</div>

            <div className="mt-2 space-y-2">
              <label className="flex items-center gap-2 text-sm text-slate-800">
                <input
                  type="radio"
                  name="vsme-mode"
                  checked={selectedMode === 'core'}
                  onChange={() => {
                    setSelectedMode('core');
                    setSelectedPacks([]);
                  }}
                />
                <span>Core</span>
              </label>

              <label className="flex items-center gap-2 text-sm text-slate-800">
                <input
                  type="radio"
                  name="vsme-mode"
                  checked={selectedMode === 'core_plus'}
                  onChange={() => setSelectedMode('core_plus')}
                />
                <span>Core Plus</span>
              </label>

              <label className="flex items-center gap-2 text-sm text-slate-800">
                <input
                  type="radio"
                  name="vsme-mode"
                  checked={selectedMode === 'comprehensive'}
                  onChange={() => {
                    setSelectedMode('comprehensive');
                    setSelectedPacks([]);
                  }}
                />
                <span>Comprehensive</span>
              </label>
            </div>

            {selectedMode === 'core_plus' ? (
              <div className="mt-3 rounded-md border border-slate-200 bg-white p-3">
                <div className="text-xs font-medium text-slate-700">Add-on packs</div>
                {packs.length === 0 ? (
                  <div className="mt-2 text-xs text-slate-500">No packs found.</div>
                ) : (
                  <div className="mt-2 space-y-2">
                    {packs.map((pack) => {
                      const checked = selectedPacks.includes(pack.code);
                      return (
                        <label key={pack.code} className="flex items-start gap-2 text-sm text-slate-800">
                          <input
                            type="checkbox"
                            checked={checked}
                            onChange={() => {
                              setSelectedPacks((prev) =>
                                prev.includes(pack.code)
                                  ? prev.filter((code) => code !== pack.code)
                                  : [...prev, pack.code],
                              );
                            }}
                            className="mt-0.5"
                          />
                          <span>
                            <span className="font-medium">{pack.name || pack.code}</span>
                            {pack.description ? <span className="block text-xs text-slate-500">{pack.description}</span> : null}
                          </span>
                        </label>
                      );
                    })}
                  </div>
                )}
              </div>
            ) : null}

            {selectedMode === 'comprehensive' ? (
              <div className="mt-3 text-xs text-slate-600">
                Full VSME report (includes all datapoints). Add-ons are not applicable.
              </div>
            ) : null}

            <div className="mt-3 flex items-center gap-3">
              <button
                type="button"
                onClick={() => void saveScope()}
                disabled={savingScope}
                className="inline-flex items-center rounded-md bg-blue-600 px-3 py-1.5 text-xs font-medium text-white hover:bg-blue-700 disabled:opacity-60 disabled:cursor-not-allowed"
              >
                {savingScope ? 'Saving…' : 'Save scope'}
              </button>

              {scopeMessage ? (
                <div className={scopeMessage.type === 'success' ? 'text-xs text-emerald-700' : 'text-xs text-red-700'}>
                  {scopeMessage.text}
                </div>
              ) : null}
            </div>
          </div>

          {error ? (
            <div className="mt-3 bg-red-50 border border-red-200 rounded p-3">
              <div className="font-semibold text-red-800 text-sm">Error</div>
              <div className="text-red-700 text-xs mt-1">{error}</div>
            </div>
          ) : null}
        </div>

        <div className="mb-6 bg-white rounded-xl border border-gray-200 shadow-sm p-3">
          <div className="text-lg font-bold text-gray-900 mb-2">Sections</div>

          <div className="space-y-3">
            {GROUP_ORDER.map((group) => {
              const sections = groupedSections[group] ?? [];
              return (
                <div key={group} className="border border-gray-200 rounded-lg overflow-hidden">
                  <div className="px-3 py-2 bg-gray-50 border-b border-gray-200 text-sm font-semibold text-gray-900">
                    {group}
                  </div>

                  <ul className="divide-y divide-gray-100">
                    {sections.map((s) => (
                      <li key={s.code} className="flex items-center justify-between px-3 py-2">
                        <Link
                          href={`/${locale}/reports/${reportId}/sections/${s.code}`}
                          className="min-w-0 flex-1 truncate text-sm text-gray-900 hover:underline"
                        >
                          {s.code} — {s.title}
                        </Link>
                        <div className="shrink-0 text-right tabular-nums">
                          <div className="text-xs text-gray-600">{s.completed}/{s.total}</div>
                          <div className="text-xs text-gray-400">{s.total > 0 ? `${s.pct}%` : '—'}</div>
                        </div>
                      </li>
                    ))}
                  </ul>
                </div>
              );
            })}
          </div>
        </div>

        <div className="mb-4 bg-white rounded-xl border border-gray-200 shadow-sm p-3">
          <div className="flex flex-wrap items-center gap-2">
            <input
              value={qSearch}
              onChange={(e) => setQSearch(e.target.value)}
              placeholder="Search (text / code / datapoint / section)…"
              className="flex-1 min-w-[260px] px-3 py-2 border border-gray-300 rounded text-sm"
            />

            <select
              value={onlyState}
              onChange={(e) => setOnlyState(e.target.value as any)}
              className="px-3 py-2 border border-gray-300 rounded text-sm bg-white"
            >
              <option value="all">All</option>
              <option value="missing">Missing only</option>
              <option value="answered">Answered only</option>
              <option value="na">N/A only</option>
            </select>

            <div className="text-xs text-gray-500">
              Showing <span className="font-semibold text-gray-800">{visibleQuestions.length}</span> / {allQuestions.length}
            </div>
          </div>
        </div>

        {loading ? (
          <div className="text-gray-600">Loading questions…</div>
        ) : !reportId ? (
          <div className="bg-yellow-50 border border-yellow-200 rounded p-4 text-yellow-900">
            Missing reportId param
          </div>
        ) : error ? (
          <div className="bg-red-50 border border-red-200 rounded p-4">
            <div className="font-semibold text-red-800">Error</div>
            <div className="text-red-700 text-sm mt-1">{error}</div>
          </div>
        ) : !error && allQuestions.length === 0 ? (
          <div className="bg-yellow-50 border border-yellow-200 rounded p-4 text-yellow-900">
            0 questions returned by RPC. Check report_id / scope / RLS.
          </div>
        ) : (
          <ul className="space-y-2">
            {visibleQuestions.map((q: any, idx: number) => {
              const state = questionState(q);
              const sc = String(q.section_code ?? '').toUpperCase();
              const code = String(q.code ?? '');
              const dp = String(q.vsme_datapoint_id ?? '');
              const unit = String(q.unit ?? '').trim();
              const guidance = String(q.guidance_text ?? '').trim();

              const badge =
                state === 'Answered'
                  ? 'bg-emerald-50 text-emerald-700 border-emerald-200'
                  : state === 'N/A'
                    ? 'bg-slate-50 text-slate-600 border-slate-200'
                    : 'bg-amber-50 text-amber-800 border-amber-200';

              return (
                <li key={q.question_id ?? `${sc}-${code}-${idx}`} className="bg-white rounded-lg border border-gray-200 shadow-sm p-4">
                  <div className="flex items-start justify-between gap-3">
                    <div className="min-w-0">
                      <div className="text-[11px] text-gray-400">
                        #{idx + 1} • {sc || '—'} • {code || '—'}
                      </div>
                      <div className="mt-1 text-base font-semibold text-gray-900">
                        {q.question_text ?? q.title ?? 'Untitled question'}
                      </div>
                      {guidance ? <div className="mt-1 text-sm text-slate-600">{guidance}</div> : null}

                      <div className="mt-2 text-xs text-gray-500">
                        <span className="font-medium text-gray-700">section:</span> {sc || '—'}
                        {' '}
                        <span className="text-gray-300">•</span>{' '}
                        <span className="font-medium text-gray-700">code:</span> {code || '—'}
                        {' '}
                        <span className="text-gray-300">•</span>{' '}
                        <span className="font-medium text-gray-700">datapoint:</span> {dp || '—'}
                        {' '}
                        <span className="text-gray-300">•</span>{' '}
                        <span className="font-medium text-gray-700">unit:</span> {unit || '—'}
                      </div>
                    </div>

                    <div className={`shrink-0 inline-flex items-center rounded-full border px-2 py-1 text-xs font-medium ${badge}`}>
                      {state}
                    </div>
                  </div>
                </li>
              );
            })}
          </ul>
        )}
      </div>
    </div>
  );
}