-- ============================================================================
-- VSME CTAs RPC Function
-- ============================================================================
-- Returns call-to-action recommendations for VSME report navigation
-- ============================================================================

CREATE OR REPLACE FUNCTION public.get_vsme_ctas_for_report(
  p_report_id UUID
)
RETURNS JSONB
LANGUAGE plpgsql
AS $$
DECLARE
  v_sections JSONB;
  v_continue_section TEXT;
  v_suggested_section TEXT;
  v_result JSONB;
BEGIN
  -- Get all sections with their progress
  SELECT jsonb_agg(
    jsonb_build_object(
      'section_code', section_code,
      'answered', answered,
      'total', total,
      'progress_ratio', CASE WHEN total > 0 THEN answered::NUMERIC / total::NUMERIC ELSE 0 END,
      'last_updated_at', last_updated_at
    ) ORDER BY 
      CASE section_code
        WHEN 'B1' THEN 1
        WHEN 'B2' THEN 2
        WHEN 'B8' THEN 3
        WHEN 'B3' THEN 4
        WHEN 'B4' THEN 5
        WHEN 'B5' THEN 6
        WHEN 'B6' THEN 7
        WHEN 'B7' THEN 8
        ELSE 99
      END
  ) INTO v_sections
  FROM (
    SELECT 
      q.section_code,
      COUNT(*) AS total,
      COUNT(a.value_text) + COUNT(a.value_numeric) + COUNT(a.value_date) AS answered,
      MAX(a.updated_at) AS last_updated_at
    FROM disclosure_question q
    LEFT JOIN disclosure_answer a 
      ON a.question_id = q.id 
      AND a.report_id = p_report_id
    WHERE q.framework = 'VSME'
      OR q.applies_to_vsme_year IS NOT NULL
    GROUP BY q.section_code
  ) sub;
  
  -- Find continue section (last section with activity, incomplete)
  SELECT section_code INTO v_continue_section
  FROM (
    SELECT 
      q.section_code,
      COUNT(*) AS total,
      COUNT(a.value_text) + COUNT(a.value_numeric) + COUNT(a.value_date) AS answered,
      MAX(a.updated_at) AS last_updated
    FROM disclosure_question q
    LEFT JOIN disclosure_answer a 
      ON a.question_id = q.id 
      AND a.report_id = p_report_id
    WHERE q.framework = 'VSME'
      OR q.applies_to_vsme_year IS NOT NULL
    GROUP BY q.section_code
    HAVING COUNT(a.value_text) + COUNT(a.value_numeric) + COUNT(a.value_date) < COUNT(*)
  ) sub
  WHERE last_updated IS NOT NULL
  ORDER BY last_updated DESC NULLS LAST
  LIMIT 1;
  
  -- Find suggested section (first incomplete in priority order)
  SELECT section_code INTO v_suggested_section
  FROM (
    SELECT 
      q.section_code,
      COUNT(*) AS total,
      COUNT(a.value_text) + COUNT(a.value_numeric) + COUNT(a.value_date) AS answered,
      CASE q.section_code
        WHEN 'B1' THEN 1
        WHEN 'B2' THEN 2
        WHEN 'B8' THEN 3
        WHEN 'B3' THEN 4
        WHEN 'B4' THEN 5
        WHEN 'B5' THEN 6
        WHEN 'B6' THEN 7
        WHEN 'B7' THEN 8
        ELSE 99
      END AS priority
    FROM disclosure_question q
    LEFT JOIN disclosure_answer a 
      ON a.question_id = q.id 
      AND a.report_id = p_report_id
    WHERE q.framework = 'VSME'
      OR q.applies_to_vsme_year IS NOT NULL
    GROUP BY q.section_code
    HAVING COUNT(a.value_text) + COUNT(a.value_numeric) + COUNT(a.value_date) < COUNT(*)
  ) sub
  ORDER BY priority
  LIMIT 1;
  
  -- Build result
  v_result := jsonb_build_object(
    'continue_section_code', COALESCE(v_continue_section, 'B1'),
    'suggested_section_code', COALESCE(v_suggested_section, 'B1'),
    'sections', COALESCE(v_sections, '[]'::JSONB)
  );
  
  RETURN v_result;
END;
$$;

COMMENT ON FUNCTION public.get_vsme_ctas_for_report(UUID) IS 
  'Returns call-to-action recommendations with section progress for VSME report navigation';
