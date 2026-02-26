-- ============================================================================
-- TEST VSME CATEGORIZATION
-- ============================================================================

-- Test 1: Micro company (5 employees, €300k balance, €500k turnover)
-- Should return: Micro, eligible
SELECT 
  'Test 1: Micro' as test_case,
  * 
FROM fn_check_vsme_eligibility(300, 500, 5);

-- Test 2: Small company (40 employees, €4M balance, €8M turnover)  
-- Should return: Small, eligible
SELECT 
  'Test 2: Small' as test_case,
  * 
FROM fn_check_vsme_eligibility(4000, 8000, 40);

-- Test 3: Medium company (200 employees, €20M balance, €40M turnover)
-- Should return: Medium, eligible
SELECT 
  'Test 3: Medium' as test_case,
  * 
FROM fn_check_vsme_eligibility(20000, 40000, 200);

-- Test 4: Large company (300 employees, €30M balance, €60M turnover)
-- Should return: Large, NOT eligible (exceeds 3 thresholds)
SELECT 
  'Test 4: Large' as test_case,
  * 
FROM fn_check_vsme_eligibility(30000, 60000, 300);

-- Test 5: Edge case - exactly 2 Medium thresholds exceeded (260 employees, €26M balance, €40M turnover)
-- Should return: Large, NOT eligible
SELECT 
  'Test 5: Edge - 2 Medium exceeded' as test_case,
  * 
FROM fn_check_vsme_eligibility(26000, 40000, 260);

-- Test 6: Edge case - only 1 Medium threshold exceeded (260 employees, €20M balance, €40M turnover)
-- Should return: Medium, eligible
SELECT 
  'Test 6: Edge - 1 Medium exceeded' as test_case,
  * 
FROM fn_check_vsme_eligibility(20000, 40000, 260);

-- Test 7: Missing data (only employee count provided)
-- Should categorize based on available data
SELECT 
  'Test 7: Partial data' as test_case,
  * 
FROM fn_check_vsme_eligibility(NULL, NULL, 200);
