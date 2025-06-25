<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="member.UserDAO, member.UserDTO" %>
<%
    // 1) 한글 파라미터 처리
    request.setCharacterEncoding("UTF-8");

    // 2) 폼 데이터 수신
    String id = request.getParameter("id");
    String pw = request.getParameter("pw");
    if (id == null || id.trim().isEmpty()) {
        out.println("<script>alert('아이디를 입력하세요.'); history.back();</script>");
        return;
    }

    UserDAO dao = new UserDAO();

    // 3) 아이디 존재 여부 검사
    if (!dao.isIdExists(id)) {
        out.println("<script>alert('존재하지 않는 아이디입니다.'); history.back();</script>");
        return;
    }

    // 4) 비밀번호 일치 여부 검사
    if (!dao.checkIdPwd(id, pw)) {
        out.println("<script>alert('비밀번호가 일치하지 않습니다.'); history.back();</script>");
        return;
    }

    // 5) 회원 정보 조회
    UserDTO user = dao.getUserById(id);
    if (user == null) {
        out.println("<script>alert('회원 정보를 가져올 수 없습니다. 관리자에게 문의하세요.'); history.back();</script>");
        return;
    }

    if ("blocked".equalsIgnoreCase(user.getStatus())) {
        out.println("<script>alert('이 계정은 차단되어 로그인할 수 없습니다.'); history.back();</script>");
        return;
    }

    if (!dao.checkIdPwd(id, pw)) {
        out.println("<script>alert('비밀번호가 일치하지 않습니다.'); history.back();</script>");
        return;
    }

    // 6) 승인 상태 검사 (W: 대기, N: 거절, Y: 승인)
    String approval = user.getApprovalStatus();
    if ("W".equals(approval)) {
        out.println("<script>alert('관리자 승인 대기중인 아이디입니다.'); history.back();</script>");
        return;
    } else if ("N".equals(approval)) {
        out.println("<script>alert('가입이 거절된 아이디이거나 로그인할 수 없습니다.'); history.back();</script>");
        return;
    }

    // 7) 정상 로그인
    session.setAttribute("sid", id);
    response.sendRedirect("info.jsp");
%>
