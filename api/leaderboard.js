const { query } = require('./lib/db');
const { sendResponse } = require('./lib/helpers');

module.exports = async function handler(req, res) {
    if (req.method !== 'GET') {
        return sendResponse(req, res, { status: 405, json: { error: 'Method not allowed' } });
    }

    try {
        const result = await query(
            `SELECT TOP 25 result_id, player_name, player_id, score, total, submission_time
             FROM ChessResults
             ORDER BY score DESC, submission_time DESC`
        );

        return sendResponse(req, res, {
            status: 200,
            json: {
                success: true,
                count: result.recordset.length,
                leaderboard: result.recordset
            }
        });

    } catch (err) {
        console.error('Error fetching leaderboard:', err);
        return sendResponse(req, res, {
            status: 500,
            json: { success: false, message: 'Could not fetch leaderboard data' }
        });
    }
};
