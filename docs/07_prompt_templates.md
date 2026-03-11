# 07 – PROMPT TEMPLATES (For GPT Collaboration)

This file defines how GPT should be used in this project.

Always reference:

- 00_CONTEXT.md
- 01_ARCHITECTURE.md
- 02_db_schema.sql
- 02_schema_map.md
- 03_rpc_contracts.md
- 04_answer_contract.md
- 05_rls_policies.md
- 06_debug_playbook.md
- 08_units_contract.md
- 09_known_limits.md
- 10_Product_logic.md
- 11_prefill_contract.md
- 12_multi_member_datapoint_pattern.md
- AI_context_md

Non-negotiables:

- DB schema is considered stable
- No destructive schema changes unless explicitly requested
- RLS must never be bypassed
- Prefer deterministic RPC-driven logic
- RPC contracts are authoritative
- UI must never compute reporting scope independently
- UI must never infer units
- UI must never bypass answer contract

Preferred RPC for question loading:

get_vsme_questions_for_report_v2

Legacy RPC get_vsme_questions_for_report must not be used for new functionality.

The following conceptual separations are critical:

disclosure_question → metadata definition  
disclosure_answer → report snapshot answers  
vsme_datapoint → canonical datapoint semantics  
report → scope configuration

Questionnaire UX metadata:

question_group  
question_group_item  
question_interaction_rule

These tables shape questionnaire UX only.

They must never define:

- scope
- progress
- export logic

Scope authority always comes from RPC.

---

# 1 – New GPT Thread Bootstrap

Paste this at the start of a new GPT conversation.

You are assisting with a VSME Reporting SaaS platform.

Before proposing any solution, read and respect the following docs:

- Project context
- Architecture
- DB schema
- RPC contracts
- Answer storage contract
- RLS policies
- Debug playbook

Critical rules:

- Do NOT propose destructive schema changes.
- Do NOT bypass RLS.
- Prefer deterministic RPC solutions.
- Always use get_vsme_questions_for_report_v2.
- disclosure_question defines question metadata.
- disclosure_answer defines report answers.
- vsme_datapoint defines canonical datapoint semantics.
- report.vsme_taxonomy_version defines taxonomy alignment.
- questionnaire metadata tables shape UX only.

Never mix these responsibilities.

Keep changes minimal and deterministic.

Current task:

<describe task>

---

# 2 – Frontend Patch Request

STEP 1 – Context

Read docs/AI_CONTEXT.md and respect it.

STEP 2 – Task

We are modifying:

<exact file path>

Constraints:

- DB schema stable
- No new columns
- No destructive schema changes
- RLS enforced
- No service role in client
- Use existing RPC contracts
- No client-side scope logic
- No client-side unit logic
- Minimal change limited to this file

Goal:

<single precise goal>

Return:

- minimal patch
- potential side effects
- verification steps

Scope must always come from RPC.

---

# 3 – Additive Schema Change Request

Use this template only when schema expansion is explicitly intended.

Context:

Read docs/AI_CONTEXT.md.

Task:

We are modifying the database schema.

Constraints:

- additive changes only
- no destructive changes
- preserve existing table semantics
- preserve RLS assumptions
- preserve existing RPC contracts unless versioned

Goal:

<precise schema goal>

Return:

- SQL migration
- validation queries
- rollback notes
- docs update text

Example use cases:

- question_group
- question_group_item
- question_interaction_rule
- new supporting indexes

---

# 4 – RPC Change Request

We are modifying RPC:

<function name>

Current contract defined in:

03_rpc_contracts.md

Goal:

<precise change>

Constraints:

- no destructive schema changes
- version RPC if return shape changes
- deterministic scope logic
- explicit column selection
- respect report.vsme_taxonomy_version

Return:

- updated SQL function
- updated RPC contract text
- test queries
- migration-safe approach

Never silently change RPC used by frontend.

---

# 5 – Question Metadata Changes

We are modifying disclosure_question metadata.

Possible fields:

guidance_text  
example_answer  
question_text  
config_jsonb  
section_code  
vsme_level

Constraints:

- must not affect disclosure_answer
- must not affect scope
- must not affect progress
- must remain read-only in UI
- must respect enforce_vsme_question_type_match trigger

Return:

- SQL update
- validation queries

