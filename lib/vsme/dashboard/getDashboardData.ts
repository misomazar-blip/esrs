// ============================================================================
// Dashboard Data Fetcher
// ============================================================================
// Fetches and computes all dashboard data for VSME reports
// ============================================================================

import { createSupabaseServerClient as createClient } from "@/lib/supabase/server";

// ============================================================================
// Types
// ============================================================================

export type TopicKey = "general" | "environmental" | "social" | "governance";

export type TopicProgress = {
  key: TopicKey;
  title: string;
  totalQuestions: number;
  missing: number;
  completionPercent: number;
  status: "Complete" | "In progress" | "Not started";
};

export type DashboardData = {
  companies: Array<{
    id: string;
    name: string;
  }>;
  active_company_id: string;
  activeCompany?: {
    id: string;
    name: string;
  } | null;
  activeReport: {
    id: string;
    year: number;
    status: string;
    created_at: string;
    continue_section_code: string | null;
  } | null;
  completionPercent: number;
  naCount: number;
  lastEditedAt: string;
  topics: TopicProgress[];
  recommendedTopic: TopicKey | null;
  recommendedAction: "continue" | "export" | null;
  can_create_new_report: boolean;
  debug?: {
    questionsCount: number;
    answersCount: number;
    answeredApplicable: number;
    naCount: number;
    missingCount: number;
    completionPercent: number;
    active_company_id: string;
    activeCompanyName: string;
    activeReportCompanyId: string;
  };
};

type Question = {
  question_id: string;
  section_code: string;
  answer_type: string;
  order_index?: number;
  value_text: string | null;
  value_numeric: number | null;
  value_date: string | null;
  value_jsonb: any | null;
  updated_at: string | null;
};

type Answer = {
  question_id: string;
  value_text: string | null;
  value_numeric: number | null;
  value_date: string | null;
};

// ============================================================================
// Constants
// ============================================================================

const SECTION_ORDER = ["B1", "B2", "B3", "B4", "B5", "B6", "B7", "B8", "B9", "B10", "B11"];

const SECTION_TO_TOPIC: Record<string, TopicKey> = {
  B1: "general",
  B2: "environmental",
  B3: "environmental",
  B4: "environmental",
  B5: "environmental",
  B6: "environmental",
  B7: "environmental",
  B8: "social",
  B9: "social",
  B10: "social",
  B11: "governance",
};

const TOPIC_TITLES: Record<TopicKey, string> = {
  general: "General information",
  environmental: "Environmental",
  social: "Social",
  governance: "Governance",
};

// ============================================================================
// Helper Functions
// ============================================================================

function isPublishedStatus(status: string): boolean {
  return /publish/i.test(status);
}

function normalizeAnswerType(rawType: string | null | undefined): string {
  if (!rawType) return "";

  const normalized = rawType.toString().trim();
  const upper = normalized.toUpperCase();

  switch (upper) {
    case "TEXT":
      return "text";
    case "NUMBER":
      return "number";
    case "BOOLEAN":
      return "boolean";
    case "ENUM":
      return "enum";
    case "DATE":
      return "date";
    case "JSON":
    case "MULTI":
    case "FILE":
      return "json";
    default:
      return normalized.toLowerCase();
  }
}

function normalizeSectionCode(rawSection: string | null | undefined): string {
  if (!rawSection) return "";

  const normalized = rawSection.toString().trim().toUpperCase();
  if (SECTION_TO_TOPIC[normalized]) return normalized;

  const labelMap: Record<string, string> = {
    GENERAL: "B1",
    ENVIRONMENTAL: "B2",
    SOCIAL: "B8",
    GOVERNANCE: "B11",
  };

  return labelMap[normalized] || normalized;
}

function hasAnswer(question: Question, answer: Answer | undefined): boolean {
  if (!answer) return false;
  const type = (question.answer_type || "").toLowerCase();

  if (type === "number" || type === "numeric") {
    return Number.isFinite(answer.value_numeric ?? NaN);
  }

  if (type === "date") {
    return Boolean(answer.value_date);
  }

  if (answer.value_text === null || answer.value_text === undefined) {
    return false;
  }

  const textValue = answer.value_text.toString();
  return textValue.trim() !== "";
}

function isNA(questionId: string, naQuestionIds: Set<string>): boolean {
  return naQuestionIds.has(questionId);
}

// ============================================================================
// Main Export
// ============================================================================

