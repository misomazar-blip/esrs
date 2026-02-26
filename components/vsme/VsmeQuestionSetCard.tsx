"use client";

import React from "react";

const MODE_LABELS: Record<string, string> = {
  core: "Core",
  core_plus: "Core Plus",
  comprehensive: "Comprehensive",
};

export type VsmeReportHeaderCardProps = {
  companyName?: string | null;
  mode: string;
  packs?: string[];
  totalQuestions: number;
  completedQuestions: number;
  progressPct: number;
  naCount: number;
  showChangeButton?: boolean;
  onChangeClick?: () => void;
  reportingYear?: string | number;
};

export default function VsmeReportHeaderCard(props: VsmeReportHeaderCardProps) {
  const {
    companyName,
    mode,
    totalQuestions,
    completedQuestions,
    progressPct,
    naCount,
    showChangeButton = false,
    onChangeClick,
    reportingYear,
  } = props;

  // Progress bar width logic
  const progressBarPct = totalQuestions > 0 ? Math.round((completedQuestions / totalQuestions) * 100) : 0;
  const progressBarWidth = totalQuestions === 0 ? 0 : Math.max(progressBarPct, 4);

  const modeLabel = MODE_LABELS[mode] || mode;
  const isCore = mode === 'core';

  return (
    <div className="bg-white rounded-lg shadow-sm p-0">
      {/* Top accent line (blue-500) */}
      <div className="h-1 w-full rounded-t-lg bg-blue-500" />
      <div className="px-6 pt-5 pb-6 space-y-2">
        {/* Report identity row */}
        <div className="flex items-start justify-between">
          <div>
            <div className="text-xs text-gray-500">Company</div>
            <div className="text-lg font-semibold text-gray-900 truncate">
              {companyName || "Unnamed company"}
            </div>
          </div>
          {reportingYear && (
            <div className="text-right">
              <div className="text-xs text-gray-500">Year</div>
              <div className="text-sm font-semibold text-gray-800">{reportingYear}</div>
            </div>
          )}
        </div>
        {/* Divider */}
        <div className="border-t border-gray-100 my-2" />
        {/* Question set row with mode pill and change button */}
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-2">
            <span className="text-sm font-medium text-gray-700">Question set</span>
            <span className={
              isCore
                ? "px-3 py-1 bg-purple-100 text-purple-800 text-xs font-semibold rounded-full"
                : "px-3 py-1 bg-gray-100 text-gray-700 text-xs font-semibold rounded-full"
            }>
              {modeLabel}
            </span>
          </div>
          {showChangeButton && (
            <button
              type="button"
              onClick={onChangeClick}
              className="text-sm font-medium text-blue-600 hover:text-blue-700 hover:underline"
              aria-label="Change report scope (question set)"
            >
              Change question set
            </button>
          )}
        </div>
        {/* Metrics row: progress value green */}
        <div className="flex items-center gap-6 text-sm text-gray-700 mt-3">
          <div>
            Questions: <span className="font-bold text-gray-900">{totalQuestions}</span>
          </div>
          <div>
            Completed: <span className="font-bold text-gray-900">{completedQuestions}</span>
          </div>
          <div>
            Progress:
            <span className="ml-2 px-2 py-0.5 rounded-full bg-gray-100 text-green-700 text-xs font-semibold">
              {progressBarPct}%
            </span>
          </div>
        </div>
        {/* Subtle progress bar under metrics (green, min width) */}
        <div className="mt-2 h-1.5 w-full rounded-full bg-gray-100 overflow-hidden">
          <div
            className="h-full rounded-full bg-green-300"
            style={{ width: `${progressBarWidth}%` }}
          />
        </div>
        {/* NA note: improved readability */}
        {naCount > 0 && (
          <div className="mt-2 text-xs text-gray-600">
            {naCount} questions marked as Not Applicable
          </div>
        )}
      </div>
    </div>
  );
}
