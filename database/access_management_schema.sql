-- =====================================================
-- ACCESS MANAGEMENT SCHEMA
-- =====================================================

-- 1. Company members with roles
CREATE TABLE company_member (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  company_id UUID NOT NULL REFERENCES company(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  role TEXT NOT NULL CHECK (role IN ('owner', 'admin', 'editor', 'viewer')),
  access_type TEXT NOT NULL DEFAULT 'all' CHECK (access_type IN ('all', 'selected')),
  invited_by UUID REFERENCES auth.users(id),
  invited_at TIMESTAMP DEFAULT NOW(),
  created_at TIMESTAMP DEFAULT NOW(),
  UNIQUE(company_id, user_id)
);

-- 2. Topic-level access for editors and viewers (when access_type = 'selected')
CREATE TABLE company_member_topic_access (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  company_member_id UUID NOT NULL REFERENCES company_member(id) ON DELETE CASCADE,
  topic_id UUID NOT NULL REFERENCES topic(id) ON DELETE CASCADE,
  can_view BOOLEAN DEFAULT TRUE,
  can_edit BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT NOW(),
  UNIQUE(company_member_id, topic_id)
);

-- 3. Indexes for performance
CREATE INDEX idx_company_member_company ON company_member(company_id);
CREATE INDEX idx_company_member_user ON company_member(user_id);
CREATE INDEX idx_company_member_role ON company_member(role);
CREATE INDEX idx_topic_access_member ON company_member_topic_access(company_member_id);
CREATE INDEX idx_topic_access_topic ON company_member_topic_access(topic_id);

-- =====================================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- =====================================================

-- Enable RLS on company_member table
ALTER TABLE company_member ENABLE ROW LEVEL SECURITY;

-- Policy: Users can view company members if they are a member themselves
CREATE POLICY "Users can view company members"
  ON company_member FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM company_member cm
      WHERE cm.company_id = company_member.company_id
      AND cm.user_id = auth.uid()
    )
  );

-- Policy: Only owners and admins can insert new members
CREATE POLICY "Owners and admins can add members"
  ON company_member FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM company_member cm
      WHERE cm.company_id = company_id
      AND cm.user_id = auth.uid()
      AND cm.role IN ('owner', 'admin')
    )
  );

-- Policy: Only owners and admins can update members (except owners can't be demoted)
CREATE POLICY "Owners and admins can update members"
  ON company_member FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM company_member cm
      WHERE cm.company_id = company_member.company_id
      AND cm.user_id = auth.uid()
      AND cm.role IN ('owner', 'admin')
    )
    AND company_member.role != 'owner' -- Can't modify owner role
  );

-- Policy: Only owners and admins can delete members (except owners)
CREATE POLICY "Owners and admins can remove members"
  ON company_member FOR DELETE
  USING (
    EXISTS (
      SELECT 1 FROM company_member cm
      WHERE cm.company_id = company_member.company_id
      AND cm.user_id = auth.uid()
      AND cm.role IN ('owner', 'admin')
    )
    AND company_member.role != 'owner' -- Can't delete owner
  );

-- Enable RLS on company_member_topic_access
ALTER TABLE company_member_topic_access ENABLE ROW LEVEL SECURITY;

-- Policy: Users can view topic access for their company
CREATE POLICY "Users can view topic access"
  ON company_member_topic_access FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM company_member cm
      WHERE cm.id = company_member_topic_access.company_member_id
      AND EXISTS (
        SELECT 1 FROM company_member cm2
        WHERE cm2.company_id = cm.company_id
        AND cm2.user_id = auth.uid()
      )
    )
  );

-- Policy: Only owners and admins can manage topic access
CREATE POLICY "Owners and admins can manage topic access"
  ON company_member_topic_access FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM company_member cm
      JOIN company_member cm_user ON cm_user.company_id = cm.company_id
      WHERE cm.id = company_member_topic_access.company_member_id
      AND cm_user.user_id = auth.uid()
      AND cm_user.role IN ('owner', 'admin')
    )
  );

-- =====================================================
-- UPDATE EXISTING COMPANY TABLE
-- =====================================================

