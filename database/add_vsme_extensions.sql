-- ============================================================================
-- VSME (Very Small & Micro Entities) Database Extensions
-- ============================================================================
-- Cieľ: Rozšíriť databázu o VSME logiku bez zmeny existujúcich stĺpcov
-- 
-- VSME Kritérium: < 750 zamestnancov (priemer počas finančného roka)
-- Fázované zavádzanie: Rok 1, Rok 2, Rok 3+
-- 
-- Táto migrácia:
-- 1. Pridá stĺpce do company (počet zamestnancov)
-- 2. Rozšíri report (rok reportingu, fázovanie)
-- 3. Rozšíri disclosure_question (aplikovateľnosť pre VSME)
-- 4. Vytvorí helper views a funkcie
--
-- Referencia: ESRS 1 - Appendix C (Phase-in provisions)
-- ============================================================================

-- ============================================================================
-- PHASE 1: COMPANY EXTENSIONS
-- ============================================================================

ALTER TABLE IF EXISTS company
ADD COLUMN IF NOT EXISTS employee_count INTEGER
  CONSTRAINT check_employee_count CHECK (employee_count > 0 OR employee_count IS NULL);

ALTER TABLE IF EXISTS company
ADD COLUMN IF NOT EXISTS employee_count_verified_at TIMESTAMP;

ALTER TABLE IF EXISTS company
ADD COLUMN IF NOT EXISTS employee_count_verified_by TEXT;

-- Generated column: automatické určenie VSME statusu
ALTER TABLE IF EXISTS company
ADD COLUMN IF NOT EXISTS is_vsme BOOLEAN
  GENERATED ALWAYS AS (
    employee_count IS NULL OR employee_count <= 750
  ) STORED;

-- Generated column: počet zamestnancov kategórie (pre UI)
ALTER TABLE IF EXISTS company
ADD COLUMN IF NOT EXISTS employee_size_category TEXT
  GENERATED ALWAYS AS (
    CASE 
      WHEN employee_count IS NULL THEN 'unknown'
      WHEN employee_count <= 10 THEN 'micro'      -- do 10
      WHEN employee_count <= 50 THEN 'vsmall'     -- 11-50
      WHEN employee_count <= 250 THEN 'small'     -- 51-250
      WHEN employee_count <= 750 THEN 'medium'    -- 251-750
      ELSE 'large'                                 -- >750
    END
  ) STORED;

-- Indexy
CREATE INDEX IF NOT EXISTS idx_company_vsme ON company(is_vsme) WHERE is_vsme = true;
CREATE INDEX IF NOT EXISTS idx_company_employee_size ON company(employee_size_category);

-- Dokumentácia
COMMENT ON COLUMN company.employee_count IS 'Počet zamestnancov (priemer počas finančného roka) - určuje VSME status';
COMMENT ON COLUMN company.is_vsme IS 'Generated: TRUE ak je firma VSME (<= 750 zamestnancov)';
COMMENT ON COLUMN company.employee_size_category IS 'Generated: Kategória veľkosti (micro, vsmall, small, medium, large)';

-- ============================================================================
-- PHASE 2: REPORT EXTENSIONS
-- ============================================================================

ALTER TABLE IF EXISTS report
ADD COLUMN IF NOT EXISTS reporting_year_sequence INTEGER
  DEFAULT 1
  CONSTRAINT check_year_sequence CHECK (reporting_year_sequence > 0);

COMMENT ON COLUMN report.reporting_year_sequence IS 'Poradie reportovania: 1 = prvý rok, 2 = druhý rok, 3+ = ďalšie roky';

-- Triggerom sa bude počítať automaticky na základe histórie
CREATE OR REPLACE FUNCTION fn_calculate_reporting_sequence()
RETURNS TRIGGER AS $$
BEGIN
  -- Ak report neexistuje, počítaj sekvenciu
  IF NEW.reporting_year_sequence IS NULL THEN
    SELECT COALESCE(MAX(reporting_year_sequence), 0) + 1
    INTO NEW.reporting_year_sequence
    FROM report
    WHERE company_id = NEW.company_id
      AND id != NEW.id;
  END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_calculate_reporting_sequence ON report;
CREATE TRIGGER trg_calculate_reporting_sequence
  BEFORE INSERT ON report
  FOR EACH ROW
  EXECUTE FUNCTION fn_calculate_reporting_sequence();

COMMENT ON FUNCTION fn_calculate_reporting_sequence() IS 'Automaticky vypočítaj poradie reportovania';

-- ============================================================================
-- PHASE 3: DISCLOSURE_QUESTION EXTENSIONS
-- ============================================================================

ALTER TABLE IF EXISTS disclosure_question
ADD COLUMN IF NOT EXISTS applies_to_vsme_year INTEGER[]
  DEFAULT ARRAY[1, 2, 3]
  CONSTRAINT check_vsme_year CHECK (applies_to_vsme_year @> ARRAY[1]::INTEGER[] OR applies_to_vsme_year IS NULL);

COMMENT ON COLUMN disclosure_question.applies_to_vsme_year IS 'Roky reportingu pre VSME: [1] = R1, [1,2,3] = všetky, [2,3] = od R2';

ALTER TABLE IF EXISTS disclosure_question
ADD COLUMN IF NOT EXISTS is_phased_in_for_vsme BOOLEAN DEFAULT false;

COMMENT ON COLUMN disclosure_question.is_phased_in_for_vsme IS 'TRUE ak sa táto otázka postupne zavádza pre VSME (fázovanie)';

ALTER TABLE IF EXISTS disclosure_question
ADD COLUMN IF NOT EXISTS vsme_note TEXT;

COMMENT ON COLUMN disclosure_question.vsme_note IS 'Vysvětlení pre VSME: "Vo R1 nie je povinné", "Vypúštiť Scope 3", atď.';

-- Indexy
CREATE INDEX IF NOT EXISTS idx_dq_vsme_year ON disclosure_question USING GIN (applies_to_vsme_year);
CREATE INDEX IF NOT EXISTS idx_dq_phased_in_vsme ON disclosure_question(is_phased_in_for_vsme) WHERE is_phased_in_for_vsme = true;

-- ============================================================================
-- PHASE 4: DISCLOSURE_ANSWER EXTENSIONS
-- ============================================================================

ALTER TABLE IF EXISTS disclosure_answer
ADD COLUMN IF NOT EXISTS is_vsme_required BOOLEAN;

COMMENT ON COLUMN disclosure_answer.is_vsme_required IS 'Determinované dynamicky na základě roku reportingu a VSME statusu';

-- ============================================================================
-- VIEWS - Logika pro filtrovani
-- ============================================================================

-- View 1: Povinné otázky pro VSME v konkrétnom roku
CREATE OR REPLACE VIEW v_vsme_applicable_questions AS
SELECT 
  dq.id,
  dq.code,
  dq.question_text,
  dq.topic_id,
  dq.is_mandatory,
  dq.is_conditional,
  dq.applies_to_vsme_year,
  dq.is_phased_in_for_vsme,
  dq.vsme_note,
  
  -- Kategorization
  CASE 
    WHEN dq.is_phased_in_for_vsme THEN 'phased-in'
    WHEN dq.is_mandatory THEN 'mandatory'
    WHEN dq.is_conditional THEN 'conditional'
    ELSE 'voluntary'
  END as requirement_type
  
FROM disclosure_question dq
WHERE dq.is_voluntary = false  -- Iba povinné + conditional
ORDER BY dq.topic_id, dq.order_index;

COMMENT ON VIEW v_vsme_applicable_questions IS 'Všetky relevantné otázky pre VSME';

-- View 2: Otázky s filtrovaním podľa roku sekvecie a firmy
CREATE OR REPLACE VIEW v_vsme_questions_by_year_and_company AS
SELECT 
  dq.id,
  c.id as company_id,
  c.is_vsme,
  r.id as report_id,
  r.reporting_year_sequence,
  dq.code,
  dq.question_text,
  dq.topic_id,
  dq.is_mandatory,
  
  -- Či sa má otázka zbazovať v tomto roku
  (dq.applies_to_vsme_year @> ARRAY[r.reporting_year_sequence]) as is_applicable,
  
  -- Či je povinná
  (dq.applies_to_vsme_year @> ARRAY[r.reporting_year_sequence] AND dq.is_mandatory) as is_required_this_year,
  
  -- VSME poznámka
  dq.vsme_note,
  
  -- Progress
  COALESCE(da.answer_text, da.value_text::TEXT, 'EMPTY') as current_value,
  (da.id IS NOT NULL) as is_answered
  
FROM company c
JOIN report r ON r.company_id = c.id
JOIN disclosure_question dq ON true  -- Cartesian, filtrujeme v WHERE
LEFT JOIN disclosure_answer da ON da.question_id = dq.id 
  AND da.report_id = r.id
