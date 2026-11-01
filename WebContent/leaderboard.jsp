<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.text.SimpleDateFormat, com.lastpawn.db.DBConnection" %>
<%
    request.setAttribute("currentPage", "challenge");
    String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tactical Challenge Leaderboard — The Last Pawn Chess Academy</title>
    <link rel="icon" type="image/png" href="images/CHESS%20LOGO.png">
    <link rel="stylesheet" href="css/style.css">
    <style>
        .leaderboard-container {
            max-width: 1040px;
            margin: 0 auto;
        }
        .leaderboard-card {
            background: #FFFFFF;
            border-radius: 16px;
            padding: 2rem;
            border: 1px solid rgba(214,163,74,0.3);
            box-shadow: 0 10px 40px rgba(0,0,0,0.06);
            overflow: hidden;
        }
        .leaderboard-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            margin-top: 1.5rem;
        }
        .leaderboard-table th {
            background: #262421;
            color: var(--gold);
            font-size: 0.82rem;
            text-transform: uppercase;
            letter-spacing: 1.5px;
            font-weight: 700;
            padding: 1.1rem 1.4rem;
            text-align: left;
            border-top: 3px solid var(--gold);
        }
        .leaderboard-table th:first-child { border-top-left-radius: 12px; }
        .leaderboard-table th:last-child { border-top-right-radius: 12px; text-align: right; }
        .leaderboard-table td {
            padding: 1.2rem 1.4rem;
            border-bottom: 1px solid rgba(0,0,0,0.06);
            color: var(--charcoal);
            font-size: 0.95rem;
        }
        .leaderboard-table tr:hover td {
            background: #fdfaf2;
        }
        .leaderboard-table td:last-child {
            text-align: right;
            color: var(--grey);
            font-size: 0.85rem;
        }
        .rank-medal {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 32px;
            height: 32px;
            border-radius: 50%;
            font-weight: 800;
            font-size: 0.9rem;
        }
        .rank-1 { background: #FFD700; color: #1a1815; box-shadow: 0 2px 8px rgba(255,215,0,0.5); }
        .rank-2 { background: #C0C0C0; color: #1a1815; }
        .rank-3 { background: #CD7F32; color: #FFFFFF; }
        .rank-default { background: #f0f0ee; color: var(--charcoal); }
        .score-pill {
            display: inline-block;
            background: rgba(214,163,74,0.15);
            color: var(--charcoal);
            font-weight: 800;
            padding: 4px 12px;
            border-radius: 20px;
            border: 1px solid rgba(214,163,74,0.3);
        }
        .acc-pill {
            display: inline-block;
            background: rgba(129,182,76,0.15);
            color: var(--dark-green);
            font-weight: 800;
            padding: 4px 10px;
            border-radius: 20px;
        }
    </style>
</head>
<body>

<%@ include file="navbar.jsp" %>

<!-- Header Banner -->
<header class="page-header" style="background: linear-gradient(135deg, #1b1917, #262421); padding: 70px 20px; text-align: center; border-bottom: 3px solid var(--gold);">
    <div class="container">
        <span class="section-tag">Competitive Standings</span>
        <h1 style="font-size: 3rem; font-weight: 900; color: #FFFFFF; margin: 0.5rem 0;">TACTICAL <span style="color:var(--gold);">LEADERBOARD</span></h1>
        <p style="color: var(--off-white); max-width: 650px; margin: 0.8rem auto 0; font-size: 1.05rem;">
            Official Academy Hall of Fame. Showing verified candidate highest tactical assessment scores and accuracy rankings.
        </p>
    </div>
</header>

<section class="section section-light">
    <div class="container leaderboard-container">

        <% if (msg != null) { %>
        <div style="background:#e2f0d9;color:#2b542c;padding:0.9rem;border-radius:10px;margin-bottom:1.5rem;text-align:center;font-weight:600;">
            ✓ <%= msg %>
        </div>
        <% } %>

        <div style="display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:12px;margin-bottom:1.5rem;">
            <div>
                <h2 style="font-size:1.6rem;font-weight:800;color:var(--charcoal);margin:0;">Candidate Ranking Index</h2>
                <p style="color:var(--grey);font-size:0.88rem;margin:4px 0 0;">Ranked by highest score & accuracy. Best attempt shown per candidate.</p>
            </div>
            <a href="challenge.jsp" class="btn btn-primary btn-sm">Take Tactical Assessment →</a>
        </div>

        <div class="leaderboard-card">
            <div style="overflow-x:auto;">
                <table class="leaderboard-table">
                    <thead>
                        <tr>
                            <th style="width:10%;">Rank</th>
                            <th style="width:30%;">Candidate Name</th>
                            <th style="width:22%;">Candidate Identifier</th>
                            <th style="width:14%;">Best Score</th>
                            <th style="width:12%;">Accuracy</th>
                            <th style="width:12%;">Recorded Date</th>
                        </tr>
                    </thead>
                    <tbody>
                    <%
                        boolean hasRecords = false;
                        String queryError = null;
                        int rank = 0;
                        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm");

                        // Primary query targeting the exact SQL Server table ChessResults with submission_time
                        String sql =
                            "WITH RankedResults AS (" +
                            "    SELECT " +
                            "        result_id, " +
                            "        player_name, " +
                            "        player_id, " +
                            "        score, " +
                            "        total, " +
                            "        submission_time, " +
                            "        ROW_NUMBER() OVER (" +
                            "            PARTITION BY COALESCE(NULLIF(LTRIM(RTRIM(player_id)), ''), player_name) " +
                            "            ORDER BY " +
                            "                (CASE WHEN total > 0 THEN (CAST(score AS FLOAT) / total) ELSE 0 END) DESC, " +
                            "                score DESC, " +
                            "                submission_time DESC, " +
                            "                result_id DESC " +
                            "        ) AS rn " +
                            "    FROM ChessResults " +
                            ") " +
                            "SELECT " +
                            "    result_id, " +
                            "    player_name, " +
                            "    player_id, " +
                            "    score, " +
                            "    total, " +
                            "    submission_time " +
                            "FROM RankedResults " +
                            "WHERE rn = 1 " +
                            "ORDER BY " +
                            "    (CASE WHEN total > 0 THEN (CAST(score AS FLOAT) / total) ELSE 0 END) DESC, " +
                            "    score DESC, " +
                            "    submission_time DESC, " +
                            "    result_id DESC";

                        try (Connection con = DBConnection.getConnection();
                             Statement st = con.createStatement();
                             ResultSet rs = st.executeQuery(sql)) {

                            while (rs.next()) {
                                hasRecords = true;
                                rank++;
                                String pName = rs.getString("player_name");
                                String pId = rs.getString("player_id");
                                int score = rs.getInt("score");
                                int total = rs.getInt("total");
                                Timestamp subTime = rs.getTimestamp("submission_time");

                                double accuracy = (total > 0) ? (score / (double) total) * 100.0 : 0.0;
                                String dateStr = (subTime != null) ? df.format(subTime) : "Recent";

                                String medalClass = "rank-default";
                                String medalText = String.valueOf(rank);
                                if (rank == 1) { medalClass = "rank-1"; medalText = "🥇"; }
                                else if (rank == 2) { medalClass = "rank-2"; medalText = "🥈"; }
                                else if (rank == 3) { medalClass = "rank-3"; medalText = "🥉"; }
                    %>
                        <tr>
                            <td><span class="rank-medal <%= medalClass %>"><%= medalText %></span></td>
                            <td><strong><%= pName %></strong></td>
                            <td><span style="font-family:monospace;color:var(--grey);"><%= (pId != null && !pId.isEmpty()) ? pId : "--" %></span></td>
                            <td><span class="score-pill"><%= score %> / <%= total %></span></td>
                            <td><span class="acc-pill"><%= String.format("%.1f", accuracy) %>%</span></td>
                            <td><%= dateStr %></td>
                        </tr>
                    <%
                            }
                        } catch (Exception e) {
                            queryError = e.getMessage();
                        }

                        if (!hasRecords && queryError == null) {
                    %>
                        <tr>
                            <td colspan="6" style="text-align:center;padding:3rem 1rem;color:var(--grey);">
                                <span style="font-size:2.5rem;display:block;margin-bottom:0.5rem;">♟</span>
                                No challenge submissions recorded yet. Be the first candidate to enter the leaderboard!
                            </td>
                        </tr>
                    <%
                        } else if (queryError != null) {
                    %>
                        <tr>
                            <td colspan="6" style="text-align:center;padding:2rem;color:#dc3545;">
                                <strong>Telemetry Notice:</strong> Unable to retrieve live database rankings: <%= queryError %>
                            </td>
                        </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
        </div>

    </div>
</section>

<%@ include file="footer.jsp" %>
<script src="js/main.js"></script>
</body>
</html>
