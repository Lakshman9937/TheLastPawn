<!-- FILE: login.jsp -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login — The Last Pawn Chess Academy</title>
    <link rel="icon" type="image/png" href="<%=request.getContextPath()%>/images/CHESS%20LOGO.png">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">
    <style>
        html, body {
            height: auto !important;
            min-height: 100%;
        }
        body.auth-page {
            min-height: 100vh;
            height: auto !important;
            padding-top: 72px !important;
            display: flex;
            flex-direction: column;
            justify-content: flex-start;
            overflow-y: auto !important;
            overflow-x: hidden;
        }
        .auth-wrapper {
            flex: 1 0 auto;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2.5rem 1rem 3.5rem;
            width: 100%;
            box-sizing: border-box;
        }
        .auth-card {
            width: 100%;
            max-width: 460px;
        }
        .remember-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 0.5rem;
            margin-bottom: 1.5rem;
        }
        .remember-row label {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 0.88rem;
            color: var(--grey);
            cursor: pointer;
            font-weight: 400;
        }
        .remember-row label input[type="checkbox"] {
            accent-color: var(--gold);
            width: 15px;
            height: 15px;
        }
        .forgot-link {
            font-size: 0.85rem;
            color: var(--gold);
            transition: color var(--transition);
        }
        .forgot-link:hover { color: var(--gold-light); text-decoration: underline; }
        .auth-divider {
            display: flex;
            align-items: center;
            gap: 1rem;
            margin: 1.5rem 0;
        }
        .auth-divider span {
            color: var(--grey);
            font-size: 0.8rem;
            white-space: nowrap;
        }
        .auth-divider::before,
        .auth-divider::after {
            content: '';
            flex: 1;
            height: 1px;
            background: rgba(119,118,111,0.35);
        }
        .auth-footer-text {
            text-align: center;
            margin-top: 1.5rem;
            font-size: 0.9rem;
            color: var(--grey);
        }
        .auth-footer-text a {
            color: var(--gold);
            font-weight: 600;
            transition: color var(--transition);
        }
        .auth-footer-text a:hover { color: var(--gold-light); text-decoration: underline; }
        .chess-board-strip {
            display: flex;
            height: 6px;
            border-radius: 0 0 3px 3px;
            overflow: hidden;
            margin-top: 2rem;
        }
        .chess-board-strip span {
            flex: 1;
        }
        .chess-board-strip span:nth-child(odd) { background: var(--charcoal); }
        .chess-board-strip span:nth-child(even) { background: var(--gold); }
        .form-group label {
            color: rgba(247,247,245,0.85);
            font-size: 0.83rem;
            font-weight: 600;
            letter-spacing: 0.4px;
        }
        .input-icon-wrap {
            position: relative;
        }
        .input-icon-wrap .field-icon {
            position: absolute;
            left: 12px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--grey);
            font-size: 1rem;
            pointer-events: none;
        }
        .input-icon-wrap .form-control {
            padding-left: 2.4rem;
        }
        .btn-login-full {
            width: 100%;
            padding: 0.85rem;
            font-size: 0.97rem;
            letter-spacing: 1px;
        }
        .auth-tagline {
            text-align: center;
            color: rgba(119,118,111,0.7);
            font-size: 0.72rem;
            letter-spacing: 3px;
            text-transform: uppercase;
            margin-top: 1.5rem;
        }
    </style>
</head>
<body class="auth-page">

    <%-- Include Navbar --%>
    <%@ include file="navbar.jsp" %>

    <div class="auth-wrapper">
        <div class="auth-card">

            <%-- Logo & Branding --%>
            <div class="auth-logo">
                <img src="<%=request.getContextPath()%>/images/CHESS%20LOGO.png" alt="The Last Pawn Logo">
                <span class="brand-name">The Last Pawn</span>
                <span class="brand-sub">Chess Academy</span>
            </div>

            <h2>Welcome Back</h2>

            <%-- Session / Error Messages --%>
            <%
                String error = request.getParameter("error");
                String success = request.getParameter("success");
                String message = request.getParameter("message");
            %>
            <% if (error != null && !error.isEmpty()) { %>
                <div class="alert alert-error" role="alert">
                    ♟ <%= error.equals("invalid") ? "Invalid username or password. Please try again." :
                           error.equals("session") ? "Your session has expired. Please log in again." :
                           error.equals("access") ? "You must be logged in to access that page." :
                           java.net.URLDecoder.decode(error, "UTF-8") %>
                </div>
            <% } %>
            <% if (success != null && !success.isEmpty()) { %>
                <div class="alert alert-success" role="alert">
                    ✓ <%= java.net.URLDecoder.decode(success, "UTF-8") %>
                </div>
            <% } %>
            <% if (message != null && !message.isEmpty()) { %>
                <div class="alert alert-info" role="alert">
                    ℹ <%= java.net.URLDecoder.decode(message, "UTF-8") %>
                </div>
            <% } %>

            <%-- Login Form --%>
            <form action="<%=request.getContextPath()%>/LoginServlet" method="post" id="loginForm" novalidate>

                <div class="form-group">
                    <label for="username">Username or Email</label>
                    <div class="input-icon-wrap">
                        <span class="field-icon">♟</span>
                        <input
                            type="text"
                            id="username"
                            name="username"
                            class="form-control dark-input"
                            placeholder="Enter your username or email"
                            required
                            autocomplete="username"
                        >
                    </div>
                </div>

                <div class="form-group">
                    <label for="password">Password</label>
                    <div class="input-icon-wrap">
                        <span class="field-icon">🔒</span>
                        <input
                            type="password"
                            id="password"
                            name="password"
                            class="form-control dark-input"
                            placeholder="Enter your password"
                            required
                            autocomplete="current-password"
                        >
                    </div>
                </div>

                <div class="remember-row">
                    <label>
                        <input type="checkbox" name="rememberMe" value="true">
                        Remember me for 30 days
                    </label>
                    <a href="<%=request.getContextPath()%>/forgot-password.jsp" class="forgot-link">Forgot Password?</a>
                </div>

                <button type="submit" class="btn btn-primary btn-login-full">
                    ♟ &nbsp; Login to Academy
                </button>

            </form>

            <div class="auth-divider">
                <span>New to The Last Pawn?</span>
            </div>

            <a href="<%=request.getContextPath()%>/register.jsp" class="btn btn-secondary w-100" style="justify-content:center;">
                Create Your Account
            </a>

            <div class="auth-footer-text">
                By logging in, you agree to our
                <a href="<%=request.getContextPath()%>/terms.jsp">Terms of Service</a>
                &amp;
                <a href="<%=request.getContextPath()%>/privacy.jsp">Privacy Policy</a>
            </div>

            <div class="auth-tagline">Think Better · Play Smarter</div>

            <div class="chess-board-strip">
                <span></span><span></span><span></span><span></span>
                <span></span><span></span><span></span><span></span>
            </div>

        </div>
    </div>

    <%@ include file="footer.jsp" %>

    <script src="<%=request.getContextPath()%>/js/main.js"></script>
</body>
</html>
