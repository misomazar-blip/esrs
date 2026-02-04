-- =====================================================
-- FIX: Update RLS Policy to avoid circular dependency
-- =====================================================

-- Drop the old problematic policy
DROP POLICY IF EXISTS "Users can view company members" ON company_member;

-- Create a new, simpler policy that allows users to see:
-- 1. Their own membership records
-- 2. Other members of companies they belong to
CREATE POLICY "Users can view company members v2"
  ON company_member FOR SELECT
  USING (
    -- Can see own records
    user_id = auth.uid()
    OR
    -- Can see other members of companies where user is a member
    company_id IN (
      SELECT company_id 
      FROM company_member 
      WHERE user_id = auth.uid()
    )
  );

-- Verify the policy was created
SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual
FROM pg_policies
WHERE tablename = 'company_member';
