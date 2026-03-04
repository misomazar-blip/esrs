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
- Is this report on the expected vsme_taxonomy_version?

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

1) Verify import spelling  
2) Verify function scope  
3) Confirm correct React hook imports  
4) Restart clean:

stop dev server  
delete .next  
run npm run dev

---

## 1.2 React Hook issues

Symptoms:

- Infinite re-render  
- Stale state  
- Dependency warnings  

Rules:

Functions used in useEffect must be:

- defined inside effect OR  
- wrapped in useCallback  

Never silence eslint warnings blindly.

---

## 1.3 Next.js App Router param hydration

Symptoms:

- params undefined  
- sectionCode empty  

Fix:

Normalize params before usage.

Example pattern:

const params = useParams<{ locale: string; id: string; sectionCode: string }>();

const reportId = typeof params.id === 'string' ? params.id : '';
const sectionCode =
  typeof params.sectionCode === 'string'
    ? params.sectionCode.toUpperCase()
    : '';

Never assume params are immediately hydrated.

---

## 1.4 Sticky navigation debugging

Sticky nav visibility depends on:

scroll threshold AND footer visibility.

Debug checklist:

- Verify scroll handler  
- Verify IntersectionObserver  
- Verify state logic  

Sticky must depend on:

scrolledPastThreshold && !footerNavVisible

Never rely on raw scrollY guesses.

---

# 2. DATA LOADING ISSUES

## 2.1 Questions not rendering

Check RPC output first:

select section_code, count(*)
from public.get_vsme_questions_for_report_v2('<report_id>')
group by section_code;

If RPC returns rows → frontend issue  
If RPC empty → DB or scope issue  

Also verify report configuration:

select framework, vsme_mode, vsme_pack_codes, vsme_taxonomy_version
from report
where id='<report_id>';

Never debug UI before verifying RPC.

---

## 2.2 Progress not recalculating

Progress source of truth = RPC.

Checklist:

- Save mutation success  
- Refetch progress RPC  
- Verify value stored correctly  

Test directly:

select *
from get_vsme_ctas_for_report('<report_id>');

---

## 2.3 Saved answer disappears

Most common causes:

- Wrong upsert key  
- Wrong value column  
- NA overwrite  
- Framework mismatch  
- Type mismatch rejected by trigger  

Verify:

- (report_id, question_id) conflict key  
- Correct typed column  
- value_jsonb merge logic  

Also check trigger errors in logs:

- enforce_answer_framework_match  
- enforce_vsme_question_type_match  

---

## 2.4 Help text not visible (guidance_text / example_answer)

Check in order:

1) Does DB contain values?

select guidance_text, example_answer
from disclosure_question
where id='<question_id>';

2) Does RPC v2 return values?

select guidance_text, example_answer
from get_vsme_questions_for_report_v2('<report_id>')
where question_id='<question_id>';

3) Is frontend calling correct RPC?

Must call:

get_vsme_questions_for_report_v2

Not legacy version.

4) Browser console diagnostic:

console.log(sectionQuestions[0])

If missing → RPC mismatch  
If present → rendering issue  

Never patch UI before verifying RPC output.

---

# 3. REPORT SETTINGS DEBUGGING

Report settings control VSME scope.

UI: Report Settings page.

Fields:

- vsme_mode
- vsme_pack_codes
- vsme_taxonomy_version

Verify settings:

select
vsme_mode,
vsme_pack_codes,
vsme_taxonomy_version
from report
where id='<report_id>';

If question scope seems incorrect, this is the first place to check.

---

# 4. SUPABASE / RLS ISSUES

## 4.1 Insert/Update fails

Most common cause: RLS denial

Verify membership:

select *
from company_member
where user_id = auth.uid();

Verify topic access:

select *
from company_member_topic_access;

---

## 4.2 User sees report but not answers

Cause:

Topic access missing OR topic not assigned for selected editor/viewer.

Fix:

Verify company_member_topic_access rows.

---

## 4.3 Unexpected data leakage (CRITICAL)

Check RLS:

select relrowsecurity
from pg_class
where relname='disclosure_answer';

Verify:

- relrowsecurity = true  
- No USING true policies  
- No service role usage  

Fix immediately.

---

# 5. RPC / SQL ISSUES

## 5.1 RPC returns empty list

Check report config:

