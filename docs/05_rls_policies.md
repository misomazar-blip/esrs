# 05 – RLS POLICIES (Authoritative Rules)

This document defines how Row Level Security (RLS) behaves in the system.  
UI is not trusted. Database enforces access.

Never weaken RLS without explicit architectural decision.

Current state reflects:
- removal of global SELECT true policies on company/report/topic
- RLS enabled on reference pack tables
- SECURITY DEFINER functions hardened with fixed search_path
- VSME-specific triggers enforcing framework/type consistency

---

## 1. Core Principle

Access is granted based on:

- Company membership (`company_member`)
- Role (`owner`, `admin`, `editor`, `viewer`)
- Topic-level permissions (`company_member_topic_access`) when access is scoped to selected topics

All checks must happen in DB (RLS + helper functions).

No table containing company-owned data is globally readable.

---

## 2. Roles (semantics)

### owner
- Full access to company
- Full access to reports
- Full access to all topics
- Full read/write on answers
- Can manage company members (invite/update/remove), including:
  - can create another owner
  - can remove own membership (self-remove)
- Can delete company

### admin
- Same as owner for day-to-day reporting access
- Not allowed to delete company

### editor
If `company_member.access_type = 'all'`:
- Can view/edit all topics

If `company_member.access_type = 'selected'`:
- Can view/edit only topics assigned in `company_member_topic_access` with:
  - `can_view = true`
  - `can_edit = true`

### viewer
If `company_member.access_type = 'all'`:
- Can view all topics

If `company_member.access_type = 'selected'`:
- Can view only assigned topics with `can_view = true`

Viewer cannot:
- insert answers
- update answers
- delete answers

---

## 3. Company lifecycle invariants (critical)

### 3.1 Removing owners does NOT delete company data

Deleting an owner membership row MUST NOT delete:

- `company`
- `report`
- `disclosure_answer`
- any other company-owned data

Even if no owner remains, the company and reports remain intact.

There is no cascade from `company_member` to `company`.

### 3.2 Company deletion is owner-only

Deleting a company (DELETE on `company`) is allowed only if:
- current user is `owner` for that company

Admins cannot delete a company.

Policy: `company_delete_owner_only`

---

## 4. Topic-level enforcement (authoritative)

Topic permissions are enforced via:

`company_member_topic_access(company_member_id, topic_id, can_view, can_edit)`

No UI-only filtering is trusted.  
RLS must block unauthorized access even if UI is bypassed.

`topic_select_auth` (USING true) has been removed.  
Topics are no longer globally readable by default.

Access to topics must derive from:

- company membership
- topic assignment (if access_type = 'selected')

---

## 5. Report access

A user can access a report only if:
- user is a `company_member` of `report.company_id`

`report_select_auth` (USING true) has been removed.

No cross-company leakage is possible via report table.

Report scope authority (framework, mode, packs, taxonomy_version)
does NOT override RLS. RLS applies first.

---

## 6. Company access

A user can access a company only if:
- user is a `company_member` of that company

`company_select_auth` (USING true) has been removed.

Company table is no longer globally readable.

---

## 7. disclosure_answer access

Policies enforce:

### SELECT

Allowed if:
- user has access to the report’s company  
AND  
- user can view the question’s topic  
OR  
- user is owner/admin for the company

### INSERT / UPDATE

Allowed if:
- user is owner/admin  
OR  
- user is editor AND `can_edit = true` for that topic

### DELETE

Same rule as UPDATE.

Policies:

- `answer_select_topic_access`
- `answer_insert_topic_access`
- `answer_update_topic_access`
- `answer_delete_topic_access`

Additionally enforced by trigger:

- `enforce_answer_framework_match()`
  - prevents cross-framework writes (e.g. ESRS question in VSME report)

---

## 8. disclosure_question protection (VSME integrity)

`disclosure_question` is treated as a shared catalog.

### SELECT

Authenticated-readable (global catalog).

### INSERT / UPDATE / DELETE

Must be restricted to:
- admin-level operations (not end users)
- typically managed via migrations, not runtime UI

Additional integrity guard:

- `enforce_vsme_question_type_match()` trigger  
  - ensures:
    - referenced `vsme_datapoint_id` exists
    - `answer_type` matches `vsme_datapoint.value_type`
  - protects VSME catalog from internal inconsistency

---

## 9. Reference catalog tables (intentional stance)

Some tables contain framework metadata only (no company-owned data) and are treated as catalogs.

### 9.1 Authenticated-readable catalogs (intentional)

- `disclosure_question` (question catalog / framework metadata)
- `vsme_datapoint` (datapoint catalog)
- `vsme_question` (metadata catalog)

Rationale:

Catalog metadata is not company-owned data and is safe to reuse across tenants.

These tables must not expose sensitive tenant-specific data.

### 9.2 Pack catalogs (RLS enabled)

- `report_pack`
- `vsme_datapoint_pack`

RLS is enabled.

Current stance:
- SELECT allowed to authenticated users
- no client-side writes expected

If writes are ever needed:
- introduce explicit owner/admin-only policies
- update this document

---

## 10. RLS + RPC interaction rules

- RPC functions must not bypass RLS unintentionally.
- RPC functions must not assume visibility beyond RLS constraints.
- If SECURITY DEFINER is used, explicit membership checks must be performed.

Allowed:

- SECURITY DEFINER for boolean helpers  
  (e.g. `has_company_role`, `user_can_edit_topic`)

Disallowed:

- SECURITY DEFINER functions returning unrestricted datasets
  without access validation

RPC must behave as if executed by the authenticated user.

---

## 11. Function Security Hardening

All SECURITY DEFINER functions in `public` schema:

- explicitly set `search_path = public`
- do not rely on implicit schema resolution
- avoid dynamic SQL unless necessary

Current state:

All SECURITY DEFINER functions have `search_path=public`.

Any new SECURITY DEFINER function must follow the same pattern.

---

## 12. Known deviations / TODOs (documented on purpose)

### 12.1 Attachments / comments currently use `company.user_id` gating

`question_attachment` and `question_comment` policies currently gate access via:

- report belongs to company where `company.user_id = auth.uid()`

This does NOT fully align with membership roles in `company_member`.

Impact:

- admins/editors may be blocked even if they should have access by role/topic permission.

TODO (future tightening):

- gate by `company_member` membership
- optionally align to topic permissions if needed

(Do not change silently: update this doc + test matrix.)

---

## 13. Non-negotiables

- No disabling RLS in production.
- No service role usage in browser/client code.
- All writes use authenticated Supabase client.
- Policies reference `auth.uid()`.
- No client-side authorization as primary enforcement.
- No cross-tenant data leakage under any scenario.

---

## 14. Practical test checklist

For each role scenario verify:

- User sees only their companies
- User sees only reports of their companies
- User sees only topics they are allowed to see
- Viewer cannot modify answers
- Editor can modify only assigned topics
- Admin cannot delete company
- Owner can delete company
- Removing last owner does not delete data
- No cross-company data leakage
- RPC question list respects topic permissions
- Progress RPC reflects only visible in-scope questions