// ============================================================================
// VSME Questions Utilities
// ============================================================================
// Funkcie na prácu s VSME otázkami, filtrovanie, progress tracking
//
// Vychádza z database/add_vsme_extensions.sql
// ============================================================================

import { createSupabaseServerClient } from '@/lib/supabase/server';
import { createSupabaseBrowserClient } from '@/lib/supabase/client';
import type { VersionedQuestion, Topic } from '@/types/esrs';

export interface VSMEQuestionWithCategory extends VersionedQuestion {
  topic: Topic;
  category: 'now' | 'future' | 'voluntary';
  is_required_this_year: boolean;
  is_answered: boolean;
  vsme_note?: string;
}

export interface VSMEReportProgress {
  total_applicable: number;
  answered: number;
  missing_mandatory: number;
  progress_percent: number;
}

export interface VSMEQuestionCategory {
  category: 'now' | 'future' | 'voluntary';
  label: string;
  count: number;
  datapoint_codes: string[];
  description: string;
}

// ============================================================================
// SERVER-SIDE FUNCTIONS (s Supabase server client)
// ============================================================================

/**
 * Načítaj aplikovateľné VSME otázky pre konkrétny report
 */
export async function getVSMEQuestionsForReport(
  reportId: string,
  supabase: ReturnType<typeof createSupabaseServerClient>
) {
  const { data: report } = await supabase
    .from('report')
    .select('reporting_year_sequence, company_id')
    .eq('id', reportId)
    .single();

  if (!report) throw new Error('Report not found');

  // Načítaj otázky aplikovateľné v tom roku
  const { data: questions, error } = await supabase
    .from('disclosure_question')
    .select(`
      id,
      code,
      question_text,
      description,
      answer_type,
      data_type,
      unit,
      is_mandatory,
      is_conditional,
      is_voluntary,
      applies_to_vsme_year,
      is_phased_in_for_vsme,
      vsme_note,
      order_index,
      topic:topic_id (
        id,
        code,
        name,
        category,
        order_index
      )
    `)
    .filter('applies_to_vsme_year', 'cs', `[${report.reporting_year_sequence}]`)
    .order('topic_id')
    .order('order_index');

  if (error) throw error;

  return questions as VSMEQuestionWithCategory[];
}

/**
 * Kategorízuj otázky: Teraz / Budúce / Voliteľné
 */
export async function getVSMEQuestionCategories(
  reportId: string,
  supabase: ReturnType<typeof createSupabaseServerClient>
): Promise<VSMEQuestionCategory[]> {
  const { data, error } = await supabase
    .rpc('fn_get_vsme_questions_by_category', {
      p_report_id: reportId
    });

  if (error) {
    console.warn('fn_get_vsme_questions_by_category not found, using fallback');
    // Fallback - manuálny query
    return getFallbackVSMECategories(reportId, supabase);
  }

  return data.map((cat: any) => ({
    category: cat.category as 'now' | 'future' | 'voluntary',
    label: getCategoryLabel(cat.category),
    count: cat.question_count,
    datapoint_codes: cat.datapoint_codes || [],
    description: getCategoryDescription(cat.category)
  }));
}

/**
 * Fallback keď RPC funkcia neexistuje
 */
