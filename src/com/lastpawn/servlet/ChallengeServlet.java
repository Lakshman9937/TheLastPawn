package com.lastpawn.servlet;

import com.lastpawn.db.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.net.URLEncoder;
import java.sql.*;

/**
 * Grades the chess knowledge challenge quiz and persists the result.
 * Supports both ChessResults (player_name, player_id, score, total, submission_time)
 * and challenge_submissions, preventing SQL column name mismatch.
 * URL: /ChallengeServlet  (POST)
 */
public class ChallengeServlet extends HttpServlet {

    // Correct option letters (1-indexed, index 0 unused)
    // Matches the questions in ChessQuestions / database-setup:
    // Q1=C (Knight L-shape), Q2=A (Bishop diagonal), Q3=B (Queen), Q4=B (Checkmate king), Q5=D (Pawn forward)
    // Or dynamic / default fallback:
    private static final String[] CORRECT = { "", "C", "A", "B", "B", "D" };
    private static final int TOTAL_QUESTIONS = 5;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String candidateName = trim(request.getParameter("candidateName"));
        String candidateId   = trim(request.getParameter("candidateId"));
        String token         = trim(request.getParameter("assessment_token"));

        String ctx = request.getContextPath();

        if (isEmpty(candidateName) || isEmpty(candidateId)) {
            redirect(response, ctx + "/challenge.jsp?error=Name+and+ID+are+required");
            return;
        }

        // Duplicate submission prevention via session token
        HttpSession session = request.getSession(true);
        String lastSubmittedToken = (String) session.getAttribute("last_submitted_token");
        if (token != null && !token.isEmpty() && token.equals(lastSubmittedToken)) {
            // Already submitted, do not re-insert duplicate
            redirect(response, ctx + "/leaderboard.jsp?msg=Attempt+already+recorded");
            return;
        }

        // ── Grade answers ─────────────────────────────────────────────────────
        int correctCount = 0;
        for (int i = 1; i <= TOTAL_QUESTIONS; i++) {
            String submitted = trim(request.getParameter("answer" + i));
            // Check against configured correct answers (or query from DB if available)
            if (CORRECT[i].equalsIgnoreCase(submitted)) {
                correctCount++;
            }
        }

        int score = correctCount; // ChessResults uses score out of total (e.g. 5/5)
        int total = TOTAL_QUESTIONS;
        double accuracy = (total > 0) ? (score / (double) total) * 100.0 : 0.0;

        // ── Persist result ────────────────────────────────────────────────────
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();

            // 1. Insert into ChessResults (with submission_time)
            try {
                String sql1 =
                    "INSERT INTO ChessResults (player_name, player_id, score, total, submission_time) " +
                    "VALUES (?, ?, ?, ?, GETDATE())";
                try (PreparedStatement stmt1 = conn.prepareStatement(sql1)) {
                    stmt1.setString(1, candidateName);
                    stmt1.setString(2, candidateId);
                    stmt1.setInt(3, score);
                    stmt1.setInt(4, total);
                    stmt1.executeUpdate();
                }
            } catch (SQLException e1) {
                log("Error inserting into ChessResults: " + e1.getMessage());
            }

            // 2. Also insert into challenge_submissions if table exists
            try {
                String sql2 =
                    "IF EXISTS (SELECT * FROM sysobjects WHERE name='challenge_submissions' AND xtype='U') " +
                    "BEGIN " +
                    "  INSERT INTO challenge_submissions (candidate_name, candidate_id, score, total_questions, accuracy, submitted_at) " +
                    "  VALUES (?, ?, ?, ?, ?, GETDATE()); " +
                    "END";
                try (PreparedStatement stmt2 = conn.prepareStatement(sql2)) {
                    stmt2.setString(1, candidateName);
                    stmt2.setString(2, candidateId);
                    stmt2.setInt(3, score * 20); // 20 pts per question in challenge_submissions
                    stmt2.setInt(4, total);
                    stmt2.setDouble(5, accuracy);
                    stmt2.executeUpdate();
                }
            } catch (SQLException e2) {
                log("Error inserting into challenge_submissions: " + e2.getMessage());
            }

            if (token != null && !token.isEmpty()) {
                session.setAttribute("last_submitted_token", token);
            }

        } catch (ClassNotFoundException e) {
            log("DB driver not found", e);
        } catch (SQLException e) {
            log("SQL error saving challenge submission", e);
        } finally {
            closeQuietly(conn);
        }

        // ── PRG redirect with results ─────────────────────────────────────────
        String encodedName = URLEncoder.encode(candidateName, "UTF-8");
        String redirectUrl = String.format(
            "%s/challenge.jsp?score=%d&total=%d&accuracy=%.1f&name=%s&finished=true",
            ctx, score, total, accuracy, encodedName
        );
        redirect(response, redirectUrl);
    }

    // ── Helpers ───────────────────────────────────────────────────────────────

    private void redirect(HttpServletResponse response, String url) throws IOException {
        response.sendRedirect(url);
    }

    private String trim(String s) {
        return (s == null) ? "" : s.trim();
    }

    private boolean isEmpty(String s) {
        return s == null || s.trim().isEmpty();
    }

    private void closeQuietly(Connection conn) {
        if (conn != null) {
            try { conn.close(); } catch (SQLException ignored) {}
        }
    }
}
