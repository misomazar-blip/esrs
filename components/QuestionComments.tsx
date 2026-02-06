"use client";

import { useState, useEffect } from "react";
import { useTranslations } from "next-intl";
import { createSupabaseBrowserClient } from "@/lib/supabase/client";
import { colors, buttonStyles, inputStyles, fonts, spacing } from "@/lib/styles";

type Comment = {
  id: string;
  question_id: string;
  report_id: string;
  user_id: string;
  user_email?: string;
  parent_comment_id: string | null;
  comment_text: string;
  created_at: string;
  updated_at: string;
  is_edited: boolean;
  replies?: Comment[];
};

type CommentsProps = {
  questionId: string;
  reportId: string;
  currentUserEmail: string;
};

export default function QuestionComments({ questionId, reportId, currentUserEmail }: CommentsProps) {
  const t = useTranslations('comments');
  const supabase = createSupabaseBrowserClient();
  const [comments, setComments] = useState<Comment[]>([]);
  const [loading, setLoading] = useState(true);
  const [newComment, setNewComment] = useState("");
  const [replyingTo, setReplyingTo] = useState<string | null>(null);
  const [replyText, setReplyText] = useState("");
  const [editingId, setEditingId] = useState<string | null>(null);
  const [editText, setEditText] = useState("");
  const [expanded, setExpanded] = useState(false);

  useEffect(() => {
    loadComments();
  }, [questionId, reportId]);

  async function loadComments() {
    setLoading(true);
    const { data, error } = await supabase
      .from("question_comment_with_user")
      .select("*")
      .eq("question_id", questionId)
      .eq("report_id", reportId)
      .order("created_at", { ascending: true });

    if (error) {
      console.error("Error loading comments:", error);
      setLoading(false);
      return;
    }

    // Build threaded structure
    const commentMap = new Map<string, Comment>();
    const rootComments: Comment[] = [];

    (data || []).forEach((c: any) => {
      commentMap.set(c.id, { ...c, replies: [] });
    });

    (data || []).forEach((c: any) => {
      const comment = commentMap.get(c.id)!;
      if (c.parent_comment_id) {
        const parent = commentMap.get(c.parent_comment_id);
        if (parent) {
          parent.replies!.push(comment);
        } else {
          rootComments.push(comment);
        }
      } else {
        rootComments.push(comment);
      }
    });

    setComments(rootComments);
    setLoading(false);
  }

  async function addComment(parentId: string | null = null) {
    const text = parentId ? replyText : newComment;
    if (!text.trim()) return;

    const { data: userData } = await supabase.auth.getUser();
    if (!userData.user) return;

    const { error } = await supabase.from("question_comment").insert({
      question_id: questionId,
      report_id: reportId,
      user_id: userData.user.id,
      parent_comment_id: parentId,
      comment_text: text.trim(),
    });

    if (error) {
      console.error("Error adding comment:", error);
      alert("Failed to add comment");
      return;
    }

    if (parentId) {
      setReplyText("");
      setReplyingTo(null);
    } else {
      setNewComment("");
    }

    loadComments();
  }

  async function updateComment(commentId: string) {
    if (!editText.trim()) return;

    const { error } = await supabase
      .from("question_comment")
      .update({ comment_text: editText.trim() })
      .eq("id", commentId);

    if (error) {
      console.error("Error updating comment:", error);
      alert("Failed to update comment");
      return;
    }

    setEditingId(null);
    setEditText("");
    loadComments();
  }

  async function deleteComment(commentId: string) {
    if (!confirm(t('deleteConfirm'))) return;

    const { error } = await supabase
      .from("question_comment")
      .delete()
      .eq("id", commentId);

    if (error) {
      console.error("Error deleting comment:", error);
      alert("Failed to delete comment");
      return;
    }

    loadComments();
  }

  function renderComment(comment: Comment, depth: number = 0) {
    const isOwn = comment.user_email === currentUserEmail;
    const isEditing = editingId === comment.id;
    const isReplying = replyingTo === comment.id;

    return (
      <div
        key={comment.id}
        style={{
          marginLeft: depth > 0 ? spacing.xl : 0,
          marginTop: spacing.sm,
          borderLeft: depth > 0 ? `2px solid ${colors.borderGray}` : "none",
          paddingLeft: depth > 0 ? spacing.md : 0,
        }}
      >
        <div
          style={{
            backgroundColor: isOwn ? colors.primaryLight : colors.bgSecondary,
            borderRadius: "6px",
            padding: spacing.sm,
          }}
        >
          {/* Header */}
          <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: spacing.xs }}>
            <div style={{ display: "flex", alignItems: "center", gap: spacing.sm }}>
              <div
                style={{
                  width: "24px",
                  height: "24px",
                  borderRadius: "50%",
                  backgroundColor: colors.primary,
                  display: "flex",
                  alignItems: "center",
                  justifyContent: "center",
                  color: colors.white,
                  fontSize: fonts.size.xs,
                  fontWeight: fonts.weight.bold,
                }}
              >
                {comment.user_email?.[0]?.toUpperCase() || "?"}
              </div>
              <span style={{ fontSize: fonts.size.sm, fontWeight: fonts.weight.semibold, color: colors.textPrimary }}>
                {comment.user_email || "Unknown"}
              </span>
              <span style={{ fontSize: fonts.size.xs, color: colors.textSecondary }}>
                {new Date(comment.created_at).toLocaleString("sk-SK")}
                {comment.is_edited && " (edited)"}
              </span>
            </div>

            {/* Actions */}
            {isOwn && !isEditing && (
              <div style={{ display: "flex", gap: spacing.xs }}>
                <button
                  onClick={() => {
                    setEditingId(comment.id);
                    setEditText(comment.comment_text);
                  }}
                  style={{
                    background: "none",
                    border: "none",
                    color: colors.primary,
                    cursor: "pointer",
                    fontSize: fonts.size.xs,
                    padding: `${spacing.xs} ${spacing.sm}`,
                  }}
                >
                  {t('edit')}
                </button>
                <button
                  onClick={() => deleteComment(comment.id)}
                  style={{
                    background: "none",
                    border: "none",
                    color: colors.error,
                    cursor: "pointer",
                    fontSize: fonts.size.xs,
                    padding: `${spacing.xs} ${spacing.sm}`,
                  }}
                >
                  {t('delete')}
                </button>
              </div>
            )}
          </div>

          {/* Content */}
          {isEditing ? (
            <div>
              <textarea
                value={editText}
                onChange={(e) => setEditText(e.target.value)}
                style={{
                  ...inputStyles.base,
                  width: "100%",
                  minHeight: "60px",
                  marginBottom: spacing.xs,
                  resize: "vertical",
                }}
              />
              <div style={{ display: "flex", gap: spacing.sm }}>
                <button
                  onClick={() => updateComment(comment.id)}
                  style={{
                    ...buttonStyles.primary,
                    padding: `${spacing.xs} ${spacing.md}`,
                    fontSize: fonts.size.sm,
                  }}
                >
                  {t('save')}
                </button>
                <button
                  onClick={() => {
                    setEditingId(null);
                    setEditText("");
                  }}
                  style={{
                    ...buttonStyles.secondary,
                    padding: `${spacing.xs} ${spacing.md}`,
                    fontSize: fonts.size.sm,
                  }}
                >
                  {t('cancel')}
                </button>
              </div>
            </div>
          ) : (
            <>
              <p
                style={{
                  fontSize: fonts.size.sm,
                  color: colors.textPrimary,
                  margin: `${spacing.xs} 0`,
                  whiteSpace: "pre-wrap",
                  wordBreak: "break-word",
                }}
              >
                {comment.comment_text}
              </p>

              {/* Reply Button */}
              {!isReplying && depth < 3 && (
                <button
                  onClick={() => setReplyingTo(comment.id)}
                  style={{
                    background: "none",
                    border: "none",
                    color: colors.primary,
                    cursor: "pointer",
                    fontSize: fonts.size.xs,
                    padding: `${spacing.xs} 0`,
                    fontWeight: fonts.weight.semibold,
                  }}
                >
                  💬 {t('reply')}
                </button>
              )}
            </>
          )}
        </div>

        {/* Reply Form */}
        {isReplying && (
          <div style={{ marginTop: spacing.sm, marginLeft: spacing.xl }}>
            <textarea
              value={replyText}
              onChange={(e) => setReplyText(e.target.value)}
              placeholder={t('addReply')}
              style={{
                ...inputStyles.base,
                width: "100%",
                minHeight: "60px",
                marginBottom: spacing.xs,
                resize: "vertical",
              }}
            />
            <div style={{ display: "flex", gap: spacing.sm }}>
              <button
                onClick={() => addComment(comment.id)}
                style={{
                  ...buttonStyles.primary,
                  padding: `${spacing.xs} ${spacing.md}`,
                  fontSize: fonts.size.sm,
                }}
              >
                {t('reply')}
              </button>
              <button
                onClick={() => {
                  setReplyingTo(null);
                  setReplyText("");
                }}
                style={{
                  ...buttonStyles.secondary,
                  padding: `${spacing.xs} ${spacing.md}`,
                  fontSize: fonts.size.sm,
                }}
              >
                {t('cancel')}
              </button>
            </div>
          </div>
        )}

        {/* Replies */}
        {comment.replies && comment.replies.length > 0 && (
          <div>{comment.replies.map((reply) => renderComment(reply, depth + 1))}</div>
        )}
      </div>
    );
  }

  const totalComments = (() => {
    function countComments(comments: Comment[]): number {
      return comments.reduce((acc, c) => acc + 1 + countComments(c.replies || []), 0);
    }
    return countComments(comments);
  })();

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
            💬 {t('title')} ({totalComments})
          </span>
        </div>
      </div>

      {expanded && (
        <div style={{ padding: spacing.md }}>
          {/* New Comment Form */}
          <div style={{ marginBottom: spacing.md }}>
            <textarea
              value={newComment}
              onChange={(e) => setNewComment(e.target.value)}
              placeholder={t('addComment')}
              style={{
                ...inputStyles.base,
                width: "100%",
                minHeight: "80px",
                marginBottom: spacing.xs,
                resize: "vertical",
              }}
            />
            <button
              onClick={() => addComment()}
              disabled={!newComment.trim()}
              style={{
                ...buttonStyles.primary,
                padding: `${spacing.xs} ${spacing.md}`,
                fontSize: fonts.size.sm,
                opacity: !newComment.trim() ? 0.5 : 1,
              }}
            >
              {t('submit')}
            </button>
          </div>

          {/* Comments List */}
          {loading ? (
            <div style={{ textAlign: "center", padding: spacing.md, color: colors.textSecondary }}>
              {t('loading')}
            </div>
          ) : comments.length === 0 ? (
            <div style={{ textAlign: "center", padding: spacing.md, color: colors.textSecondary }}>
              {t('noComments')}
            </div>
          ) : (
            <div>{comments.map((comment) => renderComment(comment))}</div>
          )}
        </div>
      )}
    </div>
  );
}
