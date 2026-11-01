const crypto = require('crypto');
const bcrypt = require('bcryptjs');
const { query } = require('../lib/db');
const { parseBody, sendResponse } = require('../lib/helpers');
const { setSessionCookie } = require('../lib/auth');
const { enforceCsrfProtection } = require('../lib/csrf');

function sha256(text) {
    return crypto.createHash('sha256').update(text, 'utf8').digest('hex');
}

module.exports = async function handler(req, res) {
    if (req.method !== 'POST') {
        return sendResponse(req, res, { status: 405, json: { error: 'Method not allowed' } });
    }

    // CSRF Protection
    if (!enforceCsrfProtection(req, res)) {
        return;
    }

    try {
        const body = await parseBody(req);
        const usernameOrEmail = (body.username || '').trim();
        const password = body.password || '';

        if (!usernameOrEmail || !password) {
            return sendResponse(req, res, {
                status: 400,
                redirect: '/login.html?error=Username+and+password+are+required',
                json: { success: false, message: 'Username and password are required' }
            });
        }

        const result = await query(
            'SELECT user_id, username, full_name, password_hash, is_admin FROM users WHERE username = @ident OR email = @ident',
            { ident: usernameOrEmail }
        );

        if (result.recordset.length === 0) {
            return sendResponse(req, res, {
                status: 401,
                redirect: '/login.html?error=Invalid+credentials',
                json: { success: false, message: 'Invalid credentials' }
            });
        }

        const user = result.recordset[0];
        const storedHash = user.password_hash || '';

        let isMatch = false;

        // Check if hash is bcrypt ($2a$, $2b$, $2y$)
        if (storedHash.startsWith('$2a$') || storedHash.startsWith('$2b$') || storedHash.startsWith('$2y$')) {
            isMatch = bcrypt.compareSync(password, storedHash);
        } else {
            // Check legacy SHA-256
            const sha = sha256(password);
            if (sha.toLowerCase() === storedHash.toLowerCase()) {
                isMatch = true;
                // Upgrade to bcrypt transparently
                try {
                    const newBcryptHash = bcrypt.hashSync(password, 10);
                    await query('UPDATE users SET password_hash = @hash WHERE user_id = @id', {
                        hash: newBcryptHash,
                        id: user.user_id
                    });
                } catch (upgradeErr) {
                    console.error('Password hash upgrade notice:', upgradeErr.message);
                }
            }
        }

        if (!isMatch) {
            return sendResponse(req, res, {
                status: 401,
                redirect: '/login.html?error=Invalid+credentials',
                json: { success: false, message: 'Invalid credentials' }
            });
        }

        // Authentication succeeded - generate cryptographically signed HMAC session token
        const token = setSessionCookie(res, user, req);

        const sessionData = {
            userId: user.user_id,
            username: user.username,
            fullName: user.full_name,
            isAdmin: !!user.is_admin
        };

        const destination = user.is_admin ? '/admin/dashboard.html' : '/index.html';
        return sendResponse(req, res, {
            status: 200,
            redirect: destination,
            json: { success: true, user: sessionData, token, redirectUrl: destination }
        });

    } catch (err) {
        console.error('Login error:', err);
        return sendResponse(req, res, {
            status: 500,
            redirect: '/login.html?error=Server+database+error',
            json: { success: false, message: 'Server database error' }
        });
    }
};
