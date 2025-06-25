<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    // 세션 무효화
    session.invalidate();
    // 로그인 폼(login.jsp)으로 리다이렉트
    response.sendRedirect(request.getContextPath() + "/member/login.jsp");
%>
