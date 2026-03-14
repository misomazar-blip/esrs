'use client';

import { useEffect, useMemo, useState, useCallback, useRef } from 'react';
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
  const b = a.value_boolean === true || a.value_boolean === false;
  return t.length > 0 || n.length > 0 || d.length > 0 || b;
}

function isFactDatapoint(q: any) {
  return String(q?.datapoint_kind ?? '').toLowerCase() === 'fact';
}

// ─── B3 GHG composite card constants ────────────────────────────────────────
// Single source of truth for all B3 GHG datapoint codes. Referenced by
// b3ComputedTotalsModel, b3DerivedPersistModel, b3IntensityModel, and
// b3IntensityPersistModel so the strings are never repeated inline.
const B3_GHG_SOURCE_CODES = {
  scope1: 'GROSSSCOPE1GREENHOUSEGASEMISSIONS',
  scope2Location: 'GROSSLOCATIONBASEDSCOPE2GREENHOUSEGASEMISSIONS',
  scope2Market: 'GROSSMARKETBASEDSCOPE2GREENHOUSEGASEMISSIONS',
} as const;

const B3_GHG_TOTAL_CODES = {
  location: 'TOTALGROSSLOCATIONBASEDSCOPE1ANDSCOPE2GHGEMISSIONS',
  market: 'TOTALGROSSMARKETBASEDSCOPE1ANDSCOPE2GHGEMISSIONS',
} as const;

const B3_GHG_INTENSITY_DP = {
  location: 'SCOPE1ANDSCOPE2GREENHOUSEGASEMISSIONSINTENSITYVALUELOCATIONBASED',
  market: 'SCOPE1ANDSCOPE2GREENHOUSEGASEMISSIONSINTENSITYVALUEMARKETBASED',
} as const;

const B3_GHG_TURNOVER_DP = 'TURNOVER';
// ─────────────────────────────────────────────────────────────────────────────

function isB3IntensityQuestionCode(value: unknown) {
  const normalized = String(value ?? '').trim().toUpperCase();
  return normalized === B3_GHG_INTENSITY_DP.location || normalized === B3_GHG_INTENSITY_DP.market;
}

function normalizeExample(exampleAnswer: unknown) {
  let normalized = String(exampleAnswer ?? '').trim();
  if (!normalized) return '';

  normalized = normalized.replace(/^example:\s*/i, '').trim();

  const startsWithQuote = ['"', "'", '“', '”', '‘', '’'].includes(normalized.charAt(0));
  const endsWithQuote = ['"', "'", '“', '”', '‘', '’'].includes(normalized.charAt(normalized.length - 1));
  if (startsWithQuote && endsWithQuote && normalized.length >= 2) {
    normalized = normalized.slice(1, -1).trim();
  }

  return normalized;
}

function isFilled(a: any) {
  return a?.na === true || hasAnyValue(a);
}

function buildPlaceholder(exampleAnswer: unknown) {
  const normalized = normalizeExample(exampleAnswer);
  return normalized ? `Example: ${normalized}` : '';
}

function getPlaceholder(q: any, a: any) {
  const answerType = String(q?.answer_type ?? '').toLowerCase();
  if (isFilled(a)) return '';
  if (answerType === 'text' || answerType === 'string' || answerType === 'number' || answerType === 'integer' || answerType === 'numeric') {
    return buildPlaceholder(q?.example_answer);
  }
  return '';
}

type LocalAnswer = {
  value_text?: string;
  value_numeric?: string; // stored as string in UI
  value_date?: string;
  value_boolean?: boolean | null;
  na?: boolean;
};

type B1QuestionGroup = {
  id?: string;
  code?: string;
  group_kind?: string;
  title?: string;
  label?: string;
  name?: string;
  sort_order?: number;
  order_index?: number;
};

type B1QuestionGroupItem = {
  id?: string;
  group_id?: string;
  question_group_id?: string;
  group_code?: string;
  question_group_code?: string;
  question_id?: string;
  disclosure_question_id?: string;
  question_code?: string;
  vsme_datapoint_id?: string;
  role?: string;
  sort_order?: number;
  order_index?: number;
};

type B1InteractionRule = {
  id?: string;
  rule_type?: string;
  interaction_type?: string;
  type?: string;
  group_id?: string;
  question_group_id?: string;
  group_code?: string;
  question_group_code?: string;
  parent_question_id?: string;
  parent_disclosure_question_id?: string;
  parent_question_code?: string;
  parent_code?: string;
  child_question_id?: string;
  child_disclosure_question_id?: string;
  child_question_code?: string;
  child_code?: string;
  config_jsonb?: Record<string, any>;
  config?: Record<string, any>;
};

