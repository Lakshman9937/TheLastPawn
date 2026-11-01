const crypto = require('crypto');

/**
 * Validates request origin to prevent Cross-Site Request Forgery (CSRF).
 * Checks Sec-Fetch-Site, Origin, and Referer headers against the Host header.
 */
function validateOrigin(req) {
    // Read headers
    const secFetchSite = req.headers['sec-fetch-site'];
    const origin = req.headers['origin'];
    const referer = req.headers['referer'];
    const host = req.headers['host'];

    // 1. Check Sec-Fetch-Site (modern browsers)
    if (secFetchSite && secFetchSite === 'cross-site') {
        return false;
    }

    // 2. If Origin header is present, it must match the expected host
    if (origin) {
        try {
            const originUrl = new URL(origin);
            if (originUrl.host !== host) {
                // Allow localhost testing on alternate ports if needed
                if (!host.startsWith('localhost') || !originUrl.host.startsWith('localhost')) {
                    return false;
                }
            }
        } catch {
            return false;
        }
    }

    // 3. If Referer header is present and no Origin was provided, verify Referer
    if (!origin && referer) {
        try {
            const refererUrl = new URL(referer);
            if (refererUrl.host !== host) {
                if (!host.startsWith('localhost') || !refererUrl.host.startsWith('localhost')) {
                    return false;
                }
            }
        } catch {
            return false;
        }
    }

    return true;
}

/**
 * Generates an HMAC-signed CSRF token tied to a session or random salt
 */
function generateCsrfToken(secret) {
    const salt = crypto.randomBytes(16).toString('hex');
    const hmac = crypto.createHmac('sha256', secret).update(salt).digest('hex');
    return `${salt}:${hmac}`;
}

/**
 * Verifies a CSRF token
 */
function verifyCsrfToken(token, secret) {
    if (!token || !token.includes(':')) return false;
    const [salt, hmac] = token.split(':');
    const expected = crypto.createHmac('sha256', secret).update(salt).digest('hex');
    try {
        return crypto.timingSafeEqual(Buffer.from(hmac), Buffer.from(expected));
    } catch {
        return false;
    }
}

/**
 * Middleware function that rejects cross-origin state changes
 */
function enforceCsrfProtection(req, res) {
    // Only state-changing methods need CSRF protection
    const stateChangingMethods = ['POST', 'PUT', 'DELETE', 'PATCH'];
    if (!stateChangingMethods.includes(req.method.toUpperCase())) {
        return true;
    }

    if (!validateOrigin(req)) {
        res.statusCode = 403;
        res.setHeader('Content-Type', 'application/json');
        res.end(JSON.stringify({
            success: false,
            error: 'Forbidden: Cross-site request forgery (CSRF) validation failed'
        }));
        return false;
    }

    return true;
}

module.exports = {
    validateOrigin,
    generateCsrfToken,
    verifyCsrfToken,
    enforceCsrfProtection
};
