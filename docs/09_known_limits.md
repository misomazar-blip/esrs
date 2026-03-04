# Known Limits / Intentional Debts

## 1) Next.js App Router params hydration
We normalize params in client components; SSR purity not a current goal.

## 2) disclosure_answer unique constraint duplication
DB currently has two UNIQUE constraints on (report_id, question_id).
Do not add a third; do not “fix” unless explicitly planned.

## 3) Attachments/comments RLS
question_attachment and question_comment may still gate via company.user_id in some policies.
Future tightening should align to company_member model.