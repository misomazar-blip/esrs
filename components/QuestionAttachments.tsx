"use client";

import { useState, useEffect, useRef } from "react";
import { useTranslations } from "next-intl";
import { createSupabaseBrowserClient } from "@/lib/supabase/client";
import { colors, fonts, spacing } from "@/lib/styles";

type Attachment = {
  id: string;
  question_id: string;
  report_id: string;
  user_id: string;
  file_name: string;
  file_size: number;
  file_type: string;
  storage_path: string;
  description: string | null;
  created_at: string;
  user_email?: string;
};

export default function QuestionAttachments({
  questionId,
  reportId,
  currentUserEmail,
}: {
  questionId: string;
  reportId: string;
  currentUserEmail: string;
}) {
  const t = useTranslations('attachments');
  const supabase = createSupabaseBrowserClient();
  const fileInputRef = useRef<HTMLInputElement>(null);

  const [attachments, setAttachments] = useState<Attachment[]>([]);
  const [loading, setLoading] = useState(false);
  const [uploading, setUploading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [expanded, setExpanded] = useState(false);
  const [description, setDescription] = useState("");
  const [previewUrl, setPreviewUrl] = useState<string | null>(null);
  const [previewType, setPreviewType] = useState<string | null>(null);

  useEffect(() => {
    loadAttachments();
  }, [questionId, reportId]);

  const loadAttachments = async () => {
    setLoading(true);
    setError(null);

    try {
      const { data, error: fetchError } = await supabase
        .from("question_attachment_with_user")
        .select("*")
        .eq("question_id", questionId)
        .eq("report_id", reportId)
        .order("created_at", { ascending: false });

      if (fetchError) throw fetchError;

      setAttachments((data as Attachment[]) || []);
    } catch (err: any) {
      console.error("Error loading attachments:", err);
      setError(err.message || "Failed to load attachments");
    } finally {
      setLoading(false);
    }
  };

  const handleFileSelect = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;

    // Validate file size (10MB)
    if (file.size > 10 * 1024 * 1024) {
      setError("File size exceeds 10MB limit");
      return;
    }

    setUploading(true);
    setError(null);

    try {
      const formData = new FormData();
      formData.append("file", file);
      formData.append("questionId", questionId);
      formData.append("reportId", reportId);
      if (description.trim()) {
        formData.append("description", description.trim());
      }

      const response = await fetch("/api/attachments", {
        method: "POST",
        body: formData,
      });

      if (!response.ok) {
        const errorData = await response.json();
        throw new Error(errorData.error || "Upload failed");
      }

      const { attachment } = await response.json();
      setAttachments((prev) => [attachment, ...prev]);
      setDescription("");

      // Reset file input
      if (fileInputRef.current) {
        fileInputRef.current.value = "";
      }
    } catch (err: any) {
      console.error("Upload error:", err);
      setError(err.message || "Failed to upload file");
    } finally {
      setUploading(false);
    }
  };

  const handleDelete = async (attachmentId: string, storagePath: string) => {
    if (!confirm(t('deleteConfirm'))) return;

    try {
      const response = await fetch(
        `/api/attachments?attachmentId=${attachmentId}`,
        {
          method: "DELETE",
        }
      );

      if (!response.ok) {
        const errorData = await response.json();
        throw new Error(errorData.error || "Delete failed");
      }

      setAttachments((prev) => prev.filter((a) => a.id !== attachmentId));
    } catch (err: any) {
      console.error("Delete error:", err);
      setError(err.message || "Failed to delete attachment");
    }
  };

  const handlePreview = async (attachment: Attachment) => {
    try {
      const { data, error: downloadError } = await supabase.storage
        .from("question-attachments")
        .createSignedUrl(attachment.storage_path, 3600); // 1 hour

      if (downloadError) throw downloadError;

      setPreviewUrl(data.signedUrl);
      setPreviewType(attachment.file_type);
    } catch (err: any) {
      console.error("Preview error:", err);
      setError("Failed to generate preview");
    }
  };

  const handleDownload = async (attachment: Attachment) => {
    try {
      const { data, error: downloadError } = await supabase.storage
        .from("question-attachments")
        .createSignedUrl(attachment.storage_path, 60);

      if (downloadError) throw downloadError;

      // Trigger download
      const link = document.createElement("a");
      link.href = data.signedUrl;
      link.download = attachment.file_name;
      document.body.appendChild(link);
      link.click();
      document.body.removeChild(link);
    } catch (err: any) {
      console.error("Download error:", err);
      setError("Failed to download file");
    }
  };

  const formatFileSize = (bytes: number): string => {
    if (bytes < 1024) return `${bytes} B`;
    if (bytes < 1024 * 1024) return `${(bytes / 1024).toFixed(1)} KB`;
    return `${(bytes / (1024 * 1024)).toFixed(1)} MB`;
  };

  const getFileIcon = (fileType: string): string => {
    if (fileType.startsWith("image/")) return "🖼️";
    if (fileType === "application/pdf") return "📄";
    if (fileType.includes("spreadsheet") || fileType.includes("excel"))
      return "📊";
    if (fileType.includes("presentation") || fileType.includes("powerpoint"))
      return "📽️";
    if (fileType.includes("word") || fileType.includes("document")) return "📝";
    if (fileType.startsWith("text/")) return "📃";
    return "📎";
  };

  return (
    <div
      style={{
        marginTop: spacing.md,
        border: `1px solid ${colors.borderGray}`,
        borderRadius: "6px",
        overflow: "hidden",
      }}
    >
      {/* Header */}
      <div
        onClick={() => setExpanded(!expanded)}
        style={{
          padding: spacing.md,
          backgroundColor: colors.bgSecondary,
          cursor: "pointer",
          display: "flex",
          justifyContent: "space-between",
          alignItems: "center",
          userSelect: "none",
        }}
      >
        <div style={{ display: "flex", alignItems: "center", gap: spacing.sm }}>
          <span style={{ fontSize: fonts.size.lg }}>
            {expanded ? "▼" : "▶"}
          </span>
          <span style={{ fontSize: fonts.size.body, fontWeight: fonts.weight.semibold }}>
            📎 {t('title')} ({attachments.length})
          </span>
        </div>
      </div>

      {/* Content */}
      {expanded && (
        <div style={{ padding: spacing.md }}>
          {/* Upload Section */}
          <div
            style={{
              marginBottom: spacing.lg,
              padding: spacing.md,
              backgroundColor: colors.bgSecondary,
              borderRadius: "6px",
            }}
          >
            <input
              ref={fileInputRef}
              type="file"
              onChange={handleFileSelect}
              disabled={uploading}
              style={{
                display: "none",
              }}
              accept="image/*,.pdf,.doc,.docx,.xls,.xlsx,.ppt,.pptx,.txt,.csv"
              id="file-upload-input"
            />
            
            <div style={{ display: "flex", gap: spacing.sm, marginBottom: spacing.sm, alignItems: "flex-start" }}>
              <button
                onClick={() => fileInputRef.current?.click()}
                disabled={uploading}
                style={{
                  padding: `${spacing.xs} ${spacing.md}`,
                  backgroundColor: uploading ? colors.borderGray : colors.primary,
                  color: colors.white,
                  border: "none",
                  borderRadius: "6px",
                  fontSize: fonts.size.sm,
                  fontWeight: fonts.weight.semibold,
                  cursor: uploading ? "not-allowed" : "pointer",
                  display: "flex",
                  alignItems: "center",
                  gap: spacing.xs,
                  whiteSpace: "nowrap",
                  transition: "background-color 0.2s",
                  flexShrink: 0,
                }}
                onMouseEnter={(e) => {
                  if (!uploading) {
                    e.currentTarget.style.backgroundColor = colors.primaryDark;
                  }
                }}
                onMouseLeave={(e) => {
                  if (!uploading) {
                    e.currentTarget.style.backgroundColor = colors.primary;
                  }
                }}
              >
                {uploading ? (
                  <>
                    <span>⏳</span>
                    <span>{t('uploading')}</span>
                  </>
                ) : (
                  <>
                    <span>📎</span>
                    <span>{t('chooseFile')}</span>
                  </>
                )}
              </button>
              
              <input
                type="text"
                placeholder={t('descriptionPlaceholder')}
                value={description}
                onChange={(e) => setDescription(e.target.value)}
                disabled={uploading}
                style={{
                  flex: 1,
                  padding: spacing.sm,
                  fontSize: fonts.size.sm,
                  border: `1px solid ${colors.borderGray}`,
                  borderRadius: "4px",
                }}
              />
            </div>
            
            <p style={{ fontSize: fonts.size.xs, color: colors.textSecondary }}>
              {t('maxSize')}
            </p>
          </div>

          {/* Error Message */}
          {error && (
            <div
              style={{
                padding: spacing.sm,
                backgroundColor: colors.errorLight,
                color: colors.error,
                borderRadius: "4px",
                marginBottom: spacing.md,
                fontSize: fonts.size.sm,
              }}
            >
              {error}
            </div>
          )}

          {/* Attachments List */}
          {loading ? (
            <p style={{ fontSize: fonts.size.sm, color: colors.textSecondary }}>
              Loading attachments...
            </p>
          ) : attachments.length === 0 ? (
            <p style={{ fontSize: fonts.size.sm, color: colors.textSecondary }}>
              {t('noAttachments')}
            </p>
          ) : (
            <div style={{ display: "flex", flexDirection: "column", gap: spacing.sm }}>
              {attachments.map((attachment) => {
                const isOwner = attachment.user_email === currentUserEmail;
                return (
                  <div
                    key={attachment.id}
                    style={{
                      padding: spacing.md,
                      border: `1px solid ${colors.borderGray}`,
                      borderRadius: "6px",
                      backgroundColor: isOwner ? "#e6f0ff" : colors.white,
                    }}
                  >
                    <div
                      style={{
                        display: "flex",
                        justifyContent: "space-between",
                        alignItems: "flex-start",
                      }}
                    >
                      <div style={{ flex: 1 }}>
                        <div
                          style={{
                            display: "flex",
                            alignItems: "center",
                            gap: spacing.xs,
                            marginBottom: spacing.xs,
                          }}
                        >
                          <span style={{ fontSize: fonts.size.lg }}>
                            {getFileIcon(attachment.file_type)}
                          </span>
                          <span
                            style={{
                              fontSize: fonts.size.body,
                              fontWeight: fonts.weight.semibold,
                              wordBreak: "break-word",
                            }}
                          >
                            {attachment.file_name}
                          </span>
                        </div>
                        <div
                          style={{
                            fontSize: fonts.size.xs,
                            color: colors.textSecondary,
                            marginBottom: spacing.xs,
                          }}
                        >
                          {formatFileSize(attachment.file_size)} •{" "}
                          {new Date(attachment.created_at).toLocaleString("sk-SK")} •{" "}
                          {attachment.user_email}
                        </div>
                        {attachment.description && (
                          <p
                            style={{
                              fontSize: fonts.size.sm,
                              color: colors.textPrimary,
                              marginTop: spacing.xs,
                            }}
                          >
                            {attachment.description}
                          </p>
                        )}
                      </div>
                      <div style={{ display: "flex", gap: spacing.xs, marginLeft: spacing.md }}>
                        {attachment.file_type.startsWith("image/") && (
                          <button
                            onClick={() => handlePreview(attachment)}
                            style={{
                              padding: `${spacing.xs} ${spacing.sm}`,
                              fontSize: fonts.size.xs,
                              backgroundColor: colors.info,
                              color: colors.white,
                              border: "none",
                              borderRadius: "4px",
                              cursor: "pointer",
                            }}
                          >
                            👁️ Preview
                          </button>
                        )}
                        <button
                          onClick={() => handleDownload(attachment)}
                          style={{
                            padding: `${spacing.xs} ${spacing.sm}`,
                            fontSize: fonts.size.xs,
                            backgroundColor: colors.primary,
                            color: colors.white,
                            border: "none",
                            borderRadius: "4px",
                            cursor: "pointer",
                          }}
                        >
                          ⬇️ Download
                        </button>
                        {isOwner && (
                          <button
                            onClick={() =>
                              handleDelete(attachment.id, attachment.storage_path)
                            }
                            style={{
                              padding: `${spacing.xs} ${spacing.sm}`,
                              fontSize: fonts.size.xs,
                              backgroundColor: colors.error,
                              color: colors.white,
                              border: "none",
                              borderRadius: "4px",
                              cursor: "pointer",
                            }}
                          >
                            🗑️ Delete
                          </button>
                        )}
                      </div>
                    </div>
                  </div>
                );
              })}
            </div>
          )}

          {/* Preview Modal */}
          {previewUrl && (
            <div
              onClick={() => setPreviewUrl(null)}
              style={{
                position: "fixed",
                top: 0,
                left: 0,
                right: 0,
                bottom: 0,
                backgroundColor: "rgba(0,0,0,0.8)",
                display: "flex",
                alignItems: "center",
                justifyContent: "center",
                zIndex: 1000,
                padding: spacing.xl,
              }}
            >
              <div
                onClick={(e) => e.stopPropagation()}
                style={{
                  maxWidth: "90%",
                  maxHeight: "90%",
                  backgroundColor: colors.white,
                  borderRadius: "8px",
                  overflow: "auto",
                  position: "relative",
                }}
              >
                <button
                  onClick={() => setPreviewUrl(null)}
                  style={{
                    position: "absolute",
                    top: spacing.sm,
                    right: spacing.sm,
                    padding: spacing.sm,
                    backgroundColor: colors.error,
                    color: colors.white,
                    border: "none",
                    borderRadius: "4px",
                    cursor: "pointer",
                    fontSize: fonts.size.lg,
                    fontWeight: fonts.weight.bold,
                  }}
                >
                  ✕
                </button>
                {previewType?.startsWith("image/") && (
                  <img
                    src={previewUrl}
                    alt="Preview"
                    style={{ maxWidth: "100%", maxHeight: "90vh", display: "block" }}
                  />
                )}
              </div>
            </div>
          )}
        </div>
      )}
    </div>
  );
}
