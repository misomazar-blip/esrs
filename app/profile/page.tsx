"use client";

import Link from "next/link";
import { useEffect, useState } from "react";
import { createSupabaseBrowserClient } from "@/lib/supabase/client";
import { colors, buttonStyles, inputStyles, cardStyles, fonts, spacing, shadows } from "@/lib/styles";
import CompanyMembersManager from "@/app/company/CompanyMembersManager";

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
  created_at?: string;
};

export default function ProfilePage() {
  const supabase = createSupabaseBrowserClient();
  const [userId, setUserId] = useState<string | null>(null);
  const [email, setEmail] = useState("");
  const [firstName, setFirstName] = useState("");
  const [lastName, setLastName] = useState("");
  const [phone, setPhone] = useState("");
  const [currentPassword, setCurrentPassword] = useState("");
  const [newPassword, setNewPassword] = useState("");
  const [confirmPassword, setConfirmPassword] = useState("");
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [msg, setMsg] = useState<{ type: "success" | "error"; text: string } | null>(null);

  // Company states
  const [companies, setCompanies] = useState<Company[]>([]);
  const [companyName, setCompanyName] = useState("");
  const [companyCountry, setCompanyCountry] = useState("");
  const [companyIndustry, setCompanyIndustry] = useState("");
  const [companyAddress, setCompanyAddress] = useState("");
  const [companyCity, setCompanyCity] = useState("");
  const [companyPostalCode, setCompanyPostalCode] = useState("");
  const [companyIdNumber, setCompanyIdNumber] = useState("");
  const [companyVatNumber, setCompanyVatNumber] = useState("");
  const [companyPhone, setCompanyPhone] = useState("");
  const [companyEmail, setCompanyEmail] = useState("");
  const [companyWebsite, setCompanyWebsite] = useState("");
  const [showAddCompanyForm, setShowAddCompanyForm] = useState(false);
  const [companyMsg, setCompanyMsg] = useState<{ type: "success" | "error"; text: string } | null>(null);
  const [expandedCompanyId, setExpandedCompanyId] = useState<string | null>(null);
  const [editingCompanyId, setEditingCompanyId] = useState<string | null>(null);
  const [editingCompany, setEditingCompany] = useState<Company | null>(null);

  useEffect(() => {
    loadProfile();
  }, []);

  async function loadProfile() {
    const { data: { user } } = await supabase.auth.getUser();
    if (!user) {
      window.location.href = "/login";
      return;
    }

    setUserId(user.id);
    setEmail(user.email ?? "");
    setFirstName(user.user_metadata?.first_name ?? "");
    setLastName(user.user_metadata?.last_name ?? "");
    setPhone(user.user_metadata?.phone ?? "");
    
    // Load companies
    await loadCompanies(user.id);
    
    setLoading(false);
  }

  async function loadCompanies(uid: string) {
    const { data } = await supabase
      .from("company")
      .select("id, name, country_code, industry_code, address, city, postal_code, identification_number, vat_number, phone, email, website, created_at")
      .eq("user_id", uid)
      .order("created_at", { ascending: false });

    setCompanies((data as Company[]) ?? []);
  }

  async function handleSaveProfile() {
    setSaving(true);
    setMsg(null);

    try {
      const { error } = await supabase.auth.updateUser({
        data: {
          first_name: firstName,
          last_name: lastName,
          phone: phone,
        },
      });

      if (error) throw error;
      setMsg({ type: "success", text: "Profile updated successfully" });
    } catch (err: any) {
      setMsg({ type: "error", text: err.message || "Failed to update profile" });
    } finally {
      setSaving(false);
    }
  }

  async function handleChangePassword() {
    setSaving(true);
    setMsg(null);

    if (newPassword !== confirmPassword) {
      setMsg({ type: "error", text: "Passwords do not match" });
      setSaving(false);
      return;
    }

    if (newPassword.length < 6) {
      setMsg({ type: "error", text: "Password must be at least 6 characters" });
      setSaving(false);
      return;
    }

    try {
      const { error } = await supabase.auth.updateUser({
        password: newPassword,
      });

      if (error) throw error;

      setMsg({ type: "success", text: "Password changed successfully" });
      setCurrentPassword("");
      setNewPassword("");
      setConfirmPassword("");
    } catch (err: any) {
      setMsg({ type: "error", text: err.message || "Failed to change password" });
    } finally {
      setSaving(false);
    }
  }

  async function handleCreateCompany() {
    if (!userId) {
      setCompanyMsg({ type: "error", text: "User not authenticated" });
      return;
    }

    if (!companyName.trim()) {
      setCompanyMsg({ type: "error", text: "Company name is required" });
      return;
    }

    setSaving(true);
    setCompanyMsg(null);

    try {
      const { error } = await supabase.from("company").insert({
        name: companyName.trim(),
        address: companyAddress.trim() || null,
        city: companyCity.trim() || null,
        postal_code: companyPostalCode.trim() || null,
        country_code: companyCountry.trim() || null,
        identification_number: companyIdNumber.trim() || null,
        vat_number: companyVatNumber.trim() || null,
        phone: companyPhone.trim() || null,
        email: companyEmail.trim() || null,
        website: companyWebsite.trim() || null,
        industry_code: companyIndustry.trim() || null,
        user_id: userId,
      });

      if (error) throw error;

      setCompanyMsg({ type: "success", text: "Company created successfully" });
      setCompanyName("");
      setCompanyAddress("");
      setCompanyCity("");
      setCompanyPostalCode("");
      setCompanyCountry("");
      setCompanyIdNumber("");
      setCompanyVatNumber("");
      setCompanyPhone("");
      setCompanyEmail("");
      setCompanyWebsite("");
      setCompanyIndustry("");
      setShowAddCompanyForm(false);

      // Reload companies
      if (userId) await loadCompanies(userId);
    } catch (err: any) {
      setCompanyMsg({ type: "error", text: err.message || "Failed to create company" });
    } finally {
      setSaving(false);
    }
  }

  async function handleDeleteCompany(companyId: string) {
    // Get company name for confirmation
    const company = companies.find(c => c.id === companyId);
    const companyName = company?.name || "this company";
    
    if (!confirm(`Are you sure you want to DELETE "${companyName}"?\n\nThis will permanently delete the company and all associated data including:\n- All reports\n- All members\n- All topic access settings\n\nThis action cannot be undone!`)) return;

    setSaving(true);
    setCompanyMsg(null);

    try {
      const { error } = await supabase
        .from("company")
        .delete()
        .eq("id", companyId);

      if (error) throw error;

      setCompanyMsg({ type: "success", text: "Company deleted successfully" });

      // Reload companies
      if (userId) await loadCompanies(userId);
    } catch (err: any) {
      setCompanyMsg({ type: "error", text: err.message || "Failed to delete company" });
    } finally {
      setSaving(false);
    }
  }

  async function handleUpdateCompany() {
    if (!editingCompany) return;

    if (!editingCompany.name.trim()) {
      setCompanyMsg({ type: "error", text: "Company name is required" });
      return;
    }

    setSaving(true);
    setCompanyMsg(null);

    try {
      const { error } = await supabase
        .from("company")
        .update({
          name: editingCompany.name.trim(),
          address: editingCompany.address?.trim() || null,
          city: editingCompany.city?.trim() || null,
          postal_code: editingCompany.postal_code?.trim() || null,
          country_code: editingCompany.country_code?.trim() || null,
          identification_number: editingCompany.identification_number?.trim() || null,
          vat_number: editingCompany.vat_number?.trim() || null,
          phone: editingCompany.phone?.trim() || null,
          email: editingCompany.email?.trim() || null,
          website: editingCompany.website?.trim() || null,
          industry_code: editingCompany.industry_code?.trim() || null,
        })
        .eq("id", editingCompany.id);

      if (error) throw error;

      setCompanyMsg({ type: "success", text: "Company updated successfully" });
      setEditingCompanyId(null);
      setEditingCompany(null);

      // Reload companies
      if (userId) await loadCompanies(userId);
    } catch (err: any) {
      setCompanyMsg({ type: "error", text: err.message || "Failed to update company" });
    } finally {
      setSaving(false);
    }
  }

  if (loading) {
    return (
      <div style={{ minHeight: "100vh", backgroundColor: colors.bgPrimary, display: "flex", alignItems: "center", justifyContent: "center" }}>
        <p style={{ color: colors.textSecondary }}>Loading...</p>
      </div>
    );
  }

  return (
    <div style={{ minHeight: "100vh", backgroundColor: colors.bgPrimary }}>
      {/* TOP NAVIGATION */}
      <div
        style={{
          borderBottom: `1px solid ${colors.borderGray}`,
          boxShadow: shadows.sm,
          backgroundColor: colors.white,
        }}
      >
        <div
          style={{
            display: "flex",
            justifyContent: "space-between",
            alignItems: "center",
            padding: `${spacing.md} ${spacing.xl}`,
            maxWidth: "1200px",
            margin: "0 auto",
          }}
        >
          <Link
            href="/"
            style={{
              fontSize: fonts.size.h3,
              fontWeight: fonts.weight.bold,
              margin: 0,
              color: colors.primary,
              textDecoration: "none",
            }}
          >
            ESRS
          </Link>

          <div style={{ display: "flex", alignItems: "center", gap: spacing.lg }}>
            <Link href="/" style={{ ...buttonStyles.secondary, textDecoration: "none" }}>
              ← Back to Dashboard
            </Link>
            <button
              onClick={async () => {
                await supabase.auth.signOut();
                window.location.href = "/";
              }}
              style={buttonStyles.danger}
            >
              Sign Out
            </button>
          </div>
        </div>
      </div>

      {/* Main Content */}
      <div
        style={{
          maxWidth: "1400px",
          margin: "0 auto",
          padding: `${spacing.xl} ${spacing.xl}`,
        }}
      >
        <h1 style={{ fontSize: fonts.size.h2, fontWeight: fonts.weight.bold, marginBottom: spacing.xl, color: colors.textPrimary }}>
          Profile Settings
        </h1>

        {/* Two Column Layout */}
        <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: spacing.xl }}>
          
          {/* LEFT COLUMN - USER INFO */}
          <div>
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
                }}
              >
                {msg.text}
              </div>
            )}

            {/* Profile Information */}
            <div style={cardStyles.base}>
              <h2 style={{ fontSize: fonts.size.lg, fontWeight: fonts.weight.bold, marginBottom: spacing.lg, color: colors.textPrimary }}>
                Personal Information
              </h2>

              <div style={{ display: "grid", gap: spacing.lg }}>
                <div>
                  <label style={{ display: "block", marginBottom: spacing.xs, fontSize: fonts.size.sm, fontWeight: fonts.weight.semibold, color: colors.textPrimary }}>
                    First Name
                  </label>
                  <input
                    type="text"
                    value={firstName}
                    onChange={(e) => setFirstName(e.target.value)}
                    placeholder="Enter your first name"
                    style={inputStyles.base}
                  />
                </div>

            <div>
              <label style={{ display: "block", marginBottom: spacing.xs, fontSize: fonts.size.sm, fontWeight: fonts.weight.semibold, color: colors.textPrimary }}>
                Last Name
              </label>
              <input
                type="text"
                value={lastName}
                onChange={(e) => setLastName(e.target.value)}
                placeholder="Enter your last name"
                style={inputStyles.base}
              />
            </div>

            <div>
              <label style={{ display: "block", marginBottom: spacing.xs, fontSize: fonts.size.sm, fontWeight: fonts.weight.semibold, color: colors.textPrimary }}>
                Email
              </label>
              <input
                type="email"
                value={email}
                disabled
                style={{ ...inputStyles.base, backgroundColor: colors.bgSecondary, cursor: "not-allowed" }}
              />
              <p style={{ fontSize: fonts.size.sm, color: colors.textSecondary, marginTop: spacing.xs }}>
                Email cannot be changed
              </p>
            </div>

            <div>
              <label style={{ display: "block", marginBottom: spacing.xs, fontSize: fonts.size.sm, fontWeight: fonts.weight.semibold, color: colors.textPrimary }}>
                Phone Number
              </label>
              <input
                type="tel"
                value={phone}
                onChange={(e) => setPhone(e.target.value)}
                placeholder="Enter your phone number"
                style={inputStyles.base}
              />
            </div>

            <button
              onClick={handleSaveProfile}
              disabled={saving}
              style={{
                ...buttonStyles.primary,
                opacity: saving ? 0.5 : 1,
                cursor: saving ? "not-allowed" : "pointer",
              }}
            >
              {saving ? "Saving..." : "Save Profile"}
            </button>
          </div>
        </div>

            {/* Change Password */}
            <div style={{ ...cardStyles.base, marginTop: spacing.xl }}>
              <h2 style={{ fontSize: fonts.size.lg, fontWeight: fonts.weight.bold, marginBottom: spacing.lg, color: colors.textPrimary }}>
                Change Password
              </h2>

              <div style={{ display: "grid", gap: spacing.lg }}>
                <div>
                  <label style={{ display: "block", marginBottom: spacing.xs, fontSize: fonts.size.sm, fontWeight: fonts.weight.semibold, color: colors.textPrimary }}>
                    New Password
                  </label>
                  <input
                    type="password"
                    value={newPassword}
                    onChange={(e) => setNewPassword(e.target.value)}
                    placeholder="Enter new password"
                    style={inputStyles.base}
                  />
                </div>

                <div>
                  <label style={{ display: "block", marginBottom: spacing.xs, fontSize: fonts.size.sm, fontWeight: fonts.weight.semibold, color: colors.textPrimary }}>
                    Confirm New Password
                  </label>
                  <input
                    type="password"
                    value={confirmPassword}
                    onChange={(e) => setConfirmPassword(e.target.value)}
                    placeholder="Confirm new password"
                    style={inputStyles.base}
                  />
                </div>

                <button
                  onClick={handleChangePassword}
                  disabled={saving || !newPassword || !confirmPassword}
                  style={{
                    ...buttonStyles.primary,
                    opacity: saving || !newPassword || !confirmPassword ? 0.5 : 1,
                    cursor: saving || !newPassword || !confirmPassword ? "not-allowed" : "pointer",
                  }}
                >
                  {saving ? "Changing..." : "Change Password"}
                </button>
              </div>
            </div>
          </div>

          {/* RIGHT COLUMN - COMPANY INFO */}
          <div>
            {/* Company Message Display */}
            {companyMsg && (
              <div
                style={{
                  backgroundColor: companyMsg.type === "success" ? "#d4edda" : "#f8d7da",
                  border: `1px solid ${companyMsg.type === "success" ? colors.success : colors.error}`,
                  color: companyMsg.type === "success" ? "#155724" : colors.error,
                  padding: spacing.md,
                  borderRadius: "6px",
                  marginBottom: spacing.lg,
                  fontSize: fonts.size.sm,
                }}
              >
                {companyMsg.text}
              </div>
            )}

            {/* Company List */}
            <div style={{ ...cardStyles.base, backgroundColor: "#e6f2ff", borderLeft: "4px solid #0066cc" }}>
              <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: spacing.lg }}>
                <h2 style={{ fontSize: fonts.size.lg, fontWeight: fonts.weight.bold, margin: 0, color: colors.textPrimary }}>
                  🏢 Companies
                </h2>
                <button
                  onClick={() => setShowAddCompanyForm(!showAddCompanyForm)}
                  style={{
                    ...buttonStyles.primary,
                    padding: `${spacing.xs} ${spacing.md}`,
                    fontSize: fonts.size.sm,
                  }}
                >
                  {showAddCompanyForm ? "Cancel" : "+ Add Company"}
                </button>
              </div>

              {/* Add Company Form */}
              {showAddCompanyForm && (
                <div style={{ marginBottom: spacing.lg, padding: spacing.md, backgroundColor: colors.bgSecondary, borderRadius: "6px" }}>
                  <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: spacing.md }}>
                    <div>
                      <label style={{ display: "block", marginBottom: spacing.xs, fontSize: fonts.size.sm, fontWeight: fonts.weight.semibold, color: colors.textPrimary }}>
                        Company Name *
                      </label>
                      <input
                        type="text"
                        value={companyName}
                        onChange={(e) => setCompanyName(e.target.value)}
                        placeholder="Enter company name"
                        style={inputStyles.base}
                      />
                    </div>

                    <div>
                      <label style={{ display: "block", marginBottom: spacing.xs, fontSize: fonts.size.sm, fontWeight: fonts.weight.semibold, color: colors.textPrimary }}>
                        Country Code
                      </label>
                      <input
                        type="text"
                        value={companyCountry}
                        onChange={(e) => setCompanyCountry(e.target.value)}
                        placeholder="e.g., SK"
                        style={inputStyles.base}
                      />
                    </div>

                    <div>
                      <label style={{ display: "block", marginBottom: spacing.xs, fontSize: fonts.size.sm, fontWeight: fonts.weight.semibold, color: colors.textPrimary }}>
                        Address
                      </label>
                      <input
                        type="text"
                        value={companyAddress}
                        onChange={(e) => setCompanyAddress(e.target.value)}
                        placeholder="Street address"
                        style={inputStyles.base}
                      />
                    </div>

                    <div>
                      <label style={{ display: "block", marginBottom: spacing.xs, fontSize: fonts.size.sm, fontWeight: fonts.weight.semibold, color: colors.textPrimary }}>
                        City
                      </label>
                      <input
                        type="text"
                        value={companyCity}
                        onChange={(e) => setCompanyCity(e.target.value)}
                        placeholder="City"
                        style={inputStyles.base}
                      />
                    </div>

                    <div>
                      <label style={{ display: "block", marginBottom: spacing.xs, fontSize: fonts.size.sm, fontWeight: fonts.weight.semibold, color: colors.textPrimary }}>
                        Postal Code
                      </label>
                      <input
                        type="text"
                        value={companyPostalCode}
                        onChange={(e) => setCompanyPostalCode(e.target.value)}
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
                        value={companyIdNumber}
                        onChange={(e) => setCompanyIdNumber(e.target.value)}
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
                        value={companyVatNumber}
                        onChange={(e) => setCompanyVatNumber(e.target.value)}
                        placeholder="DIČ"
                        style={inputStyles.base}
                      />
                    </div>

                    <div>
                      <label style={{ display: "block", marginBottom: spacing.xs, fontSize: fonts.size.sm, fontWeight: fonts.weight.semibold, color: colors.textPrimary }}>
                        Phone
                      </label>
                      <input
                        type="text"
                        value={companyPhone}
                        onChange={(e) => setCompanyPhone(e.target.value)}
                        placeholder="Phone number"
                        style={inputStyles.base}
                      />
                    </div>

                    <div>
                      <label style={{ display: "block", marginBottom: spacing.xs, fontSize: fonts.size.sm, fontWeight: fonts.weight.semibold, color: colors.textPrimary }}>
                        Email
                      </label>
                      <input
                        type="email"
                        value={companyEmail}
                        onChange={(e) => setCompanyEmail(e.target.value)}
                        placeholder="contact@company.com"
                        style={inputStyles.base}
                      />
                    </div>

                    <div>
                      <label style={{ display: "block", marginBottom: spacing.xs, fontSize: fonts.size.sm, fontWeight: fonts.weight.semibold, color: colors.textPrimary }}>
                        Website
                      </label>
                      <input
                        type="text"
                        value={companyWebsite}
                        onChange={(e) => setCompanyWebsite(e.target.value)}
                        placeholder="https://company.com"
                        style={inputStyles.base}
                      />
                    </div>

                    <div>
                      <label style={{ display: "block", marginBottom: spacing.xs, fontSize: fonts.size.sm, fontWeight: fonts.weight.semibold, color: colors.textPrimary }}>
                        Industry Code
                      </label>
                      <input
                        type="text"
                        value={companyIndustry}
                        onChange={(e) => setCompanyIndustry(e.target.value)}
                        placeholder="e.g., NACE code"
                        style={inputStyles.base}
                      />
                    </div>

                    <button
                      onClick={handleCreateCompany}
                      disabled={saving || !companyName.trim()}
                      style={{
                        ...buttonStyles.primary,
                        opacity: saving || !companyName.trim() ? 0.5 : 1,
                        cursor: saving || !companyName.trim() ? "not-allowed" : "pointer",
                      }}
                    >
                      {saving ? "Creating..." : "Create Company"}
                    </button>
                  </div>
                </div>
              )}

              {/* Companies List */}
              {companies.length === 0 ? (
                <p style={{ color: colors.textSecondary, fontSize: fonts.size.sm }}>
                  No companies yet. Click "Add Company" to create one.
                </p>
              ) : (
                <div style={{ display: "grid", gap: spacing.md }}>
                  {companies.map((company) => (
                    <div
                      key={company.id}
                      style={{
                        padding: spacing.md,
                        border: `2px solid #d4edda`,
                        borderRadius: "6px",
                        backgroundColor: "#f0f9f4",
                        borderLeft: "4px solid #28a745",
                      }}
                    >
                      {/* Company Header */}
                      <div style={{ display: "flex", justifyContent: "space-between", alignItems: "start", marginBottom: spacing.sm }}>
                        <div style={{ flex: 1 }}>
                          <h3 style={{ fontSize: fonts.size.md, fontWeight: fonts.weight.bold, margin: `0 0 ${spacing.xs} 0`, color: colors.textPrimary }}>
                            {company.name}
                          </h3>
                          
                          {/* Company Info Summary */}
                          <div style={{ display: "grid", gap: spacing.xs, marginTop: spacing.sm }}>
                            {company.identification_number && (
                              <p style={{ margin: 0, fontSize: fonts.size.sm, color: colors.textSecondary }}>
                                <strong>ID:</strong> {company.identification_number}
                              </p>
                            )}
                            {company.vat_number && (
                              <p style={{ margin: 0, fontSize: fonts.size.sm, color: colors.textSecondary }}>
                                <strong>VAT:</strong> {company.vat_number}
                              </p>
                            )}
                            {company.address && (
                              <p style={{ margin: 0, fontSize: fonts.size.sm, color: colors.textSecondary }}>
                                📍 {company.address}{company.city && `, ${company.city}`}{company.postal_code && ` ${company.postal_code}`}
                              </p>
                            )}
                            {company.phone && (
                              <p style={{ margin: 0, fontSize: fonts.size.sm, color: colors.textSecondary }}>
                                📞 {company.phone}
                              </p>
                            )}
                            {company.email && (
                              <p style={{ margin: 0, fontSize: fonts.size.sm, color: colors.textSecondary }}>
                                ✉️ {company.email}
                              </p>
                            )}
                            {company.website && (
                              <p style={{ margin: 0, fontSize: fonts.size.sm, color: colors.textSecondary }}>
                                🌐 {company.website}
                              </p>
                            )}
                          </div>
                        </div>
                        <div style={{ display: "flex", gap: spacing.sm, flexWrap: "wrap" }}>
                          <button
                            onClick={() => {
                              setEditingCompanyId(company.id);
                              setEditingCompany({ ...company });
                            }}
                            style={{
                              ...buttonStyles.secondary,
                              padding: `${spacing.xs} ${spacing.sm}`,
                              fontSize: fonts.size.sm,
                            }}
                          >
                            ✏️ Edit Info
                          </button>
                          <button
                            onClick={() => setExpandedCompanyId(expandedCompanyId === company.id ? null : company.id)}
                            style={{
                              ...buttonStyles.secondary,
                              padding: `${spacing.xs} ${spacing.sm}`,
                              fontSize: fonts.size.sm,
                            }}
                          >
                            {expandedCompanyId === company.id ? "Hide Members" : "👥 Manage Members"}
                          </button>
                          <button
                            onClick={() => handleDeleteCompany(company.id)}
                            disabled={saving}
                            style={{
                              ...buttonStyles.danger,
                              padding: `${spacing.xs} ${spacing.sm}`,
                              fontSize: fonts.size.sm,
                              opacity: saving ? 0.5 : 1,
                            }}
                          >
                            🗑️ Delete Company
                          </button>
                        </div>
                      </div>

                      {/* Edit Company Info Form */}
                      {editingCompanyId === company.id && editingCompany && (
                        <div style={{
                          marginTop: spacing.md,
                          padding: spacing.md,
                          backgroundColor: colors.white,
                          borderRadius: "6px",
                          border: `2px solid ${colors.borderGray}`,
                        }}>
                          <h4 style={{ fontSize: fonts.size.md, fontWeight: fonts.weight.bold, marginBottom: spacing.md }}>
                            📝 Edit Company Information
                          </h4>
                          <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: spacing.md }}>
                            <div>
                              <label style={{ display: "block", marginBottom: spacing.xs, fontSize: fonts.size.sm, fontWeight: fonts.weight.semibold }}>
                                Company Name *
                              </label>
                              <input
                                type="text"
                                value={editingCompany.name}
                                onChange={(e) => setEditingCompany({ ...editingCompany, name: e.target.value })}
                                style={inputStyles.base}
                              />
                            </div>
                            <div>
                              <label style={{ display: "block", marginBottom: spacing.xs, fontSize: fonts.size.sm, fontWeight: fonts.weight.semibold }}>
                                Identification Number (IČO)
                              </label>
                              <input
                                type="text"
                                value={editingCompany.identification_number || ""}
                                onChange={(e) => setEditingCompany({ ...editingCompany, identification_number: e.target.value })}
                                placeholder="e.g., 12345678"
                                style={inputStyles.base}
                              />
                            </div>
                            <div>
                              <label style={{ display: "block", marginBottom: spacing.xs, fontSize: fonts.size.sm, fontWeight: fonts.weight.semibold }}>
                                VAT Number (DIČ)
                              </label>
                              <input
                                type="text"
                                value={editingCompany.vat_number || ""}
                                onChange={(e) => setEditingCompany({ ...editingCompany, vat_number: e.target.value })}
                                placeholder="e.g., SK1234567890"
                                style={inputStyles.base}
                              />
                            </div>
                            <div>
                              <label style={{ display: "block", marginBottom: spacing.xs, fontSize: fonts.size.sm, fontWeight: fonts.weight.semibold }}>
                                Industry Code (NACE)
                              </label>
                              <input
                                type="text"
                                value={editingCompany.industry_code || ""}
                                onChange={(e) => setEditingCompany({ ...editingCompany, industry_code: e.target.value })}
                                placeholder="e.g., 62.01"
                                style={inputStyles.base}
                              />
                            </div>
                            <div style={{ gridColumn: "1 / -1" }}>
                              <label style={{ display: "block", marginBottom: spacing.xs, fontSize: fonts.size.sm, fontWeight: fonts.weight.semibold }}>
                                Address
                              </label>
                              <input
                                type="text"
                                value={editingCompany.address || ""}
                                onChange={(e) => setEditingCompany({ ...editingCompany, address: e.target.value })}
                                placeholder="Street and number"
                                style={inputStyles.base}
                              />
                            </div>
                            <div>
                              <label style={{ display: "block", marginBottom: spacing.xs, fontSize: fonts.size.sm, fontWeight: fonts.weight.semibold }}>
                                City
                              </label>
                              <input
                                type="text"
                                value={editingCompany.city || ""}
                                onChange={(e) => setEditingCompany({ ...editingCompany, city: e.target.value })}
                                placeholder="e.g., Bratislava"
                                style={inputStyles.base}
                              />
                            </div>
                            <div>
                              <label style={{ display: "block", marginBottom: spacing.xs, fontSize: fonts.size.sm, fontWeight: fonts.weight.semibold }}>
                                Postal Code
                              </label>
                              <input
                                type="text"
                                value={editingCompany.postal_code || ""}
                                onChange={(e) => setEditingCompany({ ...editingCompany, postal_code: e.target.value })}
                                placeholder="e.g., 81101"
                                style={inputStyles.base}
                              />
                            </div>
                            <div>
                              <label style={{ display: "block", marginBottom: spacing.xs, fontSize: fonts.size.sm, fontWeight: fonts.weight.semibold }}>
                                Country Code
                              </label>
                              <input
                                type="text"
                                value={editingCompany.country_code || ""}
                                onChange={(e) => setEditingCompany({ ...editingCompany, country_code: e.target.value })}
                                placeholder="e.g., SK"
                                style={inputStyles.base}
                              />
                            </div>
                            <div>
                              <label style={{ display: "block", marginBottom: spacing.xs, fontSize: fonts.size.sm, fontWeight: fonts.weight.semibold }}>
                                Phone
                              </label>
                              <input
                                type="tel"
                                value={editingCompany.phone || ""}
                                onChange={(e) => setEditingCompany({ ...editingCompany, phone: e.target.value })}
                                placeholder="e.g., +421 2 1234 5678"
                                style={inputStyles.base}
                              />
                            </div>
                            <div>
                              <label style={{ display: "block", marginBottom: spacing.xs, fontSize: fonts.size.sm, fontWeight: fonts.weight.semibold }}>
                                Email
                              </label>
                              <input
                                type="email"
                                value={editingCompany.email || ""}
                                onChange={(e) => setEditingCompany({ ...editingCompany, email: e.target.value })}
                                placeholder="e.g., info@company.sk"
                                style={inputStyles.base}
                              />
                            </div>
                            <div>
                              <label style={{ display: "block", marginBottom: spacing.xs, fontSize: fonts.size.sm, fontWeight: fonts.weight.semibold }}>
                                Website
                              </label>
                              <input
                                type="url"
                                value={editingCompany.website || ""}
                                onChange={(e) => setEditingCompany({ ...editingCompany, website: e.target.value })}
                                placeholder="e.g., https://company.sk"
                                style={inputStyles.base}
                              />
                            </div>
                          </div>
                          <div style={{ display: "flex", gap: spacing.sm, marginTop: spacing.md }}>
                            <button
                              onClick={handleUpdateCompany}
                              disabled={saving || !editingCompany.name.trim()}
                              style={{
                                ...buttonStyles.primary,
                                opacity: saving || !editingCompany.name.trim() ? 0.5 : 1,
                              }}
                            >
                              {saving ? "Saving..." : "Save Changes"}
                            </button>
                            <button
                              onClick={() => {
                                setEditingCompanyId(null);
                                setEditingCompany(null);
                              }}
                              style={buttonStyles.secondary}
                            >
                              Cancel
                            </button>
                          </div>
                        </div>
                      )}

                      {/* Members Management - Expanded View */}
                      {expandedCompanyId === company.id && (
                        <div style={{
                          marginTop: spacing.md,
                          paddingTop: spacing.md,
                          borderTop: `1px solid ${colors.borderGray}`,
                        }}>
                          <CompanyMembersManager companyId={company.id} />
                        </div>
                      )}
                    </div>
                  ))}
                </div>
              )}
            </div>
          </div>

        </div>
      </div>
    </div>
  );
}
