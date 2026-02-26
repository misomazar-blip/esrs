import ActiveReportHero from "@/components/dashboard/ActiveReportHero";
import CompanySwitcher from "@/components/dashboard/CompanySwitcher";
import ReportHistoryList from "@/components/dashboard/ReportHistoryList";
import SectionProgressList from "@/components/dashboard/SectionProgressList";

const mockCompanies = [
  { id: "co-1", name: "Nordlake Furniture" },
  { id: "co-2", name: "Greenway Services" },
  { id: "co-3", name: "Atlas Craft" },
];

const activeReport = {
  companyName: "Nordlake Furniture",
  reportYear: 2025,
  lastEdited: "2 days ago",
  completionPercent: 62,
};

const sectionProgress = [
  { code: "B1", title: "Business model", status: "In progress", percent: 65, missingCount: 4 },
  { code: "B2", title: "Governance", status: "In progress", percent: 52, missingCount: 6 },
  { code: "B3", title: "Strategy", status: "Not started", percent: 0, missingCount: 9 },
  { code: "B4", title: "Policies", status: "In progress", percent: 40, missingCount: 8 },
  { code: "B5", title: "Actions", status: "Not started", percent: 0, missingCount: 7 },
  { code: "B6", title: "Targets", status: "Not started", percent: 0, missingCount: 5 },
  { code: "B7", title: "Metrics", status: "In progress", percent: 30, missingCount: 10 },
  { code: "B8", title: "Climate", status: "Complete", percent: 100, missingCount: 0 },
  { code: "B9", title: "Resources", status: "In progress", percent: 55, missingCount: 3 },
  { code: "B10", title: "People", status: "Not started", percent: 0, missingCount: 8 },
  { code: "B11", title: "Value chain", status: "In progress", percent: 45, missingCount: 5 },
];

const reportHistory = [
  { year: 2024, status: "Draft" },
  { year: 2023, status: "Submitted" },
  { year: 2022, status: "Published" },
];

export default function DashboardPage() {
  return (
    <div className="min-h-screen bg-slate-50">
      <div className="mx-auto flex max-w-5xl flex-col gap-6 px-4 py-8">
        <header className="flex flex-col gap-4 md:flex-row md:items-center md:justify-between">
          <div>
            <p className="text-sm text-slate-500">VSME</p>
            <h1 className="text-3xl font-semibold text-slate-900">Dashboard</h1>
          </div>
          <CompanySwitcher companies={mockCompanies} activeCompanyId={mockCompanies[0].id} />
        </header>

        <ActiveReportHero
          companyName={activeReport.companyName}
          reportYear={activeReport.reportYear}
          lastEdited={activeReport.lastEdited}
          completionPercent={activeReport.completionPercent}
        />

        <SectionProgressList sections={sectionProgress} />

        <ReportHistoryList reports={reportHistory} />
      </div>
    </div>
  );
}
