import Link from "next/link";

type ActiveReport = {
  id: string;
  status?: string | null;
  reporting_year?: number | null;
  continue_section_code?: string | null;
  company_id?: string | null;
};

type Props = {
  companyName: string;
  companyId: string;
  activeReport?: ActiveReport | null;
  completionPct: number;
  naCount: number;
  lastEditedLabel: string;
  canCreateNewReport: boolean;
  continueSectionCode?: string | null;
};

export function ActiveReportHero({
  companyName,
  companyId,
  activeReport,
  completionPct,
  naCount,
  lastEditedLabel,
  canCreateNewReport,
  continueSectionCode,
}: Props) {
  const reportId = activeReport?.id;
  const status = activeReport?.status ?? "";
  const isPublished = /publish/i.test(status);

  const sectionCode = continueSectionCode ?? activeReport?.continue_section_code ?? undefined;

  const viewReportHref = reportId ? `reports/${reportId}` : undefined;
  const exportHref = reportId ? `reports/${reportId}` : undefined;
  const continueHref =
    reportId && sectionCode ? `reports/${reportId}/sections/${sectionCode}` : undefined;

  const createNewHref = canCreateNewReport ? `reports/new?companyId=${companyId}` : undefined;

  return (
    <div className="rounded-2xl border border-slate-200 bg-white p-5 shadow-sm">
      <div className="flex items-start justify-between gap-4">
        <div className="min-w-0">
          <div className="text-sm text-slate-600">
            {activeReport?.reporting_year ? `Report ${activeReport.reporting_year}` : "Report"} •{" "}
            Last edited {lastEditedLabel}
          </div>

          <div className="mt-1 truncate text-xl font-semibold text-slate-900">{companyName}</div>

          <div className="mt-3 flex flex-wrap items-center gap-3">
            <span className="inline-flex items-center rounded-full bg-emerald-50 px-3 py-1 text-sm font-medium text-emerald-800">
              {Math.round(completionPct)}% complete
            </span>
            <span className="text-sm text-slate-600">{naCount} marked as N/A</span>

            <a href="#report-history" className="text-sm text-slate-700 underline underline-offset-4">
              View all reports
            </a>
          </div>

          <div className="mt-4 h-2 w-full rounded-full bg-slate-100">
            <div
              className="h-2 rounded-full bg-emerald-500"
              style={{ width: `${Math.max(0, Math.min(100, completionPct))}%` }}
            />
          </div>
        </div>

        <div className="flex shrink-0 flex-col gap-2">
          {isPublished ? (
            viewReportHref ? (
              <Link
                href={viewReportHref}
                className="inline-flex items-center justify-center rounded-xl bg-slate-900 px-4 py-2 text-sm font-medium text-white hover:bg-slate-800"
              >
                View report
              </Link>
            ) : null
          ) : continueHref ? (
            <Link
              href={continueHref}
              className="inline-flex items-center justify-center rounded-xl bg-slate-900 px-4 py-2 text-sm font-medium text-white hover:bg-slate-800"
            >
              Continue
            </Link>
          ) : null}

          {exportHref ? (
            <Link
              href={exportHref}
              className="inline-flex items-center justify-center rounded-xl border border-slate-300 bg-white px-4 py-2 text-sm font-medium text-slate-900 hover:bg-slate-50"
            >
              Export
            </Link>
          ) : null}

          {createNewHref ? (
            <Link
              href={createNewHref}
              className="inline-flex items-center justify-center rounded-xl border border-slate-200 bg-white px-4 py-2 text-sm font-medium text-slate-700 hover:bg-slate-50"
            >
              Create new reporting period
            </Link>
          ) : null}

          {canCreateNewReport ? (
            <div className="text-xs text-slate-500">Start a new report for the next year.</div>
          ) : null}
        </div>
      </div>
    </div>
  );
}