async function getFallbackVSMECategories(
  reportId: string,
  supabase: ReturnType<typeof createSupabaseServerClient>
): Promise<VSMEQuestionCategory[]> {
  const { data: report } = await supabase
    .from('report')
    .select('reporting_year_sequence')
    .eq('id', reportId)
    .single();

  if (!report) return [];

  const currentYear = report.reporting_year_sequence;

  // Otázky "teraz" - aplikovateľné v tomto roku
  const { data: now } = await supabase
    .from('disclosure_question')
    .select('code, applies_to_vsme_year')
    .filter('applies_to_vsme_year', 'cs', `[${currentYear}]`)
    .eq('is_voluntary', false);

  // Otázky "budúce" - budú povinné neskôr
  const { data: future } = await supabase
    .from('disclosure_question')
    .select('code, applies_to_vsme_year')
    .filter('applies_to_vsme_year', 'cs', `[${currentYear + 1}]`)
    .eq('is_voluntary', false);

  // Otázky "voliteľné"
  const { data: voluntary } = await supabase
    .from('disclosure_question')
    .select('code')
    .eq('is_voluntary', true);

  return [
    {
      category: 'now',
      label: '🟢 Teraz Povinné',
      count: now?.length || 0,
      datapoint_codes: now?.map(q => q.code) || [],
      description: 'Otázky ktoré musíš vyplniť v tomto roku'
    },
    {
      category: 'future',
      label: '🔵 V Budúcnosti',
      count: future?.length || 0,
      datapoint_codes: future?.map(q => q.code) || [],
      description: 'Otázky ktoré budú povinné neskôr'
    },
    {
      category: 'voluntary',
      label: '🟡 Voliteľné',
      count: voluntary?.length || 0,
      datapoint_codes: voluntary?.map(q => q.code) || [],
      description: 'Dodatočné otázky - nepovinné'
    }
  ];
}

/**
 * Načítaj progress reportu
 */
export async function getVSMEReportProgress(
  reportId: string,
  supabase: ReturnType<typeof createSupabaseServerClient>
): Promise<VSMEReportProgress> {
  const { data, error } = await supabase
    .rpc('fn_get_vsme_report_progress', {
      p_report_id: reportId
    });

  if (error || !data || data.length === 0) {
    // Fallback manuálny query
    return getFallbackReportProgress(reportId, supabase);
  }

  return {
    total_applicable: data[0].total_applicable,
    answered: data[0].answered,
    missing_mandatory: data[0].missing_mandatory,
    progress_percent: parseFloat(data[0].progress_percent) || 0
  };
}

/**
 * Fallback progress counting
 */
async function getFallbackReportProgress(
  reportId: string,
  supabase: ReturnType<typeof createSupabaseServerClient>
): Promise<VSMEReportProgress> {
  const { data: report } = await supabase
    .from('report')
    .select('reporting_year_sequence')
    .eq('id', reportId)
    .single();

  if (!report) throw new Error('Report not found');

  // Počítaj otázky
  const { data: questions } = await supabase
    .from('disclosure_question')
    .select('id')
    .filter('applies_to_vsme_year', 'cs', `[${report.reporting_year_sequence}]`)
    .eq('is_mandatory', true);

  // Počítaj odpovede
  const { data: answers } = await supabase
    .from('disclosure_answer')
    .select('id')
    .eq('report_id', reportId);

  const total = questions?.length || 0;
  const answered = answers?.length || 0;

  return {
    total_applicable: total,
    answered: answered,
    missing_mandatory: Math.max(0, total - answered),
    progress_percent: total > 0 ? Math.round((answered / total) * 100) : 0
  };
}

/**
 * Skontroluj či je firma VSME
 */
export async function isCompanyVSME(
  companyId: string,
  supabase: ReturnType<typeof createSupabaseServerClient>
): Promise<boolean> {
  const { data } = await supabase
    .from('company')
    .select('is_vsme')
    .eq('id', companyId)
    .single();

  return data?.is_vsme ?? false;
}

/**
 * Skontroluj či je report prvý rok VSME
 */
export async function isVSMEFirstYear(
  companyId: string,
  supabase: ReturnType<typeof createSupabaseServerClient>
): Promise<boolean> {
  const { data } = await supabase
    .rpc('fn_is_vsme_first_year', {
      p_company_id: companyId
    });

  if (Array.isArray(data)) return data[0];
  return data ?? false;
}

// ============================================================================
// CLIENT-SIDE FUNCTIONS (s Supabase browser client)
// ============================================================================

/**
 * Načítaj povinné otázky pre aktuálny report (client-side)
 */
