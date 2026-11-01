<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>The Last Pawn Chess Academy — Think Better. Play Smarter.</title>
    <link rel="icon" type="image/png" href="images/CHESS%20LOGO.png">
    <link rel="stylesheet" href="css/style.css">
    <style>
        /* ── HERO ── */
        .hero {
            position: relative;
            height: 100vh;
            min-height: 620px;
            background: url('images/CHESS WWBSITE.png') center center / cover no-repeat;
            background-attachment: fixed;
            display: flex;
            align-items: center;
            justify-content: center;
            text-align: center;
            overflow: hidden;
        }
        .hero-overlay {
            position: absolute;
            inset: 0;
            background: linear-gradient(
                to bottom,
                rgba(38,36,33,0.55) 0%,
                rgba(38,36,33,0.45) 40%,
                rgba(38,36,33,0.75) 100%
            );
        }
        .hero-content {
            position: relative;
            z-index: 2;
            max-width: 800px;
            padding: 2rem;
            animation: fadeInUp 0.8s ease;
        }
        .hero-tagline {
            font-size: 0.85rem;
            letter-spacing: 4px;
            color: var(--gold);
            text-transform: uppercase;
            margin-bottom: 1rem;
            font-weight: 600;
        }
        .hero-title {
            font-size: 3.8rem;
            font-weight: 900;
            color: var(--white);
            line-height: 1.1;
            margin-bottom: 0.5rem;
            text-shadow: 2px 4px 20px rgba(0,0,0,0.5);
        }
        .hero-title span { color: var(--gold); }
        .hero-subtitle {
            font-size: 1.15rem;
            color: rgba(247,247,245,0.85);
            margin-bottom: 2.5rem;
            font-style: italic;
        }
        .hero-buttons {
            display: flex;
            gap: 1rem;
            justify-content: center;
            flex-wrap: wrap;
        }
        .hero-scroll-hint {
            position: absolute;
            bottom: 2rem;
            left: 50%;
            transform: translateX(-50%);
            z-index: 2;
            color: rgba(255,255,255,0.5);
            font-size: 0.75rem;
            letter-spacing: 2px;
            text-transform: uppercase;
            animation: bounce 2s infinite;
        }
        @keyframes bounce {
            0%, 100% { transform: translateX(-50%) translateY(0); }
            50% { transform: translateX(-50%) translateY(8px); }
        }

        /* ── STATS BAR ── */
        .stats-bar {
            background: var(--charcoal);
            border-top: 2px solid var(--gold);
            border-bottom: 1px solid rgba(214,163,74,0.2);
            padding: 1.8rem 2rem;
        }
        .stats-bar .container {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 1rem;
        }
        .stats-item {
            text-align: center;
            padding: 0.5rem;
        }
        .stats-item .stats-num {
            font-size: 2rem;
            font-weight: 800;
            color: var(--gold);
            display: block;
        }
        .stats-item .stats-label {
            font-size: 0.78rem;
            color: var(--grey);
            text-transform: uppercase;
            letter-spacing: 1.5px;
        }

        /* ── WELCOME SECTION ── */
        .welcome-section {
            background: var(--white);
        }
        .welcome-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 4rem;
            align-items: center;
        }
        .welcome-text h2 {
            font-size: 2.4rem;
            font-weight: 800;
            color: var(--charcoal);
            line-height: 1.2;
            margin-bottom: 1rem;
        }
        .welcome-text h2 span { color: var(--gold); }
        .welcome-text p {
            color: var(--grey);
            line-height: 1.8;
            margin-bottom: 1rem;
            font-size: 0.95rem;
        }
        .welcome-image {
            position: relative;
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 20px 60px rgba(0,0,0,0.15);
        }
        .welcome-image::before {
            content: '♟';
            position: absolute;
            top: -15px;
            right: -15px;
            font-size: 8rem;
            color: rgba(214,163,74,0.08);
            z-index: 0;
        }
        .pawn-chess-board {
            width: 100%;
            display: grid;
            grid-template-columns: repeat(8, 1fr);
            border-radius: 12px;
            overflow: hidden;
            border: 3px solid var(--gold);
            box-shadow: 0 8px 30px rgba(214,163,74,0.2);
        }
        .pawn-chess-board .sq {
            aspect-ratio: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.8rem;
        }
        .pawn-chess-board .sq.light { background: #f0d9b5; }
        .pawn-chess-board .sq.dark { background: #b58863; }
        .pawn-chess-board .sq.gold-sq { background: rgba(214,163,74,0.6); }

        /* ── WHY CHOOSE ── */
        .why-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 1.5rem;
        }
        .why-card {
            background: var(--white);
            border-radius: 16px;
            padding: 2rem;
            text-align: center;
            border-top: 3px solid var(--gold);
            box-shadow: 0 4px 20px rgba(0,0,0,0.06);
            transition: all 0.3s ease;
        }
        .why-card:hover {
            transform: translateY(-6px);
            box-shadow: 0 15px 40px rgba(0,0,0,0.12);
        }
        .why-card .why-icon {
            font-size: 2.8rem;
            margin-bottom: 1rem;
        }
        .why-card h3 {
            font-size: 1.05rem;
            font-weight: 700;
            color: var(--charcoal);
            margin-bottom: 0.6rem;
        }
        .why-card p {
            color: var(--grey);
            font-size: 0.88rem;
            line-height: 1.6;
        }

        /* ── COURSES ── */
        .courses-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 1.5rem;
        }
        .course-card {
            background: var(--white);
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 4px 20px rgba(0,0,0,0.07);
            transition: all 0.3s ease;
        }
        .course-card:hover {
            transform: translateY(-6px);
            box-shadow: 0 15px 40px rgba(0,0,0,0.15);
        }
        .course-img {
            height: 160px;
            background: linear-gradient(135deg, var(--charcoal), var(--charcoal-light));
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 5rem;
            position: relative;
            overflow: hidden;
        }
        .course-img::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0; right: 0;
            height: 40px;
            background: linear-gradient(to top, var(--white), transparent);
        }
        .course-body { padding: 1.5rem; }
        .course-body h3 {
            font-size: 1.05rem;
            font-weight: 700;
            color: var(--charcoal);
            margin-bottom: 0.4rem;
        }
        .course-body p {
            color: var(--grey);
            font-size: 0.85rem;
            line-height: 1.6;
            margin-bottom: 1rem;
        }
        .course-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 1rem 1.5rem;
            border-top: 1px solid rgba(0,0,0,0.05);
        }

        /* ── PUZZLES ── */
        .puzzles-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 1.5rem;
        }
        .puzzle-card {
            background: var(--charcoal-light);
            border: 1px solid rgba(214,163,74,0.2);
            border-radius: 16px;
            padding: 1.8rem;
            text-align: center;
            transition: all 0.3s ease;
        }
        .puzzle-card:hover {
            border-color: var(--gold);
            transform: translateY(-4px);
            box-shadow: 0 12px 30px rgba(0,0,0,0.3);
        }
        .puzzle-icon { font-size: 3rem; margin-bottom: 1rem; }
        .puzzle-card h3 { color: var(--gold); font-size: 1rem; margin-bottom: 0.5rem; }
        .puzzle-card p { color: var(--grey); font-size: 0.85rem; margin-bottom: 1.2rem; }

        /* ── TOURNAMENTS ── */
        .tournament-list { display: flex; flex-direction: column; gap: 1rem; }
        .tournament-item {
            background: var(--white);
            border-radius: 12px;
            padding: 1.5rem;
            display: flex;
            align-items: center;
            gap: 1.5rem;
            border-left: 4px solid var(--gold);
            box-shadow: 0 2px 12px rgba(0,0,0,0.06);
            transition: all 0.3s ease;
        }
        .tournament-item:hover {
            transform: translateX(4px);
            box-shadow: 0 6px 24px rgba(0,0,0,0.1);
        }
        .tournament-date {
            min-width: 65px;
            text-align: center;
            background: var(--charcoal);
            border-radius: 8px;
            padding: 0.6rem 0.4rem;
        }
        .tournament-date .day { font-size: 1.6rem; font-weight: 800; color: var(--gold); display: block; line-height: 1; }
        .tournament-date .month { font-size: 0.65rem; color: var(--grey); text-transform: uppercase; letter-spacing: 1px; }
        .tournament-info { flex: 1; }
        .tournament-info h3 { font-size: 1rem; font-weight: 700; color: var(--charcoal); margin-bottom: 0.25rem; }
        .tournament-info p { font-size: 0.82rem; color: var(--grey); }
        .status-upcoming { background: rgba(129,182,76,0.15); color: var(--dark-green); padding: 3px 10px; border-radius: 20px; font-size: 0.72rem; font-weight: 700; border: 1px solid var(--sage); }
        .status-ongoing { background: rgba(214,163,74,0.15); color: var(--gold-dark); padding: 3px 10px; border-radius: 20px; font-size: 0.72rem; font-weight: 700; border: 1px solid var(--gold); }

        /* ── ACHIEVEMENTS ── */
        .achievements-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 1.5rem;
        }
        .achievement-card {
            background: rgba(214,163,74,0.08);
            border: 1px solid rgba(214,163,74,0.2);
            border-radius: 16px;
            padding: 1.8rem;
            text-align: center;
        }
        .achievement-card .trophy { font-size: 2.5rem; margin-bottom: 0.75rem; }
        .achievement-card h4 { color: var(--gold); font-size: 1rem; margin-bottom: 0.3rem; }
        .achievement-card p { color: rgba(247,247,245,0.7); font-size: 0.82rem; }

        /* ── CTA ── */
        .cta-section {
            background: linear-gradient(135deg, var(--charcoal) 0%, #1a1714 100%);
            text-align: center;
            padding: 6rem 2rem;
            position: relative;
            overflow: hidden;
        }
        .cta-section::before {
            content: '♟';
            position: absolute;
            font-size: 30rem;
            color: rgba(214,163,74,0.025);
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            pointer-events: none;
        }
        .cta-section h2 {
            font-size: 3rem;
            font-weight: 900;
            color: var(--white);
            margin-bottom: 0.75rem;
        }
        .cta-section h2 span { color: var(--gold); }
        .cta-section p {
            color: rgba(247,247,245,0.7);
            font-size: 1.05rem;
            margin-bottom: 2.5rem;
            max-width: 550px;
            margin-left: auto;
            margin-right: auto;
        }
        .cta-buttons { display: flex; gap: 1rem; justify-content: center; flex-wrap: wrap; }

        /* RESPONSIVE */
        @media (max-width: 900px) {
            .hero-title { font-size: 2.6rem; }
            .welcome-grid { grid-template-columns: 1fr; gap: 2rem; }
            .why-grid, .courses-grid, .puzzles-grid { grid-template-columns: repeat(2, 1fr); }
            .achievements-grid { grid-template-columns: repeat(2, 1fr); }
            .stats-bar .container { grid-template-columns: repeat(2, 1fr); }
        }
        @media (max-width: 600px) {
            .hero-title { font-size: 2rem; }
            .why-grid, .courses-grid, .puzzles-grid, .achievements-grid { grid-template-columns: 1fr; }
            .cta-section h2 { font-size: 2rem; }
        }
    </style>
</head>
<body>
<% request.setAttribute("currentPage", "home"); %>
<%@ include file="navbar.jsp" %>

<!-- ============ HERO ============ -->
<section class="hero" id="hero">
    <div class="hero-overlay"></div>
    <div class="hero-content">
        <p class="hero-tagline">♟ THINK BETTER. PLAY SMARTER. ♟</p>
        <h1 class="hero-title" style="letter-spacing: 2px;">LEARN CHESS. MASTER STRATEGY.<br><span>BECOME A CHAMPION.</span></h1>
        <p class="hero-subtitle">Every grandmaster was once a beginner. Discover your true chess potential.</p>
        <div class="hero-buttons">
            <a href="register.jsp" class="btn btn-primary btn-lg">Join the Academy</a>
            <a href="library.jsp" class="btn btn-secondary btn-lg">Explore Chess</a>
            <a href="play.jsp" class="btn btn-green btn-lg">Play Chess</a>
        </div>
    </div>
    <div class="hero-scroll-hint">▼ Scroll to discover</div>
</section>

<!-- ============ STATS BAR ============ -->
<section class="stats-bar">
    <div class="container">
        <div class="stats-item animate-up delay-1">
            <span class="stats-num" id="cStudents">500+</span>
            <span class="stats-label">Students Trained</span>
        </div>
        <div class="stats-item animate-up delay-2">
            <span class="stats-num">20+</span>
            <span class="stats-label">Expert Coaches</span>
        </div>
        <div class="stats-item animate-up delay-3">
            <span class="stats-num">50+</span>
            <span class="stats-label">Courses Available</span>
        </div>
        <div class="stats-item animate-up delay-4">
            <span class="stats-num">100+</span>
            <span class="stats-label">Tournaments Held</span>
        </div>
    </div>
</section>

<!-- ============ WELCOME ============ -->
<section class="section welcome-section">
    <div class="container">
        <div class="welcome-grid">
            <div class="welcome-text animate-up">
                <div class="section-header" style="text-align:left;">
                    <span class="section-tag">About Us</span>
                    <h2>Welcome to<br><span>The Last Pawn</span></h2>
                    <div class="gold-line" style="margin-left:0;"></div>
                </div>
                <p>The Last Pawn Chess Academy is a premier institution dedicated to nurturing strategic minds through the ancient art of chess. Whether you're a complete beginner or an aspiring grandmaster, we have the resources and expert coaching to elevate your game.</p>
                <p>Our academy combines traditional chess wisdom with modern teaching techniques, interactive puzzles, and competitive tournaments — creating a complete chess learning ecosystem for players of all levels.</p>
                <p>Named after the most underestimated piece on the board, we believe that the smallest move can change everything. <strong>Every pawn has the potential to become a queen.</strong></p>
                <a href="about.jsp" class="btn btn-primary mt-3">Learn More About Us</a>
            </div>
            <div class="animate-up delay-2">
                <div class="pawn-chess-board">
                    <%
                    // Generate an 8x8 chessboard with some pieces displayed using Unicode
                    String[][] pieces = {
                        {"♜","♞","♝","♛","♚","♝","♞","♜"},
                        {"♟","♟","♟","♟","♟","♟","♟","♟"},
                        {"","","","","","","",""},
                        {"","","","","","","",""},
                        {"","","","","♙","","",""},
                        {"","","","","","","",""},
                        {"♙","♙","♙","♙","","♙","♙","♙"},
                        {"♖","♘","♗","♕","♔","♗","♘","♖"}
                    };
                    for (int r = 0; r < 8; r++) {
                        for (int c = 0; c < 8; c++) {
                            String sqClass = ((r + c) % 2 == 0) ? "light" : "dark";
                            String piece = pieces[r][c];
                            if (r == 4 && c == 4) sqClass += " gold-sq"; // highlight center pawn
                    %>
                    <div class="sq <%= sqClass %>" title="<%= piece.isEmpty() ? "" : piece %>">
                        <% if (!piece.isEmpty()) { %>
                        <span style="font-size:1.6rem;line-height:1;"><%= piece %></span>
                        <% } %>
                    </div>
                    <% }} %>
                </div>
                <p style="text-align:center;color:var(--grey);font-size:0.8rem;margin-top:0.75rem;font-style:italic;">
                    ♟ The highlighted pawn — the game-changer
                </p>
            </div>
        </div>
    </div>
</section>

<!-- ============ WHY CHOOSE ============ -->
<section class="section section-light">
    <div class="container">
        <div class="section-header">
            <span class="section-tag">Why Us</span>
            <h2>Why Choose Our <span>Academy?</span></h2>
            <div class="gold-line"></div>
            <p>We offer a comprehensive chess education with everything you need to succeed</p>
        </div>
        <div class="why-grid">
            <div class="why-card animate-up delay-1">
                <div class="why-icon">🎓</div>
                <h3>Professional Coaching</h3>
                <p>Learn from certified chess coaches with national and international experience in competitive chess.</p>
            </div>
            <div class="why-card animate-up delay-2">
                <div class="why-icon">🧩</div>
                <h3>Strategic Thinking</h3>
                <p>Develop deep strategic thinking skills that go beyond the board and help in real-life decision making.</p>
            </div>
            <div class="why-card animate-up delay-3">
                <div class="why-icon">⚡</div>
                <h3>Interactive Practice</h3>
                <p>Engage with interactive puzzles, daily challenges, and practice positions tailored to your level.</p>
            </div>
            <div class="why-card animate-up delay-1">
                <div class="why-icon">🏆</div>
                <h3>Tournament Opportunities</h3>
                <p>Participate in regular academy tournaments and prepare for external competitive chess events.</p>
            </div>
            <div class="why-card animate-up delay-2">
                <div class="why-icon">📚</div>
                <h3>Rich Learning Resources</h3>
                <p>Access our comprehensive chess library with PDF materials, video tutorials, and opening databases.</p>
            </div>
            <div class="why-card animate-up delay-3">
                <div class="why-icon">📊</div>
                <h3>Progress Tracking</h3>
                <p>Monitor your improvement with tactical challenges, accuracy scores, and ranked leaderboards.</p>
            </div>
        </div>
    </div>
</section>

<!-- ============ FEATURED COURSES ============ -->
<section class="section section-dark">
    <div class="container">
        <div class="section-header light">
            <span class="section-tag">Education</span>
            <h2>Featured <span>Chess Courses</span></h2>
            <div class="gold-line"></div>
            <p>Structured learning paths for every skill level</p>
        </div>
        <div class="courses-grid">
            <div class="course-card animate-up delay-1">
                <div class="course-img">♙</div>
                <div class="course-body">
                    <span class="badge badge-beginner mb-2">Beginner</span>
                    <h3>Chess Fundamentals</h3>
                    <p>Learn the rules, piece movements, basic tactics, and foundational strategies to start winning.</p>
                </div>
                <div class="course-footer">
                    <span style="color:var(--grey);font-size:0.8rem;">📖 12 Lessons</span>
                    <a href="courses.jsp" class="btn btn-sm btn-primary">Enroll →</a>
                </div>
            </div>
            <div class="course-card animate-up delay-2">
                <div class="course-img">♗</div>
                <div class="course-body">
                    <span class="badge badge-intermediate mb-2">Intermediate</span>
                    <h3>Chess Tactics Mastery</h3>
                    <p>Study tactical patterns: forks, pins, skewers, discovered attacks, and combinations.</p>
                </div>
                <div class="course-footer">
                    <span style="color:var(--grey);font-size:0.8rem;">📖 18 Lessons</span>
                    <a href="courses.jsp" class="btn btn-sm btn-primary">Enroll →</a>
                </div>
            </div>
            <div class="course-card animate-up delay-3">
                <div class="course-img">♛</div>
                <div class="course-body">
                    <span class="badge badge-advanced mb-2">Advanced</span>
                    <h3>Grandmaster Strategy</h3>
                    <p>Deep dive into positional play, endgame technique, opening preparation, and tournament strategy.</p>
                </div>
                <div class="course-footer">
                    <span style="color:var(--grey);font-size:0.8rem;">📖 24 Lessons</span>
                    <a href="courses.jsp" class="btn btn-sm btn-primary">Enroll →</a>
                </div>
            </div>
        </div>
        <div class="text-center mt-4">
            <a href="courses.jsp" class="btn btn-secondary">View All Courses</a>
        </div>
    </div>
</section>

<!-- ============ FEATURED PUZZLES ============ -->
<section class="section section-light">
    <div class="container">
        <div class="section-header">
            <span class="section-tag">Practice</span>
            <h2>Featured <span>Chess Puzzles</span></h2>
            <div class="gold-line"></div>
            <p>Sharpen your tactical vision with our curated puzzle collection</p>
        </div>
        <div class="puzzles-grid">
            <div class="puzzle-card animate-up delay-1">
                <div class="puzzle-icon">⚡</div>
                <h3>Daily Puzzle</h3>
                <p>A fresh tactical challenge every day to keep your chess sharp and your mind active.</p>
                <a href="challenge.jsp" class="btn btn-sm btn-primary">Solve Now</a>
            </div>
            <div class="puzzle-card animate-up delay-2">
                <div class="puzzle-icon">🎯</div>
                <h3>Tactical Patterns</h3>
                <p>Master essential patterns: forks, pins, discovered attacks, back rank mates, and more.</p>
                <a href="challenge.jsp" class="btn btn-sm btn-secondary">Practice</a>
            </div>
            <div class="puzzle-card animate-up delay-3">
                <div class="puzzle-icon">🏅</div>
                <h3>Puzzle Rush</h3>
                <p>Test your speed and accuracy. Solve as many puzzles as possible to climb the leaderboard.</p>
                <a href="leaderboard.jsp" class="btn btn-sm btn-secondary">Leaderboard</a>
            </div>
        </div>
    </div>
</section>

<!-- ============ UPCOMING TOURNAMENTS ============ -->
<section class="section section-charcoal">
    <div class="container">
        <div class="section-header light">
            <span class="section-tag">Competition</span>
            <h2>Upcoming <span>Tournaments</span></h2>
            <div class="gold-line"></div>
            <p>Compete against fellow academy members and prove your skills</p>
        </div>
        <div class="tournament-list animate-up">
            <div class="tournament-item">
                <div class="tournament-date">
                    <span class="day">15</span>
                    <span class="month">Nov</span>
                </div>
                <div class="tournament-info">
                    <h3>Academy Rapid Championship 2026</h3>
                    <p>⏱ Rapid (15+10) &nbsp;|&nbsp; 🏆 Open Category &nbsp;|&nbsp; 📍 Main Hall</p>
                </div>
                <span class="status-upcoming">Upcoming</span>
            </div>
            <div class="tournament-item">
                <div class="tournament-date">
                    <span class="day">05</span>
                    <span class="month">Nov</span>
                </div>
                <div class="tournament-info">
                    <h3>Blitz Battle — Monthly Series</h3>
                    <p>⏱ Blitz (5+0) &nbsp;|&nbsp; 🏆 Open Category &nbsp;|&nbsp; 🌐 Online</p>
                </div>
                <span class="status-ongoing">Ongoing</span>
            </div>
            <div class="tournament-item">
                <div class="tournament-date">
                    <span class="day">20</span>
                    <span class="month">Nov</span>
                </div>
                <div class="tournament-info">
                    <h3>Juniors Chess Championship</h3>
                    <p>⏱ Classical (60+30) &nbsp;|&nbsp; 🏆 Under-18 &nbsp;|&nbsp; 📍 Training Room</p>
                </div>
                <span class="status-upcoming">Upcoming</span>
            </div>
        </div>
        <div class="text-center mt-4">
            <a href="tournaments.jsp" class="btn btn-primary">View All Tournaments</a>
        </div>
    </div>
</section>

<!-- ============ STUDENT ACHIEVEMENTS ============ -->
<section class="section section-dark">
    <div class="container">
        <div class="section-header light">
            <span class="section-tag">Pride</span>
            <h2>Student <span>Achievements</span></h2>
            <div class="gold-line"></div>
        </div>
        <div class="achievements-grid">
            <div class="achievement-card animate-up delay-1">
                <div class="trophy">🥇</div>
                <h4>State Champions</h4>
                <p>12 students won state-level chess championships in 2026</p>
            </div>
            <div class="achievement-card animate-up delay-2">
                <div class="trophy">🌟</div>
                <h4>National Titles</h4>
                <p>4 students achieved national ranking titles this year</p>
            </div>
            <div class="achievement-card animate-up delay-3">
                <div class="trophy">🎓</div>
                <h4>FIDE Rated Players</h4>
                <p>28 students now hold official FIDE ratings</p>
            </div>
            <div class="achievement-card animate-up delay-4">
                <div class="trophy">⚡</div>
                <h4>Tactical Accuracy</h4>
                <p>Average puzzle accuracy improved by 40% in 3 months</p>
            </div>
        </div>
    </div>
</section>

<!-- ============ CTA ============ -->
<section class="cta-section">
    <div class="container" style="position:relative;z-index:2;">
        <span class="section-tag" style="margin-bottom:1rem;">Start Today</span>
        <h2>Ready to Make Your<br><span>Last Pawn Move?</span></h2>
        <p>Join hundreds of students who transformed their chess game at The Last Pawn Chess Academy.</p>
        <div class="cta-buttons">
            <a href="register.jsp" class="btn btn-primary btn-lg">Join the Academy Free</a>
            <a href="coaching.jsp" class="btn btn-secondary btn-lg">Meet Our Coaches</a>
        </div>
    </div>
</section>

<%@ include file="footer.jsp" %>

<script src="js/main.js"></script>
</body>
</html>
