-- ============================================================================
-- VSME Financial Criteria - Add Total Assets & Net Turnover
-- ============================================================================
-- VSME eligibility requires ALL 3 criteria to be met:
-- 1. Employees ≤ 750
-- 2. Total Assets ≤ €50 million
-- 3. Net Turnover ≤ €100 million
--
-- Reference: EFRAG VSME Standard
-- https://www.efrag.org/sites/default/files/sites/webpublishing/SiteAssets/VSME%20Standard.pdf
-- ============================================================================

-- Add financial criteria columns to company table
ALTER TABLE company
ADD COLUMN IF NOT EXISTS total_assets_millions DECIMAL(10, 2),
ADD COLUMN IF NOT EXISTS net_turnover_millions DECIMAL(10, 2);

COMMENT ON COLUMN company.total_assets_millions IS 'Total assets in € millions (VSME limit: ≤50M)';
COMMENT ON COLUMN company.net_turnover_millions IS 'Net turnover/revenue in € millions (VSME limit: ≤100M)';

-- Update is_vsme generated column to check ALL 3 criteria
-- Drop existing generated column
ALTER TABLE company DROP COLUMN IF EXISTS is_vsme;

-- Recreate with comprehensive VSME check
ALTER TABLE company
ADD COLUMN is_vsme BOOLEAN GENERATED ALWAYS AS (
  CASE
    WHEN employee_count IS NULL 
      AND total_assets_millions IS NULL 
      AND net_turnover_millions IS NULL 
    THEN NULL  -- Unknown eligibility
    ELSE (
      COALESCE(employee_count, 0) <= 750 
      AND COALESCE(total_assets_millions, 0) <= 50 
      AND COALESCE(net_turnover_millions, 0) <= 100
    )
  END
) STORED;

COMMENT ON COLUMN company.is_vsme IS 'Auto-calculated: true if ALL 3 VSME criteria are met (≤750 employees, ≤€50M assets, ≤€100M turnover)';

-- Update employee_size_category to reflect financial criteria too
ALTER TABLE company DROP COLUMN IF EXISTS employee_size_category;

ALTER TABLE company
ADD COLUMN employee_size_category TEXT GENERATED ALWAYS AS (
  CASE
    WHEN is_vsme = true THEN 'VSME'
    WHEN employee_count IS NOT NULL OR total_assets_millions IS NOT NULL OR net_turnover_millions IS NOT NULL THEN 'Large (Full ESRS)'
    ELSE 'Unknown'
  END
) STORED;

COMMENT ON COLUMN company.employee_size_category IS 'Auto-categorization: VSME (eligible) or Large (requires Full ESRS)';

-- ============================================================================
-- VALIDATION FUNCTION
-- ============================================================================

CREATE OR REPLACE FUNCTION fn_check_vsme_eligibility(
  p_employee_count INTEGER,
  p_total_assets_millions DECIMAL,
  p_net_turnover_millions DECIMAL
) RETURNS TABLE(
  is_eligible BOOLEAN,
  exceeded_limits TEXT[]
) AS $$
DECLARE
  v_exceeded TEXT[];
BEGIN
  v_exceeded := ARRAY[]::TEXT[];
  
  -- Check each criterion
  IF p_employee_count IS NOT NULL AND p_employee_count > 750 THEN
    v_exceeded := array_append(v_exceeded, format('Employees: %s (max 750)', p_employee_count));
  END IF;
  
  IF p_total_assets_millions IS NOT NULL AND p_total_assets_millions > 50 THEN
    v_exceeded := array_append(v_exceeded, format('Total Assets: €%sM (max €50M)', p_total_assets_millions));
  END IF;
  
  IF p_net_turnover_millions IS NOT NULL AND p_net_turnover_millions > 100 THEN
    v_exceeded := array_append(v_exceeded, format('Net Turnover: €%sM (max €100M)', p_net_turnover_millions));
  END IF;
  
  RETURN QUERY SELECT 
    (array_length(v_exceeded, 1) IS NULL OR array_length(v_exceeded, 1) = 0),
    v_exceeded;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION fn_check_vsme_eligibility IS 'Validates if a company meets ALL 3 VSME criteria and returns exceeded limits';

-- ============================================================================
-- DOCUMENTATION
-- ============================================================================

-- Example usage:
-- SELECT * FROM fn_check_vsme_eligibility(800, 45.5, 90.2);
-- Returns: (false, {"Employees: 800 (max 750)"})

-- SELECT * FROM fn_check_vsme_eligibility(500, 40, 80);
-- Returns: (true, {})
