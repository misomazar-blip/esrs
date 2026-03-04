# 07 – PROMPT TEMPLATES (For GPT Collaboration)

This file defines how GPT should be used in this project.

Always reference:

* 00_project_context.md
* 01_architecture.md
* 02_db_schema.sql
* 03_rpc_contracts.md
* 04_answer_contract.md
* 05_rls_policies.md
* 06_debug_playbook.md

Non-negotiables:

* DB schema stable (no destructive changes)
* RLS enforced (never bypass in client)
* Prefer RPC-driven deterministic logic
* RPC contracts are versioned and authoritative

Preferred RPC version for questions:

get_vsme_questions_for_report_v2

Legacy RPC get_vsme_questions_for_report must not be used for new features.

All solutions must preserve:

* deterministic scope
* deterministic unit resolution
* taxonomy-aligned datapoint integrity
* strict separation between metadata and answer state

---

# 1) New GPT thread bootstrap

Paste this into new GPT threads:

You are working on a VSME Reporting SaaS platform.

Read and respect:

* Project context
* Architecture
* DB schema (stable)
* RLS rules
* RPC contracts
* Answer storage contract
* Debug playbook

Critical rules:

* Do NOT propose destructive schema changes.
* Do NOT bypass RLS.
* Prefer deterministic RPC-based solutions.
* Use get_vsme_questions_for_report_v2 for question loading.
* disclosure_question defines metadata.
* disclosure_answer defines answer state.
* vsme_datapoint defines canonical datapoint semantics (including unit).
* report.vsme_taxonomy_version defines taxonomy alignment.

Never mix these responsibilities.

Keep changes minimal and testable.

Current task: <describe task precisely>

---

# 2) Frontend patch request

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

# 3) RPC change request

We are modifying RPC:

<function_name + signature>

Current contract (see 03_rpc_contracts.md):

<paste return shape + rules>

Goal:

<precise change>

Constraints:

* No destructive schema changes
* Do not break existing RPC without versioning
* Add new version instead (v3, etc.) if return shape changes
* Deterministic scope logic only
* Explicit columns only (never SELECT *)
* Must respect report.vsme_taxonomy_version

Provide:

* updated function SQL
* updated contract text for 03_rpc_contracts.md
* test queries (SQL)
* migration-safe approach

Never silently change RPC contract used by frontend.

---

# 4) Question metadata changes

We are modifying disclosure_question metadata.

Fields may include:

guidance_text
example_answer
question_text
config_jsonb
section_code
vsme_level

Constraints:

* Must not affect disclosure_answer
* Must not affect progress logic
* Must not affect scope logic
* Must remain read-only from frontend
* Must respect enforce_vsme_question_type_match trigger

Provide:

* safe SQL update script
* validation queries
* contract update text if needed

Never store metadata in disclosure_answer.

---

# 5) Security tightening (RLS / policies)

We are tightening RLS on:

<table_name>

Current policies:

<paste policies>

Goal:

* prevent unauthorized access
* preserve app functionality

Constraints:

* no schema refactor
* no service role usage in client
* no SECURITY DEFINER bypass unless explicitly audited
* no weakening of existing protections

Provide:

* minimal SQL changes
* safe execution order
* verification queries
* role test checklist

Never weaken RLS for convenience.

---

# 6) RPC version migration

Goal:

Switch frontend safely from legacy RPC to newer version.

Example:

get_vsme_questions_for_report → get_vsme_questions_for_report_v2

Provide:

* minimal frontend patch
* verification steps
* rollback strategy

Never delete legacy RPC immediately.

---

# 7) SECURITY DEFINER audit

Goal:

Find SECURITY DEFINER functions without search_path.

Provide audit SQL:

select proname
from pg_proc
where prosecdef = true;

Fix SQL:

alter function <function>
set search_path = public;

Re-audit SQL.

All SECURITY DEFINER functions must:

* explicitly set search_path
* not bypass RLS unintentionally

---

# 8) Performance audit

Query or RPC:

<query>

Provide:

* EXPLAIN ANALYZE interpretation
* bottleneck identification
* minimal index recommendation
* tradeoffs

Never recommend indexes without evidence.

Never optimize before confirming real bottleneck.

---

# 9) Debug template

Bug:

<exact error>

Observed:

<actual behavior>

Expected:

<expected behavior>

Already verified:

* DB contains expected data
* RPC v2 output checked
* RLS policies checked
* Cache cleared

Provide:

* minimal diagnostic path
* root cause
* minimal fix

Never propose architectural rewrite for isolated bug.

---

# 10) Contract mismatch diagnostic template

Use when frontend fields are undefined.

Verify in order:

1. DB contains values

select guidance_text
from disclosure_question
limit 5;

2. RPC returns values

select guidance_text
from get_vsme_questions_for_report_v2('<report_id>');

3. Frontend calls correct RPC

supabase.rpc('get_vsme_questions_for_report_v2')

4. Frontend types include field

If any layer missing → fix that layer.

Never patch UI blindly.

---

# 11) Taxonomy alignment template

Use when verifying 1:1 alignment with EFRAG VSME taxonomy.

Goal:

Ensure vsme_datapoint catalog matches official taxonomy version.

Verify:

* report.vsme_taxonomy_version
* vsme_datapoint count
* no orphan disclosure_question.vsme_datapoint_id
* no duplicate datapoint IDs
* answer_type aligned with value_type

Provide:

* audit SQL
* mismatch list
* safe correction script

Never “approximate” taxonomy compliance.

---

# 12) Safe change philosophy

Always prefer:

* additive changes
* versioned RPC evolution
* deterministic DB logic
* minimal frontend patches
* explicit auditability
* taxonomy version traceability

Avoid:

* destructive schema changes
* silent contract changes
* frontend workarounds for DB contract issues
* bypassing RPC logic
* weakening RLS

DB and RPC remain the single source of truth.
