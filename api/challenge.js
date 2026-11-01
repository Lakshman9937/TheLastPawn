const { query } = require('./lib/db');
const { parseBody, sendResponse } = require('./lib/helpers');
const { enforceCsrfProtection } = require('./lib/csrf');

module.exports = async function handler(req, res) {
    if (req.method === 'GET') {
        try {
            // Fetch questions from ChessQuestions table
            const result = await query('SELECT id, question, option_a, option_b, option_c, option_d FROM ChessQuestions ORDER BY id ASC');
            return sendResponse(req, res, {
                status: 200,
                json: { success: true, count: result.recordset.length, questions: result.recordset }
            });
        } catch (err) {
            console.error('Error fetching questions:', err);
            return sendResponse(req, res, {
                status: 500,
                json: { success: false, message: 'Could not load quiz questions' }
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
            const candidateName = (body.candidateName || body.playerName || '').trim();
            const candidateId = (body.candidateId || body.playerId || '').trim();

            if (!candidateName || !candidateId) {
                return sendResponse(req, res, {
                    status: 400,
                    redirect: '/challenge.html?error=Candidate+Name+and+ID+are+required',
                    json: { success: false, message: 'Candidate Name and ID are required' }
                });
            }

            // Fetch questions and correct answers from database
            let correctAnswers = { 1: 'C', 2: 'A', 3: 'B', 4: 'B', 5: 'D' };
            try {
                const dbQuestions = await query('SELECT id, correct_answer FROM ChessQuestions');
                if (dbQuestions.recordset.length > 0) {
                    correctAnswers = {};
                    dbQuestions.recordset.forEach(q => {
                        correctAnswers[q.id] = (q.correct_answer || '').trim().toUpperCase();
                    });
                }
            } catch (qErr) {
                console.warn('Using standard challenge answer key:', qErr.message);
            }

            let correctCount = 0;
            const total = Object.keys(correctAnswers).length || 5;

            // Security: server-side scoring only (client score is ignored)
            for (const [id, correctOpt] of Object.entries(correctAnswers)) {
                const userAns = (body[`answer${id}`] || body[`q${id}`] || '').trim().toUpperCase();
                if (userAns === correctOpt) {
                    correctCount++;
                }
            }

            const score = correctCount;
            const accuracy = ((score / total) * 100).toFixed(1);

            // Insert into ChessResults table
            await query(
                `INSERT INTO ChessResults (player_name, player_id, score, total, submission_time)
                 VALUES (@candidateName, @candidateId, @score, @total, GETDATE())`,
                { candidateName, candidateId, score, total }
            );

            // Also insert into challenge_submissions if table exists
            try {
                await query(
                    `IF EXISTS (SELECT * FROM sysobjects WHERE name='challenge_submissions' AND xtype='U')
                     BEGIN
                         INSERT INTO challenge_submissions (candidate_name, candidate_id, score, total_questions, accuracy, submitted_at)
                         VALUES (@candidateName, @candidateId, @pts, @total, @accuracy, GETDATE())
                     END`,
                    { candidateName, candidateId, pts: score * 20, total, accuracy: parseFloat(accuracy) }
                );
            } catch (csErr) {
                // Non-fatal if legacy table does not exist
            }

            const redirectUrl = `/leaderboard.html?success=true&player=${encodeURIComponent(candidateName)}&score=${score}&total=${total}`;
            return sendResponse(req, res, {
                status: 200,
                redirect: redirectUrl,
                json: {
                    success: true,
                    candidateName,
                    candidateId,
                    score,
                    total,
                    accuracy: `${accuracy}%`,
                    redirectUrl
                }
            });

        } catch (err) {
            console.error('Challenge submission error:', err);
            return sendResponse(req, res, {
                status: 500,
                redirect: '/challenge.html?error=Server+database+error.+Attempt+could+not+be+recorded',
                json: { success: false, message: 'Server database error' }
            });
        }
    }

    return sendResponse(req, res, { status: 405, json: { error: 'Method not allowed' } });
};
