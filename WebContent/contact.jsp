<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    request.setAttribute("currentPage", "contact");
    String successParam = request.getParameter("success");
    boolean isSuccess = "true".equalsIgnoreCase(successParam);
    String errorParam = request.getParameter("error");
    boolean isError = "true".equalsIgnoreCase(errorParam);
    String programParam = request.getParameter("program");
    String coachParam = request.getParameter("coach");

    String prefillSubject = "";
    if (programParam != null && !programParam.isEmpty()) {
        prefillSubject = "Enquiry regarding " + programParam + " Coaching Program";
    } else if (coachParam != null && !coachParam.isEmpty()) {
        prefillSubject = "Session Request with Coach " + coachParam;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contact Academy & Admissions — The Last Pawn Chess Academy</title>
    <link rel="icon" type="image/png" href="images/CHESS%20LOGO.png">
    <link rel="stylesheet" href="css/style.css">
    <style>
        .contact-layout {
            display: grid;
            grid-template-columns: 1fr 1.3fr;
            gap: 3rem;
            align-items: flex-start;
        }
        @media (max-width: 850px) {
            .contact-layout { grid-template-columns: 1fr; }
        }
        .contact-info-card {
            background: #262421;
            color: #FFFFFF;
            border-radius: 16px;
            padding: 2.5rem;
            border-top: 4px solid var(--gold);
            box-shadow: 0 10px 40px rgba(0,0,0,0.15);
        }
        .contact-form-card {
            background: #FFFFFF;
            border-radius: 16px;
            padding: 2.5rem;
            border: 1px solid rgba(214,163,74,0.3);
            box-shadow: 0 10px 40px rgba(0,0,0,0.06);
        }
        .info-item {
            display: flex;
            align-items: flex-start;
            gap: 16px;
            margin-bottom: 1.8rem;
        }
        .info-icon {
            width: 48px;
            height: 48px;
            border-radius: 12px;
            background: rgba(214,163,74,0.15);
            color: var(--gold);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.4rem;
            flex-shrink: 0;
            border: 1px solid rgba(214,163,74,0.3);
        }
    </style>
</head>
<body>

<%@ include file="navbar.jsp" %>

<!-- Header Banner -->
<header class="page-header" style="background: linear-gradient(135deg, #1b1917, #262421); padding: 70px 20px; text-align: center; border-bottom: 3px solid var(--gold);">
    <div class="container">
        <span class="section-tag">Get in Touch</span>
        <h1 style="font-size: 3rem; font-weight: 900; color: #FFFFFF; margin: 0.5rem 0;">CONTACT <span style="color:var(--gold);">THE ACADEMY</span></h1>
        <p style="color: var(--off-white); max-width: 650px; margin: 0.8rem auto 0; font-size: 1.05rem;">
            Have questions about coaching, enrollment, tournament participation, or private mentorship? Reach out to our admissions team.
        </p>
    </div>
</header>

<section class="section section-light">
    <div class="container">

        <% if (isSuccess) { %>
        <div style="background:#d4edda;color:#155724;border:1.5px solid #c3e6cb;padding:1.2rem;border-radius:12px;margin-bottom:2rem;text-align:center;font-weight:700;">
            ✓ Thank you! Your message has been safely received and stored in our database. An academy coach will reach out to you within 24 hours.
        </div>
        <% } %>

        <% if (isError) { %>
        <div style="background:#f8d7da;color:#721c24;border:1.5px solid #f5c6cb;padding:1.2rem;border-radius:12px;margin-bottom:2rem;text-align:center;">
            Please ensure all fields are filled properly before submitting your enquiry.
        </div>
        <% } %>

        <div class="contact-layout">
            <!-- Academy Info Column -->
            <div class="contact-info-card">
                <span class="section-tag" style="margin-bottom:1rem;">Headquarters</span>
                <h2 style="font-size:1.8rem;font-weight:800;color:var(--gold);margin-bottom:1.5rem;">Academy Information</h2>

                <div class="info-item">
                    <div class="info-icon">♟</div>
                    <div>
                        <strong style="color:var(--gold);display:block;margin-bottom:4px;">Main Campus</strong>
                        <p style="color:var(--off-white);margin:0;font-size:0.92rem;line-height:1.6;">
                            The Last Pawn Chess Academy<br>
                            Mount Zion Campus, Lena Vilakku<br>
                            Pudukkottai – 622 507, Tamil Nadu, India
                        </p>
                    </div>
                </div>

                <div class="info-item">
                    <div class="info-icon">✉</div>
                    <div>
                        <strong style="color:var(--gold);display:block;margin-bottom:4px;">Admissions & Support Email</strong>
                        <p style="color:var(--off-white);margin:0;font-size:0.92rem;">
                            admissions@lastpawnacademy.com<br>
                            info@lastpawnacademy.com
                        </p>
                    </div>
                </div>

                <div class="info-item">
                    <div class="info-icon">☎</div>
                    <div>
                        <strong style="color:var(--gold);display:block;margin-bottom:4px;">Direct Academy Phone</strong>
                        <p style="color:var(--off-white);margin:0;font-size:0.92rem;">
                            +91 98765 43210<br>
                            +91 94432 10987
                        </p>
                    </div>
                </div>

                <div class="info-item">
                    <div class="info-icon">🕐</div>
                    <div>
                        <strong style="color:var(--gold);display:block;margin-bottom:4px;">Training Hours</strong>
                        <p style="color:var(--off-white);margin:0;font-size:0.92rem;line-height:1.6;">
                            Monday – Friday: 9:00 AM – 9:00 PM<br>
                            Saturday: 10:00 AM – 8:00 PM<br>
                            Sunday: 10:00 AM – 6:00 PM (Tournaments)
                        </p>
                    </div>
                </div>
            </div>

            <!-- Contact Form -->
            <div class="contact-form-card">
                <h2 style="font-size:1.8rem;font-weight:800;color:var(--charcoal);margin-bottom:0.5rem;">Send Us a Message</h2>
                <p style="color:var(--grey);font-size:0.92rem;margin-bottom:1.8rem;">
                    Submit your query or coaching request below. All communications are securely routed to our management desk.
                </p>

                <form action="<%=request.getContextPath()%>/ContactServlet" method="POST">
                    <div class="form-group mb-3">
                        <label style="font-size:0.85rem;font-weight:700;color:var(--charcoal);display:block;margin-bottom:6px;">Your Full Name *</label>
                        <input type="text" name="senderName" class="form-control" required placeholder="e.g. Lakshman">
                    </div>
                    <div class="form-group mb-3">
                        <label style="font-size:0.85rem;font-weight:700;color:var(--charcoal);display:block;margin-bottom:6px;">Email Address *</label>
                        <input type="email" name="senderEmail" class="form-control" required placeholder="e.g. laxman@gmail.com">
                    </div>
                    <div class="form-group mb-3">
                        <label style="font-size:0.85rem;font-weight:700;color:var(--charcoal);display:block;margin-bottom:6px;">Subject *</label>
                        <input type="text" name="subject" class="form-control" required placeholder="Subject of your message" value="<%= prefillSubject %>">
                    </div>
                    <div class="form-group mb-3">
                        <label style="font-size:0.85rem;font-weight:700;color:var(--charcoal);display:block;margin-bottom:6px;">Message *</label>
                        <textarea name="message" class="form-control" rows="5" required placeholder="How can our coaches assist you? Describe your chess experience or questions..."></textarea>
                    </div>
                    <button type="submit" class="btn btn-primary btn-block btn-lg" style="margin-top:1.5rem;">
                        Submit Message →
                    </button>
                </form>
            </div>
        </div>

    </div>
</section>

<%@ include file="footer.jsp" %>
<script src="js/main.js"></script>
</body>
</html>
