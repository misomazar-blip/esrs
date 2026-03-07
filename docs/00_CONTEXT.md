# PROJECT CONTEXT – VSME Reporting SaaS (SME-focused)

## 1. Product Scope

Guided ESG reporting platform based on EFRAG VSME.  
Target: SMEs without ESG experts.

This is NOT a full ESRS compliance platform.

Primary goals:

- simple answering UX
- deterministic scope & progress
- non-blocking export
- modular VSME structure (Core / Comprehensive / Add-ons)
- guided reporting via contextual help text
- deterministic unit handling based on VSME datapoint catalog
- pragmatic reuse of company profile data for report onboarding

Export is always allowed.  
Missing answers are shown calmly.  
N/A is valid and counts as complete (not missing).

---

## 2. VSME Module Strategy

Platform supports:

- VSME Core
- VSME Comprehensive
- VSME Core + selected incremental add-ons (Datapoint Packs)

Add-ons (Datapoint Packs):

- predefined bundles of VSME datapoints
- selectable on top of Core
- designed for specific reporting purposes (e.g. bank request, procurement, investor request)
- remain within VSME logic (not full ESRS)

DB representation:

Pack catalog stored in:

report_pack  

Pack-to-datapoint mapping stored in:

vsme_datapoint_pack  

Datapoint catalog stored in:

vsme_datapoint  

Questions reference datapoints via:

disclosure_question.vsme_datapoint_id  

Selected pack codes stored on:

report.vsme_pack_codes  

Scope expansion is computed deterministically from report configuration.

---

## 3. Scope Rules (VSME)

For VSME flow, formal materiality assessment is NOT required.

All VSME questions are inherently applicable unless marked N/A by user.

A question/datapoint is considered in scope if:

- report.framework = 'VSME'
- included by report.vsme_mode
- OR included via selected datapoint packs (report.vsme_pack_codes)
- user has topic permission (enforced via RLS)

Topic permissions are backed by company_member_topic_access and enforced via RLS policies.

Materiality flags (if any legacy structures exist) are ignored in VSME flow.

Progress is computed only from in-scope questions.  
N/A counts as complete.

N/A is an answer-state flag only.  
It does not change scope.

---

## 4. Answer State Model

Each in-scope question/datapoint can be in one of these states:

Answered  
→ valid value stored in the correct typed column

N/A  
→ explicitly marked via value_jsonb -> { "na": true }

Missing  
→ no valid typed value and not marked N/A

Operationally, Missing means:

- no disclosure_answer row exists
- OR a row exists but all typed value columns are empty/null
- AND value_jsonb.na is not true

Progress formula:

Progress = (Answered + N/A) / (In-scope questions)

N/A counts as completed.

---

## 5. Question Metadata Model

Questions are defined in:

disclosure_question

Each question contains:

question_text  
guidance_text (optional)  
example_answer (optional)  
answer_type  
vsme_datapoint_id  
config_jsonb  

guidance_text:

- explains what data is requested
- shown below question title
- informational only

example_answer:

- provides example input format
- shown below input field prefixed with "Example:"
- informational only

These fields:

- do NOT affect scope
- do NOT affect progress
- do NOT affect validation
- do NOT affect export readiness
- are read-only from UI perspective

They exist purely for guided reporting UX.

---

## 6. UNIT MODEL (CRITICAL)

Units are defined at the datapoint level.

Canonical source of truth:

vsme_datapoint.unit

This defines the correct unit for each VSME datapoint.

Examples:

Assets → EUR  
TotalWaterConsumption → m3  
EnergyConsumption → MWh  

This ensures:

- consistent units across reports
- alignment with VSME standard
- deterministic unit rendering

Unit may be null for datapoints where no display unit is needed.  
UI must never invent a unit.

---

## 7. UNIT RESOLUTION CONTRACT (RPC)

RPC get_vsme_questions_for_report_v2 resolves unit using:

coalesce(disclosure_answer.unit, vsme_datapoint.unit, disclosure_question.unit)

Priority order:

1. disclosure_answer.unit  
   optional override (rare in MVP)

2. vsme_datapoint.unit  
   canonical source of truth

3. disclosure_question.unit  
   legacy fallback only

