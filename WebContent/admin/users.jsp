<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.lastpawn.db.DBConnection" %>
<%
// Admin security check
Object adminFlag = session.getAttribute("isAdmin");
if (adminFlag == null || !Boolean.TRUE.equals(adminFlag)) {
    response.sendRedirect(request.getContextPath() + "/login.jsp?error=Admin+access+required");
    return;
}
String adminUser = (String) session.getAttribute("username");
String successMsg = request.getParameter("success");
String errorMsg = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin — Users | The Last Pawn Chess Academy</title>
    <link rel="icon" type="image/png" href="../images/CHESS%20LOGO.png">
    <link rel="stylesheet" href="../css/style.css">
</head>
<body class="page-offset">
<% request.setAttribute("currentPage", "admin"); %>
<%@ include file="../navbar.jsp" %>

<div class="admin-layout">
    <aside class="admin-sidebar">
        <h3>Admin Panel</h3>
        <a href="dashboard.jsp">📊 Dashboard</a>
        <a href="courses-admin.jsp">📚 Courses</a>
        <a href="puzzles-admin.jsp">🧩 Puzzles</a>
        <a href="videos-admin.jsp">🎬 Videos</a>
        <a href="challenges-admin.jsp">⚡ Challenges</a>
        <a href="tournaments-admin.jsp">🏆 Tournaments</a>
        <a href="users.jsp" class="active">👥 Users</a>
        <a href="../logout.jsp" style="color:#e74c3c;">🚪 Logout</a>
    </aside>

    <main class="admin-content">
        <div class="admin-header-bar">
            <div>
                <h1 style="font-size:1.6rem;font-weight:800;color:var(--charcoal);">User Management</h1>
                <p style="color:var(--grey);font-size:0.85rem;">View and manage registered academy members</p>
            </div>
        </div>

        <% if (successMsg != null) { %><div class="alert alert-success"><%= successMsg %></div><% } %>
        <% if (errorMsg != null) { %><div class="alert alert-error"><%= errorMsg %></div><% } %>

        <div class="table-container">
            <table class="chess-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Full Name</th>
                        <th>Username</th>
                        <th>Email</th>
                        <th>Phone</th>
                        <th>Level</th>
                        <th>Role</th>
                        <th>Joined</th>
                    </tr>
                </thead>
                <tbody>
                <%
                try (Connection conn = DBConnection.getConnection();
                     PreparedStatement ps = conn.prepareStatement(
                         "SELECT user_id, full_name, username, email, phone, experience_level, is_admin, created_at FROM users ORDER BY created_at DESC");
                     ResultSet rs = ps.executeQuery()) {
                    if (!rs.isBeforeFirst()) {
                %>
                    <tr><td colspan="8" style="text-align:center;color:var(--grey);padding:2rem;">No users registered yet.</td></tr>
                <%  } else {
                        while (rs.next()) {
                            boolean isAdm = rs.getBoolean("is_admin");
                %>
                    <tr>
                        <td><%= rs.getInt("user_id") %></td>
                        <td style="font-weight:600;"><%= rs.getString("full_name") %></td>
                        <td style="color:var(--gold);">@<%= rs.getString("username") %></td>
                        <td><%= rs.getString("email") %></td>
                        <td><%= rs.getString("phone") != null ? rs.getString("phone") : "—" %></td>
                        <td><%= rs.getString("experience_level") %></td>
                        <td>
                            <% if (isAdm) { %>
                            <span class="badge badge-gold">Admin</span>
                            <% } else { %>
                            <span class="badge badge-beginner">Member</span>
                            <% } %>
                        </td>
                        <td style="font-size:0.82rem;color:var(--grey);"><%= rs.getTimestamp("created_at") != null ? rs.getTimestamp("created_at").toString().substring(0,10) : "—" %></td>
                    </tr>
                <%      }
                    }
                } catch (Exception e) { %>
                    <tr><td colspan="8" style="color:#e74c3c;padding:1rem;">Database error: <%= e.getMessage() %></td></tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </main>
</div>

<%@ include file="../footer.jsp" %>
<script src="../js/main.js"></script>
</body>
</html>
