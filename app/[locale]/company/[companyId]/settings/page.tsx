"use client";

import { useEffect, useState } from "react";
import { useParams, useRouter } from "next/navigation";
import { useTranslations, useLocale } from "next-intl";
import { createSupabaseBrowserClient } from "@/lib/supabase/client";
import { colors, buttonStyles, inputStyles, cardStyles, fonts, spacing } from "@/lib/styles";
import Link from "next/link";

type Company = {
  id: string;
  name: string;
  country_code: string | null;
  industry_code: string | null;
  address: string | null;
  city: string | null;
  postal_code: string | null;
  identification_number: string | null;
  vat_number: string | null;
  phone: string | null;
  email: string | null;
  website: string | null;
  employee_count: number | null;
  balance_sheet_total_k: number | null;
  net_turnover_k: number | null;
};

export default function CompanySettingsPage() {
  const params = useParams();
  const router = useRouter();
  const locale = useLocale();
  const t = useTranslations('common');
  const supabase = createSupabaseBrowserClient();

  const companyId = params.companyId as string;
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [company, setCompany] = useState<Company | null>(null);
  const [msg, setMsg] = useState<{ type: "success" | "error"; text: string } | null>(null);

  // Form fields
  const [name, setName] = useState("");
  const [countryCode, setCountryCode] = useState("");
  const [industryCode, setIndustryCode] = useState("");
  const [address, setAddress] = useState("");
  const [city, setCity] = useState("");
  const [postalCode, setPostalCode] = useState("");
  const [idNumber, setIdNumber] = useState("");
  const [vatNumber, setVatNumber] = useState("");
  const [phone, setPhone] = useState("");
  const [email, setEmail] = useState("");
  const [website, setWebsite] = useState("");
  const [employeeCount, setEmployeeCount] = useState("");
  const [balanceSheet, setBalanceSheet] = useState("");
  const [netTurnover, setNetTurnover] = useState("");

  useEffect(() => {
    loadCompany();
  }, [companyId]);

  async function loadCompany() {
    const { data: { user } } = await supabase.auth.getUser();
    if (!user) {
      router.push(`/${locale}/login`);
      return;
    }

    const { data, error } = await supabase
      .from("company")
      .select("*")
      .eq("id", companyId)
      .eq("user_id", user.id)
      .maybeSingle();

    if (error || !data) {
      setMsg({ type: "error", text: "Company not found or access denied" });
      setLoading(false);
      return;
    }

    const comp = data as Company;
    setCompany(comp);
    setName(comp.name);
    setCountryCode(comp.country_code || "");
    setIndustryCode(comp.industry_code || "");
    setAddress(comp.address || "");
    setCity(comp.city || "");
    setPostalCode(comp.postal_code || "");
    setIdNumber(comp.identification_number || "");
    setVatNumber(comp.vat_number || "");
    setPhone(comp.phone || "");
    setEmail(comp.email || "");
    setWebsite(comp.website || "");
    setEmployeeCount(comp.employee_count ? String(comp.employee_count) : "");
    setBalanceSheet(comp.balance_sheet_total_k ? String(comp.balance_sheet_total_k / 1000) : "");
    setNetTurnover(comp.net_turnover_k ? String(comp.net_turnover_k / 1000) : "");

    setLoading(false);
  }

  async function handleSave() {
    if (!name.trim()) {
      setMsg({ type: "error", text: "Company name is required" });
      return;
    }

    if (!countryCode.trim()) {
      setMsg({ type: "error", text: "Country is required" });
      return;
    }

    const empCount = employeeCount.trim() ? parseInt(employeeCount.trim()) : null;
    const balanceSheetVal = balanceSheet.trim() ? parseFloat(balanceSheet.trim()) : null;
    const netTurnoverVal = netTurnover.trim() ? parseFloat(netTurnover.trim()) : null;

    // Validate numbers
    if (empCount !== null && (isNaN(empCount) || empCount <= 0)) {
      setMsg({ type: "error", text: "Employee count must be a positive number" });
      return;
    }
    if (balanceSheetVal !== null && (isNaN(balanceSheetVal) || balanceSheetVal < 0)) {
      setMsg({ type: "error", text: "Balance sheet total must be a non-negative number" });
      return;
    }
    if (netTurnoverVal !== null && (isNaN(netTurnoverVal) || netTurnoverVal < 0)) {
      setMsg({ type: "error", text: "Net turnover must be a non-negative number" });
      return;
    }

    // VSME validation
    if (empCount !== null || balanceSheetVal !== null || netTurnoverVal !== null) {
      let exceedsCount = 0;
      const violations = [];

      if (empCount !== null && empCount > 250) {
        exceedsCount++;
        violations.push(`Employees: ${empCount} (Medium max: 250)`);
      }
      if (balanceSheetVal !== null && balanceSheetVal > 25) {
        exceedsCount++;
        violations.push(`Balance Sheet: €${balanceSheetVal}M (Medium max: €25M)`);
      }
      if (netTurnoverVal !== null && netTurnoverVal > 50) {
        exceedsCount++;
        violations.push(`Net Turnover: €${netTurnoverVal}M (Medium max: €50M)`);
      }

      if (exceedsCount >= 2) {
        setMsg({
          type: "error",
          text: `⚠️ This platform supports VSME reporting only.\n\nYour company exceeds 2+ Medium thresholds:\n${violations.join('\n')}`,
        });
        return;
      }
    }

    setSaving(true);
    setMsg(null);

    try {
      const { error } = await supabase
        .from("company")
        .update({
          name: name.trim(),
          country_code: countryCode.trim(),
          industry_code: industryCode.trim() || null,
          address: address.trim() || null,
          city: city.trim() || null,
          postal_code: postalCode.trim() || null,
          identification_number: idNumber.trim() || null,
          vat_number: vatNumber.trim() || null,
          phone: phone.trim() || null,
          email: email.trim() || null,
          website: website.trim() || null,
          employee_count: empCount,
          balance_sheet_total_k: balanceSheetVal ? balanceSheetVal * 1000 : null,
          net_turnover_k: netTurnoverVal ? netTurnoverVal * 1000 : null,
        })
        .eq("id", companyId);

      if (error) throw error;

      setMsg({ type: "success", text: "Company profile updated successfully" });
      await loadCompany();
    } catch (err: any) {
      setMsg({ type: "error", text: err.message || "Failed to update company" });
    } finally {
      setSaving(false);
    }
  }

  if (loading) {
    return (
      <div style={{ minHeight: "100vh", backgroundColor: colors.bgPrimary, display: "flex", alignItems: "center", justifyContent: "center" }}>
        <p style={{ color: colors.textSecondary }}>{t('loading')}</p>
      </div>
    );
  }

  if (!company) {
    return (
      <div style={{ minHeight: "100vh", backgroundColor: colors.bgPrimary, padding: spacing.xl }}>
        <div style={{ maxWidth: "800px", margin: "0 auto" }}>
          <div style={{ ...cardStyles.base, textAlign: "center" }}>
            <p style={{ color: colors.error, marginBottom: spacing.lg }}>Company not found or access denied</p>
            <Link href={`/${locale}/profile`}>
              <button style={buttonStyles.primary}>Go to Profile</button>
            </Link>
          </div>
        </div>
      </div>
    );
  }

  const isProfileIncomplete = !address || !city || !postalCode || !email || !industryCode;

  return (
    <div style={{ minHeight: "100vh", backgroundColor: colors.bgPrimary }}>
      <div style={{ maxWidth: "900px", margin: "0 auto", padding: spacing.xl }}>
        {/* Header */}
        <div style={{ marginBottom: spacing.xl }}>
          <Link href={`/${locale}`} style={{ textDecoration: "none" }}>
            <button style={{ ...buttonStyles.secondary, marginBottom: spacing.md }}>
              ← Back to Dashboard
            </button>
          </Link>
          <h1 style={{ fontSize: fonts.size.h2, fontWeight: fonts.weight.bold, color: colors.textPrimary, marginBottom: spacing.sm }}>
            Complete Company Profile
          </h1>
          <p style={{ color: colors.textSecondary, fontSize: fonts.size.body }}>
            Fill in additional details to complete your company profile
          </p>
        </div>

        {/* Status Banner */}
        {isProfileIncomplete && (
          <div style={{
            ...cardStyles.base,
            backgroundColor: "#fff3cd",
            borderLeft: "4px solid #ffc107",
            marginBottom: spacing.lg,
          }}>
            <p style={{ margin: 0, color: "#856404", fontSize: fonts.size.sm, fontWeight: fonts.weight.semibold }}>
              ⚠️ Your company profile is incomplete. Please fill in the missing fields below.
            </p>
          </div>
        )}

        {/* Message Display */}
        {msg && (
          <div
            style={{
              backgroundColor: msg.type === "success" ? "#d4edda" : "#f8d7da",
              border: `1px solid ${msg.type === "success" ? colors.success : colors.error}`,
              color: msg.type === "success" ? "#155724" : colors.error,
              padding: spacing.md,
              borderRadius: "6px",
              marginBottom: spacing.lg,
              fontSize: fonts.size.sm,
              whiteSpace: "pre-line",
            }}
          >
            {msg.text}
          </div>
        )}

        {/* Form */}
        <div style={cardStyles.base}>
          <h2 style={{ fontSize: fonts.size.lg, fontWeight: fonts.weight.bold, marginBottom: spacing.lg, color: colors.textPrimary }}>
            Company Information
          </h2>

          <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: spacing.md }}>
            <div style={{ gridColumn: "1 / -1" }}>
              <label style={{ display: "block", marginBottom: spacing.xs, fontSize: fonts.size.sm, fontWeight: fonts.weight.semibold, color: colors.textPrimary }}>
                Company Name *
              </label>
              <input
                type="text"
                value={name}
                onChange={(e) => setName(e.target.value)}
                placeholder="Enter company name"
                style={inputStyles.base}
              />
            </div>

            <div>
              <label style={{ display: "block", marginBottom: spacing.xs, fontSize: fonts.size.sm, fontWeight: fonts.weight.semibold, color: colors.textPrimary }}>
                Country Code *
              </label>
              <input
                type="text"
                value={countryCode}
                onChange={(e) => setCountryCode(e.target.value)}
                placeholder="e.g., SK"
                maxLength={2}
                style={inputStyles.base}
              />
            </div>

            <div>
              <label style={{ display: "block", marginBottom: spacing.xs, fontSize: fonts.size.sm, fontWeight: fonts.weight.semibold, color: colors.textPrimary }}>
                Industry Code {isProfileIncomplete && <span style={{ color: colors.error }}>*</span>}
              </label>
              <input
                type="text"
                value={industryCode}
                onChange={(e) => setIndustryCode(e.target.value)}
                placeholder="e.g., NACE code"
                style={inputStyles.base}
              />
            </div>

            <div>
              <label style={{ display: "block", marginBottom: spacing.xs, fontSize: fonts.size.sm, fontWeight: fonts.weight.semibold, color: colors.textPrimary }}>
                Address {isProfileIncomplete && <span style={{ color: colors.error }}>*</span>}
              </label>
              <input
                type="text"
                value={address}
                onChange={(e) => setAddress(e.target.value)}
                placeholder="Street address"
                style={inputStyles.base}
              />
            </div>

            <div>
              <label style={{ display: "block", marginBottom: spacing.xs, fontSize: fonts.size.sm, fontWeight: fonts.weight.semibold, color: colors.textPrimary }}>
                City {isProfileIncomplete && <span style={{ color: colors.error }}>*</span>}
              </label>
              <input
                type="text"
                value={city}
                onChange={(e) => setCity(e.target.value)}
                placeholder="City"
                style={inputStyles.base}
              />
            </div>

            <div>
              <label style={{ display: "block", marginBottom: spacing.xs, fontSize: fonts.size.sm, fontWeight: fonts.weight.semibold, color: colors.textPrimary }}>
                Postal Code {isProfileIncomplete && <span style={{ color: colors.error }}>*</span>}
              </label>
              <input
                type="text"
                value={postalCode}
                onChange={(e) => setPostalCode(e.target.value)}
                placeholder="Postal code"
                style={inputStyles.base}
              />
            </div>

            <div>
              <label style={{ display: "block", marginBottom: spacing.xs, fontSize: fonts.size.sm, fontWeight: fonts.weight.semibold, color: colors.textPrimary }}>
                Company ID
              </label>
              <input
                type="text"
                value={idNumber}
                onChange={(e) => setIdNumber(e.target.value)}
                placeholder="IČO"
                style={inputStyles.base}
              />
            </div>

            <div>
              <label style={{ display: "block", marginBottom: spacing.xs, fontSize: fonts.size.sm, fontWeight: fonts.weight.semibold, color: colors.textPrimary }}>
                VAT Number
              </label>
              <input
                type="text"
                value={vatNumber}
                onChange={(e) => setVatNumber(e.target.value)}
                placeholder="DIČ"
                style={inputStyles.base}
              />
            </div>

            <div>
              <label style={{ display: "block", marginBottom: spacing.xs, fontSize: fonts.size.sm, fontWeight: fonts.weight.semibold, color: colors.textPrimary }}>
                Phone
              </label>
              <input
                type="tel"
                value={phone}
                onChange={(e) => setPhone(e.target.value)}
                placeholder="Phone number"
                style={inputStyles.base}
              />
            </div>

            <div>
              <label style={{ display: "block", marginBottom: spacing.xs, fontSize: fonts.size.sm, fontWeight: fonts.weight.semibold, color: colors.textPrimary }}>
                Email {isProfileIncomplete && <span style={{ color: colors.error }}>*</span>}
              </label>
              <input
                type="email"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                placeholder="contact@company.com"
                style={inputStyles.base}
              />
            </div>

            <div style={{ gridColumn: "1 / -1" }}>
              <label style={{ display: "block", marginBottom: spacing.xs, fontSize: fonts.size.sm, fontWeight: fonts.weight.semibold, color: colors.textPrimary }}>
                Website
              </label>
              <input
                type="url"
                value={website}
                onChange={(e) => setWebsite(e.target.value)}
                placeholder="https://company.com"
                style={inputStyles.base}
              />
            </div>

            <div>
              <label style={{ display: "block", marginBottom: spacing.xs, fontSize: fonts.size.sm, fontWeight: fonts.weight.semibold, color: colors.textPrimary }}>
                Average Number of Employees (Optional)
              </label>
              <input
                type="number"
                value={employeeCount}
                onChange={(e) => setEmployeeCount(e.target.value)}
                placeholder="e.g., 25"
                min="1"
                style={inputStyles.base}
              />
            </div>

            <div>
              <label style={{ display: "block", marginBottom: spacing.xs, fontSize: fonts.size.sm, fontWeight: fonts.weight.semibold, color: colors.textPrimary }}>
                Balance Sheet Total in € Million (Optional)
              </label>
              <input
                type="number"
                value={balanceSheet}
                onChange={(e) => setBalanceSheet(e.target.value)}
                placeholder="e.g., 12.5"
                min="0"
                step="0.1"
                style={inputStyles.base}
              />
            </div>

            <div>
              <label style={{ display: "block", marginBottom: spacing.xs, fontSize: fonts.size.sm, fontWeight: fonts.weight.semibold, color: colors.textPrimary }}>
                Net Turnover in € Million (Optional)
              </label>
              <input
                type="number"
                value={netTurnover}
                onChange={(e) => setNetTurnover(e.target.value)}
                placeholder="e.g., 18.7"
                min="0"
                step="0.1"
                style={inputStyles.base}
              />
            </div>
          </div>

          <div style={{ marginTop: spacing.lg, display: "flex", gap: spacing.md }}>
            <button
              onClick={handleSave}
              disabled={saving || !name.trim() || !countryCode.trim()}
              style={{
                ...buttonStyles.primary,
                flex: 1,
                opacity: saving || !name.trim() || !countryCode.trim() ? 0.5 : 1,
                cursor: saving || !name.trim() || !countryCode.trim() ? "not-allowed" : "pointer",
              }}
            >
              {saving ? "Saving..." : "Save Company Profile"}
            </button>
          </div>
        </div>

        {/* VSME Info */}
        <div style={{ ...cardStyles.base, marginTop: spacing.lg, backgroundColor: '#e7f3ff' }}>
          <p style={{ margin: `0 0 ${spacing.xs} 0`, fontSize: fonts.size.sm, fontWeight: fonts.weight.semibold, color: colors.textPrimary }}>
            ℹ️ VSME Eligibility (EU Directive 2013/34/EU)
          </p>
          <p style={{ margin: `0 0 ${spacing.sm} 0`, fontSize: fonts.size.xs, color: colors.textSecondary }}>
            Your company qualifies as VSME if it does <strong>NOT exceed 2 of 3</strong> thresholds:
          </p>
          <table style={{ width: '100%', fontSize: fonts.size.xs, color: colors.textSecondary, borderCollapse: 'collapse' }}>
            <thead>
              <tr style={{ borderBottom: '1px solid #b3d9ff' }}>
                <th style={{ textAlign: 'left', padding: spacing.xs }}>Category</th>
                <th style={{ textAlign: 'right', padding: spacing.xs }}>Employees</th>
                <th style={{ textAlign: 'right', padding: spacing.xs }}>Balance Sheet</th>
                <th style={{ textAlign: 'right', padding: spacing.xs }}>Turnover</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td style={{ padding: spacing.xs, fontWeight: fonts.weight.semibold }}>Micro</td>
                <td style={{ textAlign: 'right', padding: spacing.xs }}>≤10</td>
                <td style={{ textAlign: 'right', padding: spacing.xs }}>≤€0.45M</td>
                <td style={{ textAlign: 'right', padding: spacing.xs }}>≤€0.9M</td>
              </tr>
              <tr>
                <td style={{ padding: spacing.xs, fontWeight: fonts.weight.semibold }}>Small</td>
                <td style={{ textAlign: 'right', padding: spacing.xs }}>≤50</td>
                <td style={{ textAlign: 'right', padding: spacing.xs }}>≤€5M</td>
                <td style={{ textAlign: 'right', padding: spacing.xs }}>≤€10M</td>
              </tr>
              <tr>
                <td style={{ padding: spacing.xs, fontWeight: fonts.weight.semibold }}>Medium</td>
                <td style={{ textAlign: 'right', padding: spacing.xs }}>≤250</td>
                <td style={{ textAlign: 'right', padding: spacing.xs }}>≤€25M</td>
                <td style={{ textAlign: 'right', padding: spacing.xs }}>≤€50M</td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
}
