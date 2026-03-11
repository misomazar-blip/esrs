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

| id                      | unit |
|-------------------------|------|
| Assets                  | EUR  |
| TotalWaterConsumption   | m3   |
| TotalEnergyConsumption  | MWh  |
| TotalWasteGeneratedMass | kg   |

This defines the correct VSME unit globally.

This is framework metadata.

NOT report-specific.

---

# 3. Unit Resolution Order (RPC Contract)

RPC used by UI:

get_vsme_questions_for_report_v2

Unit must be resolved inside RPC using:

coalesce(
  disclosure_answer.unit,
  vsme_datapoint.unit,
  disclosure_question.unit
) as unit

Priority:

1. disclosure_answer.unit  
   optional per-report override (rare, not used in MVP)

2. vsme_datapoint.unit  
   canonical source of truth

3. disclosure_question.unit  
   legacy fallback only

UI must rely only on the RPC-returned unit.

Unit logic must never be implemented client-side.

---

# 4. MVP Rule: disclosure_answer.unit is NOT used

For MVP implementations:

disclosure_answer.unit remains NULL.

All unit resolution comes from:

vsme_datapoint.unit

This ensures:

- deterministic unit behavior
- no per-report unit drift
- export consistency
- simplified client logic

Future versions may support report-specific unit overrides.

This is intentionally disabled in MVP.

---

# 5. Currency Model

Currency is handled via datapoint:

template_currency

Stored as:

disclosure_answer.value_text

Example values:

EUR  
USD  
CZK  

template_currency itself has:

vsme_datapoint.unit = NULL

It defines **reporting currency context only**.

Other monetary datapoints still use their canonical unit:

vsme_datapoint.unit = EUR

Example:

Assets → unit EUR  
Revenue → unit EUR  

Important architectural rule:

vsme_datapoint.unit remains the canonical unit contract.

template_currency defines the **display currency context for the report**, not the canonical datapoint unit.

UI may display:

value + template_currency

Example display:

15000000 EUR

Important:

Stored numeric values remain unit-agnostic.

Currency context is purely presentation logic.

Currency does NOT override vsme_datapoint.unit.

---

# 6. Unit Scope

Units belong to datapoints.

NOT to questions.  
NOT to answers.  
NOT to reports.

Mapping chain:

vsme_datapoint.id  
→ vsme_datapoint.unit  
→ disclosure_question.vsme_datapoint_id  
→ RPC resolves unit  
→ UI displays unit

This guarantees consistent unit usage across reports.

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

- question_text
- example_answer
- user input

---

# 9. UI Contract

UI must:

Display the unit returned from RPC.

Example:

value: 15000000  
unit: EUR

Display:

15000000 EUR

UI must NOT:

- infer currency
- derive units from template_currency
- guess units
- hardcode units

RPC is authoritative.

---

# 10. Export Contract (Future XBRL)

Units will map to XBRL units.

Example mappings:

EUR → iso4217:EUR  
kg → xbrli:kg  
m3 → xbrli:m3  
MWh → custom energy unit mapping  

Correct unit definition is required for valid XBRL export.

This contract ensures export compatibility.

---

# 11. Validation Queries

Audit datapoints without unit:

select id
from vsme_datapoint
where unit is null
and id not in ('template_currency');

Expected result:

0 rows

---

Audit numeric datapoints without unit:

select id, value_type, unit
from vsme_datapoint
where value_type in ('numeric','integer')
and unit is null;

Expected result:

0 rows

---

# 12. Guardrails

Never:

- store unit only in disclosure_question
- derive unit in UI
- allow inconsistent units per report
- change unit per answer

Always:

- define unit in vsme_datapoint
- resolve unit via RPC
- treat vsme_datapoint.unit as canonical

---

# 13. Summary

Unit authority:

vsme_datapoint.unit

Resolution layer:

RPC get_vsme_questions_for_report_v2

UI responsibility:

Display only.

Never compute.

This guarantees:

- deterministic reporting
- correct exports
- VSME alignment
- stable architecture

---

END OF DOCUMENT