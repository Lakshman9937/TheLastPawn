package com.lastpawn.servlet;

import com.lastpawn.db.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

/**
 * Handles contact form submissions and stores them in the database.
 * URL: /ContactServlet  (POST)
 */
public class ContactServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String senderName  = trim(request.getParameter("senderName"));
        String senderEmail = trim(request.getParameter("senderEmail"));
        String subject     = trim(request.getParameter("subject"));
        String message     = trim(request.getParameter("message"));

        String ctx = request.getContextPath();

        // ── Validation ────────────────────────────────────────────────────────
        if (isEmpty(senderName) || isEmpty(senderEmail) || isEmpty(subject) || isEmpty(message)) {
            redirect(response, ctx + "/contact.jsp?error=true");
            return;
        }

        // ── Insert ────────────────────────────────────────────────────────────
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();

            String sql =
                "INSERT INTO contact_messages (sender_name, sender_email, subject, message, received_at, submitted_at) " +
                "VALUES (?, ?, ?, ?, GETDATE(), GETDATE())";

            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, senderName);
                stmt.setString(2, senderEmail);
                stmt.setString(3, subject);
                stmt.setString(4, message);
                stmt.executeUpdate();
            }

            redirect(response, ctx + "/contact.jsp?success=true");

        } catch (ClassNotFoundException e) {
            log("DB driver not found", e);
            redirect(response, ctx + "/contact.jsp?error=true");
        } catch (SQLException e) {
            log("SQL error storing contact message", e);
            redirect(response, ctx + "/contact.jsp?error=true");
        } finally {
            closeQuietly(conn);
        }
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
