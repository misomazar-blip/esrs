/**
 * Access Control Management
 * Handles role-based access control (RBAC) with granular topic-level permissions
 */

import { createSupabaseBrowserClient } from "@/lib/supabase/client";
import { SupabaseClient } from "@supabase/supabase-js";

// =====================================================
// TYPES
// =====================================================

export type Role = "owner" | "admin" | "editor" | "viewer";
export type AccessType = "all" | "selected";

export interface CompanyMember {
  id: string;
  company_id: string;
  user_id: string;
  role: Role;
  access_type: AccessType;
  invited_by: string | null;
  invited_at: string;
  created_at: string;
  user_email?: string; // Joined from auth.users
  user_name?: string;
}

export interface TopicAccess {
  id: string;
  company_member_id: string;
  topic_id: string;
  can_view: boolean;
  can_edit: boolean;
  created_at: string;
  topic_code?: string; // Joined from topic
  topic_name?: string;
}

export interface MemberWithTopicAccess extends CompanyMember {
  topic_access: TopicAccess[];
}

// =====================================================
// PERMISSION HELPERS
// =====================================================

export const RolePermissions = {
  owner: {
    canManageMembers: true,
    canManageTopicAccess: true,
    canEditAllTopics: true,
    canViewAllTopics: true,
    canDeleteCompany: true,
    canCreateReports: true,
  },
  admin: {
    canManageMembers: true,
    canManageTopicAccess: true,
    canEditAllTopics: true,
    canViewAllTopics: true,
    canDeleteCompany: false,
    canCreateReports: true,
  },
  editor: {
    canManageMembers: false,
    canManageTopicAccess: false,
    canEditAllTopics: false, // Depends on access_type
    canViewAllTopics: false, // Depends on access_type
    canDeleteCompany: false,
    canCreateReports: true,
  },
  viewer: {
    canManageMembers: false,
    canManageTopicAccess: false,
    canEditAllTopics: false,
    canViewAllTopics: false, // Depends on access_type
    canDeleteCompany: false,
    canCreateReports: false,
  },
} as const;

// =====================================================
// ACCESS CONTROL CLASS
// =====================================================

export class AccessControl {
  private supabase: SupabaseClient;

  constructor(supabaseClient?: SupabaseClient) {
    this.supabase = supabaseClient || createSupabaseBrowserClient();
  }

  /**
   * Get current user's role in a company
   */
  async getUserRole(companyId: string): Promise<Role | null> {
    const { data: { user } } = await this.supabase.auth.getUser();
    if (!user) return null;

    const { data, error } = await this.supabase
      .from("company_member")
      .select("role")
      .eq("company_id", companyId)
      .eq("user_id", user.id)
      .maybeSingle();

    if (error || !data) return null;
    return data.role as Role;
  }

  /**
   * Get current user's company membership details
   */
  async getUserMembership(companyId: string): Promise<CompanyMember | null> {
    const { data: { user } } = await this.supabase.auth.getUser();
    if (!user) return null;

    const { data, error } = await this.supabase
      .from("company_member")
      .select("*")
      .eq("company_id", companyId)
      .eq("user_id", user.id)
      .maybeSingle();

    if (error || !data) return null;
    return data as CompanyMember;
  }

  /**
   * Check if user has access to a company
   */
  async hasCompanyAccess(companyId: string): Promise<boolean> {
    const role = await this.getUserRole(companyId);
    return role !== null;
  }

  /**
   * Check if user can manage members (Owner or Admin)
   */
  async canManageMembers(companyId: string): Promise<boolean> {
    const role = await this.getUserRole(companyId);
    return role === "owner" || role === "admin";
  }

  /**
   * Check if user can view a specific topic
   */
  async canViewTopic(companyId: string, topicId: string): Promise<boolean> {
    const membership = await this.getUserMembership(companyId);
    if (!membership) return false;

    // Owners and Admins can view all
    if (membership.role === "owner" || membership.role === "admin") {
      return true;
    }

    // If access_type is 'all', can view all topics
    if (membership.access_type === "all") {
      return true;
    }

    // Check specific topic access
    const { data, error } = await this.supabase
      .from("company_member_topic_access")
      .select("can_view")
      .eq("company_member_id", membership.id)
      .eq("topic_id", topicId)
      .maybeSingle();

    if (error || !data) return false;
    return data.can_view;
  }

