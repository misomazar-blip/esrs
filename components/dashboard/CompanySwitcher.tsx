"use client";

import React, { useState, useEffect } from "react";
import { useSearchParams } from "next/navigation";

type CompanyOption = {
  id: string;
  name: string;
};

type CompanySwitcherProps = {
  companies: CompanyOption[];
  activeCompanyId: string;
};

const STORAGE_KEY = "vsme_active_company_id";

export default function CompanySwitcher({ companies, activeCompanyId }: CompanySwitcherProps) {
  const searchParams = useSearchParams();
  const urlCompanyId = searchParams.get("company");
  const [selectedCompanyId, setSelectedCompanyId] = useState<string>("");

  // On mount: initialize from URL param or localStorage
  useEffect(() => {
    console.log("[CompanySwitcher] mount effect: urlCompanyId=", urlCompanyId, "companies=", companies.length);
    const isValid = (id: string | null) => Boolean(id && companies.some((c) => c.id === id));

    // Priority 1: URL param (source of truth)
    if (isValid(urlCompanyId)) {
      console.log("[CompanySwitcher] using URL param:", urlCompanyId);
      setSelectedCompanyId(urlCompanyId as string);
      localStorage.setItem(STORAGE_KEY, urlCompanyId as string);
    } else {
      // Priority 2: localStorage - redirect if valid
      const storedId = localStorage.getItem(STORAGE_KEY);
      if (isValid(storedId)) {
        console.log("[CompanySwitcher] URL param invalid/empty, syncing from localStorage:", storedId);
        const url = new URL(window.location.href);
        url.searchParams.set("company", storedId as string);
        window.location.replace(url.toString());
        return; // Early exit, page will reload
      } else {
        // Priority 3: prop activeCompanyId - redirect if valid
        console.log("[CompanySwitcher] no valid URL/localStorage, using prop activeCompanyId:", activeCompanyId);
        if (isValid(activeCompanyId)) {
          const url = new URL(window.location.href);
          url.searchParams.set("company", activeCompanyId);
          window.location.replace(url.toString());
          return; // Early exit, page will reload
        }
      }
    }
  }, [companies, activeCompanyId]);

  // Watch URL param and update state if it changes (e.g., via browser back/forward)
  useEffect(() => {
    console.log("[CompanySwitcher] URL watch effect: urlCompanyId=", urlCompanyId);
    if (urlCompanyId) {
      console.log("[CompanySwitcher] updating selectedCompanyId to:", urlCompanyId);
      setSelectedCompanyId(urlCompanyId);
      localStorage.setItem(STORAGE_KEY, urlCompanyId);
    }
  }, [urlCompanyId]);

  const handleChange = (e: React.ChangeEvent<HTMLSelectElement>) => {
    const newCompanyId = e.target.value;
    console.log("[CompanySwitcher] selected change ->", newCompanyId);
    
    // Persist to localStorage
    localStorage.setItem(STORAGE_KEY, newCompanyId);
    
    // Build URL and hard navigate
    const url = new URL(window.location.href);
    url.searchParams.set("company", newCompanyId);
    console.log("[CompanySwitcher] navigating to:", url.toString());
    
    window.location.assign(url.toString());
  };

  return (
    <div className="flex items-center gap-2">
      <label className="text-sm text-slate-600" htmlFor="company-switcher">
        Company
      </label>
      <div className="relative">
        <select
          id="company-switcher"
          value={selectedCompanyId}
          onChange={handleChange}
          className="appearance-none rounded-full border border-slate-200 bg-white px-4 py-2 pr-9 text-sm text-slate-700 shadow-sm focus:outline-none focus:ring-2 focus:ring-slate-200"
        >
          {companies.map((company) => (
            <option key={company.id} value={company.id}>
              {company.name}
            </option>
          ))}
        </select>
        <span className="pointer-events-none absolute right-3 top-1/2 -translate-y-1/2 text-slate-400">
          v
        </span>
      </div>
    </div>
  );
}