export async function getVSMERequiredQuestionsClient(
  reportId: string,
  supabase: ReturnType<typeof createSupabaseBrowserClient>
) {
  const { data, error } = await supabase
    .from('disclosure_question')
    .select(`
      *,
      topic:topic_id (
        id,
        code,
        name,
        category
      ),
      answers:disclosure_answer!question_id (
        id,
        answer_text,
        value_text,
        created_at
      )
    `)
    .eq('is_mandatory', true)
    .order('topic_id');

  if (error) throw error;

  // Filter podľa reportu
  return data || [];
}

/**
 * Aktualizuj employee_count firmy (auth required)
 */
export async function updateCompanyEmployeeCount(
  companyId: string,
  employeeCount: number,
  supabase: ReturnType<typeof createSupabaseBrowserClient>
) {
  const { data, error } = await supabase
    .from('company')
    .update({
      employee_count: employeeCount,
      employee_count_verified_at: new Date().toISOString()
    })
    .eq('id', companyId)
    .select();

  if (error) throw error;
  return data?.[0];
}

// ============================================================================
// HELPER FUNCTIONS
// ============================================================================

function getCategoryLabel(category: string): string {
  switch (category) {
    case 'now':
      return '🟢 Teraz Povinné';
    case 'future':
      return '🔵 V Budúcnosti';
    case 'voluntary':
      return '🟡 Voliteľné';
    default:
      return category;
  }
}

function getCategoryDescription(category: string): string {
  switch (category) {
    case 'now':
      return 'Otázky ktoré musíš vyplniť v tomto roku';
    case 'future':
      return 'Otázky ktoré budú povinné neskôr (fázované zavádzanie)';
    case 'voluntary':
      return 'Dodatočné otázky - čisto dobrovoľné, budú ťa teraz pomáhať';
    default:
      return '';
  }
}

/**
 * Formátuj progress pre UI
 */
export function formatVSMEProgress(progress: VSMEReportProgress): {
  percentText: string;
  status: 'not-started' | 'in-progress' | 'almost-done' | 'complete';
  statusColor: string;
} {
  let status: 'not-started' | 'in-progress' | 'almost-done' | 'complete' = 'not-started';
  let statusColor = '#9CA3AF'; // gray

  if (progress.progress_percent === 0) {
    status = 'not-started';
    statusColor = '#EF4444'; // red
  } else if (progress.progress_percent < 50) {
    status = 'in-progress';
    statusColor = '#F59E0B'; // amber
  } else if (progress.progress_percent < 100) {
    status = 'almost-done';
    statusColor = '#3B82F6'; // blue
  } else {
    status = 'complete';
    statusColor = '#10B981'; // green
  }

  return {
    percentText: `${progress.progress_percent.toFixed(0)}% (${progress.answered}/${progress.total_applicable})`,
    status,
    statusColor
  };
}

/**
 * Sorter na otázky podľa topiku a priority
 */
export function sortVSMEQuestions(questions: VSMEQuestionWithCategory[]) {
  return [...questions].sort((a, b) => {
    // Prvý sort: priority kategórie (now > future > voluntary)
    const categoryOrder = { now: 0, future: 1, voluntary: 2 };
    if (categoryOrder[a.category] !== categoryOrder[b.category]) {
      return categoryOrder[a.category] - categoryOrder[b.category];
    }

    // Druhý sort: topic order
    const topicA = (a.topic?.order_index || 0);
    const topicB = (b.topic?.order_index || 0);
    if (topicA !== topicB) {
      return topicA - topicB;
    }

    // Tretí sort: order_index v rámci topicu
    return (a.order_index || 0) - (b.order_index || 0);
  });
}

/**
 * Validuj že employee_count je povinný
 */
export function validateEmployeeCount(count: number | null): {
  valid: boolean;
  error?: string;
} {
  if (count === null || count === undefined) {
    return {
      valid: false,
      error: 'Počet zamestnancov je povinný pre určenie VSME statusu'
    };
  }

  if (count <= 0) {
    return {
      valid: false,
      error: 'Počet zamestnancov musí byť väčší ako 0'
    };
  }

  return { valid: true };
}