WHERE c.is_vsme = true
ORDER BY r.reporting_year_sequence, dq.topic_id, dq.order_index;

COMMENT ON VIEW v_vsme_questions_by_year_and_company IS 'Filtrované otázky podľa roku reportingu a VSME statusu';

-- View 3: Progress tracking - koľko otázok je hotových
CREATE OR REPLACE VIEW v_vsme_report_progress AS
SELECT 
  c.id as company_id,
  c.name as company_name,
  c.is_vsme,
  r.id as report_id,
  r.reporting_year,
  r.reporting_year_sequence,
  
  -- Počty
  COUNT(DISTINCT dq.id) as total_applicable_questions,
  COUNT(DISTINCT CASE WHEN da.id IS NOT NULL THEN dq.id END) as answered_questions,
  COUNT(DISTINCT CASE WHEN dq.is_mandatory AND da.id IS NULL THEN dq.id END) as missing_mandatory,
  
  -- Percenty
  ROUND(100.0 * COUNT(DISTINCT CASE WHEN da.id IS NOT NULL THEN dq.id END) / 
    NULLIF(COUNT(DISTINCT dq.id), 0), 1) as progress_percent
  
FROM company c
JOIN report r ON r.company_id = c.id
JOIN disclosure_question dq ON dq.applies_to_vsme_year @> ARRAY[r.reporting_year_sequence]
LEFT JOIN disclosure_answer da ON da.question_id = dq.id AND da.report_id = r.id
WHERE c.is_vsme = true
GROUP BY c.id, c.name, c.is_vsme, r.id, r.reporting_year, r.reporting_year_sequence;

COMMENT ON VIEW v_vsme_report_progress IS 'Progress otázok na report pre VSME';

-- View 4: Kategorizácia otázok - Teraz / Budúce / Voliteľné
CREATE OR REPLACE VIEW v_vsme_question_categories AS
SELECT 
  c.id as company_id,
  r.id as report_id,
  r.reporting_year_sequence,
  
  -- Kategórie
  'now' as category,
  COUNT(DISTINCT dq.id) as question_count,
  ARRAY_AGG(DISTINCT dq.code) as datapoint_codes
  
FROM company c
JOIN report r ON r.company_id = c.id
JOIN disclosure_question dq ON dq.applies_to_vsme_year @> ARRAY[r.reporting_year_sequence]
  AND dq.is_voluntary = false
WHERE c.is_vsme = true
GROUP BY c.id, r.id, r.reporting_year_sequence

UNION ALL

SELECT 
  c.id as company_id,
  r.id as report_id,
  r.reporting_year_sequence,
  'future' as category,
  COUNT(DISTINCT dq.id) as question_count,
  ARRAY_AGG(DISTINCT dq.code) as datapoint_codes
  
FROM company c
JOIN report r ON r.company_id = c.id
JOIN disclosure_question dq ON NOT (dq.applies_to_vsme_year @> ARRAY[r.reporting_year_sequence])
  AND dq.applies_to_vsme_year @> ARRAY[r.reporting_year_sequence + 1]
  AND dq.is_voluntary = false
WHERE c.is_vsme = true
GROUP BY c.id, r.id, r.reporting_year_sequence

UNION ALL

SELECT 
  c.id as company_id,
  r.id as report_id,
  r.reporting_year_sequence,
  'voluntary' as category,
  COUNT(DISTINCT dq.id) as question_count,
  ARRAY_AGG(DISTINCT dq.code) as datapoint_codes
  
FROM company c
JOIN report r ON r.company_id = c.id
JOIN disclosure_question dq ON dq.is_voluntary = true
WHERE c.is_vsme = true
GROUP BY c.id, r.id, r.reporting_year_sequence;

COMMENT ON VIEW v_vsme_question_categories IS '4-sekciový breakdown: Teraz / Budúce / Voliteľné pre VSME';

-- ============================================================================
-- FUNCTIONS
-- ============================================================================

-- Funkcia: Skontroluj či je otázka povinná pre konkrétny report
CREATE OR REPLACE FUNCTION fn_is_question_required_for_report(
  p_question_id UUID,
  p_report_id UUID
) RETURNS BOOLEAN AS $$
DECLARE
  v_is_mandatory BOOLEAN;
  v_applies_to_year INTEGER[];
  v_report_year_sequence INTEGER;
