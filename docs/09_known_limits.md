# Known Limits / Intentional Debts

## 1) Next.js App Router params hydration
We normalize params in client components; SSR purity is not a current goal.

---

## 2) disclosure_answer unique constraint duplication
DB currently has two UNIQUE constraints on (report_id, question_id).

Do not add a third constraint.  
Do not attempt to “clean this up” during normal development.

Schema is considered stable.

---

## 3) Attachments/comments RLS
question_attachment and question_comment may still gate access via company.user_id in some policies.

Future tightening should align access control fully to the company_member model.

---

## 4) Company profile vs report snapshot model
Company data (`company` table) represents **current master data**, not report snapshots.

Report answers are stored independently in:

disclosure_answer

Therefore:

- Changing company profile data does NOT update historical report answers.
- Reports remain stable snapshots.

Company profile data may be used only for **prefill of missing answers** via RPC.

---

## 5) Prefill RPC scope limitations
The helper RPC:

prefill_company_profile_into_open_reports(company_id)

currently targets only **selected overlapping company fields** (primarily B1 identity data).

The mapping between company fields and questions is intentionally limited and deterministic.

Future extensions may expand coverage but must remain:

- deterministic
- datapoint-driven
- safe (never overwrite typed answers)

---

## 6) Prefill does not affect submitted reports
Prefill RPC intentionally ignores reports where:

report.status = 'submitted'

Submitted reports are considered **immutable snapshots**.

Changing company profile data must never modify submitted report answers.

---

## 7) value_jsonb metadata conventions
value_jsonb currently stores lightweight metadata such as:

- na
- source

Example:

{ "na": true }

{ "source": "company_profile" }

This metadata model is intentionally lightweight and not strictly versioned.

Future evolution may introduce a formal metadata schema if additional keys are required.

---

## 8) JSON merge safety relies on application discipline
Correct behavior requires merging JSON metadata instead of overwriting it.

Correct pattern:

coalesce(existing_jsonb,'{}'::jsonb) || new_jsonb

Incorrect pattern:

value_jsonb = '{...}'

Currently this is enforced only by development discipline and documentation.

A stricter DB-level guardrail trigger may be introduced in the future.

---

## 9) RPC helper coupling to question catalog
Prefill RPC relies on deterministic mappings to VSME datapoints/questions.

If the question catalog changes (e.g., new datapoint codes or renamed mappings),
the prefill logic may require updates.

This coupling is intentional to keep prefill deterministic and avoid client-side heuristics.