# 04 – ANSWER STORAGE CONTRACT (VSME)

This file defines the storage contract for answers in disclosure_answer,
including explicit N/A support and question help text contract.

UI must follow this contract. DB/RPC logic assumes this contract.

---

## 1. Table: disclosure_answer (key facts)

Identity / upsert key:

(report_id, question_id)

Use UPSERT with conflict target:

onConflict: 'report_id,question_id'

Note:

DB currently contains duplicate UNIQUE constraints for this pair.  
Do not add another uniqueness rule and do not attempt to “fix” this as part of app work  
unless explicitly requested (schema is stable).

---

## 2. Canonical answer states

Each in-scope question is always in exactly one state:

### Missing

No disclosure_answer row exists  
OR  
row exists but contains no valid typed value AND value_jsonb.na is not true

### Answered (with value)

Valid typed value exists in correct column  
AND  
value_jsonb.na is not true (or absent)

### Answered as N/A

value_jsonb.na = true

N/A counts as answered for progress.

---

## 3. Typed value storage (authoritative)

Valid typed value must be stored in correct column according to question.answer_type:

text / string / select → value_text  
numeric → value_numeric  
number (legacy) → value_number (only if used by question definition)  
integer → value_integer  
date → value_date  
boolean → value_boolean  
json → value_jsonb (excluding na key)

Empty string does NOT count as answered.

Storing value in wrong column is treated as Missing.

---

## 4. N/A flag rules (critical)

N/A is stored in:

disclosure_answer.value_jsonb.na = true

### NA ON

When marking as N/A:

Upsert row with:

report_id  
question_id  
value_jsonb = jsonb_set(coalesce(existing_jsonb,'{}'::jsonb), '{na}', 'true'::jsonb, true)

Rules:

Must merge JSON, not overwrite  
Must not destroy existing typed values  

---

### NA OFF

When unmarking N/A:

value_jsonb = coalesce(existing_jsonb,'{}'::jsonb) - 'na'

Rules:

Must not delete row automatically  
Must preserve typed values  

---

## 5. Preservation rule (no data loss)

Toggling N/A must never destroy previously stored values.

If user toggles N/A ON and later OFF:

previous values must still exist unless explicitly cleared.

---

## 6. Save rules (UI)

### Writing value

When saving answer:

Write value to correct typed column  
Recommended: remove value_jsonb.na if value entered  

---

### Clearing value

If user clears value AND does not mark N/A:

Allowed:

delete row  
OR  
keep row with NULL values  

Progress logic treats as Missing.

Recommended:

Delete row when no typed values AND no JSON business keys.

Deleting rows is allowed for clearing values, but NOT part of N/A toggle.

---

## 7. Progress logic alignment (authoritative)

Progress RPC logic treats:

Answered = has_valid_value OR value_jsonb.na = true  
Missing = total_in_scope - answered  
Completed = answered  

---

## 8. Question help text contract (disclosure_question)

Help text fields exist in disclosure_question table.

Fields:

guidance_text TEXT NULL  
example_answer TEXT NULL  

These fields are read-only for answer storage.

They are delivered via RPC get_vsme_questions_for_report_v2.

---

### Semantics

guidance_text:

Shown under question title  
Explains what data user should provide  
Purely informational  

example_answer:

Shown under input  
Prefixed with "Example:"  
Provides format guidance  

---

### Storage and behavior rules

These fields:

Are NOT stored in disclosure_answer  
Are NOT modified by UI save operations  
Are NOT included in UPSERT operations  
Are NOT required  
May be NULL  

They do NOT affect:

Answer validity  
Completion state  
Progress calculation  
Export readiness  
Scope logic  

They are UX-only metadata.

---

## 9. Unit override storage (optional)

Unit is primarily resolved from vsme_datapoint.unit in RPC.

disclosure_answer.unit exists only as an optional per-report override.

Rules:

- UI SHOULD NOT write unit in MVP flows (default NULL)
- If unit is written, it must be a deliberate override action
- RPC resolves unit as: coalesce(disclosure_answer.unit, vsme_datapoint.unit, disclosure_question.unit)

Unit values must never be inferred from question_text in UI.

---

## 10. Separation of concerns (critical)

disclosure_question contains:

question_text  
guidance_text  
example_answer  
answer_type  
scope metadata  

disclosure_answer contains:

actual answer values  
na flag  
timestamps  
(optional) unit override  

disclosure_question defines WHAT is asked  
disclosure_answer defines WHAT was answered  

These responsibilities must never be mixed.

---

## 11. Known risks / footguns

JSON overwrite risk  
Never overwrite value_jsonb entirely when toggling NA.

Wrong typed column writes  
Writing value to wrong column causes progress to treat as Missing.

Help text overwrite risk  
UI must never attempt to write guidance_text or example_answer.

Unit confusion risk  
UI must not invent units; always use RPC-returned unit.

Mitigations:

Use RPC for scope and progress  
Centralize answer write logic  
Keep disclosure_question read-only from UI perspective