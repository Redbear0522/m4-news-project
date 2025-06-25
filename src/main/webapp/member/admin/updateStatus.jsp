<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="member.UserDAO" %>
<%
    // ※ 관리자로만 접근 가능하게 세션 체크
    String adminId = (String) session.getAttribute("userId");
    if (adminId == null || !"admin".equals(adminId)) {
        out.println("<script>alert('접근 권한이 없습니다.'); location.href='main.jsp';</script>");
        return;
    }

    String id     = request.getParameter("id");
    String status = request.getParameter("status");
    if (id == null || status == null || (!"Y".equals(status) && !"N".equals(status))) {
        out.println("<script>alert('잘못된 요청입니다.'); history.back();</script>");
        return;
    }

    UserDAO dao = new UserDAO();
    boolean ok = dao.updateApprovalStatus(id, status);

    if (ok) {
        String msg = "Y".equals(status) ? "승인" : "거절";
        out.println("<script>alert('" + id + " 회원을 " + msg + " 처리했습니다.'); location.href='infoAdminMember.jsp';</script>");
    } else {
        out.println("<script>alert('처리 중 오류가 발생했습니다.'); history.back();</script>");
    }
%>
