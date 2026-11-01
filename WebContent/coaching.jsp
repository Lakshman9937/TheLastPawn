<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.lastpawn.db.DBConnection" %>
<%
    request.setAttribute("currentPage", "coaching");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Coaching Programs — The Last Pawn Chess Academy</title>
    <link rel="icon" type="image/png" href="images/CHESS%20LOGO.png">
    <link rel="stylesheet" href="css/style.css">
    <style>
        .coaching-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
            gap: 2rem;
            margin-top: 2rem;
        }
        .coaching-card {
            background: #FFFFFF;
            border-radius: 16px;
            padding: 2.2rem;
            border: 1px solid rgba(214,163,74,0.25);
            box-shadow: 0 8px 30px rgba(0,0,0,0.06);
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            position: relative;
            overflow: hidden;
        }
        .coaching-card:hover {
            transform: translateY(-8px);
            border-color: var(--gold);
            box-shadow: 0 16px 45px rgba(214,163,74,0.18);
        }
        .coaching-card::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0;
            height: 4px;
            background: linear-gradient(90deg, var(--gold), var(--sage));
        }
        .coaching-icon {
            width: 58px;
            height: 58px;
            border-radius: 12px;
            background: rgba(214,163,74,0.12);
            color: var(--gold);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.9rem;
            margin-bottom: 1.4rem;
        }
        .coaching-title {
            font-size: 1.35rem;
            font-weight: 800;
            color: var(--charcoal);
            margin-bottom: 0.75rem;
        }
        .coaching-desc {
            color: var(--grey);
            font-size: 0.92rem;
            line-height: 1.7;
            margin-bottom: 1.5rem;
        }
        .coaching-features {
            list-style: none;
            padding: 0;
            margin-bottom: 2rem;
        }
        .coaching-features li {
            font-size: 0.88rem;
            color: #4a4945;
            padding: 0.35rem 0;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .coaching-features li::before {
            content: '♟';
            color: var(--gold);
            font-weight: bold;
        }
        .coach-roster {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 2rem;
            margin-top: 2.5rem;
        }
        .coach-card {
            background: var(--charcoal);
            border: 1px solid rgba(214,163,74,0.3);
            border-radius: 16px;
            padding: 2rem;
            text-align: center;
            color: #FFFFFF;
        }
        .coach-avatar {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            background: var(--gold);
            color: var(--charcoal);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.5rem;
            margin: 0 auto 1.2rem;
            border: 3px solid rgba(255,255,255,0.2);
        }
    </style>
</head>
<body>

<%@ include file="navbar.jsp" %>

<!-- Header Banner -->
<header class="page-header" style="background: linear-gradient(135deg, #1b1917, #262421); padding: 70px 20px; text-align: center; border-bottom: 3px solid var(--gold);">
    <div class="container">
        <span class="section-tag">Elite Training</span>
        <h1 style="font-size: 3rem; font-weight: 900; color: #FFFFFF; margin: 0.5rem 0;">CHESS <span style="color:var(--gold);">COACHING</span></h1>
        <p style="color: var(--off-white); max-width: 650px; margin: 0.8rem auto 0; font-size: 1.05rem;">
            From your very first move to master-level tournaments, our grandmaster-curated training pathways are designed for maximum rating growth.
        </p>
    </div>
</header>

<!-- Coaching Programs Section -->
<section class="section section-light">
    <div class="container">
        <div class="section-header">
            <span class="section-tag">8 Specialized Tiers</span>
            <h2>Comprehensive <span>Coaching Programs</span></h2>
            <div class="gold-line"></div>
            <p>Every student receives personalized guidance, move analysis, and practical games</p>
        </div>

        <div class="coaching-grid">
            <!-- 1. Beginner Coaching -->
            <div class="coaching-card">
                <div>
                    <div class="coaching-icon">♙</div>
                    <h3 class="coaching-title">Beginner Coaching</h3>
                    <p class="coaching-desc">Master the board layout, piece dynamics, fundamental rules, castling, and basic tactical captures. Perfect for newcomers.</p>
                    <ul class="coaching-features">
                        <li>Rules, notation & checkmate basics</li>
                        <li>Piece coordination fundamentals</li>
                        <li>Introductory puzzle exercises</li>
                    </ul>
                </div>
                <a href="contact.jsp?program=Beginner" class="btn btn-primary btn-block">Enquire Now →</a>
            </div>

            <!-- 2. Intermediate Coaching -->
            <div class="coaching-card">
                <div>
                    <div class="coaching-icon">♘</div>
                    <h3 class="coaching-title">Intermediate Coaching</h3>
                    <p class="coaching-desc">Deepen your tactical pattern recognition, pawn structures, positional evaluation, and calculation depth up to 4 plies.</p>
                    <ul class="coaching-features">
                        <li>Middle-game plans & piece play</li>
                        <li>Tactics: Pins, forks, skewers & deflections</li>
                        <li>Weekly rated practice matches</li>
                    </ul>
                </div>
                <a href="contact.jsp?program=Intermediate" class="btn btn-primary btn-block">Enquire Now →</a>
            </div>

            <!-- 3. Advanced Coaching -->
            <div class="coaching-card">
                <div>
                    <div class="coaching-icon">♖</div>
                    <h3 class="coaching-title">Advanced Coaching</h3>
                    <p class="coaching-desc">For competitive players rated 1600+. High-level positional sacrifice, pawn breakthroughs, and dynamic defense masterclasses.</p>
                    <ul class="coaching-features">
                        <li>Candidate move calculation routines</li>
                        <li>Positional sacrifices & prophylaxis</li>
                        <li>FIDE rating preparation</li>
                    </ul>
                </div>
                <a href="contact.jsp?program=Advanced" class="btn btn-primary btn-block">Enquire Now →</a>
            </div>

            <!-- 4. Tactical Training -->
            <div class="coaching-card">
                <div>
                    <div class="coaching-icon">⚡</div>
                    <h3 class="coaching-title">Tactical Training</h3>
                    <p class="coaching-desc">Intensive pattern recognition drills designed to eliminate blunders and spot explosive tactical knockout blows in blitz and classical play.</p>
                    <ul class="coaching-features">
                        <li>Double attacks & clearance sacrifices</li>
                        <li>Speed puzzle rush simulations</li>
                        <li>Mating net identification</li>
                    </ul>
                </div>
                <a href="contact.jsp?program=Tactical+Training" class="btn btn-primary btn-block">Enquire Now →</a>
            </div>

            <!-- 5. Opening Preparation -->
            <div class="coaching-card">
                <div>
                    <div class="coaching-icon">📖</div>
                    <h3 class="coaching-title">Opening Preparation</h3>
                    <p class="coaching-desc">Build a personalized opening repertoire tailored to your tactical or positional style, including 1.e4, 1.d4, and modern defenses.</p>
                    <ul class="coaching-features">
                        <li>Repertoire file (PGN) delivery</li>
                        <li>Understanding opening ideas, not just rote lines</li>
                        <li>Sideline and trap refutations</li>
                    </ul>
                </div>
                <a href="contact.jsp?program=Opening+Preparation" class="btn btn-primary btn-block">Enquire Now →</a>
            </div>

            <!-- 6. Endgame Training -->
            <div class="coaching-card">
                <div>
                    <div class="coaching-icon">♔</div>
                    <h3 class="coaching-title">Endgame Training</h3>
                    <p class="coaching-desc">Turn drawn positions into victories. Master Lucena and Philidor positions, opposition, triangulation, and fortress construction.</p>
                    <ul class="coaching-features">
                        <li>King and Pawn endgames</li>
                        <li>Rook & minor piece endings</li>
                        <li>Theoretical draw conversions</li>
                    </ul>
                </div>
                <a href="contact.jsp?program=Endgame+Training" class="btn btn-primary btn-block">Enquire Now →</a>
            </div>

            <!-- 7. Strategic Thinking -->
            <div class="coaching-card">
                <div>
                    <div class="coaching-icon">🧠</div>
                    <h3 class="coaching-title">Strategic Thinking</h3>
                    <p class="coaching-desc">Cognitive chess training that develops long-term strategy, patience, prophylactic thinking, and decision-making on and off the board.</p>
                    <ul class="coaching-features">
                        <li>Weak square & color complex exploitation</li>
                        <li>Pawn chain levers & space advantage</li>
                        <li>Strategic decision frameworks</li>
                    </ul>
                </div>
                <a href="contact.jsp?program=Strategic+Thinking" class="btn btn-primary btn-block">Enquire Now →</a>
            </div>

            <!-- 8. Personal Coaching -->
            <div class="coaching-card" style="border: 2px solid var(--gold); background: #fdfcf8;">
                <div>
                    <div class="coaching-icon" style="background:var(--gold);color:#1a1815;">👑</div>
                    <h3 class="coaching-title">Personal 1-on-1 Coaching</h3>
                    <p class="coaching-desc">Dedicated private mentorship with a certified chess master. Complete individual game reviews, custom study plans, and live sparring.</p>
                    <ul class="coaching-features">
                        <li>Individualized 60-min weekly video sessions</li>
                        <li>Comprehensive personal game audit</li>
                        <li>Direct coach messaging support</li>
                    </ul>
                </div>
                <a href="contact.jsp?program=Personal+1-on-1" class="btn btn-primary btn-block" style="background:var(--gold);color:var(--charcoal);font-weight:700;">Book Personal Session →</a>
            </div>
        </div>
    </div>
</section>

<!-- Academy Coaches from Database -->
<section class="section section-dark">
    <div class="container">
        <div class="section-header light">
            <span class="section-tag">Faculty</span>
            <h2>Meet Our <span>Certified Coaches</span></h2>
            <div class="gold-line"></div>
            <p>Learn directly from titled trainers with decades of competitive expertise</p>
        </div>

        <div class="coach-roster">
            <%
                boolean foundCoaches = false;
                try (Connection con = DBConnection.getConnection();
                     Statement st = con.createStatement();
                     ResultSet rs = st.executeQuery("SELECT CoachID, CoachName, Phone, Experience FROM Coach ORDER BY Experience DESC")) {
                    while (rs.next()) {
                        foundCoaches = true;
                        String cName = rs.getString("CoachName");
                        int exp = rs.getInt("Experience");
            %>
            <div class="coach-card">
                <div class="coach-avatar">♟</div>
                <h3 style="font-size:1.3rem;font-weight:800;color:var(--gold);margin-bottom:0.4rem;">Coach <%= cName %></h3>
                <p style="color:var(--grey);font-size:0.85rem;margin-bottom:1rem;">Senior Chess Instructor &bull; FIDE Certified</p>
                <div style="background:rgba(255,255,255,0.06);border-radius:8px;padding:0.75rem;margin-bottom:1.2rem;">
                    <span style="font-size:1.4rem;font-weight:800;color:var(--sage);"><%= exp %>+ Years</span>
                    <p style="font-size:0.78rem;color:var(--grey);margin:0;">Competitive Coaching Experience</p>
                </div>
                <a href="contact.jsp?coach=<%= java.net.URLEncoder.encode(cName, "UTF-8") %>" class="btn btn-sm btn-secondary">Request Session</a>
            </div>
            <%
                    }
                } catch (Exception e) {
                    // Fallback static cards if db not connected
                }
                if (!foundCoaches) {
            %>
            <div class="coach-card">
                <div class="coach-avatar">♟</div>
                <h3 style="font-size:1.3rem;font-weight:800;color:var(--gold);margin-bottom:0.4rem;">Coach Ramesh</h3>
                <p style="color:var(--grey);font-size:0.85rem;margin-bottom:1rem;">FIDE Master & Senior Academy Trainer</p>
                <div style="background:rgba(255,255,255,0.06);border-radius:8px;padding:0.75rem;margin-bottom:1.2rem;">
                    <span style="font-size:1.4rem;font-weight:800;color:var(--sage);">10+ Years</span>
                    <p style="font-size:0.78rem;color:var(--grey);margin:0;">Competitive Coaching Experience</p>
                </div>
                <a href="contact.jsp?coach=Ramesh" class="btn btn-sm btn-secondary">Request Session</a>
            </div>
            <div class="coach-card">
                <div class="coach-avatar">♟</div>
                <h3 style="font-size:1.3rem;font-weight:800;color:var(--gold);margin-bottom:0.4rem;">Coach Suresh</h3>
                <p style="color:var(--grey);font-size:0.85rem;margin-bottom:1rem;">Tactical Specialist & Opening Architect</p>
                <div style="background:rgba(255,255,255,0.06);border-radius:8px;padding:0.75rem;margin-bottom:1.2rem;">
                    <span style="font-size:1.4rem;font-weight:800;color:var(--sage);">7+ Years</span>
                    <p style="font-size:0.78rem;color:var(--grey);margin:0;">Competitive Coaching Experience</p>
                </div>
                <a href="contact.jsp?coach=Suresh" class="btn btn-sm btn-secondary">Request Session</a>
            </div>
            <div class="coach-card">
                <div class="coach-avatar">♟</div>
                <h3 style="font-size:1.3rem;font-weight:800;color:var(--gold);margin-bottom:0.4rem;">Coach Meena</h3>
                <p style="color:var(--grey);font-size:0.85rem;margin-bottom:1rem;">Junior Development & National Arbiter</p>
                <div style="background:rgba(255,255,255,0.06);border-radius:8px;padding:0.75rem;margin-bottom:1.2rem;">
                    <span style="font-size:1.4rem;font-weight:800;color:var(--sage);">5+ Years</span>
                    <p style="font-size:0.78rem;color:var(--grey);margin:0;">Competitive Coaching Experience</p>
                </div>
                <a href="contact.jsp?coach=Meena" class="btn btn-sm btn-secondary">Request Session</a>
            </div>
            <% } %>
        </div>
    </div>
</section>

<%@ include file="footer.jsp" %>
<script src="js/main.js"></script>
</body>
</html>