BEGIN
  -- Načítaj údaje
  SELECT dq.is_mandatory, dq.applies_to_vsme_year
  INTO v_is_mandatory, v_applies_to_year
  FROM disclosure_question dq
  WHERE dq.id = p_question_id;
  
  SELECT r.reporting_year_sequence
  INTO v_report_year_sequence
  FROM report r
  WHERE r.id = p_report_id;
  
  -- Skontroluj
  IF v_is_mandatory = false THEN
    RETURN false;
  END IF;
  
  IF v_applies_to_year IS NULL THEN
    RETURN false;
  END IF;
  
  -- Aplikuje sa v tomto roku?
  RETURN v_applies_to_year @> ARRAY[v_report_year_sequence];
END;
$$ LANGUAGE plpgsql IMMUTABLE;

COMMENT ON FUNCTION fn_is_question_required_for_report(UUID, UUID) IS 'Skontroluj či je otázka povinná pre konkrétny report';

-- Funkcia: Načítaj VSME report progress
CREATE OR REPLACE FUNCTION fn_get_vsme_report_progress(p_report_id UUID)
RETURNS TABLE(
  total_applicable INTEGER,
  answered INTEGER,
  missing_mandatory INTEGER,
  progress_percent NUMERIC
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    COUNT(DISTINCT dq.id)::INTEGER,
    COUNT(DISTINCT CASE WHEN da.id IS NOT NULL THEN dq.id END)::INTEGER,
    COUNT(DISTINCT CASE WHEN dq.is_mandatory AND da.id IS NULL THEN dq.id END)::INTEGER,
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN da.id IS NOT NULL THEN dq.id END) / 
      NULLIF(COUNT(DISTINCT dq.id), 0), 1)::NUMERIC
  FROM report r
  JOIN disclosure_question dq ON dq.applies_to_vsme_year @> ARRAY[r.reporting_year_sequence]
  LEFT JOIN disclosure_answer da ON da.question_id = dq.id AND da.report_id = r.id
  WHERE r.id = p_report_id;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION fn_get_vsme_report_progress(UUID) IS 'Načítaj progress report pre VSME';

-- Funkcia: Skontroluj či je firma VSME a je v R1
CREATE OR REPLACE FUNCTION fn_is_vsme_first_year(
  p_company_id UUID
) RETURNS BOOLEAN AS $$
DECLARE
  v_is_vsme BOOLEAN;
  v_min_sequence INTEGER;
BEGIN
  SELECT c.is_vsme, MIN(r.reporting_year_sequence)
  INTO v_is_vsme, v_min_sequence
  FROM company c
  LEFT JOIN report r ON r.company_id = c.id
  WHERE c.id = p_company_id
  GROUP BY c.id;
  
  RETURN v_is_vsme AND (v_min_sequence IS NULL OR v_min_sequence = 1);
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION fn_is_vsme_first_year(UUID) IS 'Skontroluj či je firma VSME a bude mať svoj prvý report';

-- ============================================================================
-- POLICIES & PERMISSIONS
-- ============================================================================

-- RLS sa nakonfiguruje neskôr - zatiaľ len schéma
-- Princíp: 
-- - Len vlastník firmy/user vidí employee_count
-- - Tím vidí aggregované dáta
-- - Auditors vidí confirmáciu employee_count

-- ============================================================================
-- TEST DATA & SEED
-- ============================================================================

-- Príklad: Aktualizuj existujúce otázky s VSME info
-- (To sa bude robiť cez importer, teraz len schéma)

-- Príklad VSME otázky (všetci roky):
-- UPDATE disclosure_question SET applies_to_vsme_year = ARRAY[1,2,3]
-- WHERE code IN ('E1.IRO-1_01', 'SBM-1_01', 'SBM-3_01');

-- Príklad fázo otázky (R2 a neskôr):
-- UPDATE disclosure_question SET 
--   applies_to_vsme_year = ARRAY[2,3],
--   is_phased_in_for_vsme = true,
--   vsme_note = 'Pre VSME povinné až od roku 2'
-- WHERE code = 'S1-1_01';

-- ============================================================================
-- MIGRATION VALIDATION
-- ============================================================================

-- Overit že tabuľky existujú
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name='company' AND column_name='employee_count'
  ) THEN
    RAISE EXCEPTION 'Migrácia zlyhala: company.employee_count neexistuje';
  END IF;
  
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name='report' AND column_name='reporting_year_sequence'
  ) THEN
    RAISE EXCEPTION 'Migrácia zlyhala: report.reporting_year_sequence neexistuje';
  END IF;
  
  RAISE NOTICE 'VSME migrácia úspešná! ✅';
END $$;
