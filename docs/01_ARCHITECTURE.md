# ARCHITECTURE – VSME Reporting SaaS

Architecture version: v0.4  
Last structural update: Question grouping model + structured questionnaire layer

---

# 1. Goal of the architecture

Build a guided ESG reporting tool for SMEs (VSME) with:

- stable answering loop (load → render → save → progress)
- deterministic scope & progress calculation (DB-driven)
- role/topic-based access enforced by Supabase RLS
- export always available + “readiness” summary (non-blocking)
- guided UX via question metadata (guidance_text, example_answer)
- pragmatic reuse of company profile data for report onboarding

Key idea:

DB/RPC are the source of truth.  
UI is a projection.

---

# 2. High-level flow (user journey)

1) Sign in (Supabase Auth)  
2) Company selection / creation  
3) Report creation (reporting_year)  
4) Initial scope selection (core / core_plus / comprehensive)  
5) Report Settings (scope adjustments + optional add-ons)  
6) Answering sections (questions + answers)  
7) Export (always allowed, show readiness summary)

Company profile editing exists on a separate profile/company page and may prefill overlapping missing report answers for open VSME reports.

---

# 3. Core concepts

## 3.1 Report

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

Running multiple frameworks in the same year would require schema adjustment.  
For VSME-only flow this is correct and stable.

A report is a historical snapshot.  
It must not behave like a live view directly bound to company master data.

---

## 3.2 VSME Scope (no materiality)

VSME flow does not use formal materiality assessment.

Scope is computed deterministically from:

- framework filter (report.framework = 'VSME')
- report.vsme_mode
- pack membership (report.vsme_pack_codes + vsme_datapoint_pack)
- question metadata (disclosure_question.section_code, vsme_datapoint_id)
- user topic permissions (RLS)

Mode semantics:

core  
→ questions where section_code LIKE B%

core_plus  
→ core + datapoints included by selected packs

comprehensive  
→ core + questions where section_code LIKE C%

Important UI rule:

UI must never infer scope from static metadata alone.

Scope always comes from RPC dataset returned by:

get_vsme_questions_for_report_v2(report_id)

Scope can be adjusted from the **Report Settings page**.

N/A is not a scope control.  
It is only an answer-state marker.

---

## 3.3 Add-on packs (deterministic expansion)

Pack catalog:

report_pack

defines valid pack codes.

Mapping:

vsme_datapoint_pack

maps datapoint → pack.

Question link:

disclosure_question.vsme_datapoint_id

Important contract:

- report.vsme_pack_codes must contain only valid pack codes
- scope expansion must derive from DB joins
- UI must never hardcode pack logic

---

## 3.4 Role & permissions (topic-level)

Roles:

owner/admin  
editor  
viewer

Permissions enforced via:

Row Level Security (RLS)

Permission table:

company_member_topic_access

Rules:

- owner/admin: full access
- editor: allowed topics editable
- viewer: read-only

UI hiding alone is insufficient.  
DB must enforce access.

---

## 3.5 disclosure_question is shared

Single table used for both ESRS and VSME.

Separation through:

disclosure_question.framework

UX metadata stored here:

- guidance_text
- example_answer
- config_jsonb

These are informational only and never stored in disclosure_answer.

---

## 3.6 Company profile vs report answers

company table stores reusable master data:

- legal name
- address
- city
- postal_code
- country_code
- identification_number
- vat_number

disclosure_answer stores report-specific answers.

Rule:

Company profile data must never be used directly as report answers.

To reduce duplicate entry, overlapping company fields may be prefilled into open reports through explicit RPC action.

---

# 4. Questionnaire Interaction Layer

To support richer questionnaire UX without modifying the core question model, a separate metadata layer exists.

Tables:

question_group  
question_group_item  
question_interaction_rule

Purpose:

- group questions for UI rendering
- support conditional question behaviour
- keep UX metadata separate from reporting logic

Important rule:

This layer **never affects scope or progress**.

Scope always derives from RPC.

---

## 4.1 Question grouping

Question groups define logical UI blocks inside a section.

Example (B1):

- Company identity
- Company size
- Reporting basis
- Report continuity
- Sites
- Subsidiaries

Group definitions stored in:

question_group

Group membership stored in:

question_group_item

Fields:

group_code  
question_code  
sort_order  
role

role may be:

primary  
secondary  
parent  
child  
entry  
technical

Technical rows (e.g. typed axis identifiers) are hidden from UI.

---

## 4.2 Group rendering types

Two group types exist:

block  
pair

block:

vertical question list

Example:

Company identity  
→ Legal name  
→ Country  
→ Address

pair:

two-column layout

Example:

Base year | Target year

Layout implementation typically uses:

grid grid-cols-1 md:grid-cols-2

If fewer than two visible questions exist, UI falls back to block rendering.