-- Add created_by field to company table if not exists
ALTER TABLE company ADD COLUMN IF NOT EXISTS created_by UUID REFERENCES auth.users(id);

-- =====================================================
-- MIGRATION: Create owner entries for existing companies
-- =====================================================

-- For each existing company, create an owner entry for the user_id
INSERT INTO company_member (company_id, user_id, role, access_type)
SELECT id, user_id, 'owner', 'all'
FROM company
WHERE NOT EXISTS (
  SELECT 1 FROM company_member cm
  WHERE cm.company_id = company.id
  AND cm.user_id = company.user_id
)
ON CONFLICT (company_id, user_id) DO NOTHING;

-- =====================================================
-- HELPER FUNCTIONS
-- =====================================================

-- Function to check if user has access to a company
CREATE OR REPLACE FUNCTION user_has_company_access(
  p_user_id UUID,
  p_company_id UUID
)
RETURNS BOOLEAN AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM company_member
    WHERE company_id = p_company_id
    AND user_id = p_user_id
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to check if user can edit a topic
CREATE OR REPLACE FUNCTION user_can_edit_topic(
  p_user_id UUID,
  p_company_id UUID,
  p_topic_id UUID
)
RETURNS BOOLEAN AS $$
DECLARE
  v_role TEXT;
  v_access_type TEXT;
  v_member_id UUID;
BEGIN
  -- Get user's role and access type
  SELECT cm.role, cm.access_type, cm.id
  INTO v_role, v_access_type, v_member_id
  FROM company_member cm
  WHERE cm.company_id = p_company_id
  AND cm.user_id = p_user_id;

  -- If not a member, no access
  IF v_role IS NULL THEN
    RETURN FALSE;
  END IF;

  -- Owners and Admins have full access
  IF v_role IN ('owner', 'admin') THEN
    RETURN TRUE;
  END IF;

  -- Viewers can't edit
  IF v_role = 'viewer' THEN
    RETURN FALSE;
  END IF;

  -- Editors with 'all' access can edit
  IF v_role = 'editor' AND v_access_type = 'all' THEN
    RETURN TRUE;
  END IF;

  -- Editors with 'selected' access - check specific topic permission
  IF v_role = 'editor' AND v_access_type = 'selected' THEN
    RETURN EXISTS (
      SELECT 1 FROM company_member_topic_access
      WHERE company_member_id = v_member_id
      AND topic_id = p_topic_id
      AND can_edit = TRUE
    );
  END IF;

  RETURN FALSE;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to check if user can view a topic
CREATE OR REPLACE FUNCTION user_can_view_topic(
  p_user_id UUID,
  p_company_id UUID,
  p_topic_id UUID
)
RETURNS BOOLEAN AS $$
DECLARE
  v_role TEXT;
  v_access_type TEXT;
  v_member_id UUID;
BEGIN
  -- Get user's role and access type
  SELECT cm.role, cm.access_type, cm.id
  INTO v_role, v_access_type, v_member_id
  FROM company_member cm
  WHERE cm.company_id = p_company_id
  AND cm.user_id = p_user_id;

  -- If not a member, no access
  IF v_role IS NULL THEN
    RETURN FALSE;
  END IF;

  -- All roles with 'all' access can view
  IF v_access_type = 'all' THEN
    RETURN TRUE;
  END IF;

  -- Users with 'selected' access - check specific topic permission
  IF v_access_type = 'selected' THEN
    RETURN EXISTS (
      SELECT 1 FROM company_member_topic_access
      WHERE company_member_id = v_member_id
      AND topic_id = p_topic_id
      AND can_view = TRUE
    );
  END IF;

  RETURN FALSE;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- =====================================================
-- COMMENTS
-- =====================================================

COMMENT ON TABLE company_member IS 'Company members with their roles';
COMMENT ON TABLE company_member_topic_access IS 'Granular topic-level access for editors and viewers';
COMMENT ON COLUMN company_member.access_type IS 'all = access to all topics, selected = access to specific topics only';
COMMENT ON COLUMN company_member_topic_access.can_view IS 'Can view topic and its reports';
COMMENT ON COLUMN company_member_topic_access.can_edit IS 'Can edit topic reports and answers';