Never store metadata in disclosure_answer.

---

# 6 – Questionnaire Interaction Metadata Request

Tables involved:

question_group  
question_group_item  
question_interaction_rule

Goal:

<precise interaction goal>

Examples:

- group B1 questions
- conditional child questions
- conditional group visibility
- pair layout rendering

Constraints:

- must not affect scope
- must not affect progress
- must not affect export logic
- must not bypass RPC scope logic
- must remain deterministic
- prefer ID matching over code heuristics

Return:

- SQL seed / migration
- validation queries
- minimal frontend patch if required

Never treat interaction metadata as scope authority.

---

# 7 – Security Tightening (RLS)

Target table:

<table_name>

Goal:

Improve security without breaking functionality.

Constraints:

- no schema redesign
- no service role in frontend
- no SECURITY DEFINER bypass unless audited
- no weakening of protections

Return:

- SQL policy change
- execution order
- validation queries
- role test matrix

Never weaken RLS for convenience.

---

# 8 – RPC Version Migration

Goal:

Safely migrate frontend to new RPC version.

Example:

get_vsme_questions_for_report → get_vsme_questions_for_report_v2

Return:

- minimal frontend patch
- verification steps
- rollback approach

Never delete legacy RPC immediately.

---

# 9 – SECURITY DEFINER Audit

Goal:

Find SECURITY DEFINER functions without explicit search_path.

Audit query:

select proname from pg_proc where prosecdef = true;

Fix pattern:

alter function <function_name> set search_path = public;

Re-audit after fix.

---

# 10 – Performance Audit

Target query or RPC:

<query>

Return:

- EXPLAIN ANALYZE interpretation
- bottleneck identification
- index recommendations if justified
- tradeoffs

Never propose indexes without evidence.

---

# 11 – Debug Template

Bug:

<error>

Observed:

<actual behavior>

Expected:

<expected behavior>

Already verified:

- DB state correct
- RPC output checked
- RLS policies checked
- cache cleared

Return:

- diagnostic steps
- root cause
- minimal fix

Avoid architectural rewrites.

---

# 12 – Contract Mismatch Diagnostic

Used when frontend receives undefined fields.

Verify:

1. DB contains values

select guidance_text from disclosure_question limit 5;

2. RPC returns values

select guidance_text from get_vsme_questions_for_report_v2('<report_id>');

3. Frontend calls correct RPC

supabase.rpc('get_vsme_questions_for_report_v2')

4. Frontend types include field

Fix the layer where the mismatch occurs.

Never patch UI blindly.

---

# 13 – Taxonomy Alignment Template

Goal:

Ensure vsme_datapoint catalog matches VSME taxonomy.

Verify:

- report.vsme_taxonomy_version
- vsme_datapoint completeness
- no orphan disclosure_question.vsme_datapoint_id
- no duplicate datapoints
- answer_type aligned with datapoint value_type

Return:

- audit SQL
- mismatch list
- correction script

Never approximate taxonomy compliance.

---

# 14 – Conditional Behaviour Debug Template

Bug:

<conditional behavior issue>

Observed:

<actual runtime behavior>

Expected:

<expected behavior>

Verify:

1. metadata rows exist
2. frontend loads metadata
3. ID-based matching used
4. single source of truth visibility function
5. render logic uses same visibility state

Return:

- root cause
- minimal fix
- cleanup steps

Never hardcode question-code mappings if DB metadata exists.

---

# 15 – Table Style Section / Multi Member Datapoint Pattern

Used for sections like B3 energy tables.

Goal:

<precise behaviour>

Examples:

- subtotal recomputation
- grand total persistence
- explicit zero support
- deterministic clearing

Constraints:

- must not redefine scope
- must not redefine progress
- must not introduce alternate storage model
- disclosure_answer remains source of truth
- zero must be handled explicitly

Return:

- frontend patch
- persistence rules
- SQL validation queries

---

# 16 – Safe Change Philosophy

Prefer:

- additive schema changes
- versioned RPC evolution
- deterministic DB logic
- minimal UI patches
- explicit auditability
- taxonomy version traceability

Avoid:

- destructive schema changes
- silent contract changes
- frontend workarounds for DB logic
- bypassing RPC
- weakening RLS
- heuristic matching instead of ID matching

DB and RPC remain the single source of truth.