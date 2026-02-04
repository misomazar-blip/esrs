import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@supabase/supabase-js";
import { createSupabaseServerClient } from "@/lib/supabase/server";

// Server-side Supabase client with service role (can access auth.admin)
const supabaseAdmin = createClient(
  process.env.NEXT_PUBLIC_SUPABASE_URL!,
  process.env.SUPABASE_SERVICE_ROLE_KEY!,
  {
    auth: {
      autoRefreshToken: false,
      persistSession: false,
    },
  }
);

export async function POST(request: NextRequest) {
  try {
    const { email, companyId, role, accessType } = await request.json();

    // Get current user using server client
    const supabase = await createSupabaseServerClient();
    const { data: { user }, error: authError } = await supabase.auth.getUser();
    if (authError || !user) {
      return NextResponse.json(
        { error: "Not authenticated" },
        { status: 401 }
      );
    }

    // Check if current user can manage members (is owner or admin)
    const { data: membership } = await supabase
      .from("company_member")
      .select("role")
      .eq("company_id", companyId)
      .eq("user_id", user.id)
      .single();

    if (!membership || (membership.role !== "owner" && membership.role !== "admin")) {
      return NextResponse.json(
        { error: "You don't have permission to add members" },
        { status: 403 }
      );
    }

    // Check if user already exists in auth.users
    const { data: existingUsers } = await supabaseAdmin.auth.admin.listUsers();
    const existingUser = existingUsers.users.find(u => u.email === email);

    let userId: string;

    if (existingUser) {
      // User already has account
      userId = existingUser.id;
      
      // Check if already a member
      const { data: existingMember } = await supabase
        .from("company_member")
        .select("id")
        .eq("company_id", companyId)
        .eq("user_id", userId)
        .maybeSingle();

      if (existingMember) {
        return NextResponse.json(
          { error: "User is already a member of this company" },
          { status: 400 }
        );
      }
    } else {
      // Invite new user via email
      const { data: inviteData, error: inviteError } = await supabaseAdmin.auth.admin.inviteUserByEmail(
        email,
        {
          redirectTo: `${process.env.NEXT_PUBLIC_SITE_URL || 'http://localhost:3000'}/auth/callback`,
        }
      );

      if (inviteError || !inviteData.user) {
        return NextResponse.json(
          { error: inviteError?.message || "Failed to send invite" },
          { status: 500 }
        );
      }

      userId = inviteData.user.id;
    }

    // Add member to company
    const { data: newMember, error: insertError } = await supabase
      .from("company_member")
      .insert({
        company_id: companyId,
        user_id: userId,
        role,
        access_type: accessType,
        invited_by: user.id,
        invited_at: new Date().toISOString(),
      })
      .select()
      .single();

    if (insertError) {
      return NextResponse.json(
        { error: insertError.message },
        { status: 500 }
      );
    }

    return NextResponse.json({
      success: true,
      data: newMember,
      invited: !existingUser, // Whether an invite email was sent
    });

  } catch (error: any) {
    console.error("Invite member error:", error);
    return NextResponse.json(
      { error: error.message || "Internal server error" },
      { status: 500 }
    );
  }
}
