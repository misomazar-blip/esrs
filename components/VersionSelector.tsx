'use client';

import { useEffect, useState } from 'react';
import { createSupabaseBrowserClient } from '@/lib/supabase/client';
import { ESRSVersion } from '@/types/esrs';
import { colors, fonts, spacing } from '@/lib/styles';

interface VersionSelectorProps {
  onVersionChange?: (versionId: string) => void;
  showInactive?: boolean;
}

export default function VersionSelector({ 
  onVersionChange, 
  showInactive = false 
}: VersionSelectorProps) {
  const supabase = createSupabaseBrowserClient();
  const [versions, setVersions] = useState<ESRSVersion[]>([]);
  const [activeVersion, setActiveVersion] = useState<ESRSVersion | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    loadVersions();
  }, []);

  async function loadVersions() {
    setLoading(true);
    try {
      let query = supabase
        .from('esrs_version')
        .select('*')
        .order('effective_date', { ascending: false });

      if (!showInactive) {
        query = query.eq('is_active', true);
      }

      const { data, error } = await query;
      
      if (error) throw error;
      
      setVersions((data as ESRSVersion[]) || []);
      const active = (data as ESRSVersion[] || []).find(v => v.is_active);
      setActiveVersion(active || null);
    } catch (error) {
      console.error('Failed to load versions:', error);
    } finally {
      setLoading(false);
    }
  }

  if (loading) {
    return (
      <div style={{ fontSize: fonts.size.sm, color: colors.textSecondary }}>
        Loading versions...
      </div>
    );
  }

  if (!activeVersion && versions.length === 0) {
    return null;
  }

  return (
    <div style={{ display: 'flex', alignItems: 'center', gap: spacing.sm }}>
      <span style={{ fontSize: fonts.size.sm, color: colors.textSecondary }}>
        ESRS Version:
      </span>
      {showInactive && versions.length > 1 ? (
        <select
          value={activeVersion?.id || ''}
          onChange={(e) => {
            const selected = versions.find(v => v.id === e.target.value);
            if (selected) {
              setActiveVersion(selected);
              onVersionChange?.(selected.id);
            }
          }}
          style={{
            fontSize: fonts.size.sm,
            padding: `${spacing.xs} ${spacing.sm}`,
            border: `1px solid ${colors.borderGray}`,
            borderRadius: '4px',
            backgroundColor: colors.white,
            color: colors.textPrimary,
            cursor: 'pointer',
          }}
        >
          {versions.map(v => (
            <option key={v.id} value={v.id}>
              {v.version_name} {v.is_active ? '(Active)' : ''}
            </option>
          ))}
        </select>
      ) : (
        <span style={{ 
          fontSize: fonts.size.sm, 
          fontWeight: fonts.weight.semibold,
          color: colors.primary,
          padding: `${spacing.xs} ${spacing.sm}`,
          backgroundColor: colors.bgSecondary,
          borderRadius: '4px',
        }}>
          {activeVersion?.version_name || 'No active version'}
        </span>
      )}
    </div>
  );
}
