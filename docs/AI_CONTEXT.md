# AI CONTEXT — VSME Reporting SaaS

You are helping build a guided ESG reporting tool for SMEs based on **EFRAG VSME**.

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
- docs/10_product_logic.md
- docs/11_prefill_contract.md
- docs/12_multi_member_datapoint_pattern.md

These documents define the authoritative system behaviour.

---

# Core System Principles

The platform is a **guided ESG reporting tool for SMEs** based on EFRAG VSME.

It is **not a compliance enforcement system**.

Design principles:

- deterministic reporting scope
- deterministic progress calculation
- guided UX
- non-blocking export
- minimal cognitive load for SME users
- deterministic database-driven logic

---

# Determinism Principle (CRITICAL)

The system must behave deterministically.

Given the same inputs:

- report configuration
- question catalog
- existing answers
- datapoint metadata

the system must always produce the same results.

This applies to:

- question scope
- progress calculation
- unit resolution
- export state
- section visibility

No client-side heuristics are allowed.

All authoritative logic must live in DB / RPC.

---

# Non-Negotiables

The following rules must never be violated.

---

# Database Rules

- DB schema is considered **stable**.
- No destructive schema changes unless explicitly requested.
- Additive schema changes must be explicitly requested.
- disclosure_question is shared **catalog metadata**.
- disclosure_answer stores the **report snapshot**.

Core tables must never be reinterpreted.

Stable core tables include:

- company
- report
- disclosure_question
- disclosure_answer
- vsme_datapoint

---

# RLS Rules

Row Level Security is enforced.

Never bypass RLS using service role in client code.

Access control must respect:

- company_member
- company_member_topic_access

UI must never be treated as a security boundary.

All access must be enforced at the database layer.

---

# RPC Authority

DB / RPC are the source of truth for:

- scope
- progress
- readiness
- unit resolution
- question ordering
- section visibility

UI must never recompute these rules.

UI is a **projection layer**, not a logic layer.

---

# RPC Contract Stability

RPC contracts are versioned.

Never silently change return shapes.

Preferred RPC functions:

- get_vsme_questions_for_report_v2
- get_vsme_ctas_for_report

Legacy RPCs may remain temporarily for compatibility.

Never remove legacy RPC without explicit migration.

---

# Data Model Principles

## Question metadata

disclosure_question contains:

- question_text
- guidance_text
- example_answer
- scope metadata
- vsme_datapoint_id

These fields are **catalog metadata**.

They are:

- read-only from UI
- not part of answer state
- not part of progress logic

UI must never attempt to modify them.

---

## Answer storage

disclosure_answer represents the **report snapshot**.

Answer values must be stored in the correct typed column.

Typed value columns include:

- value_text
- value_numeric
- value_integer
- value_date
- value_boolean

Optional metadata is stored in:

value_jsonb

Known metadata keys:

- na
- source

Example metadata:

{ "na": true }

{ "source": "company_profile" }

---

# JSON Merge Rule (CRITICAL)

value_jsonb must always be **merged**, never overwritten.

Correct pattern:

coalesce(existing_jsonb,'{}'::jsonb) || new_jsonb

Incorrect pattern:

value_jsonb = '{...}'

Overwriting JSON destroys metadata such as:

- na
- source
- future metadata fields

This must never happen.

---

# N/A Semantics

N/A stored as:

value_jsonb.na = true

Rules:

- N/A counts as answered for progress
- toggling N/A must preserve metadata
- N/A toggle must not overwrite other metadata keys

Important clarification:

There are two valid N/A-producing flows:

1. Manual user-driven N/A  
   - may preserve existing typed values

2. System-driven conditional child deactivation  
   - clears typed values
   - then sets value_jsonb.na = true

Both are valid under the contract.

N/A is part of the **answer state model**, not scope control.

---

# Company Profile Prefill

Company profile data may be used to prefill report answers.

Prefill is executed via RPC:

prefill_company_profile_into_open_reports(company_id)

Rules:

- Only applies to open / non-submitted reports
- Only fills missing answers
- Never overwrites typed answers
- Must skip answers where value_jsonb.na = true
- Must record provenance:

value_jsonb.source = "company_profile"

UI may show hint:

Prefilled from company profile.

Prefill does not affect scope or progress.

---

# Prefill Overwrite Prohibition (CRITICAL)

Prefill logic must never overwrite existing typed answers.

Allowed:

- create answer row if missing
- fill empty typed value fields

Not allowed:

- replacing user-entered values
- overwriting typed columns with company data
- filling answers already marked with value_jsonb.na = true

User answers always take precedence.

---

# Report Snapshot Principle (CRITICAL)

Reports represent immutable **snapshots of answers**.

Changing company profile data must not modify existing report answers.

Prefill only assists with **initial answer creation**.

Historical report data must remain stable.

---

# Units

Canonical unit source:

vsme_datapoint.unit

RPC resolves units using:

coalesce(
  disclosure_answer.unit,
  vsme_datapoint.unit,
  disclosure_question.unit
)

UI must always display the **RPC-returned unit**.

Never infer units from:

- question text
- user input
- example answers

Currency clarification:

- vsme_datapoint.unit remains the canonical unit contract
- template_currency defines reporting currency context for display
- template_currency does NOT override vsme_datapoint.unit

---

# Questionnaire Interaction Metadata

Questionnaire Interaction Metadata tables include:

- question_group
- question_group_item
- question_interaction_rule

These tables control:

- grouped question layout
- conditional child questions
- pair question rendering
- advanced questionnaire UX

Important rule:

These tables **do not define scope**.

They **do not define progress**.

They only influence **how in-scope questions are rendered**.

Scope always comes from RPC.

---

# Preferred RPC

## get_vsme_questions_for_report_v2

Returns:

- in-scope questions
- existing answers
- resolved unit
- guidance_text
- example_answer

This RPC defines the authoritative **question dataset**.

UI must rely entirely on this dataset for rendering.

---

## get_vsme_ctas_for_report

Returns:

- section progress
- report progress
- readiness metrics

This RPC defines the authoritative **completion state**.

UI may optimistically update local progress state,
but must reconcile with RPC results.

---

# Output Requirements for AI Patches

When proposing changes:

- produce minimal diff-style patches
- do not refactor unrelated files
- keep changes deterministic
- keep changes testable
- respect existing RPC contracts

Always include verification steps.

Example verification sequence:

1. SQL check
2. RPC output check
3. UI rendering check
4. Progress calculation check

---

# Documentation Update Workflow

Documentation may be updated through GPT to reduce manual editing.

Rules:

- updates must remain lightweight
- no structural rewrites
- only reflect real implemented behaviour
- preserve document structure where possible

Returned files should be copied into:

/docs

Documentation must remain consistent with:

- DB schema
- RPC contracts
- answer storage contract
- unit contract
- RLS policies

Docs act as the **single architectural reference** for the system.

---

END OF CONTEXT