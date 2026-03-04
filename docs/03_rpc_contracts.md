# 03 – RPC CONTRACTS (Source of Truth)

This file defines the exact data contracts between:

- Supabase RPC
- UI (Next.js client components)
- Progress / readiness logic

DB/RPC are the source of truth.  
UI must not reinterpret scope, answer state, unit resolution, or progress logic.

---

## Conventions

- Scope, progress, and readiness are computed from DB state only.
- Scope authority is defined by:
  - report.framework
  - report.vsme_mode
  - report.vsme_pack_codes
  - report.vsme_taxonomy_version
- Topic permissions are enforced via RLS backed by company_member_topic_access.
- UI may update optimistically, but must reconcile with RPC-confirmed results.
- No implicit client-side filtering.
- No hidden heuristics.
- Avoid select * in RPC return shapes (explicit columns only).
- RPC functions must not bypass RLS.
- RPC contracts are versioned when return shape changes.
- Deterministic edge cases must be handled explicitly (see Progress Edge Cases).

---

# 1. get_vsme_questions_for_report(p_report_id uuid)

Status: Legacy / backward compatibility

Used by older clients. Does NOT include help text fields.

Preferred RPC is now:

get_vsme_questions_for_report_v2

---

## Purpose

Return the deterministic in-scope VSME question list for a report,
including existing answers.

This function defines the authoritative VSME question scope.

---

## Scope Authority (Report-level)

Scope is computed strictly per report based on:

- report.framework
- report.vsme_mode
- report.vsme_pack_codes
- report.vsme_taxonomy_version

No global company-level configuration affects VSME scope.

---

## Scope Logic (DB-driven)

Report configuration:

- framework = 'VSME'
- vsme_mode ∈ ('core','core_plus','comprehensive')
- vsme_pack_codes = text[]
- vsme_taxonomy_version = text (e.g. '1.2.0')

Mode semantics:

core  
All VSME questions where section_code LIKE 'B%'

core_plus  
Core (B%) + questions included via selected packs:

vsme_datapoint_pack.pack_code ∈ report.vsme_pack_codes  
AND  
vsme_datapoint_pack.datapoint_id = disclosure_question.vsme_datapoint_id

comprehensive  
Core (B%) + Comprehensive sections (C%)

Materiality logic is NOT applied in VSME.

Topic permissions are enforced via RLS backed by company_member_topic_access.

---

## Taxonomy Version Contract (VSME)

Each report is aligned to a specific VSME taxonomy version:

report.vsme_taxonomy_version

The question catalog MUST support 1:1 alignment to the EFRAG VSME taxonomy
for that version.

Current default taxonomy version:

'1.2.0'

If multiple taxonomy versions are supported in the future, eligibility MUST be
computed per report.vsme_taxonomy_version.

---

## Returns (per row)

question_id uuid  
code text  
question_text text  
answer_type text  
order_index integer  
section_code text  
vsme_level text  
vsme_datapoint_id text  
config_jsonb jsonb  

value_boolean boolean  
value_text text  
value_numeric numeric  
value_integer integer  
value_date date  

value_jsonb jsonb  

unit text  
updated_at timestamptz  

---

## Determinism Requirement

Same report configuration + same DB state → same question list.

Client must not re-filter scope.

---

# 2. get_vsme_questions_for_report_v2(p_report_id uuid)

Status: Active / preferred RPC

Used by:

- VsmeSectionClient
- Report Settings page
- Question debug panel

Introduced: 2026-02

---

## Purpose

Return deterministic in-scope VSME question list including help text fields.

This RPC is the **single source of truth for the question dataset used by UI.**

---

## Scope Logic

Identical to get_vsme_questions_for_report.

No differences in:

- scope
- ordering
- eligibility
- access control
- determinism

Only return shape is extended.

---

## Returns (per row)

question_id uuid  

code text  
question_text text  

guidance_text text nullable  
example_answer text nullable  

answer_type text  
order_index integer  

section_code text  
vsme_level text  

vsme_datapoint_id text  

config_jsonb jsonb  

value_boolean boolean  
value_text text  
value_numeric numeric  
value_integer integer  
value_date date  

value_jsonb jsonb  

unit text  

updated_at timestamptz  

---

