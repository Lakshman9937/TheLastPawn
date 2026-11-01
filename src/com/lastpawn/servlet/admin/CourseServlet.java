package com.lastpawn.servlet.admin;

import com.lastpawn.db.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

/**
 * Admin servlet for managing courses (Create, Delete).
 * URL: /admin/CourseServlet
 */
public class CourseServlet extends HttpServlet {

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
            String idStr = request.getParameter("courseId");
            if (idStr != null && !idStr.isEmpty()) {
                try (Connection conn = DBConnection.getConnection();
                     PreparedStatement stmt = conn.prepareStatement("DELETE FROM courses WHERE course_id = ?")) {
                    stmt.setInt(1, Integer.parseInt(idStr));
                    stmt.executeUpdate();
                } catch (Exception e) {
                    log("Error deleting course", e);
                }
            }
        } else if ("add".equalsIgnoreCase(action)) {
            String title = request.getParameter("title");
            String desc = request.getParameter("description");
            String difficulty = request.getParameter("difficulty");
            String lessonsStr = request.getParameter("lessonsCount");
            int lessons = 10;
            try {
                if (lessonsStr != null && !lessonsStr.isEmpty()) lessons = Integer.parseInt(lessonsStr);
            } catch (NumberFormatException ignored) {}

            if (title != null && !title.trim().isEmpty()) {
                try (Connection conn = DBConnection.getConnection();
                     PreparedStatement stmt = conn.prepareStatement(
                         "INSERT INTO courses (title, description, difficulty, lessons_count, is_published, created_at) " +
                         "VALUES (?, ?, ?, ?, 1, GETDATE())")) {
                    stmt.setString(1, title.trim());
                    stmt.setString(2, desc != null ? desc.trim() : "");
                    stmt.setString(3, difficulty != null ? difficulty.trim() : "Beginner");
                    stmt.setInt(4, lessons);
                    stmt.executeUpdate();
                } catch (Exception e) {
                    log("Error inserting course", e);
                }
            }
        }

        response.sendRedirect(ctx + "/admin/courses-admin.jsp?success=1");
    }
}