type SectionGroup = 'General Information' | 'Environment' | 'Social' | 'Governance';
const GROUP_ORDER = ['General Information', 'Environment', 'Social', 'Governance'] as const;
const CURRENCY_UNITS = ['EUR', 'USD', 'GBP', 'CZK', 'PLN', 'HUF', 'CHF'] as const;
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
  const isB1Section = normalizedSectionCode === 'B1';
  const isBSection = normalizedSectionCode.startsWith('B');

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
  const [b1QuestionGroups, setB1QuestionGroups] = useState<B1QuestionGroup[]>([]);
  const [b1QuestionGroupItems, setB1QuestionGroupItems] = useState<B1QuestionGroupItem[]>([]);
  const [b1InteractionRules, setB1InteractionRules] = useState<B1InteractionRule[]>([]);
  const [answersById, setAnswersById] = useState<Record<string, LocalAnswer>>({});
  const [savingById, setSavingById] = useState<Record<string, boolean>>({});
  const [savedAtById, setSavedAtById] = useState<Record<string, number>>({});
  const [errorById, setErrorById] = useState<Record<string, string | null>>({});
  const [b3EnergyBreakdownNa, setB3EnergyBreakdownNa] = useState(false);
  const [b3TotalEnergyUserInteracted, setB3TotalEnergyUserInteracted] = useState(false);
  const [b3EnergyBreakdownValues, setB3EnergyBreakdownValues] = useState<
    Record<'electricity_purchased' | 'self_generated_electricity' | 'fuels', { renewable: string; nonRenewable: string; total: string }>
  >({
    electricity_purchased: { renewable: '', nonRenewable: '', total: '' },
    self_generated_electricity: { renewable: '', nonRenewable: '', total: '' },
    fuels: { renewable: '', nonRenewable: '', total: '' },
  });
  const b3EnergyBreakdownValuesRef = useRef(b3EnergyBreakdownValues);
  const b3DetailPersistTimeoutsRef = useRef<
    Record<'electricity_purchased' | 'self_generated_electricity' | 'fuels', number | null>
  >({
    electricity_purchased: null,
    self_generated_electricity: null,
    fuels: null,
  });
  const b3HydrationDoneRef = useRef(false);
  const b3RecomputeTriggerRef = useRef<'source' | 'turnover' | 'other'>('other');
  const [reportCurrency, setReportCurrency] = useState<string | null>(null);
  const [scrolledPastThreshold, setScrolledPastThreshold] = useState(false);
  const [footerNavVisible, setFooterNavVisible] = useState(false);
  const footerNavRef = useRef<HTMLDivElement | null>(null);

  const normalizeCurrency = useCallback((value: unknown) => {
    const next = String(value ?? '').trim().toUpperCase();
    return next || null;
  }, []);

  // Sections panel state
  const [openGroup, setOpenGroup] = useState<SectionGroup>(currentGroup);

  useEffect(() => {
    setOpenGroup(currentGroup);
  }, [currentGroup]);

  useEffect(() => {
    if (normalizedSectionCode !== 'B3') {
      setB3TotalEnergyUserInteracted(false);
      setB3EnergyBreakdownNa(false);
    }
  }, [normalizedSectionCode]);

  useEffect(() => {
    b3EnergyBreakdownValuesRef.current = b3EnergyBreakdownValues;
  }, [b3EnergyBreakdownValues]);

  useEffect(() => {
    if (normalizedSectionCode === 'B3') return;

    for (const timeoutId of Object.values(b3DetailPersistTimeoutsRef.current)) {
      if (timeoutId !== null) {
        window.clearTimeout(timeoutId);
      }
    }

    b3DetailPersistTimeoutsRef.current = {
      electricity_purchased: null,
      self_generated_electricity: null,
      fuels: null,
    };
  }, [normalizedSectionCode]);

  useEffect(() => {
    return () => {
      for (const timeoutId of Object.values(b3DetailPersistTimeoutsRef.current)) {
        if (timeoutId !== null) {
          window.clearTimeout(timeoutId);
        }
      }
    };
  }, []);

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

        const { data: allQs, error: allQsErr } = await supabase.rpc('get_vsme_questions_for_report_v2', {
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
        const { data, error: rpcError } = await supabase.rpc('get_vsme_questions_for_report_v2', {
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
                value_boolean: typeof (q as any).value_boolean === 'boolean' ? (q as any).value_boolean : null,
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

  useEffect(() => {
    if (!isBSection) {
      setB1QuestionGroups([]);
      setB1QuestionGroupItems([]);
      setB1InteractionRules([]);
      return;
    }

    let cancelled = false;

    const run = async () => {
      try {
        const supabase = createSupabaseBrowserClient();

        const { data: groupsData, error: groupsError } = await supabase
          .from('question_group')
          .select('*')
          .eq('framework', 'VSME')
          .eq('taxonomy_version', '1.2.0')
          .eq('section_code', normalizedSectionCode)
          .order('sort_order', { ascending: true });

        if (groupsError) {
          if (!cancelled) {
            setB1QuestionGroups([]);
            setB1QuestionGroupItems([]);
            setB1InteractionRules([]);
          }
          return;
        }

        const groupIds = ((groupsData as any[]) ?? [])
          .map((g: any) => String(g?.id ?? '').trim())
          .filter(Boolean);

        let itemsData: any[] = [];
        let itemsError: any = null;
        let rulesData: any[] = [];
        let rulesError: any = null;

        if (groupIds.length > 0) {
          const [itemsRes, rulesRes] = await Promise.all([
            supabase
              .from('question_group_item')
              .select('*')
              .in('group_id', groupIds)
              .order('sort_order', { ascending: true }),
            supabase
              .from('question_interaction_rule')
              .select('*'),
          ]);

          itemsData = (itemsRes.data as any[]) ?? [];
          itemsError = itemsRes.error;
          rulesData = (rulesRes.data as any[]) ?? [];
          rulesError = rulesRes.error;
        }

        if (itemsError || rulesError) {
          if (!cancelled) {
            setB1QuestionGroups([]);
            setB1QuestionGroupItems([]);
            setB1InteractionRules([]);
          }
          return;
        }

        if (!cancelled) {
          setB1QuestionGroups(((groupsData as any[]) ?? []) as B1QuestionGroup[]);
          setB1QuestionGroupItems(((itemsData as any[]) ?? []) as B1QuestionGroupItem[]);
          setB1InteractionRules(((rulesData as any[]) ?? []) as B1InteractionRule[]);
        }
      } catch {
        if (!cancelled) {
          setB1QuestionGroups([]);
          setB1QuestionGroupItems([]);
          setB1InteractionRules([]);
        }
      }
    };

    void run();

    return () => {
      cancelled = true;
    };
  }, [isBSection, normalizedSectionCode]);

  // Report-wide stats (NA included in Completed)  ✅
  const factQuestions = useMemo(
    () => (allQuestions as any[]).filter((q) => isFactDatapoint(q)),
    [allQuestions],
  );

  const reportStats = useMemo(() => {
    const total = factQuestions.length;
    let naCount = 0;
    let completedCount = 0;

    for (const q of factQuestions) {
      const isNA = q?.value_jsonb?.na === true;
      const hasValue = hasAnyValue(q);
      if (isNA) naCount += 1;
      if (isNA || hasValue) completedCount += 1;
    }

    const progressPct = total > 0 ? Math.round((completedCount / total) * 100) : 0;
    return { total, naCount, completedCount, progressPct };
  }, [factQuestions]);

  // Section aggregates for Sections panel
  const sectionAggregates = useMemo(() => {
    const totalBySection: Record<string, number> = {};
    const completedBySection: Record<string, number> = {};

    for (const q of factQuestions) {
      const sc = String(q.section_code ?? q.sectionCode ?? q.section ?? '').toUpperCase();
      if (!sc) continue;

      totalBySection[sc] = (totalBySection[sc] || 0) + 1;

      if (q.value_jsonb?.na === true || hasAnyValue(q)) {
        completedBySection[sc] = (completedBySection[sc] || 0) + 1;
      }
    }

    return { totalBySection, completedBySection };
  }, [factQuestions]);

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

    for (const q of factQuestions) {
      const sc = String(q.section_code ?? q.sectionCode ?? q.section ?? '').toUpperCase();
      if (!sc) continue;

      const group = resolveSectionGroup(sc);
      totalByGroup[group] += 1;

      if (q.value_jsonb?.na === true || hasAnyValue(q)) {
        completedByGroup[group] += 1;
      }
    }

    return { totalByGroup, completedByGroup };
  }, [factQuestions]);

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
  const showStickyNav = scrolledPastThreshold && !footerNavVisible;

  useEffect(() => {
    const onScroll = () => {
      setScrolledPastThreshold(window.scrollY > 450);
    };

    onScroll();
    window.addEventListener('scroll', onScroll, { passive: true });
    return () => window.removeEventListener('scroll', onScroll);
  }, []);

  useEffect(() => {
    const node = footerNavRef.current;
    if (!node) {
      setFooterNavVisible(false);
      return;
    }

    const observer = new IntersectionObserver(
      ([entry]) => {
        setFooterNavVisible(entry.isIntersecting);
      },
      { threshold: 0 },
    );

    observer.observe(node);
    return () => observer.disconnect();
  }, [sectionQuestions.length, loading, error, prevChapterCode, nextChapterCode]);

  const templateCurrencyQuestionId = useMemo(() => {
    const inSection = sectionQuestions.find((q: any) => String(q?.vsme_datapoint_id ?? '') === 'template_currency');
    if (inSection?.question_id) return String(inSection.question_id);

    const inAll = allQuestions.find((q: any) => String(q?.vsme_datapoint_id ?? '') === 'template_currency');
    if (inAll?.question_id) return String(inAll.question_id);

    return null;
  }, [sectionQuestions, allQuestions]);

  const templateCurrencyValue = useMemo(() => {
    if (!templateCurrencyQuestionId) return null;
    return answersById[templateCurrencyQuestionId]?.value_text ?? null;
  }, [templateCurrencyQuestionId, answersById]);

  useEffect(() => {
    if (normalizedSectionCode !== 'B3') return;

    const needles = ['energy', 'electricity', 'fuels', 'renewable', 'total'];

    const match = (q: any) => {
      const code = String(q?.code ?? '').toLowerCase();
      const dp = String(q?.vsme_datapoint_id ?? '').toLowerCase();
      return needles.some((n) => code.includes(n) || dp.includes(n));
    };

    const toDebugRow = (q: any, source: 'sectionQuestions' | 'allQuestions') => ({
      source,
      question_id: String(q?.question_id ?? ''),
      code: String(q?.code ?? ''),
      vsme_datapoint_id: String(q?.vsme_datapoint_id ?? ''),
      section_code: String(q?.section_code ?? q?.sectionCode ?? q?.section ?? ''),
      answer_type: String(q?.answer_type ?? ''),
    });

    const sectionRows = (sectionQuestions as any[])
      .filter(match)
      .map((q) => toDebugRow(q, 'sectionQuestions'));

    const allRows = (allQuestions as any[])
      .filter((q) =>
        String(q?.section_code ?? q?.sectionCode ?? q?.section ?? '').toUpperCase() === 'B3'
      )
      .filter(match)
      .map((q) => toDebugRow(q, 'allQuestions'));

    console.group('[B3 energy mapping debug]');
    console.table([...sectionRows, ...allRows]);
    console.groupEnd();
  }, [normalizedSectionCode, sectionQuestions, allQuestions]);

  const sectionCompleteness = useMemo(() => {
    const inSection = factQuestions.filter((q: any) => {
      const sc = String(q.section_code ?? q.sectionCode ?? q.section ?? '').toUpperCase();
      return sc === normalizedSectionCode;
    });

    const total = inSection.length;
    let answered = 0;
    let na = 0;

    for (const q of inSection) {
      const isNa = q?.value_jsonb?.na === true;
      const hasValue = hasAnyValue(q);

      if (isNa) {
        na += 1;
      } else if (hasValue) {
        answered += 1;
      }
    }

    const missing = Math.max(0, total - answered - na);
    const completed = answered + na;
    const pct = total > 0 ? Math.round((completed / total) * 100) : 0;

    return { total, answered, na, missing, pct };
  }, [factQuestions, normalizedSectionCode]);

  const b1GroupedRenderModel = useMemo(() => {
    if (!isBSection) return null;

    const hasMetadata = b1QuestionGroups.length > 0 || b1QuestionGroupItems.length > 0;
    if (!hasMetadata) {
      return {
        hasMetadata: false,
        grouped: [] as Array<{
          key: string;
          code: string;
          kind: string;
          title: string;
          questions: VsmeQuestion[];
        }>,
        consumedQuestionIds: new Set<string>(),
        isQuestionVisible: () => true,
        totalQuestions: 0,
      };
    }

    const byQuestionId = new Map<string, VsmeQuestion>();

    for (const q of sectionQuestions) {
      const questionId = String((q as any)?.question_id ?? '').trim();
      if (questionId) byQuestionId.set(questionId, q);
    }

    const resolveQuestionFromItem = (item: B1QuestionGroupItem): VsmeQuestion | null => {
      const questionId = String(item.question_id ?? '').trim();
      if (questionId && byQuestionId.has(questionId)) return byQuestionId.get(questionId) ?? null;
      return null;
    };

    const normalizeOrder = (value: unknown) => {
      const n = Number(value);
      return Number.isFinite(n) ? n : Number.MAX_SAFE_INTEGER;
    };

    const sortedGroups = [...b1QuestionGroups].sort((a, b) => {
      const ao = normalizeOrder(a.sort_order ?? a.order_index);
      const bo = normalizeOrder(b.sort_order ?? b.order_index);
      if (ao !== bo) return ao - bo;
      return String(a.code ?? a.id ?? '').localeCompare(String(b.code ?? b.id ?? ''));
    });

    const sortedItems = [...b1QuestionGroupItems].sort((a, b) => {
      const ao = normalizeOrder(a.sort_order ?? a.order_index);
      const bo = normalizeOrder(b.sort_order ?? b.order_index);
      if (ao !== bo) return ao - bo;
      return String(a.id ?? '').localeCompare(String(b.id ?? ''));
    });

    const itemsByGroupKey = new Map<string, B1QuestionGroupItem[]>();

    const normalizeKey = (value: unknown) => String(value ?? '').trim().toUpperCase();

    for (const item of sortedItems) {
      const candidateKeys = [
        item.question_group_id,
        item.group_id,
        item.question_group_code,
        item.group_code,
      ]
        .map((v) => normalizeKey(v))
        .filter(Boolean);

      for (const groupKey of candidateKeys) {
        const existing = itemsByGroupKey.get(groupKey) ?? [];
        existing.push(item);
        itemsByGroupKey.set(groupKey, existing);
      }
    }

    const normalizeBool = (value: unknown) => {
      if (typeof value === 'boolean') return value;
      const normalized = String(value ?? '').trim().toLowerCase();
      if (normalized === 'true') return true;
      if (normalized === 'false') return false;
      return null;
    };

    const getConditionalChildRuleForQuestion = (q: VsmeQuestion) => {
      const questionId = String((q as any)?.question_id ?? '').trim();
      if (!questionId) return null;

      return (b1InteractionRules as any[]).find((rule: any) =>
        String(rule?.rule_type ?? '').toLowerCase() === 'conditional_child' &&
        String(rule?.child_question_id ?? '').trim() === questionId,
      ) ?? null;
    };

    const getParentQuestionForRule = (rule: any): VsmeQuestion | null => {
      const parentQuestionId = String(rule?.parent_question_id ?? '').trim();
      if (!parentQuestionId) return null;
      return byQuestionId.get(parentQuestionId) ?? null;
    };

    const getRuleExpectedValue = (rule: any) => {
      const expected = rule?.config_jsonb?.show_when_parent_value;
      if (expected === undefined || expected === null) return '';
      return String(expected).trim();
    };

    const parentMatchesExpected = (parentQuestion: VsmeQuestion | null, expected: unknown) => {
      if (!parentQuestion) return false;

      const parentId = String((parentQuestion as any)?.question_id ?? '').trim();
      if (!parentId) return false;

      const expectedText = String(expected ?? '').trim();
      if (expectedText === '') return false;

      const parentAnswer = answersById[parentId] ?? {};
      const expectedBool = normalizeBool(expected);
      if (expectedBool !== null) {
        const actualBool = normalizeBool(
          parentAnswer.value_boolean === true || parentAnswer.value_boolean === false
            ? parentAnswer.value_boolean
            : parentAnswer.value_text,
        );
        return actualBool === expectedBool;
      }

      const actualText = String(parentAnswer.value_text ?? '').trim();
      return actualText.toLowerCase() === expectedText.toLowerCase();
    };

    const groupVisibilityByKey = new Map<string, boolean>();

    for (const rule of b1InteractionRules) {
      const ruleType = String((rule as any)?.rule_type ?? (rule as any)?.interaction_type ?? (rule as any)?.type ?? '')
        .trim()
        .toLowerCase();
      if (ruleType !== 'conditional_child' && ruleType !== 'conditional_group') continue;

      const expectedValue = getRuleExpectedValue(rule);
      const parentQuestion = getParentQuestionForRule(rule);
      const isVisible = parentMatchesExpected(parentQuestion, expectedValue);

      if (ruleType === 'conditional_group') {
        const groupKeys = [
          String((rule as any)?.group_id ?? (rule as any)?.question_group_id ?? ''),
          String((rule as any)?.group_code ?? (rule as any)?.question_group_code ?? ''),
        ]
          .map((k) => normalizeKey(k))
          .filter(Boolean);

        for (const key of groupKeys) {
          const previous = groupVisibilityByKey.get(key);
          groupVisibilityByKey.set(key, previous === undefined ? isVisible : previous && isVisible);
        }
      }
    }

    const evaluateConditionalChildRule = (rule: B1InteractionRule) => {
      const expectedValue = getRuleExpectedValue(rule);
      if (expectedValue === '') return false;

      const parentQuestion = getParentQuestionForRule(rule);
      return parentMatchesExpected(parentQuestion, expectedValue);
    };

    const isQuestionVisible = (q: VsmeQuestion) => {
      const questionId = String((q as any)?.question_id ?? '').trim();
      if (!questionId) return false;

      const directRule = getConditionalChildRuleForQuestion(q);
      if (!directRule) {
        return true;
      }

      return evaluateConditionalChildRule(directRule as B1InteractionRule);
    };

    const shownQuestionIds = new Set<string>();
    const grouped: Array<{
      key: string;
      code: string;
      kind: string;
      title: string;
      questions: VsmeQuestion[];
    }> = [];

    for (const group of sortedGroups) {
      const candidateKeys = [
        normalizeKey(group.id),
        normalizeKey(group.code),
      ].filter(Boolean);

      const dedupedItems = new Map<string, B1QuestionGroupItem>();
      for (const key of candidateKeys) {
        const matchedItems = itemsByGroupKey.get(key) ?? [];
        for (const item of matchedItems) {
          const itemKey = String(item.id ?? `${item.question_id ?? ''}-${item.vsme_datapoint_id ?? ''}`);
          if (!dedupedItems.has(itemKey)) {
            dedupedItems.set(itemKey, item);
          }
        }
      }

      const groupItems = Array.from(dedupedItems.values());

      const groupVisibilityKeys = candidateKeys;
      const isGroupVisible =
        groupVisibilityKeys.length === 0 ||
        groupVisibilityKeys.every((key) => groupVisibilityByKey.get(key) !== false);
      if (!isGroupVisible) {
        continue;
      }

      const questions: VsmeQuestion[] = [];

      for (const item of groupItems) {
        const resolvedQuestion = resolveQuestionFromItem(item);
        if (!resolvedQuestion) continue;

        const questionId = String((resolvedQuestion as any)?.question_id ?? '').trim();
        if (!questionId) continue;

        if (!isQuestionVisible(resolvedQuestion)) {
          continue;
        }

        const role = String(item.role ?? '').trim().toLowerCase();
        if (role === 'technical') {
          continue;
        }

        if (shownQuestionIds.has(questionId)) continue;

        shownQuestionIds.add(questionId);
        questions.push(resolvedQuestion);
      }

      grouped.push({
        key: String(group.id ?? group.code ?? `group-${grouped.length + 1}`),
        code: String(group.code ?? ''),
        kind: String(group.group_kind ?? '').trim().toLowerCase(),
        title: String(group.title ?? group.label ?? group.name ?? group.code ?? 'Group').trim(),
        questions,
      });
    }

    const totalQuestions = grouped.reduce((acc, group) => acc + group.questions.length, 0);

    return { hasMetadata: true, grouped, consumedQuestionIds: shownQuestionIds, isQuestionVisible, totalQuestions };
  }, [isBSection, sectionQuestions, b1QuestionGroups, b1QuestionGroupItems, b1InteractionRules, answersById]);

  const sectionRenderModel = useMemo(() => {
    if (!isBSection || !b1GroupedRenderModel?.hasMetadata) {
      return null;
    }

    const visibleNonTechnical = sectionQuestions.filter((q: any) => {
      const questionId = String((q as any)?.question_id ?? '').trim();
      if (!questionId) return false;
      const isTechnicalQuestion = b1QuestionGroupItems.some((item: any) => {
        const itemQuestionId = String(item?.question_id ?? '').trim();
        const role = String(item?.role ?? '').trim().toLowerCase();
        return itemQuestionId === questionId && role === 'technical';
      });
      if (isTechnicalQuestion) return false;
      return b1GroupedRenderModel.isQuestionVisible(q);
    });

    const groupedWithVisibleQuestions = b1GroupedRenderModel.grouped
      .map((group) => {
        const visibleQuestions = group.questions.filter((q: any) => b1GroupedRenderModel.isQuestionVisible(q));
        return { ...group, visibleQuestions };
      })
      .filter((group) => group.visibleQuestions.length > 0);

    const consumedIds = new Set<string>();
    for (const group of groupedWithVisibleQuestions) {
      for (const q of group.visibleQuestions as any[]) {
        const questionId = String(q?.question_id ?? '').trim();
        if (questionId) consumedIds.add(questionId);
      }
    }

    const standaloneQuestions = visibleNonTechnical.filter((q: any) => {
      const questionId = String((q as any)?.question_id ?? '').trim();
      return questionId && !consumedIds.has(questionId);
    });

    const totalVisible = groupedWithVisibleQuestions.reduce((acc, group) => acc + group.visibleQuestions.length, 0) + standaloneQuestions.length;

    return {
      grouped: groupedWithVisibleQuestions,
      consumedIds,
      standaloneQuestions,
      totalVisible,
    };
  }, [isBSection, b1GroupedRenderModel, sectionQuestions, b1QuestionGroupItems]);

  const b3ComputedTotalsModel = useMemo(() => {
    if (normalizedSectionCode !== 'B3') {
      return {
        hiddenQuestionIds: new Set<string>(),
        location: null as null | {
          questionId: string;
          title: string;
          value: number | null;
          unit: string;
          state: 'numeric' | 'na' | 'missing';
        },
        market: null as null | {
          questionId: string;
          title: string;
          value: number | null;
          unit: string;
          state: 'numeric' | 'na' | 'missing';
        },
      };
    }

    const byCode = new Map<string, any>();
    for (const q of sectionQuestions as any[]) {
      const code = String(q?.code ?? '').trim().toUpperCase();
      if (code) byCode.set(code, q);
    }

    const getSourceState = (q: any) => {
      if (!q) return null;
      const questionId = String(q?.question_id ?? '').trim();
      if (!questionId) return null;

      const hasLocalAnswer = Object.prototype.hasOwnProperty.call(answersById, questionId);
      const local = hasLocalAnswer ? (answersById[questionId] ?? {}) : {};

      const hasLocalNaOverride = Object.prototype.hasOwnProperty.call(local, 'na');
      const isNa = hasLocalNaOverride ? local.na === true : q?.value_jsonb?.na === true;

      const hasLocalNumericOverride = Object.prototype.hasOwnProperty.call(local, 'value_numeric');
      const raw = hasLocalNumericOverride ? local.value_numeric : q?.value_numeric;
      const numeric = raw === undefined || raw === null || String(raw).trim() === ''
        ? null
        : Number(raw);

      return {
        isNa,
        numeric: Number.isFinite(numeric) ? numeric : null,
      };
    };

    const deriveBranchTotal = (sources: any[]) => {
      const states = sources
        .map((q) => getSourceState(q))
        .filter((v): v is { isNa: boolean; numeric: number | null } => v !== null);

      if (states.length === 0) {
        return { state: 'missing' as const, value: null as number | null };
      }

      const allNa = states.every((s) => s.isNa === true);
      if (allNa) {
        return { state: 'na' as const, value: null as number | null };
      }

      const activeNumericValues = states
        .filter((s) => s.isNa !== true && s.numeric !== null)
        .map((s) => s.numeric as number);

      if (activeNumericValues.length > 0) {
        const sum = activeNumericValues.reduce((acc, value) => acc + value, 0);
        return { state: 'numeric' as const, value: sum };
      }

      return { state: 'missing' as const, value: null as number | null };
    };

    const resolveDisplayUnit = (q: any): string => {
      const unit = String(q?.unit ?? '').trim().toUpperCase();
      if (!unit) return '';
      return CURRENCY_UNITS.includes(unit as (typeof CURRENCY_UNITS)[number]) ? reportCurrency ?? unit : unit;
    };

    const scope1Question = byCode.get(B3_GHG_SOURCE_CODES.scope1);
    const scope2LocationQuestion = byCode.get(B3_GHG_SOURCE_CODES.scope2Location);
    const scope2MarketQuestion = byCode.get(B3_GHG_SOURCE_CODES.scope2Market);

    const locationTotalQuestion = byCode.get(B3_GHG_TOTAL_CODES.location);
    const marketTotalQuestion = byCode.get(B3_GHG_TOTAL_CODES.market);

    const hiddenQuestionIds = new Set<string>();

    const location = locationTotalQuestion
      ? {
          questionId: String(locationTotalQuestion?.question_id ?? '').trim(),
          title: String(locationTotalQuestion?.question_text ?? locationTotalQuestion?.title ?? 'Total Scope 1 + Scope 2 (location-based)'),
          ...deriveBranchTotal([scope1Question, scope2LocationQuestion]),
          unit: resolveDisplayUnit(locationTotalQuestion),
        }
      : null;

    const market = marketTotalQuestion
      ? {
          questionId: String(marketTotalQuestion?.question_id ?? '').trim(),
          title: String(marketTotalQuestion?.question_text ?? marketTotalQuestion?.title ?? 'Total Scope 1 + Scope 2 (market-based)'),
          ...deriveBranchTotal([scope1Question, scope2MarketQuestion]),
          unit: resolveDisplayUnit(marketTotalQuestion),
        }
      : null;

    return { hiddenQuestionIds, location, market };
  }, [normalizedSectionCode, sectionQuestions, answersById, reportCurrency]);

  // Render-time computed intensity (local-override-aware, depends on b3ComputedTotalsModel)
  const b3IntensityModel = useMemo(() => {
    type IntensityBranch = {
      questionId: string;
      title: string;
      state: 'numeric' | 'missing';
      value: number | null;
      warningKind: 'missing-inputs' | 'zero-turnover' | null;
      unit: string;
    };
    const empty = {
      location: null as IntensityBranch | null,
      market: null as IntensityBranch | null,
    };
    if (normalizedSectionCode !== 'B3') return empty;

    const normalizeDp = (v: unknown) => String(v ?? '').trim().toUpperCase();
    const normalizeCode = (v: unknown) => String(v ?? '').trim().toUpperCase();

    let locationIntQ: any = null;
    let marketIntQ: any = null;
    let turnoverQ: any = null;
    let locationTotalQ: any = null;
    let marketTotalQ: any = null;

    for (const q of allQuestions as any[]) {
      const dp = normalizeDp(q?.vsme_datapoint_id);
      const section = String(q?.section_code ?? q?.sectionCode ?? q?.section ?? '').trim().toUpperCase();
      const code = normalizeCode(q?.code);
      if (dp === B3_GHG_INTENSITY_DP.location && !locationIntQ) locationIntQ = q;
      if (dp === B3_GHG_INTENSITY_DP.market && !marketIntQ) marketIntQ = q;
      if (dp === B3_GHG_TURNOVER_DP && !turnoverQ) turnoverQ = q;
      if (section === 'B3' && code === B3_GHG_TOTAL_CODES.location && !locationTotalQ) locationTotalQ = q;
      if (section === 'B3' && code === B3_GHG_TOTAL_CODES.market && !marketTotalQ) marketTotalQ = q;
    }
    for (const q of sectionQuestions as any[]) {
      const dp = normalizeDp(q?.vsme_datapoint_id);
      if (dp === B3_GHG_INTENSITY_DP.location && !locationIntQ) locationIntQ = q;
      if (dp === B3_GHG_INTENSITY_DP.market && !marketIntQ) marketIntQ = q;
    }

    if (!locationIntQ && !marketIntQ) return empty;

    // Read Turnover with local-override awareness
    const getTurnoverState = (): { isNa: boolean; numeric: number | null } => {
      if (!turnoverQ) return { isNa: false, numeric: null };
      const qId = String(turnoverQ.question_id ?? '').trim();
      const hasLocal = Object.prototype.hasOwnProperty.call(answersById, qId);
      const local = hasLocal ? (answersById[qId] ?? {}) : {};
      const hasLocalNa = Object.prototype.hasOwnProperty.call(local, 'na');
      const isNa = hasLocalNa ? local.na === true : turnoverQ?.value_jsonb?.na === true;
      const hasLocalNum = Object.prototype.hasOwnProperty.call(local, 'value_numeric');
      const raw = hasLocalNum ? local.value_numeric : turnoverQ?.value_numeric;
      const n = raw === undefined || raw === null || String(raw).trim() === '' ? null : Number(raw);
      return { isNa, numeric: Number.isFinite(n) ? n : null };
    };

    const tvState = getTurnoverState();

    const computeIntensityBranch = (
      intQ: any,
      ghgBranch: typeof b3ComputedTotalsModel.location,
    ): IntensityBranch | null => {
      if (!intQ) return null;
      const questionId = String(intQ.question_id ?? '').trim();
      const title = String(intQ.question_text ?? intQ.title ?? '');
      const unit = String(intQ.unit ?? '').trim();
      if (!ghgBranch || ghgBranch.state !== 'numeric' || ghgBranch.value === null) {
        return { questionId, title, unit, state: 'missing', value: null, warningKind: 'missing-inputs' };
      }
      if (tvState.isNa || tvState.numeric === null) {
        return { questionId, title, unit, state: 'missing', value: null, warningKind: 'missing-inputs' };
      }
      if (tvState.numeric === 0) {
        return { questionId, title, unit, state: 'missing', value: null, warningKind: 'zero-turnover' };
      }
      return { questionId, title, unit, state: 'numeric', value: ghgBranch.value / tvState.numeric, warningKind: null };
    };

    return {
      location: computeIntensityBranch(locationIntQ, b3ComputedTotalsModel.location),
      market: computeIntensityBranch(marketIntQ, b3ComputedTotalsModel.market),
    };
  }, [normalizedSectionCode, allQuestions, sectionQuestions, answersById, b3ComputedTotalsModel]);

  // ── B3 source fingerprint ─────────────────────────────────────────────────
  // A stable string primitive derived from ONLY the three B3 GHG source
  // question values. Because React compares primitive deps by value (Object.is),
  // b3DerivedPersistModel won't re-run when Turnover or any other non-source
  // question changes — even though allQuestions gets a new reference on every
  // saveAnswer call. The effect for totals therefore stays quiescent on
  // Turnover-only changes, preventing total rows from being incorrectly
  // re-persisted with stale/empty source values.
  const b3SourceKey = useMemo((): string => {
    const sourceCodeSet = new Set([
      B3_GHG_SOURCE_CODES.scope1,
      B3_GHG_SOURCE_CODES.scope2Location,
      B3_GHG_SOURCE_CODES.scope2Market,
    ]);
    const parts: string[] = [];
    for (const q of allQuestions as any[]) {
      const section = String(q?.section_code ?? q?.sectionCode ?? q?.section ?? '').trim().toUpperCase();
      if (section !== 'B3') continue;
      const code = String(q?.code ?? '').trim().toUpperCase();
      if (!sourceCodeSet.has(code as (typeof B3_GHG_SOURCE_CODES)[keyof typeof B3_GHG_SOURCE_CODES])) continue;
      const na = q?.value_jsonb?.na === true ? '1' : '0';
      const num = q?.value_numeric != null ? String(q.value_numeric) : '';
      parts.push(`${code}|${na}|${num}`);
    }
    return parts.sort().join('~');
  }, [allQuestions]);

  // Keep a ref so b3DerivedPersistModel can read the full allQuestions array
  // without listing it as a dep (it only needs fresh data when b3SourceKey changes).
  const allQuestionsRef = useRef<VsmeQuestion[]>(allQuestions);
  allQuestionsRef.current = allQuestions;
  // ─────────────────────────────────────────────────────────────────────────

  const b3DerivedPersistModel = useMemo((): {
    location: { questionId: string; state: 'numeric' | 'na' | 'missing'; value: number | null } | null;
    market: { questionId: string; state: 'numeric' | 'na' | 'missing'; value: number | null } | null;
  } => {
    // Depends on b3SourceKey (not allQuestions directly) so this memo only
    // re-runs when a B3 GHG source value actually changes.  Turnover changes
    // do NOT change b3SourceKey, so totals are never recomputed for them.
    const aq = allQuestionsRef.current;
    const byCode = new Map<string, any>();
    for (const q of aq as any[]) {
      const section = String(q?.section_code ?? q?.sectionCode ?? q?.section ?? '').trim().toUpperCase();
      if (section !== 'B3') continue;
      const code = String(q?.code ?? '').trim().toUpperCase();
      if (code) byCode.set(code, q);
    }

    const getPersistedSourceState = (q: any) => {
      if (!q) return null;

      const isNa = q?.value_jsonb?.na === true;
      const numericRaw = q?.value_numeric;
      const numeric = numericRaw === undefined || numericRaw === null || String(numericRaw).trim() === ''
        ? null
        : Number(numericRaw);

      return {
        isNa,
        numeric: Number.isFinite(numeric) ? numeric : null,
      };
    };

    const deriveBranchTotal = (sources: any[]) => {
      const states = sources
        .map((q) => getPersistedSourceState(q))
        .filter((v): v is { isNa: boolean; numeric: number | null } => v !== null);

      if (states.length === 0) {
        return { state: 'missing' as const, value: null as number | null };
      }

      const allNa = states.every((s) => s.isNa === true);
      if (allNa) {
        return { state: 'na' as const, value: null as number | null };
      }

      const activeNumericValues = states
        .filter((s) => s.isNa !== true && s.numeric !== null)
        .map((s) => s.numeric as number);

      if (activeNumericValues.length > 0) {
        const sum = activeNumericValues.reduce((acc, value) => acc + value, 0);
        return { state: 'numeric' as const, value: sum };
      }

      return { state: 'missing' as const, value: null as number | null };
    };

    const scope1Question = byCode.get(B3_GHG_SOURCE_CODES.scope1);
    const scope2LocationQuestion = byCode.get(B3_GHG_SOURCE_CODES.scope2Location);
    const scope2MarketQuestion = byCode.get(B3_GHG_SOURCE_CODES.scope2Market);

    const locationTotalQuestion = byCode.get(B3_GHG_TOTAL_CODES.location);
    const marketTotalQuestion = byCode.get(B3_GHG_TOTAL_CODES.market);

    const location = locationTotalQuestion
      ? {
          questionId: String(locationTotalQuestion?.question_id ?? '').trim(),
          ...deriveBranchTotal([scope1Question, scope2LocationQuestion]),
        }
      : null;

    const market = marketTotalQuestion
      ? {
          questionId: String(marketTotalQuestion?.question_id ?? '').trim(),
          ...deriveBranchTotal([scope1Question, scope2MarketQuestion]),
        }
      : null;

    return { location, market };
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [b3SourceKey]);

  const b3DerivedPersistSignatureRef = useRef<string>('');

  useEffect(() => {
    if (!reportId) return;

    const branches = [b3DerivedPersistModel.location, b3DerivedPersistModel.market]
      .filter((b): b is { questionId: string; state: 'numeric' | 'na' | 'missing'; value: number | null } => Boolean(b?.questionId));

    if (branches.length === 0) return;

    const signature = JSON.stringify(
      branches.map((b) => ({ questionId: b.questionId, state: b.state, value: b.value })),
    );

    if (b3DerivedPersistSignatureRef.current === signature) return;
    b3DerivedPersistSignatureRef.current = signature;

    let cancelled = false;

    const run = async () => {
      const supabase = createSupabaseBrowserClient();

      for (const branch of branches) {
        const questionId = branch.questionId;
        if (!questionId) continue;

        if (branch.state === 'missing') {
          const { error } = await supabase
            .from('disclosure_answer')
            .delete()
            .eq('report_id', reportId)
            .eq('question_id', questionId);

          if (error || cancelled) {
            b3DerivedPersistSignatureRef.current = '';
            if (error) console.error('B3 derived total delete failed', { questionId, error });
            continue;
          }

          setAnswersById((prev) => ({
            ...prev,
            [questionId]: {
              ...(prev[questionId] ?? {}),
              value_text: '',
              value_numeric: '',
              value_date: '',
              value_boolean: null,
              na: false,
            },
          }));

          setAllQuestions((prev) =>
            prev.map((q: any) => {
              if (String(q?.question_id ?? '') !== questionId) return q;
              const currentJson = (q?.value_jsonb ?? {}) as any;
              const nextJson = { ...currentJson };
              delete nextJson.na;
              return {
                ...q,
                value_text: '',
                value_numeric: '',
                value_date: '',
                value_boolean: null,
                value_jsonb: Object.keys(nextJson).length > 0 ? nextJson : {},
              };
            }),
          );

          continue;
        }

        const payload: any = {
          report_id: reportId,
          question_id: questionId,
          value_text: null,
          value_date: null,
          value_boolean: null,
          value_numeric: branch.state === 'numeric' ? branch.value : null,
          value_jsonb: branch.state === 'na' ? { na: true } : {},
        };

        const { error } = await supabase
          .from('disclosure_answer')
          .upsert(payload, { onConflict: 'report_id,question_id' });

        if (error || cancelled) {
          b3DerivedPersistSignatureRef.current = '';
          if (error) console.error('B3 derived total upsert failed', { questionId, error });
          continue;
        }

        setAnswersById((prev) => ({
          ...prev,
          [questionId]: {
            ...(prev[questionId] ?? {}),
            value_text: '',
            value_numeric: branch.state === 'numeric' && branch.value !== null ? String(branch.value) : '',
            value_date: '',
            value_boolean: null,
            na: branch.state === 'na',
          },
        }));

        setAllQuestions((prev) =>
          prev.map((q: any) => {
            if (String(q?.question_id ?? '') !== questionId) return q;
            return {
              ...q,
              value_text: '',
              value_numeric: branch.state === 'numeric' ? branch.value : null,
              value_date: '',
              value_boolean: null,
              value_jsonb: branch.state === 'na' ? { ...(q?.value_jsonb ?? {}), na: true } : (() => {
                const currentJson = (q?.value_jsonb ?? {}) as any;
                const nextJson = { ...currentJson };
                delete nextJson.na;
                return Object.keys(nextJson).length > 0 ? nextJson : {};
              })(),
            };
          }),
        );
      }
    };

    void run();

    return () => {
      cancelled = true;
    };
  }, [reportId, b3DerivedPersistModel]);

  // Persist-time intensity model. Reads allQuestions for intensity Q metadata and Turnover.
  // GHG total inputs are selected by trigger type:
  // - source save: use freshly derived totals from b3DerivedPersistModel
  // - turnover/other save: use persisted B3 total rows from allQuestions
  const b3IntensityPersistModel = useMemo(() => {
    type IntensityPersistBranch = { questionId: string; state: 'numeric' | 'na' | 'missing'; value: number | null };
    const empty = { location: null as IntensityPersistBranch | null, market: null as IntensityPersistBranch | null };
    // No section guard — must fire from any section (Turnover lives in B1).

    const normalizeDp = (v: unknown) => String(v ?? '').trim().toUpperCase();
    const normalizeCode = (v: unknown) => String(v ?? '').trim().toUpperCase();

    let locationIntQ: any = null;
    let marketIntQ: any = null;
    let turnoverQ: any = null;
    let locationTotalQ: any = null;
    let marketTotalQ: any = null;

    for (const q of allQuestions as any[]) {
      const dp = normalizeDp(q?.vsme_datapoint_id);
      const section = String(q?.section_code ?? q?.sectionCode ?? q?.section ?? '').trim().toUpperCase();
      const code = normalizeCode(q?.code);
      if (dp === B3_GHG_INTENSITY_DP.location && !locationIntQ) locationIntQ = q;
      if (dp === B3_GHG_INTENSITY_DP.market && !marketIntQ) marketIntQ = q;
      if (dp === B3_GHG_TURNOVER_DP && !turnoverQ) turnoverQ = q;
      if (section === 'B3' && code === B3_GHG_TOTAL_CODES.location && !locationTotalQ) locationTotalQ = q;
      if (section === 'B3' && code === B3_GHG_TOTAL_CODES.market && !marketTotalQ) marketTotalQ = q;
    }

    if (!locationIntQ && !marketIntQ) return empty;

    const derivedLocState: { isNa: boolean; numeric: number | null } | null = b3DerivedPersistModel.location
      ? { isNa: b3DerivedPersistModel.location.state === 'na', numeric: b3DerivedPersistModel.location.state === 'numeric' ? b3DerivedPersistModel.location.value : null }
      : null;
    const derivedMktState: { isNa: boolean; numeric: number | null } | null = b3DerivedPersistModel.market
      ? { isNa: b3DerivedPersistModel.market.state === 'na', numeric: b3DerivedPersistModel.market.state === 'numeric' ? b3DerivedPersistModel.market.value : null }
      : null;

    // Turnover: read from allQuestions (persisted state, no local-override awareness needed here)
    const getPersistedState = (q: any): { isNa: boolean; numeric: number | null } | null => {
      if (!q) return null;
      const isNa = q?.value_jsonb?.na === true;
      const raw = q?.value_numeric;
      const n = raw === undefined || raw === null || String(raw).trim() === '' ? null : Number(raw);
      return { isNa, numeric: Number.isFinite(n) ? n : null };
    };
    const persistedLocState = getPersistedState(locationTotalQ);
    const persistedMktState = getPersistedState(marketTotalQ);
    const tvState = getPersistedState(turnoverQ);

    // Trigger split:
    // - source change => intensities use freshly derived totals
    // - turnover change => intensities use persisted total rows (totals don't depend on turnover)
    const trigger = b3RecomputeTriggerRef.current;
    const ghgLocState = trigger === 'source' ? (derivedLocState ?? persistedLocState) : persistedLocState;
    const ghgMktState = trigger === 'source' ? (derivedMktState ?? persistedMktState) : persistedMktState;

    const computePersistBranch = (
      intQ: any,
      ghgState: { isNa: boolean; numeric: number | null } | null,
    ): IntensityPersistBranch | null => {
      if (!intQ) return null;
      const questionId = String(intQ.question_id ?? '').trim();
      if (intQ?.value_jsonb?.na === true) return { questionId, state: 'na', value: null };
      if (!ghgState || ghgState.isNa || ghgState.numeric === null) return { questionId, state: 'missing', value: null };
      if (!tvState || tvState.isNa || tvState.numeric === null || tvState.numeric === 0) return { questionId, state: 'missing', value: null };
      return { questionId, state: 'numeric', value: ghgState.numeric / tvState.numeric };
    };

    return {
      location: computePersistBranch(locationIntQ, ghgLocState),
      market: computePersistBranch(marketIntQ, ghgMktState),
    };
  }, [allQuestions, b3DerivedPersistModel]);

  const b3IntensityPersistSignatureRef = useRef<string>('');

  useEffect(() => {
    if (!reportId) return;

    const branches = [b3IntensityPersistModel.location, b3IntensityPersistModel.market]
      .filter((b): b is { questionId: string; state: 'numeric' | 'na' | 'missing'; value: number | null } => Boolean(b?.questionId));

    if (branches.length === 0) return;

    const signature = JSON.stringify(
      branches.map((b) => ({ questionId: b.questionId, state: b.state, value: b.value })),
    );

    if (b3IntensityPersistSignatureRef.current === signature) return;
    b3IntensityPersistSignatureRef.current = signature;

    let cancelled = false;

    const run = async () => {
      const supabase = createSupabaseBrowserClient();

      for (const branch of branches) {
        const questionId = branch.questionId;
        if (!questionId) continue;

        if (branch.state === 'missing') {
          const { error } = await supabase
            .from('disclosure_answer')
            .delete()
            .eq('report_id', reportId)
            .eq('question_id', questionId);

          if (error || cancelled) {
            b3IntensityPersistSignatureRef.current = '';
            if (error) console.error('B3 intensity delete failed', { questionId, error });
            continue;
          }

          setAnswersById((prev) => ({
            ...prev,
            [questionId]: { ...(prev[questionId] ?? {}), value_text: '', value_numeric: '', value_date: '', value_boolean: null, na: false },
          }));
          setAllQuestions((prev) =>
            prev.map((q: any) => {
              if (String(q?.question_id ?? '') !== questionId) return q;
              const currentJson = (q?.value_jsonb ?? {}) as any;
              const nextJson = { ...currentJson };
              delete nextJson.na;
              return { ...q, value_text: '', value_numeric: null, value_date: '', value_boolean: null, value_jsonb: Object.keys(nextJson).length > 0 ? nextJson : {} };
            }),
          );
          continue;
        }

        if (branch.state === 'na') {
          const payload: any = {
            report_id: reportId,
            question_id: questionId,
            value_text: null,
            value_numeric: null,
            value_date: null,
            value_boolean: null,
            value_jsonb: { na: true },
          };

          const { error } = await supabase
            .from('disclosure_answer')
            .upsert(payload, { onConflict: 'report_id,question_id' });

          if (error || cancelled) {
            b3IntensityPersistSignatureRef.current = '';
            if (error) console.error('B3 intensity NA upsert failed', { questionId, error });
            continue;
          }

          setAnswersById((prev) => ({
            ...prev,
            [questionId]: { ...(prev[questionId] ?? {}), value_text: '', value_numeric: '', value_date: '', value_boolean: null, na: true },
          }));
          setAllQuestions((prev) =>
            prev.map((q: any) => {
              if (String(q?.question_id ?? '') !== questionId) return q;
              const currentJson = (q?.value_jsonb ?? {}) as any;
              return { ...q, value_text: '', value_numeric: null, value_date: '', value_boolean: null, value_jsonb: { ...currentJson, na: true } };
            }),
          );
          continue;
        }

        // state === 'numeric': persist as value_text (intensity answer_type is text per spec)
        const textValue = branch.value !== null ? String(branch.value) : '';
        const payload: any = {
          report_id: reportId,
          question_id: questionId,
          value_text: textValue,
          value_numeric: null,
          value_date: null,
          value_boolean: null,
          value_jsonb: {},
        };

        const { error } = await supabase
          .from('disclosure_answer')
          .upsert(payload, { onConflict: 'report_id,question_id' });

        if (error || cancelled) {
          b3IntensityPersistSignatureRef.current = '';
          if (error) console.error('B3 intensity upsert failed', { questionId, error });
          continue;
        }

        setAnswersById((prev) => ({
          ...prev,
          [questionId]: { ...(prev[questionId] ?? {}), value_text: textValue, value_numeric: '', value_date: '', value_boolean: null, na: false },
        }));
        setAllQuestions((prev) =>
          prev.map((q: any) => {
            if (String(q?.question_id ?? '') !== questionId) return q;
            const currentJson = (q?.value_jsonb ?? {}) as any;
            const nextJson = { ...currentJson };
            delete nextJson.na;
            return { ...q, value_text: textValue, value_numeric: null, value_date: '', value_boolean: null, value_jsonb: Object.keys(nextJson).length > 0 ? nextJson : {} };
          }),
        );
      }
    };

    void run();
    return () => { cancelled = true; };
  }, [reportId, b3IntensityPersistModel]);

  const displayedQuestionCount = useMemo(() => {
    if (!isBSection) return sectionQuestions.length;
    if (!b1GroupedRenderModel?.hasMetadata) return sectionQuestions.length;
    const hiddenCount = b3ComputedTotalsModel.hiddenQuestionIds.size;
    const computedCount = 0;
    const baseVisible = sectionRenderModel?.totalVisible ?? b1GroupedRenderModel.totalQuestions;
    return Math.max(0, baseVisible - hiddenCount + computedCount);
  }, [isBSection, sectionQuestions.length, b1GroupedRenderModel, sectionRenderModel, b3ComputedTotalsModel]);

  const b3QuestionsByDatapoint = useMemo(() => {
    const map = new Map<string, any>();
    if (normalizedSectionCode !== 'B3') return map;

    const normalizeDp = (value: unknown) => String(value ?? '').trim().toUpperCase();

    for (const q of sectionQuestions as any[]) {
      const dp = normalizeDp(q?.vsme_datapoint_id);
      if (dp && !map.has(dp)) map.set(dp, q);
    }

    for (const q of allQuestions as any[]) {
      const sc = String(q?.section_code ?? q?.sectionCode ?? q?.section ?? '').trim().toUpperCase();
      if (sc !== 'B3') continue;
      const dp = normalizeDp(q?.vsme_datapoint_id);
      if (dp && !map.has(dp)) map.set(dp, q);
    }

    return map;
  }, [normalizedSectionCode, sectionQuestions, allQuestions]);

  const b3RenderPlan = useMemo(() => {
    if (normalizedSectionCode !== 'B3' || !sectionRenderModel) return null;

    const normalizeCode = (value: unknown) => String(value ?? '').trim().toUpperCase();
    const hiddenQuestionIds = b3ComputedTotalsModel.hiddenQuestionIds;

    type B3VisibleGroup = {
      key: string;
      code: string;
      kind: string;
      title: string;
      visibleQuestions: any[];
    };

    const visibleGroups: B3VisibleGroup[] = sectionRenderModel.grouped
      .map((group) => {
        const visibleQuestions = group.visibleQuestions.filter((q: any) => {
          const questionId = String((q as any)?.question_id ?? '').trim();
          const code = String((q as any)?.code ?? '').trim();
          return !hiddenQuestionIds.has(questionId) && !isB3IntensityQuestionCode(code);
        });
        return { ...group, visibleQuestions };
      })
      .filter((group) => group.visibleQuestions.length > 0);

    const visibleStandalone = sectionRenderModel.standaloneQuestions.filter((q: any) => {
      const questionId = String((q as any)?.question_id ?? '').trim();
      const code = String((q as any)?.code ?? '').trim();
      return !hiddenQuestionIds.has(questionId) && !isB3IntensityQuestionCode(code);
    });

    const groupsByCode = new Map<string, B3VisibleGroup>();
    for (const group of visibleGroups) {
      const code = normalizeCode((group as any)?.code);
      if (code) groupsByCode.set(code, group);
    }

    const standaloneByCode = new Map<string, any>();
    for (const q of visibleStandalone as any[]) {
      const code = normalizeCode(q?.code);
      if (code) standaloneByCode.set(code, q);
    }

    const consumedGroupCodes = new Set<string>();
    const consumedQuestionIds = new Set<string>();

    const consumeQuestion = (q: any) => {
      const questionId = String(q?.question_id ?? '').trim();
      if (questionId) consumedQuestionIds.add(questionId);
      return q;
    };

    const consumeGroupByCode = (groupCode: string) => {
      const normalizedGroupCode = normalizeCode(groupCode);
      const group = groupsByCode.get(normalizedGroupCode);
      if (!group) return null;
      consumedGroupCodes.add(normalizedGroupCode);
      for (const q of group.visibleQuestions as any[]) {
        const questionId = String(q?.question_id ?? '').trim();
        if (questionId) consumedQuestionIds.add(questionId);
      }
      return group;
    };

    const plan: Array<
      | { kind: 'energy'; key: string; totalEnergyQuestion: any | null }
      | { kind: 'question'; key: string; question: any }
      | { kind: 'group'; key: string; group: B3VisibleGroup }
      | {
          kind: 'emissions-group';
          key: string;
          scope1Question: any | null;
          scope2Group: B3VisibleGroup | null;
          totalGroup: B3VisibleGroup | null;
        }
      | { kind: 'computed-total-pair'; key: string; title: string; group: B3VisibleGroup }
    > = [];

    const totalEnergyQuestion = standaloneByCode.get('TOTALENERGYCONSUMPTION');
    if (totalEnergyQuestion) {
      consumeQuestion(totalEnergyQuestion);
    }

    plan.push({
      kind: 'energy',
      key: 'b3-energy-block',
      totalEnergyQuestion: totalEnergyQuestion ?? null,
    });

    // Consume all energy-table breakdown questions so they are not re-rendered as standalone cards
    const energyTableDatapointIds = [
      'ENERGYCONSUMPTIONFROMELECTRICITY_RENEWABLEENERGYMEMBER',
      'ENERGYCONSUMPTIONFROMELECTRICITY_NONRENEWABLEENERGYMEMBER',
      'ENERGYCONSUMPTIONFROMELECTRICITY',
      'ENERGYCONSUMPTIONFROMSELFGENERATEDELECTRICITY_RENEWABLEENERGYMEMBER',
      'ENERGYCONSUMPTIONFROMSELFGENERATEDELECTRICITY_NONRENEWABLEENERGYMEMBER',
      'ENERGYCONSUMPTIONFROMSELFGENERATEDELECTRICITY',
      'ENERGYCONSUMPTIONFROMFUELS_RENEWABLEENERGYMEMBER',
      'ENERGYCONSUMPTIONFROMFUELS_NONRENEWABLEENERGYMEMBER',
      'ENERGYCONSUMPTIONFROMFUELS',
    ];
    for (const dpId of energyTableDatapointIds) {
      const dpQ = b3QuestionsByDatapoint.get(dpId);
      if (dpQ) consumeQuestion(dpQ);
    }

    const scope1Question = standaloneByCode.get('GROSSSCOPE1GREENHOUSEGASEMISSIONS');
    const scope2Group = consumeGroupByCode('SCOPE2_EMISSIONS');
    const totalScope12Group = groupsByCode.get('TOTAL_SCOPE12_EMISSIONS');

    if (scope1Question || scope2Group || totalScope12Group) {
      if (scope1Question) {
        consumeQuestion(scope1Question);
      }

      if (totalScope12Group) {
        consumedGroupCodes.add('TOTAL_SCOPE12_EMISSIONS');
        for (const q of totalScope12Group.visibleQuestions as any[]) {
          const questionId = String(q?.question_id ?? '').trim();
          if (questionId) consumedQuestionIds.add(questionId);
        }
      }

      plan.push({
        kind: 'emissions-group',
        key: 'b3-emissions-group',
        scope1Question: scope1Question ?? null,
        scope2Group: scope2Group ?? null,
        totalGroup: totalScope12Group ?? null,
      });
    }

    const ghgTargetYearsGroup = consumeGroupByCode('GHG_TARGET_YEARS');
    if (ghgTargetYearsGroup) {
      plan.push({ kind: 'group', key: 'b3-ghg-target-years-group', group: ghgTargetYearsGroup });
    }

    const totalGhgIntensityGroup = consumeGroupByCode('TOTAL_GHG_INTENSITY');
    if (totalGhgIntensityGroup) {
      // Keep intensity rows out of the standard group renderer; they are displayed inside the GHG composite card.
    }

    for (const group of visibleGroups) {
      const groupCode = normalizeCode((group as any)?.code);
      if (!groupCode || consumedGroupCodes.has(groupCode)) continue;
      plan.push({ kind: 'group', key: `b3-group-${groupCode}`, group });
      consumedGroupCodes.add(groupCode);
      for (const q of group.visibleQuestions as any[]) {
        const questionId = String(q?.question_id ?? '').trim();
        if (questionId) consumedQuestionIds.add(questionId);
      }
    }

    for (const q of visibleStandalone as any[]) {
      const questionId = String(q?.question_id ?? '').trim();
      if (!questionId || consumedQuestionIds.has(questionId)) continue;
      plan.push({ kind: 'question', key: `b3-question-${questionId}`, question: q });
      consumedQuestionIds.add(questionId);
    }

    return { plan };
  }, [normalizedSectionCode, sectionRenderModel, b3ComputedTotalsModel, b3QuestionsByDatapoint]);

  // Hydrate B3 energy table values from persisted answers (initial load only)
  useEffect(() => {
    // Only hydrate once per B3 session, and only when data is available
    if (normalizedSectionCode !== 'B3' || b3HydrationDoneRef.current || Object.keys(answersById).length === 0 || !b3QuestionsByDatapoint.size) {
      return;
    }

    b3HydrationDoneRef.current = true;

    const datapointMapping = {
      electricity_purchased: {
        renewable: 'EnergyConsumptionFromElectricity_RenewableEnergyMember',
        nonRenewable: 'EnergyConsumptionFromElectricity_NonRenewableEnergyMember',
        total: 'EnergyConsumptionFromElectricity',
      },
      self_generated_electricity: {
        renewable: 'EnergyConsumptionFromSelfGeneratedElectricity_RenewableEnergyMember',
        nonRenewable: 'EnergyConsumptionFromSelfGeneratedElectricity_NonRenewableEnergyMember',
        total: 'EnergyConsumptionFromSelfGeneratedElectricity',
      },
      fuels: {
        renewable: 'EnergyConsumptionFromFuels_RenewableEnergyMember',
        nonRenewable: 'EnergyConsumptionFromFuels_NonRenewableEnergyMember',
        total: 'EnergyConsumptionFromFuels',
      },
    } as const;

    const updatedValues = { ...b3EnergyBreakdownValues };

    for (const rowKey of ['electricity_purchased', 'self_generated_electricity', 'fuels'] as const) {
      const mapping = datapointMapping[rowKey];

      // Hydrate renewable (only if currently empty)
      const renewableQ = b3QuestionsByDatapoint.get(String(mapping.renewable).trim().toUpperCase());
      if (renewableQ && String(updatedValues[rowKey].renewable ?? '').trim() === '') {
        const qId = String(renewableQ.question_id ?? '').trim();
        if (qId && answersById[qId]) {
          updatedValues[rowKey].renewable = String(answersById[qId].value_text ?? '');
        }
      }

      // Hydrate nonRenewable (only if currently empty)
      const nonRenewableQ = b3QuestionsByDatapoint.get(String(mapping.nonRenewable).trim().toUpperCase());
      if (nonRenewableQ && String(updatedValues[rowKey].nonRenewable ?? '').trim() === '') {
        const qId = String(nonRenewableQ.question_id ?? '').trim();
        if (qId && answersById[qId]) {
          updatedValues[rowKey].nonRenewable = String(answersById[qId].value_text ?? '');
        }
      }

      // Hydrate total (only if currently empty)
      const totalQ = b3QuestionsByDatapoint.get(String(mapping.total).trim().toUpperCase());
      if (totalQ && String(updatedValues[rowKey].total ?? '').trim() === '') {
        const qId = String(totalQ.question_id ?? '').trim();
        if (qId && answersById[qId]) {
          updatedValues[rowKey].total = String(answersById[qId].value_numeric ?? '');
        }
      }
    }

    setB3EnergyBreakdownValues(updatedValues);
    b3EnergyBreakdownValuesRef.current = updatedValues;

    // Hydrate card-level N/A flag from TotalEnergyConsumption question (shared N/A anchor)
    const totalEnergyAnchorQ = b3QuestionsByDatapoint.get('TOTALENERGYCONSUMPTION');
    if (totalEnergyAnchorQ) {
      const qId = String(totalEnergyAnchorQ.question_id ?? '').trim();
      if (qId) {
        setB3EnergyBreakdownNa(answersById[qId]?.na === true);
      }
    }
  }, [normalizedSectionCode, b3QuestionsByDatapoint]);

  useEffect(() => {
    if (!reportId) return;

    let cancelled = false;

    const inMemoryCurrency = normalizeCurrency(templateCurrencyValue);

    if (inMemoryCurrency) {
      setReportCurrency(inMemoryCurrency);
      return;
    }

    const run = async () => {
      try {
        const supabase = createSupabaseBrowserClient();

        const { data: qRow, error: qErr } = await supabase
          .from('disclosure_question')
          .select('id')
          .eq('framework', 'VSME')
          .eq('vsme_datapoint_id', 'template_currency')
          .maybeSingle();

        if (qErr || !(qRow as any)?.id) {
          if (!cancelled) setReportCurrency(null);
          return;
        }

        const { data: aRow, error: aErr } = await supabase
          .from('disclosure_answer')
          .select('value_text')
          .eq('report_id', reportId)
          .eq('question_id', (qRow as any).id)
          .maybeSingle();

        if (!cancelled) {
          if (aErr) {
            setReportCurrency(null);
          } else {
            setReportCurrency(normalizeCurrency((aRow as any)?.value_text));
          }
        }
      } catch {
        if (!cancelled) setReportCurrency(null);
      }
    };

    void run();

    return () => {
      cancelled = true;
    };
  }, [reportId, templateCurrencyValue, normalizeCurrency]);

  const clearAnswer = async (questionId: string) => {
    if (!reportId) return;

    setSavingById((prev) => ({ ...prev, [questionId]: true }));
    setErrorById((prev) => ({ ...prev, [questionId]: null }));

    try {
      const supabase = createSupabaseBrowserClient();
      const { error: deleteError } = await supabase
        .from('disclosure_answer')
        .delete()
        .eq('report_id', reportId)
        .eq('question_id', questionId);
      if (deleteError) throw deleteError;

      setAnswersById((prev) => ({
        ...prev,
        [questionId]: {
          ...(prev[questionId] ?? {}),
          value_text: '',
          value_numeric: '',
          value_date: '',
          value_boolean: null,
          na: false,
        },
      }));
      setAllQuestions((prev) =>
        prev.map((q: any) => {
          if (String(q?.question_id ?? '') !== questionId) return q;
          const currentJson = (q?.value_jsonb ?? {}) as any;
          const nextJson = { ...currentJson };
          delete nextJson.na;
          return {
            ...q,
            value_text: '',
            value_numeric: '',
            value_date: '',
            value_boolean: null,
            value_jsonb: Object.keys(nextJson).length > 0 ? nextJson : {},
          };
        }),
      );
      await refreshCta();
      setSavingById((prev) => ({ ...prev, [questionId]: false }));
      setSavedAtById((prev) => ({ ...prev, [questionId]: Date.now() }));
      setTimeout(() => {
        setSavedAtById((prev) => {
          if ((prev[questionId] ?? 0) === 0) return prev;
          const next = { ...prev };
          if (Date.now() - (next[questionId] ?? 0) >= 1500) delete next[questionId];
          return next;
        });
      }, 1500);
    } catch (e: any) {
      setSavingById((prev) => ({ ...prev, [questionId]: false }));
      setErrorById((prev) => ({ ...prev, [questionId]: e?.message ?? 'Clear failed' }));
    }
  };

  const saveAnswer = async (questionId: string, answerType: string, value: string | boolean | undefined) => {
    if (!reportId) return;

    setSavingById((prev) => ({ ...prev, [questionId]: true }));
    setErrorById((prev) => ({ ...prev, [questionId]: null }));

    const supabase = createSupabaseBrowserClient();
    const t = String(answerType ?? '').toLowerCase();
    const isNumericType = t === 'number' || t === 'integer' || t === 'numeric';
    const isEmptyNumericValue =
      value === undefined ||
      value === null ||
      (typeof value === 'string' && value.trim() === '');
    const currentQuestion = (allQuestions as any[]).find(
      (q: any) => String(q?.question_id ?? '') === questionId,
    );
    const currentCode = String((currentQuestion as any)?.code ?? '').trim().toUpperCase();
    const currentDp = String((currentQuestion as any)?.vsme_datapoint_id ?? '').trim().toUpperCase();
    const isB3SourceQuestion =
      currentCode === B3_GHG_SOURCE_CODES.scope1 ||
      currentCode === B3_GHG_SOURCE_CODES.scope2Location ||
      currentCode === B3_GHG_SOURCE_CODES.scope2Market;
    const isTurnoverQuestion = currentDp === B3_GHG_TURNOVER_DP;
    const nextB3Trigger: 'source' | 'turnover' | 'other' = isB3SourceQuestion
      ? 'source'
      : isTurnoverQuestion
        ? 'turnover'
        : 'other';

    try {
      if ((isNumericType && isEmptyNumericValue) || (!isNumericType && (value === undefined || value === ''))) {
        const { error: deleteError } = await supabase
          .from('disclosure_answer')
          .delete()
          .eq('report_id', reportId)
          .eq('question_id', questionId);
        if (deleteError) throw deleteError;

        b3RecomputeTriggerRef.current = nextB3Trigger;

        setAnswersById((prev) => ({
          ...prev,
          [questionId]: {
            ...(prev[questionId] ?? {}),
            value_text: '',
            value_numeric: '',
            value_date: '',
            value_boolean: null,
            na: false,
          },
        }));
        setAllQuestions((prev) =>
          prev.map((q: any) => {
            if (String(q?.question_id ?? '') !== questionId) return q;
            const currentJson = (q?.value_jsonb ?? {}) as any;
            const nextJson = { ...currentJson };
            delete nextJson.na;
            return {
              ...q,
              value_text: '',
              value_numeric: '',
              value_date: '',
              value_boolean: null,
              value_jsonb: Object.keys(nextJson).length > 0 ? nextJson : {},
            };
          }),
        );
        await refreshCta();
        setSavingById((prev) => ({ ...prev, [questionId]: false }));
        setSavedAtById((prev) => ({ ...prev, [questionId]: Date.now() }));
        setTimeout(() => {
          setSavedAtById((prev) => {
            if ((prev[questionId] ?? 0) === 0) return prev;
            const next = { ...prev };
            if (Date.now() - (next[questionId] ?? 0) >= 1500) delete next[questionId];
            return next;
          });
        }, 1500);
        return;
      }

      const currentJson = (((currentQuestion as any)?.value_jsonb ?? {}) as any) || {};
      const nextValueJsonb = { ...currentJson };
      delete nextValueJsonb.na;
      if (nextValueJsonb.source === 'company_profile') {
        nextValueJsonb.source = 'user';
      }

      const payload: any = {
        report_id: reportId,
        question_id: questionId,
        value_jsonb: Object.keys(nextValueJsonb).length > 0 ? nextValueJsonb : {},
      };

      if (isNumericType) {
        if (!isEmptyNumericValue) {
          payload.value_numeric = Number(value);
        }
      } else if (t === 'boolean') {
        payload.value_boolean = typeof value === 'boolean' ? value : String(value).trim().toLowerCase() === 'true';
      } else if (t === 'date') {
        payload.value_date = value;
      } else {
        payload.value_text = value;
      }

      const { error: upsertError } = await supabase
        .from('disclosure_answer')
        .upsert(payload, { onConflict: 'report_id,question_id' });
      if (upsertError) throw upsertError;

      b3RecomputeTriggerRef.current = nextB3Trigger;

      setAnswersById((prev) => {
        const current = prev[questionId] ?? {};
        const next: LocalAnswer = {
          ...current,
          value_text: '',
          value_numeric: '',
          value_date: '',
          value_boolean: null,
          na: false,
        };

        if (isNumericType) {
          if (!isEmptyNumericValue) {
            next.value_numeric = String(value);
          }
        } else if (t === 'boolean') {
          next.value_boolean = typeof value === 'boolean' ? value : String(value).trim().toLowerCase() === 'true';
        } else if (t === 'date') {
          next.value_date = String(value);
        } else {
          next.value_text = String(value);
        }

        return {
          ...prev,
          [questionId]: next,
        };
      });
      setAllQuestions((prev) =>
        prev.map((q: any) => {
          if (String(q?.question_id ?? '') !== questionId) return q;
          const currentJson = (q?.value_jsonb ?? {}) as any;
          const nextJson = { ...currentJson };
          delete nextJson.na;
          if (nextJson.source === 'company_profile') {
            nextJson.source = 'user';
          }

          const nextRow: any = {
            ...q,
            value_text: '',
            value_numeric: '',
            value_date: '',
            value_boolean: null,
            value_jsonb: Object.keys(nextJson).length > 0 ? nextJson : {},
          };

          if (isNumericType) {
            if (!isEmptyNumericValue) {
              nextRow.value_numeric = Number(value);
            }
          } else if (t === 'boolean') {
            nextRow.value_boolean = typeof value === 'boolean' ? value : String(value).trim().toLowerCase() === 'true';
          } else if (t === 'date') {
            nextRow.value_date = value;
          } else {
            nextRow.value_text = value;
          }

          return nextRow;
        }),
      );
      await refreshCta();
      setSavingById((prev) => ({ ...prev, [questionId]: false }));
      setSavedAtById((prev) => ({ ...prev, [questionId]: Date.now() }));
      setTimeout(() => {
        setSavedAtById((prev) => {
          if ((prev[questionId] ?? 0) === 0) return prev;
          const next = { ...prev };
          if (Date.now() - (next[questionId] ?? 0) >= 1500) delete next[questionId];
          return next;
        });
      }, 1500);
    } catch (e: any) {
      setSavingById((prev) => ({ ...prev, [questionId]: false }));
      setErrorById((prev) => ({ ...prev, [questionId]: e?.message ?? 'Save failed' }));
    }
  };

  const toggleNA = async (questionId: string, nextNa: boolean) => {
    if (!reportId) return;

    const supabase = createSupabaseBrowserClient();

    if (nextNa) {
      const currentQuestion = (allQuestions as any[]).find(
        (q: any) => String(q?.question_id ?? '') === questionId,
      );
      const currentJson = (((currentQuestion as any)?.value_jsonb ?? {}) as any) || {};
      const { error } = await supabase
        .from('disclosure_answer')
        .upsert(
          {
            report_id: reportId,
            question_id: questionId,
            value_jsonb: {
              ...currentJson,
              na: true,
            },
          },
          { onConflict: 'report_id,question_id' },
        );
    if (error) console.error('toggle NA on failed', error);
    else {
      setAnswersById((prev) => ({
        ...prev,
        [questionId]: { ...(prev[questionId] ?? {}), na: true },
      }));
      setAllQuestions((prev) =>
        prev.map((q: any) => {
          if (String(q?.question_id ?? '') !== questionId) return q;
          const currentJson = (q?.value_jsonb ?? {}) as any;
          return {
            ...q,
            value_jsonb: {
              ...currentJson,
              na: true,
            },
          };
        }),
      );
      await refreshCta();
    }
      
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
    const nextValueJsonb = Object.keys(next).length > 0 ? next : {};

    const { error } = await supabase
      .from('disclosure_answer')
      .update({ value_jsonb: nextValueJsonb })
      .eq('report_id', reportId)
      .eq('question_id', questionId);

    if (error) console.error('toggle NA off failed', error);
    else {
      setAnswersById((prev) => ({
        ...prev,
        [questionId]: { ...(prev[questionId] ?? {}), na: false },
      }));
      setAllQuestions((prev) =>
        prev.map((q: any) => {
          if (String(q?.question_id ?? '') !== questionId) return q;
          const currentJson = (q?.value_jsonb ?? {}) as any;
          const nextJson = { ...currentJson };
          delete nextJson.na;
          return {
            ...q,
            value_jsonb: Object.keys(nextJson).length > 0 ? nextJson : {},
          };
        }),
      );
      await refreshCta();
    }
  };

  useEffect(() => {
    if (!isB1Section || !reportId) return;

    const byCode = new Map<string, any>();
    for (const q of sectionQuestions as any[]) {
      const code = String(q?.code ?? '').trim().toUpperCase();
      if (code) byCode.set(code, q);
    }

    const legalParentQuestion = byCode.get('UNDERTAKINGSLEGALFORM');
    const legalParentQuestionId = String(legalParentQuestion?.question_id ?? '').trim();
    const legalChildQuestion = byCode.get('OTHERUNDERTAKINGSLEGALFORM');
    const legalChildQuestionId = String(legalChildQuestion?.question_id ?? '').trim();

    const prevParentQuestion = byCode.get('REPORTCONTAINSDISCLOSURESFROMTHEPREVIOUSREPORTINGPERIODTHATREMAINUNCHANGED');
    const prevParentQuestionId = String(prevParentQuestion?.question_id ?? '').trim();
    const prevListChildQuestion = byCode.get('LISTOFDISCLOSURESFORWHICHNOCHANGESAREREPORTEDCOMPAREDTOTHEPREVIOUSPERIODREPORTING');
    const prevListChildQuestionId = String(prevListChildQuestion?.question_id ?? '').trim();
    const prevLinkChildQuestion = byCode.get('LINKTOPREVIOUSREPORTCONTAININGDISCLOSURESTHATREMAINUNCHANGED');
    const prevLinkChildQuestionId = String(prevLinkChildQuestion?.question_id ?? '').trim();

    const expectedLegalParentValue = 'other (please specify the legal form in the row below)';
    const legalParentValue = String(answersById[legalParentQuestionId]?.value_text ?? '').trim().toLowerCase();
    const shouldShowLegalChild = legalParentQuestionId ? legalParentValue === expectedLegalParentValue : false;

    const prevParentRawValue = answersById[prevParentQuestionId]?.value_boolean;
    const prevParentValue =
      prevParentRawValue === true || prevParentRawValue === false
        ? prevParentRawValue
        : String(answersById[prevParentQuestionId]?.value_text ?? '').trim().toLowerCase() === 'true';
    const shouldShowPrevChildren = prevParentQuestionId ? prevParentValue === true : false;

    const targets: Array<{ childQuestionId: string; shouldShow: boolean }> = [];
    if (legalChildQuestionId) {
      targets.push({ childQuestionId: legalChildQuestionId, shouldShow: shouldShowLegalChild });
    }
    if (prevListChildQuestionId) {
      targets.push({ childQuestionId: prevListChildQuestionId, shouldShow: shouldShowPrevChildren });
    }
    if (prevLinkChildQuestionId) {
      targets.push({ childQuestionId: prevLinkChildQuestionId, shouldShow: shouldShowPrevChildren });
    }

    if (targets.length === 0) return;

    let cancelled = false;

    const run = async () => {
      const supabase = createSupabaseBrowserClient();

      for (const target of targets) {
        const { childQuestionId, shouldShow } = target;
        const childAnswer = answersById[childQuestionId] ?? {};
        const childHasTypedValue = hasAnyValue(childAnswer);
        const childIsNa = childAnswer.na === true;

        if (!shouldShow) {
          if (childIsNa && !childHasTypedValue) continue;

          const { data: existing, error: readErr } = await supabase
            .from('disclosure_answer')
            .select('value_jsonb')
            .eq('report_id', reportId)
            .eq('question_id', childQuestionId)
            .maybeSingle();

          if (readErr || cancelled) continue;

          const currentJson = (existing?.value_jsonb ?? {}) as any;
          const nextValueJsonb = {
            ...currentJson,
            na: true,
          };

          const { error: upsertErr } = await supabase
            .from('disclosure_answer')
            .upsert(
              {
                report_id: reportId,
                question_id: childQuestionId,
                value_text: null,
                value_numeric: null,
                value_date: null,
                value_jsonb: nextValueJsonb,
              },
              { onConflict: 'report_id,question_id' },
            );

          if (upsertErr || cancelled) continue;

          setAnswersById((prev) => ({
            ...prev,
            [childQuestionId]: {
              ...(prev[childQuestionId] ?? {}),
              value_text: '',
              value_numeric: '',
              value_date: '',
              value_boolean: null,
              na: true,
            },
          }));

          setAllQuestions((prev) =>
            prev.map((q: any) => {
              if (String(q?.question_id ?? '') !== childQuestionId) return q;
              const currentRowJson = (q?.value_jsonb ?? {}) as any;
              return {
                ...q,
                value_text: '',
                value_numeric: '',
                value_date: '',
                value_boolean: null,
                value_jsonb: {
                  ...currentRowJson,
                  na: true,
                },
              };
            }),
          );

          await refreshCta();
          continue;
        }

        if (!childIsNa) continue;

        const { data: existing, error: readErr } = await supabase
          .from('disclosure_answer')
          .select('value_jsonb')
          .eq('report_id', reportId)
          .eq('question_id', childQuestionId)
          .maybeSingle();

        if (readErr || cancelled) continue;

        const currentJson = (existing?.value_jsonb ?? {}) as any;
        const nextValueJsonb = { ...currentJson };
        delete nextValueJsonb.na;

        const { error: updateErr } = await supabase
          .from('disclosure_answer')
          .update({ value_jsonb: Object.keys(nextValueJsonb).length > 0 ? nextValueJsonb : {} })
          .eq('report_id', reportId)
          .eq('question_id', childQuestionId);

        if (updateErr || cancelled) continue;

        setAnswersById((prev) => ({
          ...prev,
          [childQuestionId]: {
            ...(prev[childQuestionId] ?? {}),
            na: false,
          },
        }));

        setAllQuestions((prev) =>
          prev.map((q: any) => {
            if (String(q?.question_id ?? '') !== childQuestionId) return q;
            const currentRowJson = (q?.value_jsonb ?? {}) as any;
            const nextRowJson = { ...currentRowJson };
            delete nextRowJson.na;
            return {
              ...q,
              value_jsonb: Object.keys(nextRowJson).length > 0 ? nextRowJson : {},
            };
          }),
        );

        await refreshCta();
      }
    };

    void run();

    return () => {
      cancelled = true;
    };
  }, [isB1Section, reportId, sectionQuestions, answersById, refreshCta]);

  const targetSectionCode = String(cta?.continue_section_code || cta?.suggested_section_code || '').toUpperCase();
  const targetSectionTitle = VSME_SECTION_META[targetSectionCode]?.title || targetSectionCode;

  const renderQuestionCard = (
    q: any,
    idx: number,
    total: number,
    mode: 'full' | 'compact' = 'full',
    options?: { hideTopRow?: boolean; hideQuestionTitle?: boolean; hideGuidanceText?: boolean; customHeader?: any; compactShellClassName?: string },
  ) => {
    const isCompact = mode === 'compact';
    const hideTopRow = options?.hideTopRow === true;
    const hideQuestionTitle = options?.hideQuestionTitle === true;
    const hideGuidanceText = options?.hideGuidanceText === true;
    const customHeader = options?.customHeader ?? null;
    const compactShellClassName = options?.compactShellClassName ?? null;
    const questionId = String(q.question_id ?? '');
    const t = String(q.answer_type ?? '').toLowerCase();
    const a = answersById[questionId] ?? {};
    const allowed = (q.config_jsonb?.allowed_values ?? []) as string[];
    const isEnumText = (t === 'text' || t === 'string') && Array.isArray(allowed) && allowed.length > 0;
    const isNa = a.na === true;
    const isSaving = savingById[questionId] === true;
    const saveError = errorById[questionId];
    const recentlySaved = Date.now() - (savedAtById[questionId] ?? 0) < 1500;
    const guidanceText = String(q.guidance_text ?? '').trim();
    const isPrefilledFromCompanyProfile = String(q?.value_jsonb?.source ?? '') === 'company_profile';
    const unit = String(q.unit ?? '').trim().toUpperCase();
    const isNumeric = t === 'number' || t === 'integer' || t === 'numeric';
    const rawDisplayUnit = isNumeric
      ? (CURRENCY_UNITS.includes(unit as (typeof CURRENCY_UNITS)[number]) ? reportCurrency ?? unit : unit)
      : '';
    const displayUnit = rawDisplayUnit.toUpperCase() === 'MWH' ? 'MWh' : rawDisplayUnit;
    const baseText = q.question_text ?? q.title ?? 'Untitled question';

    let renderedQuestionText = baseText;

    if (
      displayUnit &&
      (q.answer_type === 'number' ||
       q.answer_type === 'numeric' ||
       q.answer_type === 'integer')
    ) {
      const trimmed = baseText.trim().toLowerCase();

      const endsWithIn =
        trimmed.endsWith(' in') ||
        trimmed.endsWith(' in:');

      const alreadyHasUnit =
        baseText.toUpperCase().endsWith(` ${displayUnit}`);

      if (endsWithIn && !alreadyHasUnit) {
        renderedQuestionText = `${baseText} ${displayUnit}`;
      }
    }

    return (
      <li
        key={questionId}
        className={[
          isCompact
            ? (compactShellClassName ?? 'h-full flex flex-col p-2 transition-colors')
            : 'rounded-lg shadow border border-gray-200 border-l-4 p-4 transition-colors',
          isCompact
            ? (isNa ? 'text-slate-500' : 'text-gray-900')
            : (isNa ? 'border-l-slate-300 bg-slate-50 text-slate-500' : 'border-l-blue-500 bg-white text-gray-900'),
        ].join(' ')}
      >
        {customHeader}

        {!hideTopRow ? (
          <div className={isCompact ? 'flex items-center justify-between gap-4' : 'flex items-center justify-between gap-4 pb-2 border-b border-slate-100'}>
            {isCompact ? <div /> : (
              <div className="text-[11px] text-gray-400">
                {idx + 1} / {total}
              </div>
            )}
            <label className="flex items-center gap-3 shrink-0 select-none cursor-pointer bg-slate-50 rounded-full px-3 py-1">
              <span className="text-xs text-slate-600">Not applicable</span>
              <div className="relative">
                <input
                  type="checkbox"
                  checked={isNa}
                  onChange={(e) => void toggleNA(questionId, e.target.checked)}
                  className="sr-only peer"
                />
                <div className="w-10 h-5 bg-gray-300 peer-checked:bg-gray-400 rounded-full transition-colors" />
                <div className="absolute left-0.5 top-0.5 w-4 h-4 bg-white rounded-full shadow transition-transform peer-checked:translate-x-5" />
              </div>
            </label>
          </div>
        ) : null}

        {!hideQuestionTitle ? (
          <div className={[isCompact ? 'mt-2 text-sm font-semibold' : 'mt-2 text-base font-semibold', isNa ? 'text-slate-600' : 'text-gray-900'].join(' ')}>
            {renderedQuestionText}
          </div>
        ) : null}
        {guidanceText && !hideGuidanceText ? (
          <div className={["mt-1 text-sm leading-relaxed", isNa ? 'text-slate-500' : 'text-slate-600'].join(' ')}>{guidanceText}</div>
        ) : null}

        {isNa ? (
          <div className="mt-2 text-xs text-slate-500">Marked as Not applicable (answer preserved)</div>
        ) : (
          <div className={isCompact ? 'mt-auto' : ''}>
            {(t === 'text' || t === 'string') && !isEnumText && (
              <div className="mt-2">
                <input
                  type="text"
                  value={a.value_text ?? ''}
                  onChange={(e) => {
                    const v = e.target.value;
                    setAnswersById((prev) => ({
                      ...prev,
                      [questionId]: { ...(prev[questionId] ?? {}), value_text: v },
                    }));
                    if (String(q.vsme_datapoint_id ?? '') === 'template_currency') {
                      setReportCurrency(normalizeCurrency(v));
                    }
                  }}
                  onBlur={(e) => saveAnswer(questionId, q.answer_type, e.target.value)}
                  className="w-full px-3 py-2 border border-gray-300 rounded placeholder:text-slate-400 placeholder:italic"
                  autoComplete="off"
                  placeholder={getPlaceholder(q, a)}
                />
              </div>
            )}

            {t === 'boolean' && (
              <div className="mt-2">
                <select
                  value={a.value_boolean === true ? 'true' : a.value_boolean === false ? 'false' : ''}
                  onChange={(e) => {
                    const v = e.target.value;
                    setAnswersById((prev) => ({
                      ...prev,
                      [questionId]: {
                        ...(prev[questionId] ?? {}),
                        value_boolean: v === 'true' ? true : v === 'false' ? false : null,
                      },
                    }));
                  }}
                  onBlur={(e) => saveAnswer(questionId, q.answer_type, e.target.value)}
                  className="w-full px-3 py-2 border border-gray-300 rounded bg-white"
                >
                  <option value="">— Select —</option>
                  <option value="true">Yes</option>
                  <option value="false">No</option>
                </select>
              </div>
            )}

            {(t === 'number' || t === 'integer' || t === 'numeric') && (
              <div className="mt-2 flex items-center gap-2">
                <input
                  type="number"
                  value={a.value_numeric ?? ''}
                  onChange={(e) => {
                    const v = e.target.value;
                    if (
                      normalizedSectionCode === 'B3' &&
                      String(q?.code ?? '').trim().toUpperCase() === 'TOTALENERGYCONSUMPTION'
                    ) {
                      setB3TotalEnergyUserInteracted(true);
                    }
                    setAnswersById((prev) => ({
                      ...prev,
                      [questionId]: { ...(prev[questionId] ?? {}), value_numeric: v },
                    }));
                  }}
                  onBlur={(e) => saveAnswer(questionId, q.answer_type, e.target.value)}
                  className="flex-1 w-full px-3 py-2 border border-gray-300 rounded placeholder:text-slate-400 placeholder:italic"
                  placeholder={getPlaceholder(q, a)}
                />
                {displayUnit ? <span className="text-xs text-gray-500 shrink-0">{displayUnit}</span> : null}
              </div>
            )}

            {t === 'date' && (
              <div className="mt-2">
                <input
                  type="date"
                  value={a.value_date ?? ''}
                  onChange={(e) => {
                    const v = e.target.value;
                    setAnswersById((prev) => ({
                      ...prev,
                      [questionId]: { ...(prev[questionId] ?? {}), value_date: v },
                    }));
                  }}
                  onBlur={(e) => saveAnswer(questionId, q.answer_type, e.target.value)}
                  className="w-full px-3 py-2 border border-gray-300 rounded"
                />
              </div>
            )}

            {(t === 'select' || isEnumText) && (
              <div className="mt-2">
                {!Array.isArray(allowed) || allowed.length === 0 ? (
                  <input
                    type="text"
                    value={a.value_text ?? ''}
                    onChange={(e) => {
                      const v = e.target.value;
                      setAnswersById((prev) => ({
                        ...prev,
                        [questionId]: { ...(prev[questionId] ?? {}), value_text: v },
                      }));
                      if (String(q.vsme_datapoint_id ?? '') === 'template_currency') {
                        setReportCurrency(normalizeCurrency(v));
                      }
                    }}
                    onBlur={(e) => saveAnswer(questionId, q.answer_type, e.target.value)}
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
                        [questionId]: { ...(prev[questionId] ?? {}), value_text: v },
                      }));
                      if (String(q.vsme_datapoint_id ?? '') === 'template_currency') {
                        setReportCurrency(normalizeCurrency(v));
                      }
                    }}
                    onBlur={(e) => saveAnswer(questionId, q.answer_type, e.target.value)}
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

            {isPrefilledFromCompanyProfile && !isCompact ? (
              <div className="mt-1 text-xs text-gray-400">Prefilled from company profile</div>
            ) : null}

            <div className="mt-1 min-h-[1rem] text-xs">
              {isSaving ? <span className="text-gray-500">Saving…</span> : null}
              {!isSaving && saveError ? <span className="text-red-600">Not saved</span> : null}
              {!isSaving && !saveError && recentlySaved ? <span className="text-emerald-600">Saved</span> : null}
            </div>
          </div>
        )}
      </li>
    );
  };

  return (
    <div className="min-h-screen bg-gray-50 p-8 pb-24">
      <div className="max-w-3xl mx-auto">
        {/* REPORT BOX (must be on top) */}
        <div className="bg-white rounded-lg border border-gray-200 border-t-4 border-t-blue-500 shadow-sm p-4 mb-6">
          <div className="flex items-center justify-between gap-3">
            <div className="text-lg font-semibold text-gray-900">Report status</div>
            <Link
              href={`/${locale}/reports/${reportId}/questions`}
              className="shrink-0 inline-flex items-center rounded-md border border-gray-300 bg-white px-3 py-1.5 text-xs font-medium text-gray-600 hover:bg-gray-50"
            >
              Report settings
            </Link>
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
          <div className="flex items-center justify-between gap-3 mb-3">
            <div className="text-lg font-semibold text-gray-900">Sections</div>
            <div className="grid grid-cols-[64px_40px] gap-x-2 shrink-0 text-right">
              <div className="col-span-2 text-xs text-gray-500 text-center">Completion</div>
            </div>
          </div>

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
                  <div className="text-sm font-medium text-gray-500">
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

        <div className="sticky top-16 z-50 mb-4 bg-white/95 backdrop-blur border-b border-gray-200">
          <div className="flex items-center justify-between px-3 py-2">
            <div className="min-w-0 text-base font-semibold text-gray-900 truncate">
              {sectionCode} — {sectionTitle}
            </div>
            <button
              type="button"
              onClick={() => window.scrollTo({ top: 0, behavior: 'smooth' })}
              className="ml-4 shrink-0 text-xs font-normal text-gray-500 hover:text-gray-700 hover:underline underline-offset-2"
            >
              Back to top
            </button>
          </div>
          <div className="px-3 pb-2 text-xs text-gray-600">
            Answered: {sectionCompleteness.answered} · N/A: {sectionCompleteness.na} · Missing: {sectionCompleteness.missing} · {sectionCompleteness.pct}%
          </div>
        </div>

        {/* SECTION QUESTIONS */}
        {loading ? (
          <div className="text-gray-600">Loading section…</div>
        ) : error ? (
          <div className="bg-red-50 border border-red-200 rounded p-4">
            <div className="font-semibold text-red-800">Error</div>
            <div className="text-red-700 text-sm mt-1">{error}</div>
          </div>
        ) : displayedQuestionCount === 0 ? (
          <div className="bg-yellow-50 border border-yellow-200 rounded p-4 text-yellow-900">
            No questions matched this section.
          </div>
        ) : (
          <>
            {isBSection && b1GroupedRenderModel?.hasMetadata && sectionRenderModel ? (
              <div className="space-y-8">
                {(() => {
                  const renderGroup = (group: any, startIndex: number, total: number) => {
                    const isPairGroup = group.kind === 'pair';
                    const shouldRenderPairLayout = isPairGroup && group.visibleQuestions.length >= 2;

                    return (
                      <div key={group.key} className="space-y-3 rounded-xl border border-gray-200 bg-white p-4 shadow-sm">
                        <div className="px-1 pb-2 text-base font-semibold text-gray-900 border-b border-gray-100">{group.title}</div>
                        {shouldRenderPairLayout ? (
                          <ul className="grid grid-cols-1 md:grid-cols-2 gap-2 items-stretch">
                            {group.visibleQuestions.map((q: any, idx: number) => {
                              const questionId = String((q as any)?.question_id ?? '').trim();
                              return (
                                <div key={`${questionId || idx}-pair`} className="h-full">
                                  {renderQuestionCard(q, startIndex + idx, total, 'compact')}
                                </div>
                              );
                            })}
                          </ul>
                        ) : (
                          <ul className="space-y-2">
                            {group.visibleQuestions.map((q: any, idx: number) => {
                              const questionId = String((q as any)?.question_id ?? '').trim();
                              return (
                                <div key={`${questionId || idx}-wrap`}>
                                  {renderQuestionCard(q, startIndex + idx, total)}
                                </div>
                              );
                            })}
                          </ul>
                        )}
                      </div>
                    );
                  };

                  if (normalizedSectionCode === 'B3' && b3RenderPlan) {
                    const formatB3ComputedLabel = (raw: string) => {
                      const text = String(raw ?? '').trim();
                      if (!text) return text;

                      const mostlyUppercase = text === text.toUpperCase();
                      if (!mostlyUppercase) return text;

                      const lower = text.toLowerCase();
                      const sentence = lower.charAt(0).toUpperCase() + lower.slice(1);
                      return sentence
                        .replace(/\bscope\b/g, 'Scope')
                        .replace(/\bghg\b/g, 'GHG')
                        .replace(/\bco2e\b/g, 'CO2e');
                    };

                    const total = b3RenderPlan.plan.reduce((acc: number, block: any) => {
                      if (block.kind === 'group') return acc + (block.group?.visibleQuestions?.length ?? 0);
                      if (block.kind === 'question') return acc + 1;
                      if (block.kind === 'energy' && block.totalEnergyQuestion) return acc + 1;
                      if (block.kind === 'computed-total-pair') return acc + 2;
                      return acc;
                    }, 0);

                    let runningIndex = 0;

                    return b3RenderPlan.plan.map((block: any) => {
                      if (block.kind === 'energy') {
                        const totalEnergyQuestion = block.totalEnergyQuestion;
                        const sectionStart = runningIndex;
                        const breakdownRows = [
                          { key: 'electricity_purchased', label: 'Electricity purchased' },
                          { key: 'self_generated_electricity', label: 'Self-generated electricity' },
                          { key: 'fuels', label: 'Fuels' },
                        ] as const;
                        console.debug('[B3 energy debug] breakdownRows', breakdownRows.map((r) => r.key));

                        const parseBreakdownNumber = (raw: string): number | null => {
                          const trimmed = String(raw ?? '').trim();
                          if (!trimmed) return null;
                          const parsed = Number(trimmed);
                          return Number.isFinite(parsed) ? parsed : null;
                        };

                        const persistByDatapoint = async (
                          datapointId: string,
                          value: string,
                          options?: {
                            forceText?: boolean;
                            debugContext?: {
                              source: 'persistDetailRow' | 'persistRowTotalBlur';
                              rowKey: 'electricity_purchased' | 'self_generated_electricity' | 'fuels';
                              field?: 'renewable' | 'nonRenewable' | 'total';
                            };
                          },
                        ) => {
                          const key = String(datapointId ?? '').trim().toUpperCase();
                          if (!key) return;
                          const q = b3QuestionsByDatapoint.get(key);
                          if (!q) return;
                          const questionId = String(q?.question_id ?? '').trim();
                          if (!questionId) return;
                          if (String(value ?? '').trim() === '') {
                            console.debug('[B3 energy clearByDatapoint]', {
                              context: options?.debugContext ?? null,
                              datapointId,
                              question_id: questionId,
                            });
                            await clearAnswer(questionId);
                            return;
                          }
                          const answerType = options?.forceText ? 'text' : String(q?.answer_type ?? 'number');
                          console.debug('[B3 energy persistByDatapoint]', {
                            context: options?.debugContext ?? null,
                            datapointId,
                            question_id: questionId,
                            answer_type: answerType,
                            value,
                          });
                          await saveAnswer(questionId, answerType, value);
                        };

                        const datapointMapping = {
                          electricity_purchased: {
                            renewable: 'EnergyConsumptionFromElectricity_RenewableEnergyMember',
                            nonRenewable: 'EnergyConsumptionFromElectricity_NonRenewableEnergyMember',
                            total: 'EnergyConsumptionFromElectricity',
                          },
                          self_generated_electricity: {
                            renewable: 'EnergyConsumptionFromSelfGeneratedElectricity_RenewableEnergyMember',
                            nonRenewable: 'EnergyConsumptionFromSelfGeneratedElectricity_NonRenewableEnergyMember',
                            total: 'EnergyConsumptionFromSelfGeneratedElectricity',
                          },
                          fuels: {
                            renewable: 'EnergyConsumptionFromFuels_RenewableEnergyMember',
                            nonRenewable: 'EnergyConsumptionFromFuels_NonRenewableEnergyMember',
                            total: 'EnergyConsumptionFromFuels',
                          },
                        } as const;

                        const getRowComputedTotal = (
                          snapshot: Record<'electricity_purchased' | 'self_generated_electricity' | 'fuels', { renewable: string; nonRenewable: string; total: string }>,
                          rowKey: 'electricity_purchased' | 'self_generated_electricity' | 'fuels',
                        ): number | null => {
                          const current = snapshot[rowKey];
                          const renewable = parseBreakdownNumber(current.renewable);
                          const nonRenewable = parseBreakdownNumber(current.nonRenewable);
                          const enteredTotal = parseBreakdownNumber(current.total);
                          const isRowDetailMode = renewable !== null || nonRenewable !== null;
                          const isRowTotalMode = !isRowDetailMode && enteredTotal !== null;
                          if (isRowDetailMode) return (renewable ?? 0) + (nonRenewable ?? 0);
                          if (isRowTotalMode) return enteredTotal;
                          return null;
                        };

                        const getGrandTotal = (
                          snapshot: Record<'electricity_purchased' | 'self_generated_electricity' | 'fuels', { renewable: string; nonRenewable: string; total: string }>,
                        ): number | null => {
                          const keys: Array<'electricity_purchased' | 'self_generated_electricity' | 'fuels'> = [
                            'electricity_purchased',
                            'self_generated_electricity',
                            'fuels',
                          ];
                          let acc = 0;
                          let hasAny = false;
                          for (const key of keys) {
                            const rowTotal = getRowComputedTotal(snapshot, key);
                            if (rowTotal !== null) {
                              hasAny = true;
                              acc += rowTotal;
                            }
                          }
                          return hasAny ? acc : null;
                        };

                        const clearScheduledPersistDetailRow = (
                          rowKey: 'electricity_purchased' | 'self_generated_electricity' | 'fuels',
                        ) => {
                          const timeoutId = b3DetailPersistTimeoutsRef.current[rowKey];
                          if (timeoutId !== null) {
                            window.clearTimeout(timeoutId);
                            b3DetailPersistTimeoutsRef.current[rowKey] = null;
                          }
                        };

                        const persistDetailRow = async (
                          rowKey: 'electricity_purchased' | 'self_generated_electricity' | 'fuels',
                        ) => {
                          const snapshot = b3EnergyBreakdownValuesRef.current;
                          const current = snapshot[rowKey];
                          const mapping = datapointMapping[rowKey];
                          const isDetailRowCleared =
                            String(current.renewable ?? '').trim() === '' &&
                            String(current.nonRenewable ?? '').trim() === '';
                          const rowTotal = getRowComputedTotal(snapshot, rowKey);
                          const grandTotal = getGrandTotal(snapshot);

                          console.debug('[B3 energy persistDetailRow]', {
                            rowKey,
                            current,
                            mapping,
                            rowTotal,
                            grandTotal,
                          });

                          if (isDetailRowCleared) {
                            await persistByDatapoint(mapping.renewable, '', {
                              forceText: true,
                              debugContext: { source: 'persistDetailRow', rowKey, field: 'renewable' },
                            });
                            await persistByDatapoint(mapping.nonRenewable, '', {
                              forceText: true,
                              debugContext: { source: 'persistDetailRow', rowKey, field: 'nonRenewable' },
                            });
                            await persistByDatapoint(mapping.total, '', {
                              debugContext: { source: 'persistDetailRow', rowKey, field: 'total' },
                            });
                            await persistByDatapoint('TotalEnergyConsumption', grandTotal !== null ? String(grandTotal) : '', {
                              debugContext: { source: 'persistDetailRow', rowKey, field: 'total' },
                            });
                            return;
                          }

                          await persistByDatapoint(mapping.renewable, String(current.renewable ?? ''), {
                            forceText: true,
                            debugContext: { source: 'persistDetailRow', rowKey, field: 'renewable' },
                          });
                          await persistByDatapoint(mapping.nonRenewable, String(current.nonRenewable ?? ''), {
                            forceText: true,
                            debugContext: { source: 'persistDetailRow', rowKey, field: 'nonRenewable' },
                          });
                          await persistByDatapoint(mapping.total, rowTotal !== null ? String(rowTotal) : '', {
                            debugContext: { source: 'persistDetailRow', rowKey, field: 'total' },
                          });
                          await persistByDatapoint('TotalEnergyConsumption', grandTotal !== null ? String(grandTotal) : '', {
                            debugContext: { source: 'persistDetailRow', rowKey, field: 'total' },
                          });
                        };

                        const schedulePersistDetailRow = (
                          rowKey: 'electricity_purchased' | 'self_generated_electricity' | 'fuels',
                        ) => {
                          clearScheduledPersistDetailRow(rowKey);
                          b3DetailPersistTimeoutsRef.current[rowKey] = window.setTimeout(() => {
                            b3DetailPersistTimeoutsRef.current[rowKey] = null;
                            void persistDetailRow(rowKey);
                          }, 350);
                        };

                        const persistRowTotalBlur = async (
                          rowKey: 'electricity_purchased' | 'self_generated_electricity' | 'fuels',
                          editedValue: string,
                        ) => {
                          const currentValues = b3EnergyBreakdownValuesRef.current;
                          const current = currentValues[rowKey];
                          const nextRow = {
                            ...current,
                            total: editedValue,
                            renewable: editedValue !== '' ? '' : current.renewable,
                            nonRenewable: editedValue !== '' ? '' : current.nonRenewable,
                          };
                          const snapshot = {
                            ...currentValues,
                            [rowKey]: nextRow,
                          };

                          const mapping = datapointMapping[rowKey];
                          const rowTotal = getRowComputedTotal(snapshot, rowKey);
                          const grandTotal = getGrandTotal(snapshot);

                          console.debug('[B3 energy persistRowTotalBlur]', {
                            rowKey,
                            editedValue,
                            nextRow,
                            mapping,
                            rowTotal,
                            grandTotal,
                          });

                          await persistByDatapoint(mapping.total, rowTotal !== null ? String(rowTotal) : '', {
                            debugContext: { source: 'persistRowTotalBlur', rowKey, field: 'total' },
                          });
                          await persistByDatapoint(mapping.renewable, String(nextRow.renewable ?? ''), {
                            forceText: true,
                            debugContext: { source: 'persistRowTotalBlur', rowKey, field: 'renewable' },
                          });
                          await persistByDatapoint(mapping.nonRenewable, String(nextRow.nonRenewable ?? ''), {
                            forceText: true,
                            debugContext: { source: 'persistRowTotalBlur', rowKey, field: 'nonRenewable' },
                          });
                          await persistByDatapoint('TotalEnergyConsumption', grandTotal !== null ? String(grandTotal) : '', {
                            debugContext: { source: 'persistRowTotalBlur', rowKey, field: 'total' },
                          });
                        };

                        const rowValues = breakdownRows.map((row) => {
                          const current = b3EnergyBreakdownValues[row.key];
                          const renewable = parseBreakdownNumber(current.renewable);
                          const nonRenewable = parseBreakdownNumber(current.nonRenewable);
                          const enteredTotal = parseBreakdownNumber(current.total);
                          const isRowDetailMode = renewable !== null || nonRenewable !== null;
                          const isRowTotalMode = !isRowDetailMode && enteredTotal !== null;
                          const rowTotal = isRowDetailMode
                            ? (renewable ?? 0) + (nonRenewable ?? 0)
                            : isRowTotalMode
                              ? enteredTotal
                              : null;
                          return {
                            ...row,
                            renewable,
                            nonRenewable,
                            enteredTotal,
                            isRowDetailMode,
                            isRowTotalMode,
                            rowTotal,
                          };
                        });

                        const hasBreakdownValues = rowValues.some((row) => (
                          row.rowTotal !== null
                        ));
                        const hasAnyRenewableValue = rowValues.some((row) => row.renewable !== null);
                        const hasAnyNonRenewableValue = rowValues.some((row) => row.nonRenewable !== null);
                        const hasRowTotalModeActive = rowValues.some((row) => row.isRowTotalMode);

                        const totalEnergyQuestionId = String(totalEnergyQuestion?.question_id ?? '').trim();
                        const totalEnergyAnswer = totalEnergyQuestionId ? (answersById[totalEnergyQuestionId] ?? {}) : {};
                        const hasEnteredTotalEnergy = totalEnergyQuestionId
                          ? b3TotalEnergyUserInteracted && hasAnyValue(totalEnergyAnswer) && totalEnergyAnswer.na !== true
                          : false;

                        const isDetailDrivenMode = hasBreakdownValues;
                        const isTotalOnlyMode = !isDetailDrivenMode && hasEnteredTotalEnergy;
                        const isBreakdownDisabled = b3EnergyBreakdownNa || isTotalOnlyMode;

                        const renewableTotal = hasAnyRenewableValue
                          ? rowValues.reduce((acc, row) => acc + (row.renewable ?? 0), 0)
                          : null;
                        const nonRenewableTotal = hasAnyNonRenewableValue
                          ? rowValues.reduce((acc, row) => acc + (row.nonRenewable ?? 0), 0)
                          : null;
                        const overallTotal = hasBreakdownValues
                          ? rowValues.reduce((acc, row) => acc + (row.rowTotal ?? 0), 0)
                          : null;

                        const renderTotalValueWithUnit = (
                          content: any,
                          options?: { shellClassName?: string; unitLabel?: string },
                        ) => {
                          const shellClassName = options?.shellClassName ?? 'bg-white text-gray-900';
                          const unitLabel = options?.unitLabel ?? 'MWh';
                          return (
                            <div className="w-full flex items-center gap-2">
                              <div className={`flex-1 min-w-0 px-2 py-1 rounded border border-gray-300 ${shellClassName}`}>
                                {content}
                              </div>
                              <span className="text-[11px] font-medium text-slate-400 whitespace-nowrap shrink-0">{unitLabel}</span>
                            </div>
                          );
                        };

                        if (totalEnergyQuestion) {
                          runningIndex += 1;
                        }

                        return (
                          <div key={block.key} className="space-y-4 rounded-lg shadow border border-gray-200 border-l-4 border-l-blue-500 bg-white p-4">
                            {/* Card header with shared N/A toggle */}
                            <div className="px-1 pb-2 border-b border-gray-100 flex items-center justify-between gap-3">
                              <span className="text-base font-semibold text-gray-900">Energy consumption</span>
                              <label className="flex items-center gap-3 shrink-0 select-none cursor-pointer bg-slate-50 rounded-full px-3 py-1">
                                <span className="text-xs text-slate-600">Not applicable</span>
                                <div className="relative">
                                  <input
                                    type="checkbox"
                                    checked={b3EnergyBreakdownNa}
                                    onChange={(e) => {
                                      const nextChecked = e.target.checked;
                                      setB3EnergyBreakdownNa(nextChecked);
                                      // Persist N/A on TotalEnergyConsumption question (card-level anchor)
                                      const totalEnergyAnchorQ = b3QuestionsByDatapoint.get('TOTALENERGYCONSUMPTION');
                                      if (totalEnergyAnchorQ) {
                                        const qId = String(totalEnergyAnchorQ.question_id ?? '').trim();
                                        if (qId) {
                                          void toggleNA(qId, nextChecked);
                                        }
                                      }
                                      if (nextChecked) {
                                        // Cancel pending debounced writes; keep values visible (read-only)
                                        // so they reappear immediately when N/A is turned back OFF.
                                        clearScheduledPersistDetailRow('electricity_purchased');
                                        clearScheduledPersistDetailRow('self_generated_electricity');
                                        clearScheduledPersistDetailRow('fuels');
                                      }
                                    }}
                                    className="sr-only peer"
                                  />
                                  <div className="w-10 h-5 bg-gray-300 peer-checked:bg-gray-400 rounded-full transition-colors" />
                                  <div className="absolute left-0.5 top-0.5 w-4 h-4 bg-white rounded-full shadow transition-transform peer-checked:translate-x-5" />
                                </div>
                              </label>
                            </div>
                            <div className="text-sm font-medium text-gray-900">What was your total energy consumption during the reporting year?</div>
                            <div className="text-sm text-gray-500">Include all energy used by your company during the reporting year (electricity, gas, district heating, fuels used on-site, etc.). If you have multiple sites, include all of them. If exact data are not available, a reasonable estimate based on utility bills or invoices is acceptable.</div>
                            <div className="text-sm text-gray-500">If you know the detailed energy breakdown, enter it here. Otherwise, you may provide only total energy consumption below.</div>
                            {b3EnergyBreakdownNa ? (
                              <div className="text-xs text-slate-500">Marked as Not applicable (answer preserved)</div>
                            ) : null}

                            {!b3EnergyBreakdownNa ? (
                              <>
                                <div className="pt-1">
                                  <div className="text-sm font-medium text-gray-700">1. Energy consumption breakdown (MWh)</div>
                                  {isTotalOnlyMode ? (
                                    <div className="mt-2 text-xs text-slate-500">
                                      To edit detailed breakdown values, clear the total value first.
                                    </div>
                                  ) : null}
                                  <div className="mt-2 overflow-x-auto">
                                    <table className={[
                                      'w-full text-sm border-collapse',
                                      isTotalOnlyMode ? 'opacity-70' : '',
                                    ].join(' ')}>
                                      <thead>
                                        <tr>
                                          <th className="text-left w-[32%] px-3 py-2 border-b border-gray-200 text-gray-600">Source</th>
                                          <th className="text-left w-[21%] px-3 py-2 border-b border-gray-200 text-gray-600">Renewable</th>
                                          <th className="text-left w-[21%] px-3 py-2 border-b border-gray-200 text-gray-600">Non-renewable</th>
                                          <th className="text-left w-[26%] px-3 py-2 border-b border-gray-200 text-gray-600">Total</th>
                                        </tr>
                                      </thead>
                                      <tbody>
                                        {rowValues.map((row) => (
                                          <tr key={row.key}>
                                            <td className="px-3 py-2 border-b border-gray-100 text-gray-800">{row.label}</td>
                                            <td className="px-3 py-2 border-b border-gray-100">
                                              <input
                                                type="number"
                                                value={b3EnergyBreakdownValues[row.key].renewable}
                                                onChange={(e) => {
                                                  const nextValue = e.target.value;
                                                  setB3EnergyBreakdownValues((prev) => {
                                                    const next = {
                                                      ...prev,
                                                      [row.key]: {
                                                        ...prev[row.key],
                                                        renewable: nextValue,
                                                        total: nextValue !== '' || String(prev[row.key].nonRenewable ?? '') !== '' ? '' : prev[row.key].total,
                                                      },
                                                    };
                                                    b3EnergyBreakdownValuesRef.current = next;
                                                    return next;
                                                  });
                                                  schedulePersistDetailRow(row.key);
                                                }}
                                                disabled={isBreakdownDisabled || row.isRowTotalMode}
                                                className="w-full px-2 py-1 rounded border border-gray-300 bg-white text-gray-900 disabled:bg-slate-50 disabled:text-slate-500"
                                                placeholder=""
                                              />
                                            </td>
                                            <td className="px-3 py-2 border-b border-gray-100">
                                              <input
                                                type="number"
                                                value={b3EnergyBreakdownValues[row.key].nonRenewable}
                                                onChange={(e) => {
                                                  const nextValue = e.target.value;
                                                  setB3EnergyBreakdownValues((prev) => {
                                                    const next = {
                                                      ...prev,
                                                      [row.key]: {
                                                        ...prev[row.key],
                                                        nonRenewable: nextValue,
                                                        total: nextValue !== '' || String(prev[row.key].renewable ?? '') !== '' ? '' : prev[row.key].total,
                                                      },
                                                    };
                                                    b3EnergyBreakdownValuesRef.current = next;
                                                    return next;
                                                  });
                                                  schedulePersistDetailRow(row.key);
                                                }}
                                                disabled={isBreakdownDisabled || row.isRowTotalMode}
                                                className="w-full px-2 py-1 rounded border border-gray-300 bg-white text-gray-900 disabled:bg-slate-50 disabled:text-slate-500"
                                                placeholder=""
                                              />
                                            </td>
                                            <td className="px-3 py-2 border-b border-gray-100">
                                              {row.isRowDetailMode ? (
                                                renderTotalValueWithUnit(
                                                  <span className="block w-full text-slate-700 font-medium">{row.rowTotal !== null ? row.rowTotal : '—'}</span>,
                                                  { shellClassName: 'bg-slate-50 text-slate-700' },
                                                )
                                              ) : (
                                                <div className="space-y-1">
                                                  {renderTotalValueWithUnit(
                                                    <input
                                                      type="number"
                                                      value={b3EnergyBreakdownValues[row.key].total}
                                                      onChange={(e) => {
                                                        const nextValue = e.target.value;
                                                        clearScheduledPersistDetailRow(row.key);
                                                        setB3EnergyBreakdownValues((prev) => {
                                                          const next = {
                                                            ...prev,
                                                            [row.key]: {
                                                              ...prev[row.key],
                                                              total: nextValue,
                                                              renewable: nextValue !== '' ? '' : prev[row.key].renewable,
                                                              nonRenewable: nextValue !== '' ? '' : prev[row.key].nonRenewable,
                                                            },
                                                          };
                                                          b3EnergyBreakdownValuesRef.current = next;
                                                          return next;
                                                        });
                                                      }}
                                                      onBlur={(e) => {
                                                        void persistRowTotalBlur(row.key, e.target.value);
                                                      }}
                                                      disabled={isBreakdownDisabled}
                                                      className="w-full min-w-0 bg-transparent text-gray-900 placeholder:text-slate-400 outline-none disabled:text-slate-500"
                                                      placeholder=""
                                                    />,
                                                    { shellClassName: isBreakdownDisabled ? 'bg-slate-50 text-slate-500' : 'bg-white text-gray-900' },
                                                  )}
                                                </div>
                                              )}
                                            </td>
                                          </tr>
                                        ))}
                                        <tr>
                                          <td className="px-3 py-2 border-t border-gray-200 font-semibold text-gray-900">Total</td>
                                          <td className="px-3 py-2 border-t border-gray-200">
                                            <div className="w-full px-2 py-1 rounded border border-gray-300 bg-slate-50 text-slate-700 font-semibold">{renewableTotal !== null ? renewableTotal : '—'}</div>
                                          </td>
                                          <td className="px-3 py-2 border-t border-gray-200">
                                            <div className="w-full px-2 py-1 rounded border border-gray-300 bg-slate-50 text-slate-700 font-semibold">{nonRenewableTotal !== null ? nonRenewableTotal : '—'}</div>
                                          </td>
                                          <td className="px-3 py-2 border-t border-gray-200">
                                            {renderTotalValueWithUnit(
                                              <span className="block w-full text-slate-800 font-semibold">{overallTotal !== null ? overallTotal : '—'}</span>,
                                              { shellClassName: 'bg-slate-50 text-slate-800' },
                                            )}
                                          </td>
                                        </tr>
                                      </tbody>
                                    </table>
                                  </div>
                                  {hasRowTotalModeActive ? (
                                    <div className="mt-2 text-xs text-slate-500">
                                      If you enter a row total, renewable and non-renewable values for that row are disabled. Clear the row total to enter the detailed breakdown.
                                    </div>
                                  ) : null}
                                </div>

                                {totalEnergyQuestion ? (
                                  <div className="mt-6 pt-4 border-t border-gray-100">
                                    <div className="text-sm font-medium text-gray-700">2. Total energy consumption (MWh)</div>
                                    <div className="mt-1">
                                      {isDetailDrivenMode ? (
                                        <div className="rounded-md border border-slate-200 bg-slate-50 p-3 text-gray-900">
                                          <div className="text-sm font-medium text-slate-700">Computed from energy breakdown</div>
                                          {overallTotal !== null ? (
                                            <div className="mt-1 text-xs text-slate-500">To enter a total value manually, clear the breakdown values first.</div>
                                          ) : null}
                                          <div className="mt-2 flex items-center gap-2">
                                            {(() => {
                                              const rawUnit = String(totalEnergyQuestion?.unit ?? '').trim();
                                              if (!rawUnit) return null;
                                              const unitLabel = rawUnit.toUpperCase() === 'MWH' ? 'MWh' : rawUnit;
                                              return renderTotalValueWithUnit(
                                                <span className="block w-full text-base font-semibold text-slate-800">{overallTotal !== null ? overallTotal : '—'}</span>,
                                                { shellClassName: 'bg-white text-slate-800', unitLabel },
                                              );
                                            })()}
                                          </div>
                                        </div>
                                      ) : (
                                        renderQuestionCard(totalEnergyQuestion, sectionStart, total, 'compact', { hideTopRow: true, hideQuestionTitle: true, hideGuidanceText: true })
                                      )}
                                    </div>
                                  </div>
                                ) : null}
                              </>
                            ) : null}
                          </div>
                        );
                      }

                      if (block.kind === 'question') {
                        const node = renderQuestionCard(block.question, runningIndex, total);
                        runningIndex += 1;
                        return <div key={block.key}>{node}</div>;
                      }

                      if (block.kind === 'emissions-group') {
                        const scope1Question = block.scope1Question;
                        const scope2Questions = block.scope2Group?.visibleQuestions ?? [];
                        const totalQuestions = block.totalGroup?.visibleQuestions ?? [];
                        const sectionCount = (scope1Question ? 1 : 0) + scope2Questions.length + totalQuestions.length;
                        const sectionStart = runningIndex;
                        runningIndex += sectionCount;

                        const totalItems = (totalQuestions as any[]).map((q: any) => {
                          const code = String(q?.code ?? '').trim().toUpperCase();
                          if (code === 'TOTALGROSSLOCATIONBASEDSCOPE1ANDSCOPE2GHGEMISSIONS') {
                            return b3ComputedTotalsModel.location ?? {
                              questionId: String(q?.question_id ?? '').trim(),
                              title: String(q?.question_text ?? q?.title ?? 'Total Scope 1 + Scope 2 (location-based)'),
                              value: null,
                              unit: String(q?.unit ?? '').trim().toUpperCase(),
                            };
                          }
                          if (code === 'TOTALGROSSMARKETBASEDSCOPE1ANDSCOPE2GHGEMISSIONS') {
                            return b3ComputedTotalsModel.market ?? {
                              questionId: String(q?.question_id ?? '').trim(),
                              title: String(q?.question_text ?? q?.title ?? 'Total Scope 1 + Scope 2 (market-based)'),
                              value: null,
                              unit: String(q?.unit ?? '').trim().toUpperCase(),
                            };
                          }
                          return {
                            questionId: String(q?.question_id ?? '').trim(),
                            title: String(q?.question_text ?? q?.title ?? 'Derived total'),
                            value: null,
                            unit: String(q?.unit ?? '').trim().toUpperCase(),
                          };
                        });

                        const intensityBranches = [b3IntensityModel.location, b3IntensityModel.market].filter(
                          (b): b is NonNullable<typeof b3IntensityModel.location> => Boolean(b?.questionId),
                        );
                        const b1Href = `/${locale}/reports/${reportId}/sections/B1`;
                        const fmtIntensity = (v: number) => {
                          if (!Number.isFinite(v)) return '—';
                          if (v === 0) return '0';
                          if (Math.abs(v) < 0.0001 || Math.abs(v) >= 1e6) return v.toExponential(3);
                          return parseFloat(v.toPrecision(4)).toString();
                        };

                        return (
                          <div key={block.key} className="space-y-4 rounded-lg shadow border border-blue-200 border-l-4 border-l-blue-500 bg-white p-4">
                            <div className="px-1 pb-2 text-base font-semibold text-gray-900 border-b border-gray-100">Scope 1 and Scope 2 GHG emissions</div>

                            {scope1Question ? (
                              <div className="pt-1">
                                <div className="flex items-center justify-between gap-3">
                                  <div className="text-sm font-medium text-gray-700">1. Scope 1 GHG emissions</div>
                                  {(() => {
                                    const questionId = String(scope1Question?.question_id ?? '').trim();
                                    const isNa = questionId ? answersById[questionId]?.na === true : false;
                                    return questionId ? (
                                      <label className="flex items-center gap-3 shrink-0 select-none cursor-pointer bg-slate-50 rounded-full px-3 py-1">
                                        <span className="text-xs text-slate-600">Not applicable</span>
                                        <div className="relative">
                                          <input
                                            type="checkbox"
                                            checked={isNa}
                                            onChange={(e) => void toggleNA(questionId, e.target.checked)}
                                            className="sr-only peer"
                                          />
                                          <div className="w-10 h-5 bg-gray-300 peer-checked:bg-gray-400 rounded-full transition-colors" />
                                          <div className="absolute left-0.5 top-0.5 w-4 h-4 bg-white rounded-full shadow transition-transform peer-checked:translate-x-5" />
                                        </div>
                                      </label>
                                    ) : null;
                                  })()}
                                </div>
                                <div className="mt-2">
                                  {renderQuestionCard(scope1Question, sectionStart, total, 'compact', { hideTopRow: true, hideQuestionTitle: true })}
                                </div>
                              </div>
                            ) : null}

                            {scope2Questions.length > 0 ? (
                              <div className="mt-6 pt-4 border-t border-gray-100">
                                <div className="text-sm font-medium text-gray-700">2. Scope 2 GHG emissions</div>
                                <ul className="mt-2 grid grid-cols-1 md:grid-cols-2 gap-2 items-stretch">
                                  {scope2Questions.map((q: any, idx: number) => {
                                    const questionId = String((q as any)?.question_id ?? '').trim();
                                    const headline = String((q as any)?.question_text ?? (q as any)?.title ?? 'Untitled question');
                                    const isNa = questionId ? answersById[questionId]?.na === true : false;
                                    return (
                                      renderQuestionCard(q, sectionStart + (scope1Question ? 1 : 0) + idx, total, 'compact', {
                                        hideTopRow: true,
                                        hideQuestionTitle: true,
                                        compactShellClassName: 'h-full flex flex-col rounded-md border border-gray-200 bg-gray-50 p-3 transition-colors',
                                        customHeader: (
                                          <div className="flex items-center justify-between gap-3 pb-2 border-b border-gray-100">
                                            <div className="text-sm font-medium text-gray-700">{headline}</div>
                                            {questionId ? (
                                              <label className="flex items-center gap-3 shrink-0 select-none cursor-pointer bg-white rounded-full px-3 py-1">
                                                <span className="text-xs text-slate-600">Not applicable</span>
                                                <div className="relative">
                                                  <input
                                                    type="checkbox"
                                                    checked={isNa}
                                                    onChange={(e) => void toggleNA(questionId, e.target.checked)}
                                                    className="sr-only peer"
                                                  />
                                                  <div className="w-10 h-5 bg-gray-300 peer-checked:bg-gray-400 rounded-full transition-colors" />
                                                  <div className="absolute left-0.5 top-0.5 w-4 h-4 bg-white rounded-full shadow transition-transform peer-checked:translate-x-5" />
                                                </div>
                                              </label>
                                            ) : null}
                                          </div>
                                        ),
                                      })
                                    );
                                  })}
                                </ul>
                              </div>
                            ) : null}

                            {totalItems.length > 0 ? (
                              <div className="mt-6 pt-4 border-t border-gray-100">
                                <div className="text-sm font-medium text-gray-700">3. Total Scope 1 + Scope 2 GHG emissions</div>
                                <ul className="mt-2 grid grid-cols-1 md:grid-cols-2 gap-2 items-stretch">
                                  {totalItems.map((item, idx) => (
                                    <li key={`${block.key}-${idx}`} className="h-full rounded-md border border-gray-200 bg-gray-50 p-3 text-gray-900">
                                      <div className="text-sm font-medium text-gray-700">{formatB3ComputedLabel(item.title)}</div>
                                      <div className="mt-2 flex items-center gap-2">
                                        <div className="flex-1 text-base font-semibold text-gray-900">
                                          {item.value !== null ? item.value : '—'}
                                        </div>
                                        {item.unit ? (
                                          <span className="text-xs text-gray-500 shrink-0">
                                            {item.unit}
                                          </span>
                                        ) : null}
                                      </div>
                                      <div className="mt-2 text-xs text-slate-500 leading-relaxed">
                                        {item.value !== null
                                          ? 'Computed from Scope 1 and Scope 2 values.'
                                          : 'Computed automatically once required source values are available.'}
                                      </div>
                                    </li>
                                  ))}
                                </ul>
                              </div>
                            ) : null}

                            {intensityBranches.length > 0 ? (
                              <div className="mt-6 pt-4 border-t border-gray-100">
                                <div className="text-sm font-medium text-gray-700">4. GHG emissions intensity</div>
                                <ul className="mt-2 grid grid-cols-1 md:grid-cols-2 gap-2 items-stretch">
                                  {intensityBranches.map((item, idx) => {
                                    const isNa = item.questionId ? answersById[item.questionId]?.na === true : false;
                                    return (
                                      <li key={`${block.key}-intensity-${idx}`} className="h-full rounded-md border border-gray-200 bg-gray-50 p-3">
                                        <div className="flex items-center justify-between gap-3 pb-2 border-b border-gray-100">
                                          <div className="text-sm font-medium text-gray-700">{item.title}</div>
                                          {item.questionId ? (
                                            <label className="flex items-center gap-3 shrink-0 select-none cursor-pointer bg-white rounded-full px-3 py-1">
                                              <span className="text-xs text-slate-600">Not applicable</span>
                                              <div className="relative">
                                                <input
                                                  type="checkbox"
                                                  checked={isNa}
                                                  onChange={(e) => void toggleNA(item.questionId, e.target.checked)}
                                                  className="sr-only peer"
                                                />
                                                <div className="w-10 h-5 bg-gray-300 peer-checked:bg-gray-400 rounded-full transition-colors" />
                                                <div className="absolute left-0.5 top-0.5 w-4 h-4 bg-white rounded-full shadow transition-transform peer-checked:translate-x-5" />
                                              </div>
                                            </label>
                                          ) : null}
                                        </div>
                                        {isNa ? (
                                          <div className="mt-2 text-xs text-slate-500 leading-relaxed">Marked as Not applicable (answer preserved)</div>
                                        ) : (
                                          <>
                                            <div className="mt-2 flex items-end gap-2">
                                              <div className={item.state === 'numeric' && item.value !== null
                                                ? 'text-base font-semibold leading-none text-gray-900'
                                                : 'text-base font-semibold leading-none text-gray-400'
                                              }>
                                                {item.state === 'numeric' && item.value !== null ? fmtIntensity(item.value) : '—'}
                                              </div>
                                              {item.state === 'numeric' && item.value !== null && item.unit ? (
                                                <span className="text-xs font-medium text-slate-500 mb-0.5">{item.unit}</span>
                                              ) : null}
                                            </div>
                                            {item.warningKind === 'missing-inputs' ? (
                                              <div className="mt-2 text-xs text-amber-600 leading-relaxed">
                                                Intensity cannot be calculated because GHG emissions or Turnover (in{' '}
                                                <Link href={b1Href} className="underline font-medium hover:text-amber-800">section B1</Link>
                                                ) is missing or marked as N/A. Please check the GHG totals in this section and Turnover in section B1. If intensity is not available for your report, you may mark this field as N/A.
                                              </div>
                                            ) : item.warningKind === 'zero-turnover' ? (
                                              <div className="mt-2 text-xs text-amber-600 leading-relaxed">
                                                Intensity cannot be calculated because Turnover (in{' '}
                                                <Link href={b1Href} className="underline font-medium hover:text-amber-800">section B1</Link>
                                                ) is 0. If your turnover is truly 0 for this reporting period, mark this field as N/A.
                                              </div>
                                            ) : (
                                              <div className="mt-2 text-xs text-slate-500 leading-relaxed">
                                                <div>Computed as: GHG total ÷ Turnover (section B1).</div>
                                                <div>Unit: tCO₂e per 1 unit of Turnover.</div>
                                              </div>
                                            )}
                                          </>
                                        )}
                                      </li>
                                    );
                                  })}
                                </ul>
                              </div>
                            ) : null}
                          </div>
                        );
                      }

                      if (block.kind === 'computed-total-pair') {
                        const totalItems = (block.group.visibleQuestions as any[]).map((q: any) => {
                          const code = String(q?.code ?? '').trim().toUpperCase();
                          if (code === 'TOTALGROSSLOCATIONBASEDSCOPE1ANDSCOPE2GHGEMISSIONS') {
                            return b3ComputedTotalsModel.location ?? {
                              questionId: String(q?.question_id ?? '').trim(),
                              title: String(q?.question_text ?? q?.title ?? 'Total Scope 1 + Scope 2 (location-based)'),
                              value: null,
                              unit: String(q?.unit ?? '').trim().toUpperCase(),
                            };
                          }
                          if (code === 'TOTALGROSSMARKETBASEDSCOPE1ANDSCOPE2GHGEMISSIONS') {
                            return b3ComputedTotalsModel.market ?? {
                              questionId: String(q?.question_id ?? '').trim(),
                              title: String(q?.question_text ?? q?.title ?? 'Total Scope 1 + Scope 2 (market-based)'),
                              value: null,
                              unit: String(q?.unit ?? '').trim().toUpperCase(),
                            };
                          }
                          return {
                            questionId: String(q?.question_id ?? '').trim(),
                            title: String(q?.question_text ?? q?.title ?? 'Derived total'),
                            value: null,
                            unit: String(q?.unit ?? '').trim().toUpperCase(),
                          };
                        });

                        runningIndex += 2;
                        return (
                          <div key={block.key} className="space-y-3 rounded-xl border border-gray-200 bg-white p-4 shadow-sm">
                            <div className="px-1 pb-2 text-base font-semibold text-gray-900 border-b border-gray-100">{block.title}</div>
                            <ul className="grid grid-cols-1 md:grid-cols-2 gap-2 items-stretch">
                              {totalItems.map((item, idx) => (
                                <li key={`${block.key}-${idx}`} className="h-full rounded-md border border-emerald-200 bg-emerald-50/40 p-3 text-gray-900">
                                  <div className="text-xs font-semibold uppercase tracking-wide text-emerald-900/80">{item.title}</div>
                                  <div className="mt-2 flex items-end gap-2">
                                    <div className={item.value !== null ? 'text-2xl font-bold leading-none text-emerald-700' : 'text-2xl font-bold leading-none text-slate-400'}>
                                      {item.value !== null ? item.value : '—'}
                                    </div>
                                    {item.unit ? (
                                      <span className={item.value !== null ? 'text-xs font-medium text-emerald-700/90 mb-0.5' : 'text-xs font-medium text-slate-500 mb-0.5'}>
                                        {item.unit}
                                      </span>
                                    ) : null}
                                  </div>
                                  <div className={item.value !== null ? 'mt-2 text-xs text-emerald-800/80' : 'mt-2 text-xs text-slate-500'}>
                                    {item.value !== null
                                      ? 'Derived summary from Scope 1 and Scope 2 source inputs.'
                                      : 'Computed automatically once required source values are available.'}
                                  </div>
                                </li>
                              ))}
                            </ul>
                          </div>
                        );
                      }

                      const startIndex = runningIndex;
                      runningIndex += block.group.visibleQuestions.length;
                      return renderGroup(block.group, startIndex, total);
                    });
                  }

                  const hiddenQuestionIds = b3ComputedTotalsModel.hiddenQuestionIds;
                  let runningIndex = 0;
                  const visibleGroups = sectionRenderModel.grouped.map((group) => {
                    const visibleQuestions = group.visibleQuestions.filter((q: any) => {
                      const questionId = String((q as any)?.question_id ?? '').trim();
                      return !hiddenQuestionIds.has(questionId);
                    });
                    return { ...group, visibleQuestions };
                  }).filter((group) => group.visibleQuestions.length > 0);

                  const standaloneQuestions = sectionRenderModel.standaloneQuestions.filter((q: any) => {
                    const questionId = String((q as any)?.question_id ?? '').trim();
                    return !hiddenQuestionIds.has(questionId);
                  });

                  const total = visibleGroups.reduce((acc, group) => acc + group.visibleQuestions.length, 0) + standaloneQuestions.length;

                  const renderedGroups = visibleGroups.map((group) => {
                    const startIndex = runningIndex;
                    runningIndex += group.visibleQuestions.length;
                    return renderGroup(group, startIndex, total);
                  });

                  const standaloneStartIndex = runningIndex;
                  const renderedStandalone = standaloneQuestions.length > 0 ? (
                    <ul className="space-y-2">
                      {standaloneQuestions.map((q: any, idx: number) =>
                        renderQuestionCard(q, standaloneStartIndex + idx, total),
                      )}
                    </ul>
                  ) : null;

                  return (
                    <>
                      {renderedGroups}
                      {renderedStandalone}
                    </>
                  );
                })()}
              </div>
            ) : (
              <div className="space-y-2">
                {b3ComputedTotalsModel.location || b3ComputedTotalsModel.market ? (
                  <div className="space-y-2">
                    <div className="rounded-lg border border-emerald-200 bg-emerald-50/40 p-4">
                      <div className="text-sm font-semibold text-gray-900">Total Scope 1 + Scope 2 emissions</div>
                      <div className="mt-2 grid grid-cols-1 md:grid-cols-2 gap-2">
                        {[b3ComputedTotalsModel.location, b3ComputedTotalsModel.market].filter(Boolean).map((item: any, idx) => (
                          <div key={`b3-fallback-computed-${idx}`} className="p-2">
                            <div className="text-sm font-semibold text-gray-900">{item.title}</div>
                            <div className="mt-1 flex items-center gap-2">
                              <div className="flex-1 px-3 py-2 border border-gray-300 rounded bg-gray-50 text-lg font-semibold text-emerald-700">
                                {item.value !== null ? item.value : '—'}
                              </div>
                              {item.unit ? <span className="text-xs text-gray-500 shrink-0">{item.unit}</span> : null}
                            </div>
                          </div>
                        ))}
                      </div>
                    </div>
                  </div>
                ) : null}

                <ul className="space-y-2">
                  {(() => {
                    const hiddenQuestionIds = b3ComputedTotalsModel.hiddenQuestionIds;
                    const visibleQuestions = sectionQuestions.filter((q: any) => {
                      const questionId = String((q as any)?.question_id ?? '').trim();
                      return !hiddenQuestionIds.has(questionId);
                    });
                    return visibleQuestions.map((q: any, idx: number) => renderQuestionCard(q, idx, visibleQuestions.length));
                  })()}
                </ul>
              </div>
            )}

            {(prevChapterCode || nextChapterCode) ? (
              <div ref={footerNavRef} className="max-w-3xl mx-auto mt-10">
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

        {showStickyNav && displayedQuestionCount > 0 && !loading && !error && (prevChapterCode || nextChapterCode) ? (
          <div className="fixed bottom-6 left-0 right-0 z-40 pointer-events-none">
            <div className="max-w-3xl mx-auto pointer-events-auto">
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
          </div>
        ) : null}
      </div>
    </div>
  );
}