<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, com.lastpawn.db.DBConnection" %>
<%
    /* ── Session / auth guard ──────────────────────────────────────────────── */
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("isAdmin") == null || !(Boolean) sess.getAttribute("isAdmin")) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    String adminName = (String) sess.getAttribute("fullName");
    if (adminName == null) adminName = (String) sess.getAttribute("username");

    /* ── Stat counters ─────────────────────────────────────────────────────── */
    int totalUsers = 0, totalCourses = 0, totalPuzzles = 0,
        totalTournaments = 0, totalSubmissions = 0, totalMessages = 0;

    ResultSet rsSubmissions = null, rsMessages = null;
    Connection conn = null;
    PreparedStatement stmtSub = null, stmtMsg = null;

    try {
        conn = DBConnection.getConnection();

        String[][] countQueries = {
            { "SELECT COUNT(*) FROM users",                "users"        },
            { "SELECT COUNT(*) FROM courses",              "courses"      },
            { "SELECT COUNT(*) FROM puzzles",              "puzzles"      },
            { "SELECT COUNT(*) FROM Tournament",           "tournaments"  },
            { "SELECT COUNT(*) FROM ChessResults",         "submissions"  },
            { "SELECT COUNT(*) FROM contact_messages",     "messages"     }
        };

        for (String[] q : countQueries) {
            try (PreparedStatement ps = conn.prepareStatement(q[0]);
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int val = rs.getInt(1);
                    switch (q[1]) {
                        case "users":        totalUsers        = val; break;
                        case "courses":      totalCourses      = val; break;
                        case "puzzles":      totalPuzzles      = val; break;
                        case "tournaments":  totalTournaments  = val; break;
                        case "submissions":  totalSubmissions  = val; break;
                        case "messages":     totalMessages     = val; break;
                    }
                }
            } catch (SQLException ignored) {}
        }

        // Recent submissions from ChessResults
        stmtSub = conn.prepareStatement(
            "SELECT TOP 10 player_name AS candidate_name, player_id AS candidate_id, score, " +
            "(CASE WHEN total > 0 THEN (CAST(score AS FLOAT)/total)*100.0 ELSE 0 END) AS accuracy, " +
            "submission_time AS submitted_at " +
            "FROM ChessResults ORDER BY submission_time DESC"
        );
        rsSubmissions = stmtSub.executeQuery();

        stmtMsg = conn.prepareStatement(
            "SELECT TOP 10 sender_name, sender_email, subject, submitted_at " +
            "FROM contact_messages ORDER BY submitted_at DESC"
        );
        rsMessages = stmtMsg.executeQuery();

    } catch (Exception e) {
        // counts stay 0; ResultSets stay null
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard – The Last Pawn Chess Academy</title>
    <link rel="icon" type="image/png" href="<%= request.getContextPath() %>/images/CHESS%20LOGO.png">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <style>
        :root {
            --charcoal: #262421;
            --gold:     #D6A34A;
            --sage:     #81B64C;
        }

        * { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #1a1815;
            color: #e0d8cc;
            min-height: 100vh;
        }

        /* ── Layout ────────────────────────────────────────────────────────── */
        .admin-wrapper {
            display: flex;
            min-height: calc(100vh - 70px);
        }

        /* ── Sidebar ───────────────────────────────────────────────────────── */
        .sidebar {
            width: 250px;
            background: var(--charcoal);
            border-right: 2px solid var(--gold);
            padding: 30px 0;
            flex-shrink: 0;
        }

        .sidebar-logo {
            text-align: center;
            padding: 0 20px 25px;
            border-bottom: 1px solid rgba(214,163,74,.3);
            margin-bottom: 20px;
        }

        .sidebar-logo h2 {
            color: var(--gold);
            font-size: 1.1rem;
            line-height: 1.4;
        }

        .sidebar-logo span {
            color: var(--sage);
            font-size: .8rem;
        }

        .sidebar-nav a {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 13px 25px;
            color: #c9b99a;
            text-decoration: none;
            font-size: .93rem;
            transition: background .2s, color .2s;
            border-left: 3px solid transparent;
        }

        .sidebar-nav a:hover,
        .sidebar-nav a.active {
            background: rgba(214,163,74,.12);
            color: var(--gold);
            border-left-color: var(--gold);
        }

        .sidebar-nav a .icon { font-size: 1.1rem; width: 20px; }

        .sidebar-nav .logout-link {
            margin-top: 30px;
            border-top: 1px solid rgba(214,163,74,.3);
            padding-top: 15px;
        }

        .sidebar-nav .logout-link a { color: #e07070; }
        .sidebar-nav .logout-link a:hover { color: #ff8888; background: rgba(224,112,112,.1); border-left-color: #e07070; }

        /* ── Main content ──────────────────────────────────────────────────── */
        .main-content {
            flex: 1;
            padding: 35px 40px;
            overflow-y: auto;
        }

        .page-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 35px;
        }

        .page-header h1 { color: var(--gold); font-size: 1.8rem; }
        .page-header .admin-badge {
            background: rgba(214,163,74,.15);
            border: 1px solid var(--gold);
            color: var(--gold);
            padding: 6px 16px;
            border-radius: 20px;
            font-size: .85rem;
        }

        /* ── Stat cards ────────────────────────────────────────────────────── */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(175px, 1fr));
            gap: 20px;
            margin-bottom: 40px;
        }

        .stat-card {
            background: var(--charcoal);
            border: 1px solid rgba(214,163,74,.25);
            border-radius: 12px;
            padding: 22px 20px;
            text-align: center;
            transition: transform .2s, border-color .2s;
        }

        .stat-card:hover { transform: translateY(-3px); border-color: var(--gold); }

        .stat-card .stat-icon { font-size: 2rem; margin-bottom: 10px; }
        .stat-card .stat-count { font-size: 2.2rem; font-weight: 700; color: var(--gold); }
        .stat-card .stat-label { font-size: .82rem; color: #9a8e80; margin-top: 5px; text-transform: uppercase; letter-spacing: .05em; }

        /* ── Tables ────────────────────────────────────────────────────────── */
        .section-title {
            color: var(--gold);
            font-size: 1.15rem;
            margin-bottom: 15px;
            padding-bottom: 8px;
            border-bottom: 1px solid rgba(214,163,74,.3);
        }

        .table-section { margin-bottom: 40px; }

        .data-table {
            width: 100%;
            border-collapse: collapse;
            background: var(--charcoal);
            border-radius: 10px;
            overflow: hidden;
            font-size: .88rem;
        }

        .data-table thead tr { background: rgba(214,163,74,.15); }
        .data-table th {
            color: var(--gold);
            padding: 12px 15px;
            text-align: left;
            font-weight: 600;
            white-space: nowrap;
        }

        .data-table tbody tr { border-bottom: 1px solid rgba(255,255,255,.05); }
        .data-table tbody tr:last-child { border-bottom: none; }
        .data-table tbody tr:hover { background: rgba(255,255,255,.04); }
        .data-table td { padding: 11px 15px; color: #c9b99a; }

        .badge {
            display: inline-block;
            padding: 3px 10px;
            border-radius: 12px;
            font-size: .78rem;
            font-weight: 600;
        }
        .badge-gold  { background: rgba(214,163,74,.2);  color: var(--gold); }
        .badge-green { background: rgba(129,182,76,.2);  color: var(--sage); }
        .badge-red   { background: rgba(220,80,80,.2);   color: #e07070; }

        .no-data { color: #6b5f52; padding: 20px; text-align: center; font-style: italic; }
    </style>
</head>
<body>
<%@include file="../navbar.jsp"%>

<div class="admin-wrapper">

    <!-- ── Sidebar ──────────────────────────────────────────────────────── -->
    <aside class="sidebar">
        <div class="sidebar-logo">
            <div style="display:flex;align-items:center;gap:12px;margin-bottom:8px;">
                <img src="<%= request.getContextPath() %>/images/CHESS%20LOGO.png" alt="The Last Pawn" style="width:42px;height:42px;object-fit:contain;border-radius:8px;filter:drop-shadow(0 0 6px rgba(214,163,74,0.5));">
                <div>
                    <h2 style="font-size:1.1rem;margin:0;line-height:1.2;">The Last Pawn</h2>
                    <span style="font-size:0.7rem;color:var(--gold);letter-spacing:1px;text-transform:uppercase;">Admin Portal</span>
                </div>
            </div>
            <span style="font-size:0.8rem;color:#aaa;">Welcome, <%= adminName %></span>
        </div>

        <nav class="sidebar-nav">
            <a href="dashboard.jsp" class="active">
                <span class="icon">📊</span> Dashboard
            </a>
            <a href="puzzles.jsp">
                <span class="icon">♟</span> Manage Puzzles
            </a>
            <a href="videos.jsp">
                <span class="icon">🎬</span> Manage Videos
            </a>
            <a href="courses.jsp">
                <span class="icon">📚</span> Manage Courses
            </a>
            <a href="tournaments.jsp">
                <span class="icon">🏆</span> Manage Tournaments
            </a>
            <a href="challenges.jsp">
                <span class="icon">🧩</span> Manage Challenges
            </a>
            <a href="users.jsp">
                <span class="icon">👥</span> View Users
            </a>

            <div class="logout-link">
                <a href="<%= request.getContextPath() %>/LogoutServlet">
                    <span class="icon">🚪</span> Logout
                </a>
            </div>
        </nav>
    </aside>

    <!-- ── Main Content ──────────────────────────────────────────────────── -->
    <main class="main-content">

        <div class="page-header">
            <h1>Dashboard Overview</h1>
            <span class="admin-badge">🛡 Administrator</span>
        </div>

        <!-- ── Stat Cards ──────────────────────────────────────────────── -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon">👥</div>
                <div class="stat-count"><%= totalUsers %></div>
                <div class="stat-label">Total Users</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">📚</div>
                <div class="stat-count"><%= totalCourses %></div>
                <div class="stat-label">Total Courses</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">♟</div>
                <div class="stat-count"><%= totalPuzzles %></div>
                <div class="stat-label">Total Puzzles</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">🏆</div>
                <div class="stat-count"><%= totalTournaments %></div>
                <div class="stat-label">Tournaments</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">🧩</div>
                <div class="stat-count"><%= totalSubmissions %></div>
                <div class="stat-label">Submissions</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">✉️</div>
                <div class="stat-count"><%= totalMessages %></div>
                <div class="stat-label">Messages</div>
            </div>
        </div>

        <!-- ── Recent Submissions ──────────────────────────────────────── -->
        <div class="table-section">
            <h2 class="section-title">📋 Recent Challenge Submissions</h2>
            <table class="data-table">
                <thead>
                    <tr>
                        <th>Candidate Name</th>
                        <th>Candidate ID</th>
                        <th>Score</th>
                        <th>Accuracy</th>
                        <th>Submitted At</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    boolean hasSubmissions = false;
                    if (rsSubmissions != null) {
                        try {
                            while (rsSubmissions.next()) {
                                hasSubmissions = true;
                                String accStr = String.format("%.1f%%", rsSubmissions.getDouble("accuracy"));
                                int score = rsSubmissions.getInt("score");
                                String badgeClass = score >= 80 ? "badge-green" : (score >= 50 ? "badge-gold" : "badge-red");
                %>
                    <tr>
                        <td><%= escHtml(rsSubmissions.getString("candidate_name")) %></td>
                        <td><%= escHtml(rsSubmissions.getString("candidate_id")) %></td>
                        <td><span class="badge <%= badgeClass %>"><%= score %></span></td>
                        <td><%= accStr %></td>
                        <td><%= rsSubmissions.getTimestamp("submitted_at") %></td>
                    </tr>
                <%
                            }
                        } catch (SQLException ignored) {}
                    }
                    if (!hasSubmissions) {
                %>
                    <tr><td colspan="5" class="no-data">No submissions yet.</td></tr>
                <%  } %>
                </tbody>
            </table>
        </div>

        <!-- ── Recent Contact Messages ────────────────────────────────── -->
        <div class="table-section">
            <h2 class="section-title">✉️ Recent Contact Messages</h2>
            <table class="data-table">
                <thead>
                    <tr>
                        <th>Sender</th>
                        <th>Email</th>
                        <th>Subject</th>
                        <th>Received At</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    boolean hasMessages = false;
                    if (rsMessages != null) {
                        try {
                            while (rsMessages.next()) {
                                hasMessages = true;
                %>
                    <tr>
                        <td><%= escHtml(rsMessages.getString("sender_name")) %></td>
                        <td><%= escHtml(rsMessages.getString("sender_email")) %></td>
                        <td><%= escHtml(rsMessages.getString("subject")) %></td>
                        <td><%= rsMessages.getTimestamp("submitted_at") %></td>
                    </tr>
                <%
                            }
                        } catch (SQLException ignored) {}
                    }
                    if (!hasMessages) {
                %>
                    <tr><td colspan="4" class="no-data">No messages yet.</td></tr>
                <%  } %>
                </tbody>
            </table>
        </div>

    </main>
</div>

<%@include file="../footer.jsp"%>

<%
    /* ── Cleanup ──────────────────────────────────────────────────────────── */
    if (rsSubmissions != null) { try { rsSubmissions.close(); } catch (Exception ignored) {} }
    if (rsMessages    != null) { try { rsMessages.close();    } catch (Exception ignored) {} }
    if (stmtSub       != null) { try { stmtSub.close();       } catch (Exception ignored) {} }
    if (stmtMsg       != null) { try { stmtMsg.close();       } catch (Exception ignored) {} }
    if (conn          != null) { try { conn.close();          } catch (Exception ignored) {} }
%>

<%!
    /** Escapes HTML special characters to prevent XSS. */
    private String escHtml(String s) {
        if (s == null) return "";
        return s.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#x27;");
    }
%>
</body>
</html>
