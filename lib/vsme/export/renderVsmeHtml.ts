import { DisclosureAnswerRow, getStatus, isNaRow } from '@/lib/vsme/answers/answerState';

export function renderVsmeHtml({ questions, answers, completion_pct }: {
  questions: any[];
  answers: Record<string, DisclosureAnswerRow>;
  completion_pct: number;
}) {
  if (!questions || questions.length === 0) {
    return `<div>V tomto scope nie sú otázky.</div>`;
  }

  let html = `<html><head><meta charset='utf-8'><title>VSME Export</title></head><body>`;
  html += `<h1>VSME Report Export</h1>`;
  html += `<div>Completion: ${completion_pct}%</div>`;

  // Group by section
  const sectionMap: Record<string, any[]> = {};
  questions.forEach(q => {
    const sec = q.section_code || 'OTHER';
    if (!sectionMap[sec]) sectionMap[sec] = [];
    sectionMap[sec].push(q);
  });

  Object.entries(sectionMap).forEach(([section, qs]) => {
    html += `<h2>${section}</h2>`;
    html += `<table border='1' cellpadding='4' style='border-collapse:collapse;width:100%'>`;
    html += `<tr><th>#</th><th>Code</th><th>Question</th><th>Answer</th><th>Unit</th></tr>`;
    qs.forEach((q, idx) => {
      const a = answers[q.question_id];
      const status = getStatus(a);
      let answerStr = '—';
      if (status === 'na') answerStr = 'Not applicable';
      else if (status === 'answered') {
        if (a.value_text) answerStr = a.value_text;
        else if (a.value_boolean !== undefined && a.value_boolean !== null) answerStr = String(a.value_boolean);
        else if (a.value_integer !== undefined && a.value_integer !== null) answerStr = String(a.value_integer);
        else if (a.value_numeric !== undefined && a.value_numeric !== null) answerStr = String(a.value_numeric);
        else if (a.value_number !== undefined && a.value_number !== null) answerStr = String(a.value_number);
        else if (a.value_date) answerStr = a.value_date;
        else if (a.value_json && typeof a.value_json === 'object') answerStr = JSON.stringify(a.value_json);
        else if (a.value_jsonb && typeof a.value_jsonb === 'object') answerStr = JSON.stringify(a.value_jsonb);
      }
      html += `<tr><td>${idx + 1}</td><td>${q.code || ''}</td><td>${q.question_text || ''}</td><td>${answerStr}</td><td>${a?.unit || ''}</td></tr>`;
    });
    html += `</table>`;
  });

  html += `</body></html>`;
  return html;
}
