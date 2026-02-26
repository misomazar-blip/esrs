# PROJECT CONTEXT – VSME Reporting SaaS (SME-focused)

## 1. Product Scope

Guided ESG reporting platform based on EFRAG VSME.  
Target: SMEs without ESG experts.

This is **not** a full ESRS compliance platform.

Primary goals:
- simple answering UX
- deterministic scope & progress
- non-blocking export
- modular VSME structure (Core / Comprehensive / Add-ons)

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

- Pack catalog stored in `report_pack`
- Pack-to-datapoint mapping stored in `vsme_datapoint_pack`
- Datapoints stored in `vsme_datapoint`
- Questions reference datapoints via `disclosure_question.vsme_datapoint_id`
- Selected pack codes stored on `report.vsme_pack_codes`
- Scope expansion is computed deterministically from report configuration

VSME mode semantics (stored on `report.vsme_mode`):

- `core`  
  → Core sections only (section_code like B%)

- `core_plus`  
  → Core (B%)  
  + datapoints included via selected packs

- `comprehensive`  
  → Core (B%)  
  + Comprehensive sections (C%)

Add-ons must not:
- automatically convert Core into full Comprehensive
- introduce formal materiality assessment
- alter the base VSME framework logic

---

## 3. Scope Rules (VSME)

For VSME flow, **formal materiality assessment is NOT required**.

All VSME questions are inherently applicable unless marked N/A by user.

A question/datapoint is considered **in scope** if:

- `report.framework = 'VSME'`
- included by `report.vsme_mode`
- OR included via selected datapoint packs (`report.vsme_pack_codes`)
- user has topic permission (enforced via RLS)

Topic permissions are backed by `company_member_topic_access` and enforced via RLS policies.

Materiality flags (if any legacy structures exist) are ignored in VSME flow.

Progress is computed only from in-scope questions.  
N/A counts as complete.

---

## 4. Answer State Model

Each in-scope question/datapoint can be in one of these states:

- **Answered**  
  → valid value stored in the correct typed column for the question’s `answer_type`

- **N/A**  
  → explicitly marked via `value_jsonb -> { "na": true }`

- **Missing**  
  → no valid value and not marked N/A

Progress formula:
Progress = (Answered + N/A) / (In-scope questions)
N/A counts as completed.

---

## 5. Determinism Principle

All scope and progress calculations must be deterministic:

- based only on DB state
- no implicit client-side filtering
- no hidden heuristics
- same inputs must always produce same outputs

Scope authority:
- `report.framework`
- `report.vsme_mode`
- `report.vsme_pack_codes`
- pack mappings (`vsme_datapoint_pack`)
- RLS permissions

RPC functions are the source of truth for:

- in-scope question list (e.g. `get_vsme_questions_for_report`)
- progress calculation (`get_vsme_ctas_for_report`)
- export readiness (informative, never blocking)

UI may update instantly (optimistic UX), but must reconcile with RPC-confirmed results after writes.

---

## 6. Tech Stack

Frontend:
- Next.js (App Router)
- React 19
- TypeScript
- Tailwind CSS

Backend:
- Supabase (Postgres)
- Supabase Auth
- Row Level Security (RLS)
- RPC functions for deterministic data loading

Architecture:
- Server + Client Components
- Deterministic data loading
- Prefer RPC over complex client joins
- No heavy client-side filtering of scope

---

## 7. Core Database Model (STABLE – do not refactor casually)

Core Tables:

- `company`
- `company_member`
- `company_member_topic_access`
- `topic`
- `report`
- `disclosure_question`
- `disclosure_answer`
- `report_pack`
- `vsme_datapoint`
- `vsme_datapoint_pack`

Key principles:

- `disclosure_question` is a shared table (framework separates ESRS/VSME)
- No VSME-only duplicate question tables
- Respect existing constraints and triggers
- Respect RLS
- No destructive schema changes unless explicitly requested
- Do not introduce duplicate uniqueness rules

---

## 8. Role Model

Owner / Admin:
- Full company access

Editor:
- Can view/edit only assigned topics

Viewer:
- Can view only assigned topics

Topic-level permissions are defined in `company_member_topic_access`
and enforced via RLS policies.

---

## 9. Guardrails

- DB schema is considered stable
- Do not rename columns casually
- Do not remove constraints
- Respect triggers
- Respect RLS
- If unsure about DB change → ask first

Prefer:

- Small deterministic changes
- Explicit RPC contracts
- No `select *` in RPC return shapes
- No disabling RLS
- No service role usage in browser
- Clear separation of responsibilities
- No UI-only business logic patches

---

## 10. Sections Panel – Scope-Derived Structure (NEW)

Sections panel is fully derived from:

get_vsme_questions_for_report(p_report_id)

This RPC is the single source of truth.

Rules:

Chapters (B1, C2, etc.)
- Display ONLY if total questions > 0
- Chapters with 0/0 must NOT be shown
- This ensures UI reflects actual report scope

Themes (Groups)
- Always visible:
  - General Information
  - Environment
  - Social
  - Governance

Theme totals are computed as:

groupTotal = sum(sectionTotal)
groupCompleted = sum(sectionCompleted)

Grouping resolver:

resolveSectionGroup(sectionCode) using explicit mapping:

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

Important constraints:

- VSME_SECTION_META is used only for labels
- It must NOT determine scope
- RPC determines scope
- UI derives grouping and totals deterministically

---

## 11. Current Focus

Feature / Goal:

Routes:

RPC:

Definition of done:

Known issues: