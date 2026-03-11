# 09 – KNOWN LIMITS / INTENTIONAL DEBTS

This document records known architectural limits and intentional technical debts.

These items are **documented consciously** and are **not bugs** unless explicitly stated.

Do not “fix” them during normal feature work unless the change is explicitly approved and the architecture documents are updated.

---

# 1) Next.js App Router params hydration

Next.js App Router sometimes delivers params asynchronously in client components.

Current approach:

Client components normalize params defensively.

Example pattern:

const params = useParams<{ locale: string; id: string; sectionCode: string }>();

const reportId = typeof params.id === 'string' ? params.id : '';
const sectionCode =
  typeof params.sectionCode === 'string'
    ? params.sectionCode.toUpperCase()
    : '';

SSR purity is not currently a priority.

Goal:

- stable client-side behavior
- predictable hydration
- minimal runtime errors

This is acceptable for the current architecture.

---

# 2) disclosure_answer unique constraint duplication

The database currently contains **two UNIQUE constraints** on:

(report_id, question_id)

Example:

- disclosure_answer_report_id_question_id_key
- unique_disclosure_answer

These constraints are redundant but harmless.

Rules:

- Do NOT add a third constraint
- Do NOT attempt to “clean this up” during feature work
- Do NOT drop constraints without full migration planning

Schema is considered **stable**.

---

# 3) Attachments / comments RLS model

Tables affected:

- question_attachment
- question_comment

Some RLS policies currently gate access using:

company.user_id

instead of the newer membership model:

company_member

Impact:

- access logic may not fully respect role-based membership
- editors/admins may not always have expected access
- access model is inconsistent with the rest of the system

Future fix should:

- migrate policies to company_member-based access
- optionally align with topic permissions

Important:

Do not silently change RLS behavior without updating:

- 05_rls_policies.md
- test matrix
- migration plan

---

# 4) Company profile vs report snapshot model

Company data (table `company`) represents **current master data**.

Reports are **snapshots**.

Report answers live in:

disclosure_answer

Therefore:

- changing company profile data does NOT update historical report answers
- reports remain stable historical records

Company profile data may only be used for:

**prefill of missing answers**.

Prefill occurs via RPC:

prefill_company_profile_into_open_reports(company_id)

This preserves:

- report integrity
- auditability
- deterministic exports

---

# 5) Prefill RPC scope limitations

Helper RPC:

prefill_company_profile_into_open_reports(company_id)

Currently pre-fills only **selected overlapping company fields**, primarily:

- B1 identity fields
- company address information
- registration identifiers

The mapping between company fields and questions is intentionally:

- limited
- deterministic
- datapoint-driven

Future extensions may expand coverage.

Requirements for expansion:

- deterministic mapping
- no client heuristics
- never overwrite typed answers

---

# 6) Prefill does not affect submitted reports

Prefill RPC intentionally ignores reports where:

report.status = 'submitted'

Submitted reports are treated as **immutable snapshots**.

Changing company profile data must never modify:

- submitted report answers
- historical reporting state

This is a deliberate audit-safety rule.

---

# 7) value_jsonb metadata conventions

Answer metadata is stored in:

disclosure_answer.value_jsonb

Currently used keys include:

- na
- source

Examples:

{ "na": true }

{ "source": "company_profile" }

Example combined:

{ "na": true, "source": "company_profile" }

This metadata model is intentionally **lightweight**.

It is **not versioned**.

Future evolution may introduce:

- stricter metadata schema
- additional metadata keys
- JSON schema validation

---

# 8) JSON merge safety relies on application discipline

Correct metadata updates must **merge JSON objects**, not overwrite them.

Correct pattern:

coalesce(existing_jsonb,'{}'::jsonb) || new_jsonb

Incorrect pattern:

value_jsonb = '{...}'

Incorrect updates may destroy existing metadata.

Currently enforced by:

- development discipline
- code review
- documentation

Future improvement possibility:

Introduce a **DB trigger guardrail** preventing destructive overwrites.

This is not implemented yet.

---

# 9) RPC helper coupling to question catalog

Prefill RPC logic depends on deterministic mapping between:

- company fields
- VSME datapoints
- disclosure_question entries

If the question catalog changes (for example):

- new datapoint codes
- renamed datapoints
- changed mappings

the prefill logic may require updates.

This coupling is intentional because it avoids:

- client-side heuristics
- fuzzy matching
- non-deterministic behavior

Prefill must remain **catalog-driven**.

---

# 10) Deterministic scope authority lives in RPC

Scope determination is centralized in RPC functions, primarily:

get_vsme_questions_for_report_v2

UI must not:

- infer scope
- filter questions independently
- recompute pack logic
- infer section eligibility

All scope rules must live in DB/RPC.

This constraint simplifies:

- debugging
- auditability
- deterministic exports

---

# 11) Pack expansion relies on datapoint mapping

Add-on packs rely on:

vsme_datapoint_pack

Mapping structure:

datapoint_id ↔ pack_code

If pack definitions change, the mapping table must be updated.

UI must never hardcode pack logic.

All pack expansion must happen via RPC joins.

---

# 12) Unit override column exists but is unused

disclosure_answer.unit exists as an optional override column.

However:

MVP rule:

disclosure_answer.unit remains NULL.

Unit resolution currently relies entirely on:

vsme_datapoint.unit

Future versions may support per-report overrides.

This is intentionally not implemented yet to maintain deterministic reporting.

---

# 13) Legacy RPC functions remain temporarily

Legacy RPC:

get_vsme_questions_for_report

Still exists for compatibility.

New features must use:

get_vsme_questions_for_report_v2

Legacy RPC may be removed later once all clients migrate.

Until then:

Do not delete legacy RPC.

---

# 14) Questionnaire interaction metadata is UX-only

Questionnaire interaction metadata tables include:

- question_group
- question_group_item
- question_interaction_rule

These tables define:

- grouped rendering
- pair layouts
- conditional child questions
- questionnaire UX improvements

Important limitation:

They do **not** define scope.

They do **not** define progress.

They do **not** influence export readiness.

They are purely **UX structuring metadata**.

Scope and progress remain controlled by RPC logic.

---

# 15) Schema stability principle

The database schema is currently treated as **stable**.

Normal feature work should not introduce:

- destructive migrations
- column removals
- semantic redefinitions of core tables

Allowed changes must be:

- additive
- backward compatible
- migration-safe

Core tables considered stable:

- company
- report
- disclosure_question
- disclosure_answer
- vsme_datapoint

Any schema-level refactor must be treated as an **explicit architecture change**.

---

END OF DOCUMENT