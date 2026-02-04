-- =====================================================
-- Helper function to get user emails for company members
-- =====================================================

-- Drop existing function first
DROP FUNCTION IF EXISTS get_company_members_with_emails(UUID);

CREATE FUNCTION get_company_members_with_emails(p_company_id UUID)
RETURNS JSONB AS $$
DECLARE
  result JSONB;
BEGIN
  SELECT jsonb_agg(row_to_json(t))
  INTO result
  FROM (
    SELECT 
      cm.id,
      cm.company_id,
      cm.user_id,
      cm.role,
      cm.access_type,
      cm.invited_by,
      cm.invited_at,
      cm.created_at,
      au.email as user_email
    FROM company_member cm
    LEFT JOIN auth.users au ON au.id = cm.user_id
    WHERE cm.company_id = p_company_id
    ORDER BY cm.created_at
  ) t;
  
  RETURN COALESCE(result, '[]'::JSONB);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
