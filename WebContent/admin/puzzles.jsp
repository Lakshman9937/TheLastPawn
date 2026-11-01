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
    <title>Admin — Puzzle Management | The Last Pawn</title>
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
        <a href="puzzles-admin.jsp" class="active">🧩 Puzzles</a>
        <a href="videos-admin.jsp">🎬 Videos</a>
        <a href="challenges-admin.jsp">⚡ Challenges</a>
        <a href="tournaments-admin.jsp">🏆 Tournaments</a>
        <a href="users.jsp">👥 Users</a>
        <a href="../logout.jsp" style="color:#e74c3c;">🚪 Logout</a>
    </aside>

    <main class="admin-content">
        <div class="admin-header-bar">
            <div>
                <h1 style="font-size:1.6rem;font-weight:800;color:var(--charcoal);">Tactical Puzzle Management</h1>
                <p style="color:var(--grey);font-size:0.85rem;">Create, publish, and manage interactive chess puzzles</p>
            </div>
        </div>

        <% if (successMsg != null) { %><div class="alert alert-success">✓ Operation completed successfully.</div><% } %>

        <!-- Add Puzzle Form -->
        <div class="card mb-4">
            <div class="card-body">
                <h3 style="color:var(--gold);margin-bottom:1.2rem;font-size:1.1rem;">➕ Add New Tactical Puzzle</h3>
                <form action="<%=request.getContextPath()%>/admin/PuzzleServlet" method="post">
                    <input type="hidden" name="action" value="add">
                    <div class="grid-2" style="gap:1rem;">
                        <div class="form-group">
                            <label>Puzzle Title *</label>
                            <input type="text" name="title" class="form-control" required placeholder="e.g. Back-Rank Mate in 2">
                        </div>
                        <div class="form-group">
                            <label>Difficulty *</label>
                            <select name="difficulty" class="form-control">
                                <option value="Beginner">Beginner</option>
                                <option value="Intermediate" selected>Intermediate</option>
                                <option value="Advanced">Advanced</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <label>Puzzle Objective / Description</label>
                        <input type="text" name="description" class="form-control" placeholder="e.g. White to move and checkmate in 2 moves.">
                    </div>
                    <div class="grid-2" style="gap:1rem;">
                        <div class="form-group">
                            <label>Correct Solution *</label>
                            <input type="text" name="solution" class="form-control" required placeholder="e.g. 1. Re8+ Rxe8 2. Rxe8#">
                        </div>
                        <div class="form-group">
                            <label>Explanation & Tactical Motif</label>
                            <input type="text" name="explanation" class="form-control" placeholder="e.g. Overloading the back rank rook...">
                        </div>
                    </div>
                    <button type="submit" class="btn btn-primary mt-2">Publish Tactical Puzzle</button>
                </form>
            </div>
        </div>

        <!-- Puzzles List Table -->
        <div class="card">
            <div class="card-body">
                <h3 style="color:var(--charcoal);margin-bottom:1rem;font-size:1.1rem;">Active Tactical Puzzles</h3>
                <div class="table-responsive">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Title</th>
                                <th>Difficulty</th>
                                <th>Solution</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                        <%
                            try (Connection con = DBConnection.getConnection();
                                 Statement st = con.createStatement();
                                 ResultSet rs = st.executeQuery("SELECT puzzle_id, title, difficulty, solution FROM puzzles ORDER BY puzzle_id DESC")) {
                                boolean hasAny = false;
                                while (rs.next()) {
                                    hasAny = true;
                                    int pid = rs.getInt("puzzle_id");
                        %>
                            <tr>
                                <td>#<%= pid %></td>
                                <td><strong><%= rs.getString("title") %></strong></td>
                                <td><span class="badge badge-gold"><%= rs.getString("difficulty") %></span></td>
                                <td><code><%= rs.getString("solution") %></code></td>
                                <td>
                                    <form action="<%=request.getContextPath()%>/admin/PuzzleServlet" method="post" style="display:inline;" onsubmit="return confirm('Delete this puzzle?');">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="puzzleId" value="<%= pid %>">
                                        <button type="submit" class="btn btn-sm" style="background:#e74c3c;color:#fff;">Delete</button>
                                    </form>
                                </td>
                            </tr>
                        <%
                                }
                                if (!hasAny) {
                        %>
                            <tr><td colspan="5" class="text-center" style="padding:2rem;">No puzzles found.</td></tr>
                        <%
                                }
                            } catch (Exception e) {
                                out.println("<tr><td colspan='5' style='color:red;'>Error loading puzzles: " + e.getMessage() + "</td></tr>");
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
