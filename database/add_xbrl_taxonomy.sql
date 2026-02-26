-- ============================================================================
-- XBRL Taxonomy para ESRS Datapoints
-- ============================================================================
-- Cieľ: Mapovať ESRS datapoints na XBRL elementy bez zmeny existujúcich tabuliek
-- 
-- XBRL (eXtensible Business Reporting Language) je XML-based štandard pre 
-- digitálny reporting v EU. EFRAG vyvíja XBRL taxonomies pre ESRS.
--
-- Táto migrácia:
-- 1. Vytvorí nové tabuľky pre XBRL taxonomy
-- 2. Nechá staré tabuľky bez zmien (backup)
-- 3. Umožní budúci export v XBRL/ESEF formáte
--
-- Referencia: EFRAG Taxonomy Workstream - Digital Reporting with XBRL
-- ============================================================================

-- ============================================================================
-- 1. XBRL TAXONOMY - Základná tabuľka
-- ============================================================================

CREATE TABLE IF NOT EXISTS xbrl_taxonomy (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  
  -- Identifikácia
  taxonomy_code TEXT NOT NULL UNIQUE,        -- 'esrs-2024', 'esrs-vsme-2024'
  taxonomy_name TEXT NOT NULL,               -- 'ESRS 2024', 'ESRS VSME 2024'
  version TEXT NOT NULL,                     -- '1.0', '1.1'
  
  -- Metadata
  namespace TEXT NOT NULL,                   -- 'http://xbrl.ifrs.org/taxonomy/esrs-2024'
  entry_point TEXT NOT NULL,                 -- 'esrs-2024-full.xsd'
  
  -- Aplikovateľnosť
  applies_to TEXT[] NOT NULL,                -- ['full', 'vsme', 'lsme']
  regulatory_region TEXT,                    -- 'EU', 'UK', 'other'
  
  -- Verzia a dátumy
  effective_date DATE NOT NULL,
  supersedes_taxonomy_id UUID REFERENCES xbrl_taxonomy(id),
  
  -- Zdroj a dokumentácia
  source_url TEXT,                           -- Link na EFRAG/EIOPA
  documentation_url TEXT,
  
  -- Stav
  is_active BOOLEAN DEFAULT true,
  
  -- Audit
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  created_by TEXT,
  notes TEXT
);

COMMENT ON TABLE xbrl_taxonomy IS 'Definície XBRL taxonomií pre rôzne ESRS verzie (full, VSME, LSME)';
COMMENT ON COLUMN xbrl_taxonomy.namespace IS 'XML namespace identifikácia (globálne unikátne)';
COMMENT ON COLUMN xbrl_taxonomy.entry_point IS 'Vstupný XSD súbor XBRL taxonomie';
COMMENT ON COLUMN xbrl_taxonomy.applies_to IS 'Array identifikátorov: full ESRS, VSME, LSME';

CREATE INDEX IF NOT EXISTS idx_xbrl_taxonomy_active ON xbrl_taxonomy(is_active) WHERE is_active = true;
CREATE INDEX IF NOT EXISTS idx_xbrl_taxonomy_effective ON xbrl_taxonomy(effective_date);

-- ============================================================================
-- 2. XBRL ELEMENTS - Jednotlivé elementy v taxonomii
-- ============================================================================

