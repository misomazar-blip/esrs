import { NextRequest, NextResponse } from 'next/server';
import { getVsmeExportSnapshot } from '@/lib/vsme/getVsmeExportSnapshot';
import { renderVsmeHtml } from '@/lib/vsme/export/renderVsmeHtml';
import playwright from 'playwright';

export const runtime = 'nodejs';

export async function GET(req: NextRequest, { params }: { params: { id: string } }) {
  const reportId = params.id;
  try {
    const snapshot = await getVsmeExportSnapshot(reportId);
    const html = renderVsmeHtml({
      questions: snapshot.questions,
      answers: snapshot.answers,
      completion_pct: snapshot.completion_pct,
    });

    // Render PDF using Playwright
    const browser = await playwright.chromium.launch();
    const page = await browser.newPage();
    await page.setContent(html, { waitUntil: 'networkidle' });
    const pdfBuffer = await page.pdf({ format: 'A4' });
    await browser.close();

    return new NextResponse(pdfBuffer, {
      status: 200,
      headers: {
        'Content-Type': 'application/pdf',
        'Content-Disposition': `attachment; filename=vsme-report-${reportId}.pdf`,
      },
    });
  } catch (err: any) {
    return new NextResponse(`Export failed: ${err.message}`, { status: 500 });
  }
}
