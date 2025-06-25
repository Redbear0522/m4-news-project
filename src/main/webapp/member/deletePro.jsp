<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ page import="member.UserDAO, member.UserDTO" %>
<%
    // 1) 한글 파라미터 처리
    request.setCharacterEncoding("UTF-8");
    String ctx = request.getContextPath();

    // 2) 로그인 검사
    String id = (String) session.getAttribute("sid");
    if (id == null) {
        response.sendRedirect(ctx + "/member/login.jsp");
        return;
    }

    // 3) 비밀번호 검증
    String inputPw = request.getParameter("pw");
    UserDTO dto = new UserDAO().getUserById(id);
    if (dto == null || !dto.getPw().equals(inputPw)) {
        out.println("<script>alert('비밀번호가 일치하지 않습니다.'); history.back();</script>");
        return;
    }

    // 4) 회원 탈퇴
    boolean success = new UserDAO().deleteMember(id);
    if (success) {
        session.invalidate();
        response.sendRedirect(ctx + "/main.jsp");
    } else {
        out.println("<script>alert('탈퇴 중 오류가 발생했습니다.'); history.back();</script>");
    }
%>
