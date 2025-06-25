<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="member.UserDTO, member.UserDAO, java.sql.Date" %>
<%
    request.setCharacterEncoding("UTF-8");

    UserDTO dto = new UserDTO();
    dto.setId(   request.getParameter("id"));
    dto.setPw(   request.getParameter("pw"));
    dto.setName(request.getParameter("name"));
    String b = request.getParameter("birth");
    if (b != null && !b.isEmpty()) {
        dto.setBirth(Date.valueOf(b));
    }
    dto.setGender(  Integer.parseInt(request.getParameter("gender")));
    dto.setPhone1(  Integer.parseInt(request.getParameter("phone1")));
    dto.setPhone2(  Integer.parseInt(request.getParameter("phone2")));
    dto.setJob(     Integer.parseInt(request.getParameter("job")));
    dto.setZip(     request.getParameter("zip"));
    dto.setAddr1(   request.getParameter("addr1"));
    dto.setAddr2(   request.getParameter("addr2"));

    UserDAO dao = new UserDAO();

    // 1) 비밀번호 확인
    String pw2 = request.getParameter("pw2");
    if (!dto.getPw().equals(pw2)) {
        out.print("<script>alert('비밀번호가 일치하지 않습니다.'); history.back();</script>");
        return;
    }

    // 2) 아이디 중복 체크
    if (dao.isIdExists(dto.getId())) {
        out.print("<script>alert('이미 사용 중인 아이디입니다.'); history.back();</script>");
        return;
    }

    // 3) 가입 처리
    boolean ok = dao.input(dto);
    if (ok) {
%>
    <script>
        alert("회원가입이 완료되었습니다.");
        location.href = "<%=request.getContextPath()%>/member/login.jsp";
    </script>
<%
    } else {
%>
    <script>
        alert("가입 중 오류가 발생했습니다. 다시 시도해 주세요.");
        history.back();
    </script>
<%
    }
%>