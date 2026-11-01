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
    <title>Admin — Videos & Resources | The Last Pawn</title>
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
        <a href="videos-admin.jsp" class="active">🎬 Videos</a>
        <a href="challenges-admin.jsp">⚡ Challenges</a>
        <a href="tournaments-admin.jsp">🏆 Tournaments</a>
        <a href="users.jsp">👥 Users</a>
        <a href="../logout.jsp" style="color:#e74c3c;">🚪 Logout</a>
    </aside>

    <main class="admin-content">
        <div class="admin-header-bar">
            <div>
                <h1 style="font-size:1.6rem;font-weight:800;color:var(--charcoal);">Tutorial Videos & Study Materials</h1>
                <p style="color:var(--grey);font-size:0.85rem;">Manage multimedia lectures, video masterclasses, and PDF resources</p>
            </div>
        </div>

        <% if (successMsg != null) { %><div class="alert alert-success">✓ Resource updated successfully.</div><% } %>

        <!-- Add Resource Form -->
        <div class="card mb-4">
            <div class="card-body">
                <h3 style="color:var(--gold);margin-bottom:1.2rem;font-size:1.1rem;">➕ Add Video or Study Material</h3>
                <form action="<%=request.getContextPath()%>/admin/VideoServlet" method="post">
                    <input type="hidden" name="action" value="add">
                    <div class="grid-2" style="gap:1rem;">
                        <div class="form-group">
                            <label>Title *</label>
                            <input type="text" name="title" class="form-control" required placeholder="e.g. Pawn Structures in the Sicilian">
                        </div>
                        <div class="form-group">
                            <label>Resource Type *</label>
                            <select name="resourceType" class="form-control">
                                <option value="video" selected>Video Tutorial</option>
                                <option value="pdf">Downloadable PDF</option>
                                <option value="article">Study Article</option>
                            </select>
                        </div>
                    </div>
                    <div class="grid-2" style="gap:1rem;">
                        <div class="form-group">
                            <label>Video URL or File Link *</label>
                            <input type="text" name="videoUrl" class="form-control" placeholder="https://www.youtube.com/watch?v=... or /uploads/materials/...">
                        </div>
                        <div class="form-group">
                            <label>Category</label>
                            <select name="category" class="form-control">
                                <option value="Openings">Openings</option>
                                <option value="Tactics">Tactics</option>
                                <option value="Endgames">Endgames</option>
                                <option value="Strategy">Positional Strategy</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <label>Description</label>
                        <textarea name="description" class="form-control" rows="2" placeholder="Brief summary of learning outcomes..."></textarea>
                    </div>
                    <button type="submit" class="btn btn-primary mt-2">Save Learning Resource</button>
                </form>
            </div>
        </div>

        <!-- Resources Table -->
        <div class="card">
            <div class="card-body">
                <h3 style="color:var(--charcoal);margin-bottom:1rem;font-size:1.1rem;">Published Resources</h3>
                <div class="table-responsive">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Title</th>
                                <th>Type</th>
                                <th>Category</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                        <%
                            try (Connection con = DBConnection.getConnection();
                                 Statement st = con.createStatement();
                                 ResultSet rs = st.executeQuery("SELECT resource_id, title, resource_type, category FROM learning_resources ORDER BY resource_id DESC")) {
                                boolean hasAny = false;
                                while (rs.next()) {
                                    hasAny = true;
                                    int rid = rs.getInt("resource_id");
                        %>
                            <tr>
                                <td>#<%= rid %></td>
                                <td><strong><%= rs.getString("title") %></strong></td>
                                <td><span class="badge badge-gold"><%= rs.getString("resource_type") %></span></td>
                                <td><%= rs.getString("category") %></td>
                                <td>
                                    <form action="<%=request.getContextPath()%>/admin/VideoServlet" method="post" style="display:inline;" onsubmit="return confirm('Delete this resource?');">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="resourceId" value="<%= rid %>">
                                        <button type="submit" class="btn btn-sm" style="background:#e74c3c;color:#fff;">Delete</button>
                                    </form>
                                </td>
                            </tr>
                        <%
                                }
                                if (!hasAny) {
                        %>
                            <tr><td colspan="5" class="text-center" style="padding:2rem;">No learning resources published yet.</td></tr>
                        <%
                                }
                            } catch (Exception e) {
                                out.println("<tr><td colspan='5' style='color:red;'>Error: " + e.getMessage() + "</td></tr>");
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
