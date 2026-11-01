<%-- footer.jsp — Include on every page --%>
<footer class="site-footer">
    <div class="footer-grid">
        <!-- Brand -->
        <div class="footer-brand">
            <div class="footer-logo">
                <img src="<%=request.getContextPath()%>/images/CHESS%20LOGO.png" alt="The Last Pawn Logo">
                <div>
                    <span class="brand-name">The Last Pawn</span><br>
                    <span class="brand-sub">Chess Academy</span>
                </div>
            </div>
            <p>A premier chess academy dedicated to developing strategic thinkers and champion chess players at every level — beginner to grandmaster.</p>
            <div class="footer-tagline">THINK BETTER. PLAY SMARTER.</div>
        </div>

        <!-- Quick Links -->
        <div class="footer-col">
            <h4>Academy</h4>
            <a href="<%=request.getContextPath()%>/index.jsp">Home</a>
            <a href="<%=request.getContextPath()%>/about.jsp">About Us</a>
            <a href="<%=request.getContextPath()%>/coaching.jsp">Coaching</a>
            <a href="<%=request.getContextPath()%>/courses.jsp">Courses</a>
            <a href="<%=request.getContextPath()%>/contact.jsp">Contact</a>
        </div>

        <!-- Learn -->
        <div class="footer-col">
            <h4>Learn</h4>
            <a href="<%=request.getContextPath()%>/library.jsp">Chess Library</a>
            <a href="<%=request.getContextPath()%>/challenge.jsp">Chess Challenge</a>
            <a href="<%=request.getContextPath()%>/leaderboard.jsp">Leaderboard</a>
            <a href="<%=request.getContextPath()%>/tournaments.jsp">Tournaments</a>
            <a href="<%=request.getContextPath()%>/play.jsp">Play Chess</a>
        </div>

        <!-- Contact -->
        <div class="footer-col">
            <h4>Contact</h4>
            <div class="footer-contact-item">
                <span class="icon">♟</span>
                <span>The Last Pawn Chess Academy</span>
            </div>
            <div class="footer-contact-item">
                <span class="icon">✉</span>
                <span>info@lastpawnacademy.com</span>
            </div>
            <div class="footer-contact-item">
                <span class="icon">☎</span>
                <span>+91 98765 43210</span>
            </div>
            <div class="footer-contact-item">
                <span class="icon">🕐</span>
                <span>Mon–Fri: 9AM – 9PM<br>Sat: 10AM – 8PM<br>Sun: 10AM – 6PM</span>
            </div>
        </div>
    </div>

    <div class="footer-bottom">
        <p>© 2026 <span>The Last Pawn Chess Academy</span>. All Rights Reserved.</p>
        <div class="footer-chess-pieces">♟ ♞ ♝ ♜ ♛ ♚</div>
        <p>Built with ♟ for Chess Lovers</p>
    </div>
</footer>
