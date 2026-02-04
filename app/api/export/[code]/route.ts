import { NextResponse } from "next/server";
import { createSupabaseServerClient } from "@/lib/supabase/server";

export async function GET(req: Request, { params }: { params: Promise<{ code: string }> }) {
  try {
    const { searchParams } = new URL(req.url);
    const reportId = searchParams.get("reportId");
    const { code } = await params;
    const topicCode = code.toUpperCase();

    if (!reportId) {
      return NextResponse.json({ error: "Missing reportId" }, { status: 400 });
    }

    const supabase = await createSupabaseServerClient();

    const { data: authData } = await supabase.auth.getUser();
    if (!authData?.user) {
      return NextResponse.json({ error: "Not authenticated" }, { status: 401 });
    }

    // Check že user vlastní tento report (BEZPEČNOSŤ)
    const { data: report, error: rErr } = await supabase
      .from("report")
      .select("company_id, reporting_year")
      .eq("id", reportId)
      .maybeSingle();

    if (rErr) {
      return NextResponse.json({ error: `Cannot load report: ${rErr.message}` }, { status: 500 });
    }
    if (!report) {
      return NextResponse.json({ error: "Report not found" }, { status: 404 });
    }

    const { data: company, error: cErr } = await supabase
      .from("company")
      .select("user_id, name")
      .eq("id", report.company_id)
      .maybeSingle();

    if (cErr) {
      return NextResponse.json({ error: `Cannot load company: ${cErr.message}` }, { status: 500 });
    }
    if (!company || company.user_id !== authData.user.id) {
      return NextResponse.json({ error: "Unauthorized: You don't own this report" }, { status: 403 });
    }

    // Get active version
    const { data: version } = await supabase
      .from("esrs_version")
      .select("id, version_name")
      .eq("is_active", true)
      .maybeSingle();

    const activeVersionId = version?.id;

    const { data: topic, error: topicErr } = await supabase
      .from("topic")
      .select("id, code, name")
      .eq("code", topicCode)
      .maybeSingle();

    if (topicErr) {
      return NextResponse.json({ error: `Cannot load topic ${topicCode}: ${topicErr.message}` }, { status: 500 });
    }
    if (!topic) {
      return NextResponse.json({ error: `Topic ${topicCode} not found` }, { status: 404 });
    }

    const { data: questions, error: qErr } = await supabase
      .from("disclosure_question")
      .select("id, code, question_text, order_index, data_type, unit, disclosure_requirement, esrs_paragraph, is_mandatory")
      .eq("topic_id", topic.id)
      .eq("version_id", activeVersionId)
      .order("order_index", { ascending: true });

    if (qErr) {
      return NextResponse.json({ error: `Cannot load questions: ${qErr.message}` }, { status: 500 });
    }

    const qList = questions ?? [];
    const questionIds = qList.map((q) => q.id);

    const { data: answers, error: aErr } = await supabase
      .from("disclosure_answer")
      .select("question_id, value_text, value_numeric, value_boolean, value_date, value_json, unit, notes, updated_at")
      .eq("report_id", reportId)
      .in("question_id", questionIds.length ? questionIds : ["00000000-0000-0000-0000-000000000000"]);

    if (aErr) {
      return NextResponse.json({ error: `Cannot load answers: ${aErr.message}` }, { status: 500 });
    }

    const answerByQ = new Map<string, any>();
    (answers ?? []).forEach((a: any) => answerByQ.set(a.question_id, a));

    // Helper function to format answer value
    function formatAnswer(question: any, answer: any): string {
      if (!answer) return "[NO ANSWER]";

      const dataType = question.data_type;
      
      switch (dataType) {
        case "narrative":
        case "text":
          return answer.value_text?.trim() || "[NO ANSWER]";
        
        case "percentage":
        case "percent":
          if (answer.value_numeric !== null && answer.value_numeric !== undefined) {
            return `${answer.value_numeric}%`;
          }
          return "[NO ANSWER]";
        
        case "monetary":
          if (answer.value_numeric !== null && answer.value_numeric !== undefined) {
            const unit = answer.unit || question.unit || "EUR";
            return `${answer.value_numeric} ${unit}`;
          }
          return "[NO ANSWER]";
        
        case "numeric":
        case "integer":
          if (answer.value_numeric !== null && answer.value_numeric !== undefined) {
            const unit = answer.unit || question.unit || "";
            return unit ? `${answer.value_numeric} ${unit}` : `${answer.value_numeric}`;
          }
          return "[NO ANSWER]";
        
        case "date":
          return answer.value_date || "[NO ANSWER]";
        
        case "boolean":
          if (answer.value_boolean !== null && answer.value_boolean !== undefined) {
            return answer.value_boolean ? "Yes" : "No";
          }
          return "[NO ANSWER]";
        
        default:
          // Fallback to text
          return answer.value_text?.trim() || "[NO ANSWER]";
      }
    }

    const lines: string[] = [];
    lines.push("═══════════════════════════════════════════════════════════════");
    lines.push(`  ESRS ${topic.code} — ${topic.name ?? "Topic"}`);
    lines.push(`  ${company.name} — Reporting Year: ${report.reporting_year}`);
    lines.push(`  Version: ${version?.version_name ?? "Unknown"}`);
    lines.push(`  Exported: ${new Date().toISOString()}`);
    lines.push("═══════════════════════════════════════════════════════════════");
    lines.push("");

    for (const q of qList as any[]) {
      const answer = answerByQ.get(q.id);
      const answerValue = formatAnswer(q, answer);
      
      lines.push("───────────────────────────────────────────────────────────────");
      lines.push(`[${q.code}] ${q.is_mandatory ? "★ MANDATORY" : "VOLUNTARY"}`);
      
      if (q.disclosure_requirement) {
        lines.push(`DR: ${q.disclosure_requirement}`);
      }
      if (q.esrs_paragraph) {
        lines.push(`Paragraph: ${q.esrs_paragraph}`);
      }
      
      lines.push("");
      lines.push("Question:");
      lines.push(q.question_text || "[No question text]");
      lines.push("");
      lines.push("Answer:");
      lines.push(answerValue);
      
      if (answer?.notes) {
        lines.push("");
        lines.push("Notes:");
        lines.push(answer.notes);
      }
      
      lines.push("");
    }

    lines.push("═══════════════════════════════════════════════════════════════");
    lines.push(`  End of ${topic.code} Export`);
    lines.push("═══════════════════════════════════════════════════════════════");

    const filename = `ESRS_${topic.code}_${company.name.replace(/[^a-z0-9]/gi, '_')}_${report.reporting_year}.txt`;

    return new NextResponse(lines.join("\n"), {
      headers: {
        "Content-Type": "text/plain; charset=utf-8",
        "Content-Disposition": `attachment; filename="${filename}"`,
      },
    });
  } catch (e: any) {
    return NextResponse.json({ error: e?.message ?? "Unexpected error" }, { status: 500 });
  }
}
