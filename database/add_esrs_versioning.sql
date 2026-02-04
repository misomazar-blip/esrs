-- =====================================================
-- ESRS VERSIONING & DATAPOINTS
-- =====================================================
-- Umožňuje verzie ESRS štandardov, porovnávanie v čase,
-- a jednoduchú aktualizáciu obsahu

-- =====================================================
-- 1. ESRS VERZIE
-- =====================================================

CREATE TABLE IF NOT EXISTS esrs_version (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  version_code TEXT UNIQUE NOT NULL,        -- '2023', '2024', '2025'
  version_name TEXT NOT NULL,               -- 'ESRS 2023 (Original)', 'EFRAG IG3 May 2024'
  effective_date DATE,                      -- kedy nadobudla účinnosť
  description TEXT,                         -- popis zmien
  is_active BOOLEAN DEFAULT TRUE,           -- aktuálna verzia?
  source_url TEXT,                          -- link na oficiálny dokument
  created_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE esrs_version IS 'Verzie ESRS štandardov - umožňuje spravovať zmeny v čase';
COMMENT ON COLUMN esrs_version.version_code IS 'Krátky kód verzie (napr. 2024, 2024-addendum)';
COMMENT ON COLUMN esrs_version.is_active IS 'TRUE = aktuálna verzia pre nové reporty';

-- Index
CREATE INDEX IF NOT EXISTS idx_esrs_version_active ON esrs_version(is_active) WHERE is_active = TRUE;

-- =====================================================
-- 2. ROZŠÍRENIE REPORT - pridať verziu
-- =====================================================

ALTER TABLE report 
ADD COLUMN IF NOT EXISTS esrs_version_id UUID REFERENCES esrs_version(id);

COMMENT ON COLUMN report.esrs_version_id IS 'Verzia ESRS štandardu použitá v tomto reporte';

-- =====================================================
-- 3. ROZŠÍRENIE DISCLOSURE_QUESTION - verzie a metadata
-- =====================================================

ALTER TABLE disclosure_question
-- Verzia
ADD COLUMN IF NOT EXISTS version_id UUID REFERENCES esrs_version(id),

-- EFRAG IG3 metadata
ADD COLUMN IF NOT EXISTS datapoint_id TEXT,           -- 'E1-1', 'E1-2' - stabilný naprieč verziami
ADD COLUMN IF NOT EXISTS esrs_paragraph TEXT,         -- 'ESRS 2.GOV-1.AR 16(a)'
ADD COLUMN IF NOT EXISTS disclosure_requirement TEXT, -- 'GOV-1', 'E1-1'

-- Mandatory/Voluntary
ADD COLUMN IF NOT EXISTS is_mandatory BOOLEAN DEFAULT false,
ADD COLUMN IF NOT EXISTS is_phase_in BOOLEAN DEFAULT false,  -- postupné zavádzanie
ADD COLUMN IF NOT EXISTS phase_in_year INTEGER,              -- rok kedy sa stáva povinným
ADD COLUMN IF NOT EXISTS applies_to TEXT[],                  -- ['large company', 'listed SME']

-- Conditional requirements
ADD COLUMN IF NOT EXISTS is_conditional BOOLEAN DEFAULT false,
ADD COLUMN IF NOT EXISTS condition_description TEXT,

-- Typy dát a jednotky
ADD COLUMN IF NOT EXISTS data_type TEXT DEFAULT 'narrative',  -- 'narrative', 'percentage', 'date', 'monetary', 'boolean', 'integer'
ADD COLUMN IF NOT EXISTS unit TEXT,                           -- 'tonnes CO2e', '%', 'EUR', 'number'
ADD COLUMN IF NOT EXISTS value_options TEXT[],                -- pre výberové polia

-- Hierarchia (sub-datapoints)
ADD COLUMN IF NOT EXISTS parent_question_id UUID REFERENCES disclosure_question(id),
ADD COLUMN IF NOT EXISTS level INTEGER DEFAULT 1,

-- Guidance
ADD COLUMN IF NOT EXISTS guidance_text TEXT,
ADD COLUMN IF NOT EXISTS example_answer TEXT,

-- Verziovanie
ADD COLUMN IF NOT EXISTS valid_from DATE,
ADD COLUMN IF NOT EXISTS valid_to DATE,
ADD COLUMN IF NOT EXISTS superseded_by UUID REFERENCES disclosure_question(id),  -- nahradené novou verziou
ADD COLUMN IF NOT EXISTS supersedes UUID REFERENCES disclosure_question(id),     -- nahrádza starú verziu

-- Metadata
ADD COLUMN IF NOT EXISTS tags TEXT[],                         -- ['climate', 'scope-1', 'emissions']
ADD COLUMN IF NOT EXISTS updated_at TIMESTAMPTZ DEFAULT NOW();

-- Indexy pre rýchle vyhľadávanie
CREATE INDEX IF NOT EXISTS idx_question_version ON disclosure_question(version_id);
CREATE INDEX IF NOT EXISTS idx_question_datapoint ON disclosure_question(datapoint_id);
CREATE INDEX IF NOT EXISTS idx_question_topic_version ON disclosure_question(topic_id, version_id);
CREATE INDEX IF NOT EXISTS idx_question_parent ON disclosure_question(parent_question_id);
CREATE INDEX IF NOT EXISTS idx_question_valid ON disclosure_question(valid_from, valid_to);

-- Komentáre
COMMENT ON COLUMN disclosure_question.datapoint_id IS 'Stabilný identifikátor naprieč verziami (E1-1, E1-2...)';
COMMENT ON COLUMN disclosure_question.superseded_by IS 'ID novšej verzie tejto otázky';
COMMENT ON COLUMN disclosure_question.supersedes IS 'ID staršej verzie, ktorú táto nahrádza';
COMMENT ON COLUMN disclosure_question.valid_from IS 'Dátum začiatku platnosti';
COMMENT ON COLUMN disclosure_question.valid_to IS 'Dátum konca platnosti (NULL = stále platí)';

-- =====================================================
-- 4. ROZŠÍRENIE DISCLOSURE_ANSWER - viacero typov hodnôt
-- =====================================================

ALTER TABLE disclosure_answer
-- Rôzne typy hodnôt
ADD COLUMN IF NOT EXISTS value_numeric NUMERIC(20,4),     -- čísla, percentá
ADD COLUMN IF NOT EXISTS value_integer INTEGER,           -- celé čísla
ADD COLUMN IF NOT EXISTS value_date DATE,                 -- dátumy
ADD COLUMN IF NOT EXISTS value_boolean BOOLEAN,           -- áno/nie
ADD COLUMN IF NOT EXISTS value_json JSONB,                -- komplexné štruktúry, tabuľky

-- Metadata odpovede
ADD COLUMN IF NOT EXISTS unit TEXT,                       -- jednotka použitá v odpovedi
ADD COLUMN IF NOT EXISTS data_quality TEXT,               -- 'verified', 'estimated', 'calculated', 'third-party'
ADD COLUMN IF NOT EXISTS source_document TEXT,            -- odkaz na podporný dokument
ADD COLUMN IF NOT EXISTS confidence_level TEXT,           -- 'high', 'medium', 'low'
ADD COLUMN IF NOT EXISTS notes TEXT,                      -- interné poznámky
ADD COLUMN IF NOT EXISTS last_reviewed_at TIMESTAMPTZ,    -- kedy bolo naposledy preverené
ADD COLUMN IF NOT EXISTS reviewed_by UUID REFERENCES auth.users(id);

-- Index
CREATE INDEX IF NOT EXISTS idx_answer_report ON disclosure_answer(report_id);
CREATE INDEX IF NOT EXISTS idx_answer_question ON disclosure_answer(question_id);

COMMENT ON COLUMN disclosure_answer.value_json IS 'Pre komplexné odpovede (tabuľky, zoznamy, štruktúrované dáta)';
COMMENT ON COLUMN disclosure_answer.data_quality IS 'Kvalita dát: verified (overené), estimated (odhadované), calculated (vypočítané)';

-- =====================================================
-- 5. TABUĽKA PRE MAPOVANIE VERZIÍ (porovnávanie)
-- =====================================================

CREATE TABLE IF NOT EXISTS datapoint_version_mapping (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  datapoint_id TEXT NOT NULL,                    -- E1-1
  old_question_id UUID REFERENCES disclosure_question(id),
  new_question_id UUID REFERENCES disclosure_question(id),
  mapping_type TEXT NOT NULL,                    -- 'identical', 'modified', 'split', 'merged', 'new', 'removed'
  change_description TEXT,                       -- popis zmeny
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(old_question_id, new_question_id)
);

COMMENT ON TABLE datapoint_version_mapping IS 'Mapovanie datapoints medzi verziami - umožňuje porovnanie v čase';
COMMENT ON COLUMN datapoint_version_mapping.mapping_type IS 'Typ zmeny: identical (rovnaké), modified (zmenené), split (rozdelené), merged (zlúčené), new (nové), removed (odstránené)';

CREATE INDEX IF NOT EXISTS idx_mapping_datapoint ON datapoint_version_mapping(datapoint_id);
CREATE INDEX IF NOT EXISTS idx_mapping_old ON datapoint_version_mapping(old_question_id);
CREATE INDEX IF NOT EXISTS idx_mapping_new ON datapoint_version_mapping(new_question_id);

-- =====================================================
-- 6. FUNKCIE PRE PRÁCU S VERZIAMI
-- =====================================================

-- Funkcia: Získať aktuálnu verziu ESRS
CREATE OR REPLACE FUNCTION get_active_esrs_version()
RETURNS UUID AS $$
BEGIN
  RETURN (SELECT id FROM esrs_version WHERE is_active = TRUE LIMIT 1);
END;
$$ LANGUAGE plpgsql;

-- Funkcia: Získať otázky pre konkrétnu verziu a topic
CREATE OR REPLACE FUNCTION get_questions_for_version(
  p_topic_id UUID,
  p_version_id UUID DEFAULT NULL
)
RETURNS TABLE (
  id UUID,
  code TEXT,
  question_text TEXT,
  datapoint_id TEXT,
  data_type TEXT,
  is_mandatory BOOLEAN
) AS $$
BEGIN
  -- Ak nie je zadaná verzia, použiť aktívnu
  IF p_version_id IS NULL THEN
    p_version_id := get_active_esrs_version();
  END IF;

  RETURN QUERY
  SELECT 
    dq.id,
    dq.code,
    dq.question_text,
    dq.datapoint_id,
    dq.data_type,
    dq.is_mandatory
  FROM disclosure_question dq
  WHERE dq.topic_id = p_topic_id
    AND dq.version_id = p_version_id
    AND (dq.valid_to IS NULL OR dq.valid_to > CURRENT_DATE)
  ORDER BY dq.order_index;
END;
$$ LANGUAGE plpgsql;

-- Funkcia: Nájsť zodpovedajúcu otázku v novej verzii
CREATE OR REPLACE FUNCTION find_equivalent_question(
  p_old_question_id UUID,
  p_new_version_id UUID
)
RETURNS UUID AS $$
DECLARE
  v_datapoint_id TEXT;
  v_new_question_id UUID;
BEGIN
  -- Získať datapoint_id starej otázky
  SELECT datapoint_id INTO v_datapoint_id
  FROM disclosure_question
  WHERE id = p_old_question_id;

  -- Nájsť otázku s rovnakým datapoint_id v novej verzii
  SELECT id INTO v_new_question_id
  FROM disclosure_question
  WHERE datapoint_id = v_datapoint_id
    AND version_id = p_new_version_id
  LIMIT 1;

  RETURN v_new_question_id;
END;
$$ LANGUAGE plpgsql;

-- Funkcia: Migrovať report na novú verziu
CREATE OR REPLACE FUNCTION migrate_report_to_version(
  p_report_id UUID,
  p_new_version_id UUID
)
RETURNS TABLE (
  old_question_id UUID,
  new_question_id UUID,
  mapping_type TEXT,
  migrated BOOLEAN
) AS $$
BEGIN
  RETURN QUERY
  WITH report_answers AS (
    SELECT DISTINCT question_id
    FROM disclosure_answer
    WHERE report_id = p_report_id
  )
  SELECT 
    ra.question_id as old_question_id,
    find_equivalent_question(ra.question_id, p_new_version_id) as new_question_id,
    COALESCE(dvm.mapping_type, 'unknown') as mapping_type,
    (find_equivalent_question(ra.question_id, p_new_version_id) IS NOT NULL) as migrated
  FROM report_answers ra
  LEFT JOIN datapoint_version_mapping dvm ON dvm.old_question_id = ra.question_id;
END;
$$ LANGUAGE plpgsql;

-- =====================================================
-- 7. INICIALIZÁCIA - defaultná verzia
-- =====================================================

-- Vložiť prvú verziu (aktuálne použité otázky)
INSERT INTO esrs_version (version_code, version_name, effective_date, is_active, description)
VALUES 
  ('2024-base', 'ESRS 2024 Base (Current)', '2024-01-01', TRUE, 'Aktuálne používané otázky v platforme')
ON CONFLICT (version_code) DO NOTHING;

-- Aktualizovať existujúce otázky - priradiť k base verzii
UPDATE disclosure_question 
SET version_id = (SELECT id FROM esrs_version WHERE version_code = '2024-base')
WHERE version_id IS NULL;

-- Aktualizovať existujúce reporty - priradiť k base verzii
UPDATE report
SET esrs_version_id = (SELECT id FROM esrs_version WHERE version_code = '2024-base')
WHERE esrs_version_id IS NULL;

-- =====================================================
-- 8. VIEWS PRE POHODLNÉ DOTAZY
-- =====================================================

-- View: Aktuálne platné otázky
CREATE OR REPLACE VIEW current_questions AS
SELECT 
  dq.*,
  t.code as topic_code,
  t.name as topic_name,
  ev.version_code,
  ev.version_name
FROM disclosure_question dq
JOIN topic t ON t.id = dq.topic_id
JOIN esrs_version ev ON ev.id = dq.version_id
WHERE dq.valid_to IS NULL OR dq.valid_to > CURRENT_DATE;

-- View: Porovnanie odpovedí medzi verziami
CREATE OR REPLACE VIEW answer_comparison AS
SELECT 
  da.report_id,
  dq.datapoint_id,
  dq.question_text,
  da.value_text,
  da.value_numeric,
  da.updated_at,
  ev.version_code
FROM disclosure_answer da
JOIN disclosure_question dq ON dq.id = da.question_id
JOIN esrs_version ev ON ev.id = dq.version_id;

-- =====================================================
-- HOTOVO
-- =====================================================

COMMENT ON TABLE datapoint_version_mapping IS 
'Umožňuje:
1. Sledovať zmeny datapoints medzi verziami
2. Automaticky mapovať odpovede pri upgrade
3. Generovať changelog pre používateľov
4. Porovnávať reporty naprieč rokmi aj keď sa štandard zmenil';
