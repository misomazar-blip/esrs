type ReportHistoryItem = {
  year: number;
  status: "Draft" | "Submitted" | "Published";
};

type ReportHistoryListProps = {
  reports: ReportHistoryItem[];
};

const statusStyles: Record<ReportHistoryItem["status"], string> = {
  Draft: "bg-slate-100 text-slate-600",
  Submitted: "bg-blue-100 text-blue-700",
  Published: "bg-emerald-100 text-emerald-700",
};

export default function ReportHistoryList({ reports }: ReportHistoryListProps) {
  return (
    <section className="rounded-3xl border border-slate-200 bg-white p-6 shadow-sm">
      <h3 className="text-lg font-semibold text-slate-900">Report history</h3>
      <div className="mt-4 space-y-2">
        {reports.map((report) => (
          <div
            key={report.year}
            className="flex items-center justify-between rounded-2xl border border-slate-100 bg-slate-50 px-4 py-3"
          >
            <div className="text-sm font-medium text-slate-800">{report.year}</div>
            <span className={`rounded-full px-3 py-1 text-xs font-medium ${statusStyles[report.status]}`}>
              {report.status}
            </span>
          </div>
        ))}
      </div>
    </section>
  );
}
