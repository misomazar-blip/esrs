"use client";

import { useRouter, usePathname } from 'next/navigation';
import { useLocale } from 'next-intl';
import { buttonStyles, colors } from '@/lib/styles';

export default function LanguageSwitcher() {
  const router = useRouter();
  const pathname = usePathname();
  const currentLocale = useLocale();

  const switchLanguage = (newLocale: string) => {
    // Remove current locale from pathname if it exists
    const pathnameWithoutLocale = pathname.replace(/^\/(sk|en)/, '') || '/';
    
    // Add new locale if it's not the default (sk)
    const newPath = newLocale === 'sk' 
      ? pathnameWithoutLocale 
      : `/${newLocale}${pathnameWithoutLocale}`;
    
    router.push(newPath);
  };

  return (
    <div style={{ 
      display: 'flex', 
      gap: '8px',
      alignItems: 'center'
    }}>
      <button
        onClick={() => switchLanguage('sk')}
        style={{
          ...buttonStyles.base,
          ...(currentLocale === 'sk' ? buttonStyles.primary : buttonStyles.secondary),
          padding: '6px 12px',
          fontSize: '14px',
          minWidth: '50px'
        }}
      >
        🇸🇰 SK
      </button>
      <button
        onClick={() => switchLanguage('en')}
        style={{
          ...buttonStyles.base,
          ...(currentLocale === 'en' ? buttonStyles.primary : buttonStyles.secondary),
          padding: '6px 12px',
          fontSize: '14px',
          minWidth: '50px'
        }}
      >
        🇬🇧 EN
      </button>
    </div>
  );
}
