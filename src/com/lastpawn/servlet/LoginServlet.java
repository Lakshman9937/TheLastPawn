package com.lastpawn.servlet;

import com.lastpawn.db.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.*;

/**
 * Handles user login for The Last Pawn Chess Academy.
 * Accepts username OR email combined with password.
 * URL: /LoginServlet  (POST)
 */
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String usernameOrEmail = trim(request.getParameter("username"));
        String password        = request.getParameter("password");

        String ctx = request.getContextPath();

        if (isEmpty(usernameOrEmail) || isEmpty(password)) {
            redirect(response, ctx + "/login.jsp?error=Invalid+credentials");
            return;
        }

        String passwordHash = sha256(password);

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();

            String sql =
                "SELECT user_id, username, full_name, is_admin FROM users " +
                "WHERE (username = ? OR email = ?) AND password_hash = ?";

            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, usernameOrEmail);
                stmt.setString(2, usernameOrEmail);
                stmt.setString(3, passwordHash);

                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        int     userId   = rs.getInt(1); // column 1 is user_id
                        String  uname    = rs.getString("username");
                        String  fullName = rs.getString("full_name");
                        boolean isAdmin  = rs.getBoolean("is_admin");

                        HttpSession session = request.getSession(true);
                        session.setAttribute("userId",   userId);
                        session.setAttribute("username", uname);
                        session.setAttribute("fullName", fullName);
                        session.setAttribute("isAdmin",  isAdmin);

                        if (isAdmin) {
                            redirect(response, ctx + "/admin/dashboard.jsp");
                        } else {
                            redirect(response, ctx + "/index.jsp");
                        }
                    } else {
                        redirect(response, ctx + "/login.jsp?error=Invalid+credentials");
                    }
                }
            }

        } catch (ClassNotFoundException e) {
            log("DB driver not found", e);
            redirect(response, ctx + "/login.jsp?error=Server+error.+Please+try+again+later");
        } catch (SQLException e) {
            log("SQL error during login", e);
            redirect(response, ctx + "/login.jsp?error=Login+failed.+Please+try+again");
        } finally {
            closeQuietly(conn);
        }
    }

    // ── Helpers ───────────────────────────────────────────────────────────────

    private String sha256(String input) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hash = md.digest(input.getBytes("UTF-8"));
            StringBuilder sb = new StringBuilder();
            for (byte b : hash) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException | java.io.UnsupportedEncodingException e) {
            throw new RuntimeException("SHA-256 not available", e);
        }
    }

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