  /**
   * Check if user can edit a specific topic
   */
  async canEditTopic(companyId: string, topicId: string): Promise<boolean> {
    const membership = await this.getUserMembership(companyId);
    if (!membership) return false;

    // Viewers can't edit anything
    if (membership.role === "viewer") return false;

    // Owners and Admins can edit all
    if (membership.role === "owner" || membership.role === "admin") {
      return true;
    }

    // Editors with 'all' access can edit all
    if (membership.role === "editor" && membership.access_type === "all") {
      return true;
    }

    // Check specific topic access for editors with 'selected' access
    if (membership.role === "editor" && membership.access_type === "selected") {
      const { data, error } = await this.supabase
        .from("company_member_topic_access")
        .select("can_edit")
        .eq("company_member_id", membership.id)
        .eq("topic_id", topicId)
        .maybeSingle();

      if (error || !data) return false;
      return data.can_edit;
    }

    return false;
  }

  /**
   * Get all topics user can view
   */
  async getAccessibleTopics(companyId: string): Promise<string[]> {
    const membership = await this.getUserMembership(companyId);
    if (!membership) return [];

    // Owners and Admins can access all topics
    if (membership.role === "owner" || membership.role === "admin" || membership.access_type === "all") {
      const { data, error } = await this.supabase
        .from("topic")
        .select("id");

      if (error || !data) return [];
      return data.map((t: any) => t.id);
    }

    // Get specific topics for 'selected' access
    const { data, error } = await this.supabase
      .from("company_member_topic_access")
      .select("topic_id")
      .eq("company_member_id", membership.id)
      .eq("can_view", true);

    if (error || !data) return [];
    return data.map((t: any) => t.topic_id);
  }

  /**
   * Get all company members with their topic access
   */
  async getCompanyMembers(companyId: string): Promise<MemberWithTopicAccess[]> {
    const { data: members, error: membersError } = await this.supabase
      .from("company_member")
      .select("*")
      .eq("company_id", companyId)
      .order("created_at", { ascending: true });

    if (membersError || !members) return [];

    // Get topic access for each member
    const membersWithAccess = await Promise.all(
      members.map(async (member) => {
        const { data: topicAccess } = await this.supabase
          .from("company_member_topic_access")
          .select(`
            *,
            topic:topic_id (code, name)
          `)
          .eq("company_member_id", member.id);

        return {
          ...member,
          topic_access: topicAccess || [],
        } as MemberWithTopicAccess;
      })
    );

    return membersWithAccess;
  }

  /**
   * Add a new member to a company (sends invite email if user doesn't exist)
   */
  async addMember(
    companyId: string,
    userEmail: string,
    role: Role,
    accessType: AccessType = "all"
  ): Promise<{ success: boolean; error?: string; data?: any; invited?: boolean }> {
    try {
      // Call API route to handle invite (server-side with admin access)
      const response = await fetch('/api/company/invite-member', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          email: userEmail,
          companyId,
          role,
          accessType,
        }),
      });

      const result = await response.json();

      if (!response.ok) {
        return { success: false, error: result.error || 'Failed to add member' };
      }

      return {
        success: true,
        data: result.data,
        invited: result.invited, // true if invite email was sent
      };
    } catch (error: any) {
      return { success: false, error: error.message || 'Failed to add member' };
    }
  }

  /**
   * Update member's role or access type
   */
  async updateMember(
    memberId: string,
    updates: { role?: Role; access_type?: AccessType }
  ): Promise<{ success: boolean; error?: string }> {
    const { error } = await this.supabase
      .from("company_member")
      .update(updates)
      .eq("id", memberId);

    if (error) {
      return { success: false, error: error.message };
    }

    return { success: true };
  }

  /**
   * Remove a member from a company
   */
  async removeMember(memberId: string): Promise<{ success: boolean; error?: string }> {
    const { error } = await this.supabase
      .from("company_member")
      .delete()
      .eq("id", memberId);

    if (error) {
      return { success: false, error: error.message };
    }

    return { success: true };
  }

  /**
   * Set topic access for a member
   */
  async setTopicAccess(
    memberId: string,
    topicId: string,
    canView: boolean,
    canEdit: boolean
  ): Promise<{ success: boolean; error?: string }> {
    const { error } = await this.supabase
      .from("company_member_topic_access")
      .upsert({
        company_member_id: memberId,
        topic_id: topicId,
        can_view: canView,
        can_edit: canEdit,
      }, {
        onConflict: "company_member_id,topic_id",
      });

    if (error) {
      return { success: false, error: error.message };
    }

    return { success: true };
  }

  /**
   * Remove topic access for a member
   */
  async removeTopicAccess(
    memberId: string,
    topicId: string
  ): Promise<{ success: boolean; error?: string }> {
    const { error } = await this.supabase
      .from("company_member_topic_access")
      .delete()
      .eq("company_member_id", memberId)
      .eq("topic_id", topicId);

    if (error) {
      return { success: false, error: error.message };
    }

    return { success: true };
  }
}

// =====================================================
// EXPORT SINGLETON INSTANCE
// =====================================================

export const accessControl = new AccessControl();
