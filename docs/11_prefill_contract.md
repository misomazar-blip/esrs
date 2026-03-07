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

---

# 2. Prefill RPC

Current implementation:

prefill_company_profile_into_open_reports(company_id)

This RPC scans open reports belonging to the company and fills
missing answers when appropriate.

---

# 3. Eligibility Rules

Prefill applies only when:

- report.framework = 'VSME'
- report.status != 'submitted'
- answer is missing

Prefill must never run on submitted reports.

---

# 4. Overwrite Protection (CRITICAL)

Prefill must never overwrite existing user answers.

Allowed:

- create answer row if none exists
- fill empty typed value columns

Not allowed:

- replace user-entered values
- overwrite typed columns containing data

User answers always take precedence.

---

# 5. Provenance Tracking

Prefilled values must include metadata:

value_jsonb.source = "company_profile"

Example:

{
  "source": "company_profile"
}

This allows UI to display informational hints.

---

# 6. JSON Merge Rule

When writing metadata, JSON must always be merged.

Correct:

coalesce(existing_jsonb,'{}'::jsonb) || jsonb_build_object('source','company_profile')

Incorrect:

value_jsonb = '{ "source": "company_profile" }'

Overwriting JSON would destroy other metadata such as:

- na flag
- other future metadata

---

# 7. Report Snapshot Principle

Reports represent historical snapshots.

Changing company profile data must not modify
existing report answers automatically.

Prefill assists with initial population only.

---

# 8. Future Prefill Extensions

Additional prefill mappings may include:

- company address
- city
- postal code
- country
- VAT number
- company identifier

All mappings must follow the same overwrite protection rules.

---

# END OF CONTRACT