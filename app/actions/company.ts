"use server";

import { createSupabaseServerClient } from "@/lib/supabase/server";

export async function createCompanyAction(data: {
  name: string;
  country_code: string;
  address?: string | null;
  city?: string | null;
  postal_code?: string | null;
  identification_number?: string | null;
  vat_number?: string | null;
  phone?: string | null;
  email?: string | null;
  website?: string | null;
  industry_code?: string | null;
  employee_count?: number | null;
  balance_sheet_total_k?: number | null;
  net_turnover_k?: number | null;
}) {
  const supabase = await createSupabaseServerClient();

  // Get authenticated user from session
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user || !user.id) {
    throw new Error("User not authenticated");
  }

  // Insert company with explicit user_id
  const { data: company, error: companyError } = await supabase
    .from("company")
    .insert({
      name: data.name.trim(),
      country_code: data.country_code.trim(),
      address: data.address?.trim() || null,
      city: data.city?.trim() || null,
      postal_code: data.postal_code?.trim() || null,
      identification_number: data.identification_number?.trim() || null,
      vat_number: data.vat_number?.trim() || null,
      phone: data.phone?.trim() || null,
      email: data.email?.trim() || null,
      website: data.website?.trim() || null,
      industry_code: data.industry_code?.trim() || null,
      employee_count: data.employee_count || null,
      balance_sheet_total_k: data.balance_sheet_total_k || null,
      net_turnover_k: data.net_turnover_k || null,
      user_id: user.id, // Explicitly set, never rely on auth.uid() in SQL
    })
    .select('id, name')
    .single();

  if (companyError) {
    throw new Error(`Failed to create company: ${companyError.message}`);
  }

  if (!company) {
    throw new Error("Company creation returned no data");
  }

  // Insert owner membership with explicitly verified user_id
  const { error: memberError } = await supabase
    .from("company_member")
    .insert({
      company_id: company.id,
      user_id: user.id, // Explicitly set, guaranteed non-null from auth check above
      role: "owner",
    });

  if (memberError) {
    // Cleanup: delete the company if membership insertion fails
    await supabase.from("company").delete().eq("id", company.id);
    throw new Error(`Failed to create company membership: ${memberError.message}`);
  }

  return {
    success: true,
    companyId: company.id,
    companyName: company.name,
  };
}
