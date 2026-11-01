const bcrypt = require('bcryptjs');
const { query } = require('./lib/db');
const { parseBody, sendResponse } = require('./lib/helpers');
const { enforceCsrfProtection } = require('./lib/csrf');

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
        const fullName = (body.fullName || '').trim();
        const username = (body.username || '').trim();
        const email = (body.email || '').trim();
        const phone = (body.phone || '').trim();
        const password = body.password || '';
        const confirmPassword = body.confirmPassword || '';
        const experienceLevel = (body.experienceLevel || 'Beginner').trim();

        if (!fullName || !username || !email || !password || !confirmPassword) {
            return sendResponse(req, res, {
                status: 400,
                redirect: '/register.html?error=All+required+fields+must+be+filled',
                json: { success: false, message: 'All required fields must be filled' }
            });
        }

        const emailRegex = /^[\w._%+-]+@[\w.-]+\.[a-zA-Z]{2,}$/;
        if (!emailRegex.test(email)) {
            return sendResponse(req, res, {
                status: 400,
                redirect: '/register.html?error=Invalid+email+format',
                json: { success: false, message: 'Invalid email format' }
            });
        }

        if (password.length < 6) {
            return sendResponse(req, res, {
                status: 400,
                redirect: '/register.html?error=Password+must+be+at+least+6+characters',
                json: { success: false, message: 'Password must be at least 6 characters' }
            });
        }

        if (password !== confirmPassword) {
            return sendResponse(req, res, {
                status: 400,
                redirect: '/register.html?error=Passwords+do+not+match',
                json: { success: false, message: 'Passwords do not match' }
            });
        }

        // Duplicate username or email check
        const checkResult = await query(
            'SELECT COUNT(*) AS cnt FROM users WHERE username = @username OR email = @email',
            { username, email }
        );

        if (checkResult.recordset[0].cnt > 0) {
            return sendResponse(req, res, {
                status: 409,
                redirect: '/register.html?error=Username+or+email+already+exists',
                json: { success: false, message: 'Username or email already exists' }
            });
        }

        // Hash password securely with bcrypt
        const passwordHash = bcrypt.hashSync(password, 10);

        // Security: is_admin is strictly hardcoded to 0
        await query(
            `INSERT INTO users (full_name, username, email, phone, password_hash, experience_level, is_admin, created_at)
             VALUES (@fullName, @username, @email, @phone, @passwordHash, @experienceLevel, 0, GETDATE())`,
            { fullName, username, email, phone, passwordHash, experienceLevel }
        );

        return sendResponse(req, res, {
            status: 201,
            redirect: '/login.html?registered=true',
            json: { success: true, message: 'Registration successful! You may now login.' }
        });

    } catch (err) {
        console.error('Registration error:', err);
        return sendResponse(req, res, {
            status: 500,
            redirect: '/register.html?error=Registration+failed.+Please+try+again',
            json: { success: false, message: 'Registration failed due to a database error' }
        });
    }
};
