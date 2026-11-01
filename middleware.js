// Vercel Edge Middleware — Protects all /admin routes at the HTTP Edge
// This runs on Vercel's global edge network BEFORE any static file or page is served.

export const config = {
    matcher: ['/admin/:path*']
};

export default function middleware(request) {
    const url = new URL(request.url);
    const pathname = url.pathname.toLowerCase();

    // Allow static assets inside /admin if any (e.g., images/css)
    if (pathname.includes('/css/') || pathname.includes('/images/') || pathname.endsWith('.css') || pathname.endsWith('.js') || pathname.endsWith('.png') || pathname.endsWith('.jpg')) {
        return;
    }

    // Extract chess_session cookie
    const cookies = request.headers.get('cookie') || '';
    const match = cookies.match(/chess_session=([^;]+)/);
    const sessionToken = match ? match[1] : null;

    if (!sessionToken || !sessionToken.includes('.')) {
        const loginUrl = new URL('/login.html', request.url);
        loginUrl.searchParams.set('error', 'Admin access required');
        return Response.redirect(loginUrl, 302);
    }

    // Verify basic token structure and expiration at the Edge
    try {
        const [encodedPayload] = sessionToken.split('.');
        let base64 = encodedPayload.replace(/-/g, '+').replace(/_/g, '/');
        while (base64.length % 4) {
            base64 += '=';
        }
        const jsonStr = atob(base64);
        const payload = JSON.parse(jsonStr);

        if (!payload.isAdmin || (payload.exp && Date.now() > payload.exp)) {
            const loginUrl = new URL('/login.html', request.url);
            loginUrl.searchParams.set('error', 'Admin access required');
            return Response.redirect(loginUrl, 302);
        }
    } catch {
        const loginUrl = new URL('/login.html', request.url);
        loginUrl.searchParams.set('error', 'Admin access required');
        return Response.redirect(loginUrl, 302);
    }

    // Authorized administrator — continue to requested admin page
}
