# 06 – DEBUG PLAYBOOK (VSME SaaS)

This document defines how to debug safely and systematically.
No random fixes. No emotional coding.

When something breaks, follow this order:

1) Reproduce
2) Identify layer (UI vs RPC vs RLS vs DB)
3) Minimal diagnostics
4) Minimal fix
5) Verify with role matrix

---

# 0. Quick triage (2 minutes)

Answer these first:

- Does the bug happen for all users or only certain roles?
- Is the data missing in UI only or also missing in DB?
- Is it a frontend crash, an RPC error, or an RLS denial?

Fast checks:

- Browser console → errors + Network tab
- Supabase logs → API / policy errors
- SQL editor → verify rows actually exist

Never guess the layer. Identify it first.

---

# 1. FRONTEND ERRORS

## 1.1 “X is not defined”

Typical causes:

- Missing import
- Function declared after usage in closure context
- Wrong hook import (useCallback vs useCallBack)
- Stale dev server cache

Checklist:

1) Verify import spelling (case-sensitive)
2) Verify function scope
3) Confirm correct React hook imports
4) Restart clean:

stop dev server  
delete .next  
run npm run dev  

If it persists:

Check stack trace chunk → verify correct file mapping.

---

## 1.2 React Hook issues

Symptoms:

- Infinite re-render
- Stale state
- Dependency warnings
- Effect firing unexpectedly

Rules:

Every function referenced inside useEffect must be:

- defined inside the effect OR
- wrapped in useCallback

Dependency arrays must include referenced variables.

Never silence eslint warnings blindly.

Debug approach:

- Log dependency values
- Confirm effect runs only when expected

---

## 1.3 Next.js App Router param hydration

Symptoms:

- params undefined on first render
- sectionCode empty
- Flicker or empty question list

Recommended pattern:

Server Component renders layout + auth guard  
Client Component fetches section data via RPC after mount  

Normalize params:

sectionCode must always be uppercased before usage.

Never rely on raw params without normalization.

---

# 2. DATA LOADING ISSUES

## 2.1 Questions not rendering

Check in this order:

1) Does RPC return rows?
2) Does sectionCode match DB casing?
3) Is client-side filtering removing everything?
4) Is RLS blocking query?

Debug query:

select section_code, count(*)
from public.get_vsme_questions_for_report('<report_id>')
group by section_code
order by section_code;

Never assume frontend is wrong before verifying RPC output.

---

## 2.2 Progress not recalculating

Understand the model:

DB-authoritative progress updates only after refetch.  
UI-live progress updates from local state.

Rule:

Optimistic update allowed.  
Must reconcile with RPC-confirmed state.

Checklist:

- Confirm save mutation success
- Confirm local state updated
- Confirm CTA refresh runs

---

## 2.3 Saved answer disappears after refresh

Likely causes:

- Wrong upsert conflict key
- Value stored in wrong typed column
- NA toggle overwrote JSON instead of merging
- Framework mismatch trigger rejected write

Checklist:

Verify upsert key is (report_id, question_id)

Verify correct value_* column used

Verify JSON merge logic

Verify report.framework matches question.framework

---

# 3. SUPABASE / RLS ISSUES

## 3.1 Insert/Update fails (401/403)

Most common cause: RLS denial.

Checklist:

select *
from company_member
where company_id = '<company_id>'
and user_id = auth.uid();

If editor with selected access:

select *
from company_member_topic_access ta
join company_member cm on cm.id = ta.company_member_id
where cm.user_id = auth.uid()
and cm.company_id = '<company_id>'
and ta.topic_id = '<topic_id>';

Also:

- Confirm correct policy exists
- Check Supabase logs

---

## 3.2 User sees report but not answers

Cause:

Report membership OK  
Answer policy blocked via topic permission  

Fix:

Verify topic access rows exist  
Verify ta.can_view = true  

---

## 3.3 Editor cannot edit some topics

Expected if:

access_type = selected  
can_edit differs per topic  

If unexpected:

Verify topic access seeding  
Verify UI does not incorrectly show edit controls  

---

## 3.4 Unexpected data leakage (CRITICAL)

If cross-company data visible:

select relrowsecurity, relforcerowsecurity
from pg_class
where relname = '<table>';

Then verify:

- no USING true policies remain
- RPC not SECURITY DEFINER leaking data
- client not using service role

Fix immediately.

---

# 4. RPC / SQL ISSUES

## 4.1 RPC returns empty list

Check:

select id, framework, vsme_mode, vsme_pack_codes
from report
where id = '<report_id>';

select count(*)
from disclosure_question
where framework='VSME'
and section_code like 'B%';

If core_plus:

verify vsme_pack_codes  
verify vsme_datapoint_pack mapping  

---

## 4.2 RPC contract mismatch

If UI expects fields not returned:

Update TypeScript types OR RPC.

Do not patch UI silently.

03_rpc_contracts.md is authoritative.

---

## 4.3 Performance debugging

If slow:

explain analyze
select * from public.get_vsme_questions_for_report('<report_id>');

Look for:

- Seq Scan on large tables
- Nested Loop over large datasets

Add indexes only with evidence.

---

# 5. PROJECT-SPECIFIC ROOT CAUSES

## 5.1 Framework mismatch

Trigger: enforce_answer_framework_match

Symptom:

Answer not persisted

Fix:

Ensure report.framework = 'VSME'  
Ensure question.framework = 'VSME'  

---

## 5.2 NA JSON overwrite

Bad:

value_jsonb overwritten completely

Good:

Merge JSON or remove only "na" key

---

# 6. ROLE-BASED TEST MATRIX

Owner:
Full reporting access

Admin:
Full reporting access

Editor (all):
Edit all topics

Editor (selected):
Edit only assigned topics

Viewer:
View only allowed topics

Always test:

Owner  
Admin  
Editor (all)  
Editor (selected)  
Viewer  

---

# 7. SAFE RESET PLAYBOOK

Frontend:

Stop dev server  
Delete .next  
Restart npm run dev  

Supabase:

Sign out / sign in again  
Verify membership rows  
Re-check policies  

---

# 8. WHAT NOT TO DO

- Do not disable RLS to test
- Do not switch client to service role
- Do not add random indexes without EXPLAIN evidence
- Do not patch UI to hide DB contract issues
- Do not rewrite architecture to fix one bug

---

# 9. SECTIONS PANEL DEBUGGING

Sections panel is derived entirely from get_vsme_questions_for_report(report_id)

UI must never infer scope from static metadata.

---

## 9.1 Chapters missing or showing incorrectly

Run:

select section_code, count(*)
from public.get_vsme_questions_for_report('<report_id>')
group by section_code
order by section_code;

If count = 0 → chapter must not be shown  
If count > 0 → chapter must be shown  

---

## 9.2 Chapters assigned to wrong theme

Verify resolveSectionGroup(sectionCode) mapping:

General Information:
B1, B2, C1, C2

Environment:
B3–B7, C3–C4

Social:
B8–B10, C5–C7

Governance:
B11, C8–C9

---

## 9.3 Theme totals incorrect

Verify totals derived from RPC dataset only.

Never compute totals from static section list.

---

## 9.4 Theme opens incorrectly

Expected:

openGroup must equal currentGroup

If mismatch → fix openGroup sync effect.

---

## 9.5 Core vs Comprehensive mismatch

Check:

select vsme_mode from report where id='<report_id>';

core → only B sections  
comprehensive → B + C sections  
core_plus → B + pack sections  

Never patch UI to hide incorrect RPC output.