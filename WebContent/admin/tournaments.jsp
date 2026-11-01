<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.lastpawn.db.DBConnection" %>
<%
    Object adminFlag = session.getAttribute("isAdmin");
    if (adminFlag == null || !Boolean.TRUE.equals(adminFlag)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?error=Admin+access+required");
        return;
    }
    String successMsg = request.getParameter("success");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin — Tournament Management | The Last Pawn</title>
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
        <a href="tournaments-admin.jsp" class="active">🏆 Tournaments</a>
        <a href="users.jsp">👥 Users</a>
        <a href="../logout.jsp" style="color:#e74c3c;">🚪 Logout</a>
    </aside>

    <main class="admin-content">
        <div class="admin-header-bar">
            <div>
                <h1 style="font-size:1.6rem;font-weight:800;color:var(--charcoal);">Tournament Management</h1>
                <p style="color:var(--grey);font-size:0.85rem;">Create championships, set prize pools, and manage tournament roster</p>
            </div>
        </div>

        <% if (successMsg != null) { %><div class="alert alert-success">✓ Tournament updated successfully.</div><% } %>

        <!-- Add Tournament Form -->
        <div class="card mb-4">
            <div class="card-body">
                <h3 style="color:var(--gold);margin-bottom:1.2rem;font-size:1.1rem;">➕ Create New Tournament</h3>
                <form action="<%=request.getContextPath()%>/admin/TournamentServlet" method="post">
                    <input type="hidden" name="action" value="add">
                    <div class="grid-2" style="gap:1rem;">
                        <div class="form-group">
                            <label>Tournament Name *</label>
                            <input type="text" name="name" class="form-control" required placeholder="e.g. Winter Grand Prix 2026">
                        </div>
                        <div class="form-group">
                            <label>Venue / Location *</label>
                            <input type="text" name="location" class="form-control" required placeholder="e.g. Academy Main Hall or Online">
                        </div>
                    </div>
                    <div class="grid-2" style="gap:1rem;">
                        <div class="form-group">
                            <label>Tournament Date *</label>
                            <input type="date" name="date" class="form-control" required value="2026-11-25">
                        </div>
                        <div class="form-group">
                            <label>Prize Money (₹) *</label>
                            <input type="number" name="prize" class="form-control" required placeholder="50000" value="50000">
                        </div>
                    </div>
                    <button type="submit" class="btn btn-primary mt-2">Publish Tournament</button>
                </form>
            </div>
        </div>

        <!-- Tournaments Table -->
        <div class="card">
            <div class="card-body">
                <h3 style="color:var(--charcoal);margin-bottom:1rem;font-size:1.1rem;">Active Tournaments</h3>
                <div class="table-responsive">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Tournament Name</th>
                                <th>Location</th>
                                <th>Date</th>
                                <th>Prize</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                        <%
                            try (Connection con = DBConnection.getConnection();
                                 Statement st = con.createStatement();
                                 ResultSet rs = st.executeQuery("SELECT TournamentID, TournamentName, Location, TournamentDate, PrizeMoney FROM Tournament ORDER BY TournamentID DESC")) {
                                while (rs.next()) {
                                    int tid = rs.getInt("TournamentID");
                        %>
                            <tr>
                                <td>#<%= tid %></td>
                                <td><strong><%= rs.getString("TournamentName") %></strong></td>
                                <td><%= rs.getString("Location") %></td>
                                <td><%= rs.getString("TournamentDate") %></td>
                                <td><span class="badge badge-gold">₹<%= String.format("%,.0f", rs.getDouble("PrizeMoney")) %></span></td>
                                <td>
                                    <form action="<%=request.getContextPath()%>/admin/TournamentServlet" method="post" style="display:inline;" onsubmit="return confirm('Delete this tournament?');">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="tournamentId" value="<%= tid %>">
                                        <button type="submit" class="btn btn-sm" style="background:#e74c3c;color:#fff;">Delete</button>
                                    </form>
                                </td>
                            </tr>
                        <%
                                }
                            } catch (Exception e) {
                                out.println("<tr><td colspan='6' style='color:red;'>Error: " + e.getMessage() + "</td></tr>");
                            }
                        %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </main>
</div>

<%@ include file="../footer.jsp" %>
</body>
</html>
