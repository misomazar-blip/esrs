import { redirect } from "next/navigation";
import { createSupabaseServerClient } from "@/lib/supabase/server";
import { getDashboardData } from "@/lib/vsme/dashboard/getDashboardData";
import { ActiveReportHero } from "@/components/dashboard/ActiveReportHero";
import CompanySwitcher from "@/components/dashboard/CompanySwitcher";
import ReportHistoryList from "@/components/dashboard/ReportHistoryList";
import SectionProgressList from "@/components/dashboard/SectionProgressList";

function formatLastEdited(timestamp: string): string {
  const now = new Date();
  const edited = new Date(timestamp);
  const diffMs = now.getTime() - edited.getTime();
  const diffDays = Math.max(0, Math.floor(diffMs / (1000 * 60 * 60 * 24)));

  if (diffDays === 0) return "today";
  if (diffDays === 1) return "1 day ago";
  return `${diffDays} days ago`;
}

function isPublishedStatus(status: string): boolean {
  return /publish/i.test(status);
}

type DashboardPageProps = {
  params: { locale: string };
  searchParams: Promise<Record<string, string | string[] | undefined>>;
};

export default async function DashboardPage({ params, searchParams }: DashboardPageProps) {
  const sp = await searchParams;

  // ============================================================================
  // Extract companyId from URL (source of truth)
  // ============================================================================
  const companyId = typeof sp.company === "string" ? sp.company : undefined;
  const debug = sp.debug === "1";

  const supabase = await createSupabaseServerClient();

  // ============================================================================
  // 1) Get authenticated user
  // ============================================================================
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) {
    redirect("/login");
  }

  // ============================================================================
  // 2) Fetch dashboard data
  // ============================================================================
  
  let dashboardData;
  let dashboardError: string | null = null;
  
  try {
    dashboardData = await getDashboardData(companyId, { debug });
  } catch (error: any) {
    console.error("[DASHBOARD PAGE] getDashboardData error:", error);
    dashboardError = `${error.message || "Unknown error"} (Code: ${error.code || "N/A"})`;
    if (error.hint) dashboardError += `\nHint: ${error.hint}`;
    if (error.details) dashboardError += `\nDetails: ${error.details}`;
    
    // Return fallback data
    dashboardData = {
      companies: [],
      active_company_id: "",
      activeCompany: null,
      activeReport: null,
      completionPercent: 0,
      naCount: 0,
      lastEditedAt: new Date().toISOString(),
      topics: [],
      recommendedTopic: null,
      recommendedAction: null,
      debug: debug
        ? {
            questionsCount: 0,
            answersCount: 0,
            answeredApplicable: 0,
            naCount: 0,
            missingCount: 0,
            completionPercent: 0,
            active_company_id: "",
            activeCompanyName: "",
            activeReportCompanyId: "",
          }
        : undefined,
    };
  }

  // Validate we have companies
  if (dashboardData.companies.length === 0) {
    redirect("/profile");
  }

  const activeCompany = dashboardData.activeCompany || dashboardData.companies[0];

  // ============================================================================
  // 4) Fetch all reports for history list (company-specific)
  // ============================================================================
  const { data: allReports } = await supabase
    .from("report")
    .select("reporting_year, status")
    .eq("company_id", activeCompany.id)
    .order("reporting_year", { ascending: false });

  const reportHistory =
    allReports?.map((r) => ({
      year: r.reporting_year,
      status: isPublishedStatus(r.status)
        ? ("Published" as const)
        : r.status.toLowerCase() === "submitted"
          ? ("Submitted" as const)
          : ("Draft" as const),
    })) ?? [];

  // ============================================================================
  // 5) Prepare view models
  // ============================================================================
  const activeReportView = {
    companyName: activeCompany.name,
    reportYear: dashboardData.activeReport?.year ?? new Date().getFullYear(),
    lastEdited: formatLastEdited(dashboardData.lastEditedAt),
    completionPercent: dashboardData.completionPercent,
    naCount: dashboardData.naCount,
    reportStatus: dashboardData.activeReport?.status ?? null,
    continueSectionCode: dashboardData.activeReport?.continue_section_code ?? null,
    canCreateNewReport: dashboardData.can_create_new_report,
    companyId: activeCompany.id,
  };

  const allReportsPublished =
    dashboardData.activeReport !== null && isPublishedStatus(dashboardData.activeReport.status);

  const reportId = dashboardData.activeReport?.id ?? null;

  const recommendedState = {
    allReportsPublished,
    activeReportExists: dashboardData.activeReport !== null,
    activeReportCompletionPercent: dashboardData.completionPercent,
    continueSectionCode: dashboardData.activeReport?.continue_section_code ?? null,
    recommendedTopic: dashboardData.recommendedTopic,
    recommendedAction: dashboardData.recommendedAction,
  };

  // ============================================================================
  // 6) Render dashboard
  // ============================================================================
  return (
    <div className="min-h-screen bg-slate-50">
      <div className="mx-auto flex max-w-5xl flex-col gap-6 px-4 py-8">
        {debug && (
          <div className="rounded border border-blue-300 bg-blue-50 px-3 py-2 text-xs text-blue-900">
            DEV: sp.company={String(sp.company)} | companyId={companyId ?? "(empty)"}
          </div>
        )}

        <header className="flex flex-col gap-4 md:flex-row md:items-center md:justify-between">
          <div>
            <p className="text-sm text-slate-500">VSME</p>
            <h1 className="text-3xl font-semibold text-slate-900">Dashboard</h1>
          </div>
          <CompanySwitcher companies={dashboardData.companies} activeCompanyId={dashboardData.active_company_id} />
        </header>

        {debug && dashboardError && (
          <div className="rounded-2xl border-2 border-red-300 bg-red-50 p-6">
            <h3 className="text-lg font-bold text-red-900">DEV: Dashboard Error</h3>
            <pre className="mt-2 whitespace-pre-wrap text-sm text-red-800">{dashboardError}</pre>
            <pre className="mt-3 whitespace-pre-wrap text-sm text-red-800">
              {JSON.stringify(
                {
                  questionsCount: dashboardData.debug?.questionsCount ?? 0,
                  answersCount: dashboardData.debug?.answersCount ?? 0,
                  answeredCount: dashboardData.debug?.answeredApplicable ?? 0,
                  naCount: dashboardData.debug?.naCount ?? 0,
                  missingCount: dashboardData.debug?.missingCount ?? 0,
                  completionPct: dashboardData.debug?.completionPercent ?? 0,
                },
                null,
                2
              )}
            </pre>
          </div>
        )}

        <ActiveReportHero
          companyName={activeReportView.companyName}
          reportYear={activeReportView.reportYear}
          lastEdited={activeReportView.lastEdited}
          completionPercent={activeReportView.completionPercent}
          naCount={activeReportView.naCount}
          reportId={reportId}
          reportStatus={activeReportView.reportStatus}
          continueSectionCode={activeReportView.continueSectionCode}
          canCreateNewReport={activeReportView.canCreateNewReport}
          companyId={activeReportView.companyId}
        />

        {debug && dashboardData.debug && (
          <div className="flex flex-col gap-2 rounded-xl border border-amber-200 bg-amber-50 px-4 py-3 text-xs text-amber-900">
            <div className="font-bold text-amber-950">
              URL companyId: {companyId ?? "(empty)"} • data.active_company_id: {dashboardData.debug.active_company_id}
              {companyId === dashboardData.debug.active_company_id ? " ✅ MATCH" : " ❌ MISMATCH"}
            </div>
            <div>
              Debug counts: questions={dashboardData.debug.questionsCount}, answers={dashboardData.debug.answersCount},
              answered={dashboardData.debug.answeredApplicable}, na={dashboardData.debug.naCount}, missing={dashboardData.debug.missingCount},
              completion={dashboardData.debug.completionPercent}%
            </div>
            <div className="border-t border-amber-200 pt-2">
              active_company_id=<span className="font-mono font-bold">{dashboardData.debug.active_company_id}</span>, 
              active_company_name=<span className="font-mono font-bold">{dashboardData.debug.activeCompanyName}</span>,
              active_report_company_id=<span className="font-mono font-bold">{dashboardData.debug.activeReportCompanyId}</span>
            </div>
          </div>
        )}

        <SectionProgressList
          topics={dashboardData.topics}
          reportId={reportId}
          recommendedState={recommendedState}
        />

        <section id="report-history" className="scroll-mt-24">
          <ReportHistoryList reports={reportHistory} />
        </section>
      </div>
    </div>
  );
}
