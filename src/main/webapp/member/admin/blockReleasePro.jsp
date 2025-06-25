<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="member.UserDAO" %>
<%
    request.setCharacterEncoding("UTF-8");

    String sid = (String) session.getAttribute("sid");
    // 관리자만 접근 가능
    if (sid == null || !"admin".equals(sid)) {
        response.sendRedirect(request.getContextPath() + "/main.jsp");
        return;
    }

    String userId = request.getParameter("user_id");

    if (userId == null || userId.trim().isEmpty()) {
        out.println("<script>alert('사용자 ID가 유효하지 않습니다.'); history.back();/script>");
        return;
    }

    UserDAO dao = new UserDAO();
    dao.unblockUser(userId);  // 차단 해제 메서드 호출

    response.sendRedirect("blockUser.jsp");
%>
