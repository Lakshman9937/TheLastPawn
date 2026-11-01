<!-- FILE: about.jsp -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    request.setAttribute("currentPage", "about");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>About Us — The Last Pawn Chess Academy</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">
    <style>
        /* ---- About Page specific styles ---- */
        .about-intro-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 2.5rem;
            align-items: center;
        }
        @media (max-width: 768px) {
            .about-intro-grid { grid-template-columns: 1fr; }
        }
        .about-intro-text h3 {
            font-size: 1.7rem;
            font-weight: 800;
            color: var(--off-white);
            margin-bottom: 1rem;
            line-height: 1.25;
        }
        .about-intro-text h3 span { color: var(--gold); }
        .about-intro-text p {
            color: rgba(247,247,245,0.72);
            font-size: 0.97rem;
            line-height: 1.8;
            margin-bottom: 1rem;
        }
        .about-intro-visual {
            position: relative;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .board-visual {
            width: 260px;
            height: 260px;
            display: grid;
            grid-template-columns: repeat(8, 1fr);
            grid-template-rows: repeat(8, 1fr);
            border: 3px solid var(--gold);
            border-radius: 4px;
            overflow: hidden;
            box-shadow: 0 12px 40px rgba(214,163,74,0.2);
        }
        .board-cell { aspect-ratio: 1; }
        .board-cell.light { background: #f0d9b5; }
        .board-cell.dark  { background: #b58863; }
        .chess-pieces-display {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            font-size: 3rem;
            color: var(--charcoal);
            text-shadow: 1px 1px 0 rgba(255,255,255,0.4);
            letter-spacing: 4px;
        }
        /* Mission / Vision */
        .mv-card {
            background: rgba(49,46,43,0.8);
            border-radius: var(--radius-lg);
            padding: 2.5rem;
            border: 1px solid rgba(214,163,74,0.2);
            height: 100%;
            transition: all var(--transition);
        }
        .mv-card:hover {
            border-color: var(--gold);
            transform: translateY(-4px);
            box-shadow: 0 16px 40px rgba(0,0,0,0.3);
        }
        .mv-card .mv-icon {
            font-size: 2.8rem;
            margin-bottom: 1rem;
        }
        .mv-card h3 {
            font-size: 1.3rem;
            font-weight: 800;
            color: var(--gold);
            margin-bottom: 1rem;
            padding-bottom: 0.6rem;
            border-bottom: 1px solid rgba(214,163,74,0.25);
        }
        .mv-card p {
            color: rgba(247,247,245,0.72);
            font-size: 0.93rem;
            line-height: 1.75;
        }
        .mv-card ul {
            margin-top: 1rem;
            padding-left: 0;
        }
        .mv-card ul li {
            color: rgba(247,247,245,0.72);
            font-size: 0.9rem;
            padding: 0.35rem 0;
            border-bottom: 1px solid rgba(255,255,255,0.05);
            display: flex;
            align-items: flex-start;
            gap: 8px;
        }
        .mv-card ul li::before {
            content: '♟';
            color: var(--gold);
            flex-shrink: 0;
            font-size: 0.85rem;
        }
        /* Benefits Cards */
        .benefit-card {
            background: var(--white);
            border-radius: var(--radius-lg);
            padding: 2rem;
            border-top: 4px solid var(--gold);
            box-shadow: 0 4px 20px rgba(0,0,0,0.07);
            transition: all var(--transition);
            text-align: center;
        }
        .benefit-card:nth-child(2) { border-top-color: var(--sage); }
        .benefit-card:nth-child(3) { border-top-color: #8B6FCB; }
        .benefit-card:hover {
            transform: translateY(-6px);
            box-shadow: 0 16px 40px rgba(0,0,0,0.13);
        }
        .benefit-icon {
            font-size: 3rem;
            margin-bottom: 1rem;
            display: block;
        }
        .benefit-card h3 {
            font-size: 1.1rem;
            font-weight: 800;
            color: var(--charcoal);
            margin-bottom: 0.75rem;
        }
        .benefit-card p {
            color: var(--grey);
            font-size: 0.9rem;
            line-height: 1.7;
        }
        .benefit-card .benefit-stats {
            margin-top: 1.2rem;
            background: rgba(214,163,74,0.08);
            border-radius: var(--radius);
            padding: 0.6rem 1rem;
            font-size: 0.82rem;
            font-weight: 700;
            color: var(--gold-dark);
        }
        /* Teaching Steps */
        .steps-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 0;
            position: relative;
        }
        @media (max-width: 900px) {
            .steps-grid { grid-template-columns: repeat(2, 1fr); }
        }
        @media (max-width: 540px) {
            .steps-grid { grid-template-columns: 1fr; }
        }
        .step-item {
            padding: 2rem 1.5rem;
            text-align: center;
            position: relative;
            border-right: 1px solid rgba(214,163,74,0.15);
        }
        .step-item:last-child { border-right: none; }
        .step-number {
            width: 56px;
            height: 56px;
            background: linear-gradient(135deg, var(--gold), var(--gold-dark));
            color: var(--charcoal);
            border-radius: 50%;
            font-size: 1.3rem;
            font-weight: 900;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1.2rem;
            box-shadow: 0 4px 14px rgba(214,163,74,0.4);
        }
        .step-item h4 {
            font-size: 1rem;
            font-weight: 800;
            color: var(--off-white);
            margin-bottom: 0.6rem;
        }
        .step-item p {
            font-size: 0.87rem;
            color: rgba(247,247,245,0.62);
            line-height: 1.65;
        }
        /* Highlights / Stats */
        .highlight-stat {
            text-align: center;
            padding: 2rem 1rem;
        }
        .highlight-stat .stat-num {
            font-size: 3.5rem;
            font-weight: 900;
            color: var(--gold);
            line-height: 1;
            margin-bottom: 0.4rem;
            display: block;
        }
        .highlight-stat .stat-desc {
            font-size: 0.88rem;
            color: rgba(247,247,245,0.65);
            text-transform: uppercase;
            letter-spacing: 1.5px;
            font-weight: 600;
        }
        .highlight-stat .stat-icon {
            font-size: 2rem;
            margin-bottom: 0.8rem;
            display: block;
        }
        /* Gold separator */
        .gold-separator {
            width: 100%;
            height: 2px;
            background: linear-gradient(90deg, transparent, var(--gold), transparent);
            margin: 0;
            opacity: 0.4;
        }
        /* Team teaser */
        .team-note {
            background: rgba(214,163,74,0.07);
            border: 1px solid rgba(214,163,74,0.2);
            border-radius: var(--radius-lg);
            padding: 2rem;
            text-align: center;
        }
        .team-note p {
            color: rgba(247,247,245,0.75);
            font-size: 0.95rem;
            line-height: 1.7;
            margin-bottom: 1rem;
        }
    </style>
</head>
<body class="page-offset">

    <%-- Navbar --%>
    <%@ include file="navbar.jsp" %>

    <%-- ======================================================
         PAGE HERO
         ====================================================== --%>
    <section class="page-hero">
        <div class="container">
            <div class="chess-divider" style="margin-bottom:1rem;">♙ ♘ ♗ ♖ ♕ ♔</div>
            <h1>About <span>The Last Pawn</span> Chess Academy</h1>
            <p>Where passion for chess meets world-class coaching — nurturing strategic minds, one move at a time.</p>
            <div class="chess-divider" style="margin-top:1.2rem;">♟ ♞ ♝ ♜ ♛ ♚</div>
        </div>
    </section>

    <%-- ======================================================
         ABOUT THE ACADEMY — Intro
         ====================================================== --%>
    <section class="section section-dark">
        <div class="container">
            <div class="about-intro-grid">
                <div class="about-intro-text animate-up">
                    <span class="badge badge-gold" style="margin-bottom:1rem;font-size:0.72rem;letter-spacing:2px;">Est. 2020</span>
                    <h3>A <span>Legacy of Excellence</span> on Every Board</h3>
                    <p>
                        The Last Pawn Chess Academy was founded on a simple belief: every player — from a curious beginner
                        taking their first step on the 64 squares, to a seasoned competitor chasing titles — deserves
                        world-class guidance, structured training, and a thriving chess community.
                    </p>
                    <p>
                        Our name is a tribute to the quiet power of the pawn — often underestimated, yet capable of
                        becoming anything on the board. We believe every student carries that same transformative potential.
                    </p>
                    <p>
                        Since 2020 we have grown from a local coaching circle to a full-fledged academy serving hundreds
                        of students across all ages and skill levels, delivering structured courses, live coaching,
                        puzzle challenges, and competitive tournaments.
                    </p>
                    <a href="<%=request.getContextPath()%>/coaching.jsp" class="btn btn-primary btn-sm" style="margin-top:0.5rem;">
                        Explore Coaching →
                    </a>
                </div>

                <div class="about-intro-visual animate-up delay-2">
                    <div class="board-visual" id="chessboardDeco"></div>
                </div>
            </div>
        </div>
    </section>

    <div class="gold-separator"></div>

    <%-- ======================================================
         MISSION & VISION
         ====================================================== --%>
    <section class="section section-charcoal">
        <div class="container">
            <div class="section-header light">
                <span class="section-tag">Purpose &amp; Direction</span>
                <h2>Our <span>Mission</span> &amp; Vision</h2>
                <div class="gold-line"></div>
                <p>Every great move starts with a clear goal. Here is ours.</p>
            </div>

            <div class="grid-2">
                <div class="mv-card animate-up">
                    <div class="mv-icon">🎯</div>
                    <h3>Our Mission</h3>
                    <p>
                        To make chess education accessible, engaging, and transformative for every student —
                        providing a structured learning environment where analytical thinking, creative
                        problem-solving, and competitive spirit flourish together.
                    </p>
                    <ul>
                        <li>Deliver high-quality, structured chess curriculum</li>
                        <li>Build a supportive, inclusive learning community</li>
                        <li>Provide pathways from beginner to competitive play</li>
                        <li>Foster life skills through chess: patience, focus, strategy</li>
                    </ul>
                </div>

                <div class="mv-card animate-up delay-2">
                    <div class="mv-icon">🌟</div>
                    <h3>Our Vision</h3>
                    <p>
                        To be the most respected chess academy in the region — recognised not only for producing
                        skilled players and champions, but for developing thoughtful, resilient, and strategic
                        thinkers who carry the lessons of chess into every area of their lives.
                    </p>
                    <ul>
                        <li>Be a nationally recognised chess institution</li>
                        <li>Host premier regional and national tournaments</li>
                        <li>Produce Fide-rated players and national champions</li>
                        <li>Expand online reach to students across the globe</li>
                    </ul>
                </div>
            </div>
        </div>
    </section>

    <div class="gold-separator"></div>

    <%-- ======================================================
         WHY CHESS MATTERS
         ====================================================== --%>
    <section class="section section-light">
        <div class="container">
            <div class="section-header">
                <span class="section-tag">Benefits of Chess</span>
                <h2>Why <span>Chess Matters</span></h2>
                <div class="gold-line"></div>
                <p>Chess is far more than a game — it is a lifelong mental discipline with proven cognitive benefits.</p>
            </div>

            <div class="grid-3">
                <%-- Card 1: Cognitive --%>
                <div class="benefit-card animate-up">
                    <span class="benefit-icon">🧠</span>
                    <h3>Cognitive Development</h3>
                    <p>
                        Chess activates both hemispheres of the brain simultaneously. Regular play improves
                        memory retention, pattern recognition, and logical reasoning — skills that translate
                        directly into academic and professional excellence.
                    </p>
                    <div class="benefit-stats">📊 Studies show 17% improvement in maths scores for chess players</div>
                </div>

                <%-- Card 2: Focus --%>
                <div class="benefit-card animate-up delay-2">
                    <span class="benefit-icon">🎯</span>
                    <h3>Focus &amp; Concentration</h3>
                    <p>
                        Every chess game demands sustained concentration and full attention. Students who
                        study chess consistently demonstrate superior ability to focus on complex tasks,
                        manage time effectively, and maintain composure under pressure.
                    </p>
                    <div class="benefit-stats" style="background:rgba(129,182,76,0.1);color:var(--dark-green);">
                        ⏱ Improves sustained attention by up to 25%
                    </div>
                </div>

                <%-- Card 3: Creativity --%>
                <div class="benefit-card animate-up delay-3">
                    <span class="benefit-icon">💡</span>
                    <h3>Creativity &amp; Innovation</h3>
                    <p>
                        The near-infinite variety of chess positions demands creative thinking, novel
                        approaches, and the courage to try uncharted ideas. Chess players learn to think
                        outside the box and evaluate unconventional solutions confidently.
                    </p>
                    <div class="benefit-stats" style="background:rgba(139,111,203,0.1);color:#6B4FAB;">
                        🎨 Develops divergent thinking &amp; original problem solving
                    </div>
                </div>
            </div>
        </div>
    </section>

    <div class="gold-separator"></div>

    <%-- ======================================================
         TEACHING APPROACH — 4 Steps
         ====================================================== --%>
    <section class="section section-dark">
        <div class="container">
            <div class="section-header light">
                <span class="section-tag">Methodology</span>
                <h2>Our Teaching <span>Approach</span></h2>
                <div class="gold-line"></div>
                <p>A proven four-step framework that takes you from your first piece to your best game.</p>
            </div>

            <div class="steps-grid">
                <div class="step-item animate-up">
                    <div class="step-number">1</div>
                    <h4>Assess &amp; Diagnose</h4>
                    <p>
                        Every student begins with a thorough skill assessment. We identify strengths,
                        weaknesses, learning style, and goals to tailor a personalised study plan.
                    </p>
                </div>
                <div class="step-item animate-up delay-1">
                    <div class="step-number">2</div>
                    <h4>Structured Learning</h4>
                    <p>
                        Guided through a progressive curriculum — openings, tactics, strategy, endgames —
                        with expert-curated materials, puzzles, and interactive lessons at every stage.
                    </p>
                </div>
                <div class="step-item animate-up delay-2">
                    <div class="step-number">3</div>
                    <h4>Practice &amp; Analysis</h4>
                    <p>
                        Students apply knowledge through live games and our puzzle engine, then conduct
                        deep post-game analysis with coaches to understand every decision and its outcome.
                    </p>
                </div>
                <div class="step-item animate-up delay-3" style="border-right:none;">
                    <div class="step-number">4</div>
                    <h4>Compete &amp; Grow</h4>
                    <p>
                        Internal and external tournaments expose students to competitive pressure. We
                        track rating progress, celebrate milestones, and continuously refine the plan.
                    </p>
                </div>
            </div>
        </div>
    </section>

    <div class="gold-separator"></div>

    <%-- ======================================================
         ACADEMY HIGHLIGHTS — Stats
         ====================================================== --%>
    <section class="section section-charcoal">
        <div class="container">
            <div class="section-header light">
                <span class="section-tag">By the Numbers</span>
                <h2>Academy <span>Highlights</span></h2>
                <div class="gold-line"></div>
                <p>Numbers that speak to our commitment to excellence and our growing community.</p>
            </div>

            <div class="grid-4" style="margin-bottom:3rem;">
                <div class="highlight-stat animate-up">
                    <span class="stat-icon">📅</span>
                    <span class="stat-num">2020</span>
                    <span class="stat-desc">Founded</span>
                </div>
                <div class="highlight-stat animate-up delay-1">
                    <span class="stat-icon">👥</span>
                    <span class="stat-num">500+</span>
                    <span class="stat-desc">Students Trained</span>
                </div>
                <div class="highlight-stat animate-up delay-2">
                    <span class="stat-icon">🏅</span>
                    <span class="stat-num">20+</span>
                    <span class="stat-desc">Expert Coaches</span>
                </div>
                <div class="highlight-stat animate-up delay-3">
                    <span class="stat-icon">🏆</span>
                    <span class="stat-num">100+</span>
                    <span class="stat-desc">Tournaments Hosted</span>
                </div>
            </div>

            <%-- Additional stats row --%>
            <div class="grid-4">
                <div class="highlight-stat animate-up">
                    <span class="stat-icon">⭐</span>
                    <span class="stat-num">4.9</span>
                    <span class="stat-desc">Average Rating</span>
                </div>
                <div class="highlight-stat animate-up delay-1">
                    <span class="stat-icon">🌐</span>
                    <span class="stat-num">12+</span>
                    <span class="stat-desc">Countries Represented</span>
                </div>
                <div class="highlight-stat animate-up delay-2">
                    <span class="stat-icon">📚</span>
                    <span class="stat-num">50+</span>
                    <span class="stat-desc">Course Modules</span>
                </div>
                <div class="highlight-stat animate-up delay-3">
                    <span class="stat-icon">🧩</span>
                    <span class="stat-num">10K+</span>
                    <span class="stat-desc">Puzzles Solved Daily</span>
                </div>
            </div>
        </div>
    </section>

    <%-- ======================================================
         CTA BAND
         ====================================================== --%>
    <section class="section section-dark" style="padding:3.5rem 2rem;">
        <div class="container" style="text-align:center;">
            <div class="chess-divider" style="margin-bottom:1.5rem;">♟ ♞ ♝ ♜ ♛ ♚</div>
            <h2 style="color:var(--off-white);font-size:2rem;font-weight:800;margin-bottom:0.75rem;">
                Ready to Make Your <span style="color:var(--gold);">Best Move?</span>
            </h2>
            <p style="color:rgba(247,247,245,0.65);margin-bottom:2rem;max-width:520px;margin-left:auto;margin-right:auto;">
                Join The Last Pawn Chess Academy today and begin your journey from your first move to your finest masterpiece.
            </p>
            <div style="display:flex;gap:1rem;justify-content:center;flex-wrap:wrap;">
                <a href="<%=request.getContextPath()%>/register.jsp" class="btn btn-primary btn-lg">Join the Academy</a>
                <a href="<%=request.getContextPath()%>/contact.jsp" class="btn btn-secondary btn-lg">Contact Us</a>
            </div>
        </div>
    </section>

    <%-- Footer --%>
    <%@ include file="footer.jsp" %>

    <script src="<%=request.getContextPath()%>/js/main.js"></script>
    <script>
        /* Build decorative chessboard */
        (function() {
            const board = document.getElementById('chessboardDeco');
            if (!board) return;
            for (let r = 0; r < 8; r++) {
                for (let c = 0; c < 8; c++) {
                    const cell = document.createElement('div');
                    cell.className = 'board-cell ' + ((r + c) % 2 === 0 ? 'light' : 'dark');
                    board.appendChild(cell);
                }
            }
        })();

        /* Animate stats counting up */
        function animateCount(el, target, suffix) {
            let start = 0;
            const duration = 1800;
            const step = Math.ceil(target / (duration / 16));
            const timer = setInterval(() => {
                start = Math.min(start + step, target);
                el.textContent = (start >= 1000 ? (start / 1000).toFixed(0) + 'K' : start) + (suffix || '');
                if (start >= target) clearInterval(timer);
            }, 16);
        }

        /* Trigger on scroll into view */
        const statNums = document.querySelectorAll('.stat-num');
        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    observer.unobserve(entry.target);
                    const text = entry.target.textContent.trim();
                    const match = text.match(/[\d.]+/);
                    if (match) {
                        const num = parseFloat(match[0]);
                        const suffix = text.replace(/[\d.]+/, '');
                        if (!isNaN(num) && !text.includes('.') && num > 10) {
                            animateCount(entry.target, parseInt(num), suffix);
                        }
                    }
                }
            });
        }, { threshold: 0.3 });
        statNums.forEach(el => observer.observe(el));
    </script>
</body>
</html>
