# ARCHITECTURE – VSME Reporting SaaS

## 1. Goal of the architecture

Build a guided ESG reporting tool for SMEs (VSME) with:

- stable answering loop (load → render → save → progress)
- deterministic scope & progress calculation (DB-driven)
- role/topic-based access enforced by Supabase RLS
- export always available + “readiness” summary (non-blocking)
- guided UX via question metadata (guidance_text, example_answer)
- pragmatic reuse of company profile data for report onboarding

Key idea:  
DB/RPC are the source of truth. UI is a projection.

---

## 2. High-level flow (user journey)

1) Sign in (Supabase Auth)  
2) Company selection / creation  
3) Report creation (reporting_year)  
4) Initial scope selection (core / core_plus / comprehensive)  
5) Report Settings (scope adjustments + optional add-ons)  
6) Answering sections (questions + answers)  
7) Export (always allowed, show readiness summary)

Company profile editing exists on a separate profile/company page and may prefill overlapping missing report answers for open VSME reports.

---

## 3. Core concepts

### 3.1 Report

A report is a snapshot for a company + year:

- report.company_id
- report.reporting_year
- report.status
- report.framework (default VSME)
- report.vsme_mode (core | core_plus | comprehensive)
- report.vsme_pack_codes (text[] of selected add-on packs)
- report.vsme_taxonomy_version

Uniqueness in DB:

- One report per (company_id, reporting_year)
- This uniqueness currently applies across all frameworks
  (DB does not differentiate by framework in unique constraint)

Implication:

- Running multiple frameworks in the same year would require schema adjustment.
- For VSME-only flow this is correct and stable.

A report is a historical snapshot.  
It must not behave like a live view directly bound to company master data.

---

### 3.2 VSME Scope (no materiality)

VSME flow does not use formal materiality assessment.

Scope is computed deterministically from:

- framework filter (report.framework = 'VSME')
- report.vsme_mode
- pack membership (report.vsme_pack_codes + vsme_datapoint_pack)
- question metadata (disclosure_question.section_code, vsme_datapoint_id)
- user topic permissions (RLS)

Mode semantics:

- core → questions where section_code LIKE B%
- core_plus → core + datapoints included by selected packs
- comprehensive → core + questions where section_code LIKE C%

Important UI rule:

- UI must never infer scope from static metadata alone (e.g. VSME_SECTION_META).
- UI scope is derived from the RPC dataset returned by get_vsme_questions_for_report_v2(report_id).

Scope can be adjusted from the **Report Settings** page.

N/A is not a scope control.  
It is only an answer-state marker.

---

### 3.3 Add-on packs (deterministic expansion)

Pack catalog:

- report_pack defines valid pack codes
- vsme_datapoint_pack maps (datapoint_id, pack_code)
- disclosure_question.vsme_datapoint_id links questions to datapoints

Important contract:

- report.vsme_pack_codes must only contain values that exist in report_pack.code
- Scope expansion must always derive from DB joins
- UI must not hardcode pack logic

---

### 3.4 Role & permissions (topic-level)

- owner/admin: full access
- editor: only topics explicitly allowed (view/edit)
- viewer: only topics explicitly allowed (view)

Enforced by:

- Row Level Security (RLS)
- company_member_topic_access (per-member per-topic permission table)

No UI-only enforcement. UI may hide, but DB must block.

---

### 3.5 disclosure_question is shared

Single table for ESRS + VSME.  
Separation through disclosure_question.framework.

No duplicate VSME-only runtime tables.

Question UX metadata lives here:

- guidance_text (optional)
- example_answer (optional)

These are informational only and never stored in disclosure_answer.

---

### 3.6 Company profile vs report answers

company stores reusable master data such as:

- legal name
- address
- city
- postal_code
- country_code
- identification_number
- vat_number

disclosure_answer stores report-specific answers / snapshot values.

Important rule:

- company profile data is not rendered as report data directly
- report-facing values must live in disclosure_answer

To reduce duplicate entry, overlapping company profile fields may be prefilling candidates for open VSME reports, but only through explicit DB/RPC action.