CREATE TABLE IF NOT EXISTS xbrl_element (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  
  -- XBRL Identifikácia
  xbrl_element_id TEXT NOT NULL,             -- 'esrs_E1_GOV_3_01'
  xbrl_tag TEXT NOT NULL,                    -- Ľuďský čitateľný tag
  
  -- Vzťah k taxonomii
  taxonomy_id UUID NOT NULL REFERENCES xbrl_taxonomy(id),
  
  -- Typ a charakteristika
  element_type TEXT NOT NULL,                -- 'Concept' (data element)
  data_type TEXT NOT NULL,                   -- 'xbrli:stringItemType', 'xbrli:decimalItemType', etc.
  period_type TEXT,                          -- 'instant', 'duration'
  
  -- Popis z XBRL
  label_en TEXT NOT NULL,
  label_sk TEXT,
  documentation_text TEXT,                   -- Definition z XBRL
  
  -- Jednotky a jednotky
  unit_ref TEXT,                             -- 'iso4217:EUR', 'xbrli:pure', 'iso80000-3:t' (tony)
  
  -- Vzťahy v XBRL hierarchii
  parent_element_id UUID REFERENCES xbrl_element(id),
  context_scenario TEXT,                     -- 'member', 'axis', etc.
  
  -- Povinnosť a podmienky
  is_required BOOLEAN DEFAULT false,
  is_monetary BOOLEAN DEFAULT false,
  is_numeric BOOLEAN DEFAULT false,
  is_nonfraction BOOLEAN DEFAULT false,
  
  -- Metadata
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  
  UNIQUE(taxonomy_id, xbrl_element_id)
);

COMMENT ON TABLE xbrl_element IS 'XBRL elementy zo taxonomie - definície dátových bodov';
COMMENT ON COLUMN xbrl_element.data_type IS 'XBRL data type (string, decimal, boolean, date, uri, etc.)';
COMMENT ON COLUMN xbrl_element.period_type IS 'instant=bod v čase (e.g., teplota), duration=počas obdobia (e.g., emisia za rok)';
COMMENT ON COLUMN xbrl_element.unit_ref IS 'Jednotka podľa ISO štandardov alebo XBRL conventions';

CREATE INDEX IF NOT EXISTS idx_xbrl_element_taxonomy ON xbrl_element(taxonomy_id);
CREATE INDEX IF NOT EXISTS idx_xbrl_element_id ON xbrl_element(xbrl_element_id);
CREATE INDEX IF NOT EXISTS idx_xbrl_element_parent ON xbrl_element(parent_element_id);

-- ============================================================================
-- 3. MAPPING: ESRS Datapoints <-> XBRL Elements
-- ============================================================================

CREATE TABLE IF NOT EXISTS esrs_to_xbrl_mapping (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  
  -- ESRS strana
  datapoint_id TEXT NOT NULL,                -- E1-1_01, S1-1_02, etc. (z ig3 CSV)
  esrs_standard TEXT NOT NULL,               -- 'E1', 'S1', 'S2', 'G1', 'ESRS 2', etc.
  esrs_disclosure_req TEXT,                  -- 'E1-1', 'SBM-1', etc.
  
  -- XBRL strana
  xbrl_element_id UUID NOT NULL REFERENCES xbrl_element(id),
  taxonomy_id UUID NOT NULL REFERENCES xbrl_taxonomy(id),
  
  -- Typ mappingu
  mapping_type TEXT NOT NULL,                -- 'direct' (1:1), 'split' (1:N), 'merged' (N:1), 'calculated'
  description TEXT,                         -- Vysvetlenie mappingu
  
  -- Kondicionálnosť
  is_conditional BOOLEAN DEFAULT false,
  condition_description TEXT,                -- "Iba ak je materiálne", "Iba <750 zamestnancov", etc.
  
  -- Aplikovateľnosť
  applies_to TEXT[] NOT NULL,                -- ['full', 'vsme'] - kedy je tento mapping relevantný
  
  -- Verzie
  valid_from_version TEXT,                   -- '2024-01'
  valid_to_version TEXT,                     -- '2024-03', NULL = current
  
  -- Audit
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  created_by TEXT,
  reviewed_by TEXT,
  
  UNIQUE(datapoint_id, taxonomy_id, valid_from_version)
);

COMMENT ON TABLE esrs_to_xbrl_mapping IS 'Mapovanie ESRS datapoints (z IG3) na XBRL elementy';
COMMENT ON COLUMN esrs_to_xbrl_mapping.mapping_type IS 'direct=1:1, split=jeden ESRS na viac XBRL, merged=viac ESRS na jeden XBRL, calculated=odvodovaný';
COMMENT ON COLUMN esrs_to_xbrl_mapping.applies_to IS 'Kedy sa tento mapping používa: full ESRS, VSME, LSME, atď.';