---

## 4.3 Conditional interaction rules

Conditional logic is defined via:

question_interaction_rule

Rule types currently used:

conditional_child  
conditional_group  
pair

Example:

UndertakingsLegalForm  
→ controls visibility of  
OtherUndertakingsLegalForm

Previous report reuse question  
→ controls follow-up explanation fields.

Conditional logic is evaluated **client-side**, but rule definitions live in DB metadata.

This separation allows flexible UX without altering scope logic.

---

## 4.4 Conditional child behaviour

When a child question becomes inactive:

- typed values are cleared
- disclosure_answer.value_jsonb.na = true

When child becomes active again:

- na flag removed
- user can answer again

This ensures:

- no hidden invalid answers
- deterministic export behaviour
- consistent progress calculation.

---

# 5. Section Render Model

Sections may contain both grouped and standalone questions.

The UI constructs an internal **section render model**.

Example:

sectionRenderModel

grouped_blocks  
standalone_questions  
consumed_question_ids  
total_visible

Purpose:

- avoid duplicate rendering
- support mixed layouts
- compute visible question count

Visible question count excludes:

- technical rows
- hidden children.

---

# 6. Answering Loop (core loop)

## 6.1 Deterministic UI data contract

For a given report the UI needs:

- ordered question list
- existing answers
- question config
- stable identifiers for save/upsert

Source of truth:

get_vsme_questions_for_report_v2(report_id)

UI must never recompute scope.

---

## 6.2 Loading strategy

Preferred approach:

Server Component:

- loads report header
- performs authorization checks

Client Component:

- loads questions via RPC
- loads progress via RPC

RPC used:

get_vsme_questions_for_report_v2  
get_vsme_ctas_for_report

Avoid client-side joins.

---

## 6.3 Save strategy

Saving answers must be idempotent.

Upsert key:

(report_id, question_id)

Value stored in typed column depending on answer_type:

value_text  
value_numeric  
value_date  
value_boolean

Boolean questions are rendered as dropdown (Yes / No).

N/A representation:

value_jsonb → { "na": true }

Rules:

- if na=true → typed columns ignored
- if na removed → values stored normally
- JSON metadata must always be merged

After save:

- optimistic UI update
- refresh progress via RPC.

---

## 6.4 Data integrity safeguards

Database triggers enforce consistency.

Triggers:

enforce_answer_framework_match()

Ensures question.framework matches report.framework.

set_updated_at()

Maintains consistent timestamps.

RLS policies prevent cross-company access.

These safeguards must never be bypassed.

---

# 7. Sections Panel

Sections panel derives entirely from RPC dataset:

get_vsme_questions_for_report_v2

Rules:

Show section only if total > 0.

Chapters grouped by section_code.

Completion metric:

(Answered + N/A) / total.

Chapters with 0 questions are not shown.

---

# 8. Section navigation

Prev/Next navigation uses same chapter list as sections panel.

Rules:

Previous → nearest earlier chapter with questions  
Next → nearest later chapter with questions

Zero-question chapters excluded.

---

# 9. Company profile prefill flow

Company profile editing occurs on:

/[locale]/profile

After update the app may call:

prefill_company_profile_into_open_reports(company_id)

Purpose:

copy overlapping company data into open VSME reports.

Rules:

- prefill only if answer is missing
- never overwrite existing answers
- skip answers where value_jsonb.na = true
- mark provenance in metadata:

value_jsonb.source = "company_profile"

UI may show:

"Prefilled from company profile".

This RPC is a helper action only.

---

# 10. Progress calculation

Progress must be deterministic.

Metrics:

total_in_scope_questions  
answered_count  
missing_count  
completion_pct

Definitions:

Answered  
→ typed value OR na=true

Missing  
→ in-scope AND not answered

Source of truth:

get_vsme_ctas_for_report

---

# 11. Export philosophy

Export is always allowed.

Before export show:

- completion %
- answered/missing counts
- top gaps

No blocking.

Export readiness must follow same logic as progress.

---

# 12. Where logic lives

DB/RPC owns:

- scope determination
- question selection
- answer retrieval
- progress calculation
- missing logic
- company-profile prefill

UI owns:

- rendering
- interactions
- optimistic updates
- navigation
- informational hints

UI must never replicate scope logic.

---

# 13. RPC contract versioning

RPC return shapes must never change in place.

When extended:

- introduce new version (v2, v3…)
- update docs
- migrate UI

Preferred RPC:

get_vsme_questions_for_report_v2

Helper RPC:

prefill_company_profile_into_open_reports

---

# 14. Non-negotiables

- DB schema stable unless explicitly requested
- disclosure_question shared between frameworks
- RLS enforced
- deterministic logic preferred
- disclosure_answer is the report snapshot
- company profile must never rewrite submitted reports