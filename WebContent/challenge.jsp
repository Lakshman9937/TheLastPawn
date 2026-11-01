<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.UUID, com.lastpawn.db.DBConnection" %>
<%
    request.setAttribute("currentPage", "challenge");

    String finishedParam = request.getParameter("finished");
    boolean isFinished = "true".equalsIgnoreCase(finishedParam);
    String scoreStr = request.getParameter("score");
    String totalStr = request.getParameter("total");
    String accuracyStr = request.getParameter("accuracy");
    String candidateNameParam = request.getParameter("name");
    String errorMsg = request.getParameter("error");

    // Generate fresh assessment token to prevent duplicate submissions
    String assessmentToken = UUID.randomUUID().toString();
    session.setAttribute("assessment_token", assessmentToken);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tactical Chess Challenge — The Last Pawn Chess Academy</title>
    <link rel="icon" type="image/png" href="images/CHESS%20LOGO.png">
    <link rel="stylesheet" href="css/style.css">
    <style>
        .challenge-container {
            max-width: 840px;
            margin: 0 auto;
        }
        .candidate-bar {
            background: #FFFFFF;
            border: 2px solid var(--gold);
            border-radius: 16px;
            padding: 1.5rem 2rem;
            margin-bottom: 2rem;
            box-shadow: 0 8px 30px rgba(214,163,74,0.15);
            display: flex;
            gap: 1.5rem;
            align-items: center;
            flex-wrap: wrap;
        }
        .q-card {
            background: #FFFFFF;
            border-radius: 16px;
            padding: 2rem;
            margin-bottom: 1.8rem;
            border: 1px solid rgba(214,163,74,0.25);
            box-shadow: 0 6px 25px rgba(0,0,0,0.05);
            transition: all 0.25s ease;
        }
        .q-card:hover {
            border-color: var(--gold);
            box-shadow: 0 10px 30px rgba(214,163,74,0.15);
        }
        .q-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 1rem;
            border-bottom: 1px solid rgba(0,0,0,0.06);
            padding-bottom: 0.8rem;
        }
        .q-idx {
            font-size: 1.1rem;
            font-weight: 800;
            color: var(--gold);
        }
        .q-title {
            font-size: 1.15rem;
            font-weight: 800;
            color: var(--charcoal);
            margin-bottom: 1.2rem;
        }
        .opt-label {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 0.9rem 1.2rem;
            background: #fdfcf9;
            border: 1.5px solid rgba(0,0,0,0.1);
            border-radius: 10px;
            margin-bottom: 0.75rem;
            cursor: pointer;
            transition: all 0.2s ease;
            font-size: 0.95rem;
            color: var(--charcoal);
        }
        .opt-label:hover {
            background: #FFFFFF;
            border-color: var(--gold);
            transform: translateX(4px);
        }
        .opt-label input[type="radio"] {
            accent-color: var(--gold);
            width: 18px;
            height: 18px;
        }

        /* ── RESULT CELEBRATION BOX ── */
        .result-celebration {
            background: #FFFFFF;
            border-radius: 20px;
            padding: 3rem 2rem;
            border: 3px solid var(--gold);
            box-shadow: 0 20px 60px rgba(214,163,74,0.25);
            text-align: center;
            margin-bottom: 3rem;
            animation: fadeInUp 0.6s ease;
        }
        .score-circle {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            background: var(--charcoal);
            color: var(--gold);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.8rem;
            font-weight: 900;
            margin: 1.5rem auto;
            border: 4px solid var(--gold);
            box-shadow: 0 8px 30px rgba(0,0,0,0.2);
        }
    </style>
</head>
<body>

<%@ include file="navbar.jsp" %>

<!-- Header Banner -->
<header class="page-header" style="background: linear-gradient(135deg, #1b1917, #262421); padding: 70px 20px; text-align: center; border-bottom: 3px solid var(--gold);">
    <div class="container">
        <span class="section-tag">Interactive Evaluation</span>
        <h1 style="font-size: 3rem; font-weight: 900; color: #FFFFFF; margin: 0.5rem 0;">CHESS <span style="color:var(--gold);">CHALLENGE</span></h1>
        <p style="color: var(--off-white); max-width: 650px; margin: 0.8rem auto 0; font-size: 1.05rem;">
            Test your tactical acumen and pattern recognition. Results are automatically recorded on the official academy leaderboard.
        </p>
    </div>
</header>