CREATE INDEX IF NOT EXISTS idx_mapping_datapoint ON esrs_to_xbrl_mapping(datapoint_id);
CREATE INDEX IF NOT EXISTS idx_mapping_xbrl ON esrs_to_xbrl_mapping(xbrl_element_id);
CREATE INDEX IF NOT EXISTS idx_mapping_taxonomy ON esrs_to_xbrl_mapping(taxonomy_id);
CREATE INDEX IF NOT EXISTS idx_mapping_esrs_std ON esrs_to_xbrl_mapping(esrs_standard);

-- ============================================================================
-- 4. DISCLOSURE_QUESTION <-> XBRL Linking Bridge
-- ============================================================================
-- Nie je zmena na disclosure_question, ale nový view/tabuľka pre spojenie

CREATE TABLE IF NOT EXISTS disclosure_question_xbrl (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  
  -- Vzťah na existujúcu otázku
  question_id UUID NOT NULL REFERENCES disclosure_question(id),
  
  -- XBRL elementy
  xbrl_element_id UUID NOT NULL REFERENCES xbrl_element(id),
  taxonomy_id UUID NOT NULL REFERENCES xbrl_taxonomy(id),
  
  -- Priorita (ak má otázka viac XBRL elementov)
  priority INTEGER DEFAULT 1,
  
  -- Metadata
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  
  UNIQUE(question_id, xbrl_element_id, taxonomy_id)
);

COMMENT ON TABLE disclosure_question_xbrl IS 'Bridge tabuľka - vzťah medzi otázkami v platforme a XBRL elementami';

CREATE INDEX IF NOT EXISTS idx_dq_xbrl_question ON disclosure_question_xbrl(question_id);
CREATE INDEX IF NOT EXISTS idx_dq_xbrl_element ON disclosure_question_xbrl(xbrl_element_id);

-- ============================================================================
-- 5. XBRL CONTEXT - Kontexty pre vykazovanie (instant vs duration)
-- ============================================================================

