const { query } = require('../lib/db');
const { parseBody, sendResponse } = require('../lib/helpers');
const { requireAdmin } = require('../lib/auth');
const { enforceCsrfProtection } = require('../lib/csrf');

module.exports = async function handler(req, res) {
    if (req.method === 'GET') {
        try {
            const result = await query(
                'SELECT puzzle_id, title, description, image_path, difficulty, solution, explanation, is_published FROM puzzles ORDER BY puzzle_id ASC'
            );
            return sendResponse(req, res, {
                status: 200,
                json: { success: true, count: result.recordset.length, puzzles: result.recordset }
            });
        } catch (err) {
            console.error('Error fetching puzzles:', err);
            return sendResponse(req, res, { status: 500, json: { success: false, message: 'Could not fetch puzzles' } });
        }
    }

    if (req.method === 'POST') {
        // CSRF Protection
        if (!enforceCsrfProtection(req, res)) {
            return;
        }

        const admin = requireAdmin(req, res);
        if (!admin) return;

        try {
            const body = await parseBody(req);
            const action = (body.action || '').toLowerCase();

            if (action === 'delete') {
                const puzzleId = parseInt(body.puzzleId || '0', 10);
                if (puzzleId > 0) {
                    await query('DELETE FROM puzzles WHERE puzzle_id = @puzzleId', { puzzleId });
                }
                return sendResponse(req, res, { status: 200, redirect: '/admin/puzzles.html?deleted=true', json: { success: true } });
            }

            const title = (body.title || '').trim();
            const description = (body.description || '').trim();
            const difficulty = (body.difficulty || 'Intermediate').trim();
            const solution = (body.solution || '').trim();
            const explanation = (body.explanation || '').trim();

            if (!title || !solution) {
                return sendResponse(req, res, {
                    status: 400,
                    redirect: '/admin/puzzles.html?error=Title+and+solution+required',
                    json: { success: false, message: 'Title and solution required' }
                });
            }

            await query(
                `INSERT INTO puzzles (title, description, difficulty, solution, explanation, is_published, created_at)
                 VALUES (@title, @description, @difficulty, @solution, @explanation, 1, GETDATE())`,
                { title, description, difficulty, solution, explanation }
            );

            return sendResponse(req, res, {
                status: 201,
                redirect: '/admin/puzzles.html?added=true',
                json: { success: true }
            });
        } catch (err) {
            console.error('Error in puzzles admin:', err);
            return sendResponse(req, res, { status: 500, redirect: '/admin/puzzles.html?error=Server+database+error', json: { success: false } });
        }
    }

    return sendResponse(req, res, { status: 405, json: { error: 'Method not allowed' } });
};
