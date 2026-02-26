# ARCHITECTURE – VSME Reporting SaaS

## 1. Goal of the architecture

Build a guided ESG reporting tool for SMEs (VSME) with:

- stable answering loop (load → render → save → progress)
- deterministic scope & progress calculation (DB-driven)
- role/topic-based access enforced by Supabase RLS
- export always available + “readiness” summary (non-blocking)

Key idea:  
**DB/RPC are the source of truth. UI is a projection.**

---

## 2. High-level flow (user journey)

1) Sign in (Supabase Auth)  
2) Company selection / creation  
3) Report creation (reporting_year)  
4) Choose VSME mode + optional add-ons (packs)  
5) Answering sections (questions + answers)  
6) Export (always allowed, show readiness summary)

---

## 3. Core concepts

### 3.1 Report

A report is a snapshot for a company + year:

- `report.company_id`
- `report.reporting_year`
- `report.status`
- `report.framework` (default VSME)
- `report.vsme_mode` (`core` | `core_plus` | `comprehensive`)
- `report.vsme_pack_codes` (text[] of selected add-on packs)

Uniqueness in DB:

- One report per `(company_id, reporting_year)`
- This uniqueness currently applies across all frameworks
  (DB does not differentiate by framework in unique constraint)

Implication:
- Running multiple frameworks in the same year would require schema adjustment.
- For VSME-only flow this is correct and stable.

---

### 3.2 VSME Scope (no materiality)

VSME flow does **not** use formal materiality assessment.

Scope is computed deterministically from:

- framework filter (`report.framework = 'VSME'`)
- `report.vsme_mode`
- pack membership (`report.vsme_pack_codes` + `vsme_datapoint_pack`)
- question metadata (`disclosure_question.section_code`, `vsme_datapoint_id`)
- user topic permissions (RLS)

Mode semantics:

- `core` → questions where `section_code` LIKE `B%`
- `core_plus` → `core` + datapoints included by selected packs
- `comprehensive` → `core` + questions where `section_code` LIKE `C%`

Important UI rule:
- UI must never infer scope from static metadata alone (e.g. VSME_SECTION_META).
- UI scope is derived from the RPC dataset returned by `get_vsme_questions_for_report(report_id)`.

---

### 3.3 Add-on packs (deterministic expansion)

Pack catalog:

- `report_pack` defines valid pack codes
- `vsme_datapoint_pack` maps `(datapoint_id, pack_code)`
- `disclosure_question.vsme_datapoint_id` links questions to datapoints

Important contract:

- `report.vsme_pack_codes` must only contain values that exist in `report_pack.code`
- Scope expansion must always derive from DB joins
- UI must not hardcode pack logic

---

### 3.4 Role & permissions (topic-level)

- owner/admin: full access
- editor: only topics explicitly allowed (view/edit)
- viewer: only topics explicitly allowed (view)

Enforced by:

- Row Level Security (RLS)
- `company_member_topic_access` (per-member per-topic permission table)

No UI-only enforcement. UI may hide, but DB must block.

---

### 3.5 disclosure_question is shared

Single table for ESRS + VSME.  
Separation through `disclosure_question.framework`.

No duplicate VSME-only runtime tables.

---

## 4. Answering Loop (core loop)

### 4.1 Deterministic data contract for UI

For a given report, UI needs:

- question list in deterministic order
- existing answers for those questions (if any)
- question config (answer_type, allowed units/enums, help text)
- stable identifiers for save/upsert

Source of truth:

- `get_vsme_questions_for_report(report_id)`

UI must not recompute scope rules.

---

### 4.2 Loading strategy

Preferred:

- Server Component loads report header + authorization sanity checks
- Client Component loads questions via RPC:
  - `get_vsme_questions_for_report(report_id)`
  - `get_vsme_ctas_for_report(report_id)` (for progress)

Avoid heavy client-side joins.

---

### 4.3 Save strategy (answers)

Save must be predictable and idempotent:

- Upsert by `(report_id, question_id)`
- Normalize value into correct typed column per `answer_type`
- Support explicit “N/A” state

N/A representation (current DB contract):

- `disclosure_answer.value_jsonb -> { "na": true }`

Rules:

- if `na=true`, value columns are ignored consistently
- if `na=false` or absent, values must be stored in correct typed column

After save:

- optimistic local update
- refresh progress via `get_vsme_ctas_for_report(report_id)`

---

### 4.4 Data integrity safeguards

The following DB mechanisms protect consistency:

- `enforce_answer_framework_match()` trigger  
  → ensures question.framework matches report.framework

- `set_updated_at()` trigger  
  → ensures answer timestamps are consistent

RLS policies prevent cross-company or unauthorized topic access.

These protections must not be bypassed.

---

### 4.5 Sections Panel (scope-derived UI)

Sections UI is derived from the same RPC dataset used for questions:

- `get_vsme_questions_for_report(report_id)` is the only source of truth.

Derivations computed in frontend (from RPC result):

- `totalBySection[section_code]`
- `completedBySection[section_code]` (Answered + N/A)
- `totalByGroup[group]` and `completedByGroup[group]`

Chapters (B1, C2, etc.) display rule:

- show a chapter only if `totalBySection[code] > 0`
- chapters with `0/0` are out-of-scope and must not be shown
- (edge case safety: if current route sectionCode has 0 questions, keep it visible)

Themes (groups) shown:

- General Information
- Environment
- Social
- Governance

Grouping is deterministic and shared across:
- building the chapter list (group membership)
- computing group totals

Grouping resolver:

resolveSectionGroup(sectionCode) with explicit mapping:

General Information:
- B1, B2, C1, C2

Environment:
- B3, B4, B5, B6, B7
- C3, C4

Social:
- B8, B9, B10
- C5, C6, C7

Governance:
- B11
- C8, C9

Accordion behavior:

- max 1 open theme at a time
- open theme auto-syncs with current chapter route

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

- In-scope: same eligibility logic as `get_vsme_questions_for_report`
- Answered: valid typed value OR `value_jsonb.na = true`
- Missing: in-scope AND not answered

Source of truth:

- `get_vsme_ctas_for_report`

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

### DB / RPC owns:

- scope determination
- question selection and ordering
- answer retrieval
- progress calculation
- missing logic

### UI owns:

- rendering
- interactions
- optimistic updates
- navigation

UI must not duplicate missing rules or scope rules.

---

## 8. Non-negotiables

- DB schema stable unless explicitly requested
- disclosure_question remains shared (ESRS + VSME)
- RLS is enforced (never bypass in app code)
- Prefer small deterministic changes
- If uncertain about DB policy/trigger change → ask first