## Help Text Fields Contract

Source table:

disclosure_question

Fields:

guidance_text TEXT NULL  
example_answer TEXT NULL  

Semantics:

guidance_text  
- explanatory text shown under question title  
- describes what the user should provide  

example_answer  
- example value shown under input  
- prefixed with "Example:"  

These fields:

- do NOT affect answer validation
- do NOT affect completion state
- do NOT affect progress
- do NOT affect export readiness
- do NOT affect scope

They exist purely for guided reporting UX.

---

## UNIT RESOLUTION CONTRACT (CRITICAL)

The `unit` returned by RPC is resolved deterministically.

Priority order:

1) disclosure_answer.unit  

2) vsme_datapoint.unit  

3) disclosure_question.unit  

Implementation:

unit = coalesce(a.unit, dp.unit, q.unit)

Where:

a = disclosure_answer  
dp = vsme_datapoint  
q = disclosure_question  

UI must always display the unit returned by RPC.

UI must never derive units independently.

---

## TYPE MATCHING CONTRACT (VSME)

Guardrail trigger:

enforce_vsme_question_type_match()

Rule:

disclosure_question.answer_type MUST match vsme_datapoint.value_type.

This prevents invalid combinations such as:

numeric datapoint + date answer type.

---

## CURRENCY DISPLAY CONTRACT (VSME TEMPLATE)

Template currency datapoint:

vsme_datapoint_id = 'template_currency'

Stored as:

disclosure_answer.value_text

Example:

EUR  
USD  

UI MAY use this value to display a currency suffix
for monetary datapoints.

This is display logic only.

Stored numeric values remain unit-agnostic.

---

## Determinism Requirement

Same report configuration + same DB state  
→ same question list INCLUDING guidance_text, example_answer and unit.

---

# 3. get_vsme_ctas_for_report(p_report_id uuid)

## Purpose

Return deterministic progress and readiness summary for the report.

This function MUST derive totals from the same eligible question set
as get_vsme_questions_for_report_v2.

---

## Answer State Model (Authoritative)

N/A representation:

value_jsonb -> { "na": true }

Answered:

- valid typed value stored in correct column  
OR  
- value_jsonb.na = true  

Missing:

- in-scope AND not answered  

N/A:

- explicit value_jsonb.na = true  
- counted as Answered

---

## Completion Formula

completion =

(Answered + N/A) / total_in_scope

---

## Progress Edge Cases

If total_in_scope_questions = 0:

overall.missing = 0  
overall.progress_ratio = 1.0  

sections[].missing = 0  
sections[].progress_ratio = 1.0  

continue_section_code may be NULL  
suggested_section_code may be NULL  

A report with zero eligible questions is considered complete.

---

## Aggregation Consistency Requirement

overall.total = sum(sections.total)

overall.answered = sum(sections.answered)

overall.missing = sum(sections.missing)

Deviation indicates a scope or aggregation bug.

---

## Returns (JSON)

{
  "sections": [
    {
      "section_code": "B1",
      "total": 30,
      "answered": 11,
      "missing": 19,
      "progress_ratio": 0.36,
      "last_updated_at": "timestamp"
    }
  ],
  "overall": {
    "total": 120,
    "answered": 85,
    "missing": 35,
    "progress_ratio": 0.71
  },
  "continue_section_code": "B1",
  "suggested_section_code": "B2"
}

Export readiness must be informative and never blocking.

---

# 4. Section Visibility Contract

Sections are derived from the RPC dataset.

Rule:

Sections where total = 0 must NOT be displayed in UI.

This prevents:

0 / 0 sections appearing in navigation.

Section lists must be derived only from the RPC dataset.

---

# 5. Security Model

Access control enforced by:

- Row Level Security (RLS)
- company_member_topic_access
- report/company membership rules

RPC must not bypass RLS.

If SECURITY DEFINER is used, explicit membership checks must exist.

---

# 6. Single Source of Truth

Scope, progress and readiness MUST be computed in DB.

UI:

- may optimistically update local state
- must reconcile with RPC-confirmed state
- must not duplicate scope rules
- must not redefine unit resolution
- must not reinterpret answer states

If business logic changes:

1. Update RPC
2. Update this file
3. Do NOT patch logic in UI only