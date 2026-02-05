-- Attachments table for questions
CREATE TABLE IF NOT EXISTS question_attachment (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  question_id UUID NOT NULL REFERENCES disclosure_question(id) ON DELETE CASCADE,
  report_id UUID NOT NULL REFERENCES report(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  file_name TEXT NOT NULL,
  file_size BIGINT NOT NULL, -- in bytes
  file_type TEXT NOT NULL, -- MIME type
  storage_path TEXT NOT NULL, -- path in Supabase Storage
  description TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indexes for performance
CREATE INDEX idx_question_attachment_question_id ON question_attachment(question_id);
CREATE INDEX idx_question_attachment_report_id ON question_attachment(report_id);
CREATE INDEX idx_question_attachment_user_id ON question_attachment(user_id);
CREATE INDEX idx_question_attachment_created_at ON question_attachment(created_at DESC);

-- RLS Policies
ALTER TABLE question_attachment ENABLE ROW LEVEL SECURITY;

-- Users can view attachments if they have access to the report
CREATE POLICY "Users can view attachments for their company reports"
ON question_attachment FOR SELECT
USING (
  EXISTS (
    SELECT 1 FROM report r
    INNER JOIN company c ON r.company_id = c.id
    WHERE r.id = question_attachment.report_id
    AND c.user_id = auth.uid()
  )
);

-- Users can insert attachments if they have access to the report
CREATE POLICY "Users can insert attachments for their company reports"
ON question_attachment FOR INSERT
WITH CHECK (
  user_id = auth.uid()
  AND EXISTS (
    SELECT 1 FROM report r
    INNER JOIN company c ON r.company_id = c.id
    WHERE r.id = question_attachment.report_id
    AND c.user_id = auth.uid()
  )
);

-- Users can update their own attachments
CREATE POLICY "Users can update their own attachments"
ON question_attachment FOR UPDATE
USING (user_id = auth.uid())
WITH CHECK (user_id = auth.uid());

-- Users can delete their own attachments
CREATE POLICY "Users can delete their own attachments"
ON question_attachment FOR DELETE
USING (user_id = auth.uid());

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_question_attachment_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to update updated_at
CREATE TRIGGER trigger_update_question_attachment_updated_at
  BEFORE UPDATE ON question_attachment
  FOR EACH ROW
  EXECUTE FUNCTION update_question_attachment_updated_at();

-- View for attachments with user info
CREATE OR REPLACE VIEW question_attachment_with_user AS
SELECT 
  qa.*,
  u.email as user_email
FROM question_attachment qa
LEFT JOIN auth.users u ON qa.user_id = u.id;

-- Storage bucket policy (run in Supabase Storage UI or via API)
-- Bucket name: question-attachments
-- Public: false
-- File size limit: 10MB
-- Allowed MIME types: image/*, application/pdf, application/vnd.*, text/*, .xlsx, .docx, .csv