---

### 3.7 Report Settings (control panel)

Each report exposes a **Report Settings page** used for configuration and support/debug visibility.

Route:

/reports/[id]/settings

The page contains four functional areas.

---

#### 1) Report status

Shows:

- company
- reporting year
- reporting scope
- question count
- completion percentage
- N/A count

This information is derived from the same RPC dataset used by the answering pages.

---

#### 2) Scope configuration

Allows editing:

- report.vsme_mode
- report.vsme_pack_codes

Supported modes:

Core  
→ base VSME dataset

Core Plus  
→ Core + optional add-on packs

Comprehensive  
→ full VSME dataset

UX rules:

- add-on packs are visible only when mode = core_plus
- comprehensive disables add-on selection
- packs are preserved when switching modes in UI until saved
- saving scope updates report.vsme_mode and report.vsme_pack_codes

After saving scope:

- report row is updated
- question scope is recomputed via RPC
- question lists refresh deterministically

---

#### 3) Sections overview

Displays per-section completion derived from the RPC dataset.

Rules:

- sections with total = 0 are hidden
- completion represents (Answered + N/A) / total

This mirrors the same logic used on the answering page.

Current section panel header convention:

- left: Sections
- right: Completion

No global numeric total is shown in the header.  
Completion values are shown at section-row level only.

---

#### 4) All questions (advanced)

A collapsible **support/debug panel** containing the full in-scope question list.

Purpose:

- troubleshooting
- export validation
- support diagnostics

Features:

- collapsed by default
- search by text / code / datapoint / section
- filter by state (All / Missing / Answered / N/A)
- per-question debug details
- answer preview
- copy debug bundle for support

This panel is **not part of the normal SME answering flow** and exists primarily for diagnostics.

---

## 4. Answering Loop (core loop)

### 4.1 Deterministic data contract for UI

For a given report, UI needs:

- question list in deterministic order
- existing answers for those questions (if any)
- question config (answer_type, allowed units/enums, UX help text)
- stable identifiers for save/upsert

Source of truth:

- get_vsme_questions_for_report_v2(report_id)

UI must not recompute scope rules.

---

### 4.2 Loading strategy

Preferred:

- Server Component loads report header + authorization sanity checks
- Client Component loads questions via RPC:
  - get_vsme_questions_for_report_v2(report_id)
  - get_vsme_ctas_for_report(report_id) (for progress)

Avoid heavy client-side joins.

---

### 4.3 Save strategy (answers)

Save must be predictable and idempotent:

- Upsert by (report_id, question_id)
- Normalize value into correct typed column per answer_type
- Support explicit N/A state

N/A representation (current DB contract):

- disclosure_answer.value_jsonb -> { "na": true }

Metadata representation (current DB contract):

- disclosure_answer.value_jsonb is NOT NULL
- empty metadata state is {}

Rules:

- if na=true, value columns are ignored consistently
- if na=false or absent, values must be stored in correct typed column
- JSON metadata must be merged, not blindly replaced
- save operations must preserve unrelated value_jsonb keys

After save:

- optimistic local update
- refresh progress via get_vsme_ctas_for_report(report_id)

If a prefilled answer is later edited by the user, source metadata may be switched from company_profile to user.

---

### 4.4 Data integrity safeguards

The following DB mechanisms protect consistency:

- enforce_answer_framework_match() trigger  
  → ensures question.framework matches report.framework

- set_updated_at() trigger  
  → ensures answer timestamps are consistent

RLS policies prevent cross-company or unauthorized topic access.

These protections must not be bypassed.

---

### 4.5 Sections Panel (scope-derived UI)

Sections UI is derived from the same RPC dataset used for questions:

- get_vsme_questions_for_report_v2(report_id) is the only source of truth.

Derivations computed in frontend (from RPC result):

- totalBySection[section_code]
- completedBySection[section_code] (Answered + N/A)
- totalByGroup[group] and completedByGroup[group]

Chapters display rule:

- show a chapter only if totalBySection[code] > 0
- chapters with 0/0 are out-of-scope and must not be shown
- (edge case safety: if current route sectionCode has 0 questions, keep it visible)

