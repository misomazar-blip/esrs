"use client";

import { useRouter, usePathname, useSearchParams } from 'next/navigation';
import { useLocale } from 'next-intl';
import { useState, useRef, useEffect } from 'react';
import { colors, fonts, spacing, borderRadius, shadows } from '@/lib/styles';

const languages = [
  { code: 'en', flag: '🇬🇧', name: 'English' },
  { code: 'sk', flag: '🇸🇰', name: 'Slovensky' }
];

export default function LanguageSwitcher() {
  const router = useRouter();
  const pathname = usePathname();
  const searchParams = useSearchParams();
  const currentLocale = useLocale();
  const [isOpen, setIsOpen] = useState(false);
  const dropdownRef = useRef<HTMLDivElement>(null);

  const currentLanguage = languages.find(lang => lang.code === currentLocale) || languages[0];

  const switchLanguage = (newLocale: string) => {
    // Remove current locale from pathname if it exists
    const pathnameWithoutLocale = pathname.replace(/^\/(sk|en)/, '') || '/';
    
    // Preserve query parameters
    const queryString = searchParams.toString();
    const queryPart = queryString ? `?${queryString}` : '';
    
    // Add new locale
    const newPath = `/${newLocale}${pathnameWithoutLocale}${queryPart}`;
    
    router.push(newPath);
    setIsOpen(false);
  };

  // Close dropdown when clicking outside
  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      if (dropdownRef.current && !dropdownRef.current.contains(event.target as Node)) {
        setIsOpen(false);
      }
    };

    if (isOpen) {
      document.addEventListener('mousedown', handleClickOutside);
    }

    return () => {
      document.removeEventListener('mousedown', handleClickOutside);
    };
  }, [isOpen]);

  return (
    <div ref={dropdownRef} style={{ position: 'relative' }}>
      <button
        onClick={() => setIsOpen(!isOpen)}
        style={{
          display: 'flex',
          alignItems: 'center',
          gap: spacing.sm,
          padding: `${spacing.sm} ${spacing.md}`,
          backgroundColor: colors.white,
          border: `1px solid ${colors.borderGray}`,
          borderRadius: borderRadius.md,
          cursor: 'pointer',
          fontFamily: fonts.family.primary,
          fontSize: fonts.size.sm,
          fontWeight: fonts.weight.medium,
          color: colors.textPrimary,
          transition: 'all 0.2s ease',
          boxShadow: shadows.sm,
          minWidth: '60px',
        }}
        onMouseEnter={(e) => {
          e.currentTarget.style.borderColor = colors.primary;
        }}
        onMouseLeave={(e) => {
          e.currentTarget.style.borderColor = colors.borderGray;
        }}
      >
        <span>{currentLanguage.code.toUpperCase()}</span>
        <span style={{ 
          fontSize: '10px',
          transition: 'transform 0.2s ease',
          transform: isOpen ? 'rotate(180deg)' : 'rotate(0deg)'
        }}>▼</span>
      </button>

      {isOpen && (
        <div
          style={{
            position: 'absolute',
            top: 'calc(100% + 4px)',
            right: 0,
            minWidth: '160px',
            backgroundColor: colors.white,
            border: `1px solid ${colors.borderGray}`,
            borderRadius: borderRadius.md,
            boxShadow: shadows.lg,
            zIndex: 1000,
            overflow: 'hidden'
          }}
        >
          {languages.map((lang) => (
            <button
              key={lang.code}
              onClick={() => switchLanguage(lang.code)}
              style={{
                display: 'flex',
                alignItems: 'center',
                gap: spacing.md,
                width: '100%',
                padding: `${spacing.md} ${spacing.lg}`,
                border: 'none',
                backgroundColor: currentLocale === lang.code ? colors.primaryLight : colors.white,
                cursor: 'pointer',
                fontFamily: fonts.family.primary,
                fontSize: fonts.size.sm,
                fontWeight: currentLocale === lang.code ? fonts.weight.semibold : fonts.weight.normal,
                color: colors.textPrimary,
                textAlign: 'left',
                transition: 'background-color 0.2s ease',
              }}
              onMouseEnter={(e) => {
                if (currentLocale !== lang.code) {
                  e.currentTarget.style.backgroundColor = colors.bgSecondary;
                }
              }}
              onMouseLeave={(e) => {
                if (currentLocale !== lang.code) {
                  e.currentTarget.style.backgroundColor = colors.white;
                }
              }}
            >
              <span style={{ fontWeight: fonts.weight.bold }}>{lang.code.toUpperCase()}</span>
              <span>{lang.name}</span>
            </button>
          ))}
        </div>
      )}
    </div>
  );
}
