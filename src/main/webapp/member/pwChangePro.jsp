<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ page import="member.UserDAO, member.UserDTO" %>
<%
    // 1) 한글 파라미터 처리
    request.setCharacterEncoding("UTF-8");

    // 2) 로그인 세션 확인
    String sid = (String) session.getAttribute("sid");
    if (sid == null) {
        out.println("<script>alert('로그인이 필요합니다.'); location.href='loginForm.jsp';</script>");
        return;
    }

    // 3) 폼 파라미터 수신
    String currentPw = request.getParameter("pw");
    String newPw     = request.getParameter("pw1");
    String newPw2    = request.getParameter("pw2");

    // 4) 새 비밀번호 확인 일치 검사
    if (newPw == null || !newPw.equals(newPw2)) {
        out.println("<script>alert('새 비밀번호가 일치하지 않습니다.'); history.back();</script>");
        return;
    }

    // 5) DAO로 사용자 정보 조회 및 현재 비밀번호 확인
    UserDAO dao = new UserDAO();
    UserDTO user = dao.getUserById(sid);
    if (user == null) {
        out.println("<script>alert('사용자 정보를 불러올 수 없습니다.'); history.back();</script>");
        return;
    }
    if (!user.getPw().equals(currentPw)) {
        out.println("<script>alert('현재 비밀번호가 일치하지 않습니다.'); history.back();</script>");
        return;
    }

    // 6) 비밀번호 변경 (메서드 시그니처: pwChange(String id, String newPw))
    boolean ok = dao.pwChange(sid, newPw);
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>비밀번호 변경 결과</title>
</head>
<body>
<% if (ok) { %>
    <script>
        alert("비밀번호가 성공적으로 변경되었습니다.");
        location.href = "info.jsp";
    </script>
<% } else { %>
    <script>
        alert("비밀번호 변경 중 오류가 발생했습니다.");
        history.back();
    </script>
<% } %>
</body>
</html>
