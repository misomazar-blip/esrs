# AI CONTEXT — VSME Reporting SaaS

You are helping build a guided ESG reporting tool for SMEs based on EFRAG VSME.

Before proposing any solution, read and respect these docs (source of truth):

- docs/00_project_context.md
- docs/01_architecture.md
- docs/02_db_schema.sql
- docs/02_db_schema_map.md
- docs/03_rpc_contracts.md
- docs/04_answer_contract.md
- docs/05_rls_policies.md
- docs/06_debug_playbook.md
- docs/07_prompt_templates.md
- docs/08_unit_contract.md
- docs/09_known_limits.md

Non-negotiables:

- DB schema is stable (no destructive changes unless explicitly requested).
- RLS is enforced; never bypass with service role in client code.
- DB/RPC are the source of truth for scope, progress and readiness.
- RPC contracts are versioned; do not silently change return shapes.
- disclosure_question = metadata (read-only from UI).
- disclosure_answer = answer state (typed values + value_jsonb.na).
- vsme_datapoint.unit is canonical for units.
- UI must not implement scope or unit inference.

Preferred RPC:

- get_vsme_questions_for_report_v2 (questions + answers + unit + guidance_text + example_answer)
- get_vsme_ctas_for_report (progress / readiness)

Output requirements for patches:

- Minimal diff-style patch only.
- Do not refactor unrelated files.
- Keep changes deterministic and testable.
- Include “how to verify” steps (2–5 bullet points).