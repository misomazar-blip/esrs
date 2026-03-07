-- ============================================================================
-- Prefill RPC: company legal name -> VSME B1 legal-name question
-- ============================================================================

CREATE OR REPLACE FUNCTION public.prefill_vsme_b1_legal_name_for_company(
  p_company_id UUID
)
RETURNS INTEGER
LANGUAGE plpgsql
SECURITY INVOKER
SET search_path = public
AS $$
DECLARE
  v_company_name TEXT;
  v_prefilled_count INTEGER := 0;
BEGIN
  SELECT c.name
  INTO v_company_name
  FROM public.company c
  WHERE c.id = p_company_id;

  IF v_company_name IS NULL OR btrim(v_company_name) = '' THEN
    RETURN 0;
  END IF;

  WITH target_reports AS (
    SELECT r.id AS report_id
    FROM public.report r
    WHERE r.company_id = p_company_id
      AND r.framework = 'VSME'
      AND COALESCE(r.status, 'draft') <> 'submitted'
  ),
  upserted AS (
    INSERT INTO public.disclosure_answer (
      report_id,
      question_id,
      value_text,
      value_jsonb
    )
    SELECT
      tr.report_id,
      '84496cc7-9946-484b-951e-0f2464274b85'::UUID,
      v_company_name,
      jsonb_build_object('source', 'company_profile')
    FROM target_reports tr
    LEFT JOIN public.disclosure_answer da
      ON da.report_id = tr.report_id
     AND da.question_id = '84496cc7-9946-484b-951e-0f2464274b85'::UUID
    WHERE da.id IS NULL
       OR (
            (da.value_text IS NULL OR btrim(da.value_text) = '')
        AND da.value_numeric IS NULL
        AND da.value_date IS NULL
       )
    ON CONFLICT (report_id, question_id)
    DO UPDATE
      SET value_text = EXCLUDED.value_text,
          value_jsonb = COALESCE(public.disclosure_answer.value_jsonb, '{}'::jsonb) || jsonb_build_object('source', 'company_profile'),
          updated_at = NOW()
    WHERE
          (public.disclosure_answer.value_text IS NULL OR btrim(public.disclosure_answer.value_text) = '')
      AND public.disclosure_answer.value_numeric IS NULL
      AND public.disclosure_answer.value_date IS NULL
    RETURNING 1
  )
  SELECT COUNT(*)::INTEGER
  INTO v_prefilled_count
  FROM upserted;

  RETURN v_prefilled_count;
END;
$$;

COMMENT ON FUNCTION public.prefill_vsme_b1_legal_name_for_company(UUID)
IS 'Prefills company legal name into VSME B1 legal-name question for open/non-submitted reports when answer is missing.';

GRANT EXECUTE ON FUNCTION public.prefill_vsme_b1_legal_name_for_company(UUID) TO authenticated;

-- ============================================================================
-- Prefill RPC: company profile -> overlapping VSME B1 fields (open reports)
-- ============================================================================

CREATE OR REPLACE FUNCTION public.prefill_company_profile_into_open_reports(
  p_company_id UUID
)
RETURNS INTEGER
LANGUAGE plpgsql
SECURITY INVOKER
SET search_path = public
AS $$
DECLARE
  v_prefilled_count INTEGER := 0;
