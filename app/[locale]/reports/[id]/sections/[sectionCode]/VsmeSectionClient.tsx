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
    if (!isB1Section) {
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
          .eq('section_code', 'B1')
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
  }, [isB1Section]);

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

  const sectionCompleteness = useMemo(() => {
    const inSection = (allQuestions as any[]).filter((q: any) => {
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
  }, [allQuestions, normalizedSectionCode]);

  const b1GroupedRenderModel = useMemo(() => {
    if (!isB1Section) return null;

    const hasMetadata = b1QuestionGroups.length > 0 || b1QuestionGroupItems.length > 0;
    if (!hasMetadata) {
      return {
        hasMetadata: false,
        grouped: [] as Array<{
          key: string;
          code: string;
          title: string;
          questions: VsmeQuestion[];
        }>,
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
        title: String(group.title ?? group.label ?? group.name ?? group.code ?? 'Group').trim(),
        questions,
      });
    }

    const totalQuestions = grouped.reduce((acc, group) => acc + group.questions.length, 0);

    return { hasMetadata: true, grouped, isQuestionVisible, totalQuestions };
  }, [isB1Section, sectionQuestions, b1QuestionGroups, b1QuestionGroupItems, b1InteractionRules, answersById]);

  const displayedQuestionCount = useMemo(() => {
    if (!isB1Section) return sectionQuestions.length;
    if (!b1GroupedRenderModel?.hasMetadata) return sectionQuestions.length;
    return b1GroupedRenderModel.totalQuestions;
  }, [isB1Section, sectionQuestions.length, b1GroupedRenderModel]);

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

  const saveAnswer = async (questionId: string, answerType: string, value: string | boolean | undefined) => {
    if (!reportId) return;

    setSavingById((prev) => ({ ...prev, [questionId]: true }));
    setErrorById((prev) => ({ ...prev, [questionId]: null }));

    const supabase = createSupabaseBrowserClient();
    const t = String(answerType ?? '').toLowerCase();

    try {
      if (value === undefined || value === '') {
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
        return;
      }

      const currentQuestion = (allQuestions as any[]).find(
        (q: any) => String(q?.question_id ?? '') === questionId,
      );
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

      if (t === 'number' || t === 'integer' || t === 'numeric') {
        payload.value_numeric = Number(value);
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

        if (t === 'number' || t === 'integer' || t === 'numeric') {
          next.value_numeric = String(value);
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

          if (t === 'number' || t === 'integer' || t === 'numeric') {
            nextRow.value_numeric = Number(value);
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

  const renderQuestionCard = (q: any, idx: number, total: number) => {
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
    const displayUnit = isNumeric
      ? (CURRENCY_UNITS.includes(unit as (typeof CURRENCY_UNITS)[number]) ? reportCurrency ?? unit : unit)
      : '';
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
          'rounded-lg shadow',
          'border border-gray-200',
          'border-l-4',
          isNa ? 'border-l-slate-300 bg-slate-50 text-slate-500' : 'border-l-blue-500 bg-white text-gray-900',
          'p-4 transition-colors',
        ].join(' ')}
      >
        <div className="flex items-center justify-between gap-4 pb-2 border-b border-slate-100">
          <div className="text-[11px] text-gray-400">
            {idx + 1} / {total}
          </div>
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

        <div className={["mt-2 text-base font-semibold", isNa ? 'text-slate-600' : 'text-gray-900'].join(' ')}>
          {renderedQuestionText}
        </div>
        {guidanceText ? (
          <div className={["mt-1 text-sm leading-relaxed", isNa ? 'text-slate-500' : 'text-slate-600'].join(' ')}>{guidanceText}</div>
        ) : null}

        {isNa ? (
          <div className="mt-2 text-xs text-slate-500">Marked as Not applicable (answer preserved)</div>
        ) : (
          <>
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

            {isPrefilledFromCompanyProfile ? (
              <div className="mt-1 text-xs text-gray-400">Prefilled from company profile</div>
            ) : null}

            <div className="mt-1 text-xs">
              {isSaving ? <span className="text-gray-500">Saving…</span> : null}
              {!isSaving && saveError ? <span className="text-red-600">Not saved</span> : null}
              {!isSaving && !saveError && recentlySaved ? <span className="text-emerald-600">Saved</span> : null}
            </div>
          </>
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
            {isB1Section && b1GroupedRenderModel?.hasMetadata ? (
              <div className="space-y-8">
                {(() => {
                  const visibleGroups = b1GroupedRenderModel.grouped.map((group) => {
                    const visibleQuestions = group.questions.filter((q: any) => b1GroupedRenderModel.isQuestionVisible(q));
                    return { ...group, visibleQuestions };
                  });

                  let runningIndex = 0;
                  const total = visibleGroups.reduce((acc, group) => acc + group.visibleQuestions.length, 0);

                  return visibleGroups.map((group) => {
                    const startIndex = runningIndex;
                    runningIndex += group.visibleQuestions.length;

                    return (
                      <div key={group.key} className="space-y-3 rounded-xl border border-gray-200 bg-white p-4 shadow-sm">
                        <div className="px-1 pb-2 text-base font-semibold text-gray-900 border-b border-gray-100">{group.title}</div>
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
                      </div>
                    );
                  });
                })()}
              </div>
            ) : (
              <ul className="space-y-2">
                {sectionQuestions.map((q: any, idx: number) => renderQuestionCard(q, idx, sectionQuestions.length))}
              </ul>
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