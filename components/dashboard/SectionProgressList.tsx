import Link from "next/link";

type TopicProgress = {
  key: "general" | "environmental" | "social" | "governance";
  title: string;
  totalQuestions: number;
  missing: number;
  completionPercent: number;
  status: "Complete" | "In progress" | "Not started";
};

type SectionProgressListProps = {
  topics: TopicProgress[];
  reportId?: string | null;
  recommendedState?: {
    allReportsPublished: boolean;
    activeReportExists: boolean;
    activeReportCompletionPercent: number;
    continueSectionCode: string | null;
    recommendedTopic: "general" | "environmental" | "social" | "governance" | null;
    recommendedAction: "continue" | "export" | null;
  };
};

type TopicTile = {
  key: "general" | "environmental" | "social" | "governance";
  title: string;
  sectionCodes: string[];
};

type TopicSummary = {
  key: TopicTile["key"];
  title: string;
  completionPercent: number;
  sectionsCount: number;
  missingCount: number;
  status: TopicProgress["status"];
};

const statusStyles: Record<TopicProgress["status"], string> = {
  "Complete": "rounded-full border border-emerald-100 bg-emerald-50 px-2.5 py-1 text-xs font-medium text-emerald-700",
  "In progress": "rounded-full border border-slate-200 bg-slate-50 px-2.5 py-1 text-xs font-medium text-slate-600",
  "Not started": "text-xs font-medium text-slate-400",
};

const TOPIC_TILES: TopicTile[] = [
  { key: "general", title: "General information", sectionCodes: ["B1"] },
  { key: "environmental", title: "Environmental", sectionCodes: ["B3", "B2", "B4", "B5", "B6", "B7"] },
  { key: "social", title: "Social", sectionCodes: ["B8", "B9", "B10"] },
  { key: "governance", title: "Governance", sectionCodes: ["B11"] },
];

export default function SectionProgressList({ topics, recommendedState, reportId = null }: SectionProgressListProps) {
  const SECTION_ORDER = ["B1", "B2", "B3", "B4", "B5", "B6", "B7", "B8", "B9", "B10", "B11"];

  const topicSummaries: TopicSummary[] = TOPIC_TILES.map((topic) => {
    const matched = topics.find((item) => item.key === topic.key);

    return {
      key: topic.key,
      title: matched?.title ?? topic.title,
      completionPercent: matched?.completionPercent ?? 0,
      sectionsCount: topic.sectionCodes.length,
      missingCount: matched?.missing ?? 0,
      status: matched?.status ?? "Not started",
    };
  });

  // Use recommended topic from dashboard data if provided, otherwise compute locally
  let recommendedTopic: TopicSummary | null = null;

  if (recommendedState?.recommendedTopic) {
    recommendedTopic =
      topicSummaries.find((topic) => topic.key === recommendedState.recommendedTopic) || null;
  } else {
    // Fallback: compute locally (legacy logic)
    const sectionToTopicKey: Record<string, TopicSummary["key"]> = {
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

    const firstMissingTopicKey = topicSummaries.find((topic) => topic.missingCount > 0)?.key;
    const firstMissingTopic = firstMissingTopicKey
      ? topicSummaries.find((topic) => topic.key === firstMissingTopicKey) || null
      : null;

    const fallbackRecommendedTopic = topicSummaries[0] || null;

    const continueTopicKey = recommendedState?.continueSectionCode
      ? sectionToTopicKey[recommendedState.continueSectionCode]
      : undefined;

    const continueTopic = continueTopicKey
      ? topicSummaries.find((topic) => topic.key === continueTopicKey) || null
      : null;

    recommendedTopic = continueTopic || firstMissingTopic || fallbackRecommendedTopic;
  }

  const derivedCompletion = recommendedState?.activeReportCompletionPercent ?? 0;
  const isComplete = derivedCompletion >= 100;
  const hasActiveReport = recommendedState?.activeReportExists ?? false;

  const remainingQuestions = recommendedTopic?.missingCount ?? 0;

  const recommendedSectionCode =
    recommendedState?.continueSectionCode ||
    TOPIC_TILES.find((topic) => topic.key === recommendedTopic?.key)?.sectionCodes[0] ||
    SECTION_ORDER[0];

  const continueHref = reportId
    ? `reports/${reportId}/sections/${recommendedSectionCode}`
    : null;
  const exportHref = reportId ? `reports/${reportId}` : null;
  const primaryCtaHref = isComplete ? exportHref : continueHref;

  let recommendationTitle = "Continue where you left off";
  let recommendationSubtitle = `${recommendedTopic?.title ?? "Environmental"} reporting`;
  let helperText = `${remainingQuestions} questions remaining`;
  let primaryCtaLabel = `Continue ${recommendedTopic?.title ?? "Environmental"}`;

  if (hasActiveReport && isComplete) {
    recommendationSubtitle = "Your report is complete. You can export anytime.";
    helperText = "";
    primaryCtaLabel = "Export report";
  } else if (!hasActiveReport) {
    recommendationSubtitle = "General information reporting";
    helperText = "Create the next reporting period when you're ready.";
    primaryCtaLabel = "Create new report";
  }

  return (
    <section className="rounded-3xl bg-white p-6 shadow-sm">
      <div className="mb-5">
        <h3 className="text-lg font-semibold text-slate-900">Section progress</h3>
      </div>

      {recommendedTopic && (
        <div className="mt-7 mb-4 rounded-2xl border border-slate-200 bg-slate-100 p-6 shadow-sm">
          <div className="flex items-start gap-4">
            <div className="w-1 self-stretch rounded-full bg-slate-300" />

            <div className="flex-1">
              <h4 className="mt-1 text-xl font-semibold text-slate-900">{recommendationTitle}</h4>
              <p className="mt-1 text-base font-medium text-slate-800">{recommendationSubtitle}</p>
              <p className="mt-1 text-sm text-slate-600">{helperText}</p>

              <div className="mt-4 flex flex-wrap items-center gap-3">
                {primaryCtaHref ? (
                  <Link
                    href={primaryCtaHref}
                    className="rounded-full bg-slate-900 px-5 py-2.5 text-sm font-medium text-white transition hover:bg-slate-800"
                  >
                    {primaryCtaLabel}
                  </Link>
                ) : (
                  <button
                    type="button"
                    className="rounded-full bg-slate-900 px-5 py-2.5 text-sm font-medium text-white transition hover:bg-slate-800"
                  >
                    {primaryCtaLabel}
                  </button>
                )}
              </div>
            </div>
          </div>
        </div>
      )}

      <div className="grid grid-cols-1 gap-4 md:grid-cols-2">
        {topicSummaries.map((topic) => {
          const firstSectionCode = TOPIC_TILES.find((item) => item.key === topic.key)?.sectionCodes[0];
          const topicHref = reportId && firstSectionCode ? `reports/${reportId}/sections/${firstSectionCode}` : null;

          const tileContent = (
            <>
              <div className="flex items-start justify-between gap-3">
                <div>
                  <h4 className="text-lg font-semibold text-slate-900">{topic.title}</h4>
                </div>
                <div className="flex flex-col items-end gap-2">
                  <span className="text-sm font-normal text-slate-500">{topic.completionPercent}%</span>
                  {topic.status === "Not started" ? (
                    <span className={statusStyles[topic.status]}>Not started</span>
                  ) : (
                    <span className={statusStyles[topic.status]}>{topic.status}</span>
                  )}
                </div>
              </div>

              <div>
                <div className="h-1.5 w-full rounded-full bg-slate-200">
                  <div
                    className="h-1.5 rounded-full bg-slate-700"
                    style={{ width: `${topic.completionPercent}%` }}
                  />
                </div>
                <p className="mt-2 text-xs text-slate-500">
                  {topic.sectionsCount} section{topic.sectionsCount !== 1 ? "s" : ""} • {topic.missingCount} missing
                </p>
              </div>
            </>
          );

          const tileClasses =
            "group flex w-full flex-col gap-5 rounded-2xl bg-slate-50 p-6 shadow-sm transition hover:bg-white hover:shadow-sm hover:border-slate-300 cursor-pointer";

          return topicHref ? (
            <Link key={topic.key} href={topicHref} className={tileClasses} prefetch={false}>
              {tileContent}
            </Link>
          ) : (
            <div key={topic.key} className={tileClasses + ' opacity-60 pointer-events-none'}>
              {tileContent}
            </div>
          );
        })}
      </div>
    </section>
  );
}