CREATE TABLE IF NOT EXISTS xbrl_context (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  
  -- Identifikácia
  context_id TEXT NOT NULL,                  -- 'Current2024-12-31', 'D2024', etc.
  taxonomy_id UUID NOT NULL REFERENCES xbrl_taxonomy(id),
  
  -- Typ
  context_type TEXT NOT NULL,                -- 'instant' (bod v čase), 'duration' (období)
  
  -- Inštant (e.g., 2024-12-31)
  instant_date DATE,
  
  -- Duration (od-do)
  start_date DATE,
  end_date DATE,
  
  -- Scenáre/členy (pre segmenttázto)
  scenario_members JSONB,                    -- {'geo': 'SK', 'business_line': 'Operations'}
  
  -- Metadata
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE xbrl_context IS 'XBRL kontexty definujú časový rámec a scenár pre dátové hodnoty';

CREATE INDEX IF NOT EXISTS idx_xbrl_context_taxonomy ON xbrl_context(taxonomy_id);
CREATE INDEX IF NOT EXISTS idx_xbrl_context_type ON xbrl_context(context_type);

-- ============================================================================
-- 6. XBRL UNITS - Definície jednotiek
-- ============================================================================

CREATE TABLE IF NOT EXISTS xbrl_unit (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  
  unit_ref TEXT NOT NULL UNIQUE,             -- 'iso4217:EUR', 'iso80000-3:t', 'xbrli:pure'
  
  -- Popis
  unit_name TEXT NOT NULL,
  unit_symbol TEXT,                          -- '€', 't', '%'
  
  -- Kategorization
  unit_type TEXT,                            -- 'currency', 'mass', 'volume', 'dimensionless', etc.
  
  -- Konverzia (na základnú jednotku)
  iso_code TEXT,                             -- 'EUR', 't', NULL
  
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE xbrl_unit IS 'Jednotky používané v XBRL - valuty, hmotnosti, atď.';

CREATE INDEX IF NOT EXISTS idx_xbrl_unit_ref ON xbrl_unit(unit_ref);
CREATE INDEX IF NOT EXISTS idx_xbrl_unit_type ON xbrl_unit(unit_type);

-- ============================================================================
-- 7. XBRL FACTS - Skutočné vykazované hodnoty (metadáta)
-- ============================================================================
-- POZNÁMKA: Skutočné hodnoty sú v disclosure_answer, 
-- táto tabuľka iba ukladá ich XBRL reprezentáciu

CREATE TABLE IF NOT EXISTS xbrl_fact_metadata (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  
  -- Vzťah na odpoveď
  answer_id UUID NOT NULL REFERENCES disclosure_answer(id),
  
  -- XBRL definícia
  xbrl_element_id UUID NOT NULL REFERENCES xbrl_element(id),
  xbrl_context_id UUID NOT NULL REFERENCES xbrl_context(id),
  xbrl_unit_id TEXT REFERENCES xbrl_unit(unit_ref),
  
  -- Presnosť a decimálne miesta
  decimals INTEGER,                          -- Pre numerické: -3 (tisíce), -2 (stovky), 2 (2 desatinné miesta)
  
  -- XML reprezentácia (pre export)
  xml_attributes JSONB,                      -- {'continuedAt': 'false', 'sign': 'minus'}
  
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  
  UNIQUE(answer_id, xbrl_element_id)
);

COMMENT ON TABLE xbrl_fact_metadata IS 'Mapovanie odpovede na XBRL fact - pre potreby exportu';

CREATE INDEX IF NOT EXISTS idx_xbrl_fact_answer ON xbrl_fact_metadata(answer_id);
CREATE INDEX IF NOT EXISTS idx_xbrl_fact_element ON xbrl_fact_metadata(xbrl_element_id);

-- ============================================================================
-- 8. XBRL EXPORT LOGS - Audit trail
-- ============================================================================

CREATE TABLE IF NOT EXISTS xbrl_export_log (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  
  -- Export údaje
  company_id UUID NOT NULL REFERENCES company(id),
  report_id UUID NOT NULL REFERENCES report(id),
  taxonomy_id UUID NOT NULL REFERENCES xbrl_taxonomy(id),
  
  -- Export detaily
  export_format TEXT NOT NULL,               -- 'XBRL', 'iXBRL', 'ESEF'
  export_filename TEXT,
  export_size_bytes BIGINT,
  
  -- Validácia
  validation_status TEXT,                    -- 'valid', 'warning', 'error'
  validation_errors TEXT[],
  
  -- Metadata
  exported_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  exported_by TEXT,
  
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE xbrl_export_log IS 'Log XBRL exportov - audit trail a validácia';

CREATE INDEX IF NOT EXISTS idx_xbrl_export_company ON xbrl_export_log(company_id);
CREATE INDEX IF NOT EXISTS idx_xbrl_export_report ON xbrl_export_log(report_id);

-- ============================================================================
-- 9. XBRL VALIDATION RULES - Validačné pravidlá
-- ============================================================================

CREATE TABLE IF NOT EXISTS xbrl_validation_rule (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  
  -- Identifikácia
  rule_code TEXT NOT NULL UNIQUE,            -- 'XBRL-E1-001', 'XBRL-VSME-002'
  rule_name TEXT NOT NULL,
  
  -- Popis
  description TEXT NOT NULL,
  
  -- Typ validácie
  rule_type TEXT NOT NULL,                   -- 'consistency', 'completeness', 'format', 'calculation'
  
  -- SQL/Logika pre validáciu
  validation_sql TEXT,
  error_message TEXT,
  error_severity TEXT,                       -- 'error', 'warning', 'info'
  
  -- Aplikovateľnosť
  applies_to TEXT[] NOT NULL,                -- ['full', 'vsme']
  
  -- Status
  is_active BOOLEAN DEFAULT true,
  
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE xbrl_validation_rule IS 'Pravidlá na validáciu XBRL dát pred exportom';

-- ============================================================================
-- VIEWS
-- ============================================================================

-- View: Všetky ESRS datapoints s ich XBRL mappingami
CREATE OR REPLACE VIEW v_esrs_datapoints_with_xbrl AS
SELECT 
  dq.id as question_id,
  dq.code as esrs_datapoint,
  dq.question_text,
  
  -- XBRL info
  xe.xbrl_element_id,
  xe.xbrl_tag,
  xt.taxonomy_code,
  xt.taxonomy_name,
  
  -- Mapping info
  em.mapping_type,
  em.applies_to,
  
  -- Status
  xt.is_active as taxonomy_is_active
  
FROM disclosure_question dq
LEFT JOIN esrs_to_xbrl_mapping em ON em.datapoint_id = dq.code
LEFT JOIN xbrl_element xe ON xe.id = em.xbrl_element_id
LEFT JOIN xbrl_taxonomy xt ON xt.id = em.taxonomy_id
WHERE xt.is_active = true
ORDER BY dq.code, xt.effective_date DESC;

COMMENT ON VIEW v_esrs_datapoints_with_xbrl IS 'Všetky ESRS otázky s mapom na XBRL elementy';

-- View: Chýbajúce mappingy (ESRS bez XBRL)
CREATE OR REPLACE VIEW v_missing_xbrl_mappings AS
SELECT DISTINCT
  dq.code as esrs_datapoint,
  dq.question_text,
  dq.topic_id
FROM disclosure_question dq
WHERE NOT EXISTS (
  SELECT 1 FROM esrs_to_xbrl_mapping em 
  WHERE em.datapoint_id = dq.code
);

COMMENT ON VIEW v_missing_xbrl_mappings IS 'ESRS datapoints bez XBRL mappingu';

-- ============================================================================
-- INITIAL DATA - Základný ESRS 2024 XBRL Taxonomy (prázdny, čaká na naplnenie)
-- ============================================================================

INSERT INTO xbrl_taxonomy (
  taxonomy_code, 
  taxonomy_name, 
  version, 
  namespace, 
  entry_point, 
  applies_to, 
  regulatory_region,
  effective_date, 
  source_url,
  is_active
) VALUES (
  'esrs-2024-full',
  'ESRS 2024 Full Taxonomy',
  '1.0',
  'http://xbrl.ifrs.org/taxonomy/esrs-2024-full',
  'esrs-2024-full.xsd',
  ARRAY['full'],
  'EU',
  '2024-01-01',
  'https://www.efrag.org/en/sustainability-reporting/esrs-workstreams/digital-reporting-with-xbrl',
  true
)
ON CONFLICT DO NOTHING;

INSERT INTO xbrl_taxonomy (
  taxonomy_code, 
  taxonomy_name, 
  version, 
  namespace, 
  entry_point, 
  applies_to,
  regulatory_region,
  effective_date,
  source_url,
  is_active
) VALUES (
  'esrs-2024-vsme',
  'ESRS 2024 VSME Voluntary Taxonomy',
  '1.0',
  'http://xbrl.ifrs.org/taxonomy/esrs-2024-vsme',
  'esrs-2024-vsme.xsd',
  ARRAY['vsme'],
  'EU',
  '2024-01-01',
  'https://www.efrag.org/en/sustainability-reporting/esrs-workstreams/digital-reporting-with-xbrl',
  false  -- Bude aktívne keď bude finalizovaná VSME taxonomie
)
ON CONFLICT DO NOTHING;

-- ============================================================================
-- FUNCTIONS
-- ============================================================================

-- Funkcia: Vygeneruj XBRL XML snippet pre answer
CREATE OR REPLACE FUNCTION fn_generate_xbrl_fact_xml(
  p_answer_id UUID,
  p_taxonomy_id UUID
) RETURNS TEXT AS $$
DECLARE
  v_element_id TEXT;
  v_value TEXT;
  v_context_id TEXT;
  v_unit_ref TEXT;
  v_decimals INTEGER;
BEGIN
  -- Vyhľad metadata
  SELECT 
    xe.xbrl_element_id,
    COALESCE((da.value_numeric::TEXT), da.value_text, da.value_date::TEXT, da.answer_text),
    xc.context_id,
    xfm.xbrl_unit_id,
    xfm.decimals
  INTO v_element_id, v_value, v_context_id, v_unit_ref, v_decimals
  FROM disclosure_answer da
  JOIN xbrl_fact_metadata xfm ON xfm.answer_id = da.id
  JOIN xbrl_element xe ON xe.id = xfm.xbrl_element_id
  JOIN xbrl_context xc ON xc.id = xfm.xbrl_context_id
  WHERE da.id = p_answer_id AND xfm.xbrl_element_id IN (
    SELECT id FROM xbrl_element WHERE taxonomy_id = p_taxonomy_id
  )
  LIMIT 1;
  
  IF NOT FOUND THEN
    RETURN NULL;
  END IF;
  
  -- Vygeneruj XML
  RETURN FORMAT(
    '<ix:continuation xmlns:ix="http://www.sec.gov/usfr/2018-01-31" '
    'contextRef="%s" unitRef="%s" decimals="%s" name="%s">%s</ix:continuation>',
    v_context_id,
    COALESCE(v_unit_ref, 'pure'),
    COALESCE(v_decimals::TEXT, 'INF'),
    v_element_id,
    v_value
  );
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION fn_generate_xbrl_fact_xml(UUID, UUID) IS 'Vygeneruj XBRL fact XML pre odpoveď';

-- Funkcia: Validuj XBRL completeness
CREATE OR REPLACE FUNCTION fn_validate_xbrl_completeness(
  p_report_id UUID,
  p_taxonomy_id UUID
) RETURNS TABLE(
  validation_result BOOLEAN,
  missing_count INTEGER,
  missing_elements TEXT[]
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    COUNT(*) = 0,
    COUNT(*)::INTEGER,
    ARRAY_AGG(DISTINCT xe.xbrl_element_id)
  FROM xbrl_element xe
  LEFT JOIN disclosure_question_xbrl dqx ON dqx.xbrl_element_id = xe.id
  LEFT JOIN disclosure_answer da ON da.question_id = dqx.question_id
    AND da.report_id = p_report_id
  WHERE xe.taxonomy_id = p_taxonomy_id
    AND xe.is_required = true
    AND da.id IS NULL;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION fn_validate_xbrl_completeness(UUID, UUID) IS 'Validuj že všetky povinné XBRL elementy sú vyplnené';

-- ============================================================================
-- PERMISSIONS
-- ============================================================================

-- RLS by mala byť implementovaná podobne ako na ostatných tabuľkách
-- Teraz je len štruktúra - RLS sa konfiguruje neskôr

-- ============================================================================
-- DOKUMENTÁCIA
-- ============================================================================

-- Ako naplniť mappingy:
-- 1. Stiahnuť XBRL schémy z https://www.efrag.org/en/sustainability-reporting/esrs-workstreams/digital-reporting-with-xbrl
-- 2. Parsovať XSD súbory a naplniť xbrl_element tabuľku
-- 3. Z IG3 CSV mapovať datapoint_id na xbrl_element_id
-- 4. Vložiť do esrs_to_xbrl_mapping tabuľky

-- Príklady mappingu (budú naplnené neskôr):
-- E1-1_01 (Disclosure on GHG emissions) -> esrs_E1_A_A1_001
-- S1-1_01 (Number of employees) -> esrs_S1_C_1_01
-- atď.
