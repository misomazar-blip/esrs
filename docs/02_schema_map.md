# 02 – DATABASE SCHEMA MAP (VSME Reporting SaaS)

This document explains **how the database model is used by the application layer**.

It is not a raw schema dump.

For physical schema definitions see:

* `02_db_schema.sql`

For RPC contracts see:

* `03_rpc_contracts.md`

---

# 1. DOMAIN OVERVIEW

The system contains two primary data domains:

### A) Tenant-owned operational data

Scoped per company.

Protected by **Row Level Security (RLS)**.

Tables:

* company
* company_member
* company_member_topic_access
* report
* disclosure_answer

These contain **company reporting data**.

---

### B) Shared framework/catalog metadata

Global reference data.

Readable by authenticated users.

Tables:

* disclosure_question
* topic
* vsme_datapoint
* report_pack
* vsme_datapoint_pack

These define the **reporting framework itself**.

They are **not company-owned data**.

---

# 2. TENANT DOMAIN (Company Data)

These tables store company-owned reporting data.

### company

Represents a tenant organization.

---

### company_member

Defines membership and roles.

Roles:

* owner
* admin
* editor
* viewer

Membership determines report access.

---

### company_member_topic_access

Defines **topic-level permissions**.

Controls which users may:

* view
* edit

specific reporting topics.

---

### report

Represents a reporting instance for:

* company_id
* reporting_year

Report configuration also defines the **VSME scope model**.

Important fields:

* framework
* vsme_mode
* vsme_pack_codes
* vsme_taxonomy_version

---

### disclosure_answer

Stores answers to questions.

Identity constraint:

```
(report_id, question_id)
```

Each question has **at most one answer per report**.

---

# 3. FRAMEWORK CATALOG DOMAIN

Framework catalog tables define **what is asked**, not **what is answered**.

---

### disclosure_question

Master catalog of questions.

Shared by:

* ESRS
* VSME

Key fields:

* framework
* question_text
* topic_id
* section_code
* vsme_datapoint_id

Additional UX metadata:

* guidance_text
* example_answer

These fields:

* do NOT affect scope
* do NOT affect validation
* do NOT affect progress
* do NOT affect export readiness

They exist purely for **guided reporting UX**.

---

### topic

Logical grouping of questions.

Topics are used for:

* navigation
* access control
* reporting organization

---

### vsme_datapoint

Defines canonical datapoints aligned with the **VSME taxonomy**.

Each datapoint defines:

* semantic meaning
* value_type
* canonical unit

Units are defined in:

```
vsme_datapoint.unit
```

This is the **canonical source of truth for units**.

---

# 4. VSME SCOPE MODEL

The scope of questions in a report is determined deterministically from:

* report.framework
* report.vsme_mode
* report.vsme_pack_codes
* report.vsme_taxonomy_version
* vsme_datapoint_pack
* disclosure_question.section_code

Scope logic is implemented **only in RPC functions**.

UI must never compute scope itself.

---

## 4.1 VSME Modes

### core

Includes sections:

```
B*
```

---

### core_plus

Includes:

* core sections (B*)
* datapoints from selected add-on packs

---

### comprehensive

Includes:

* core sections (B*)
* all comprehensive sections (C*)

Add-on packs are ignored in comprehensive mode.

---

## 4.2 Add-on Packs

Add-on packs extend the reporting scope.

Tables:

### report_pack

Catalog of available packs.

---

### vsme_datapoint_pack

Mapping table:

```
datapoint_id ↔ pack_code
```

Questions connect to datapoints via:

```
disclosure_question.vsme_datapoint_id
```

Scope expansion is always computed in **database logic**.

UI must never compute scope.

---

# 5. RPC SOURCE OF TRUTH

Application logic relies on **RPC functions for deterministic behavior**.

---

## get_vsme_questions_for_report_v2(report_id)

Responsible for:

* computing scope
* expanding datapoint packs
* ordering questions
* returning existing answers
* resolving units
* returning guidance_text
* returning example_answer

This RPC is the **single source of truth for**:

* question list
* section membership
* in-scope questions

UI must not recompute scope.

---

## get_vsme_ctas_for_report(report_id)

Responsible for:

* computing completion percentage
* answered count
* missing count
* readiness signals

Used by:

* report dashboard
* export modal
* progress indicators

---

### Determinism Requirement

Same report configuration + same database state
must always produce the **same RPC output**.

Client-side filtering or recomputation is not allowed.

---

# 6. ANSWER STORAGE MODEL

Answers are stored in:

```
disclosure_answer
```

Typed value columns:

* value_text
* value_numeric
* value_integer
* value_date
* value_boolean

Optional metadata:

* unit
* notes
* data_quality

---

### N/A representation

N/A is stored as:

```
value_jsonb -> { "na": true }
```

When NA = true:

typed value columns are ignored.

---

### Unit Resolution

Units are resolved in RPC.

Canonical source:

```
vsme_datapoint.unit
```

Resolution order:

```
coalesce(
  disclosure_answer.unit,
  vsme_datapoint.unit,
  disclosure_question.unit
)
```

UI must always use the **RPC-returned unit**.

---

# 7. ANSWER STATE MODEL

Question state definitions:

### Answered

Valid typed value present.

---

### N/A

```
value_jsonb.na = true
```

---

### Missing

No value stored and not marked N/A.

---

### Progress Rule

Completion ratio:

```
(Answered + NA) / total_in_scope
```

N/A counts as answered.

---

# 8. UI PAGE → DATA MODEL MAP

---

## Report Sections page

Route:

```
/reports/[id]/sections/[sectionCode]
```

Uses:

* get_vsme_questions_for_report_v2
* get_vsme_ctas_for_report

Responsible for:

* rendering questions
* saving answers
* displaying progress
* section navigation

---

## Report Settings page

Route:

```
/reports/[id]/settings
```

Allows user to change:

* report.vsme_mode
* report.vsme_pack_codes

Packs loaded from:

```
report_pack
```

After saving scope:

questions are recalculated via:

```
get_vsme_questions_for_report_v2
```

---

## Questions debug panel

Report Settings page contains a collapsible

**"Questions overview" panel.**

Purpose:

* support/debug view
* export troubleshooting

Shows:

* question_text
* section_code
* answer_state
* answer_preview

This panel is **not part of the normal user flow**.

---

# 9. SECTION STRUCTURE

Sections are derived entirely from the RPC dataset.

Rules:

Show section only if:

```
total_questions > 0
```

Hide sections with:

```
0 / 0 questions
```

Section ordering follows deterministic

```
section_code ordering
```

---

# 10. SECURITY MODEL

Tenant isolation enforced via:

**Row Level Security (RLS)**.

Access determined by:

* company_member
* company_member_topic_access

No cross-company access is permitted.

Catalog tables remain readable to authenticated users.

---

# 11. DESIGN PRINCIPLES

Application architecture follows three rules:

1. **DB defines structure**
2. **RPC defines logic**
3. **UI renders state**

UI must not redefine:

* scope
* progress
* unit resolution
* taxonomy alignment

All business logic must remain in the database layer.

---

END OF SCHEMA MAP
