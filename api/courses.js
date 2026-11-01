const { query } = require('../lib/db');
const { parseBody, sendResponse } = require('../lib/helpers');
const { requireAdmin } = require('../lib/auth');
const { enforceCsrfProtection } = require('../lib/csrf');

module.exports = async function handler(req, res) {
    if (req.method === 'GET') {
        try {
            const url = new URL(req.url, 'http://localhost');
            const level = url.searchParams.get('level');

            let sqlQuery = 'SELECT course_id, title, description, difficulty, image_path, lessons_count, is_published FROM courses WHERE is_published = 1';
            const params = {};

            if (level && level.toLowerCase() !== 'all') {
                sqlQuery += ' AND LOWER(difficulty) = LOWER(@level)';
                params.level = level;
            }

            sqlQuery += ' ORDER BY course_id ASC';

            const result = await query(sqlQuery, params);
            return sendResponse(req, res, {
                status: 200,
                json: { success: true, count: result.recordset.length, courses: result.recordset }
            });
        } catch (err) {
            console.error('Error fetching courses:', err);
            return sendResponse(req, res, {
                status: 500,
                json: { success: false, message: 'Failed to retrieve courses' }
            });
        }
    }

    if (req.method === 'POST') {
        // CSRF Protection
        if (!enforceCsrfProtection(req, res)) {
            return;
        }

        // Enforce admin permission for modifying courses
        const admin = requireAdmin(req, res);
        if (!admin) return;

        try {
            const body = await parseBody(req);
            const action = (body.action || '').toLowerCase();

            if (action === 'delete') {
                const courseId = parseInt(body.courseId || '0', 10);
                if (courseId > 0) {
                    await query('DELETE FROM courses WHERE course_id = @courseId', { courseId });
                }
                return sendResponse(req, res, {
                    status: 200,
                    redirect: '/admin/courses.html?deleted=true',
                    json: { success: true, message: 'Course deleted successfully' }
                });
            }

            // Default action: add new course
            const title = (body.title || '').trim();
            const description = (body.description || '').trim();
            const difficulty = (body.difficulty || 'Beginner').trim();
            const lessonsCount = parseInt(body.lessonsCount || '10', 10);

            if (!title) {
                return sendResponse(req, res, {
                    status: 400,
                    redirect: '/admin/courses.html?error=Title+is+required',
                    json: { success: false, message: 'Course title is required' }
                });
            }

            await query(
                `INSERT INTO courses (title, description, difficulty, lessons_count, is_published, created_at)
                 VALUES (@title, @description, @difficulty, @lessonsCount, 1, GETDATE())`,
                { title, description, difficulty, lessonsCount }
            );

            return sendResponse(req, res, {
                status: 201,
                redirect: '/admin/courses.html?added=true',
                json: { success: true, message: 'Course added successfully' }
            });

        } catch (err) {
            console.error('Error in courses admin action:', err);
            return sendResponse(req, res, {
                status: 500,
                redirect: '/admin/courses.html?error=Server+database+error',
                json: { success: false, message: 'Server database error' }
            });
        }
    }

    return sendResponse(req, res, { status: 405, json: { error: 'Method not allowed' } });
};