<section class="section section-light">
    <div class="container challenge-container">

        <% if (errorMsg != null) { %>
        <div style="background:#f8d7da;color:#721c24;padding:1rem;border-radius:10px;margin-bottom:1.5rem;text-align:center;">
            <strong>Notice:</strong> <%= errorMsg %>
        </div>
        <% } %>

        <% if (isFinished) { %>
        <!-- FINISHED RESULT VIEW -->
        <div class="result-celebration">
            <span style="font-size:3.5rem;">🏆</span>
            <span class="section-tag" style="margin-top:0.5rem;">Assessment Completed</span>
            <h2 style="font-size:2.2rem;font-weight:900;color:var(--charcoal);margin:0.5rem 0;">
                Congratulations, <span><%= candidateNameParam != null ? candidateNameParam : "Candidate" %></span>!
            </h2>
            <p style="color:var(--grey);max-width:550px;margin:0 auto;">
                Your answers have been graded and permanently saved to the SQL Server database ranking index.
            </p>

            <div class="score-circle">
                <%= scoreStr != null ? scoreStr : "5" %>/<%= totalStr != null ? totalStr : "5" %>
            </div>

            <div style="display:inline-flex;gap:2rem;margin-bottom:2rem;background:#f7f7f5;padding:1rem 2rem;border-radius:12px;">
                <div>
                    <span style="font-size:0.8rem;text-transform:uppercase;color:var(--grey);font-weight:700;">Tactical Accuracy</span>
                    <div style="font-size:1.6rem;font-weight:900;color:var(--sage);"><%= accuracyStr != null ? accuracyStr : "100.0" %>%</div>
                </div>
                <div style="border-left:1px solid rgba(0,0,0,0.1);padding-left:2rem;">
                    <span style="font-size:0.8rem;text-transform:uppercase;color:var(--grey);font-weight:700;">Score Points</span>
                    <div style="font-size:1.6rem;font-weight:900;color:var(--gold);"><%= Integer.parseInt(scoreStr != null ? scoreStr : "5") * 20 %> pts</div>
                </div>
            </div>

            <!-- Explanations breakdown -->
            <div style="text-align:left;background:#fdfcf9;border:1px solid rgba(214,163,74,0.3);border-radius:12px;padding:1.8rem;margin:1.5rem auto;max-width:700px;">
                <h4 style="font-size:1.1rem;font-weight:800;color:var(--charcoal);margin-bottom:1rem;">Master Solutions & Explanations:</h4>
                <ul style="padding-left:1.2rem;color:#4a4945;font-size:0.9rem;line-height:1.7;">
                    <li><strong>Q1 (Knight Movement):</strong> Option C — The Knight moves in an L-shape and is the only piece that leaps over others.</li>
                    <li><strong>Q2 (Bishop Diagonal):</strong> Option A — Bishops move along unobstructed diagonals of their designated color.</li>
                    <li><strong>Q3 (Queen Power):</strong> Option B — The Queen combines the diagonal laser of a Bishop with the rank/file power of a Rook.</li>
                    <li><strong>Q4 (Primary Objective):</strong> Option B — The fundamental aim of chess is to deliver checkmate to the opponent's king.</li>
                    <li><strong>Q5 (Pawn Direction):</strong> Option D — Pawns only advance forward; they cannot retreat backwards.</li>
                </ul>
            </div>

            <div style="display:flex;gap:1rem;justify-content:center;flex-wrap:wrap;margin-top:2rem;">
                <a href="leaderboard.jsp" class="btn btn-primary btn-lg">View Official Leaderboard 🏆</a>
                <a href="challenge.jsp" class="btn btn-secondary btn-lg">Retake Challenge ↺</a>
            </div>
        </div>

        <% } else { %>
        <!-- QUIZ FORM -->
        <form action="<%=request.getContextPath()%>/ChallengeServlet" method="POST" id="challengeForm">
            <input type="hidden" name="assessment_token" value="<%= assessmentToken %>">

            <!-- Candidate Identity Bar -->
            <div class="candidate-bar">
                <div style="flex:1;min-width:220px;">
                    <label style="font-size:0.82rem;font-weight:700;color:var(--charcoal);text-transform:uppercase;letter-spacing:1px;display:block;margin-bottom:5px;">Candidate Full Name *</label>
                    <input type="text" name="candidateName" class="form-control" required placeholder="e.g. Lakshman or Magnus Carlsen" value="<% Object u = session.getAttribute("fullName"); if (u!=null) out.print(u); %>">
                </div>
                <div style="flex:1;min-width:220px;">
                    <label style="font-size:0.82rem;font-weight:700;color:var(--charcoal);text-transform:uppercase;letter-spacing:1px;display:block;margin-bottom:5px;">Candidate Identifier / Username *</label>
                    <input type="text" name="candidateId" class="form-control" required placeholder="e.g. Laxman9937 or GM2882" value="<% Object un = session.getAttribute("username"); if (un!=null) out.print(un); %>">
                </div>
            </div>

            <%
                int qCount = 0;
                try (Connection con = DBConnection.getConnection();
                     Statement st = con.createStatement();
                     ResultSet rs = st.executeQuery("SELECT id, question, option_a, option_b, option_c, option_d FROM ChessQuestions ORDER BY id")) {
                    while (rs.next()) {
                        qCount++;
                        int qId = rs.getInt("id");
                        String qText = rs.getString("question");
                        String optA = rs.getString("option_a");
                        String optB = rs.getString("option_b");
                        String optC = rs.getString("option_c");
                        String optD = rs.getString("option_d");
            %>
            <div class="q-card">
                <div class="q-header">
                    <span class="q-idx">Question <%= qCount %> of 5</span>
                    <span class="badge badge-info">Tactical Fundamentals</span>
                </div>
                <h3 class="q-title"><%= qText %></h3>

                <label class="opt-label">
                    <input type="radio" name="answer<%= qCount %>" value="A" required>
                    <span><strong>A.</strong> <%= optA %></span>
                </label>
                <label class="opt-label">
                    <input type="radio" name="answer<%= qCount %>" value="B">
                    <span><strong>B.</strong> <%= optB %></span>
                </label>
                <label class="opt-label">
                    <input type="radio" name="answer<%= qCount %>" value="C">
                    <span><strong>C.</strong> <%= optC %></span>
                </label>
                <label class="opt-label">
                    <input type="radio" name="answer<%= qCount %>" value="D">
                    <span><strong>D.</strong> <%= optD %></span>
                </label>
            </div>
            <%
                    }
                } catch (Exception e) {
                    // Fallback static questions if DB is offline
                }

                if (qCount == 0) {
            %>
            <!-- Static fallback questions matching ChessQuestions schema -->
            <div class="q-card">
                <div class="q-header"><span class="q-idx">Question 1 of 5</span></div>
                <h3 class="q-title">Which piece moves in an L shape?</h3>
                <label class="opt-label"><input type="radio" name="answer1" value="A" required><span><strong>A.</strong> Rook</span></label>
                <label class="opt-label"><input type="radio" name="answer1" value="B"><span><strong>B.</strong> Bishop</span></label>
                <label class="opt-label"><input type="radio" name="answer1" value="C"><span><strong>C.</strong> Knight</span></label>
                <label class="opt-label"><input type="radio" name="answer1" value="D"><span><strong>D.</strong> Queen</span></label>
            </div>
            <div class="q-card">
                <div class="q-header"><span class="q-idx">Question 2 of 5</span></div>
                <h3 class="q-title">Which piece moves diagonally?</h3>
                <label class="opt-label"><input type="radio" name="answer2" value="A" required><span><strong>A.</strong> Bishop</span></label>
                <label class="opt-label"><input type="radio" name="answer2" value="B"><span><strong>B.</strong> Rook</span></label>
                <label class="opt-label"><input type="radio" name="answer2" value="C"><span><strong>C.</strong> Knight</span></label>
                <label class="opt-label"><input type="radio" name="answer2" value="D"><span><strong>D.</strong> Pawn</span></label>
            </div>
            <div class="q-card">
                <div class="q-header"><span class="q-idx">Question 3 of 5</span></div>
                <h3 class="q-title">Which piece is the most powerful in normal chess?</h3>
                <label class="opt-label"><input type="radio" name="answer3" value="A" required><span><strong>A.</strong> King</span></label>
                <label class="opt-label"><input type="radio" name="answer3" value="B"><span><strong>B.</strong> Queen</span></label>
                <label class="opt-label"><input type="radio" name="answer3" value="C"><span><strong>C.</strong> Rook</span></label>
                <label class="opt-label"><input type="radio" name="answer3" value="D"><span><strong>D.</strong> Knight</span></label>
            </div>
            <div class="q-card">
                <div class="q-header"><span class="q-idx">Question 4 of 5</span></div>
                <h3 class="q-title">What is the main objective of chess?</h3>
                <label class="opt-label"><input type="radio" name="answer4" value="A" required><span><strong>A.</strong> Capture all pawns</span></label>
                <label class="opt-label"><input type="radio" name="answer4" value="B"><span><strong>B.</strong> Checkmate the enemy king</span></label>
                <label class="opt-label"><input type="radio" name="answer4" value="C"><span><strong>C.</strong> Promote a queen</span></label>
                <label class="opt-label"><input type="radio" name="answer4" value="D"><span><strong>D.</strong> Castle twice</span></label>
            </div>
            <div class="q-card">
                <div class="q-header"><span class="q-idx">Question 5 of 5</span></div>
                <h3 class="q-title">Which piece can move only forward initially?</h3>
                <label class="opt-label"><input type="radio" name="answer5" value="A" required><span><strong>A.</strong> Knight</span></label>
                <label class="opt-label"><input type="radio" name="answer5" value="B"><span><strong>B.</strong> Bishop</span></label>
                <label class="opt-label"><input type="radio" name="answer5" value="C"><span><strong>C.</strong> King</span></label>
                <label class="opt-label"><input type="radio" name="answer5" value="D"><span><strong>D.</strong> Pawn</span></label>
            </div>
            <% } %>

            <div style="text-align:center;margin-top:2.5rem;">
                <button type="submit" class="btn btn-primary btn-lg" style="padding:1rem 3rem;font-size:1.15rem;">
                    Submit Tactical Challenge →
                </button>
            </div>
        </form>
        <% } %>

    </div>
</section>

<%@ include file="footer.jsp" %>
<script src="js/main.js"></script>
</body>
</html>