UI MUST rely on RPC-returned unit.  
UI must never infer units independently.

---

## 8. TEMPLATE CURRENCY MODEL

Template currency datapoint:

vsme_datapoint_id = template_currency

Stored as:

disclosure_answer.value_text  

Example:

EUR  
USD  
CZK  

This defines the reporting currency for the report.

Important:

template_currency itself has no unit.

Other monetary datapoints have unit defined in:

vsme_datapoint.unit

UI may display:

Assets input → value + EUR

This is display logic only.

Stored numeric values remain unit-agnostic.

Template currency is a report-level value.  
It does not override vsme_datapoint.unit.

---

## 9. Determinism Principle

All scope, progress, and unit calculations must be deterministic:

- based only on DB state
- no implicit client-side filtering
- no hidden heuristics

Scope authority:

- report.framework
- report.vsme_mode
- report.vsme_pack_codes
- report.vsme_taxonomy_version
- vsme_datapoint_pack
- vsme_datapoint
- RLS permissions

RPC functions are the single source of truth for:

in-scope question list  
get_vsme_questions_for_report_v2  

progress calculation  
get_vsme_ctas_for_report  

unit resolution  
get_vsme_questions_for_report_v2  

UI may update optimistically but must reconcile with RPC state.

---

## 10. RPC Contract Versioning

RPC return shape is versioned when extended.

Current preferred RPC:

get_vsme_questions_for_report_v2

Includes:

guidance_text  
example_answer  
unit (resolved deterministically)

Legacy RPC remains only for compatibility.

UI must use v2.

Additional utility RPC now used for onboarding/prefill:

prefill_company_profile_into_open_reports

This RPC is not a scope/progress authority RPC.  
It is a deterministic helper action that copies overlapping company profile data into open report answers only when the target answer is missing.

Legacy narrow prefill RPC may remain temporarily for backward compatibility, but preferred prefill RPC is:

prefill_company_profile_into_open_reports

---

## 11. Taxonomy Versioning (VSME)

The platform is aligned 1:1 with EFRAG VSME XBRL taxonomy version 1.2.0 (facts/questions).

Each report stores the taxonomy version used when the report was created:

report.vsme_taxonomy_version (default: '1.2.0')

This ensures:

- auditability of historical reports
- forward compatibility with future taxonomy releases
- deterministic export expectations per report

---

## 12. Tech Stack

Frontend:

Next.js (App Router)  
React 19  
TypeScript  
Tailwind CSS  

Backend:

Supabase  
Postgres  
Supabase Auth  
Row Level Security  
RPC functions

Architecture principles:

RPC-driven  
Deterministic  
No client-side scope logic  

---

## 13. Core Database Model (STABLE)

Core Tables:

company  
company_member  
company_member_topic_access  
topic  
report  
disclosure_question  
disclosure_answer  
report_pack  
vsme_datapoint  
vsme_datapoint_pack  

Key ownership:

company  
defines reusable company profile data

disclosure_question  
defines question metadata

vsme_datapoint  
defines canonical datapoint semantics including unit

disclosure_answer  
defines report-specific answer state / snapshot

Strict separation must be maintained.

Company profile is not rendered directly as report data.  
Report-facing values live in disclosure_answer.

---

## 14. Role Model

Owner / Admin  
Full access

Editor  
Edit allowed topics

Viewer  
View allowed topics

Permissions enforced via RLS.

---

## 15. Guardrails

DB schema is stable.

Never:

implement unit logic in UI  
derive unit from question_text  
bypass RPC  
duplicate unit logic client-side  
treat company profile as a live substitute for report answers  

Always:

use RPC-returned unit  
treat vsme_datapoint.unit as canonical  
use additive schema changes only  
treat disclosure_answer as the report snapshot  

---

## 16. Sections Panel – Scope-Derived Structure

Sections panel is derived entirely from:

get_vsme_questions_for_report_v2

Rules:

Show section only if total > 0  
Never show empty sections  

Grouping derived from section_code.

Current header layout:

- left: Sections
- right: Completion

No global numeric total is shown in the sections header.  
Completion values are shown only at section-row level.

---

## 17. Current Focus

Guided reporting UX with deterministic unit handling and pragmatic company-profile prefill for overlapping B1 data.

