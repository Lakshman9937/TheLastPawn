<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.lastpawn.db.DBConnection" %>
<%
    request.setAttribute("currentPage", "courses");
    String filterDiff = request.getParameter("level");
    if (filterDiff == null) filterDiff = "All";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Curated Chess Courses — The Last Pawn Chess Academy</title>
    <link rel="icon" type="image/png" href="images/CHESS%20LOGO.png">
    <link rel="stylesheet" href="css/style.css">
    <style>
        .filter-bar {
            display: flex;
            justify-content: center;
            gap: 0.8rem;
            margin: 2rem 0 3rem;
            flex-wrap: wrap;
        }
        .filter-btn {
            background: #FFFFFF;
            border: 1.5px solid rgba(214,163,74,0.3);
            padding: 0.6rem 1.4rem;
            border-radius: 30px;
            font-size: 0.88rem;
            font-weight: 600;
            color: var(--charcoal);
            text-decoration: none;
            transition: all 0.25s ease;
        }
        .filter-btn:hover, .filter-btn.active {
            background: var(--gold);
            color: #1a1815;
            border-color: var(--gold);
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(214,163,74,0.3);
        }
        .courses-catalog {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(330px, 1fr));
            gap: 2rem;
        }
        .course-card-modern {
            background: #FFFFFF;
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 8px 30px rgba(0,0,0,0.06);
            border: 1px solid rgba(214,163,74,0.2);
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            transition: all 0.3s ease;
        }
        .course-card-modern:hover {
            transform: translateY(-8px);
            box-shadow: 0 16px 40px rgba(214,163,74,0.2);
            border-color: var(--gold);
        }
        .course-thumb {
            height: 180px;
            background: linear-gradient(135deg, #1b1917, #262421);
            position: relative;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 5rem;
            color: var(--gold);
            border-bottom: 2px solid var(--gold);
        }
        .course-badge-level {
            position: absolute;
            top: 15px; right: 15px;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        .level-beginner { background: rgba(129,182,76,0.9); color: #fff; }
        .level-intermediate { background: rgba(214,163,74,0.9); color: #1a1815; }
        .level-advanced { background: rgba(220,53,69,0.9); color: #fff; }
        .course-content {
            padding: 1.8rem;
            flex: 1;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }
        .course-title {
            font-size: 1.25rem;
            font-weight: 800;
            color: var(--charcoal);
            margin-bottom: 0.75rem;
        }
        .course-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-top: 1rem;
            border-top: 1px solid rgba(0,0,0,0.06);
            margin-top: 1.2rem;
            font-size: 0.85rem;
            color: var(--grey);
        }
    </style>
</head>
<body>

<%@ include file="navbar.jsp" %>

<!-- Header Banner -->
<header class="page-header" style="background: linear-gradient(135deg, #1b1917, #262421); padding: 70px 20px; text-align: center; border-bottom: 3px solid var(--gold);">
    <div class="container">
        <span class="section-tag">Structured Curriculum</span>
        <h1 style="font-size: 3rem; font-weight: 900; color: #FFFFFF; margin: 0.5rem 0;">ACADEMY <span style="color:var(--gold);">COURSES</span></h1>
        <p style="color: var(--off-white); max-width: 650px; margin: 0.8rem auto 0; font-size: 1.05rem;">
            Step-by-step masterclasses designed to take your chess ability from novice fundamentals to tournament-winning mastery.
        </p>
    </div>
</header>

<section class="section section-light">
    <div class="container">
        <!-- Filter Tabs -->
        <div class="filter-bar">
            <a href="courses.jsp" class="filter-btn <%= "All".equals(filterDiff) ? "active" : "" %>">All Courses</a>
            <a href="courses.jsp?level=Beginner" class="filter-btn <%= "Beginner".equalsIgnoreCase(filterDiff) ? "active" : "" %>">Beginner</a>
            <a href="courses.jsp?level=Intermediate" class="filter-btn <%= "Intermediate".equalsIgnoreCase(filterDiff) ? "active" : "" %>">Intermediate</a>
            <a href="courses.jsp?level=Advanced" class="filter-btn <%= "Advanced".equalsIgnoreCase(filterDiff) ? "active" : "" %>">Advanced</a>
        </div>

        <div class="courses-catalog">
            <%
                boolean foundCourses = false;
                String query = "SELECT course_id, title, description, difficulty, lessons_count FROM courses WHERE is_published = 1";
                if (!"All".equals(filterDiff)) {
                    query += " AND difficulty = ?";
                }
                query += " ORDER BY course_id ASC";

                try (Connection con = DBConnection.getConnection();
                     PreparedStatement stmt = con.prepareStatement(query)) {
                    
                    if (!"All".equals(filterDiff)) {
                        stmt.setString(1, filterDiff);
                    }

                    try (ResultSet rs = stmt.executeQuery()) {
                        while (rs.next()) {
                            foundCourses = true;
                            int cId = rs.getInt("course_id");
                            String cTitle = rs.getString("title");
                            String cDesc = rs.getString("description");
                            String cDiff = rs.getString("difficulty");
                            int cLessons = rs.getInt("lessons_count");

                            String pieceSymbol = "♙";
                            String levelClass = "level-beginner";
                            if ("Intermediate".equalsIgnoreCase(cDiff)) {
                                pieceSymbol = "♘";
                                levelClass = "level-intermediate";
                            } else if ("Advanced".equalsIgnoreCase(cDiff)) {
                                pieceSymbol = "♛";
                                levelClass = "level-advanced";
                            }
            %>
            <div class="course-card-modern">
                <div class="course-thumb">
                    <span><%= pieceSymbol %></span>
                    <span class="course-badge-level <%= levelClass %>"><%= cDiff %></span>
                </div>
                <div class="course-content">
                    <div>
                        <h3 class="course-title"><%= cTitle %></h3>
                        <p style="color:var(--grey);font-size:0.9rem;line-height:1.6;margin-bottom:1rem;"><%= cDesc %></p>
                    </div>
                    <div>
                        <div class="course-meta">
                            <span>📖 <%= cLessons %> Intensive Lessons</span>
                            <span style="color:var(--sage);font-weight:700;">Full Access</span>
                        </div>
                        <a href="register.jsp?course=<%= java.net.URLEncoder.encode(cTitle, "UTF-8") %>" class="btn btn-primary btn-block mt-3">Enroll in Course →</a>
                    </div>
                </div>
            </div>
            <%
                        }
                    }
                } catch (Exception e) {
                    // Fallback handled below
                }

                if (!foundCourses) {
            %>
            <!-- Static Courses if DB is initializing -->
            <div class="course-card-modern">
                <div class="course-thumb">
                    <span>♙</span>
                    <span class="course-badge-level level-beginner">Beginner</span>
                </div>
                <div class="course-content">
                    <div>
                        <h3 class="course-title">Beginner Chess Course</h3>
                        <p style="color:var(--grey);font-size:0.9rem;line-height:1.6;">Board setup, piece values, rules of movement, castling, and standard checkmating motifs.</p>
                    </div>
                    <div>
                        <div class="course-meta">
                            <span>📖 12 Lessons</span>
                            <span style="color:var(--sage);font-weight:700;">Certificate Included</span>
                        </div>
                        <a href="register.jsp" class="btn btn-primary btn-block mt-3">Enroll in Course →</a>
                    </div>
                </div>
            </div>
            <div class="course-card-modern">
                <div class="course-thumb">
                    <span>♘</span>
                    <span class="course-badge-level level-intermediate">Intermediate</span>
                </div>
                <div class="course-content">
                    <div>
                        <h3 class="course-title">Chess Tactics Mastery</h3>
                        <p style="color:var(--grey);font-size:0.9rem;line-height:1.6;">Forks, pins, skewers, deflection, discovered attacks, and combinatorial play.</p>
                    </div>
                    <div>
                        <div class="course-meta">
                            <span>📖 18 Lessons</span>
                            <span style="color:var(--sage);font-weight:700;">Certificate Included</span>
                        </div>
                        <a href="register.jsp" class="btn btn-primary btn-block mt-3">Enroll in Course →</a>
                    </div>
                </div>
            </div>
            <div class="course-card-modern">
                <div class="course-thumb">
                    <span>♛</span>
                    <span class="course-badge-level level-advanced">Advanced</span>
                </div>
                <div class="course-content">
                    <div>
                        <h3 class="course-title">Tournament Preparation & Strategy</h3>
                        <p style="color:var(--grey);font-size:0.9rem;line-height:1.6;">Time management under clock pressure, opening preparation against opponents, and deep calculation.</p>
                    </div>
                    <div>
                        <div class="course-meta">
                            <span>📖 24 Lessons</span>
                            <span style="color:var(--sage);font-weight:700;">Certificate Included</span>
                        </div>
                        <a href="register.jsp" class="btn btn-primary btn-block mt-3">Enroll in Course →</a>
                    </div>
                </div>
            </div>
            <% } %>
        </div>
    </div>
</section>

<%@ include file="footer.jsp" %>
<script src="js/main.js"></script>
</body>
</html>
