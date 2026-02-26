import { createSupabaseBrowserClient } from '@/lib/supabase/client';
import { getStatus, DisclosureAnswerRow } from '@/lib/vsme/answers/answerState';

export async function getVsmeExportSnapshot(reportId: string) {
  const supabase = createSupabaseBrowserClient();

  // Load questions
  const { data: questionsData, error: questionsError } = await supabase.rpc('get_vsme_questions_for_report', {
    p_report_id: reportId,
  });
  if (questionsError) throw new Error(questionsError.message);
  const questions = questionsData || [];

  // Load answers
  const questionIds = questions.map((q: any) => q.question_id);
  const { data: answersData, error: answersError } = await supabase
    .from('disclosure_answer')
    .select('question_id,value_text,value_boolean,value_integer,value_numeric,value_number,value_date,value_json,value_jsonb,unit')
    .eq('report_id', reportId)
    .in('question_id', questionIds);
  if (answersError) throw new Error(answersError.message);
  const answers: DisclosureAnswerRow[] = answersData || [];

  // Build answer map
  const answerMap: Record<string, DisclosureAnswerRow> = {};
  answers.forEach(a => {
    answerMap[a.question_id] = a;
  });

  // Compute statuses
  let answeredCount = 0;
  let naCount = 0;
  questions.forEach((q: any) => {
    const a = answerMap[q.question_id];
    const status = getStatus(a);
    if (status === 'answered') answeredCount++;
    if (status === 'na') naCount++;
  });

  const total = questions.length;
  const completion_pct = total > 0 ? Math.round(((answeredCount + naCount) / total) * 100) : 0;

  return {
    questions,
    answers: answerMap,
    total,
    answeredCount,
    naCount,
    completion_pct,
  };
}
