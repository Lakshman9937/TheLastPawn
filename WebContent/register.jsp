<!-- FILE: register.jsp -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Join The Academy — The Last Pawn Chess Academy</title>
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
            align-items: flex-start;
            justify-content: center;
            padding: 2.5rem 1rem 3.5rem;
            width: 100%;
            box-sizing: border-box;
        }
        .auth-card {
            width: 100%;
            max-width: 520px;
        }
        .form-grid-2 {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 0 1.2rem;
        }
        @media (max-width: 540px) {
            .form-grid-2 { grid-template-columns: 1fr; }
        }
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
            font-size: 0.95rem;
            pointer-events: none;
        }
        .input-icon-wrap .form-control {
            padding-left: 2.4rem;
        }
        .password-strength {
            height: 4px;
            border-radius: 2px;
            background: rgba(255,255,255,0.1);
            margin-top: 6px;
            overflow: hidden;
        }
        .password-strength-bar {
            height: 100%;
            border-radius: 2px;
            transition: width 0.3s ease, background 0.3s ease;
            width: 0;
        }
        .strength-weak   { width: 25%; background: #e74c3c; }
        .strength-fair   { width: 50%; background: var(--gold); }
        .strength-good   { width: 75%; background: #f0a500; }
        .strength-strong { width: 100%; background: var(--sage); }
        .strength-label {
            font-size: 0.72rem;
            color: var(--grey);
            margin-top: 3px;
        }
        .form-error-msg {
            color: #e74c3c;
            font-size: 0.78rem;
            margin-top: 4px;
            display: none;
        }
        .form-error-msg.visible { display: block; }
        .register-btn {
            width: 100%;
            padding: 0.88rem;
            font-size: 0.97rem;
            letter-spacing: 1px;
            margin-top: 0.5rem;
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
        .chess-board-strip span { flex: 1; }
        .chess-board-strip span:nth-child(odd) { background: var(--charcoal); }
        .chess-board-strip span:nth-child(even) { background: var(--gold); }
        .level-cards {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 0.6rem;
            margin-top: 0.4rem;
        }
        .level-card-label {
            display: block;
            cursor: pointer;
        }
        .level-card-label input[type="radio"] { display: none; }
        .level-card-inner {
            border: 1.5px solid rgba(255,255,255,0.12);
            border-radius: var(--radius);
            padding: 0.7rem 0.8rem;
            transition: all 0.2s ease;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .level-card-label input[type="radio"]:checked + .level-card-inner {
            border-color: var(--gold);
            background: rgba(214,163,74,0.12);
        }
        .level-card-inner:hover {
            border-color: rgba(214,163,74,0.5);
            background: rgba(214,163,74,0.06);
        }
        .level-card-inner .level-icon { font-size: 1.3rem; }
        .level-card-inner .level-text { font-size: 0.82rem; color: var(--off-white); font-weight: 600; }
        .level-card-inner .level-desc { font-size: 0.7rem; color: var(--grey); }
        select.form-control.dark-input option {
            background: var(--charcoal-light);
            color: var(--off-white);
        }
        .section-divider {
            display: flex;
            align-items: center;
            gap: 0.8rem;
            margin: 1.2rem 0 1rem;
        }
        .section-divider span {
            color: var(--gold);
            font-size: 0.72rem;
            font-weight: 700;
            letter-spacing: 2px;
            text-transform: uppercase;
            white-space: nowrap;
        }
        .section-divider::before,
        .section-divider::after {
            content: '';
            flex: 1;
            height: 1px;
            background: rgba(214,163,74,0.2);
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

            <h2>Join the Academy</h2>

            <%-- Error / Success Messages --%>
            <%
                String regError   = request.getParameter("error");
                String regSuccess = request.getParameter("success");
            %>
            <% if (regError != null && !regError.isEmpty()) { %>
                <div class="alert alert-error" role="alert">
                    ✕ &nbsp;<%= java.net.URLDecoder.decode(regError, "UTF-8") %>
                </div>
            <% } %>
            <% if (regSuccess != null && !regSuccess.isEmpty()) { %>
                <div class="alert alert-success" role="alert">
                    ✓ &nbsp;<%= java.net.URLDecoder.decode(regSuccess, "UTF-8") %>
                </div>
            <% } %>

            <%-- Registration Form --%>
            <form action="<%=request.getContextPath()%>/RegisterServlet" method="post"
                  id="registerForm" onsubmit="return validateForm('registerForm')" novalidate>

                <%-- Personal Info --%>
                <div class="section-divider"><span>Personal Info</span></div>

                <div class="form-grid-2">
                    <div class="form-group">
                        <label for="fullName">Full Name</label>
                        <div class="input-icon-wrap">
                            <span class="field-icon">👤</span>
                            <input type="text" id="fullName" name="fullName"
                                   class="form-control dark-input"
                                   placeholder="John Smith" required autocomplete="name">
                        </div>
                        <span class="form-error-msg" id="err-fullName">Please enter your full name.</span>
                    </div>

                    <div class="form-group">
                        <label for="username">Username</label>
                        <div class="input-icon-wrap">
                            <span class="field-icon">♟</span>
                            <input type="text" id="username" name="username"
                                   class="form-control dark-input"
                                   placeholder="chessmaster99" required autocomplete="username"
                                   minlength="3" maxlength="30">
                        </div>
                        <span class="form-error-msg" id="err-username">Username must be 3–30 characters.</span>
                    </div>
                </div>

                <div class="form-grid-2">
                    <div class="form-group">
                        <label for="email">Email Address</label>
                        <div class="input-icon-wrap">
                            <span class="field-icon">✉</span>
                            <input type="email" id="email" name="email"
                                   class="form-control dark-input"
                                   placeholder="you@example.com" required autocomplete="email">
                        </div>
                        <span class="form-error-msg" id="err-email">Please enter a valid email.</span>
                    </div>

                    <div class="form-group">
                        <label for="phone">Phone Number</label>
                        <div class="input-icon-wrap">
                            <span class="field-icon">☎</span>
                            <input type="tel" id="phone" name="phone"
                                   class="form-control dark-input"
                                   placeholder="+91 98765 43210" autocomplete="tel">
                        </div>
                    </div>
                </div>

                <%-- Security --%>
                <div class="section-divider"><span>Security</span></div>

                <div class="form-group">
                    <label for="password">Password</label>
                    <div class="input-icon-wrap">
                        <span class="field-icon">🔒</span>
                        <input type="password" id="password" name="password"
                               class="form-control dark-input"
                               placeholder="Min. 8 characters" required
                               autocomplete="new-password" minlength="8"
                               oninput="checkPasswordStrength(this.value)">
                    </div>
                    <div class="password-strength">
                        <div class="password-strength-bar" id="strengthBar"></div>
                    </div>
                    <div class="strength-label" id="strengthLabel"></div>
                    <span class="form-error-msg" id="err-password">Password must be at least 8 characters.</span>
                </div>

                <div class="form-group">
                    <label for="confirmPassword">Confirm Password</label>
                    <div class="input-icon-wrap">
                        <span class="field-icon">🔑</span>
                        <input type="password" id="confirmPassword" name="confirmPassword"
                               class="form-control dark-input"
                               placeholder="Re-enter your password" required
                               autocomplete="new-password">
                    </div>
                    <span class="form-error-msg" id="err-confirmPassword">Passwords do not match.</span>
                </div>

                <%-- Chess Level --%>
                <div class="section-divider"><span>Chess Experience</span></div>

                <div class="form-group">
                    <label for="experienceLevel">Chess Experience Level</label>
                    <select id="experienceLevel" name="experienceLevel"
                            class="form-control dark-input" required>
                        <option value="" disabled selected>— Select your level —</option>
                        <option value="Beginner">♙ Beginner — Just starting out</option>
                        <option value="Intermediate">♗ Intermediate — Know the rules &amp; basic tactics</option>
                        <option value="Advanced">♖ Advanced — Tournament experience</option>
                        <option value="Expert">♛ Expert — Rated / Competitive player</option>
                    </select>
                    <span class="form-error-msg" id="err-experienceLevel">Please select your experience level.</span>
                </div>

                <%-- Submit --%>
                <button type="submit" class="btn btn-primary register-btn">
                    ♟ &nbsp; Create My Account
                </button>

            </form>

            <div class="auth-footer-text">
                Already have an account? &nbsp;
                <a href="<%=request.getContextPath()%>/login.jsp">Login here</a>
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
    <script>
        /* ---- Client-side validation ---- */
        function validateForm(formId) {
            const form = document.getElementById(formId);
            let valid = true;

            // Helper: show/hide error
            function setError(fieldId, errId, condition) {
                const el  = document.getElementById(fieldId);
                const err = document.getElementById(errId);
                if (!el || !err) return;
                if (condition) {
                    err.classList.add('visible');
                    el.style.borderColor = '#e74c3c';
                    valid = false;
                } else {
                    err.classList.remove('visible');
                    el.style.borderColor = '';
                }
            }

            // Full Name
            const fullName = document.getElementById('fullName');
            setError('fullName', 'err-fullName', !fullName || fullName.value.trim().length < 2);

            // Username
            const username = document.getElementById('username');
            const unVal = username ? username.value.trim() : '';
            setError('username', 'err-username', unVal.length < 3 || unVal.length > 30);

            // Email
            const email = document.getElementById('email');
            const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            setError('email', 'err-email', !email || !emailPattern.test(email.value.trim()));

            // Password
            const password = document.getElementById('password');
            setError('password', 'err-password', !password || password.value.length < 8);

            // Confirm Password
            const confirm = document.getElementById('confirmPassword');
            setError('confirmPassword', 'err-confirmPassword',
                !confirm || confirm.value !== (password ? password.value : ''));

            // Experience Level
            const level = document.getElementById('experienceLevel');
            setError('experienceLevel', 'err-experienceLevel', !level || !level.value);

            return valid;
        }

        /* ---- Password Strength Indicator ---- */
        function checkPasswordStrength(val) {
            const bar   = document.getElementById('strengthBar');
            const label = document.getElementById('strengthLabel');
            if (!bar || !label) return;

            let score = 0;
            if (val.length >= 8)  score++;
            if (val.length >= 12) score++;
            if (/[A-Z]/.test(val) && /[a-z]/.test(val)) score++;
            if (/[0-9]/.test(val)) score++;
            if (/[^A-Za-z0-9]/.test(val)) score++;

            bar.className = 'password-strength-bar';
            if (val.length === 0) {
                bar.style.width = '0';
                label.textContent = '';
            } else if (score <= 1) {
                bar.classList.add('strength-weak');
                label.textContent = 'Weak — add uppercase, numbers, symbols';
                label.style.color = '#e74c3c';
            } else if (score === 2) {
                bar.classList.add('strength-fair');
                label.textContent = 'Fair — getting better';
                label.style.color = 'var(--gold)';
            } else if (score === 3) {
                bar.classList.add('strength-good');
                label.textContent = 'Good — almost there';
                label.style.color = '#f0a500';
            } else {
                bar.classList.add('strength-strong');
                label.textContent = 'Strong — great password!';
                label.style.color = 'var(--sage)';
            }
        }

        /* ---- Clear errors on input ---- */
        document.querySelectorAll('#registerForm .form-control').forEach(function(el) {
            el.addEventListener('input', function() {
                this.style.borderColor = '';
                const id = this.id;
                const err = document.getElementById('err-' + id);
                if (err) err.classList.remove('visible');
            });
        });
    </script>
</body>
</html>