BEGIN
  WITH company_values AS (
    SELECT
      c.id AS company_id,
      NULLIF(btrim(c.name), '') AS legal_name,
      NULLIF(btrim(c.address), '') AS address,
      NULLIF(btrim(c.city), '') AS city,
      NULLIF(btrim(c.postal_code), '') AS postal_code,
      NULLIF(btrim(c.country_code), '') AS country_code,
      NULLIF(btrim(c.identification_number), '') AS identification_number,
      NULLIF(btrim(c.vat_number), '') AS vat_number
    FROM public.company c
    WHERE c.id = p_company_id
  ),
  target_reports AS (
    SELECT r.id AS report_id
    FROM public.report r
    WHERE r.company_id = p_company_id
      AND r.framework = 'VSME'
      AND COALESCE(r.status, 'draft') <> 'submitted'
  ),
  mapping_inputs AS (
    SELECT
      'legal_name'::TEXT AS map_key,
      cv.legal_name AS source_value,
      '84496cc7-9946-484b-951e-0f2464274b85'::UUID AS known_question_id,
      ARRAY['template_reporting_entity_name']::TEXT[] AS datapoint_candidates,
      ARRAY[]::TEXT[] AS code_candidates
    FROM company_values cv

    UNION ALL

    SELECT
      'address',
      cv.address,
      NULL::UUID,
      ARRAY['AddressOfSite']::TEXT[],
      ARRAY[]::TEXT[]
    FROM company_values cv

    UNION ALL

    SELECT
      'city',
      cv.city,
      NULL::UUID,
      ARRAY['CityOfSite']::TEXT[],
      ARRAY[]::TEXT[]
    FROM company_values cv

    UNION ALL

    SELECT
      'postal_code',
      cv.postal_code,
      NULL::UUID,
      ARRAY['PostalCodeOfSite']::TEXT[],
      ARRAY[]::TEXT[]
    FROM company_values cv

    UNION ALL

    SELECT
      'country_code',
      cv.country_code,
      NULL::UUID,
      ARRAY['CountryOfSite']::TEXT[],
      ARRAY[]::TEXT[]
    FROM company_values cv

    UNION ALL

    SELECT
      'identification_number',
      cv.identification_number,
      NULL::UUID,
      ARRAY['template_reporting_entity_identifier']::TEXT[],
      ARRAY[]::TEXT[]
    FROM company_values cv

    UNION ALL

    SELECT
      'vat_number',
      cv.vat_number,
      NULL::UUID,
      ARRAY[
        'VATNumber',
        'VatNumber',
        'template_vat_number',
        'template_reporting_entity_vat_number'
      ]::TEXT[],
      ARRAY[
        'B1_VAT',
        'B1-VAT'
      ]::TEXT[]
    FROM company_values cv
  ),
  target_questions AS (
    SELECT DISTINCT
      q.id AS question_id,
      mi.map_key,
      mi.source_value
    FROM mapping_inputs mi
    JOIN public.disclosure_question q
      ON q.framework = 'VSME'
     AND q.section_code = 'B1'
     AND (
          (mi.known_question_id IS NOT NULL AND q.id = mi.known_question_id)
       OR (q.vsme_datapoint_id IS NOT NULL AND q.vsme_datapoint_id = ANY(mi.datapoint_candidates))
       OR q.code = ANY(mi.code_candidates)
     )
    WHERE mi.source_value IS NOT NULL
  ),
  upserted AS (
    INSERT INTO public.disclosure_answer (
      report_id,
      question_id,
      value_text,
      value_jsonb
    )
    SELECT
      tr.report_id,
      tq.question_id,
      tq.source_value,
      jsonb_build_object('source', 'company_profile')
    FROM target_reports tr
    JOIN target_questions tq ON TRUE
    LEFT JOIN public.disclosure_answer da
      ON da.report_id = tr.report_id
     AND da.question_id = tq.question_id
    WHERE da.id IS NULL
       OR (
            (da.value_text IS NULL OR btrim(da.value_text) = '')
        AND da.value_numeric IS NULL
        AND da.value_date IS NULL
       )
    ON CONFLICT (report_id, question_id)
    DO UPDATE
      SET value_text = EXCLUDED.value_text,
          value_jsonb = COALESCE(public.disclosure_answer.value_jsonb, '{}'::jsonb) || jsonb_build_object('source', 'company_profile'),
          updated_at = NOW()
    WHERE
          (public.disclosure_answer.value_text IS NULL OR btrim(public.disclosure_answer.value_text) = '')
      AND public.disclosure_answer.value_numeric IS NULL
      AND public.disclosure_answer.value_date IS NULL
    RETURNING 1
  )
  SELECT COUNT(*)::INTEGER
  INTO v_prefilled_count
  FROM upserted;

  RETURN v_prefilled_count;
END;
$$;

COMMENT ON FUNCTION public.prefill_company_profile_into_open_reports(UUID)
IS 'Prefills overlapping company-profile fields into open/non-submitted VSME B1 answers when typed values are missing; preserves value_jsonb metadata and marks source=company_profile.';

GRANT EXECUTE ON FUNCTION public.prefill_company_profile_into_open_reports(UUID) TO authenticated;
