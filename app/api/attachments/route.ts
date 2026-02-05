import { NextRequest, NextResponse } from "next/server";
import { createSupabaseServerClient } from "@/lib/supabase/server";

const MAX_FILE_SIZE = 10 * 1024 * 1024; // 10MB
const ALLOWED_TYPES = [
  "image/jpeg",
  "image/png",
  "image/gif",
  "image/webp",
  "application/pdf",
  "application/vnd.ms-excel",
  "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
  "application/vnd.ms-powerpoint",
  "application/vnd.openxmlformats-officedocument.presentationml.presentation",
  "application/msword",
  "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
  "text/plain",
  "text/csv",
];

export async function POST(request: NextRequest) {
  try {
    const supabase = await createSupabaseServerClient();

    // Check authentication
    const {
      data: { user },
      error: authError,
    } = await supabase.auth.getUser();

    if (authError || !user) {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    const formData = await request.formData();
    const file = formData.get("file") as File;
    const questionId = formData.get("questionId") as string;
    const reportId = formData.get("reportId") as string;
    const description = formData.get("description") as string | null;

    if (!file || !questionId || !reportId) {
      return NextResponse.json(
        { error: "Missing required fields" },
        { status: 400 }
      );
    }

    // Validate file size
    if (file.size > MAX_FILE_SIZE) {
      return NextResponse.json(
        { error: "File size exceeds 10MB limit" },
        { status: 400 }
      );
    }

    // Validate file type
    if (!ALLOWED_TYPES.includes(file.type)) {
      return NextResponse.json(
        { error: "File type not allowed" },
        { status: 400 }
      );
    }

    // Check if user has access to this report
    const { data: report } = await supabase
      .from("report")
      .select("id, company_id, company(user_id)")
      .eq("id", reportId)
      .single();

    if (!report || (report.company as any)?.user_id !== user.id) {
      return NextResponse.json(
        { error: "Access denied to this report" },
        { status: 403 }
      );
    }

    // Generate unique file path
    const timestamp = Date.now();
    const sanitizedFileName = file.name.replace(/[^a-zA-Z0-9.-]/g, "_");
    const storagePath = `${reportId}/${questionId}/${timestamp}_${sanitizedFileName}`;

    // Upload to Supabase Storage
    const fileBuffer = await file.arrayBuffer();
    const { data: storageData, error: storageError } = await supabase.storage
      .from("question-attachments")
      .upload(storagePath, fileBuffer, {
        contentType: file.type,
        upsert: false,
      });

    if (storageError) {
      console.error("Storage error:", storageError);
      return NextResponse.json(
        { error: "Failed to upload file to storage" },
        { status: 500 }
      );
    }

    // Save metadata to database
    const { data: attachment, error: dbError } = await supabase
      .from("question_attachment")
      .insert({
        question_id: questionId,
        report_id: reportId,
        user_id: user.id,
        file_name: file.name,
        file_size: file.size,
        file_type: file.type,
        storage_path: storagePath,
        description: description || null,
      })
      .select("*")
      .single();

    if (dbError) {
      // Rollback: delete from storage
      await supabase.storage.from("question-attachments").remove([storagePath]);
      console.error("Database error:", dbError);
      return NextResponse.json(
        { error: "Failed to save attachment metadata" },
        { status: 500 }
      );
    }

    return NextResponse.json({ attachment }, { status: 201 });
  } catch (error) {
    console.error("Upload error:", error);
    return NextResponse.json(
      { error: "Internal server error" },
      { status: 500 }
    );
  }
}

export async function DELETE(request: NextRequest) {
  try {
    const supabase = await createSupabaseServerClient();

    // Check authentication
    const {
      data: { user },
      error: authError,
    } = await supabase.auth.getUser();

    if (authError || !user) {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    const { searchParams } = new URL(request.url);
    const attachmentId = searchParams.get("attachmentId");

    if (!attachmentId) {
      return NextResponse.json(
        { error: "Missing attachmentId" },
        { status: 400 }
      );
    }

    // Get attachment details
    const { data: attachment, error: fetchError } = await supabase
      .from("question_attachment")
      .select("*, report(company_id, company(user_id))")
      .eq("id", attachmentId)
      .single();

    if (fetchError || !attachment) {
      return NextResponse.json(
        { error: "Attachment not found" },
        { status: 404 }
      );
    }

    // Check ownership
    const reportCompany = (attachment.report as any)?.company;
    if (
      attachment.user_id !== user.id &&
      reportCompany?.user_id !== user.id
    ) {
      return NextResponse.json(
        { error: "Access denied" },
        { status: 403 }
      );
    }

    // Delete from storage
    const { error: storageError } = await supabase.storage
      .from("question-attachments")
      .remove([attachment.storage_path]);

    if (storageError) {
      console.error("Storage deletion error:", storageError);
    }

    // Delete from database
    const { error: dbError } = await supabase
      .from("question_attachment")
      .delete()
      .eq("id", attachmentId);

    if (dbError) {
      console.error("Database deletion error:", dbError);
      return NextResponse.json(
        { error: "Failed to delete attachment" },
        { status: 500 }
      );
    }

    return NextResponse.json({ success: true }, { status: 200 });
  } catch (error) {
    console.error("Delete error:", error);
    return NextResponse.json(
      { error: "Internal server error" },
      { status: 500 }
    );
  }
}
