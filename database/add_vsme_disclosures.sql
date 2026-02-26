-- ============================================================================
-- VSME DISCLOSURES SCHEMA
-- ============================================================================
-- Creates database tables for all VSME Basic Module (B1-B11) and 
-- Comprehensive Module (C1-C9) disclosures based on knowledge base files.
-- 
-- Each table stores disclosure-specific data linked to a company via FK.
-- Tables follow the "if applicable" principle - nullable columns allow 
-- partial reporting based on company context.
-- ============================================================================

-- ----------------------------------------------------------------------------
-- B1: BASIS FOR PREPARATION
-- ----------------------------------------------------------------------------
-- Corporate identity, legal structure, locations of operations
-- ----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS vsme_b1_basis_preparation (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    company_id UUID NOT NULL REFERENCES company(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    
    -- Legal structure (paragraph 24(e)(i))
    legal_form TEXT CHECK (legal_form IN (
        'private_limited_liability',
        'sole_proprietorship', 
        'partnership',
        'cooperative',
        'other'
    )),
    legal_form_other TEXT, -- if legal_form = 'other'
    
    -- Economic activity (paragraph 24(e)(ii))
    nace_code_primary TEXT NOT NULL, -- 2-5 digit NACE code
    nace_codes_additional TEXT[], -- array for multiple codes
    
    -- Sustainability certifications (paragraph 25)
    has_certifications BOOLEAN DEFAULT FALSE,
    certifications JSONB, -- [{name, issuer, valid_until, scope}]
    
    UNIQUE(company_id)
);

-- Sites/locations table (paragraph 24(e)(vi), (vii), paragraph 73)
CREATE TABLE IF NOT EXISTS vsme_b1_sites (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    company_id UUID NOT NULL REFERENCES company(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    
    site_type TEXT CHECK (site_type IN (
        'registered_office',
        'warehouse', 
        'industrial_plant',
        'retail_location',
        'office',
        'other'
    )),
    site_name TEXT,
    address TEXT NOT NULL,
    postal_code TEXT,
    city TEXT NOT NULL,
    country TEXT NOT NULL,
    
    -- Geolocation (paragraph 74-76) - 5 decimal places
    latitude DECIMAL(8,5), -- e.g. 48.14816
    longitude DECIMAL(8,5), -- e.g. 17.10674
    
    -- For larger sites (farms, mines)
    polygon_coordinates JSONB, -- array of {lat, lng} objects
    
    is_primary_operations BOOLEAN DEFAULT FALSE,
    has_significant_assets BOOLEAN DEFAULT FALSE
);

-- Index for company lookups
CREATE INDEX IF NOT EXISTS idx_vsme_b1_sites_company ON vsme_b1_sites(company_id);

-- ----------------------------------------------------------------------------
-- B2: PRACTICES, POLICIES AND FUTURE INITIATIVES  
-- ----------------------------------------------------------------------------
-- Table showing which sustainability areas have practices/policies
-- ----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS vsme_b2_practices (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    company_id UUID NOT NULL REFERENCES company(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    
    -- For each topic: null = not disclosed, text = description of practice
    climate_change TEXT,
    climate_change_accountable_role TEXT, -- senior level accountable
    
    pollution TEXT,
    pollution_accountable_role TEXT,
    
    water_marine TEXT,
    water_marine_accountable_role TEXT,
    
    biodiversity TEXT,
    biodiversity_accountable_role TEXT,
    
    circular_economy TEXT,
    circular_economy_accountable_role TEXT,
    
    own_workforce TEXT,
    own_workforce_accountable_role TEXT,
    
    value_chain_workers TEXT,
    value_chain_workers_accountable_role TEXT,
    
    affected_communities TEXT,
    affected_communities_accountable_role TEXT,
    
    consumers_end_users TEXT,
    consumers_end_users_accountable_role TEXT,
    
    business_conduct TEXT,
    business_conduct_accountable_role TEXT,
    
    UNIQUE(company_id)
);

-- ----------------------------------------------------------------------------
-- B3: ENERGY AND GREENHOUSE GAS EMISSIONS
-- ----------------------------------------------------------------------------
-- Core climate metrics: Scope 1, 2, 3 emissions
-- ----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS vsme_b3_ghg_emissions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    company_id UUID NOT NULL REFERENCES company(id) ON DELETE CASCADE,
    reporting_year INTEGER NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    
    -- Scope 1: Direct emissions (tCO2e)
    scope_1_total DECIMAL(15,2),
    scope_1_calculation_method TEXT, -- e.g. "GHG Protocol", "ISO 14064-1"
    
    -- Scope 2: Indirect emissions from purchased energy (tCO2e)
    scope_2_location_based DECIMAL(15,2),
    scope_2_market_based DECIMAL(15,2),
    scope_2_calculation_method TEXT,
    
    -- Scope 3: Value chain emissions (optional but recommended for certain sectors)
    scope_3_total DECIMAL(15,2),
    scope_3_categories_included TEXT[], -- e.g. ["purchased_goods", "business_travel"]
    scope_3_calculation_method TEXT,
    scope_3_screening_performed BOOLEAN DEFAULT FALSE,
    
    -- Total emissions
    total_emissions DECIMAL(15,2) GENERATED ALWAYS AS (
        COALESCE(scope_1_total, 0) + 
        COALESCE(scope_2_location_based, 0) + 
        COALESCE(scope_3_total, 0)
    ) STORED,
    
    -- Energy consumption (MWh)
    energy_consumption_total DECIMAL(15,2),
    energy_consumption_renewable DECIMAL(15,2),
    energy_consumption_non_renewable DECIMAL(15,2),
    
    UNIQUE(company_id, reporting_year)
);

CREATE INDEX IF NOT EXISTS idx_vsme_b3_company_year ON vsme_b3_ghg_emissions(company_id, reporting_year);

-- ----------------------------------------------------------------------------
-- B5: BIODIVERSITY
-- ----------------------------------------------------------------------------
-- Sites in/near biodiversity-sensitive areas + land use
-- ----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS vsme_b5_biodiversity_sites (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    company_id UUID NOT NULL REFERENCES company(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    
    site_name TEXT NOT NULL,
    country TEXT NOT NULL,
    area_hectares DECIMAL(12,4),
    
    -- Biodiversity-sensitive area details (paragraph 33, 134-137)
    is_in_sensitive_area BOOLEAN DEFAULT FALSE,
    is_near_sensitive_area BOOLEAN DEFAULT FALSE,
    
    sensitive_area_type TEXT CHECK (sensitive_area_type IN (
        'natura_2000',
        'unesco_world_heritage',
        'key_biodiversity_area',
        'iucn_protected',
        'national_protected',
        'river_basin_district',
        'other'
    )),
    sensitive_area_name TEXT,
    
    -- Documentation source
    documentation_source TEXT, -- URL to WDPA, KBA database, etc.
    verification_date DATE
);

CREATE INDEX IF NOT EXISTS idx_vsme_b5_company ON vsme_b5_biodiversity_sites(company_id);

-- Land use table (paragraph 34, 138-141)
CREATE TABLE IF NOT EXISTS vsme_b5_land_use (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    company_id UUID NOT NULL REFERENCES company(id) ON DELETE CASCADE,
    reporting_year INTEGER NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    
    -- Areas in hectares or m²
    total_sealed_area_ha DECIMAL(15,4), -- roads, buildings, parking
    total_nature_oriented_onsite_ha DECIMAL(15,4), -- green roofs, etc.
    total_nature_oriented_offsite_ha DECIMAL(15,4), -- off-site conservation
    
    total_land_use_ha DECIMAL(15,4) GENERATED ALWAYS AS (
        COALESCE(total_sealed_area_ha, 0) + 
        COALESCE(total_nature_oriented_onsite_ha, 0) +
        COALESCE(total_nature_oriented_offsite_ha, 0)
    ) STORED,
    
    -- Year-over-year changes
    sealed_area_change_pct DECIMAL(5,2),
    nature_oriented_onsite_change_pct DECIMAL(5,2),
    nature_oriented_offsite_change_pct DECIMAL(5,2),
    
    UNIQUE(company_id, reporting_year)
);

-- ----------------------------------------------------------------------------
-- B6: WATER (placeholder - spec TBD from file)
-- ----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS vsme_b6_water (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    company_id UUID NOT NULL REFERENCES company(id) ON DELETE CASCADE,
    reporting_year INTEGER NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    
    -- Placeholder for water metrics - to be expanded based on B6.txt
    water_consumption_total_m3 DECIMAL(15,2),
    water_discharge_total_m3 DECIMAL(15,2),
    water_in_stress_areas BOOLEAN,
    
    UNIQUE(company_id, reporting_year)
);

-- ----------------------------------------------------------------------------
-- B7: RESOURCE USE, CIRCULAR ECONOMY, WASTE (placeholder - spec TBD)
-- ----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS vsme_b7_circular_economy (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    company_id UUID NOT NULL REFERENCES company(id) ON DELETE CASCADE,
    reporting_year INTEGER NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    
    -- Placeholder - to be expanded based on B7.txt
    total_waste_generated_tonnes DECIMAL(15,2),
    waste_diverted_from_disposal_tonnes DECIMAL(15,2),
    waste_recycled_tonnes DECIMAL(15,2),
    
    UNIQUE(company_id, reporting_year)
);

-- ----------------------------------------------------------------------------
-- B8: WORKFORCE - GENERAL CHARACTERISTICS
-- ----------------------------------------------------------------------------
-- Employee demographics, contracts, turnover (paragraphs 175-183)
-- ----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS vsme_b8_workforce (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    company_id UUID NOT NULL REFERENCES company(id) ON DELETE CASCADE,
    reporting_year INTEGER NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    
    -- Total workforce
    total_employees_fte DECIMAL(10,2),
    total_employees_headcount INTEGER,
    
    -- By contract type
    permanent_contract_count INTEGER,
    temporary_contract_count INTEGER,
    
    -- By gender
    male_count INTEGER,
    female_count INTEGER,
    other_gender_count INTEGER,
    not_reported_gender_count INTEGER,
    
    -- By country (stored as JSONB for flexibility)
    employees_by_country JSONB, -- [{country: "SK", count: 25}, ...]
    
    -- Turnover (paragraph 182-183)
    employees_left_during_year INTEGER,
    average_employees_during_year DECIMAL(10,2),
    turnover_rate_pct DECIMAL(5,2) GENERATED ALWAYS AS (
        CASE 
            WHEN average_employees_during_year > 0 
            THEN (employees_left_during_year::DECIMAL / average_employees_during_year) * 100
            ELSE 0
        END
    ) STORED,
    
    UNIQUE(company_id, reporting_year)
);

-- ----------------------------------------------------------------------------
-- B9: WORKFORCE - HEALTH AND SAFETY (placeholder - spec TBD)
-- ----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS vsme_b9_health_safety (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    company_id UUID NOT NULL REFERENCES company(id) ON DELETE CASCADE,
    reporting_year INTEGER NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    
    -- Placeholder - to be expanded based on B9.txt
    work_related_injuries INTEGER,
    fatalities INTEGER,
    
    UNIQUE(company_id, reporting_year)
);

-- ----------------------------------------------------------------------------
-- B10: WORKFORCE - REMUNERATION, COLLECTIVE BARGAINING, TRAINING
-- ----------------------------------------------------------------------------
-- Gender pay gap, minimum wage, collective bargaining coverage
-- ----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS vsme_b10_remuneration (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    company_id UUID NOT NULL REFERENCES company(id) ON DELETE CASCADE,
    reporting_year INTEGER NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    
    -- Minimum wage comparison (paragraph 192-193)
    applicable_minimum_wage_eur DECIMAL(10,2),
    entry_level_wage_eur DECIMAL(10,2),
    
    -- Gender pay gap (paragraph 194-201)
    avg_gross_hourly_pay_male_eur DECIMAL(10,2),
    avg_gross_hourly_pay_female_eur DECIMAL(10,2),
    gender_pay_gap_pct DECIMAL(5,2) GENERATED ALWAYS AS (
        CASE 
            WHEN avg_gross_hourly_pay_male_eur > 0
            THEN ((avg_gross_hourly_pay_male_eur - avg_gross_hourly_pay_female_eur) / avg_gross_hourly_pay_male_eur) * 100
            ELSE 0
        END
    ) STORED,
    
    -- Collective bargaining (paragraph 202-205)
    employees_covered_by_cb INTEGER,
    total_employees INTEGER,
    collective_bargaining_coverage_pct DECIMAL(5,2) GENERATED ALWAYS AS (
        CASE 
            WHEN total_employees > 0
            THEN (employees_covered_by_cb::DECIMAL / total_employees) * 100
            ELSE 0
        END
    ) STORED,
    
    -- Training metrics (placeholder)
    avg_training_hours_per_employee DECIMAL(8,2),
    
    UNIQUE(company_id, reporting_year)
);

-- ----------------------------------------------------------------------------
-- B11: CONVICTIONS AND FINES FOR CORRUPTION AND BRIBERY
-- ----------------------------------------------------------------------------
-- Business conduct metrics (paragraph 206-209)
-- ----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS vsme_b11_corruption (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    company_id UUID NOT NULL REFERENCES company(id) ON DELETE CASCADE,
    reporting_year INTEGER NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    
    -- Convictions (paragraph 208)
    total_convictions INTEGER DEFAULT 0,
    conviction_details JSONB, -- [{date, court, offense, outcome}]
    
    -- Fines (paragraph 209)
    total_fines_eur DECIMAL(15,2) DEFAULT 0,
    fine_details JSONB, -- [{date, authority, amount, reason}]
    
    UNIQUE(company_id, reporting_year)
);

-- ============================================================================
-- COMPREHENSIVE MODULE TABLES (C1-C9)
-- ============================================================================

-- ----------------------------------------------------------------------------
-- C1: STRATEGY - BUSINESS MODEL AND SUSTAINABILITY
-- ----------------------------------------------------------------------------
-- Suppliers, customers, value chain (paragraph 212)
-- ----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS vsme_c1_strategy (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    company_id UUID NOT NULL REFERENCES company(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    
    -- Business model description
    business_model_description TEXT,
    
    -- Supplier relationships (paragraph 212)
    estimated_supplier_count INTEGER,
    suppliers_by_sector JSONB, -- [{sector: "Manufacturing", count: 15}, ...]
    suppliers_by_geography JSONB, -- [{country: "DE", count: 8}, ...]
    
    -- Customer information
    main_customer_types TEXT, -- e.g. "B2B, Public sector"
    customer_geographies TEXT[], -- array of countries
    
    UNIQUE(company_id)
);

-- ----------------------------------------------------------------------------
-- C3: GHG REDUCTION TARGETS AND CLIMATE TRANSITION PLAN
-- ----------------------------------------------------------------------------
-- Links to B3 emissions data
-- ----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS vsme_c3_ghg_targets (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    company_id UUID NOT NULL REFERENCES company(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    
    -- Scope 1 target
    scope_1_target_absolute DECIMAL(15,2),
    scope_1_target_year INTEGER,
    scope_1_base_year INTEGER,
    scope_1_base_year_value DECIMAL(15,2),
    scope_1_unit TEXT DEFAULT 'tCO2e',
    scope_1_coverage_pct DECIMAL(5,2),
    
    -- Scope 2 target
    scope_2_target_absolute DECIMAL(15,2),
    scope_2_target_year INTEGER,
    scope_2_base_year INTEGER,
    scope_2_base_year_value DECIMAL(15,2),
    scope_2_unit TEXT DEFAULT 'tCO2e',
    scope_2_coverage_pct DECIMAL(5,2),
    
    -- Scope 3 target (optional)
    scope_3_target_absolute DECIMAL(15,2),
    scope_3_target_year INTEGER,
    scope_3_base_year INTEGER,
    scope_3_base_year_value DECIMAL(15,2),
    scope_3_unit TEXT DEFAULT 'tCO2e',
    scope_3_coverage_pct DECIMAL(5,2),
    
    -- Actions to achieve targets
    main_actions TEXT[], -- array of planned actions
    
    -- Transition plan (for high-climate impact sectors)
    operates_in_high_impact_sector BOOLEAN DEFAULT FALSE,
    has_transition_plan BOOLEAN DEFAULT FALSE,
    transition_plan_description TEXT,
    transition_plan_adoption_date DATE,
    
    UNIQUE(company_id)
);

-- ----------------------------------------------------------------------------
-- C4: CLIMATE RISKS
-- ----------------------------------------------------------------------------
-- Physical hazards and transition events
-- ----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS vsme_c4_climate_risks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    company_id UUID NOT NULL REFERENCES company(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    
    has_identified_climate_hazards BOOLEAN DEFAULT FALSE,
    
    -- Climate hazards (paragraph C4)
    hazards_description TEXT,
    exposure_assessment_method TEXT,
    
    -- Time horizons
    hazards_short_term TEXT[], -- array of identified hazards
    hazards_medium_term TEXT[],
    hazards_long_term TEXT[],
    
    -- Adaptation actions
    has_adaptation_actions BOOLEAN DEFAULT FALSE,
    adaptation_actions_description TEXT,
    
    -- Risk assessment
    potential_financial_impact TEXT CHECK (potential_financial_impact IN ('high', 'medium', 'low')),
    
    UNIQUE(company_id)
);

-- ----------------------------------------------------------------------------
-- C6: HUMAN RIGHTS POLICIES AND PROCESSES
-- ----------------------------------------------------------------------------
-- Code of conduct covering workforce rights
-- ----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS vsme_c6_human_rights (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    company_id UUID NOT NULL REFERENCES company(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    
    has_code_of_conduct BOOLEAN DEFAULT FALSE,
    has_human_rights_policy BOOLEAN DEFAULT FALSE,
    
    -- Coverage areas (YES/NO per area)
    covers_child_labour BOOLEAN DEFAULT FALSE,
    covers_forced_labour BOOLEAN DEFAULT FALSE,
    covers_human_trafficking BOOLEAN DEFAULT FALSE,
    covers_discrimination BOOLEAN DEFAULT FALSE,
    
    policy_document_url TEXT,
    policy_last_updated DATE,
    
    UNIQUE(company_id)
);

-- ----------------------------------------------------------------------------
-- C9: GENDER DIVERSITY RATIO IN GOVERNANCE BODY
-- ----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS vsme_c9_gender_diversity (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    company_id UUID NOT NULL REFERENCES company(id) ON DELETE CASCADE,
    reporting_year INTEGER NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    
    -- Board/governance body composition
    governance_body_total INTEGER,
    governance_body_male INTEGER,
    governance_body_female INTEGER,
    governance_body_other INTEGER,
    
    female_ratio_pct DECIMAL(5,2) GENERATED ALWAYS AS (
        CASE 
            WHEN governance_body_total > 0
            THEN (governance_body_female::DECIMAL / governance_body_total) * 100
            ELSE 0
        END
    ) STORED,
    
    UNIQUE(company_id, reporting_year)
);

-- ============================================================================
-- INDEXES AND TRIGGERS
-- ============================================================================

-- Update timestamp triggers
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_vsme_b1_updated_at BEFORE UPDATE ON vsme_b1_basis_preparation
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_vsme_b2_updated_at BEFORE UPDATE ON vsme_b2_practices
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_vsme_b3_updated_at BEFORE UPDATE ON vsme_b3_ghg_emissions
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_vsme_b5_land_updated_at BEFORE UPDATE ON vsme_b5_land_use
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_vsme_b6_updated_at BEFORE UPDATE ON vsme_b6_water
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_vsme_b7_updated_at BEFORE UPDATE ON vsme_b7_circular_economy
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_vsme_b8_updated_at BEFORE UPDATE ON vsme_b8_workforce
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_vsme_b9_updated_at BEFORE UPDATE ON vsme_b9_health_safety
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_vsme_b10_updated_at BEFORE UPDATE ON vsme_b10_remuneration
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_vsme_b11_updated_at BEFORE UPDATE ON vsme_b11_corruption
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_vsme_c1_updated_at BEFORE UPDATE ON vsme_c1_strategy
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_vsme_c3_updated_at BEFORE UPDATE ON vsme_c3_ghg_targets
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_vsme_c4_updated_at BEFORE UPDATE ON vsme_c4_climate_risks
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_vsme_c6_updated_at BEFORE UPDATE ON vsme_c6_human_rights
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_vsme_c9_updated_at BEFORE UPDATE ON vsme_c9_gender_diversity
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ============================================================================
-- COMMENTS
-- ============================================================================

COMMENT ON TABLE vsme_b1_basis_preparation IS 'B1: Basic company information, legal form, NACE codes, certifications';
COMMENT ON TABLE vsme_b1_sites IS 'B1: Company sites/locations with geolocation (paragraph 73-77)';
COMMENT ON TABLE vsme_b2_practices IS 'B2: Sustainability practices and policies across all ESRS topics';
COMMENT ON TABLE vsme_b3_ghg_emissions IS 'B3: Scope 1, 2, 3 GHG emissions and energy consumption';
COMMENT ON TABLE vsme_b5_biodiversity_sites IS 'B5: Sites in/near biodiversity-sensitive areas';
COMMENT ON TABLE vsme_b5_land_use IS 'B5: Land use metrics (sealed, nature-oriented areas)';
COMMENT ON TABLE vsme_b6_water IS 'B6: Water consumption and discharge metrics';
COMMENT ON TABLE vsme_b7_circular_economy IS 'B7: Waste and circular economy metrics';
COMMENT ON TABLE vsme_b8_workforce IS 'B8: Employee demographics, contracts, turnover';
COMMENT ON TABLE vsme_b9_health_safety IS 'B9: Workplace health and safety incidents';
COMMENT ON TABLE vsme_b10_remuneration IS 'B10: Gender pay gap, minimum wage, collective bargaining';
COMMENT ON TABLE vsme_b11_corruption IS 'B11: Corruption/bribery convictions and fines';
COMMENT ON TABLE vsme_c1_strategy IS 'C1: Business model, supplier and customer relationships';
COMMENT ON TABLE vsme_c3_ghg_targets IS 'C3: GHG reduction targets and transition plans';
COMMENT ON TABLE vsme_c4_climate_risks IS 'C4: Climate-related physical and transition risks';
COMMENT ON TABLE vsme_c6_human_rights IS 'C6: Human rights policies (child labour, forced labour, etc.)';
COMMENT ON TABLE vsme_c9_gender_diversity IS 'C9: Gender diversity in governance body';
