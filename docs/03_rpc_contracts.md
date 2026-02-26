# 03 – RPC CONTRACTS (Source of Truth)

This file defines the exact data contracts between:

- Supabase RPC
- UI (Next.js client components)
- Progress / readiness logic

DB/RPC are the source of truth.  
UI must not reinterpret scope, answer state, or progress logic.

---

## Conventions

- Scope, progress, and readiness are computed from DB state only.
- Scope authority is defined by:
  - `report.framework`
  - `report.vsme_mode`
  - `report.vsme_pack_codes`
- Topic permissions are enforced via RLS backed by `company_member_topic_access`.
- UI may update optimistically, but must reconcile with RPC-confirmed results.
- No implicit client-side filtering.
- No hidden heuristics.
- Avoid `select *` in RPC return shapes (explicit columns only).
- RPC functions must not bypass RLS.

---

# 1. get_vsme_questions_for_report(p_report_id uuid)

## Purpose

Return the deterministic in-scope VSME question list for a report,
including existing answers.

This function defines the authoritative VSME question scope.

---

## Scope Authority (Report-level)

Scope is computed strictly per report based on:

- `report.framework`
- `report.vsme_mode`
- `report.vsme_pack_codes`

No global company-level configuration affects VSME scope.

---

## Scope Logic (DB-driven)

Report configuration:

- `framework = 'VSME'`
- `vsme_mode ∈ ('core','core_plus','comprehensive')`
- `vsme_pack_codes = text[]`

Mode semantics:

### core

All VSME questions where:

    section_code LIKE 'B%'

### core_plus

Core (B%)  
+ questions included via selected packs:

    vsme_datapoint_pack.pack_code ∈ report.vsme_pack_codes
    AND
    vsme_datapoint_pack.datapoint_id = disclosure_question.vsme_datapoint_id

### comprehensive

Core (B%)  
+ Comprehensive sections (C%)

Materiality logic is NOT applied in VSME.

Topic permissions are enforced via RLS backed by
`company_member_topic_access`.

---

## Returns (per row)

| Field | Type |
|-------|------|
| question_id | uuid |
| code | text |
| question_text | text |
| answer_type | text |
| order_index | integer |
| section_code | text |
| vsme_level | text |
| vsme_datapoint_id | text |
| config_jsonb | jsonb |
| value_boolean | boolean |
| value_text | text |
| value_number | numeric |
| value_integer | integer |
| value_numeric | numeric |
| value_date | date |
| value_jsonb | jsonb |
| unit | text |
| updated_at | timestamptz |

---

## Determinism Requirement

Same report configuration + same DB state  
→ same question list.

Client must not re-filter scope.

---

# 2. get_vsme_ctas_for_report(p_report_id uuid)

## Purpose

Return deterministic progress and readiness summary for the report.

This function MUST derive totals from the same eligible question set
as `get_vsme_questions_for_report`.

---

## Answer State Model (Authoritative)

N/A is represented explicitly as:

    value_jsonb -> { "na": true }

No other implicit interpretation of NULL values is allowed.

### Answered

- Valid value stored in the correct typed column
  according to `answer_type`
OR
- `value_jsonb.na = true`

### Missing

- In-scope AND not answered

### N/A

- Explicit `value_jsonb.na = true`
- Counted as Answered

---

## Completion Formula

    (Answered + N/A) / (In-scope questions)

---

## Aggregation Consistency Requirement

Overall totals MUST equal sum of section totals:

- overall.total = sum(sections.total)
- overall.answered = sum(sections.answered)
- overall.missing = sum(sections.missing)

Any deviation indicates a scope or aggregation bug.

---

## Returns (JSON)

```json
{
  "sections": [
    {
      "section_code": "B1",
      "total": 30,
      "answered": 11,
      "missing": 19,
      "progress_ratio": 0.36,
      "last_updated_at": "timestamp"
    }
  ],
  "overall": {
    "total": 120,
    "answered": 85,
    "missing": 35,
    "progress_ratio": 0.71
  },
  "continue_section_code": "B1",
  "suggested_section_code": "B2"
}
```

Export readiness must be informative and never blocking.

---

# 3. Security Model

Access control is enforced by:

- Row Level Security (RLS)
- `company_member_topic_access`
- report/company membership rules

RPC functions must not bypass RLS.

If SECURITY DEFINER is used,
explicit role and membership checks must be performed inside the function.

---

# 4. Single Source of Truth

Scope, progress and readiness logic MUST be computed in DB.

UI:

- may optimistically update local state
- must reconcile with RPC-confirmed state after writes
- must not duplicate missing rules
- must not redefine scope client-side

If business logic changes:

1. Update RPC
2. Update this file
3. Do NOT patch logic in UI only

---

# 5. Related / Supporting Functions (Reference)

## VSME eligibility

- `fn_check_vsme_eligibility(p_balance_sheet_k numeric, p_net_turnover_k numeric, p_employees integer)`
- `fn_vsme_category(p_balance_sheet_k numeric, p_net_turnover_k numeric, p_employees integer)`

## Access helpers (SECURITY DEFINER = true)

- `user_has_company_access(p_user_id uuid, p_company_id uuid)`
- `is_company_member(p_company_id uuid)`
- `has_company_role(p_company_id uuid, p_roles text[])`
- `user_can_view_topic(p_user_id uuid, p_company_id uuid, p_topic_id uuid)`
- `user_can_edit_topic(p_user_id uuid, p_company_id uuid, p_topic_id uuid)`
- `get_company_members_with_emails(p_company_id uuid)`

## ESRS/versioning (future)

- `get_active_esrs_version()`
- `get_questions_for_version(p_topic_id uuid, p_version_id uuid)`
- `migrate_report_to_version(p_report_id uuid, p_new_version_id uuid)`
- `find_equivalent_question(p_old_question_id uuid, p_new_version_id uuid)`

## XBRL (future)

- `fn_generate_xbrl_fact_xml(p_answer_id uuid, p_taxonomy_id uuid)`
- `fn_validate_xbrl_completeness(p_report_id uuid, p_taxonomy_id uuid)`