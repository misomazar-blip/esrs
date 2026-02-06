-- Example: How to add Slovak translations for questions
-- After running add_question_translations.sql migration

-- Example 1: Add Slovak translation for a specific question by code
UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Aké sú vaše hlavné environmentálne politiky?')
WHERE code = 'E1-1';

-- Example 2: Add multiple translations at once
UPDATE disclosure_question 
SET translations = translations || jsonb_build_object(
  'sk', 'Popíšte vašu stratégiu adaptácie na klimatické zmeny.',
  'de', 'Beschreiben Sie Ihre Strategie zur Anpassung an den Klimawandel.'
)
WHERE code = 'E1-2';

-- Example 3: Bulk update for multiple questions
-- First, create a temporary table with translations
CREATE TEMP TABLE temp_translations (
  question_code VARCHAR(50),
  slovak_text TEXT
);

-- Insert your translations
INSERT INTO temp_translations (question_code, slovak_text) VALUES
  ('E1-1', 'Aké sú vaše hlavné environmentálne politiky?'),
  ('E1-2', 'Popíšte vašu stratégiu adaptácie na klimatické zmeny.'),
  ('E1-3', 'Aké ciele ste si stanovili na zníženie emisií skleníkových plynov?');

-- Update all questions with translations
UPDATE disclosure_question vq
SET translations = vq.translations || jsonb_build_object('sk', tt.slovak_text)
FROM temp_translations tt
WHERE vq.code = tt.question_code;

-- Clean up
DROP TABLE temp_translations;

-- Example 4: View questions with their translations
SELECT 
  code,
  question_text as original_text,
  translations->>'en' as english,
  translations->>'sk' as slovak,
  translations->>'de' as german
FROM disclosure_question
WHERE translations IS NOT NULL
ORDER BY code;

-- Example 5: Find questions missing Slovak translation
SELECT code, question_text, translations
FROM disclosure_question
WHERE translations->>'sk' IS NULL
ORDER BY code;

-- Example 6: Update translation for a specific topic
UPDATE disclosure_question vq
SET translations = translations || jsonb_build_object('sk', 'SLOVAK TEXT HERE')
FROM topic t
WHERE vq.topic_id = t.id 
  AND t.code = 'E1'
  AND vq.code = 'E1-1';
