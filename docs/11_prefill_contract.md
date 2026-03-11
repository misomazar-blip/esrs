# 11 – PREFILL CONTRACT

This document defines deterministic prefill behaviour for VSME reports.

Prefill is a **convenience feature** that assists users by copying
known company profile data into report answers.

Prefill must never modify the reporting logic.

---

# 1. Purpose

Prefill populates missing answers using data from the company profile.

Example:

company.name → reporting entity legal name

Prefill improves UX by reducing duplicate manual entry.

Prefill is **not a reporting authority**.

Scope, progress, and readiness are determined entirely by RPC logic.

---

# 2. Prefill RPC

Current implementation:

prefill_company_profile_into_open_reports(company_id)

This RPC scans open reports belonging to the company and fills
missing answers when appropriate.

The RPC operates **deterministically** using predefined mappings between:

- company profile fields
- VSME datapoints
- disclosure_question entries

Client code must never implement its own prefill logic.

Prefill logic must remain **server-controlled and catalog-driven**.

---

# 3. Eligibility Rules

Prefill applies only when:

- report.framework = 'VSME'
- report.status != 'submitted'
- answer is missing

Definition of missing:

- no disclosure_answer row exists  
OR
- row exists but contains no typed value
AND
- value_jsonb.na is not true

Typed value columns include:

- value_text
- value_numeric
- value_integer
- value_date
- value_boolean

Prefill must never run on submitted reports.

Submitted reports are treated as immutable snapshots.

---

# 4. Overwrite Protection (CRITICAL)

Prefill must never overwrite existing user answers.

Allowed:

- create answer row if none exists
- populate typed value column when empty

Not allowed:

- replace user-entered values
- overwrite typed columns containing data

If any typed value exists, prefill must **skip that answer**.

User answers always take precedence.

---

# 5. Provenance Tracking

Prefilled values must include metadata:

value_jsonb.source = "company_profile"

Example:

{
  "source": "company_profile"
}

This metadata allows the UI to display informational hints such as:

Prefilled from company profile.

This metadata does not affect:

- completion logic
- validation
- export readiness
- scope determination

---

# 6. JSON Merge Rule

When writing metadata, JSON must always be merged.

Correct pattern:

coalesce(existing_jsonb,'{}'::jsonb)  
|| jsonb_build_object('source','company_profile')

Incorrect pattern:

value_jsonb = '{ "source": "company_profile" }'

Overwriting JSON would destroy other metadata such as:

- na flag
- existing source metadata
- future metadata fields

JSON metadata must always be treated as a **mergeable object**.

---

# 7. Report Snapshot Principle

Reports represent historical snapshots.

Changing company profile data must not modify
existing report answers automatically.

Prefill assists with **initial population only**.

After a value exists in the report snapshot,
that value becomes authoritative for the report.

---

# 8. Prefill Execution Timing

Prefill is typically triggered after a **company profile update**.

Typical flow:

1. User updates company profile  
2. Company row is saved  
3. Backend calls:

prefill_company_profile_into_open_reports(company_id)

4. Missing answers in open reports may be filled

Prefill is **not executed continuously** during normal report editing.

---

# 9. Prefill Scope (Current MVP)

Current mappings focus primarily on **identity fields**.

Typical examples:

- company legal name
- company address
- city
- postal code
- country code
- company identification number
- VAT number

These typically correspond to **B1 onboarding questions**.

Mapping is intentionally limited to avoid unintended overwrites.

---

# 10. Future Prefill Extensions

Additional prefill mappings may include:

- employee count
- balance sheet total
- net turnover
- industry classification
- company size indicators

All mappings must follow the same overwrite protection rules.

Future extensions must remain:

- deterministic
- datapoint-driven
- server-controlled

Client-side heuristics must never be introduced.

---

# 11. Determinism Requirement

Prefill must always produce the same result given the same inputs:

- company row
- report configuration
- question catalog
- existing answers

No randomness or heuristics are allowed.

This guarantees:

- predictable behaviour
- reproducible report state
- safe debugging

---

# 12. Separation of Responsibilities

Company profile (`company` table):

Stores **current organization data**.

Report answers (`disclosure_answer`):

Store **report snapshot data**.

Prefill only bridges the two during initial population.

The two data domains must remain logically separate.

---

# 13. RPC Authority

Prefill must never influence:

- reporting scope
- progress calculation
- section visibility
- export readiness

These are determined exclusively by RPC functions such as:

get_vsme_questions_for_report_v2  
get_vsme_ctas_for_report

Prefill only affects **initial answer population**.

---

END OF CONTRACT