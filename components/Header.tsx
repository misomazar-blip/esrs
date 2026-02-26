"use client";

import Link from "next/link";
import { useTranslations, useLocale } from "next-intl";
import { useState, useEffect } from "react";
import { createSupabaseBrowserClient } from "@/lib/supabase/client";
import { colors, fonts, spacing, shadows } from "@/lib/styles";
import LanguageSwitcher from "./LanguageSwitcher";

export default function Header() {
  const tNav = useTranslations('nav');
  const tAuth = useTranslations('auth');
  const locale = useLocale();
  const supabase = createSupabaseBrowserClient();
  
  const [email, setEmail] = useState<string | null>(null);
  const [dropdownOpen, setDropdownOpen] = useState(false);

  useEffect(() => {
    supabase.auth.getUser().then(({ data }) => {
      setEmail(data.user?.email ?? null);
    });
  }, []);

  const signOut = async () => {
    await supabase.auth.signOut();
    window.location.href = `/${locale}`;
  };

  const navItems = [
    { key: 'dashboard', href: `/${locale}/dashboard` },
    { key: 'reports', href: `/${locale}/report` },
    { key: 'analytics', href: `/${locale}/analytics` },
    { key: 'comparison', href: `/${locale}/comparison` },
    { key: 'profile', href: `/${locale}/profile` },
  ];

  return (
    <header
      style={{
        backgroundColor: colors.white,
        borderBottom: `1px solid ${colors.borderGray}`,
        boxShadow: shadows.sm,
        position: 'sticky',
        top: 0,
        zIndex: 100,
      }}
    >
      <div
        style={{
          maxWidth: '1400px',
          margin: '0 auto',
          padding: `${spacing.md} ${spacing.xl}`,
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'space-between',
          gap: spacing.xl,
        }}
      >
        {/* Logo/Brand */}
        <Link
          href={`/${locale}`}
          style={{
            fontFamily: fonts.family.primary,
            fontSize: fonts.size.lg,
            fontWeight: fonts.weight.bold,
            color: colors.primary,
            textDecoration: 'none',
            whiteSpace: 'nowrap',
          }}
        >
          ESRS SME
        </Link>

        {/* Navigation */}
        <nav
          style={{
            display: 'flex',
            alignItems: 'center',
            gap: spacing.lg,
            flex: 1,
            overflowX: 'auto',
          }}
        >
          {navItems.map((item) => (
            <Link
              key={item.key}
              href={item.href}
              style={{
                fontFamily: fonts.family.primary,
                fontSize: fonts.size.sm,
                fontWeight: fonts.weight.medium,
                color: colors.textSecondary,
                textDecoration: 'none',
                whiteSpace: 'nowrap',
                padding: `${spacing.sm} ${spacing.md}`,
                borderRadius: '4px',
                transition: 'all 0.2s ease',
              }}
              onMouseEnter={(e) => {
                e.currentTarget.style.color = colors.primary;
                e.currentTarget.style.backgroundColor = colors.primaryLight;
              }}
              onMouseLeave={(e) => {
                e.currentTarget.style.color = colors.textSecondary;
                e.currentTarget.style.backgroundColor = 'transparent';
              }}
            >
              {tNav(item.key as any)}
            </Link>
          ))}
        </nav>

        {/* Right side: Language Switcher + User Menu */}
        <div style={{ display: 'flex', alignItems: 'center', gap: spacing.md }}>
          {/* Language Switcher */}
          <LanguageSwitcher />

          {/* User Dropdown */}
          {email && (
            <div style={{ position: "relative" }}>
              <div
                onClick={() => setDropdownOpen(!dropdownOpen)}
                style={{
                  display: "flex",
                  alignItems: "center",
                  gap: spacing.sm,
                  cursor: "pointer",
                  padding: spacing.sm,
                  borderRadius: "8px",
                  transition: "background-color 0.2s",
                  backgroundColor: dropdownOpen ? colors.bgSecondary : "transparent",
                }}
                onMouseEnter={(e) => {
                  if (!dropdownOpen) e.currentTarget.style.backgroundColor = colors.bgSecondary;
                }}
                onMouseLeave={(e) => {
                  if (!dropdownOpen) e.currentTarget.style.backgroundColor = "transparent";
                }}
              >
                <div
                  style={{
                    width: "32px",
                    height: "32px",
                    borderRadius: "50%",
                    backgroundColor: colors.primary,
                    display: "flex",
                    alignItems: "center",
                    justifyContent: "center",
                    color: colors.white,
                    fontWeight: fonts.weight.bold,
                    fontSize: fonts.size.sm,
                  }}
                >
                  {email[0]?.toUpperCase()}
                </div>
                <span
                  style={{
                    fontSize: fonts.size.sm,
                    color: colors.textPrimary,
                    fontWeight: fonts.weight.medium,
                    maxWidth: "150px",
                    overflow: "hidden",
                    textOverflow: "ellipsis",
                    whiteSpace: "nowrap",
                  }}
                >
                  {email}
                </span>
                <span style={{ fontSize: "10px", color: colors.textSecondary }}>▼</span>
              </div>

              {/* Dropdown Menu */}
              {dropdownOpen && (
                <div
                  style={{
                    position: "absolute",
                    top: "calc(100% + 8px)",
                    right: 0,
                    backgroundColor: colors.white,
                    border: `1px solid ${colors.borderGray}`,
                    borderRadius: "8px",
                    boxShadow: shadows.md,
                    minWidth: "180px",
                    zIndex: 1000,
                    overflow: "hidden",
                  }}
                >
                  <Link
                    href={`/${locale}/profile`}
                    style={{
                      display: "block",
                      padding: `${spacing.sm} ${spacing.md}`,
                      fontSize: fonts.size.sm,
                      color: colors.textPrimary,
                      textDecoration: "none",
                      transition: "background-color 0.2s",
                    }}
                    onMouseEnter={(e) => (e.currentTarget.style.backgroundColor = colors.bgSecondary)}
                    onMouseLeave={(e) => (e.currentTarget.style.backgroundColor = "transparent")}
                  >
                    {tNav('profile')}
                  </Link>
                  <button
                    onClick={signOut}
                    style={{
                      display: "block",
                      width: "100%",
                      padding: `${spacing.sm} ${spacing.md}`,
                      fontSize: fonts.size.sm,
                      color: colors.error,
                      textAlign: "left",
                      border: "none",
                      backgroundColor: "transparent",
                      cursor: "pointer",
                      transition: "background-color 0.2s",
                    }}
                    onMouseEnter={(e) => (e.currentTarget.style.backgroundColor = colors.bgSecondary)}
                    onMouseLeave={(e) => (e.currentTarget.style.backgroundColor = "transparent")}
                  >
                    {tAuth('signOut')}
                  </button>
                </div>
              )}
            </div>
          )}
        </div>
      </div>
    </header>
  );
}
