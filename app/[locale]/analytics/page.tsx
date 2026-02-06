"use client";

import { useState, useEffect } from "react";
import { useTranslations, useLocale } from "next-intl";
import { createSupabaseBrowserClient } from "@/lib/supabase/client";
import { colors, fonts } from "@/lib/styles";
import Link from "next/link";
import {
  BarChart,
  Bar,
  PieChart,
  Pie,
  LineChart,
  Line,
  RadarChart,
  PolarGrid,
  PolarAngleAxis,
  PolarRadiusAxis,
  Radar,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  Legend,
  Cell,
  ResponsiveContainer,
} from "recharts";

type Report = {
  id: string;
  reporting_year: number;
  company_id: string;
};

type Company = {
  id: string;
  name: string;
};

type TopicStats = {
  topic_code: string;
  topic_name: string;
  total_questions: number;
  answered_questions: number;
  completion_percentage: number;
};

type YearComparison = {
  year: number;
  total_questions: number;
  answered: number;
  completion: number;
};

export default function AnalyticsPage() {
  const locale = useLocale();
  const t = useTranslations('analytics');
  const tCommon = useTranslations('common');
  const tNav = useTranslations('nav');
  const supabase = createSupabaseBrowserClient();
  const [loading, setLoading] = useState(true);
  const [company, setCompany] = useState<Company | null>(null);
  const [reports, setReports] = useState<Report[]>([]);
  const [selectedReport, setSelectedReport] = useState<string>("");
  const [topicStats, setTopicStats] = useState<TopicStats[]>([]);
  const [yearComparison, setYearComparison] = useState<YearComparison[]>([]);
  const [overallCompletion, setOverallCompletion] = useState(0);
  const [totalQuestions, setTotalQuestions] = useState(0);
  const [answeredQuestions, setAnsweredQuestions] = useState(0);
  const [materialTopicsCount, setMaterialTopicsCount] = useState(0);

  useEffect(() => {
    loadData();
  }, []);

  useEffect(() => {
    if (selectedReport) {
      loadReportAnalytics();
    }
  }, [selectedReport]);

  const loadData = async () => {
    try {
      const {
        data: { user },
      } = await supabase.auth.getUser();
      if (!user) return;

      // Load company
      const { data: companyData } = await supabase
        .from("company")
        .select("*")
        .eq("user_id", user.id)
        .single();

      if (companyData) {
        setCompany(companyData);

        // Load reports
        const { data: reportsData } = await supabase
          .from("report")
          .select("*")
          .eq("company_id", companyData.id)
          .order("reporting_year", { ascending: false });

        if (reportsData && reportsData.length > 0) {
          setReports(reportsData);
          setSelectedReport(reportsData[0].id);
          
          // Load year comparison data
          await loadYearComparison(companyData.id, reportsData);
        }
      }
    } catch (error) {
      console.error("Error loading data:", error);
    } finally {
      setLoading(false);
    }
  };

  const loadYearComparison = async (companyId: string, allReports: Report[]) => {
    try {
      const yearData: YearComparison[] = [];

      for (const report of allReports) {
        // Get material topics for this report
        const { data: materialTopics } = await supabase
          .from("report_topic")
          .select("topic_id")
          .eq("report_id", report.id)
          .eq("is_material", true);

        if (!materialTopics || materialTopics.length === 0) continue;

        const topicIds = materialTopics.map((t: any) => t.topic_id);

        // Get all questions for material topics
        const { data: questions } = await supabase
          .from("disclosure_question")
          .select("id")
          .in("topic_id", topicIds);

        if (!questions) continue;

        const questionIds = questions.map((q) => q.id);

        // Get answered questions
        const { data: answers } = await supabase
          .from("answer")
          .select("question_id")
          .eq("report_id", report.id)
          .in("question_id", questionIds)
          .not("answer_text", "is", null)
          .neq("answer_text", "");

        const totalQ = questions.length;
        const answeredQ = answers?.length || 0;
        const completion = totalQ > 0 ? Math.round((answeredQ / totalQ) * 100) : 0;

        yearData.push({
          year: report.reporting_year,
          total_questions: totalQ,
          answered: answeredQ,
          completion,
        });
      }

      setYearComparison(yearData.sort((a, b) => a.year - b.year));
    } catch (error) {
      console.error("Error loading year comparison:", error);
    }
  };

  const loadReportAnalytics = async () => {
    try {
      // Get material topics for selected report
      const { data: materialTopics } = await supabase
        .from("report_topic")
        .select(`
          topic_id,
          disclosure_topic (
            code,
            name
          )
        `)
        .eq("report_id", selectedReport)
        .eq("is_material", true);

      if (!materialTopics || materialTopics.length === 0) {
        setTopicStats([]);
        setOverallCompletion(0);
        return;
      }

      setMaterialTopicsCount(materialTopics.length);

      const stats: TopicStats[] = [];
      let totalQ = 0;
      let totalAnswered = 0;

      for (const mt of materialTopics) {
        const topic = (mt as any).disclosure_topic;
        if (!topic) continue;

        // Get questions for this topic
        const { data: questions } = await supabase
          .from("disclosure_question")
          .select("id")
          .eq("topic_id", mt.topic_id);

        if (!questions || questions.length === 0) continue;

        const questionIds = questions.map((q) => q.id);

        // Get answers
        const { data: answers } = await supabase
          .from("answer")
          .select("question_id")
          .eq("report_id", selectedReport)
          .in("question_id", questionIds)
          .not("answer_text", "is", null)
          .neq("answer_text", "");

        const total = questions.length;
        const answered = answers?.length || 0;
        const completion = total > 0 ? Math.round((answered / total) * 100) : 0;

        stats.push({
          topic_code: topic.code,
          topic_name: topic.name,
          total_questions: total,
          answered_questions: answered,
          completion_percentage: completion,
        });

        totalQ += total;
        totalAnswered += answered;
      }

      setTopicStats(stats.sort((a, b) => a.topic_code.localeCompare(b.topic_code)));
      setTotalQuestions(totalQ);
      setAnsweredQuestions(totalAnswered);
      setOverallCompletion(totalQ > 0 ? Math.round((totalAnswered / totalQ) * 100) : 0);
    } catch (error) {
      console.error("Error loading report analytics:", error);
    }
  };

  const COLORS = [
    colors.primary,
    colors.info,
    "#10b981",
    "#f59e0b",
    "#8b5cf6",
    "#ec4899",
    "#06b6d4",
    "#f97316",
  ];

  if (loading) {
    return (
      <div style={{ padding: "2rem", textAlign: "center" }}>
        <p style={{ fontSize: fonts.size.lg }}>{tCommon('loading')}</p>
      </div>
    );
  }

  if (!company || reports.length === 0) {
    return (
      <div style={{ padding: "2rem", textAlign: "center" }}>
        <h2 style={{ fontSize: fonts.size.h2, marginBottom: "1rem" }}>
          {t('title')}
        </h2>
        <p style={{ fontSize: fonts.size.body, marginBottom: "1.5rem" }}>
          {/* Create a report to view analytics */}
        </p>
        <Link
          href={`/${locale}/report`}
          style={{
            display: "inline-block",
            padding: "0.75rem 1.5rem",
            backgroundColor: colors.primary,
            color: "#fff",
            borderRadius: "0.5rem",
            textDecoration: "none",
            fontSize: fonts.size.body,
          }}
        >
          {tNav('reports')}
        </Link>
      </div>
    );
  }

  const selectedReportData = reports.find((r) => r.id === selectedReport);

  return (
    <div style={{ padding: "2rem", maxWidth: "1400px", margin: "0 auto" }}>
      {/* Header */}
      <div style={{ marginBottom: "2rem" }}>
        <h1 style={{ fontSize: fonts.size.h1, marginBottom: "0.5rem" }}>
          📊 {t('title')}
        </h1>
        <p style={{ fontSize: fonts.size.body, color: colors.textSecondary }}>
          {company.name}
        </p>
      </div>

      {/* Report Selector */}
      <div style={{ marginBottom: "2rem" }}>
        <label
          htmlFor="reportSelect"
          style={{
            display: "block",
            fontSize: fonts.size.body,
            marginBottom: "0.5rem",
            fontWeight: 600,
          }}
        >
          Select Report:
        </label>
        <select
          id="reportSelect"
          value={selectedReport}
          onChange={(e) => setSelectedReport(e.target.value)}
          style={{
            padding: "0.75rem",
            fontSize: fonts.size.body,
            borderRadius: "0.5rem",
            border: `1px solid ${colors.borderGray}`,
            minWidth: "250px",
          }}
        >
          {reports.map((report) => (
            <option key={report.id} value={report.id}>
              Reporting Year {report.reporting_year}
            </option>
          ))}
        </select>
      </div>

      {/* Overall Stats Cards */}
      <div
        style={{
          display: "grid",
          gridTemplateColumns: "repeat(auto-fit, minmax(200px, 1fr))",
          gap: "1rem",
          marginBottom: "2rem",
        }}
      >
        <StatCard
          title="Overall Completion"
          value={`${overallCompletion}%`}
          color={colors.primary}
        />
        <StatCard
          title="Total Questions"
          value={totalQuestions.toString()}
          color={colors.info}
        />
        <StatCard
          title="Answered"
          value={answeredQuestions.toString()}
          color="#10b981"
        />
        <StatCard
          title="Material Topics"
          value={materialTopicsCount.toString()}
          color="#8b5cf6"
        />
      </div>

      {/* Charts Grid */}
      <div style={{ display: "grid", gap: "2rem" }}>
        {/* Topic Completion Bar Chart */}
        {topicStats.length > 0 && (
          <div
            style={{
              backgroundColor: "#fff",
              padding: "1.5rem",
              borderRadius: "0.75rem",
              border: `1px solid ${colors.borderGray}`,
            }}
          >
            <h3
              style={{
                fontSize: fonts.size.h3,
                marginBottom: "1rem",
                fontWeight: 600,
              }}
            >
              Completion by Topic
            </h3>
            <ResponsiveContainer width="100%" height={400}>
              <BarChart data={topicStats}>
                <CartesianGrid strokeDasharray="3 3" />
                <XAxis
                  dataKey="topic_code"
                  style={{ fontSize: "12px" }}
                  angle={-45}
                  textAnchor="end"
                  height={100}
                />
                <YAxis />
                <Tooltip
                  content={({ active, payload }) => {
                    if (active && payload && payload.length) {
                      const data = payload[0].payload as TopicStats;
                      return (
                        <div
                          style={{
                            backgroundColor: "#fff",
                            padding: "1rem",
                            border: `1px solid ${colors.borderGray}`,
                            borderRadius: "0.5rem",
                          }}
                        >
                          <p style={{ fontWeight: 600, marginBottom: "0.5rem" }}>
                            {data.topic_code}
                          </p>
                          <p style={{ fontSize: "0.875rem", marginBottom: "0.25rem" }}>
                            {data.topic_name}
                          </p>
                          <p style={{ fontSize: "0.875rem" }}>
                            Completion: {data.completion_percentage}%
                          </p>
                          <p style={{ fontSize: "0.875rem" }}>
                            {data.answered_questions}/{data.total_questions} questions
                          </p>
                        </div>
                      );
                    }
                    return null;
                  }}
                />
                <Bar dataKey="completion_percentage" fill={colors.primary} />
              </BarChart>
            </ResponsiveContainer>
          </div>
        )}

        {/* Two Column Layout */}
        <div
          style={{
            display: "grid",
            gridTemplateColumns: "repeat(auto-fit, minmax(400px, 1fr))",
            gap: "2rem",
          }}
        >
          {/* Topic Distribution Pie Chart */}
          {topicStats.length > 0 && (
            <div
              style={{
                backgroundColor: "#fff",
                padding: "1.5rem",
                borderRadius: "0.75rem",
                border: `1px solid ${colors.borderGray}`,
              }}
            >
              <h3
                style={{
                  fontSize: fonts.size.h3,
                  marginBottom: "1rem",
                  fontWeight: 600,
                }}
              >
                Questions Distribution
              </h3>
              <ResponsiveContainer width="100%" height={350}>
                <PieChart>
                  <Pie
                    data={topicStats}
                    dataKey="total_questions"
                    nameKey="topic_code"
                    cx="50%"
                    cy="50%"
                    outerRadius={100}
                    label={(entry: any) => `${entry.topic_code} (${entry.total_questions})`}
                  >
                    {topicStats.map((entry, index) => (
                      <Cell key={`cell-${index}`} fill={COLORS[index % COLORS.length]} />
                    ))}
                  </Pie>
                  <Tooltip />
                </PieChart>
              </ResponsiveContainer>
            </div>
          )}

          {/* Radar Chart - Topic Completion */}
          {topicStats.length > 0 && (
            <div
              style={{
                backgroundColor: "#fff",
                padding: "1.5rem",
                borderRadius: "0.75rem",
                border: `1px solid ${colors.borderGray}`,
              }}
            >
              <h3
                style={{
                  fontSize: fonts.size.h3,
                  marginBottom: "1rem",
                  fontWeight: 600,
                }}
              >
                Completion Radar
              </h3>
              <ResponsiveContainer width="100%" height={350}>
                <RadarChart data={topicStats.slice(0, 8)}>
                  <PolarGrid />
                  <PolarAngleAxis dataKey="topic_code" style={{ fontSize: "12px" }} />
                  <PolarRadiusAxis angle={90} domain={[0, 100]} />
                  <Radar
                    name="Completion %"
                    dataKey="completion_percentage"
                    stroke={colors.primary}
                    fill={colors.primary}
                    fillOpacity={0.6}
                  />
                  <Tooltip />
                </RadarChart>
              </ResponsiveContainer>
            </div>
          )}
        </div>

        {/* Year-over-Year Comparison */}
        {yearComparison.length > 1 && (
          <div
            style={{
              backgroundColor: "#fff",
              padding: "1.5rem",
              borderRadius: "0.75rem",
              border: `1px solid ${colors.borderGray}`,
            }}
          >
            <h3
              style={{
                fontSize: fonts.size.h3,
                marginBottom: "1rem",
                fontWeight: 600,
              }}
            >
              Year-over-Year Progress
            </h3>
            <ResponsiveContainer width="100%" height={350}>
              <LineChart data={yearComparison}>
                <CartesianGrid strokeDasharray="3 3" />
                <XAxis dataKey="year" />
                <YAxis yAxisId="left" />
                <YAxis yAxisId="right" orientation="right" />
                <Tooltip
                  content={({ active, payload }) => {
                    if (active && payload && payload.length) {
                      const data = payload[0].payload as YearComparison;
                      return (
                        <div
                          style={{
                            backgroundColor: "#fff",
                            padding: "1rem",
                            border: `1px solid ${colors.borderGray}`,
                            borderRadius: "0.5rem",
                          }}
                        >
                          <p style={{ fontWeight: 600, marginBottom: "0.5rem" }}>
                            Year {data.year}
                          </p>
                          <p style={{ fontSize: "0.875rem" }}>
                            Completion: {data.completion}%
                          </p>
                          <p style={{ fontSize: "0.875rem" }}>
                            Answered: {data.answered}/{data.total_questions}
                          </p>
                        </div>
                      );
                    }
                    return null;
                  }}
                />
                <Legend />
                <Line
                  yAxisId="left"
                  type="monotone"
                  dataKey="completion"
                  stroke={colors.primary}
                  strokeWidth={2}
                  name="Completion %"
                />
                <Line
                  yAxisId="right"
                  type="monotone"
                  dataKey="answered"
                  stroke={colors.info}
                  strokeWidth={2}
                  name="Answered Questions"
                />
              </LineChart>
            </ResponsiveContainer>
          </div>
        )}
      </div>

      {/* Action Buttons */}
      <div
        style={{
          marginTop: "2rem",
          display: "flex",
          gap: "1rem",
          justifyContent: "center",
        }}
      >
        <Link
          href={`/${locale}/report`}
          style={{
            padding: "0.75rem 1.5rem",
            backgroundColor: colors.primary,
            color: "#fff",
            borderRadius: "0.5rem",
            textDecoration: "none",
            fontSize: fonts.size.body,
          }}
        >
          Go to Reports
        </Link>
        <Link
          href={`/${locale}/topics/${topicStats[0]?.topic_code || ""}`}
          style={{
            padding: "0.75rem 1.5rem",
            backgroundColor: colors.info,
            color: "#fff",
            borderRadius: "0.5rem",
            textDecoration: "none",
            fontSize: fonts.size.body,
          }}
        >
          Start Questionnaire
        </Link>
      </div>
    </div>
  );
}

function StatCard({
  title,
  value,
  color,
}: {
  title: string;
  value: string;
  color: string;
}) {
  return (
    <div
      style={{
        backgroundColor: "#fff",
        padding: "1.5rem",
        borderRadius: "0.75rem",
        border: `1px solid ${colors.borderGray}`,
        textAlign: "center",
      }}
    >
      <p
        style={{
          fontSize: fonts.size.body,
          color: colors.textSecondary,
          marginBottom: "0.5rem",
        }}
      >
        {title}
      </p>
      <p style={{ fontSize: fonts.size.h2, fontWeight: 700, color }}>{value}</p>
    </div>
  );
}