Implemented:

guidance_text rendering  
example_answer rendering  
RPC v2 contract  
unit resolution via vsme_datapoint  
template_currency support  
taxonomy version stored on report (vsme_taxonomy_version)  
sections header cleanup  
company-profile prefill into open reports for overlapping B1 fields  
prefill source hint rendering in questionnaire UI  

Answering UX (MVP):

- answers saved on blur (no explicit Save button)
- N/A toggle supported via value_jsonb.na
- section completion shown live (Answered / N/A / Missing / %)
- sticky section header for long sections
- sections panel completion derived from the same RPC dataset (consistent numbers)

Routes:

/reports/[id]/sections/[sectionCode]  
/[locale]/profile

RPC:

get_vsme_questions_for_report_v2  
get_vsme_ctas_for_report  
prefill_company_profile_into_open_reports  

Company profile prefill behavior:

- company profile is edited on a separate profile/company page
- after successful company update, open non-submitted VSME reports may be prefilled via RPC
- prefill applies only to overlapping Company Info ↔ B1 fields
- prefill writes into disclosure_answer, not directly from company to UI
- prefill never overwrites an existing typed answer
- prefill marks answer metadata with:
  value_jsonb.source = "company_profile"
- UI may show:
  "Prefilled from company profile"
  when source is company_profile
- if user later edits that answer in the questionnaire, source may be switched to user
- submitted reports are not targeted by prefill RPC

Current overlapping fields covered by company-profile prefill are intended to include applicable B1 company identity fields such as:

- legal name
- address
- city
- postal code
- country
- identification / registration number
- VAT number

Definition of done:

units always present where applicable  
unit resolved deterministically  
no unit logic in UI  
help text visible when present  
answering loop stable (load → edit → save → progress)  
company-profile prefill fills only missing overlapping report answers  
prefilled answers clearly indicated in UI  

Known issues:

None critical.

---

## 18. disclosure_answer JSONB metadata conventions

value_jsonb is NOT NULL.  
Empty metadata state should use:

{}

Current metadata keys used in MVP include:

na  
→ explicit N/A marker

source  
→ provenance marker for prefilled answers, e.g.:
  company_profile  
  user

JSON metadata must be merged, not blindly replaced.

In particular:

- NA toggle must not erase source
- saveAnswer must preserve unrelated keys in value_jsonb
- empty metadata should be stored as {} rather than null

---

## 19. Company Profile vs Report Snapshot Model

Company profile data and report answers are related but not identical concepts.

Company profile:

- represents the current master data of the company
- may change over time

Report answers:

- represent the snapshot used for that specific report
- must remain stable for historical/audit reasons

Therefore:

- changing company profile must not retroactively rewrite historical submitted reports
- open reports may receive deterministic prefills for missing overlapping answers
- report answers can diverge from company profile if the user explicitly changes them
- divergence is acceptable in MVP; user is not blocked

This avoids double entry while preserving report history.

---

## 20. VSC AI

Kodovanie robim cez VSC AI  
Prosim promty pre VSC rob v nasledovnom tvare:

STEP 1 (context):

Read docs/AI_CONTEXT.md and respect it.

STEP 2 (task):

We are modifying:
<exact file path>

Constraints:
- DB schema stable (no new columns, no destructive schema changes)
- RLS enforced (no bypass, no service role)
- Use existing RPC contracts (03_rpc_contracts.md)
- No client-side scope logic
- No client-side unit logic
- Minimal changes limited to this file

Goal:
<single precise goal>

Return:
- minimal diff-like patch only
- list side effects (if any)
- verification steps (how I can test in UI)

Never implement scope logic client-side.  
Scope must always come from RPC.

---

## 21. Docs Update Workflow (recommended)

To keep docs consistent without heavy manual copying:

1) Upload the relevant docs file(s) into GPT (copy/paste text in chat).  
2) GPT applies light updates only:
   - remove statements that are no longer true
   - incorporate newly implemented behaviour where it logically belongs
   - keep structure and wording stable (no rewrites)  
3) GPT returns the full updated file.  
4) Replace the file in `/docs` via Explorer.  
5) VSC AI reads docs from `/docs` as the source of truth.