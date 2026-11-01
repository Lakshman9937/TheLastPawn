const { query } = require('../lib/db');
const { parseBody, sendResponse } = require('../lib/helpers');
const { requireAdmin } = require('../lib/auth');
const { enforceCsrfProtection } = require('../lib/csrf');

module.exports = async function handler(req, res) {
    // 1. Strict Administrator Authorization Check
    const admin = requireAdmin(req, res);
    if (!admin) {
        return; // requireAdmin already sent 403 or redirect
    }

    if (req.method === 'GET') {
        try {
            // Count queries
            const [usersCount, coursesCount, puzzlesCount, submissionsCount, messagesCount] = await Promise.all([
                query('SELECT COUNT(*) AS count FROM users'),
                query('SELECT COUNT(*) AS count FROM courses'),
                query('SELECT COUNT(*) AS count FROM puzzles'),
                query('SELECT COUNT(*) AS count FROM ChessResults'),
                query('SELECT COUNT(*) AS count FROM contact_messages')
            ]);

            // Recent submissions
            const recentSubmissions = await query(
                `SELECT TOP 10 player_name, player_id, score, total, submission_time 
                 FROM ChessResults 
                 ORDER BY submission_time DESC`
            );

            // Recent contact messages
            const recentMessages = await query(
                `SELECT TOP 10 message_id, sender_name, sender_email, subject, message, received_at, is_read 
                 FROM contact_messages 
                 ORDER BY received_at DESC`
            );

            // Recent registered users
            const recentUsers = await query(
                `SELECT TOP 10 user_id, full_name, username, email, experience_level, is_admin, created_at 
                 FROM users 
                 ORDER BY created_at DESC`
            );

            return sendResponse(req, res, {
                status: 200,
                json: {
                    success: true,
                    stats: {
                        totalUsers: usersCount.recordset[0].count,
                        totalCourses: coursesCount.recordset[0].count,
                        totalPuzzles: puzzlesCount.recordset[0].count,
                        totalSubmissions: submissionsCount.recordset[0].count,
                        totalMessages: messagesCount.recordset[0].count
                    },
                    submissions: recentSubmissions.recordset,
                    messages: recentMessages.recordset,
                    users: recentUsers.recordset
                }
            });
        } catch (err) {
            console.error('Error fetching admin overview data:', err);
            return sendResponse(req, res, {
                status: 500,
                json: { success: false, message: 'Could not load admin dashboard statistics' }
            });
        }
    }

    if (req.method === 'POST') {
        // CSRF Protection
        if (!enforceCsrfProtection(req, res)) {
            return;
        }

        try {
            const body = await parseBody(req);
            const action = body.action;

            if (action === 'delete_user') {
                const userId = parseInt(body.userId, 10);
                if (userId > 1) { // Protect root admin
                    await query('DELETE FROM users WHERE user_id = @userId', { userId });
                }
                return sendResponse(req, res, { status: 200, json: { success: true } });
            }

            if (action === 'mark_read') {
                const messageId = parseInt(body.messageId, 10);
                await query('UPDATE contact_messages SET is_read = 1 WHERE message_id = @messageId', { messageId });
                return sendResponse(req, res, { status: 200, json: { success: true } });
            }

            return sendResponse(req, res, { status: 400, json: { error: 'Unknown admin action' } });
        } catch (err) {
            console.error('Admin POST action error:', err);
            return sendResponse(req, res, { status: 500, json: { success: false, message: err.message } });
        }
    }

    return sendResponse(req, res, { status: 405, json: { error: 'Method not allowed' } });
};
