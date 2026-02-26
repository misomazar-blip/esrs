# 07 – PROMPT TEMPLATES (For GPT Collaboration)

This file defines how GPT should be used in this project.

Always reference:
- 00_project_context.md
- 01_architecture.md
- 02_db_schema.sql
- 03_rpc_contracts.md
- 04_answer_contract.md
- 05_rls_policies.md
- 06_debug_playbook.md

Non-negotiables:
- DB schema stable (no destructive changes)
- RLS enforced (never bypass in client)
- Prefer RPC-driven deterministic logic

---

## 1) New GPT thread bootstrap

Paste:

You are working on a VSME Reporting SaaS platform.

Read and respect:
- Project context
- Architecture
- DB schema (stable)
- RLS rules
- RPC contracts
- Answer storage contract
- Debug playbook

Rules:
- Do NOT propose destructive schema changes.
- Prefer deterministic RPC-based solutions.
- Keep changes minimal and testable.
- Ask before altering RLS, triggers, constraints.

Current task:
<describe task precisely>

---

## 2) Frontend patch request

We are modifying:
<component_path>

Constraints:
- DB schema stable
- RLS enforced
- Prefer RPC outputs as source of truth
- No broad refactor

Goal:
<precise goal>

Provide:
- minimal patch (diff-like)
- explain assumptions
- highlight risks + rollback

---

## 3) RPC change request

We are modifying RPC:
<function_name + signature>

Current contract (03):
<paste return shape + rules>

Goal:
<precise change>

Constraints:
- No breaking change to return columns unless coordinated
- Deterministic scope/progress rules
- Explicit columns, no SELECT *

Provide:
- updated function SQL
- updated contract text for 03
- test queries (SQL) to validate behavior

---

## 4) Security tightening (RLS / policies)

We are tightening RLS on:
<table(s)>

Current policies:
<paste current policies>

Goal:
- remove unintended global access
- preserve app functionality

Constraints:
- no schema refactor
- no service role usage in client

Provide:
- minimal SQL steps (drop/add policies)
- safe order of operations
- role-based test checklist

---

## 5) SECURITY DEFINER audit (search_path)

Goal:
- list SECURITY DEFINER functions missing search_path
- apply `alter function ... set search_path = public`

Provide:
- audit SQL
- fix SQL
- re-audit SQL

---

## 6) Performance audit (RPC / query plan)

Query/RPC:
<query or function call>

Provide:
- EXPLAIN ANALYZE interpretation
- identify bottlenecks (seq scan, bad join order)
- propose minimal index changes (only if justified)
- note write-performance tradeoffs

---

## 7) Debug template (fast)

Bug:
<exact error message>

Observed:
<what happens>

Expected:
<what should happen>

Already checked:
- RPC output
- RLS policies
- casing/params
- cache cleared (.next)

Give:
- minimal diagnostic path
- likely root cause
- smallest fix