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
        const senderName = (body.senderName || body.name || '').trim();
        const senderEmail = (body.senderEmail || body.email || '').trim();
        const subject = (body.subject || 'General Inquiry').trim();
        const message = (body.message || '').trim();

        if (!senderName || !senderEmail || !message) {
            return sendResponse(req, res, {
                status: 400,
                redirect: '/contact.html?error=Please+complete+all+required+fields',
                json: { success: false, message: 'Please complete all required fields' }
            });
        }

        await query(
            `INSERT INTO contact_messages (sender_name, sender_email, subject, message, received_at, submitted_at, is_read)
             VALUES (@senderName, @senderEmail, @subject, @message, GETDATE(), GETDATE(), 0)`,
            { senderName, senderEmail, subject, message }
        );

        return sendResponse(req, res, {
            status: 200,
            redirect: '/contact.html?success=true',
            json: { success: true, message: 'Thank you! Your message has been sent successfully.' }
        });

    } catch (err) {
        console.error('Contact form submission error:', err);
        return sendResponse(req, res, {
            status: 500,
            redirect: '/contact.html?error=Server+database+error.+Please+try+again',
            json: { success: false, message: 'Server database error' }
        });
    }
};
