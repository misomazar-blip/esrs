# 08 – UNIT CONTRACT (VSME Reporting SaaS)

This document defines the authoritative unit model for VSME datapoints.

Units must be deterministic, DB-driven, and aligned with the VSME standard.

UI must never infer, guess, or override units.

---

# 1. Purpose

Ensure that:

- every datapoint uses the correct VSME unit
- units are consistent across reports
- units are deterministic
- unit display is fully DB-driven
- unit logic is not implemented client-side

Canonical source of truth:

vsme_datapoint.unit

---

# 2. Canonical Source of Truth

Authoritative unit source:

vsme_datapoint.unit

Definition:

Each datapoint defines its canonical unit in:

public.vsme_datapoint

Example:

| id | unit |
|----|------|
| Assets | EUR |
| TotalWaterConsumption | m3 |
| TotalEnergyConsumption | MWh |
| TotalWasteGeneratedMass | kg |

This defines the correct VSME unit globally.

This is framework metadata.

NOT report-specific.

---

# 3. Unit Resolution Order (RPC Contract)

RPC:

get_vsme_questions_for_report_v2

Unit must be resolved using:

coalesce(
  disclosure_answer.unit,
  vsme_datapoint.unit,
  disclosure_question.unit
) as unit

Priority:

1) disclosure_answer.unit  
   optional override (rare, not used in MVP)

2) vsme_datapoint.unit  
   canonical source  
   required for numeric datapoints

3) disclosure_question.unit  
   legacy fallback only

UI must rely only on RPC-returned unit.

---

# 4. MVP RULE: disclosure_answer.unit is NOT used

For MVP:

disclosure_answer.unit remains NULL.

All unit resolution comes from:

vsme_datapoint.unit

This ensures:

- consistency
- no per-report unit drift
- deterministic exports

Future versions may support overrides.

Not in MVP.

---

# 5. Currency Model

Currency is handled via datapoint:

template_currency

Stored as:

disclosure_answer.value_text

Example:

EUR  
USD  
CZK  

template_currency itself has:

vsme_datapoint.unit = NULL

It defines reporting currency context.

Other monetary datapoints still have canonical unit:

vsme_datapoint.unit = EUR

UI may display:

value + template_currency

but stored numeric values remain unit-agnostic.

---

# 6. Unit Scope

Units belong to datapoints.

NOT to questions.

NOT to answers.

NOT to reports.

Mapping:

vsme_datapoint.id  
→ vsme_datapoint.unit  
→ disclosure_question.vsme_datapoint_id  
→ RPC returns resolved unit

This ensures:

consistent unit for all reports.

---

# 7. Unit Alignment with VSME Standard

Units must match VSME recommended units.

Examples:

Currency datapoints → EUR  
Water consumption → m3  
Waste mass → kg  
Energy consumption → MWh  
Emissions → tCO2e  
Area → m2  
Count → count  
Percentage → %  

Unit selection is defined at datapoint level.

Never per answer.

Never per report.

---

# 8. Determinism Requirement

Unit resolution must be deterministic.

Same datapoint → same unit.

No client logic allowed.

Unit must always come from RPC.

Never inferred from:

question_text  
example_answer  
user input  

---

# 9. UI Contract

UI must:

Display unit returned from RPC.

Example:

input value: 15000000  
unit: EUR  

display:

15000000 EUR

UI must NOT:

infer currency  
derive unit from template_currency directly  
guess units  

RPC is authoritative.

---

# 10. Export Contract (Future XBRL)

Unit will map to:

xbrl_unit

Mapping example:

EUR → iso4217:EUR  
kg → xbrli:kg  
m3 → xbrli:m3  

Unit correctness is required for valid XBRL export.

This document ensures export compatibility.

---

# 11. Validation Queries

Audit datapoints without unit:

```sql
select id
from vsme_datapoint
where unit is null
  and id not in ('template_currency');
```

Expected:

0 rows

---

Audit numeric datapoints without unit:

```sql
select id, value_type, unit
from vsme_datapoint
where value_type in ('number','numeric','integer')
  and unit is null;
```

Expected:

0 rows

---

# 12. Guardrails

Never:

store unit only in disclosure_question  
derive unit in UI  
allow inconsistent units per report  
change unit per answer  

Always:

define unit in vsme_datapoint  
resolve unit via RPC  
treat vsme_datapoint.unit as canonical  

---

# 13. Summary

Unit authority:

vsme_datapoint.unit

Resolution:

RPC get_vsme_questions_for_report_v2

UI responsibility:

Display only.

Never compute.

This guarantees:

deterministic reporting  
correct exports  
VSME alignment  
stable architecture

---

END OF DOCUMENT