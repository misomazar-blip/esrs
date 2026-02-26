# 04 – ANSWER STORAGE CONTRACT (VSME)

This file defines the storage contract for answers in `disclosure_answer`,
including explicit **N/A** support.

UI must follow this contract. DB/RPC logic assumes this contract.

---

## 1. Table: disclosure_answer (key facts)

Identity / upsert key:
- `(report_id, question_id)`

Use UPSERT with conflict target:
- `onConflict: 'report_id,question_id'`

Note:
- DB currently contains duplicate UNIQUE constraints for this pair.
- Do not add another uniqueness rule and do not attempt to “fix” this as part of app work
  unless explicitly requested (schema is stable).

---

## 2. Canonical answer states

Each in-scope question is always in exactly one state:

### 1) Missing
- No `disclosure_answer` row exists
OR
- a row exists but contains **no valid typed value** AND `value_jsonb.na` is not true

### 2) Answered (with value)
- a valid typed value exists in the relevant value column (by `answer_type`)
AND
- `value_jsonb.na` is not true (or absent)

### 3) Answered as N/A
- `value_jsonb.na = true`

N/A counts as answered for progress.

---

## 3. What counts as “has value” (typed validity)

A question is “answered with value” if:

- **text / string / select**: `value_text` is a non-empty trimmed string
- **number / numeric**: `value_numeric` is not null
- **number (legacy)**: `value_number` is treated as valid only if used by the question type in UI
- **integer**: `value_integer` is not null
- **date**: `value_date` is not null
- **boolean**: `value_boolean` is not null
- **json**: `value_jsonb` contains at least one business key other than `na`
  (i.e. `value_jsonb - 'na' <> '{}'::jsonb`)

Empty string does NOT count as answered.

Important:
- Values must be stored in the correct typed column for the question’s `answer_type`.
- Storing values in the wrong column is treated as Missing by progress logic.

---

## 4. N/A flag rules (critical)

N/A is stored as:
- `disclosure_answer.value_jsonb.na = true`

### NA ON (mark as N/A)

When user marks question as N/A:
- Upsert row with:
  - report_id
  - question_id
  - `value_jsonb = jsonb_set(coalesce(existing_jsonb,'{}'::jsonb), '{na}', 'true'::jsonb, true)`

Rule:
- Must not overwrite other keys in `value_jsonb`.
- Must not destroy existing typed values in other columns.

### NA OFF (unmark N/A)

When user unmarks N/A:
- Remove only the `na` key:
  - `value_jsonb = coalesce(existing_jsonb,'{}'::jsonb) - 'na'`

Rule:
- Must not delete the row automatically.
- Row may still contain values that become “active” again.

---

## 5. Preservation rule (avoid data loss)

Toggling N/A must never destroy previously stored values.

This is why:
- NA ON must merge (not replace)
- NA OFF must delete only the `na` key

If user toggles NA ON and later OFF:
- previously entered values must still exist (unless user explicitly cleared them)

---

## 6. Save rules (UI)

### Writing a normal value

When saving a value for an answer:
- write to the correct typed column
- optionally clear N/A flag:
  - if user enters a value, remove `value_jsonb.na` (recommended)

### Clearing a value

If user explicitly clears the value (and does NOT mark N/A):
- either delete the row OR keep it with NULL typed values
- but progress logic must treat it as Missing unless NA is true

Recommended for simplicity:
- if all typed value columns are NULL/empty AND `value_jsonb` has no business keys (excluding `na`)
  → delete the row

Important:
- deleting rows is allowed for “clear value”
- deleting rows is NOT part of NA toggle

---

## 7. Progress logic alignment (authoritative)

Progress calculations (RPCs) must treat:

- Answered = (has_value OR na=true)
- Missing = total_in_scope - answered
- Completed = answered (includes NA)

---

## 8. Known risks / footguns

1) JSONB overwrite risk  
If UI uses `.upsert({ value_jsonb: { na: true } })` without merge,
it overwrites the whole JSON and can destroy other keys.

2) Wrong typed column writes  
If UI writes a number into `value_text` (or similar),
progress logic will treat the answer as Missing.

Mitigations:
- implement safe NA toggle via DB RPC (preferred long-term)
- centralize “typed write” mapping in one UI module
- keep RPC as the single source of truth for progress/readiness