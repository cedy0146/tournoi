<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Redirection automatique vers la servlet des tournois
    response.sendRedirect(request.getContextPath() + "/tournois");
%>