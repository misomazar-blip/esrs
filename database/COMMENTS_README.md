# Comments Feature - Database Setup

## Prerequisites
You need to run the SQL migration to create the comments table before using the comments feature.

## Steps

### 1. Connect to your Supabase database
```bash
# Using psql
psql "postgresql://postgres:[YOUR-PASSWORD]@[YOUR-PROJECT-REF].supabase.co:5432/postgres"

# Or use Supabase SQL Editor in the dashboard
```

### 2. Run the migration
Execute the SQL file:
```bash
psql "postgresql://postgres:[YOUR-PASSWORD]@[YOUR-PROJECT-REF].supabase.co:5432/postgres" < database/create_comments.sql
```

Or copy and paste the contents of `database/create_comments.sql` into the Supabase SQL Editor.

## What this creates

### Tables
- `question_comment` - Main comments table with support for nested replies (threaded comments)
  - `id` - UUID primary key
  - `question_id` - Reference to the question being commented on
  - `report_id` - Reference to the report (for access control)
  - `user_id` - Who wrote the comment
  - `parent_comment_id` - For threaded replies (NULL for top-level comments)
  - `comment_text` - The actual comment
  - `created_at`, `updated_at` - Timestamps
  - `is_edited` - Flag to show if comment was edited

### Views
- `question_comment_with_user` - Joins comments with user email for easier querying

### Security (RLS Policies)
- Users can only view/add comments for reports they have access to (via company ownership)
- Users can only edit/delete their own comments
- Threaded replies are supported (up to 3 levels deep in the UI)

### Triggers
- Auto-updates `updated_at` and sets `is_edited` flag when a comment is modified

## Features

### Comments System
✅ **Add Comments** - Any user with access to a report can comment on questions
✅ **Threaded Replies** - Reply to comments (up to 3 levels deep)
✅ **Edit Comments** - Users can edit their own comments
✅ **Delete Comments** - Users can delete their own comments
✅ **Timestamps** - Shows when comments were created/edited
✅ **User Attribution** - Shows who wrote each comment
✅ **Collapsible** - Comments section can be collapsed/expanded
✅ **Counter** - Shows total comment count including replies

### UI Features
- Avatar with user initial
- "Edited" indicator for modified comments
- Blue background for own comments
- Nested indentation for replies
- Edit/Delete buttons for own comments
- Reply button (max 3 levels)
- Real-time updates after actions

### Permissions
All roles (Owner, Editor, Contributor, Viewer) can:
- View comments
- Add comments
- Reply to comments
- Edit their own comments
- Delete their own comments

Access is controlled at the report level - users can only comment on questions in reports they have access to.
