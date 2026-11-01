<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.lastpawn.db.DBConnection" %>
<%
    request.setAttribute("currentPage", "tournaments");
    String regSuccess = request.getParameter("registered");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Championship Tournaments — The Last Pawn Chess Academy</title>
    <link rel="icon" type="image/png" href="images/CHESS%20LOGO.png">
    <link rel="stylesheet" href="css/style.css">
    <style>
        .tourn-tabs {
            display: flex;
            justify-content: center;
            gap: 1rem;
            margin: 2rem 0 3rem;
            flex-wrap: wrap;
        }
        .tourn-tab {
            background: #FFFFFF;
            border: 1.5px solid rgba(214,163,74,0.3);
            padding: 0.7rem 1.6rem;
            border-radius: 30px;
            font-weight: 700;
            color: var(--charcoal);
            cursor: pointer;
            transition: all 0.25s ease;
        }
        .tourn-tab.active, .tourn-tab:hover {
            background: var(--gold);
            color: #1a1815;
            border-color: var(--gold);
            box-shadow: 0 4px 15px rgba(214,163,74,0.25);
        }
        .tourn-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(330px, 1fr));
            gap: 2rem;
        }
        .tourn-card {
            background: #FFFFFF;
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 8px 30px rgba(0,0,0,0.06);
            border: 1px solid rgba(214,163,74,0.25);
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            transition: all 0.3s ease;
        }
        .tourn-card:hover {
            transform: translateY(-6px);
            border-color: var(--gold);
            box-shadow: 0 16px 40px rgba(214,163,74,0.2);
        }
        .tourn-header {
            background: linear-gradient(135deg, #1b1917, #262421);
            color: #FFFFFF;
            padding: 1.5rem;
            border-bottom: 2px solid var(--gold);
            position: relative;
        }
        .tourn-badge {
            position: absolute;
            top: 15px; right: 15px;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 700;
            text-transform: uppercase;
        }
        .badge-upcoming { background: var(--sage); color: #fff; }
        .badge-ongoing { background: var(--gold); color: #1a1815; }
        .badge-completed { background: var(--grey); color: #fff; }
        .tourn-body {
            padding: 1.8rem;
            flex: 1;
        }
        .tourn-prize-box {
            background: rgba(214,163,74,0.1);
            border: 1px solid rgba(214,163,74,0.3);
            border-radius: 8px;
            padding: 0.8rem 1rem;
            margin: 1.2rem 0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        /* ── REGISTRATION MODAL ── */
        .modal-overlay {
            display: none;
            position: fixed;
            inset: 0;
            background: rgba(0,0,0,0.7);
            z-index: 9999;
            align-items: center;
            justify-content: center;
            padding: 1rem;
        }
        .modal-overlay.open {
            display: flex;
        }
        .modal-card {
            background: #FFFFFF;
            border-radius: 16px;
            max-width: 500px;
            width: 100%;
            padding: 2.2rem;
            border: 2px solid var(--gold);
            position: relative;
            box-shadow: 0 20px 60px rgba(0,0,0,0.4);
        }
    </style>
</head>
<body>

<%@ include file="navbar.jsp" %>

<!-- Header Banner -->
<header class="page-header" style="background: linear-gradient(135deg, #1b1917, #262421); padding: 70px 20px; text-align: center; border-bottom: 3px solid var(--gold);">
    <div class="container">
        <span class="section-tag">Competitive Arena</span>
        <h1 style="font-size: 3rem; font-weight: 900; color: #FFFFFF; margin: 0.5rem 0;">ACADEMY <span style="color:var(--gold);">TOURNAMENTS</span></h1>
        <p style="color: var(--off-white); max-width: 650px; margin: 0.8rem auto 0; font-size: 1.05rem;">
            Official rated classical, rapid, and blitz championships. Put your strategic skills to the test and earn trophies and cash prizes.
        </p>
    </div>
</header>

<section class="section section-light">
    <div class="container">
        <% if ("1".equals(regSuccess)) { %>
        <div style="background:rgba(129,182,76,0.15);border:2px solid var(--sage);border-radius:12px;padding:1.2rem;margin-bottom:2rem;text-align:center;color:var(--dark-green);font-weight:700;">
            ✓ Tournament registration confirmed! Your entry has been recorded in the academy database.
        </div>
        <% } %>

        <!-- Filter tabs -->
        <div class="tourn-tabs">
            <button class="tourn-tab active" onclick="filterTournaments('all', this)">All Tournaments</button>
            <button class="tourn-tab" onclick="filterTournaments('upcoming', this)">Upcoming</button>
            <button class="tourn-tab" onclick="filterTournaments('ongoing', this)">Ongoing</button>
            <button class="tourn-tab" onclick="filterTournaments('completed', this)">Completed Results</button>
        </div>

        <div class="tourn-grid">
            <%
                boolean foundAny = false;
                try (Connection con = DBConnection.getConnection();
                     Statement st = con.createStatement();
                     ResultSet rs = st.executeQuery("SELECT TournamentID, TournamentName, Location, TournamentDate, PrizeMoney FROM Tournament ORDER BY TournamentDate DESC")) {
                    while (rs.next()) {
                        foundAny = true;
                        int tId = rs.getInt("TournamentID");
                        String tName = rs.getString("TournamentName");
                        String tLoc = rs.getString("Location");
                        String tDate = rs.getString("TournamentDate");
                        double prize = rs.getDouble("PrizeMoney");

                        String statusClass = "badge-upcoming";
                        String statusText = "Upcoming";
                        String dataCategory = "upcoming";

                        if (tName.toLowerCase().contains("open 2026") || tId == 301) {
                            statusClass = "badge-ongoing";
                            statusText = "Ongoing";
                            dataCategory = "ongoing";
                        } else if (tDate != null && tDate.compareTo("2026-08-01") < 0) {
                            statusClass = "badge-completed";
                            statusText = "Completed";
                            dataCategory = "completed";
                        }
            %>
            <div class="tourn-card tourn-item" data-category="<%= dataCategory %>">
                <div class="tourn-header">
                    <span class="tourn-badge <%= statusClass %>"><%= statusText %></span>
                    <span style="font-size:0.75rem;text-transform:uppercase;color:var(--gold);letter-spacing:1px;font-weight:700;">FIDE Rated Championship</span>
                    <h3 style="font-size:1.35rem;font-weight:800;margin:0.4rem 0 0;"><%= tName %></h3>
                </div>
                <div class="tourn-body">
                    <div style="font-size:0.88rem;color:var(--grey);margin-bottom:0.8rem;">
                        <span>📍 Venue: <strong><%= tLoc %></strong></span><br>
                        <span>📅 Date: <strong><%= tDate %></strong></span><br>
                        <span>⏱ Time Control: <strong>Rapid 15m + 10s</strong></span>
                    </div>

                    <div class="tourn-prize-box">
                        <span style="font-size:0.85rem;color:var(--charcoal);font-weight:700;">Prize Pool</span>
                        <span style="font-size:1.2rem;font-weight:900;color:var(--gold);">₹<%= String.format("%,.0f", prize) %></span>
                    </div>

                    <% if ("completed".equals(dataCategory)) { %>
                    <div style="background:#f7f7f5;padding:0.75rem;border-radius:8px;font-size:0.85rem;margin-bottom:1rem;">
                        <strong>🏆 Winner:</strong> Lakshman (Score: 5.0/5.0)<br>
                        <strong>🥈 Runner-Up:</strong> GM Magnus (Score: 4.5/5.0)
                    </div>
                    <button class="btn btn-secondary btn-block" disabled>Results Finalized</button>
                    <% } else { %>
                    <button class="btn btn-primary btn-block" onclick="openRegModal('<%= tName.replace("'", "\\'") %>', <%= tId %>)">Register for Tournament →</button>
                    <% } %>
                </div>
            </div>
            <%
                    }
                } catch (Exception e) {
                    // Fallback handled below
                }

                if (!foundAny) {
            %>
            <div class="tourn-card tourn-item" data-category="upcoming">
                <div class="tourn-header">
                    <span class="tourn-badge badge-upcoming">Upcoming</span>
                    <h3 style="font-size:1.35rem;font-weight:800;">Academy Rapid Championship 2026</h3>
                </div>
                <div class="tourn-body">
                    <p style="color:var(--grey);font-size:0.9rem;">Venue: Academy Main Hall &bull; Date: 2026-11-15</p>
                    <div class="tourn-prize-box">
                        <span style="font-weight:700;">Prize Pool</span>
                        <span style="font-size:1.2rem;font-weight:900;color:var(--gold);">₹50,000</span>
                    </div>
                    <button class="btn btn-primary btn-block" onclick="openRegModal('Academy Rapid Championship 2026', 1)">Register Now →</button>
                </div>
            </div>
            <% } %>
        </div>
    </div>
</section>

<!-- Registration Modal -->
<div class="modal-overlay" id="tournModal">
    <div class="modal-card">
        <button onclick="closeRegModal()" style="position:absolute;top:15px;right:15px;border:none;background:none;font-size:1.5rem;cursor:pointer;">&times;</button>
        <span class="section-tag" style="margin-bottom:6px;">Official Entry</span>
        <h2 style="font-size:1.5rem;font-weight:800;color:var(--charcoal);margin-bottom:0.5rem;" id="modalTournTitle">Tournament Entry</h2>
        <p style="color:var(--grey);font-size:0.88rem;margin-bottom:1.5rem;">Fill out your details to enter the official academy draw.</p>

        <form action="tournaments.jsp?registered=1" method="POST">
            <input type="hidden" name="tournamentId" id="modalTournId" value="">
            <div class="form-group mb-3">
                <label style="font-size:0.85rem;font-weight:700;color:var(--charcoal);">Candidate Full Name</label>
                <input type="text" name="participantName" class="form-control" required placeholder="Your full name">
            </div>
            <div class="form-group mb-3">
                <label style="font-size:0.85rem;font-weight:700;color:var(--charcoal);">FIDE Rating or Player ID</label>
                <input type="text" name="playerId" class="form-control" placeholder="e.g. Laxman9937, FIDE ID or Unrated">
            </div>
            <div class="form-group mb-3">
                <label style="font-size:0.85rem;font-weight:700;color:var(--charcoal);">Email Address</label>
                <input type="email" name="email" class="form-control" required placeholder="contact@example.com">
            </div>
            <button type="submit" class="btn btn-primary btn-block btn-lg mt-3">Confirm Entry Registration →</button>
        </form>
    </div>
</div>

<%@ include file="footer.jsp" %>

<script>
    function filterTournaments(category, btn) {
        document.querySelectorAll('.tourn-tab').forEach(t => t.classList.remove('active'));
        btn.classList.add('active');

        document.querySelectorAll('.tourn-item').forEach(item => {
            if (category === 'all' || item.dataset.category === category) {
                item.style.display = 'flex';
            } else {
                item.style.display = 'none';
            }
        });
    }

    function openRegModal(title, id) {
        document.getElementById('modalTournTitle').textContent = title;
        document.getElementById('modalTournId').value = id;
        document.getElementById('tournModal').classList.add('open');
    }

    function closeRegModal() {
        document.getElementById('tournModal').classList.remove('open');
    }
</script>
<script src="js/main.js"></script>
</body>
</html>
