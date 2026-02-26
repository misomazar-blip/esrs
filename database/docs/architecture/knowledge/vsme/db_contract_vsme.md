# VSME Database Contract (Core + Comprehensive)

## Purpose

This document defines the stable database contract for the VSME reporting layer.

It is the single source of truth for:
- VSME datapoints
- VSME questions
- VSME answers
- Mapping to Full ESRS

Goals:
- Simple UX for SMEs
- Stable structure across years
- Data reuse
- Future upgrade path to Full ESRS

---

# Core principles

1) VSME is the primary reporting layer for SMEs.
2) ESRS is an advanced layer and may be added later.
3) VSME is NOT a strict subset of ESRS.
4) Mapping between VSME and ESRS must support 1..N relationships.
5) Datapoints are stable identifiers independent from questions.
6) Questions are only UX wrappers over datapoints.

---

# Entity model

## 1) vsme_datapoint (semantic layer)

Represents one measurable/reportable sustainability fact.

Examples:
- TotalEnergyConsumption
- NumberOfEmployees
- GrossScope1GreenhouseGasEmissions

Fields:

- id (text, PK)  
  Stable identifier from Digital Template named ranges

- module (text)  
  One of: B1–B11, C1–C9

- level (text)  
  core | comprehensive

- label_en (text)  
  English label from Translations sheet

- value_type (text)  
  One of:
  - string
  - integer
  - decimal
  - boolean
  - date
  - json

- allowed_units (jsonb, optional)  
  Example: ["kg","t","m3"]

- unit_required (boolean, default false)

- allowed_values (jsonb, optional)  
  Used for enums

- kind (text, default 'fact')  
  One of:
  - fact
  - dimension
  - table
  - member

Only `kind = 'fact'` is shown in UI.

---

## 2) vsme_question (UX layer)

Represents the question displayed to the SME user.

1 datapoint can have one or more questions.

Fields:

- id (uuid, PK)
- vsme_datapoint_id (text, FK → vsme_datapoint.id)
- question_text (text)
- answer_type (text)
- order_index (int)
- help_text (text)
- config_jsonb (jsonb)

---

## 3) vsme_answer (data layer)

Stores actual answers for a specific report.

Fields:

- id (uuid, PK)
- report_id (uuid, FK → report.id)
- vsme_question_id (uuid, FK)
- value_boolean (boolean)
- value_text (text)
- value_number (numeric)
- value_integer (integer)
- value_date (date)
- value_jsonb (jsonb)
- unit (text)
- updated_at (timestamp)

Unique constraint:
- (report_id, vsme_question_id)

---

## 4) vsme_to_esrs_map (upgrade bridge)

Enables migration from VSME → Full ESRS.

Mapping types:

- equivalent  → direct copy
- aggregate   → sum/merge multiple datapoints
- derived     → formula
- manual      → requires refinement

Fields:

- id (uuid)
- vsme_datapoint_id (text)
- esrs_datapoint_id (text)
- mapping_type (text)
- transform (jsonb)
- priority (int)

---

# Relationship to existing ESRS schema

Existing ESRS layer remains unchanged:

- disclosure_question
- disclosure_answer
- esrs_to_xbrl_mapping

VSME layer runs in parallel.

---

# Data flow

## Year 1

User fills:
vsme_question → vsme_answer

## Year 2

System reuses:
previous vsme_answer as prefill

## Future: move to ESRS

System:
- reads vsme_answer
- uses vsme_to_esrs_map
- pre-fills ESRS answers

---

# What is NOT a datapoint

The following must NEVER be stored as business datapoints:

- Axis
- Member
- Table
- Hypercube
- TypedAxis
- *_unit selectors

These are XBRL structural elements.

Units belong as metadata to the main datapoint.

---

# Scope (MVP)

Included:
- VSME Core
- VSME Comprehensive

Excluded:
- Full ESRS modeling
- Full XBRL modeling
