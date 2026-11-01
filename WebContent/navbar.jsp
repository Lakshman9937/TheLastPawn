<%-- navbar.jsp — Include on every page --%>
<%
String currentPage = (String) request.getAttribute("currentPage");
if (currentPage == null) currentPage = "";
%>
<nav class="navbar" id="mainNav">
    <a href="<%=request.getContextPath()%>/index.jsp" class="nav-logo">
        <img src="<%=request.getContextPath()%>/images/CHESS%20LOGO.png" alt="The Last Pawn Logo">
        <div class="nav-brand">
            <span class="brand-name">The Last Pawn</span>
            <span class="brand-sub">Chess Academy</span>
        </div>
    </a>

    <ul class="nav-links" id="navLinks">
        <li><a href="<%=request.getContextPath()%>/index.jsp" class="<%= "home".equals(currentPage) ? "active" : "" %>">Home</a></li>
        <li><a href="<%=request.getContextPath()%>/about.jsp" class="<%= "about".equals(currentPage) ? "active" : "" %>">About</a></li>
        <li><a href="<%=request.getContextPath()%>/coaching.jsp" class="<%= "coaching".equals(currentPage) ? "active" : "" %>">Coaching</a></li>
        <li><a href="<%=request.getContextPath()%>/courses.jsp" class="<%= "courses".equals(currentPage) ? "active" : "" %>">Courses</a></li>
        <li><a href="<%=request.getContextPath()%>/play.jsp" class="<%= "play".equals(currentPage) ? "active" : "" %>">Play Chess</a></li>
        <li><a href="<%=request.getContextPath()%>/library.jsp" class="<%= "library".equals(currentPage) ? "active" : "" %>">Chess Library</a></li>
        <li><a href="<%=request.getContextPath()%>/tournaments.jsp" class="<%= "tournaments".equals(currentPage) ? "active" : "" %>">Tournaments</a></li>
        <li><a href="<%=request.getContextPath()%>/challenge.jsp" class="<%= "challenge".equals(currentPage) ? "active" : "" %>">Chess Challenge</a></li>
        <li><a href="<%=request.getContextPath()%>/contact.jsp" class="<%= "contact".equals(currentPage) ? "active" : "" %>">Contact</a></li>
    </ul>

    <div class="nav-buttons">
        <%
        Object loggedInUser = session.getAttribute("username");
        if (loggedInUser != null) {
        %>
            <span style="color:var(--gold);font-size:0.82rem;font-weight:600;">♟ <%= loggedInUser %></span>
            <a href="<%=request.getContextPath()%>/logout.jsp" class="btn-login">Logout</a>
            <%
            if (Boolean.TRUE.equals(session.getAttribute("isAdmin"))) {
            %>
            <a href="<%=request.getContextPath()%>/admin/dashboard.jsp" class="btn-join">Admin</a>
            <% } %>
        <% } else { %>
            <a href="<%=request.getContextPath()%>/login.jsp" class="btn-login">Login</a>
            <a href="<%=request.getContextPath()%>/register.jsp" class="btn-join">Join the Academy</a>
        <% } %>
    </div>

    <div class="nav-hamburger" id="navHamburger" onclick="document.getElementById('navLinks').classList.toggle('open')">
        <span></span>
        <span></span>
        <span></span>
    </div>
</nav>
