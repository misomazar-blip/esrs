# 04 – ANSWER STORAGE CONTRACT (VSME)

This file defines the storage contract for answers in `disclosure_answer`,
including explicit N/A support, metadata handling, and help-text separation.

UI must follow this contract.
DB/RPC logic assumes this contract.

---

# 1. Table: disclosure_answer (key facts)

Identity / upsert key:

```
(report_id, question_id)
```

Use UPSERT with conflict target:

```
onConflict: 'report_id,question_id'
```

Note:

DB currently contains duplicate UNIQUE constraints for this pair.
Do not add another uniqueness rule and do not attempt to “fix” this as part of application work.
Schema is considered stable.

---

# 2. Canonical Answer States

Each in-scope question is always in exactly one state.

### Missing

No `disclosure_answer` row exists
OR

Row exists but:

* contains no valid typed value
  AND
* `value_jsonb.na` is not true

---

### Answered (with value)

A valid typed value exists in the correct column
AND
`value_jsonb.na` is not true (or absent).

---

### Answered as N/A

```
value_jsonb.na = true
```

N/A counts as **Answered** for progress.

---

# 3. Typed Value Storage (authoritative)

Valid typed value must be stored in the correct column according to `question.answer_type`.

Mapping:

```
text / string / select → value_text
numeric → value_numeric
number (legacy) → value_number
integer → value_integer
date → value_date
boolean → value_boolean
json → value_jsonb (excluding `na` key)
```

Important:

Empty string **does not count as answered**.

Values stored in wrong typed columns are treated as **Missing**.

---

# 4. N/A Flag Rules (critical)

N/A is stored in:

```
disclosure_answer.value_jsonb -> { "na": true }
```

---

## NA ON

When marking N/A:

Upsert row with:

```
report_id
question_id
```

value_jsonb =

```
jsonb_set(
  coalesce(existing_jsonb,'{}'::jsonb),
  '{na}',
  'true'::jsonb,
  true
)
```

Rules:

* Must merge JSON, not overwrite
* Must not destroy existing typed values

---

## NA OFF

When unmarking N/A:

```
value_jsonb =
coalesce(existing_jsonb,'{}'::jsonb) - 'na'
```

Rules:

* Must not delete row automatically
* Must preserve typed values

---

# 5. Preservation Rule (No Data Loss)

Toggling N/A must never destroy previously stored values.

Example:

User enters value → toggles N/A → later toggles N/A off.

Previously entered value **must still exist** unless explicitly cleared.

---

# 6. Save Rules (UI)

### Writing Value

When saving answer:

Write value to correct typed column.

Recommended behavior:

If value is entered → remove `value_jsonb.na`.

---

### Clearing Value

If user clears value AND does not mark N/A:

Allowed behaviors:

delete row

OR

keep row with NULL values

Both are treated as **Missing** by progress logic.

Recommended:

Delete row when:

* no typed values exist
* no JSON business keys exist

Deleting rows is allowed for clearing values,
but **must not be used as part of N/A toggle logic**.

---

# 7. Progress Logic Alignment (authoritative)

Progress RPC treats:

Answered = valid typed value OR value_jsonb.na = true

Missing = total_in_scope − answered

Completed = answered

Progress is derived exclusively from DB state.

UI must not recompute progress independently.

---

# 8. Question Help Text Contract (disclosure_question)

Help text fields exist in `disclosure_question`.

Fields:

```
guidance_text TEXT NULL
example_answer TEXT NULL
```

These fields are delivered via:

```
get_vsme_questions_for_report_v2
```

---

## Semantics

### guidance_text

Displayed below question title.
Explains what information the user should provide.

### example_answer

Displayed below the input field.

Prefixed with:

```
Example:
```

Provides format guidance only.

---

## Storage Rules

These fields:

* are NOT stored in `disclosure_answer`
* are NOT modified by UI save operations
* are NOT part of UPSERT payload
* may be NULL

They do NOT affect:

* answer validity
* completion state
* progress calculation
* export readiness
* scope logic

They are **UX-only metadata**.

---

# 9. Unit Override Storage (optional)

Units are primarily resolved from:

```
vsme_datapoint.unit
```

`disclosure_answer.unit` exists only as an optional per-report override.

Rules:

UI SHOULD NOT write `unit` during normal flows.

If written, it must be a deliberate override.

RPC resolves unit as:

```
coalesce(
  disclosure_answer.unit,
  vsme_datapoint.unit,
  disclosure_question.unit
)
```

UI must always display the **RPC-returned unit**.

UI must never derive units from question text.

---

# 10. Answer Metadata (value_jsonb)

`value_jsonb` is used for **answer metadata flags**.

It must always be treated as a **mergeable JSON object**.

Empty state:

```
{}
```

The column is **NOT NULL** in the schema.

---

## Known Metadata Keys

### na

```
value_jsonb.na = true
```

Marks answer as **Not Applicable**.

---

### source

```
value_jsonb.source
```

Indicates **origin of the answer value**.

Possible values:

```
company_profile
user
system
```

Example:

```
{
  "source": "company_profile"
}
```

---

## Metadata Merge Rule (critical)

When updating `value_jsonb`, implementations must **merge existing JSON**.

Never overwrite entire JSON objects.

Correct pattern:

```
coalesce(existing_jsonb,'{}'::jsonb) || new_jsonb
```

Incorrect pattern:

```
value_jsonb = '{...}'
```

which destroys existing metadata.

---

# 11. Company Profile Prefill Contract

Some answers may be **prefilled from company profile data**.

This is performed via RPC:

```
prefill_company_profile_into_open_reports(company_id)
```

Typical overlapping fields include:

* company legal name
* address
* city
* postal code
* country code
* registration number
* VAT number

---

## Prefill Rules

Prefill must follow these rules:

* Only apply to **open / non-submitted reports**
* Only fill **missing answers**
* Must **never overwrite typed user values**
* Must record provenance

Provenance is stored as:

```
value_jsonb.source = 'company_profile'
```

---

## Editing Prefilled Values

When a user edits a prefilled value:

* typed value becomes authoritative
* UI may change metadata to:

```
value_jsonb.source = 'user'
```

This change is optional and informational only.

Prefill metadata **does not affect progress logic**.

---

# 12. Separation of Concerns (critical)

`disclosure_question` contains:

* question_text
* guidance_text
* example_answer
* answer_type
* scope metadata

`disclosure_answer` contains:

* actual answer values
* na flag
* metadata (value_jsonb)
* timestamps
* optional unit override

Principle:

```
disclosure_question → WHAT is asked
disclosure_answer → WHAT was answered
```

These responsibilities must never be mixed.

---

# 13. Support / Debug Views (Settings Page)

The Report Settings page contains a **collapsible Questions overview panel**.

Purpose:

Support debugging and export troubleshooting.

Displayed information:

* question_text
* section_code
* answer_state
* answer_preview

Answer preview is derived from typed value columns or NA flag.

This panel must be read-only and must never modify answers.

---

# 14. Known Risks / Footguns

### JSON overwrite risk

Never overwrite `value_jsonb` when updating NA or metadata.

Always merge existing JSON.

---

### Wrong typed column writes

Writing value to wrong column causes progress logic to treat the answer as Missing.

---

### Help text overwrite risk

UI must never attempt to write:

```
guidance_text
example_answer
```

These belong to `disclosure_question`.

---

### Unit confusion risk

UI must never invent units.

Always display unit returned by RPC.

---

### Prefill overwrite risk

Company prefill logic must never overwrite existing typed answers.

Only missing answers may be prefilled.

---

# END OF CONTRACT
