package com.lastpawn.servlet.admin;

import com.lastpawn.db.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

/**
 * Admin servlet for managing tactical puzzles (Create, Delete).
 * URL: /admin/PuzzleServlet
 */
public class PuzzleServlet extends HttpServlet {

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
            String idStr = request.getParameter("puzzleId");
            if (idStr != null && !idStr.isEmpty()) {
                try (Connection conn = DBConnection.getConnection();
                     PreparedStatement stmt = conn.prepareStatement("DELETE FROM puzzles WHERE puzzle_id = ?")) {
                    stmt.setInt(1, Integer.parseInt(idStr));
                    stmt.executeUpdate();
                } catch (Exception e) {
                    log("Error deleting puzzle", e);
                }
            }
        } else if ("add".equalsIgnoreCase(action)) {
            String title = request.getParameter("title");
            String desc = request.getParameter("description");
            String difficulty = request.getParameter("difficulty");
            String solution = request.getParameter("solution");
            String explanation = request.getParameter("explanation");

            if (title != null && !title.trim().isEmpty()) {
                try (Connection conn = DBConnection.getConnection();
                     PreparedStatement stmt = conn.prepareStatement(
                         "INSERT INTO puzzles (title, description, difficulty, solution, explanation, is_published, created_at) " +
                         "VALUES (?, ?, ?, ?, ?, 1, GETDATE())")) {
                    stmt.setString(1, title.trim());
                    stmt.setString(2, desc != null ? desc.trim() : "");
                    stmt.setString(3, difficulty != null ? difficulty.trim() : "Intermediate");
                    stmt.setString(4, solution != null ? solution.trim() : "");
                    stmt.setString(5, explanation != null ? explanation.trim() : "");
                    stmt.executeUpdate();
                } catch (Exception e) {
                    log("Error adding puzzle", e);
                }
            }
        }

        response.sendRedirect(ctx + "/admin/dashboard.jsp?tab=puzzles&success=1");
    }
}
