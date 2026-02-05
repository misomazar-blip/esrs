# Attachments System Setup Guide

## Prerequisites
- Supabase project with authentication enabled
- Database access (SQL Editor or psql)
- Storage access

## Step 1: Run Database Migration

1. Open Supabase Dashboard → SQL Editor
2. Copy contents from `create_attachments.sql`
3. Execute the SQL script

This creates:
- `question_attachment` table with proper constraints
- Indexes for performance (question_id, report_id, user_id, created_at)
- RLS policies for security
- Trigger for auto-updating timestamps
- View `question_attachment_with_user` with user email

## Step 2: Create Storage Bucket

### Option A: Via Supabase Dashboard
1. Go to Storage in Supabase Dashboard
2. Click "Create bucket"
3. Configure:
   - **Name**: `question-attachments`
   - **Public**: ❌ NO (keep private)
   - **File size limit**: 10MB
   - **Allowed MIME types**: 
     - `image/*`
     - `application/pdf`
     - `application/vnd.*`
     - `text/*`
     - Custom: `.xlsx`, `.docx`, `.csv`

### Option B: Via SQL
```sql
-- Create bucket
INSERT INTO storage.buckets (id, name, public)
VALUES ('question-attachments', 'question-attachments', false);

-- Add storage policies
CREATE POLICY "Users can upload attachments to their company reports"
ON storage.objects FOR INSERT
WITH CHECK (
  bucket_id = 'question-attachments'
  AND auth.uid()::text = (storage.foldername(name))[1]
);

CREATE POLICY "Users can view attachments from their company reports"
ON storage.objects FOR SELECT
USING (
  bucket_id = 'question-attachments'
  AND EXISTS (
    SELECT 1 FROM question_attachment qa
    INNER JOIN report r ON qa.report_id = r.id
    INNER JOIN company c ON r.company_id = c.id
    WHERE qa.storage_path = name
    AND c.user_id = auth.uid()
  )
);

CREATE POLICY "Users can delete their own attachments"
ON storage.objects FOR DELETE
USING (
  bucket_id = 'question-attachments'
  AND auth.uid()::text = (storage.foldername(name))[1]
);
```

## Step 3: Verify Setup

Test the following:

1. **Upload**: Go to topics page → click "Choose File" → select file → upload
2. **View**: Uploaded files appear in list with file icon, name, size, timestamp
3. **Preview**: Click "👁️ Preview" on images to see full-size preview
4. **Download**: Click "⬇️ Download" to download any file
5. **Delete**: Click "🗑️ Delete" (only on your own files)

## Features

### File Types Supported
- **Images**: JPG, PNG, GIF, WebP
- **Documents**: PDF, Word (.doc, .docx)
- **Spreadsheets**: Excel (.xls, .xlsx), CSV
- **Presentations**: PowerPoint (.ppt, .pptx)
- **Text**: TXT, CSV

### Size Limit
- Maximum: 10MB per file
- Validation happens both client-side and server-side

### Security
- **RLS Policies**: Users can only access attachments from their company's reports
- **Private Storage**: All files stored in private bucket with signed URLs
- **Delete Protection**: Users can only delete their own attachments
- **Ownership Indicators**: Blue background for your attachments

### File Structure in Storage
```
question-attachments/
  {report-id}/
    {question-id}/
      {timestamp}_{sanitized-filename}
```

## Troubleshooting

### Upload fails with "Access denied"
- Check RLS policies on `question_attachment` table
- Verify user has access to the report (via company ownership)

### Storage error
- Ensure `question-attachments` bucket exists
- Check storage policies
- Verify bucket is private (public = false)

### Preview not working
- Check browser console for errors
- Verify signed URL generation works
- Ensure storage policies allow SELECT

### Files not appearing
- Check database: `SELECT * FROM question_attachment;`
- Verify storage bucket has files: Supabase Dashboard → Storage
- Check RLS policies allow SELECT for current user

## Database Schema

```sql
question_attachment (
  id UUID PRIMARY KEY,
  question_id UUID → disclosure_question(id),
  report_id UUID → report(id),
  user_id UUID → auth.users(id),
  file_name TEXT,
  file_size BIGINT, -- bytes
  file_type TEXT, -- MIME type
  storage_path TEXT, -- bucket path
  description TEXT,
  created_at TIMESTAMPTZ,
  updated_at TIMESTAMPTZ
)
```

## Component Props

```typescript
<QuestionAttachments
  questionId={string}     // UUID of question
  reportId={string}       // UUID of report
  currentUserEmail={string} // For ownership check
/>
```

## API Endpoints

### POST /api/attachments
Upload new attachment

**FormData:**
- `file`: File object
- `questionId`: UUID
- `reportId`: UUID
- `description`: string (optional)

**Response:**
```json
{
  "attachment": {
    "id": "uuid",
    "file_name": "document.pdf",
    "file_size": 1234567,
    ...
  }
}
```

### DELETE /api/attachments?attachmentId={uuid}
Delete attachment

**Response:**
```json
{ "success": true }
```

## Next Steps

After setup, consider:
- Adding drag-and-drop upload
- Implementing file versioning
- Adding bulk download (ZIP all attachments for question/report)
- OCR for scanned documents
- Thumbnail generation for images
