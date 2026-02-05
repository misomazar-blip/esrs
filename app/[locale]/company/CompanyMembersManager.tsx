"use client";

import { useEffect, useState } from "react";
import { createSupabaseBrowserClient } from "@/lib/supabase/client";
import {
  AccessControl,
  CompanyMember,
  Role,
  AccessType,
  TopicAccess,
  RolePermissions,
} from "@/lib/access-control";
import { colors, buttonStyles, inputStyles, cardStyles, fonts, spacing } from "@/lib/styles";

interface Topic {
  id: string;
  code: string;
  name: string | null;
}

interface Props {
  companyId: string;
}

export default function CompanyMembersManager({ companyId }: Props) {
  const supabase = createSupabaseBrowserClient();
  const accessControl = new AccessControl();

  const [members, setMembers] = useState<CompanyMember[]>([]);
  const [topics, setTopics] = useState<Topic[]>([]);
  const [currentUserRole, setCurrentUserRole] = useState<Role | null>(null);
  const [loading, setLoading] = useState(true);
  const [msg, setMsg] = useState<{ type: "success" | "error"; text: string } | null>(null);

  // Add member form
  const [showAddForm, setShowAddForm] = useState(false);
  const [newMemberEmail, setNewMemberEmail] = useState("");
  const [newMemberRole, setNewMemberRole] = useState<Role>("viewer");
  const [newMemberAccessType, setNewMemberAccessType] = useState<AccessType>("all");
  const [newMemberTopics, setNewMemberTopics] = useState<{ [topicId: string]: { view: boolean; edit: boolean } }>({});

  // Topic access management
  const [editingMemberId, setEditingMemberId] = useState<string | null>(null);
  const [memberTopicAccess, setMemberTopicAccess] = useState<TopicAccess[]>([]);

  useEffect(() => {
    loadData();
  }, [companyId]);

  async function loadData() {
    setLoading(true);
    setMsg(null);

    // Get current user's role
    const role = await accessControl.getUserRole(companyId);
    setCurrentUserRole(role);

    if (!role) {
      setMsg({ type: "error", text: "You don't have access to this company" });
      setLoading(false);
      return;
    }

    // Load members
    await loadMembers();

    // Load topics
    const { data: topicsData } = await supabase
      .from("topic")
      .select("id, code, name")
      .order("code");
    setTopics((topicsData as Topic[]) || []);

    setLoading(false);
  }

  async function loadMembers() {
    // Use RPC function to get members with emails (returns JSONB)
    const { data, error } = await supabase
      .rpc('get_company_members_with_emails', { p_company_id: companyId });

    if (error) {
      setMsg({ type: "error", text: error.message });
      return;
    }

    // Parse JSONB response
    const members = (data || []) as CompanyMember[];
    setMembers(members);
  }

  async function handleAddMember() {
    if (!newMemberEmail.trim()) {
      setMsg({ type: "error", text: "Email is required" });
      return;
    }

    setLoading(true);
    const result = await accessControl.addMember(
      companyId,
      newMemberEmail,
      newMemberRole,
      newMemberAccessType
    );

    if (result.success && result.data) {
      // If selected topics, add topic access permissions
      if (newMemberAccessType === "selected" && Object.keys(newMemberTopics).length > 0) {
        const memberId = result.data.id;
        for (const [topicId, perms] of Object.entries(newMemberTopics)) {
          if (perms.view || perms.edit) {
            await accessControl.setTopicAccess(memberId, topicId, perms.view, perms.edit);
          }
        }
      }

      const inviteMsg = result.invited 
        ? "Member invited successfully! An invitation email has been sent." 
        : "Member added successfully!";
      setMsg({ type: "success", text: inviteMsg });
      setNewMemberEmail("");
      setNewMemberRole("viewer");
      setNewMemberAccessType("all");
      setNewMemberTopics({});
      setShowAddForm(false);
      await loadMembers();
    } else {
      setMsg({ type: "error", text: result.error || "Failed to add member" });
    }

    setLoading(false);
  }

  async function handleRemoveMember(memberId: string) {
    if (!confirm("Are you sure you want to remove this member?")) return;

    setLoading(true);
    const result = await accessControl.removeMember(memberId);

    if (result.success) {
      setMsg({ type: "success", text: "Member removed successfully" });
      await loadMembers();
    } else {
      setMsg({ type: "error", text: result.error || "Failed to remove member" });
    }

    setLoading(false);
  }

  async function handleUpdateMemberRole(memberId: string, role: Role) {
    setLoading(true);
    const result = await accessControl.updateMember(memberId, { role });

    if (result.success) {
      setMsg({ type: "success", text: "Role updated successfully" });
      await loadMembers();
    } else {
      setMsg({ type: "error", text: result.error || "Failed to update role" });
    }

    setLoading(false);
  }

  async function handleUpdateAccessType(memberId: string, accessType: AccessType) {
    setLoading(true);
    const result = await accessControl.updateMember(memberId, { access_type: accessType });

    if (result.success) {
      setMsg({ type: "success", text: "Access type updated successfully" });
      await loadMembers();
    } else {
      setMsg({ type: "error", text: result.error || "Failed to update access type" });
    }

    setLoading(false);
  }

  async function loadMemberTopicAccess(memberId: string) {
    const { data, error } = await supabase
      .from("company_member_topic_access")
      .select("*")
      .eq("company_member_id", memberId);

    if (!error && data) {
      setMemberTopicAccess(data as TopicAccess[]);
    }
  }

  async function handleToggleTopicAccess(
    memberId: string,
    topicId: string,
    type: "view" | "edit"
  ) {
    const existing = memberTopicAccess.find((ta) => ta.topic_id === topicId);

    let canView = existing?.can_view || false;
    let canEdit = existing?.can_edit || false;

    if (type === "view") {
      canView = !canView;
      // If removing view, also remove edit
      if (!canView) canEdit = false;
    } else {
      canEdit = !canEdit;
      // If adding edit, also add view
      if (canEdit) canView = true;
    }

    const result = await accessControl.setTopicAccess(memberId, topicId, canView, canEdit);

    if (result.success) {
      await loadMemberTopicAccess(memberId);
      setMsg({ type: "success", text: "Topic access updated" });
    } else {
      setMsg({ type: "error", text: result.error || "Failed to update access" });
    }
  }

  const canManage = currentUserRole === "owner" || currentUserRole === "admin";

  if (loading && members.length === 0) {
    return <div style={{ color: colors.textSecondary }}>Loading members...</div>;
  }

  return (
    <div>
      {/* Message */}
      {msg && (
        <div
          style={{
            backgroundColor: msg.type === "success" ? "#d4edda" : "#f8d7da",
            border: `1px solid ${msg.type === "success" ? colors.success : colors.error}`,
            color: msg.type === "success" ? "#155724" : colors.error,
            padding: spacing.md,
            borderRadius: "6px",
            marginBottom: spacing.lg,
            fontSize: fonts.size.sm,
          }}
        >
          {msg.text}
        </div>
      )}

      {/* Header */}
      <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: spacing.lg }}>
        <h3 style={{ fontSize: fonts.size.lg, fontWeight: fonts.weight.bold, margin: 0 }}>
          Company Members
        </h3>
        {canManage && (
          <button
            onClick={() => setShowAddForm(!showAddForm)}
            style={{
              ...buttonStyles.primary,
              padding: `${spacing.xs} ${spacing.md}`,
              fontSize: fonts.size.sm,
            }}
          >
            {showAddForm ? "Cancel" : "+ Add Member"}
          </button>
        )}
      </div>

      {/* Add Member Form */}
      {showAddForm && canManage && (
        <div style={{ ...cardStyles.base, marginBottom: spacing.lg, backgroundColor: colors.bgSecondary }}>
          <h4 style={{ fontSize: fonts.size.md, fontWeight: fonts.weight.bold, marginBottom: spacing.md }}>
            Add New Member
          </h4>
          <div style={{ display: "grid", gap: spacing.md }}>
            <div>
              <label style={{ display: "block", marginBottom: spacing.xs, fontSize: fonts.size.sm, fontWeight: fonts.weight.semibold }}>
                Email Address
              </label>
              <input
                type="email"
                value={newMemberEmail}
                onChange={(e) => setNewMemberEmail(e.target.value)}
                placeholder="member@example.com"
                style={inputStyles.base}
              />
            </div>

            <div>
              <label style={{ display: "block", marginBottom: spacing.xs, fontSize: fonts.size.sm, fontWeight: fonts.weight.semibold }}>
                Role
              </label>
              <select
                value={newMemberRole}
                onChange={(e) => {
                  const role = e.target.value as Role;
                  setNewMemberRole(role);
                  // Auto-set access type to "all" for admin and owner
                  if (role === "admin" || role === "owner") {
                    setNewMemberAccessType("all");
                  }
                }}
                style={inputStyles.base}
              >
                <option value="viewer">Viewer (Read-only)</option>
                <option value="editor">Editor (Can edit reports)</option>
                <option value="admin">Admin (Full access except delete company)</option>
                {currentUserRole === "owner" && <option value="owner">Owner (Full access)</option>}
              </select>
            </div>

            {/* Topic Access - only for Editor and Viewer */}
            {(newMemberRole === "editor" || newMemberRole === "viewer") && (
              <div>
                <label style={{ display: "block", marginBottom: spacing.xs, fontSize: fonts.size.sm, fontWeight: fonts.weight.semibold }}>
                  Topic Access
                </label>
                <select
                  value={newMemberAccessType}
                  onChange={(e) => {
                    const accessType = e.target.value as AccessType;
                    setNewMemberAccessType(accessType);
                    // Clear topic selections when switching to "all"
                    if (accessType === "all") {
                      setNewMemberTopics({});
                    }
                  }}
                  style={inputStyles.base}
                >
                  <option value="all">All Topics</option>
                  <option value="selected">Selected Topics Only</option>
                </select>
              </div>
            )}
            
            {/* Info text for Admin/Owner */}
            {(newMemberRole === "admin" || newMemberRole === "owner") && (
              <p style={{ fontSize: fonts.size.sm, color: colors.success, margin: 0 }}>
                ✓ This role will have full access to all topics
              </p>
            )}

            {/* Topic Selection for "selected" access type */}
            {(newMemberRole === "editor" || newMemberRole === "viewer") && newMemberAccessType === "selected" && (
              <div style={{ 
                border: `2px solid ${colors.borderGray}`, 
                borderRadius: "6px", 
                padding: spacing.md,
                backgroundColor: colors.white,
                maxHeight: "300px",
                overflowY: "auto"
              }}>
                <h4 style={{ margin: `0 0 ${spacing.sm} 0`, fontSize: fonts.size.sm, fontWeight: fonts.weight.bold }}>
                  📋 Select Topics & Permissions
                </h4>
                {topics.length === 0 ? (
                  <p style={{ color: colors.textSecondary, fontSize: fonts.size.sm }}>No topics available</p>
                ) : (
                  topics.map((topic) => {
                    const perms = newMemberTopics[topic.id] || { view: false, edit: false };
                    return (
                      <div
                        key={topic.id}
                        style={{
                          display: "flex",
                          alignItems: "center",
                          gap: spacing.md,
                          padding: spacing.sm,
                          borderBottom: `1px solid ${colors.borderGray}`,
                        }}
                      >
                        <span style={{ flex: 1, fontSize: fonts.size.sm }}>
                          <strong>{topic.code}</strong> - {topic.name}
                        </span>
                        <label style={{ fontSize: fonts.size.sm, display: "flex", alignItems: "center", gap: spacing.xs }}>
                          <input
                            type="checkbox"
                            checked={perms.view}
                            onChange={(e) => {
                              const newPerms = { ...perms, view: e.target.checked };
                              // If unchecking view, also uncheck edit
                              if (!e.target.checked) newPerms.edit = false;
                              setNewMemberTopics({ ...newMemberTopics, [topic.id]: newPerms });
                            }}
                          />
                          Allow
                        </label>
                        {newMemberRole === "editor" && (
                          <label style={{ fontSize: fonts.size.sm, display: "flex", alignItems: "center", gap: spacing.xs }}>
                            <input
                              type="checkbox"
                              checked={perms.edit}
                              onChange={(e) => {
                                const newPerms = { ...perms, edit: e.target.checked };
                                // If checking edit, also check view
                                if (e.target.checked) newPerms.view = true;
                                setNewMemberTopics({ ...newMemberTopics, [topic.id]: newPerms });
                              }}
                            />
                            Edit
                          </label>
                        )}
                      </div>
                    );
                  })
                )}
              </div>
            )}

            <button
              onClick={handleAddMember}
              disabled={loading || !newMemberEmail.trim()}
              style={{
                ...buttonStyles.primary,
                opacity: loading || !newMemberEmail.trim() ? 0.5 : 1,
              }}
            >
              {loading ? "Adding..." : "Add Member"}
            </button>
          </div>
        </div>
      )}

      {/* Members List */}
      {members.length === 0 ? (
        <p style={{ color: colors.textSecondary }}>No members yet.</p>
      ) : (
        <div style={{ display: "grid", gap: spacing.md }}>
          {members.map((member) => {
            // Role colors
            const roleColor = 
              member.role === "owner" ? "#0066cc" :
              member.role === "admin" ? "#8b5cf6" :
              member.role === "editor" ? "#06b6d4" :
              "#64748b";
            
            const roleBgColor = 
              member.role === "owner" ? "#e6f0ff" :
              member.role === "admin" ? "#f3e8ff" :
              member.role === "editor" ? "#e0f7fa" :
              "#f1f5f9";

            return (
              <div
                key={member.id}
                style={{
                  border: `2px solid ${roleBgColor}`,
                  borderRadius: "8px",
                  padding: spacing.md,
                  backgroundColor: roleBgColor,
                }}
              >
                <div style={{ display: "flex", justifyContent: "space-between", alignItems: "start", marginBottom: spacing.sm }}>
                  <div style={{ flex: 1 }}>
                    {/* Email and Role Badge */}
                    <div style={{ display: "flex", alignItems: "center", gap: spacing.sm, marginBottom: spacing.xs }}>
                      <div style={{ display: "flex", alignItems: "center", gap: spacing.xs }}>
                        <span style={{ fontSize: "20px" }}>👤</span>
                        <span style={{ fontSize: fonts.size.md, fontWeight: fonts.weight.bold, color: colors.textPrimary }}>
                          {member.user_email || "Unknown User"}
                        </span>
                      </div>
                      <span
                        style={{
                          padding: `${spacing.xs} ${spacing.sm}`,
                          backgroundColor: roleColor,
                          color: colors.white,
                          borderRadius: "6px",
                          fontSize: fonts.size.xs,
                          fontWeight: fonts.weight.bold,
                          textTransform: "uppercase",
                          letterSpacing: "0.5px",
                        }}
                      >
                        {member.role}
                      </span>
                    </div>

                    {/* Access Type Info */}
                    {(member.role === "owner" || member.role === "admin") ? (
                      <p style={{ margin: `${spacing.xs} 0 0 28px`, fontSize: fonts.size.sm, color: colors.success }}>
                        ✓ Full access to all topics
                      </p>
                    ) : (
                      <p style={{ margin: `${spacing.xs} 0 0 28px`, fontSize: fonts.size.sm, color: colors.textSecondary }}>
                        Access: <strong>{member.access_type === "all" ? "All Topics" : "Selected Topics Only"}</strong>
                      </p>
                    )}

                    {/* Role Selector */}
                    {canManage && member.role !== "owner" && (
                      <div style={{ marginTop: spacing.sm, marginLeft: "28px" }}>
                        <label style={{ fontSize: fonts.size.sm, color: colors.textSecondary, marginRight: spacing.sm }}>
                          Change Role:
                        </label>
                        <select
                          value={member.role}
                          onChange={(e) => handleUpdateMemberRole(member.id, e.target.value as Role)}
                          disabled={loading}
                          style={{
                            ...inputStyles.base,
                            padding: `${spacing.xs} ${spacing.sm}`,
                            fontSize: fonts.size.sm,
                            backgroundColor: colors.white,
                          }}
                        >
                          <option value="viewer">Viewer</option>
                          <option value="editor">Editor</option>
                          <option value="admin">Admin</option>
                        </select>
                      </div>
                    )}

                    {/* Access Type Selector */}
                    {canManage && (member.role === "editor" || member.role === "viewer") && (
                      <div style={{ marginTop: spacing.sm, marginLeft: "28px" }}>
                        <label style={{ fontSize: fonts.size.sm, color: colors.textSecondary, marginRight: spacing.sm }}>
                          Topic Access:
                        </label>
                        <select
                          value={member.access_type}
                          onChange={(e) => handleUpdateAccessType(member.id, e.target.value as AccessType)}
                          disabled={loading}
                          style={{
                            ...inputStyles.base,
                            padding: `${spacing.xs} ${spacing.sm}`,
                            fontSize: fonts.size.sm,
                            backgroundColor: colors.white,
                          }}
                        >
                          <option value="all">All Topics</option>
                          <option value="selected">Selected Topics Only</option>
                        </select>
                      </div>
                    )}

                    {/* Topic Access Manager */}
                    {member.access_type === "selected" && canManage && (member.role === "editor" || member.role === "viewer") && (
                      <div style={{ marginTop: spacing.md, marginLeft: "28px" }}>
                        {editingMemberId === member.id ? (
                          <>
                            <button
                              onClick={() => setEditingMemberId(null)}
                              style={{
                                ...buttonStyles.secondary,
                                padding: `${spacing.xs} ${spacing.sm}`,
                                fontSize: fonts.size.sm,
                                backgroundColor: colors.white,
                              }}
                            >
                              ✕ Close Topic Access
                            </button>
                            <div style={{ marginTop: spacing.sm, maxHeight: "300px", overflowY: "auto", backgroundColor: colors.white, padding: spacing.sm, borderRadius: "6px", border: `2px solid ${colors.borderGray}` }}>
                              <h4 style={{ margin: `0 0 ${spacing.sm} 0`, fontSize: fonts.size.sm, fontWeight: fonts.weight.bold, color: colors.textPrimary }}>
                                📋 Select Topics & Permissions
                              </h4>
                              {topics.map((topic) => {
                                const access = memberTopicAccess.find((ta) => ta.topic_id === topic.id);
                                return (
                                <div
                                  key={topic.id}
                                  style={{
                                    display: "flex",
                                    alignItems: "center",
                                    gap: spacing.md,
                                    padding: spacing.sm,
                                    borderBottom: `1px solid ${colors.borderGray}`,
                                  }}
                                >
                                  <span style={{ flex: 1, fontSize: fonts.size.sm }}>
                                    <strong>{topic.code}</strong> - {topic.name}
                                  </span>
                                  <label style={{ fontSize: fonts.size.sm, display: "flex", alignItems: "center", gap: spacing.xs }}>
                                    <input
                                      type="checkbox"
                                      checked={access?.can_view || false}
                                      onChange={() => handleToggleTopicAccess(member.id, topic.id, "view")}
                                    />
                                    Allow
                                  </label>
                                  {member.role === "editor" && (
                                    <label style={{ fontSize: fonts.size.sm, display: "flex", alignItems: "center", gap: spacing.xs }}>
                                      <input
                                        type="checkbox"
                                        checked={access?.can_edit || false}
                                        onChange={() => handleToggleTopicAccess(member.id, topic.id, "edit")}
                                      />
                                      Edit
                                    </label>
                                  )}
                                </div>
                              );
                            })}
                          </div>
                        </>
                      ) : (
                        <button
                          onClick={() => {
                            setEditingMemberId(member.id);
                            loadMemberTopicAccess(member.id);
                          }}
                          style={{
                            ...buttonStyles.secondary,
                            padding: `${spacing.xs} ${spacing.sm}`,
                            fontSize: fonts.size.sm,
                            backgroundColor: colors.white,
                          }}
                        >
                          ⚙️ Manage Topic Access
                        </button>
                      )}
                    </div>
                  )}
                  </div>

                  {/* Remove Button */}
                  {canManage && member.role !== "owner" && (
                    <button
                      onClick={() => handleRemoveMember(member.id)}
                      disabled={loading}
                      style={{
                        ...buttonStyles.danger,
                        padding: `${spacing.xs} ${spacing.sm}`,
                        fontSize: fonts.size.sm,
                      }}
                    >
                      Remove
                    </button>
                  )}
                </div>
              </div>
            );
          })}
        </div>
      )}
    </div>
  );
}