Themes (groups) shown:

- General Information
- Environment
- Social
- Governance

Grouping is deterministic and shared across:

- building the chapter list
- computing group totals

---

### 4.6 Section navigation (Prev / Next)

Section-to-section navigation is derived from the same in-scope chapter list as the Sections panel.

Source of truth:

- get_vsme_questions_for_report_v2(report_id)
- chapters included only if totalBySection[code] > 0

Prev/Next rules:

- Previous = nearest earlier chapter with totalBySection > 0
- Next = nearest later chapter with totalBySection > 0
- Chapters with 0/0 are excluded from navigation

---

Sticky navigation behavior:

Two navigation UI modes exist:

1) Sticky navigation (floating)
2) Footer navigation (anchored after last question)

Sticky navigation visibility rules:

- visible only after user scroll passes threshold (~450px)
- automatically hidden when footer navigation enters viewport
- implemented using IntersectionObserver on footer navigation element

Footer navigation:

- always rendered after the last question
- acts as the final navigation anchor

Both navigation modes use the same deterministic chapter list.

---

### 4.7 Company profile prefill flow

Company profile editing happens outside the report answering page, currently on:

/[locale]/profile

After successful company update, the app may call:

- prefill_company_profile_into_open_reports(company_id)

Purpose:

- copy overlapping company-profile values into open/non-submitted VSME report answers
- reduce duplicate typing in B1 onboarding fields

Rules:

- prefill targets disclosure_answer, never UI-only state
- prefill only applies when the target answer is missing
- prefill never overwrites an existing typed answer
- prefill marks provenance in value_jsonb.source = 'company_profile'
- questionnaire UI may render:
  "Prefilled from company profile"

This is a helper action only.  
It is not a scope/progress authority.

---

## 5. Progress calculation (rules)

Progress must be deterministic and consistent across:

- dashboard overall progress
- per-section progress
- export readiness

Metrics:

- total_in_scope_questions
- answered_count (includes N/A)
- missing_count = total_in_scope - answered_count
- completion_pct = answered_count / total_in_scope

Definitions:

- In-scope: same eligibility logic as get_vsme_questions_for_report_v2
- Answered: valid typed value OR value_jsonb.na = true
- Missing: in-scope AND not answered

Operationally, Missing means:

- no disclosure_answer row exists
- OR a row exists but all typed value columns are empty/null
- AND value_jsonb.na is not true

Source of truth:

- get_vsme_ctas_for_report

---

## 6. Export readiness philosophy (non-blocking)

Export is always allowed.

Before export, show:

- completion %
- answered / missing counts
- top gaps (max 3)

No blocking. No alarmist wording.

Readiness logic must match progress logic exactly.

---

## 7. Where logic lives (anti-drift rule)

DB / RPC owns:

- scope determination
- question selection and ordering
- answer retrieval
- progress calculation
- missing logic
- company-profile prefill action for report answers

UI owns:

- rendering
- interactions
- optimistic updates
- navigation
- showing informational prefill provenance hints

UI must not duplicate missing rules or scope rules.  
UI must not use company table values as a live substitute for disclosure_answer.

---

## 8. RPC contract versioning (important)

When RPC return shape changes (new columns), do not modify the legacy function return type in place.

Instead:

- introduce a new version (v2, v3, ...)
- update 03_rpc_contracts.md
- switch frontend to the new version

Legacy RPC can remain for backward compatibility.

Current preferred question-loading RPC:

- get_vsme_questions_for_report_v2

Current helper prefill RPC:

- prefill_company_profile_into_open_reports

A narrower legacy prefill RPC may remain temporarily for backward compatibility, but should not be the preferred call from current UI.

---

## 9. Non-negotiables

- DB schema stable unless explicitly requested
- disclosure_question remains shared (ESRS + VSME)
- RLS is enforced (never bypass in app code)
- Prefer small deterministic changes
- disclosure_answer is the report snapshot
- company profile changes must not retroactively rewrite submitted reports
- If uncertain about DB policy/trigger change → ask first