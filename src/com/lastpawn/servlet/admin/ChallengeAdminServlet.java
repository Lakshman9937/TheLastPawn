package com.lastpawn.servlet.admin;

import com.lastpawn.db.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

/**
 * Admin servlet for managing tactical challenge questions.
 * URL: /admin/ChallengeAdminServlet
 */
public class ChallengeAdminServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        if (session == null || !Boolean.TRUE.equals(session.getAttribute("isAdmin"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        String ctx = request.getContextPath();

        if ("delete".equalsIgnoreCase(action)) {
            String idStr = request.getParameter("questionId");
            if (idStr != null && !idStr.isEmpty()) {
                try (Connection conn = DBConnection.getConnection();
                     PreparedStatement stmt = conn.prepareStatement("DELETE FROM ChessQuestions WHERE id = ?")) {
                    stmt.setInt(1, Integer.parseInt(idStr));
                    stmt.executeUpdate();
                } catch (Exception e) {
                    log("Error deleting challenge question", e);
                }
            }
        } else if ("add".equalsIgnoreCase(action)) {
            String q = request.getParameter("question");
            String a = request.getParameter("optionA");
            String b = request.getParameter("optionB");
            String c = request.getParameter("optionC");
            String d = request.getParameter("optionD");
            String ans = request.getParameter("correctAnswer");

            if (q != null && !q.trim().isEmpty() && ans != null && !ans.trim().isEmpty()) {
                try (Connection conn = DBConnection.getConnection();
                     PreparedStatement stmt = conn.prepareStatement(
                         "INSERT INTO ChessQuestions (question, option_a, option_b, option_c, option_d, correct_answer) " +
                         "VALUES (?, ?, ?, ?, ?, ?)")) {
                    stmt.setString(1, q.trim());
                    stmt.setString(2, a != null ? a.trim() : "");
                    stmt.setString(3, b != null ? b.trim() : "");
                    stmt.setString(4, c != null ? c.trim() : "");
                    stmt.setString(5, d != null ? d.trim() : "");
                    stmt.setString(6, ans.trim().toUpperCase());
                    stmt.executeUpdate();
                } catch (Exception e) {
                    log("Error adding question", e);
                }
            }
        }

        response.sendRedirect(ctx + "/admin/dashboard.jsp?tab=challenges&success=1");
    }
}
