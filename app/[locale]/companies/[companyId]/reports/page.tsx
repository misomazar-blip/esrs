"use client";

import Link from "next/link";
import { useEffect, useState } from "react";
import { useRouter, useParams } from "next/navigation";
import { useLocale } from "next-intl";
import { createSupabaseBrowserClient } from "@/lib/supabase/client";

type ReportWithProgress = {
  id: string;
  reporting_year: number;
  status: string | null;
  updated_at: string | null;
  created_at: string | null;
  totalQuestions: number;
  answeredQuestions: number;
  progressPercent: number;
  continueSection: string;
};

type Company = {
  id: string;
  name: string;
};

export default function CompanyReportsPage() {
  const params = useParams<{ companyId: string }>();
  const locale = useLocale();
  const router = useRouter();
  const supabase = createSupabaseBrowserClient();
  
  const [loading, setLoading] = useState(true);
  const [company, setCompany] = useState<Company | null>(null);
  const [reports, setReports] = useState<ReportWithProgress[]>([]);

  useEffect(() => {
    console.log("[CompanyPage] useEffect triggered with params.companyId:", params.companyId);
    loadReports();
  }, [params.companyId]);

  async function loadReports() {
    setLoading(true);

    // Check authentication
    const { data: { user } } = await supabase.auth.getUser();
    if (!user) {
      router.push(`/${locale}/login`);
      return;
    }

    // Extract companyId from route params
    const companyId = params.companyId;
    
    // DEBUG LOGS as requested
    console.log('[CompanyPage] params.companyId =', params.companyId);
    console.log('[CompanyPage] companyId used for query =', companyId);

    // Get company details
    const { data: companyData } = await supabase
      .from("company")
      .select("id, name")
      .eq("id", companyId)
      .eq("user_id", user.id)
      .single();

    if (!companyData) {
      console.log("❌ [CompanyPage] Company not found or unauthorized");
      router.push(`/${locale}/dashboard`);
      return;
    }

    console.log("✅ [CompanyPage] Company found:", companyData);
    setCompany(companyData as Company);

    const { data, error } = await supabase
      .from("report")
      .select("id,company_id,reporting_year,status,framework,created_at")
      .eq("company_id", "f73dd304-7771-4870-b9cb-bde82e4bafac")
      .eq("framework", "VSME")
      .order("created_at", { ascending: false });

    console.log("[CompanyPage] data=", data);
    console.log("[CompanyPage] error=", error);

    const reportsList = (data ?? []) as Omit<ReportWithProgress, 'totalQuestions' | 'answeredQuestions' | 'progressPercent' | 'continueSection'>[];

    // For each report, get progress and continue section
    const reportsWithProgress: ReportWithProgress[] = [];

    for (const report of reportsList) {
      // Get CTA data which includes progress info
      const { data: ctaData } = await supabase.rpc("get_vsme_ctas_for_report", {
        p_report_id: report.id,
      });

      let totalQuestions = 0;
      let answeredQuestions = 0;

      if (ctaData?.sections) {
        const sections = ctaData.sections as Array<{ total: number; answered: number }>;
        totalQuestions = sections.reduce((sum, s) => sum + s.total, 0);
        answeredQuestions = sections.reduce((sum, s) => sum + s.answered, 0);
      }

      const progressPercent = totalQuestions > 0 ? Math.round((answeredQuestions / totalQuestions) * 100) : 0;

      reportsWithProgress.push({
        ...report,
        totalQuestions,
        answeredQuestions,
        progressPercent,
        continueSection: ctaData?.continue_section_code ?? "B1",
      });
    }

    setReports(reportsWithProgress);
    setLoading(false);
  }

  const formatDate = (dateString: string | null) => {
    if (!dateString) return "—";
    return new Date(dateString).toLocaleDateString();
  };

  const getStatusBadgeColor = (status: string | null) => {
    switch (status?.toLowerCase()) {
      case "published":
        return "bg-green-100 text-green-800";
      case "submitted":
        return "bg-blue-100 text-blue-800";
      case "draft":
      default:
        return "bg-gray-100 text-gray-800";
    }
  };

  if (loading) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600 mx-auto mb-4"></div>
          <p className="text-gray-600">Loading reports...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gray-50">
      <div className="max-w-6xl mx-auto px-4 py-8">
        {/* Header */}
        <div className="mb-8">
          <Link
            href={`/${locale}/dashboard`}
            className="text-blue-600 hover:text-blue-700 text-sm mb-2 inline-block"
          >
            ← Back to Dashboard
          </Link>
          <h1 className="text-3xl font-bold text-gray-900 mb-1">{company?.name}</h1>
          <p className="text-gray-600">VSME Reports</p>
        </div>

        {/* Create New Report Button */}
        <div className="mb-6">
          <Link
            href={`/${locale}/reports/new?companyId=${params.companyId}`}
            className="inline-block px-6 py-3 bg-blue-600 text-white font-medium rounded-lg hover:bg-blue-700 transition-colors"
          >
            + Create New Report
          </Link>
        </div>

        {/* Reports Table */}
        {reports.length === 0 ? (
          <div className="bg-white rounded-lg shadow p-8 text-center">
            <p className="text-gray-600 mb-4">No VSME reports yet for this company.</p>
            <Link
              href={`/${locale}/reports/new?companyId=${params.companyId}`}
              className="inline-block px-6 py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors"
            >
              Create Your First Report
            </Link>
          </div>
        ) : (
          <div className="bg-white rounded-lg shadow overflow-hidden">
            <table className="min-w-full divide-y divide-gray-200">
              <thead className="bg-gray-50">
                <tr>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Year
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Status
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Progress
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Last Updated
                  </th>
                  <th className="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Actions
                  </th>
                </tr>
              </thead>
              <tbody className="bg-white divide-y divide-gray-200">
                {reports.map((report) => (
                  <tr key={report.id} className="hover:bg-gray-50">
                    <td className="px-6 py-4 whitespace-nowrap">
                      <div className="text-sm font-medium text-gray-900">{report.reporting_year}</div>
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap">
                      <span className={`px-2.5 py-1 inline-flex text-xs leading-5 font-semibold rounded-full ${getStatusBadgeColor(report.status)}`}>
                        {report.status || "draft"}
                      </span>
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap">
                      <div className="flex items-center">
                        <div className="flex-1 max-w-xs">
                          <div className="flex items-center gap-2">
                            <div className="flex-1 bg-gray-200 rounded-full h-2">
                              <div
                                className="bg-blue-600 h-2 rounded-full transition-all"
                                style={{ width: `${report.progressPercent}%` }}
                              />
                            </div>
                            <span className="text-sm font-medium text-gray-700 w-12 text-right">
                              {report.progressPercent}%
                            </span>
                          </div>
                          <div className="text-xs text-gray-500 mt-1">
                            {report.answeredQuestions} / {report.totalQuestions} questions
                          </div>
                        </div>
                      </div>
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                      {formatDate(report.updated_at)}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                      <div className="flex items-center justify-end gap-2">
                        <Link
                          href={`/${locale}/reports/${report.id}/sections/${report.continueSection}`}
                          className="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors"
                        >
                          Continue
                        </Link>
                        <Link
                          href={`/${locale}/reports/${report.id}/questions`}
                          className="px-4 py-2 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200 transition-colors"
                        >
                          Overview
                        </Link>
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </div>
    </div>
  );
}
