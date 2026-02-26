import { NextRequest, NextResponse } from "next/server";
import { updateSession } from "./lib/supabase/middleware";
import createMiddleware from 'next-intl/middleware';
import { locales, defaultLocale } from './i18n/config';

// Let next-intl handle locale routing
const intlMiddleware = createMiddleware({
  locales,
  defaultLocale,
  localePrefix: 'always'
});

export async function proxy(request: NextRequest) {
  const { pathname, search } = request.nextUrl;

  // TEMP: Debug logging
  console.log("[PROXY] IN", pathname, search);
  
  // Skip middleware for API routes and auth callback
  if (pathname.startsWith('/api') || pathname.startsWith('/auth')) {
    console.log("[PROXY] SKIP api/auth, calling updateSession");
    const result = await updateSession(request);
    console.log("[PROXY] NEXT (api/auth) status:", result.status);
    return result;
  }

  // First, let next-intl handle locale routing
  const intlResponse = intlMiddleware(request);
  
  // Check if next-intl wants to redirect
  if (intlResponse.status === 307 || intlResponse.status === 308) {
    const location = intlResponse.headers.get('location');
    if (location) {
      const redirectUrl = new URL(location, request.url);

      for (const [key, value] of request.nextUrl.searchParams) {
        redirectUrl.searchParams.set(key, value);
      }

      console.log("[PROXY] REDIRECT (intl) to:", redirectUrl.pathname + redirectUrl.search);
      const response = NextResponse.redirect(redirectUrl, { status: intlResponse.status });

      // Copy cookies from intl response
      intlResponse.headers.forEach((value, key) => {
        if (key.toLowerCase() === 'set-cookie') {
          response.headers.set(key, value);
        }
      });

      return response;
    }
  }

  // Then handle auth with the request (locale is already set by next-intl)
  console.log("[PROXY] Calling updateSession");
  const authResponse = await updateSession(request);

  console.log("[PROXY] Auth status:", authResponse.status);
  
  // If auth middleware returned a redirect, preserve search params
  if (authResponse.status === 307 || authResponse.status === 308) {
    const location = authResponse.headers.get('location');
    console.log("[PROXY] Auth wants redirect to:", location);
    if (location) {
      const redirectUrl = new URL(location, request.url);

      for (const [key, value] of request.nextUrl.searchParams) {
        redirectUrl.searchParams.set(key, value);
      }

      console.log("[PROXY] REDIRECT (auth) to:", redirectUrl.pathname + redirectUrl.search);
      return NextResponse.redirect(redirectUrl, { status: authResponse.status });
    }
    console.log("[PROXY] RETURN (auth redirect, no location)");
    return authResponse;
  }

  // Merge intl response (locale cookies, etc.) with auth response
  console.log("[PROXY] NEXT (continue)");
  const response = NextResponse.next({ request });
  
  // Copy headers from both intl and auth responses
  intlResponse.headers.forEach((value, key) => {
    if (key.toLowerCase() === 'set-cookie') {
      response.headers.append(key, value);
    }
  });
  
  authResponse.headers.forEach((value, key) => {
    if (key.toLowerCase() === 'set-cookie') {
      response.headers.append(key, value);
    }
  });

  return response;
}

export const config = {
  matcher: [
    /*
     * Match all request paths except:
     * - _next/static (static files)
     * - _next/image (image optimization)
     * - favicon.ico, robots.txt, sitemap.xml (SEO files)
     * - files with extensions (images, css, js, etc.)
     */
    "/((?!_next/static|_next/image|favicon.ico|robots.txt|sitemap.xml|.*\\.(?:png|jpg|jpeg|gif|webp|svg|ico|css|js|map|woff|woff2|ttf|eot)$).*)",
  ],
};
