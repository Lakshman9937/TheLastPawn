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
    <title>Admin — Challenge Management | The Last Pawn</title>
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
        <a href="challenges-admin.jsp" class="active">⚡ Challenges</a>
        <a href="tournaments-admin.jsp">🏆 Tournaments</a>
        <a href="users.jsp">👥 Users</a>
        <a href="../logout.jsp" style="color:#e74c3c;">🚪 Logout</a>
    </aside>

    <main class="admin-content">
        <div class="admin-header-bar">
            <div>
                <h1 style="font-size:1.6rem;font-weight:800;color:var(--charcoal);">Challenge Questions Management</h1>
                <p style="color:var(--grey);font-size:0.85rem;">Manage active quiz questions in ChessQuestions table</p>
            </div>
        </div>

        <% if (successMsg != null) { %><div class="alert alert-success">✓ Question saved successfully.</div><% } %>

        <!-- Add Question Form -->
        <div class="card mb-4">
            <div class="card-body">
                <h3 style="color:var(--gold);margin-bottom:1.2rem;font-size:1.1rem;">➕ Add Challenge Question</h3>
                <form action="<%=request.getContextPath()%>/admin/ChallengeAdminServlet" method="post">
                    <input type="hidden" name="action" value="add">
                    <div class="form-group mb-3">
                        <label>Question Text *</label>
                        <input type="text" name="question" class="form-control" required placeholder="e.g. Which piece can deliver a smothered mate?">
                    </div>
                    <div class="grid-2" style="gap:1rem;">
                        <div class="form-group">
                            <label>Option A *</label>
                            <input type="text" name="optionA" class="form-control" required placeholder="Option A">
                        </div>
                        <div class="form-group">
                            <label>Option B *</label>
                            <input type="text" name="optionB" class="form-control" required placeholder="Option B">
                        </div>
                    </div>
                    <div class="grid-2" style="gap:1rem;">
                        <div class="form-group">
                            <label>Option C *</label>
                            <input type="text" name="optionC" class="form-control" required placeholder="Option C">
                        </div>
                        <div class="form-group">
                            <label>Option D *</label>
                            <input type="text" name="optionD" class="form-control" required placeholder="Option D">
                        </div>
                    </div>
                    <div class="form-group mb-3" style="max-width:300px;">
                        <label>Correct Answer Letter (A, B, C, or D) *</label>
                        <select name="correctAnswer" class="form-control">
                            <option value="A">A</option>
                            <option value="B">B</option>
                            <option value="C">C</option>
                            <option value="D">D</option>
                        </select>
                    </div>
                    <button type="submit" class="btn btn-primary">Add Question to Bank</button>
                </form>
            </div>
        </div>

        <!-- Questions List Table -->
        <div class="card">
            <div class="card-body">
                <h3 style="color:var(--charcoal);margin-bottom:1rem;font-size:1.1rem;">Active Challenge Questions</h3>
                <div class="table-responsive">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Question</th>
                                <th>Correct Ans</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                        <%
                            try (Connection con = DBConnection.getConnection();
                                 Statement st = con.createStatement();
                                 ResultSet rs = st.executeQuery("SELECT id, question, correct_answer FROM ChessQuestions ORDER BY id ASC")) {
                                while (rs.next()) {
                                    int qid = rs.getInt("id");
                        %>
                            <tr>
                                <td>#<%= qid %></td>
                                <td><strong><%= rs.getString("question") %></strong></td>
                                <td><span class="badge badge-green"><%= rs.getString("correct_answer") %></span></td>
                                <td>
                                    <form action="<%=request.getContextPath()%>/admin/ChallengeAdminServlet" method="post" style="display:inline;" onsubmit="return confirm('Delete this question?');">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="questionId" value="<%= qid %>">
                                        <button type="submit" class="btn btn-sm" style="background:#e74c3c;color:#fff;">Delete</button>
                                    </form>
                                </td>
                            </tr>
                        <%
                                }
                            } catch (Exception e) {
                                out.println("<tr><td colspan='4' style='color:red;'>Error: " + e.getMessage() + "</td></tr>");
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
