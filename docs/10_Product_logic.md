# 10 – PRODUCT LOGIC (VSME Reporting)

This document defines the **product-level rules** for the VSME reporting experience.

It describes how the reporting UI behaves from the user perspective.

Technical architecture and DB schema are documented elsewhere.

---

# 1. Core Reporting Principle

The platform is a **guided ESG reporting tool for SMEs**, not a compliance enforcement engine.

Key design goals:

- simple answering UX
- deterministic progress
- non-blocking export
- proportional reporting logic aligned with VSME

Users can always export their report.

Missing answers are visible but **do not block export**.

The system guides completion but does not enforce compliance gates.

---

# 2. Question States

Each question can be in one of three states.

### Answered

User provided a valid value.

Detected when any typed value exists:

- value_text
- value_numeric
- value_integer
- value_date
- value_boolean

OR when the answer is explicitly marked as N/A.

---

### Not Applicable (N/A)

User explicitly marks the question as not applicable.

Stored as:

value_jsonb → { "na": true }

N/A counts as completed.

---

### Missing

Question has:

- no typed value
- not marked as N/A

Missing means the question still requires user attention.

---

# 3. Completion Logic

Completion is calculated as:

Completed = Answered + N/A

Missing = Total − Completed

Progress % = Completed / Total

Important rule:

N/A **counts as completed**.

Completion logic is derived from **DB state only**.

---

# 4. Progress Scope

Progress is computed at multiple levels.

### Section level

Example:

B1 – Basis for preparation

Completion uses only questions belonging to that section.

---

### Group level

Example group:

General Information

Completion aggregates:

- B1
- B2
- C1
- C2

Group progress is derived from section progress.

---

### Report level

Report progress uses **all in-scope questions**.

Displayed in the **Report status card**.

---

# 5. Progress Authority

Progress logic is computed in RPC:

get_vsme_ctas_for_report

UI must not recompute progress independently.

UI may optimistically update local state but must reconcile with RPC results.

RPC remains the authoritative source of truth.

---

# 6. Live Progress Updates

Progress updates immediately when:

- answer is saved
- answer is deleted
- N/A is toggled

UI updates local state immediately.

After refresh or navigation, progress is reloaded from RPC.

---

# 7. Save Strategy

Answers are saved using:

onBlur

Behavior:

1. User edits field  
2. Field loses focus  
3. Save request is sent  
4. Local UI updates completion  

This keeps the UI fast and reduces explicit save actions.

---

# 8. Section Navigation

Sections panel provides structured navigation.

Hierarchy:

Section groups  
→ Sections  
→ Questions

Example:

General Information  
→ B1 – Basis for preparation  
→ B2 – Practices, policies & future initiatives

Sections can be expanded or collapsed.

Section visibility rules:

Sections with **0 in-scope questions are hidden**.

Section lists must be derived from the RPC dataset returned by:

get_vsme_questions_for_report_v2

---

# 9. Sticky Section Header

Each section page includes a sticky header with:

- Section title
- Answered count
- N/A count
- Missing count
- Completion %

The header stays visible while scrolling.

Sticky header is informational only.

Progress values are derived from RPC-derived state.

---

# 10. Units

Numeric questions may display a unit.

Unit source:

vsme_datapoint.unit

Examples:

EUR  
MWh  
kg  
count  

Units are informational and displayed next to inputs.

UI must always display the **unit returned by RPC**.

UI must never infer units from question text.

---

# 11. Export Philosophy

Export is always available.

Before export the system may show:

- Completion %
- Missing items
- Major reporting gaps

But export remains possible.

Goal:

**guidance rather than enforcement.**

Exports always reflect the **current report snapshot**.

---

# 12. Company Profile Prefill

Some questions overlap with **company profile information**.

Examples:

- company legal name  
- address  
- city  
- postal code  
- country  
- registration number  
- VAT number  

If these fields exist in the company profile, the system may **prefill missing report answers**.

Prefill behavior:

- only applies to **missing answers**
- never overwrites typed answers
- applies only to **open / non-submitted reports**

Prefill is executed via RPC:

prefill_company_profile_into_open_reports

---

# 13. Prefill Indicator

If an answer originates from company profile data, the UI may show:

Prefilled from company profile.

Indicator is based on metadata:

value_jsonb.source = "company_profile"

This is informational only.

It does not affect progress.

---

# 14. Editing Prefilled Answers

Users may freely edit prefilled values.

When edited:

- the value becomes a normal user answer
- user-entered value takes precedence

Prefill never locks inputs.

---

# 15. Report Snapshot Principle

Reports represent a **snapshot of answers at the time of reporting**.

Changing company profile data later **does not modify existing report answers**.

This guarantees:

- historical consistency
- reproducible reports
- stable exports

Company profile data assists only with **initial report population**.

---

# 16. Section Visibility Rules

Sections must be derived from the RPC dataset.

Rule:

A section is displayed only if:

total_questions > 0

Sections with:

0 / 0 questions

must not appear in navigation.

Prev / Next navigation must follow the same in-scope section list.

---

# 17. Deterministic Scope

Question scope is determined exclusively by report configuration:

- report.framework
- report.vsme_mode
- report.vsme_pack_codes
- report.vsme_taxonomy_version

Scope computation happens in RPC:

get_vsme_questions_for_report_v2

UI must not infer scope.

UI must not filter questions independently.

---

# 18. Questionnaire Interaction Metadata

Questionnaire UX behavior may be influenced by metadata tables:

- question_group
- question_group_item
- question_interaction_rule

These define:

- grouped question layouts
- conditional child questions
- paired question rendering
- UX interaction rules

Important:

These tables **do not define scope or progress**.

They only shape how in-scope questions are rendered.

---

# 19. UX Design Principle

The reporting experience should feel:

- simple
- calm
- transparent

The user should always understand:

- what is missing
- what is completed
- what is optional

The system guides the user toward completion without introducing compliance barriers.

---

END OF DOCUMENT