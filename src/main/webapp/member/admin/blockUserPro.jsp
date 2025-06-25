<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ page import="member.UserDAO" %>
<%
    // 한글 깨짐 방지 - 파라미터 읽기 전에 호출
    request.setCharacterEncoding("UTF-8");

    // 관리자 권한 체크
    String sid = (String) session.getAttribute("sid");
    if (sid == null || !"admin".equals(sid)) {
        response.sendRedirect(request.getContextPath() + "/main.jsp");
        return;
    }

    String userId = request.getParameter("user_id");

    // userId가 null 아니고 admin이 아닌 경우만 차단 처리
    if (userId != null && !userId.equals("admin")) {
        UserDAO dao = new UserDAO();
        try {
            dao.blockUser(userId); // 유저 차단
        } catch (Exception e) {
            e.printStackTrace();
            // 필요하면 에러 페이지로 이동하거나 메시지 출력
            // response.sendRedirect("error.jsp");
            // return;
        }
    }

    // 처리 후 차단 회원 목록 페이지로 이동
    response.sendRedirect("blockUser.jsp");
%>
