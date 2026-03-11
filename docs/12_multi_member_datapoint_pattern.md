PATCH — docs/12_multi_member_datapoint_pattern.md

# MULTI-MEMBER DATAPOINT PATTERN

## Purpose

Some VSME datapoints require dimensional breakdowns.

Example:

Energy consumption split into:

- renewable
- non-renewable
- total

This pattern appears in multiple ESG areas:

- energy
- emissions
- waste
- water
- revenue segmentation

The system implements this using **member datapoints + fact datapoints**.

This document defines the architecture pattern used across the platform.

---

# 1. Concept

A breakdown consists of:

1) member datapoints  
2) fact datapoint

Members represent **dimension values**.

Fact represents the **aggregated numeric value**.

Example:

Electricity consumption.

Member datapoints:

EnergyConsumptionFromElectricity_RenewableEnergyMember  
EnergyConsumptionFromElectricity_NonRenewableEnergyMember

Fact datapoint:

EnergyConsumptionFromElectricity

---

# 2. Datapoint categories

Two datapoint categories exist.

## 2.1 Fact datapoint

Represents a numeric ESG metric.

Example:

EnergyConsumptionFromElectricity

Stored as:

value_numeric

Unit example:

MWh

Answer type:

number

Fact datapoints are:

- exported
- counted in metrics
- used in totals

---

## 2.2 Member datapoint

Represents a **dimension member**.

Example:

EnergyConsumptionFromElectricity_RenewableEnergyMember  
EnergyConsumptionFromElectricity_NonRenewableEnergyMember

Stored as:

value_text

Answer type:

text

Reason:

Members represent **XBRL dimensional context**, not numeric facts.

Members:

- are not exported as standalone metrics
- exist to represent breakdown structure

---

# 3. Example — B3 Energy section

Rows:

Electricity purchased  
Self-generated electricity  
Fuels

Columns:

Renewable  
Non-renewable  
Total

Grand total displayed below the table.

---

## Datapoint mapping

Electricity row:

Member datapoints:

EnergyConsumptionFromElectricity_RenewableEnergyMember  
EnergyConsumptionFromElectricity_NonRenewableEnergyMember

Fact datapoint:

EnergyConsumptionFromElectricity

---

Self-generated electricity row:

Member datapoints:

EnergyConsumptionFromSelfGeneratedElectricity_RenewableEnergyMember  
EnergyConsumptionFromSelfGeneratedElectricity_NonRenewableEnergyMember

Fact datapoint:

EnergyConsumptionFromSelfGeneratedElectricity

---

Fuels row:

Member datapoints:

EnergyConsumptionFromFuels_RenewableEnergyMember  
EnergyConsumptionFromFuels_NonRenewableEnergyMember

Fact datapoint:

EnergyConsumptionFromFuels

---

Grand total:

TotalEnergyConsumption

---

# 4. UI input structure

The UI renders breakdowns as tables.

Example layout:

                Renewable   Non-renewable   Total
Electricity        x             x            x
Self-generated     x             x            x
Fuels              x             x            x
-----------------------------------------------
Total                                           x

The UI internally tracks values as structured state.

Example UI state model:

{
  electricity: {
    renewable: string,
    nonRenewable: string,
    total: string
  },
  self_generated: {
    renewable: string,
    nonRenewable: string,
    total: string
  },
  fuels: {
    renewable: string,
    nonRenewable: string,
    total: string
  }
}

---

# 5. Calculation rules

Row subtotal logic:

Detail mode:

renewable + nonRenewable → subtotal

Row total mode:

total → subtotal

Grand total logic:

sum of all row subtotals

Rows with NULL subtotal are ignored.

---

# 6. Persistence strategy

Persistence occurs per datapoint.

Helper abstraction:

persistByDatapoint(datapointId, value)

Logic:

If value == ''  
→ clearAnswer()

If value != ''  
→ saveAnswer()

---

# 7. Clear semantics

Empty string represents **clear datapoint**.

Implementation:

delete from disclosure_answer
where report_id = ...
and question_id = ...

This ensures deterministic DB state.

---

# 8. Zero handling

Zero is a valid value.

Important rule:

'0' != ''

Examples:

0 + 0 → subtotal = 0

Zero values must always be persisted.

---

# 9. Deterministic DB states

Valid states:

Case A

renewable = 3  
nonRenewable = 4  
subtotal = 7

Case B

renewable = null  
nonRenewable = null  
subtotal = null

Case C

renewable = 0  
nonRenewable = 0  
subtotal = 0

Invalid state (must never occur):

renewable = null  
nonRenewable = 4  
subtotal = 4

The system prevents this via explicit clear logic.

---

# 10. Debounced persistence

Detail inputs use debounce persistence.

Typical delay:

350 ms

Reasons:

- avoid race conditions
- reduce DB writes
- ensure stable subtotal calculations

---

# 11. Technical datapoints

Some datapoints represent structural XBRL elements:

Examples:

BreakdownOfEnergyConsumptionAxis  
BreakdownOfEnergyConsumptionTable

These may appear in RPC datasets but:

- are not rendered as UI questions
- exist for export structure
- may be referenced in grouping metadata

---

# 12. Reusability

This pattern is reusable for:

Energy consumption  
Water consumption  
Waste generation  
Scope emissions breakdowns  
Revenue segmentation

Future table-style questionnaire inputs should follow this pattern.

---

# Final principle

Breakdown structure is represented by **member datapoints**.

Numeric reporting values are represented by **fact datapoints**.

The UI may present them as tables, but the database model remains **flat, deterministic, and datapoint-driven**.