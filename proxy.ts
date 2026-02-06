import { NextRequest, NextResponse } from "next/server";
import { updateSession } from "./lib/supabase/middleware";
import createIntlMiddleware from 'next-intl/middleware';
import { locales, defaultLocale } from './i18n/config';

// Create the internationalization middleware
const intlMiddleware = createIntlMiddleware({
  locales,
  defaultLocale,
  localePrefix: 'always'
});

export async function proxy(request: NextRequest) {
  const { pathname } = request.nextUrl;
  
  // Skip locale handling for API routes and auth callback
  if (pathname.startsWith('/api') || pathname.startsWith('/auth')) {
    return updateSession(request);
  }

  // First, handle authentication
  const authResponse = await updateSession(request);
  
  // If auth middleware returned a redirect, use it
  if (authResponse.status === 307 || authResponse.status === 308) {
    return authResponse;
  }

  // Then handle internationalization (only if not already on a locale path)
  if (!pathname.match(/^\/(sk|en)(\/|$)/)) {
    const intlResponse = intlMiddleware(request);
    
    // If intl middleware returned a redirect, use it
    if (intlResponse && (intlResponse.status === 307 || intlResponse.status === 308)) {
      return intlResponse;
    }
  }

  // Otherwise return the auth response (which includes session cookies)
  return authResponse;
}

export const config = {
  matcher: [
    "/((?!_next/static|_next/image|favicon.ico|.*\\.(?:svg|png|jpg|jpeg|gif|webp|ico|css|js|map)$).*)",
  ],
};
