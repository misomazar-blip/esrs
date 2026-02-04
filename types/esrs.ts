// ESRS Versioning Types

export interface ESRSVersion {
  id: string;
  version_code: string;
  version_name: string;
  effective_date: string;
  is_active: boolean;
  description?: string;
  source_url?: string;
  created_at: string;
}

export type DataType = 
  | 'narrative'
  | 'text'
  | 'percentage'
  | 'percent'
  | 'monetary'
  | 'numeric'
  | 'integer'
  | 'date'
  | 'boolean';

export type AnswerType = 'text' | 'number' | 'boolean' | 'date';

export interface VersionedQuestion {
  id: string;
  topic_id: string;
  version_id?: string;
  code: string;
  datapoint_id?: string;
  question_text: string;
  description?: string;
  answer_type: AnswerType;
  order_index?: number;
  
  // EFRAG IG3 fields
  data_type?: DataType;
  unit?: string;
  disclosure_requirement?: string;
  esrs_paragraph?: string;
  esrs_section?: string;
  related_ar?: string;
  is_mandatory?: boolean;
  is_conditional?: boolean;
  is_voluntary?: boolean;
  phase_in_provision?: string;
  valid_from?: string;
  valid_to?: string;
  
  created_at: string;
  updated_at: string;
}

export interface VersionedAnswer {
  id: string;
  company_id: string;
  question_id: string;
  report_id?: string;
  answer_text?: string;
  
  // Typed value fields
  value_text?: string;
  value_numeric?: number;
  value_boolean?: boolean;
  value_date?: string;
  value_json?: any;
  
  unit?: string;
  notes?: string;
  source_document?: string;
  verified_at?: string;
  verified_by?: string;
  
  created_at: string;
  updated_at: string;
  created_by?: string;
}

export interface Topic {
  id: string;
  code: string;
  name: string;
  description?: string;
  category: 'environmental' | 'social' | 'governance';
  icon?: string;
  order_index: number;
  created_at: string;
}

// Helper type for question with topic
export interface QuestionWithTopic extends VersionedQuestion {
  topic: Topic;
}

// Helper type for answer with question and topic
export interface AnswerWithDetails extends VersionedAnswer {
  question: QuestionWithTopic;
}

// Version comparison types
export interface QuestionComparison {
  current: VersionedQuestion;
  previous?: VersionedQuestion;
  status: 'new' | 'modified' | 'unchanged' | 'deprecated';
}

export interface AnswerHistory {
  answer: VersionedAnswer;
  question_version: string;
  changed_fields: string[];
}
