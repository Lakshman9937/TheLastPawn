package com.lastpawn.servlet;

import com.lastpawn.db.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.*;

/**
 * Handles new user registration for The Last Pawn Chess Academy.
 * URL: /RegisterServlet  (POST)
 */
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String fullName        = trim(request.getParameter("fullName"));
        String username        = trim(request.getParameter("username"));
        String email           = trim(request.getParameter("email"));
        String phone           = trim(request.getParameter("phone"));
        String password        = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String experienceLevel = trim(request.getParameter("experienceLevel"));

        String ctx = request.getContextPath();

        // ── Validation ────────────────────────────────────────────────────────
        if (isEmpty(fullName) || isEmpty(username) || isEmpty(email)
                || isEmpty(password) || isEmpty(confirmPassword) || isEmpty(experienceLevel)) {
            redirect(response, ctx + "/register.jsp?error=All+required+fields+must+be+filled");
            return;
        }

        if (!email.matches("^[\\w._%+\\-]+@[\\w.\\-]+\\.[a-zA-Z]{2,}$")) {
            redirect(response, ctx + "/register.jsp?error=Invalid+email+format");
            return;
        }

        if (password.length() < 6) {
            redirect(response, ctx + "/register.jsp?error=Password+must+be+at+least+6+characters");
            return;
        }

        if (!password.equals(confirmPassword)) {
            redirect(response, ctx + "/register.jsp?error=Passwords+do+not+match");
            return;
        }

        // ── DB operations ─────────────────────────────────────────────────────
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();

            // Duplicate check
            String checkSql = "SELECT COUNT(*) FROM users WHERE username = ? OR email = ?";
            try (PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
                checkStmt.setString(1, username);
                checkStmt.setString(2, email);
                try (ResultSet rs = checkStmt.executeQuery()) {
                    if (rs.next() && rs.getInt(1) > 0) {
                        redirect(response, ctx + "/register.jsp?error=Username+or+email+already+exists");
                        return;
                    }
                }
            }

            // Hash password
            String passwordHash = sha256(password);

            // Insert user
            String insertSql =
                "INSERT INTO users (full_name, username, email, phone, password_hash, experience_level, is_admin, created_at) " +
                "VALUES (?, ?, ?, ?, ?, ?, 0, GETDATE())";
            try (PreparedStatement insertStmt = conn.prepareStatement(insertSql)) {
                insertStmt.setString(1, fullName);
                insertStmt.setString(2, username);
                insertStmt.setString(3, email);
                insertStmt.setString(4, phone);
                insertStmt.setString(5, passwordHash);
                insertStmt.setString(6, experienceLevel);
                insertStmt.executeUpdate();
            }

            redirect(response, ctx + "/login.jsp?registered=true");

        } catch (ClassNotFoundException e) {
            log("DB driver not found", e);
            redirect(response, ctx + "/register.jsp?error=Server+error.+Please+try+again+later");
        } catch (SQLException e) {
            log("SQL error during registration", e);
            redirect(response, ctx + "/register.jsp?error=Registration+failed.+Please+try+again");
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
