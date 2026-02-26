// VSME Report and Question Types

export interface VsmeQuestion {
  question_id: string;
  question_text?: string;
  code?: string;
  answer_type?: string;
  section_code?: string;
  value_numeric?: number | null;
  value_text?: string | null;
  value_date?: string | null;
  value_jsonb?: Record<string, any> | null;
  config_jsonb?: {
    allowed_values?: string[];
    [key: string]: any;
  } | null;
  updated_at?: string;
}

export interface VsmeQuestionListResponse {
  questions: VsmeQuestion[];
  total: number;
}
