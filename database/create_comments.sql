-- Comments table for questions
CREATE TABLE IF NOT EXISTS question_comment (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  question_id UUID NOT NULL REFERENCES disclosure_question(id) ON DELETE CASCADE,
  report_id UUID NOT NULL REFERENCES report(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  parent_comment_id UUID REFERENCES question_comment(id) ON DELETE CASCADE,
  comment_text TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  is_edited BOOLEAN DEFAULT FALSE
);

-- Indexes for performance
CREATE INDEX idx_question_comment_question_id ON question_comment(question_id);
CREATE INDEX idx_question_comment_report_id ON question_comment(report_id);
CREATE INDEX idx_question_comment_parent_id ON question_comment(parent_comment_id);
CREATE INDEX idx_question_comment_created_at ON question_comment(created_at DESC);

-- RLS Policies
ALTER TABLE question_comment ENABLE ROW LEVEL SECURITY;

-- Users can view comments if they have access to the report
CREATE POLICY "Users can view comments for their company reports"
ON question_comment FOR SELECT
USING (
  EXISTS (
    SELECT 1 FROM report r
    INNER JOIN company c ON r.company_id = c.id
    WHERE r.id = question_comment.report_id
    AND c.user_id = auth.uid()
  )
);

-- Users can insert comments if they have access to the report
CREATE POLICY "Users can insert comments for their company reports"
ON question_comment FOR INSERT
WITH CHECK (
  user_id = auth.uid()
  AND EXISTS (
    SELECT 1 FROM report r
    INNER JOIN company c ON r.company_id = c.id
    WHERE r.id = question_comment.report_id
    AND c.user_id = auth.uid()
  )
);

-- Users can update their own comments
CREATE POLICY "Users can update their own comments"
ON question_comment FOR UPDATE
USING (user_id = auth.uid())
WITH CHECK (user_id = auth.uid());

-- Users can delete their own comments
CREATE POLICY "Users can delete their own comments"
ON question_comment FOR DELETE
USING (user_id = auth.uid());

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_question_comment_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  NEW.is_edited = TRUE;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to update updated_at
CREATE TRIGGER trigger_update_question_comment_updated_at
  BEFORE UPDATE ON question_comment
  FOR EACH ROW
  EXECUTE FUNCTION update_question_comment_updated_at();

-- View for comments with user info
CREATE OR REPLACE VIEW question_comment_with_user AS
SELECT 
  qc.*,
  u.email as user_email
FROM question_comment qc
LEFT JOIN auth.users u ON qc.user_id = u.id;