select framework, vsme_mode, vsme_pack_codes
from report
where id='<report_id>';

Verify questions exist:

select count(*)
from disclosure_question
where framework='VSME';

Verify datapoint catalog:

select count(*)
from vsme_datapoint;

---

## 5.2 RPC return shape mismatch (CRITICAL)

Symptoms:

- Frontend receives undefined fields  
- Help text missing  
- TypeScript mismatch  

Diagnostic:

select *
from get_vsme_questions_for_report_v2('<report_id>')
limit 1;

Verify expected fields exist:

- guidance_text  
- example_answer  
- unit  
- vsme_datapoint_id  

If missing:

- RPC version mismatch  
- Frontend calling legacy RPC  

Fix:

Switch to correct RPC version.

Never patch UI to hide contract mismatch.

---

## 5.3 Multiple RPC versions present

Check available versions:

select proname
from pg_proc
where proname like 'get_vsme_questions_for_report%';

Ensure frontend calls correct version.

Preferred version:

get_vsme_questions_for_report_v2

Legacy version kept for compatibility.

---

## 5.4 Performance debugging

Use:

explain analyze
select *
from get_vsme_questions_for_report_v2('<report_id>');

Investigate:

- Seq scans  
- Large nested loops  

Add indexes only if proven necessary.  
Do not prematurely optimize.

---

# 6. PROJECT-SPECIFIC ROOT CAUSES

## 6.1 Framework mismatch

Verify:

report.framework='VSME'  
question.framework='VSME'

Mismatch causes trigger failures.

---

## 6.2 Datapoint type mismatch (trigger failure)

Error example:

VSME answer_type mismatch for datapoint ...

Cause:

disclosure_question.answer_type not aligned with vsme_datapoint.value_type.

Fix:

Align question definition to canonical datapoint.

Never bypass trigger.

---

## 6.3 NA JSON overwrite

Incorrect:

value_jsonb replaced entirely  

Correct:

jsonb_set(coalesce(value_jsonb,'{}'::jsonb), '{na}', 'true')

If previous values disappear → inspect JSON merge logic.

---

## 6.4 Help text write attempt (invalid)

guidance_text and example_answer must never be written via UI.

These fields belong to disclosure_question.

If UI attempts write → contract violation.

Fix UI immediately.

---

## 6.5 Unit confusion

If UI shows missing unit:

Check RPC output first.

Unit must come from:

coalesce(disclosure_answer.unit,
vsme_datapoint.unit,
disclosure_question.unit)

Never infer units from question text.

---

## 6.6 Taxonomy drift

If counts mismatch EFRAG taxonomy:

Check:

report.vsme_taxonomy_version

Then verify:

- vsme_datapoint catalog completeness
- datapoint ↔ pack mappings
- no stray legacy datapoints

Never silently add datapoints without updating mapping logic.

---

# 7. ROLE-BASED TEST MATRIX

Always test:

- Owner  
- Admin  
- Editor (all topics)  
- Editor (selected topics)  
- Viewer  

Verify:

- View access  
- Edit access  
- Save behavior  
- Progress calculation  
- RLS enforcement  

---

# 8. SAFE RESET PLAYBOOK

Frontend reset:

Stop dev server  
Delete .next  
Restart npm run dev

Session reset:

Sign out  
Sign in again  

Verify membership.

---

# 9. WHAT NOT TO DO

Do NOT disable RLS  
Do NOT use service role in browser  
Do NOT patch UI to hide RPC contract mismatch  
Do NOT modify schema casually  
Do NOT rewrite RPC without contract update  
Do NOT bypass triggers to “make it work”

---

# 10. SECTIONS PANEL DEBUGGING

Sections panel derived from:

get_vsme_questions_for_report_v2

Never compute scope in UI.

---

## 10.1 Missing sections

Run:

select section_code, count(*)
from get_vsme_questions_for_report_v2('<report_id>')
group by section_code;

Section must exist only if count > 0.

---

## 10.2 Incorrect grouping

Verify:

VSME_SECTION_META  
resolveSectionGroup()

Never infer grouping dynamically.

---

## 10.3 Core vs Comprehensive mismatch

Check:

select vsme_mode
from report
where id='<report_id>';

Mode semantics:

core → B sections only  
core_plus → B + selected pack sections  
comprehensive → B + C sections  

If mismatch → fix RPC, not UI.