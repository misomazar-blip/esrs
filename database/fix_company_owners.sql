-- =====================================================
-- FIX: Create owner entries for existing companies
-- =====================================================

-- This will create an owner entry for each existing company
-- where the user_id from company table becomes the owner

INSERT INTO company_member (company_id, user_id, role, access_type)
SELECT 
  c.id as company_id, 
  c.user_id, 
  'owner' as role, 
  'all' as access_type
FROM company c
WHERE NOT EXISTS (
  SELECT 1 FROM company_member cm
  WHERE cm.company_id = c.id
  AND cm.user_id = c.user_id
)
ON CONFLICT (company_id, user_id) DO NOTHING;

-- Check the results
SELECT 
  c.name as company_name,
  cm.role,
  cm.access_type,
  cm.created_at
FROM company c
JOIN company_member cm ON cm.company_id = c.id
ORDER BY c.name, cm.created_at;