export async function getDashboardData(
  companyId: string | undefined,
  options?: { debug?: boolean }
): Promise<DashboardData> {
  try {
    const supabase = await createClient();
    const debugEnabled = Boolean(options?.debug);

    // Get authenticated user
    const { data: { user }, error: userError } = await supabase.auth.getUser();
    if (userError || !user) {
      throw new Error("User not authenticated");
    }

    // ============================================================================
    // 0) Fetch user's accessible companies via company_member
    // ============================================================================
    const { data: memberRecords, error: memberError } = await supabase
      .from("company_member")
      .select("company_id, company:company_id (id, name)")
      .eq("user_id", user.id);

    if (memberError) {
      console.error("[DASHBOARD] fetch company_member failed", {
        code: memberError.code,
        message: memberError.message,
        details: memberError.details,
        hint: memberError.hint,
      });
      throw memberError;
    }

    const companies =
      memberRecords
        ?.map((m: any) => m.company)
        .filter(Boolean)
        .map((c: any) => ({ id: c.id, name: c.name })) ?? [];

    console.log("[DASHBOARD] requested companyId:", companyId);
    console.log("[DASHBOARD] companies:", companies.map(c => ({ id: c.id, name: c.name })));

    // Strict company validation: match on id
    const activeCompanyId = companyId && companies.some(c => c.id === companyId)
      ? companyId
      : companies[0]?.id;
    
    const activeCompany = companies.find(c => c.id === activeCompanyId) || null;

    if (!activeCompany) {
      console.error("[DASHBOARD] No accessible companies found for user", user.id);
      throw new Error("No accessible companies found");
    }

    console.log("[DASHBOARD] active_company_id:", activeCompanyId, "name:", activeCompany.name);

    // ============================================================================
    // 1) Fetch all reports for the company
    // ============================================================================

    const reportSelectCols = "id, reporting_year, status, created_at, framework, company_id";
    console.log("[DASHBOARD] Fetching reports with columns:", reportSelectCols);
    const { data: reports, error: reportsError } = await supabase
      .from("report")
      .select(reportSelectCols)
      .eq("company_id", activeCompanyId)
      .order("created_at", { ascending: false });

    if (reportsError) {
      console.error("[DASHBOARD] fetch reports failed", {
        code: reportsError.code,
        message: reportsError.message,
        details: reportsError.details,
        hint: reportsError.hint,
      });
      throw reportsError;
    }

    let can_create_new_report = false;
    if (!reports || reports.length === 0) {
      can_create_new_report = true;
      console.log("[DASHBOARD] No reports found for company", activeCompanyId);
      const debug = debugEnabled
        ? {
            questionsCount: 0,
            answersCount: 0,
            answeredApplicable: 0,
            naCount: 0,
            missingCount: 0,
            completionPercent: 0,
            active_company_id: activeCompanyId,
            activeCompanyName: activeCompany.name,
            activeReportCompanyId: "N/A",
          }
        : undefined;

      return {
        companies,
        active_company_id: activeCompanyId,
        activeCompany,
        activeReport: null,
        completionPercent: 0,
        naCount: 0,
        lastEditedAt: new Date().toISOString(),
        topics: [],
        recommendedTopic: null,
        recommendedAction: null,
        can_create_new_report,
        debug,
      };
    }

    console.log("[DASHBOARD] Found", reports.length, "reports");

    // ============================================================================
    // 2) Select active report
    // ============================================================================

    const nonPublishedReports = reports.filter((r: any) => !isPublishedStatus(r.status));
    const activeReport = nonPublishedReports[0] || reports[0];
    // Can create new report if all reports are published (no drafts/in-progress)
    can_create_new_report = reports.every((r: any) => isPublishedStatus(r.status));

    if (debugEnabled) {
      console.log("[DASHBOARD] activeReport", { id: activeReport.id, framework: activeReport.framework, company_id: activeReport.company_id });
    }

    const activeReportView = {
      id: activeReport.id,
      year: activeReport.reporting_year,
      status: activeReport.status,
      created_at: activeReport.created_at,
      continue_section_code: null, // This is from RPC, not report table
    };

    // ============================================================================
    // 3) Fetch questions in scope using RPC
    // ============================================================================

    console.log("[DASHBOARD] Calling RPC get_vsme_questions_for_report");
    const { data: rpcData, error: questionsError } = await supabase.rpc(
      "get_vsme_questions_for_report",
      {
        p_report_id: activeReport.id,
      }
    );

    if (questionsError) {
      console.error("[DASHBOARD] RPC get_vsme_questions_for_report failed", {
        code: questionsError.code,
        message: questionsError.message,
        details: questionsError.details,
        hint: questionsError.hint,
      });
      throw questionsError;
    }

    if (debugEnabled) {
      console.log("[DASHBOARD] rpc count", Array.isArray(rpcData) ? rpcData.length : rpcData);
      console.log("[DASHBOARD] rpc sample keys", rpcData?.[0] ? Object.keys(rpcData[0]) : null);
      console.log("[DASHBOARD] rpc sample", rpcData?.[0]);
    }

    const questionsInScope: Question[] = (rpcData ?? [])
      .map((row: any) => {
        const questionId = row?.id ?? row?.disclosure_question_id ?? row?.question_id;
        const sectionCode = normalizeSectionCode(row?.section_code ?? row?.section);
        const answerType = normalizeAnswerType(row?.value_type ?? row?.answer_type);

        return {
          question_id: questionId,
          section_code: sectionCode,
          answer_type: answerType,
          order_index: row?.order_index ?? undefined,
          value_text: row?.value_text ?? null,
          value_numeric: row?.value_numeric ?? null,
          value_date: row?.value_date ?? null,
          value_jsonb: row?.value_jsonb ?? null,
          updated_at: row?.updated_at ?? null,
        };
      })
      .filter((q: Question) => Boolean(q.question_id) && Boolean(q.section_code));

    if (debugEnabled) {
      console.log("[DASHBOARD] questionsInScope", questionsInScope.length, questionsInScope[0]);
    }

    const questions = questionsInScope;

    if (questionsInScope.length === 0) {
      console.log("[DASHBOARD] No questions found for report");
      const debug = debugEnabled
        ? {
            questionsCount: 0,
            answersCount: 0,
            answeredApplicable: 0,
            naCount: 0,
            missingCount: 0,
            completionPercent: 0,
            active_company_id: activeCompanyId,
            activeCompanyName: activeCompany.name,
            activeReportCompanyId: activeReport.company_id,
          }
        : undefined;

      return {
        companies,
        active_company_id: activeCompanyId,
        activeCompany,
        activeReport: activeReportView,
        completionPercent: 0,
        naCount: 0,
        lastEditedAt: activeReport.created_at,
        topics: [],
        recommendedTopic: null,
        recommendedAction: null,
        debug,
      };
    }

    console.log("[DASHBOARD] Found", questionsInScope.length, "questions");

    // ============================================================================
    // 4) Fetch answers
    // ============================================================================

    const answerSelectCols = "question_id, value_text, value_numeric, value_date";
    console.log("[DASHBOARD] Fetching answers with columns:", answerSelectCols);
    const { data: answers, error: answersError } = await supabase
      .from("disclosure_answer")
      .select(answerSelectCols)
      .eq("report_id", activeReport.id);

    if (answersError) {
      console.error("[DASHBOARD] fetch answers failed", {
        code: answersError.code,
        message: answersError.message,
        details: answersError.details,
        hint: answersError.hint,
      });
      throw answersError;
    }

    console.log("[DASHBOARD] Found", answers?.length || 0, "answers");

    const { data: naRows, error: naError } = await supabase
      .from("disclosure_answer")
      .select("question_id")
      .eq("report_id", activeReport.id)
      .filter("value_jsonb->>na", "eq", "true");

    if (naError) {
      console.error("[DASHBOARD] fetch NA answers failed", {
        code: naError.code,
        message: naError.message,
        details: naError.details,
        hint: naError.hint,
      });
      throw naError;
    }

    const naQuestionIds = new Set<string>((naRows || []).map((row: any) => row.question_id));

    const answerMap = new Map<string, Answer>();
    if (answers) {
      for (const ans of answers) {
        answerMap.set(ans.question_id, ans);
      }
    }

    // ============================================================================
    // 5) Compute question states and metrics
    // ============================================================================

    let naCount = 0;
    let answeredCount = 0;
    let missingCount = 0;
    let lastEditedAt = activeReport.created_at;

    for (const q of questions) {
      const answer = answerMap.get(q.question_id);

      if (isNA(q.question_id, naQuestionIds)) {
        naCount++;
      } else if (hasAnswer(q, answer)) {
        answeredCount++;
        if (q.updated_at && q.updated_at > lastEditedAt) {
          lastEditedAt = q.updated_at;
        }
      } else {
        missingCount++;
      }
    }

    console.log("[DASHBOARD] Metrics:", { naCount, answeredCount, missingCount });

    const totalQuestions = questions.length;
    const applicableQuestions = Math.max(0, totalQuestions - naCount);
    const completionPercent =
      applicableQuestions > 0 ? Math.round((answeredCount / applicableQuestions) * 100) : 0;

    if (debugEnabled) {
      console.log("[DASHBOARD] debug counts", {
        questionsInScope: questions.length,
        answers: answers?.length || 0,
        answered_applicable: answeredCount,
        na_count: naCount,
        missing_count: missingCount,
        completion_pct: completionPercent,
      });
    }

  // ============================================================================
  // 6) Compute topic aggregation
  // ============================================================================

  const topicMap = new Map<TopicKey, { total: number; missing: number; sections: Set<string> }>();

  for (const key of Object.keys(TOPIC_TITLES) as TopicKey[]) {
    topicMap.set(key, { total: 0, missing: 0, sections: new Set() });
  }

  for (const q of questions) {
    const topicKey = SECTION_TO_TOPIC[q.section_code];
    if (!topicKey) {
      console.warn("[DASHBOARD] Unknown section_code:", q.section_code);
      continue;
    }

    const topic = topicMap.get(topicKey)!;
    topic.total++;
    topic.sections.add(q.section_code);

    const answer = answerMap.get(q.question_id);
    if (!isNA(q.question_id, naQuestionIds) && !hasAnswer(q, answer)) {
      topic.missing++;
    }
  }

  if (debugEnabled) {
    console.log("[DASHBOARD] Topic map:", Array.from(topicMap.entries()).map(([key, val]) => ({
      key,
      total: val.total,
      missing: val.missing,
      sections: Array.from(val.sections),
    })));
  }

  const topics: TopicProgress[] = Array.from(topicMap.entries()).map(([key, topic]) => {
    const percent = topic.total > 0 ? Math.round(((topic.total - topic.missing) / topic.total) * 100) : 0;
    const status: "Complete" | "In progress" | "Not started" = percent === 100 ? "Complete" : topic.missing === topic.total ? "Not started" : "In progress";
    
    return {
      key,
      title: TOPIC_TITLES[key],
      totalQuestions: topic.total,
      missing: topic.missing,
      completionPercent: percent,
      status,
    };
  });

  // ============================================================================
  // 7) Compute recommended topic
  // ============================================================================

  let recommendedTopic: TopicKey | null = null;
  let recommendedAction: "continue" | "export" | null = null;

  if (completionPercent === 100) {
    recommendedAction = "export";
  } else {
    recommendedAction = "continue";

    // Note: continue_section_code is not a report table column
    // It comes from get_vsme_ctas_for_report RPC
    // For now, skip that check and use fallback logic

    // Fallback: find first missing question in section order (B1..B11)
    // Sort questions by order_index within each section
    for (const sectionCode of SECTION_ORDER) {
      const sectionQuestions = questions
        .filter((q: Question) => q.section_code === sectionCode)
        .sort((a: Question, b: Question) => (a.order_index || 0) - (b.order_index || 0));
      
      for (const q of sectionQuestions) {
        const answer = answerMap.get(q.question_id);
        if (!isNA(q.question_id, naQuestionIds) && !hasAnswer(q, answer)) {
          recommendedTopic = SECTION_TO_TOPIC[sectionCode];
          break;
        }
      }
      if (recommendedTopic) break;
    }

    // Final fallback: recommend first incomplete topic
    if (!recommendedTopic) {
      const incompleteTopic = topics.find((t) => t.status !== "Complete");
      recommendedTopic = incompleteTopic?.key ?? null;
    }
  }

  console.log("[DASHBOARD] Recommended:", { recommendedTopic, recommendedAction });

  // ============================================================================
  // 8) Return dashboard data
  // ============================================================================

    const debug = debugEnabled
      ? {
          questionsCount: questions.length,
          answersCount: answers?.length || 0,
          answeredApplicable: answeredCount,
          naCount,
          missingCount,
          completionPercent,
          active_company_id: activeCompanyId,
          activeCompanyName: activeCompany.name,
          activeReportCompanyId: activeReport.company_id,
        }
      : undefined;

    return {
      companies,
      active_company_id: activeCompanyId,
      activeCompany,
      activeReport: activeReportView,
      completionPercent,
      naCount,
      lastEditedAt,
      topics,
      recommendedTopic,
      recommendedAction,
      can_create_new_report,
      debug,
    };
  } catch (error: any) {
    console.error("[DASHBOARD] getDashboardData failed:", {
      error,
      message: error?.message,
      code: error?.code,
      details: error?.details,
      hint: error?.hint,
    });
    throw error;
  }
}
