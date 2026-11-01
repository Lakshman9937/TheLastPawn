const crypto = require('crypto');
const path = require('path');
const fs = require('fs');

// Attempt to load .env if present and environment variables not yet set
const envPath = path.resolve(process.cwd(), '.env');
if (fs.existsSync(envPath)) {
    const lines = fs.readFileSync(envPath, 'utf-8').split('\n');
    for (const line of lines) {
        const trimmed = line.trim();
        if (trimmed && !trimmed.startsWith('#') && trimmed.includes('=')) {
            const [k, ...v] = trimmed.split('=');
            const key = k.trim();
            const val = v.join('=').trim();
            if (!process.env[key]) {
                process.env[key] = val;
            }
        }
    }
}

function getSessionSecret() {
    const secret = process.env.SESSION_SECRET;
    if (!secret || secret.trim().length < 32) {
        throw new Error('FATAL SECURITY ERROR: SESSION_SECRET environment variable is not defined or is shorter than 32 characters. Configure SESSION_SECRET in environment variables.');
    }
    return secret.trim();
}

function base64UrlEncode(str) {
    return Buffer.from(str).toString('base64')
        .replace(/=/g, '')
        .replace(/\+/g, '-')
        .replace(/\//g, '_');
}

function base64UrlDecode(str) {
    str = str.replace(/-/g, '+').replace(/_/g, '/');
    while (str.length % 4) {
        str += '=';
    }
    return Buffer.from(str, 'base64').toString('utf8');
}

function createSessionToken(user) {
    const secret = getSessionSecret();
    const payload = JSON.stringify({
        userId: user.user_id || user.userId,
        username: user.username,
        fullName: user.full_name || user.fullName,
        isAdmin: !!(user.is_admin || user.isAdmin),
        iat: Date.now(),
        exp: Date.now() + (8 * 3600 * 1000) // 8 hours duration
    });

    const encodedPayload = base64UrlEncode(payload);
    const signature = crypto.createHmac('sha256', secret).update(encodedPayload).digest('base64url');
    return `${encodedPayload}.${signature}`;
}

function verifySessionToken(token) {
    if (!token || typeof token !== 'string' || !token.includes('.')) {
        return null;
    }

    const [encodedPayload, signature] = token.split('.');
    if (!encodedPayload || !signature) {
        return null;
    }

    const secret = getSessionSecret();
    const expectedSig = crypto.createHmac('sha256', secret).update(encodedPayload).digest('base64url');
    try {
        if (!crypto.timingSafeEqual(Buffer.from(signature), Buffer.from(expectedSig))) {
            return null; // Tampered token
        }
    } catch {
        return null;
    }

    try {
        const payload = JSON.parse(base64UrlDecode(encodedPayload));
        if (!payload.exp || Date.now() > payload.exp) {
            return null; // Expired token
        }
        return payload;
    } catch {
        return null;
    }
}

function getSessionUser(req) {
    // 1. Check Cookie
    const cookieHeader = req.headers['cookie'] || '';
    const match = cookieHeader.match(/chess_session=([^;]+)/);
    if (match && match[1]) {
        const user = verifySessionToken(match[1]);
        if (user) return user;
    }

    // 2. Check Authorization Header (Bearer token)
    const authHeader = req.headers['authorization'] || '';
    if (authHeader.startsWith('Bearer ')) {
        const token = authHeader.substring(7).trim();
        const user = verifySessionToken(token);
        if (user) return user;
    }

    return null;
}

function setSessionCookie(res, user, req) {
    const token = createSessionToken(user);
    const isProduction = process.env.NODE_ENV === 'production' || 
                         process.env.VERCEL === '1' ||
                         (req && (req.headers['x-forwarded-proto'] === 'https' || req.connection?.encrypted));
    const secureFlag = isProduction ? '; Secure' : '';
    res.setHeader('Set-Cookie', `chess_session=${token}; Path=/; HttpOnly; SameSite=Lax; Max-Age=28800${secureFlag}`);
    return token;
}

function clearSessionCookie(res) {
    res.setHeader('Set-Cookie', 'chess_session=; Path=/; HttpOnly; SameSite=Lax; Max-Age=0');
}

function requireAdmin(req, res) {
    const user = getSessionUser(req);
    if (!user || !user.isAdmin) {
        const wantsJson = (req.headers['accept'] || '').includes('application/json') ||
                          req.headers['x-requested-with'] === 'XMLHttpRequest';
        if (wantsJson) {
            res.statusCode = 403;
            res.setHeader('Content-Type', 'application/json');
            res.end(JSON.stringify({ success: false, error: 'Forbidden: Administrator authorization required' }));
        } else {
            res.statusCode = 302;
            res.setHeader('Location', '/login.html?error=Admin+access+required');
            res.end();
        }
        return null;
    }
    return user;
}

module.exports = {
    getSessionSecret,
    createSessionToken,
    verifySessionToken,
    getSessionUser,
    setSessionCookie,
    clearSessionCookie,
    requireAdmin
};
