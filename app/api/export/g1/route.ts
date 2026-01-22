import { NextResponse } from "next/server";
import { createSupabaseServerClient } from "@/lib/supabase/server";

export async function GET(req: Request) {
  try {
    const { searchParams } = new URL(req.url);
    const reportId = searchParams.get("reportId");

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
      .select("company_id")
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
      .select("user_id")
      .eq("id", report.company_id)
      .maybeSingle();

    if (cErr) {
      return NextResponse.json({ error: `Cannot load company: ${cErr.message}` }, { status: 500 });
    }
    if (!company || company.user_id !== authData.user.id) {
      return NextResponse.json({ error: "Unauthorized: You don't own this report" }, { status: 403 });
    }

    const { data: topic, error: topicErr } = await supabase
      .from("topic")
      .select("id, code, name")
      .eq("code", "G1")
      .maybeSingle();

    if (topicErr) {
      return NextResponse.json({ error: `Cannot load topic G1: ${topicErr.message}` }, { status: 500 });
    }
    if (!topic) {
      return NextResponse.json({ error: "Topic G1 not found" }, { status: 404 });
    }

    const { data: questions, error: qErr } = await supabase
      .from("disclosure_question")
      .select("id, code, question_text, order_index")
      .eq("topic_id", topic.id)
      .order("order_index", { ascending: true });

    if (qErr) {
      return NextResponse.json({ error: `Cannot load questions: ${qErr.message}` }, { status: 500 });
    }

    const qList = questions ?? [];
    const questionIds = qList.map((q) => q.id);

    const { data: answers, error: aErr } = await supabase
      .from("disclosure_answer")
      .select("question_id, value_text, updated_at")
      .eq("report_id", reportId)
      .in("question_id", questionIds.length ? questionIds : ["00000000-0000-0000-0000-000000000000"]);

    if (aErr) {
      return NextResponse.json({ error: `Cannot load answers: ${aErr.message}` }, { status: 500 });
    }

    const answerByQ = new Map<string, string>();
    (answers ?? []).forEach((a: any) => answerByQ.set(a.question_id, (a.value_text ?? "").trim()));

    const lines: string[] = [];
    lines.push(`${topic.code} — ${topic.name ?? "Topic"}`);
    lines.push("");

    for (const q of qList as any[]) {
      const ans = answerByQ.get(q.id) ?? "";
      lines.push(`${q.code} — ${q.question_text}`);
      lines.push(ans.length ? ans : "[NO ANSWER]");
      lines.push("");
    }

    return new NextResponse(lines.join("\n"), {
      headers: {
        "Content-Type": "text/plain; charset=utf-8",
        "Content-Disposition": `attachment; filename="ESRS_${topic.code}_${reportId}.txt"`,
      },
    });
  } catch (e: any) {
    return NextResponse.json({ error: e?.message ?? "Unexpected error" }, { status: 500 });
  }
}
