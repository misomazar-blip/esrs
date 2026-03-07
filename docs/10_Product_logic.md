# 10 – PRODUCT LOGIC (VSME Reporting)

This document defines the **product-level rules** for the VSME reporting experience.

It describes how the reporting UI behaves from the user perspective.

Technical architecture and DB schema are documented elsewhere.

---

# 1. Core Reporting Principle

The platform is a **guided reporting tool for SMEs**, not a compliance enforcement engine.

Key design goals:

- simple answering UX
- deterministic progress
- non-blocking export
- proportional reporting logic (aligned with VSME)

Users can always export their report.

Missing answers are shown but **do not block export**.

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

---

### Not Applicable (N/A)

User explicitly marks the question as not applicable.

Stored as:

value_jsonb → { "na": true }

---

### Missing

Question has:

- no value
- not marked as N/A

---

# 3. Completion Logic

Completion is calculated as:

Completed = Answered + N/A

Missing = Total − Completed

Progress % = Completed / Total

Important:

N/A **counts as completed**.

---

# 4. Progress Scope

Progress is computed at multiple levels.

### Section level

Example:

B1 – Basis for preparation

Completion uses questions in that section only.

---

### Group level

Example:

General Information

Completion aggregates:

- B1
- B2
- C1
- C2

---

### Report level

Report progress uses **all in-scope questions**.

Displayed in the **Report status card**.

---

# 5. Live Progress Updates

Progress updates immediately when:

- answer is saved
- answer is deleted
- N/A is toggled

UI updates local state immediately.

Server remains the **source of truth** after refresh.

---

# 6. Save Strategy

Answers are saved using:

onBlur

Behavior:

1. User edits field  
2. Field loses focus  
3. Save request is sent  
4. Local UI updates completion  

This keeps the UI fast and reduces explicit save actions.

---

# 7. Section Navigation

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

---

# 8. Sticky Section Header

Each section page includes a sticky header with:

Section title  
Answered count  
N/A count  
Missing count  
Completion %

This header stays visible while scrolling.

---

# 9. Units

Numeric questions may display a unit.

Unit source:

vsme_datapoint.unit

Examples:

EUR  
MWh  
kg  
count  

Units are informational and displayed next to inputs.

---

# 10. Export Philosophy

Export is always available.

Before export the system may show:

Completion %  
Missing items

But the user can still export.

The goal is:

**guidance, not blocking compliance.**

---

# 11. Company Profile Prefill

Some questions overlap with **company profile information**.

Examples include:

- company legal name  
- address  
- city  
- postal code  
- country  
- registration number  
- VAT number  

If these fields are already filled in the company profile, the system may **prefill missing answers** in the report.

Prefill behavior:

- Only applies to **missing answers**
- Never overwrites existing typed answers
- Applies only to **open / non-submitted reports**

Prefill is performed via server RPC.

---

# 12. Prefill Indicator

If an answer originates from company profile data, the UI may display an informational hint:

Prefilled from company profile.

This hint is based on metadata stored in:

value_jsonb.source = "company_profile"

The hint is informational only and does not affect completion logic.

---

# 13. Editing Prefilled Answers

Users may freely edit values that were prefilled.

When edited:

- the value becomes a normal user answer
- the user value takes precedence over company profile data

Prefill never locks fields.

---

# 14. Report Snapshot Principle

Reports represent a **snapshot of answers at the time of reporting**.

Changing company profile data later **does not modify existing report answers**.

This ensures:

- historical consistency
- reproducible reports
- stable exports

Company profile data only assists with **initial data entry**.

---

# 15. Design Principle

The reporting experience should feel:

- simple
- calm
- transparent

The user should always understand:

- what is missing
- what is completed
- what is optional