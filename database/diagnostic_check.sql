-- =====================================================
-- DIAGNOSTIC: Check what's wrong
-- =====================================================

-- 1. Check if you can see your own company_member records
SELECT 
  'Test 1: Your company_member records' as test,
  cm.id,
  cm.company_id,
  cm.role,
  cm.access_type
FROM company_member cm
WHERE cm.user_id = auth.uid();

-- 2. Check RLS policies on company_member
SELECT 
  'Test 2: RLS Policies' as test,
  policyname,
  permissive,
  cmd,
  qual
FROM pg_policies
WHERE tablename = 'company_member';

-- 3. Test without RLS (as admin)
-- This will show all records regardless of RLS
SELECT 
  'Test 3: All company_member records (bypassing RLS)' as test,
  cm.id,
  cm.company_id,
  c.name as company_name,
  cm.user_id,
  cm.role
FROM company_member cm
JOIN company c ON c.id = cm.company_id
LIMIT 5;
