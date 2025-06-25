<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="member.UserDAO" %>
<%
    // 관리자 권한 체크
    String adminId = (String) session.getAttribute("sid");
    if (adminId == null || !"admin".equals(adminId)) {
        response.sendRedirect("main.jsp");
        return;
    }

    // 파라미터 검증
    String id     = request.getParameter("id");
    String status = request.getParameter("status");
    if (id == null || status == null || (!"Y".equals(status) && !"N".equals(status))) {
        out.println("<script>alert('잘못된 요청입니다.'); history.back();</script>");
        return;
    }

    // DAO 호출
    boolean success = new UserDAO().updateApprovalStatus(id, status);
    String msg     = "Y".equals(status) ? "승인" : "거절";
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>가입 승인 처리</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="p-4">
<%@ include file="/views/layout/header.jsp" %>
    <div class="container text-center">
        <% if (success) { %>
            <div class="alert alert-success" role="alert">
                <strong><%= id %></strong> 회원을 <strong><%= msg %></strong>했습니다.
            </div>
            <a href="infoAdminMember.jsp" class="btn btn-primary">승인 대기 목록으로</a>
        <% } else { %>
            <div class="alert alert-danger" role="alert">
                처리 중 오류가 발생했습니다.
            </div>
            <button onclick="history.back()" class="btn btn-secondary">뒤로가기</button>
        <% } %>
    </div>
    <%@ include file="/views/layout/footer_new.jsp" %>
</body>
</html>
