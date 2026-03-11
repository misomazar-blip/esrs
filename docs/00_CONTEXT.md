# PROJECT CONTEXT – VSME Reporting SaaS (SME-focused)

Architecture version: v0.4  
Last structural update: Question grouping model + multi-member datapoint pattern

---

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

Unit may be null for datapoints where no display unit is needed.  
UI must never invent a unit.

---

## 7. UNIT RESOLUTION CONTRACT (RPC)

RPC get_vsme_questions_for_report_v2 resolves unit using:

coalesce(disclosure_answer.unit, vsme_datapoint.unit, disclosure_question.unit)

Priority order:

1. disclosure_answer.unit  
2. vsme_datapoint.unit  
3. disclosure_question.unit

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

Template currency itself has no unit.

Other monetary datapoints have unit defined in:

vsme_datapoint.unit

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

- in-scope question list  
- progress calculation  
- unit resolution

UI may update optimistically but must reconcile with RPC state.

---

## 10. RPC Contract Versioning

Preferred RPC:

get_vsme_questions_for_report_v2

Includes:

- guidance_text
- example_answer
- resolved unit

Utility RPC:

prefill_company_profile_into_open_reports

Used for deterministic prefill of missing B1 answers from company profile.

---

## 11. Taxonomy Versioning (VSME)

Platform aligned with VSME XBRL taxonomy **1.2.0**.

Stored on:

report.vsme_taxonomy_version

Ensures:

- auditability
- deterministic exports
- forward compatibility.

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

Core tables:

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

Strict separation:

Company profile ≠ report answers.

Report-facing values always live in **disclosure_answer**.

---

## 14. Role Model

Owner / Admin → full access  
Editor → edit allowed topics  
Viewer → read-only

Permissions enforced via RLS.

---

## 15. Guardrails

DB schema is stable.

Never:

- implement unit logic in UI
- derive unit from question_text
- bypass RPC
- duplicate unit logic client-side
- treat company profile as live report data

Always:

- use RPC-returned unit
- treat vsme_datapoint.unit as canonical
- treat disclosure_answer as the report snapshot

---

## 16. Sections Panel – Scope-Derived Structure

Sections panel derived from:

get_vsme_questions_for_report_v2

Rules:

Show section only if total > 0  
Never show empty sections

Grouping derived from section_code.

Completion displayed per section.

---

## 17. Questionnaire Interaction Layer (B1 Pilot)

Additional metadata layer for questionnaire UX.

Tables:

question_group  
question_group_item  
question_interaction_rule

Purpose:

- grouped questionnaire rendering
- conditional question behaviour
- separation of UX metadata from core data model

This layer does NOT affect:

- scope
- progress
- unit logic
- export logic

---

## 18. Question Grouping Model

Questions remain **atomic datapoint prompts** stored in:

disclosure_question

UI layout and interaction structure are defined through grouping metadata.

Tables:

question_group  
question_group_item

Purpose:

- visual grouping of questions
- paired question layouts
- parent → child dependencies
- structural rows used for XBRL tables

---

### question_group

Defines logical UI blocks.

Fields:

id  
framework  
taxonomy_version  
section_code  
code  
title  
description  
group_kind  
sort_order  
is_active  
config_jsonb

Supported group kinds:

block  
pair

Meaning:

block → vertical group  
pair → two-column layout

Example:

Base year | Target year

---

### question_group_item

Defines group membership.

Fields:

group_id  
question_id  
sort_order  
role  
config_jsonb

Supported roles:

primary  
secondary  
parent  
child  
entry  
technical

Meaning:

primary → main question  
secondary → paired question  
parent → controlling question  
child → dependent question  
entry → normal group item  
technical → hidden structural row

---

### Technical questions

Some XBRL datapoints represent:

- tables
- axes
- structural rows

Examples:

BreakdownOfEnergyConsumptionAxis  
BreakdownOfEnergyConsumptionTable

These use:

role = technical

Technical rows:

- exist in DB
- may be returned by RPC
- are **never rendered as question cards**

---

### Parent → child behaviour

Parent questions may control child visibility.

Example:

Has the undertaking set a GHG reduction target?

Children:

Base year  
Target year

If parent = false:

children are hidden.

Hidden children:

- remain in DB
- are excluded from UI
- do not count toward visible question counts

---

## 19. Conditional Question Behaviour (B1 Pilot)

Implemented rule patterns:

conditional_child  
conditional_group  
pair

Example:

UndertakingsLegalForm  
→ shows  
OtherUndertakingsLegalForm

Previous report reuse question  
→ shows follow-up explanation fields.

Inactive child behaviour:

- typed values cleared
- value_jsonb.na = true

When reactivated:

- na removed
- user may answer again

---

## 20. disclosure_answer JSONB metadata conventions

value_jsonb is NOT NULL.

Empty metadata:

{}

Keys used:

na  
source

Example:

source = "company_profile"

Metadata must always be **merged**, not overwritten.

---

## 21. Company Profile vs Report Snapshot Model

Company profile:

- editable master data

Report answers:

- immutable snapshot for that report

Rules:

- company profile never rewrites submitted reports
- open reports may receive deterministic prefills
- users may override prefills

---

## 22. VSC AI

Coding is done via VSC AI.

Prompt structure:

STEP 1 (context):

Read docs/AI_CONTEXT.md and respect it.

STEP 2 (task):

We are modifying:  
<exact file path>

Constraints:

- DB schema stable
- RLS enforced
- Use existing RPC contracts
- No client-side scope logic
- No client-side unit logic

Goal:  
<single precise goal>

Return:

- minimal diff-like patch
- side effects
- verification steps

Scope must never be implemented client-side.

---

## 23. Docs Update Workflow

Docs maintenance process:

1) Paste relevant docs into GPT.  
2) GPT performs light updates only.  
3) GPT returns the full updated file.  
4) Replace file in `/docs`.  
5) VSC AI reads `/docs` as source of truth.