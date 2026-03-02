-- ============================================================================
-- VSME Questions RPC Function
-- ============================================================================
-- Returns all questions applicable to a VSME report with existing answers
-- ============================================================================

CREATE OR REPLACE FUNCTION public.get_vsme_questions_for_report(
  p_report_id UUID
)
RETURNS TABLE (
  question_id UUID,
  code TEXT,
  question_text TEXT,
  guidance_text TEXT,
  example_answer TEXT,
  answer_type TEXT,
  order_index INTEGER,
  section_code TEXT,
  vsme_level TEXT,
  vsme_datapoint_id TEXT,
  config_jsonb JSONB,
  value_text TEXT,
  value_numeric NUMERIC,
  value_date DATE,
  value_jsonb JSONB,
  updated_at TIMESTAMPTZ
) 
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY
  SELECT 
    q.id AS question_id,
    q.code,
    q.question_text,
    q.guidance_text,
    q.example_answer,
    q.data_type AS answer_type,
    q.order_index,
    q.section_code,
    q.vsme_level,
    q.vsme_datapoint_id,
    q.config_jsonb,
    a.value_text,
    a.value_numeric,
    a.value_date,
    a.value_jsonb,
    a.updated_at
  FROM disclosure_question q
  LEFT JOIN disclosure_answer a 
    ON a.question_id = q.id 
    AND a.report_id = p_report_id
  WHERE q.framework = 'VSME'
    OR q.applies_to_vsme_year IS NOT NULL
  ORDER BY q.order_index;
END;
$$;

COMMENT ON FUNCTION public.get_vsme_questions_for_report(UUID) IS 
  'Returns all VSME-applicable questions for a report with existing answers joined';
