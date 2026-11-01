<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.lastpawn.db.DBConnection" %>
<%
Object adminFlag = session.getAttribute("isAdmin");
if (adminFlag == null || !Boolean.TRUE.equals(adminFlag)) {
    response.sendRedirect(request.getContextPath() + "/login.jsp?error=Admin+access+required");
    return;
}
String successMsg = request.getParameter("success");
String errorMsg = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin — Manage Courses | The Last Pawn Chess Academy</title>
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
        <a href="courses-admin.jsp" class="active">📚 Courses</a>
        <a href="puzzles-admin.jsp">🧩 Puzzles</a>
        <a href="videos-admin.jsp">🎬 Videos</a>
        <a href="challenges-admin.jsp">⚡ Challenges</a>
        <a href="tournaments-admin.jsp">🏆 Tournaments</a>
        <a href="users.jsp">👥 Users</a>
        <a href="../logout.jsp" style="color:#e74c3c;">🚪 Logout</a>
    </aside>

    <main class="admin-content">
        <div class="admin-header-bar">
            <div>
                <h1 style="font-size:1.6rem;font-weight:800;color:var(--charcoal);">Course Management</h1>
                <p style="color:var(--grey);font-size:0.85rem;">Add, edit, and manage chess courses</p>
            </div>
        </div>

        <% if (successMsg != null) { %><div class="alert alert-success"><%= successMsg %></div><% } %>
        <% if (errorMsg != null) { %><div class="alert alert-error"><%= errorMsg %></div><% } %>

        <!-- Add Course Form -->
        <div class="card mb-4">
            <div class="card-body">
                <h3 style="color:var(--gold);margin-bottom:1.5rem;font-size:1.1rem;">➕ Add New Course</h3>
                <form action="<%=request.getContextPath()%>/admin/CourseServlet" method="post">
                    <input type="hidden" name="action" value="add">
                    <div class="grid-2" style="gap:1rem;">
                        <div class="form-group">
                            <label>Course Title *</label>
                            <input type="text" name="title" class="form-control" required placeholder="e.g. Chess Fundamentals">
                        </div>
                        <div class="form-group">
                            <label>Difficulty *</label>
                            <select name="difficulty" class="form-control" required>
                                <option value="Beginner">Beginner</option>
                                <option value="Intermediate">Intermediate</option>
                                <option value="Advanced">Advanced</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>Number of Lessons</label>
                            <input type="number" name="lessonsCount" class="form-control" min="1" placeholder="e.g. 12">
                        </div>
                        <div class="form-group">
                            <label>Published</label>
                            <select name="isPublished" class="form-control">
                                <option value="1">Yes — Published</option>
                                <option value="0">No — Draft</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <label>Description *</label>
                        <textarea name="description" class="form-control" rows="3" required placeholder="Describe what students will learn in this course..."></textarea>
                    </div>
                    <button type="submit" class="btn btn-primary">Add Course</button>
                </form>
            </div>
        </div>

        <!-- Course List -->
        <div class="table-container">
            <table class="chess-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Title</th>
                        <th>Difficulty</th>
                        <th>Lessons</th>
                        <th>Status</th>
                        <th>Created</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                <%
                try (Connection conn = DBConnection.getConnection();
                     PreparedStatement ps = conn.prepareStatement("SELECT * FROM courses ORDER BY created_at DESC");
                     ResultSet rs = ps.executeQuery()) {
                    if (!rs.isBeforeFirst()) {
                %>
                    <tr><td colspan="7" style="text-align:center;color:var(--grey);padding:2rem;">No courses found. Add one above!</td></tr>
                <%  } else {
                        while (rs.next()) {
                            boolean pub = rs.getBoolean("is_published");
                %>
                    <tr>
                        <td><%= rs.getInt("course_id") %></td>
                        <td style="font-weight:600;"><%= rs.getString("title") %></td>
                        <td>
                            <%
                            String diff = rs.getString("difficulty");
                            String badgeClass = "badge-beginner";
                            if ("Intermediate".equals(diff)) badgeClass = "badge-intermediate";
                            else if ("Advanced".equals(diff)) badgeClass = "badge-advanced";
                            %>
                            <span class="badge <%= badgeClass %>"><%= diff %></span>
                        </td>
                        <td><%= rs.getInt("lessons_count") %></td>
                        <td>
                            <% if (pub) { %>
                            <span class="badge badge-beginner">Published</span>
                            <% } else { %>
                            <span class="badge" style="background:rgba(119,118,111,0.15);color:var(--grey);border:1px solid var(--grey);">Draft</span>
                            <% } %>
                        </td>
                        <td style="font-size:0.82rem;color:var(--grey);"><%= rs.getTimestamp("created_at") != null ? rs.getTimestamp("created_at").toString().substring(0,10) : "—" %></td>
                        <td>
                            <form action="<%=request.getContextPath()%>/admin/CourseServlet" method="post" style="display:inline;"
                                  onsubmit="return confirm('Delete this course?');">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="courseId" value="<%= rs.getInt("course_id") %>">
                                <button type="submit" class="btn btn-sm btn-dark" style="color:#e74c3c;border-color:#e74c3c;">Delete</button>
                            </form>
                        </td>
                    </tr>
                <%      }
                    }
                } catch (Exception e) { %>
                    <tr><td colspan="7" style="color:#e74c3c;padding:1rem;">Database error: <%= e.getMessage() %></td></tr>
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
