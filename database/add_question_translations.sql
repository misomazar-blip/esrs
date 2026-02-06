-- Add translations JSONB column to disclosure_question table
-- This allows storing multiple language versions of question text

ALTER TABLE disclosure_question 
ADD COLUMN IF NOT EXISTS translations JSONB DEFAULT '{}'::jsonb;

-- Migrate existing question_text to English in translations
-- This assumes current data is in English
UPDATE disclosure_question 
SET translations = jsonb_build_object('en', question_text)
WHERE translations = '{}'::jsonb OR translations IS NULL;

-- Create index for better performance on JSONB queries
CREATE INDEX IF NOT EXISTS idx_disclosure_question_translations 
ON disclosure_question USING GIN (translations);

-- Example of adding Slovak translation for a question:
-- UPDATE disclosure_question 
-- SET translations = translations || jsonb_build_object('sk', 'Slovenský text otázky')
-- WHERE code = 'E1-1';

-- View all questions with their translations
-- SELECT id, code, translations 
-- FROM disclosure_question 
-- ORDER BY code;
