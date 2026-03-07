# AI CONTEXT — VSME Reporting SaaS

You are helping build a guided ESG reporting tool for SMEs based on EFRAG VSME.

Before proposing any solution, read and respect these docs (source of truth):

- docs/00_project_context.md
- docs/01_architecture.md
- docs/02_db_schema.sql
- docs/02_schema_map.md
- docs/03_rpc_contracts.md
- docs/04_answer_contract.md
- docs/05_rls_policies.md
- docs/06_debug_playbook.md
- docs/07_prompt_templates.md
- docs/08_units_contract.md
- docs/09_known_limits.md
- docs/10_Product_logic.md
- docs/11_prefill_contract.md

---

# Core System Principles

The platform is a guided ESG reporting tool for SMEs based on EFRAG VSME.

It is not a compliance enforcement system.

Design principles:

- deterministic reporting scope
- deterministic progress calculation
- guided UX
- non-blocking export
- minimal cognitive load for SME users

---

# Non-Negotiables

The following rules must never be violated.

## Database

- DB schema is stable (no destructive changes unless explicitly requested).
- Never introduce breaking schema changes.
- disclosure_question is shared catalog metadata (read-only from UI).
- disclosure_answer stores the report snapshot.

## RLS

- RLS is enforced.
- Never bypass RLS with service role in client code.
- All access must respect company_member and topic access rules.

## RPC authority

DB/RPC are the source of truth for:

- scope
- progress
- readiness
- unit resolution

UI must never recompute these.

## RPC contract stability

RPC contracts are versioned.

Never silently change return shapes.

Preferred RPC:

- get_vsme_questions_for_report_v2
- get_vsme_ctas_for_report

---

# Data Model Principles

## Question metadata

disclosure_question contains:

- question_text
- guidance_text
- example_answer
- scope metadata
- vsme_datapoint_id

UI must never attempt to modify these fields.

---

## Answer storage

disclosure_answer represents the report snapshot.

Answer values must be stored in the correct typed column.

Metadata stored in:

value_jsonb

Known keys:

- na
- source

Example:

{ "na": true }

{ "source": "company_profile" }

---

## JSON Merge Rule (CRITICAL)

value_jsonb must always be merged, never overwritten.

Correct pattern:

coalesce(existing_jsonb,'{}'::jsonb) || new_jsonb

Incorrect pattern:

value_jsonb = '{...}'

Overwriting JSON destroys metadata such as:

- na
- source

This must never happen.

---

## N/A semantics

N/A stored as:

value_jsonb.na = true

Rules:

- N/A counts as answered for progress
- N/A must not delete previously stored typed values
- toggling NA must preserve previous values

---

## Company profile prefill

Company profile data may be used to prefill report answers.

Prefill is executed via RPC:

prefill_company_profile_into_open_reports(company_id)

Rules:

- Only applies to open / non-submitted reports
- Only fills missing answers
- Never overwrites typed answers
- Must record provenance:

value_jsonb.source = "company_profile"

This metadata may be used by UI to show an informational hint:

"Prefilled from company profile"

Prefill does not affect progress or scope.

---

## Prefill Overwrite Prohibition (CRITICAL)

Prefill logic must never overwrite existing typed answers.

Allowed:

- create answer row if missing
- fill empty typed value fields

Not allowed:

- replacing user-entered values
- overwriting typed columns with company data

User answers always take precedence.

---

## Report Snapshot Principle (CRITICAL)

Reports represent immutable snapshots of answers.

Changing company profile data must not modify existing report answers.

Prefill only assists with initial answer creation.

Report data must remain historically stable.

---

## Units

Canonical unit source:

vsme_datapoint.unit

RPC resolves units using:

coalesce(
  disclosure_answer.unit,
  vsme_datapoint.unit,
  disclosure_question.unit
)

UI must always display RPC-returned unit.

Never infer units from question text.

---

# Preferred RPC

## get_vsme_questions_for_report_v2

Returns:

- questions
- existing answers
- resolved unit
- guidance_text
- example_answer

This RPC defines the authoritative question dataset.

---

## get_vsme_ctas_for_report

Returns:

- section progress
- report progress
- readiness metrics

This RPC defines the authoritative completion state.

---

# Output Requirements for AI Patches

When proposing changes:

- produce minimal diff-style patches
- do not refactor unrelated files
- keep changes deterministic
- keep changes testable
- respect existing RPC contracts

Always include:

How to verify:

- 2–5 verification steps
- clear UI or SQL tests

---

# Documentation Update Workflow

Documentation may be updated through GPT to reduce manual editing.

Rules:

- Updates must be lightweight
- No structural rewrites
- Only reflect real implemented behaviour
- Preserve document structure where possible

Returned files should be copied into /docs as the new source of truth.

Documentation must remain consistent with:

- DB schema
- RPC contracts
- answer storage contract