import React from "react";
import Link from "next/link";

// Hardened shared layout constants for perfect alignment
const ROW_GRID = "grid grid-cols-[1fr_140px_32px] items-center gap-3";
const ROW_PAD = "px-4 py-2";
const PROGRESS_WRAP = "w-[140px] grid grid-cols-[80px_48px] items-center justify-end gap-2";
const XY_CELL_GROUP = "text-right font-mono text-sm font-medium text-gray-700 tabular-nums";
const XY_CELL_SECTION = "text-right font-mono text-sm text-gray-600 tabular-nums";
const PCT_CELL = "text-right text-xs text-gray-400 opacity-80 tabular-nums";
const CHEVRON_CELL = "w-[32px]";

interface Section {
  code: string;
  title: string;
  answered: number;
  total: number;
}

interface GroupStat {
  group: string;
  sections: Section[];
}

interface GroupSummary {
  group: string;
  total: number;
  answered: number;
  percent: number;
  firstSectionCode: string | null;
  sections: Section[];
}

interface VsmeSectionsNavProps {
  locale: string;
  reportId: string;
  groupedSections: GroupStat[];
  groupSummary: GroupSummary[];
  currentSectionCode?: string | null;
  defaultExpanded?: boolean;
  showCollapseControls?: boolean;
}

const VsmeSectionsNav: React.FC<VsmeSectionsNavProps> = ({
  locale,
  reportId,
  groupedSections,
  groupSummary,
  currentSectionCode,
  defaultExpanded = false,
  showCollapseControls = true,
}) => {
  // For now, all groups are expanded if defaultExpanded is true
  // Collapse controls are shown if showCollapseControls is true
  // This is a stateless version; stateful expand/collapse logic can be added if needed

  return (
    <div className="mt-4 space-y-4">
      {groupedSections.map((groupStat) => (
        <div key={groupStat.group}>
          {/* Group Header */}
          <div
            className={`${ROW_GRID} ${ROW_PAD} text-xs font-semibold uppercase tracking-wide mb-2 rounded ${
              groupStat.sections.some(s => s.code === currentSectionCode)
                ? "text-blue-800 bg-blue-50 border border-blue-100"
                : "text-gray-500"
            }`}
          >
            <div className="truncate">{groupStat.group}</div>
            <div className={PROGRESS_WRAP}>
              <div className={XY_CELL_GROUP}>{(() => {
                const summary = groupSummary.find(g => g.group === groupStat.group);
                return summary ? `${summary.answered}/${summary.total}` : "";
              })()}</div>
              <div className={PCT_CELL}>{(() => {
                const summary = groupSummary.find(g => g.group === groupStat.group);
                return summary ? `${summary.percent}%` : "";
              })()}</div>
            </div>
            <div className={CHEVRON_CELL} />
          </div>
          {/* Sections List */}
          <div className="space-y-1">
            {groupStat.sections.map((section) => (
              <Link
                key={section.code}
                href={`/${locale}/reports/${reportId}/sections/${section.code}`}
                className={`${ROW_GRID} ${ROW_PAD} text-sm rounded transition-colors group ${
                  section.code === currentSectionCode
                    ? "bg-blue-100 font-semibold border border-blue-200 border-l-4 border-l-blue-500"
                    : "hover:bg-blue-50"
                }`}
              >
                <div className="truncate pl-6">
                  <span className={
                    section.code === currentSectionCode
                      ? "text-blue-900"
                      : "text-gray-700 group-hover:text-blue-700"
                  }>
                    {section.code} — {section.title}
                  </span>
                </div>
                <div className={PROGRESS_WRAP}>
                  <div className={XY_CELL_SECTION}>{section.answered}/{section.total}</div>
                  <div className={PCT_CELL}></div>
                </div>
                <div className={CHEVRON_CELL} />
              </Link>
            ))}
          </div>
        </div>
      ))}
    </div>
  );
};

export default VsmeSectionsNav;
