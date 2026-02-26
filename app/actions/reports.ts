"use server";

import { createSupabaseServerClient } from "@/lib/supabase/server";
import { redirect } from "next/navigation";

type Purpose = "financing" | "supply_chain" | "investor" | "voluntary";
type VsmeMode = "core" | "core_plus" | "comprehensive";

export async function createVsmeReportAction(formData: FormData) {
  const companyId = formData.get("companyId") as string;
  const locale = formData.get("locale") as string;
  const reportingYear = parseInt(formData.get("reportingYear") as string, 10);
  const purpose = formData.get("purpose") as Purpose;
  const employees = parseInt(formData.get("employees") as string, 10);
  const turnover = parseFloat(formData.get("turnover") as string);
  const assets = parseFloat(formData.get("assets") as string);

  // Validate inputs
  if (!companyId) throw new Error("Company ID is required");
  if (!reportingYear || isNaN(reportingYear)) throw new Error("Reporting year is required");
  if (!purpose || !["financing", "supply_chain", "investor", "voluntary"].includes(purpose)) {
    throw new Error("Valid purpose is required");
  }
  if (isNaN(employees) || employees < 0) throw new Error("Valid employee count is required");
  if (isNaN(turnover) || turnover < 0) throw new Error("Valid turnover is required");
  if (isNaN(assets) || assets < 0) throw new Error("Valid assets is required");

  const supabase = await createSupabaseServerClient();

  // Check authentication
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user || !user.id) {
    throw new Error("User not authenticated");
  }

  // Compute vsme_mode and vsme_pack_codes based on purpose
  let vsmeMode: VsmeMode = "core";
  let vsmePacks: string[] = [];

  switch (purpose) {
    case "financing":
      vsmeMode = "core_plus";
      vsmePacks = ["financing_common"];
      break;
    case "supply_chain":
      vsmeMode = "core_plus";
      vsmePacks = ["supply_chain_common"];
      break;
    case "investor":
      vsmeMode = "core_plus";
      vsmePacks = ["investor_dd_light"];
      break;
    case "voluntary":
      vsmeMode = "core";
      vsmePacks = [];
      break;
  }

  // Try to insert report
  const { data: report, error: reportError } = await supabase
    .from("report")
    .insert({
      company_id: companyId,
      reporting_year: reportingYear,
      framework: "VSME",
      vsme_mode: vsmeMode,
      vsme_pack_codes: vsmePacks,
    })
    .select("id")
    .single();

  let reportId: string;

  if (reportError) {
    // Handle unique constraint violation: unique(company_id, reporting_year, framework)
    if (reportError.code === "23505") {
      // Report already exists for this company/year/framework
      const { data: existing, error: selectError } = await supabase
        .from("report")
        .select("id")
        .eq("company_id", companyId)
        .eq("reporting_year", reportingYear)
        .eq("framework", "VSME")
        .single();

      if (selectError || !existing) {
        throw new Error("Report exists but could not be retrieved");
      }

      reportId = existing.id;
    } else {
      throw new Error(reportError.message || "Failed to create report");
    }
  } else {
    if (!report) throw new Error("Failed to create report");
    reportId = report.id;
  }

  // Insert disclosure answers for onboarding data
  // Using specific question IDs for employees, turnover, assets
  const answers = [
    {
      report_id: reportId,
      question_id: "5f3b2cfd-93ee-404d-828a-3a909003fdb4", // Employees
      value_number: employees,
      value_jsonb: {},
      updated_at: new Date().toISOString(),
    },
    {
      report_id: reportId,
      question_id: "55ebe1d9-3bdf-411d-b743-5c88541ad9ee", // Turnover
      value_number: turnover, // in full EUR
      value_jsonb: {},
      updated_at: new Date().toISOString(),
    },
    {
      report_id: reportId,
      question_id: "e9fa926a-c7ea-4384-9783-09f5448f7c4f", // Assets
      value_number: assets, // in full EUR
      value_jsonb: {},
      updated_at: new Date().toISOString(),
    },
  ];

  const { error: answersError } = await supabase
    .from("disclosure_answer")
    .insert(answers);

  if (answersError) {
    throw new Error(answersError.message || "Failed to save disclosure answers");
  }

  // Redirect to questions page
  redirect(`/${locale}/reports/${reportId}/questions`);
}

export async function updateVsmeReportScopeAction(formData: FormData) {
  const reportId = formData.get("reportId") as string;
  const vsmeMode = formData.get("vsmeMode") as VsmeMode;
  const vsmePackCodesRaw = formData.get("vsmePackCodes") as string;

  // Validate inputs
  if (!reportId) throw new Error("Report ID is required");
  if (!vsmeMode || !["core", "core_plus", "comprehensive"].includes(vsmeMode)) {
    throw new Error("Valid VSME mode is required");
  }

  // Parse vsmePackCodes
  let vsmePacks: string[] = [];
  try {
    if (vsmePackCodesRaw) {
      vsmePacks = JSON.parse(vsmePackCodesRaw);
    }
  } catch {
    throw new Error("Invalid vsmePackCodes format");
  }

  // Force empty packs if not core_plus
  if (vsmeMode !== "core_plus") {
    vsmePacks = [];
  }

  const supabase = await createSupabaseServerClient();

  // Check authentication
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user || !user.id) {
    throw new Error("User not authenticated");
  }

  // Update report
  const { data: updated, error: updateError } = await supabase
    .from("report")
    .update({
      vsme_mode: vsmeMode,
      vsme_pack_codes: vsmePacks,
    })
    .eq("id", reportId)
    .eq("framework", "VSME")
    .select("id, vsme_mode, vsme_pack_codes")
    .single();

  if (updateError) {
    throw new Error(updateError.message || "Failed to update report scope");
  }

  if (!updated) {
    throw new Error("Report not found or not updated");
  }

  return updated;
}
