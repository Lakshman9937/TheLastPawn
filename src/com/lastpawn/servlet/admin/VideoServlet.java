package com.lastpawn.servlet.admin;

import com.lastpawn.db.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

/**
 * Admin servlet for managing tutorial videos and learning resources.
 * URL: /admin/VideoServlet
 */
public class VideoServlet extends HttpServlet {

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
            String idStr = request.getParameter("resourceId");
            if (idStr != null && !idStr.isEmpty()) {
                try (Connection conn = DBConnection.getConnection();
                     PreparedStatement stmt = conn.prepareStatement("DELETE FROM learning_resources WHERE resource_id = ?")) {
                    stmt.setInt(1, Integer.parseInt(idStr));
                    stmt.executeUpdate();
                } catch (Exception e) {
                    log("Error deleting resource", e);
                }
            }
        } else if ("add".equalsIgnoreCase(action)) {
            String title = request.getParameter("title");
            String desc = request.getParameter("description");
            String type = request.getParameter("resourceType");
            String videoUrl = request.getParameter("videoUrl");
            String category = request.getParameter("category");

            if (title != null && !title.trim().isEmpty()) {
                try (Connection conn = DBConnection.getConnection();
                     PreparedStatement stmt = conn.prepareStatement(
                         "INSERT INTO learning_resources (title, description, resource_type, video_url, category, is_published, created_at) " +
                         "VALUES (?, ?, ?, ?, ?, 1, GETDATE())")) {
                    stmt.setString(1, title.trim());
                    stmt.setString(2, desc != null ? desc.trim() : "");
                    stmt.setString(3, type != null ? type.trim() : "video");
                    stmt.setString(4, videoUrl != null ? videoUrl.trim() : "");
                    stmt.setString(5, category != null ? category.trim() : "General");
                    stmt.executeUpdate();
                } catch (Exception e) {
                    log("Error adding resource", e);
                }
            }
        }

        response.sendRedirect(ctx + "/admin/dashboard.jsp?tab=videos&success=1");
    }
}
