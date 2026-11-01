<!-- FILE: logout.jsp -->
<%@ page language="java" %>
<%
    session.invalidate();
    response.sendRedirect(request.getContextPath() + "/index.jsp");
%>
