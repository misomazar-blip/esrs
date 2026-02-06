# Database Translation Setup

## Step 1: Add translations column

Run `add_question_translations.sql` in Supabase SQL Editor:

1. Open Supabase Dashboard → SQL Editor
2. Create new query
3. Copy and paste content from `add_question_translations.sql`
4. Click **RUN**

This will:
- Add `translations` JSONB column to `disclosure_question` table
- Migrate existing `question_text` to English in translations
- Create GIN index for performance

## Step 2: Verify the setup

Run this query to check:

```sql
SELECT id, code, question_text, translations 
FROM disclosure_question 
LIMIT 5;
```

You should see `translations` column with format:
```json
{"en": "Original question text"}
```

## Step 3: Add Slovak translations

Now you can add Slovak translations manually or via script:

```sql
-- Example: Add Slovak translation for a specific question
UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Slovenský text otázky')
WHERE code = 'E1-1';
```

## Step 4: Test in application

1. Open topic detail page (e.g., `/en/topics/e1?reportId=xxx`)
2. Change language to Slovak
3. Question text should display in Slovak (if translation exists) or fallback to English

## Translation Priority

The application follows this priority:
1. Translation in current locale (SK/EN)
2. English translation (fallback)
3. Original `question_text` field (legacy fallback)

## Bulk Translation Script

For bulk translations, you can prepare CSV file:
```
code,sk_text
E1-1,Slovenský text pre E1-1
E1-2,Slovenský text pre E1-2
...
```

Then use script (to be created) to import translations.
