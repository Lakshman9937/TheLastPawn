package com.lastpawn.servlet.admin;

import com.lastpawn.db.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

/**
 * Admin servlet for managing tournaments (Create, Delete).
 * Supports Tournament / tournaments tables.
 * URL: /admin/TournamentServlet
 */
public class TournamentServlet extends HttpServlet {

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
            String idStr = request.getParameter("tournamentId");
            if (idStr != null && !idStr.isEmpty()) {
                try (Connection conn = DBConnection.getConnection()) {
                    try (PreparedStatement stmt = conn.prepareStatement("DELETE FROM tournaments WHERE tournament_id = ?")) {
                        stmt.setInt(1, Integer.parseInt(idStr));
                        stmt.executeUpdate();
                    } catch (Exception ignored) {}
                    try (PreparedStatement stmt2 = conn.prepareStatement("DELETE FROM Tournament WHERE TournamentID = ?")) {
                        stmt2.setInt(1, Integer.parseInt(idStr));
                        stmt2.executeUpdate();
                    } catch (Exception ignored) {}
                } catch (Exception e) {
                    log("Error deleting tournament", e);
                }
            }
        } else if ("add".equalsIgnoreCase(action)) {
            String name = request.getParameter("name");
            String location = request.getParameter("location");
            String dateStr = request.getParameter("date");
            String prizeStr = request.getParameter("prize");
            double prize = 10000;
            try {
                if (prizeStr != null && !prizeStr.isEmpty()) prize = Double.parseDouble(prizeStr);
            } catch (NumberFormatException ignored) {}

            if (name != null && !name.trim().isEmpty()) {
                try (Connection conn = DBConnection.getConnection();
                     PreparedStatement stmt = conn.prepareStatement(
                         "INSERT INTO Tournament (TournamentName, Location, TournamentDate, PrizeMoney) " +
                         "VALUES (?, ?, ?, ?)")) {
                    stmt.setString(1, name.trim());
                    stmt.setString(2, location != null ? location.trim() : "Main Hall");
                    stmt.setString(3, dateStr != null && !dateStr.isEmpty() ? dateStr : "2026-12-01");
                    stmt.setDouble(4, prize);
                    stmt.executeUpdate();
                } catch (Exception e) {
                    log("Error adding tournament", e);
                }
            }
        }

        response.sendRedirect(ctx + "/admin/dashboard.jsp?tab=tournaments&success=1");
    }
}
