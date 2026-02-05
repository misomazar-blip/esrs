import { NextResponse } from "next/server";
import { createSupabaseServerClient } from "@/lib/supabase/server";
import JSZip from "jszip";

export async function GET(req: Request) {
  try {
    const { searchParams } = new URL(req.url);
    const reportId = searchParams.get("reportId");
    const format = searchParams.get("format") || "txt"; // txt, csv, or json

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

    // Get active ESRS version
    const { data: versionData } = await supabase
      .from("esrs_version")
      .select("id, version_name")
      .eq("is_active", true)
      .maybeSingle();

    const versionId = versionData?.id;
    const versionName = versionData?.version_name || "Unknown";

    if (!versionId) {
      return NextResponse.json({ error: "No active ESRS version found" }, { status: 500 });
    }

    // Nájdi materiálne témy pre tento report
    const { data: reportTopics, error: rtErr } = await supabase
      .from("report_topic")
      .select("topic_id")
      .eq("report_id", reportId)
      .eq("is_material", true);

    if (rtErr) {
      return NextResponse.json({ error: `Cannot load material topics: ${rtErr.message}` }, { status: 500 });
    }

    const materialTopicIds = (reportTopics ?? []).map((rt: any) => rt.topic_id);

    if (materialTopicIds.length === 0) {
      return NextResponse.json({ error: "No material topics found for this report" }, { status: 404 });
    }

    // Načítaj všetky materiálne témy s otázkami
    const { data: topics, error: tErr } = await supabase
      .from("topic")
      .select("id, code, name")
      .in("id", materialTopicIds);

    if (tErr) {
      return NextResponse.json({ error: `Cannot load topics: ${tErr.message}` }, { status: 500 });
    }

    const zip = new JSZip();
    const companyName = company.name.replace(/[^a-z0-9]/gi, "_");
    const year = report.reporting_year;

    // Pre každú materiálnu tému vytvor súbor
    for (const topic of topics ?? []) {
      const { data: questions, error: qErr } = await supabase
        .from("disclosure_question")
        .select("id, code, question_text, order_index, data_type, is_mandatory")
        .eq("topic_id", topic.id)
        .eq("version_id", versionId)
        .order("order_index", { ascending: true });

      if (qErr) {
        console.error(`Error loading questions for topic ${topic.code}:`, qErr);
        continue;
      }

      const qList = questions ?? [];
      const questionIds = qList.map((q) => q.id);

      const { data: answers, error: aErr } = await supabase
        .from("disclosure_answer")
        .select("question_id, value_text, value_numeric, updated_at")
        .eq("report_id", reportId)
        .in("question_id", questionIds.length ? questionIds : ["00000000-0000-0000-0000-000000000000"]);

      if (aErr) {
        console.error(`Error loading answers for topic ${topic.code}:`, aErr);
        continue;
      }

      const answerByQ = new Map<string, any>();
      (answers ?? []).forEach((a: any) => {
        answerByQ.set(a.question_id, {
          text: a.value_text ?? "",
          numeric: a.value_numeric ?? null,
          updated_at: a.updated_at,
        });
      });

      // Generate file content based on format
      let content = "";
      const fileName = `${topic.code}_${topic.name?.replace(/[^a-z0-9]/gi, "_") || "Topic"}`;

      if (format === "csv") {
        // CSV format
        const rows: string[] = [];
        rows.push("Code,Question,Answer,Type,Mandatory,Last Updated");
        
        for (const q of qList as any[]) {
          const ans = answerByQ.get(q.id);
          const answer = ans?.text?.trim() || ans?.numeric?.toString() || "";
          const lastUpdated = ans?.updated_at || "";
          const mandatory = q.is_mandatory ? "Yes" : "No";
          
          // Escape CSV values
          const escapeCsv = (str: string) => {
            if (str.includes(",") || str.includes('"') || str.includes("\n")) {
              return `"${str.replace(/"/g, '""')}"`;
            }
            return str;
          };
          
          rows.push(
            `${escapeCsv(q.code || "")},${escapeCsv(q.question_text || "")},${escapeCsv(answer)},${escapeCsv(q.data_type || "")},${mandatory},${lastUpdated}`
          );
        }
        
        content = rows.join("\n");
        zip.file(`${fileName}.csv`, content);
        
      } else if (format === "json") {
        // JSON format
        const jsonData = {
          topic: {
            code: topic.code,
            name: topic.name,
          },
          company: company.name,
          year: year,
          version: versionName,
          questions: qList.map((q: any) => {
            const ans = answerByQ.get(q.id);
            return {
              code: q.code,
              question: q.question_text,
              answer: ans?.text?.trim() || ans?.numeric?.toString() || null,
              dataType: q.data_type,
              isMandatory: q.is_mandatory,
              lastUpdated: ans?.updated_at || null,
            };
          }),
        };
        
        content = JSON.stringify(jsonData, null, 2);
        zip.file(`${fileName}.json`, content);
        
      } else {
        // TXT format (default)
        const lines: string[] = [];
        lines.push(`${topic.code} — ${topic.name ?? "Topic"}`);
        lines.push(`Company: ${company.name}`);
        lines.push(`Reporting Year: ${year}`);
        lines.push(`ESRS Version: ${versionName}`);
        lines.push("");
        lines.push("=".repeat(80));
        lines.push("");

        for (const q of qList as any[]) {
          const ans = answerByQ.get(q.id);
          const answer = ans?.text?.trim() || ans?.numeric?.toString() || "";
          const mandatory = q.is_mandatory ? "[MANDATORY]" : "[VOLUNTARY]";
          
          lines.push(`${q.code} ${mandatory} — ${q.question_text}`);
          lines.push(answer.length ? answer : "[NO ANSWER]");
          lines.push("");
        }

        content = lines.join("\n");
        zip.file(`${fileName}.txt`, content);
      }
    }

    // Add README file
    const readme = `ESRS Bulk Export
================

Company: ${company.name}
Reporting Year: ${year}
ESRS Version: ${versionName}
Export Date: ${new Date().toISOString()}
Format: ${format.toUpperCase()}

This archive contains all material topics for the selected report.
Each file represents one material topic with all questions and answers.

Total Topics: ${(topics ?? []).length}
`;

    zip.file("README.txt", readme);

    // Generate ZIP file
    const zipBuffer = await zip.generateAsync({ type: "nodebuffer" });

    return new NextResponse(zipBuffer, {
      headers: {
        "Content-Type": "application/zip",
        "Content-Disposition": `attachment; filename="ESRS_${companyName}_${year}_BulkExport.zip"`,
      },
    });
  } catch (e: any) {
    console.error("Bulk export error:", e);
    return NextResponse.json({ error: e?.message ?? "Unexpected error" }, { status: 500 });
  }
}
