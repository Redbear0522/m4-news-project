<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ page import="member.UserDAO, member.UserDTO, java.sql.Date" %>
<%
    // 1) 한글 파라미터 처리
    request.setCharacterEncoding("UTF-8");

    // 2) 폼 데이터로 DTO 세팅
    UserDTO dto = new UserDTO();
    dto.setId(request.getParameter("id"));
    dto.setName(request.getParameter("name"));
	
    // 생년월일 (java.sql.Date로 변환)
    String birthStr = request.getParameter("birth");
    if (birthStr != null && !birthStr.isEmpty()) {
        dto.setBirth(Date.valueOf(birthStr));  // Timestamp → java.sql.Date로 변경
    }

    // 정수형 필드 파싱
    dto.setGender(Integer.parseInt(request.getParameter("gender")));
    dto.setPhone1(Integer.parseInt(request.getParameter("phone1")));
    dto.setPhone2(Integer.parseInt(request.getParameter("phone2")));
    dto.setJob(Integer.parseInt(request.getParameter("job")));
    
    dto.setCompany(request.getParameter("company"));
    dto.setZip(request.getParameter("zip"));
    dto.setAddr1(request.getParameter("addr1"));
    dto.setAddr2(request.getParameter("addr2"));

    // 3) DAO 호출
    UserDAO dao = new UserDAO();
    boolean ok = dao.updateUser(dto);
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>정보 수정 결과</title>
<%
String jobStr = request.getParameter("job");
int job = 0;
try {
    if (jobStr != null && !jobStr.trim().equals("")) {
        job = Integer.parseInt(jobStr.trim());
    }
} catch (NumberFormatException e) {
    job = 0; // 또는 에러 처리
}
dto.setJob(job);
%>
</head>
<body>

<% if (ok) { %>
    <script>
        alert("회원 정보가 성공적으로 수정되었습니다.");
        location.href = "info.jsp";
    </script>
<% } else { %>
    <script>
        alert("정보 수정 중 오류가 발생했습니다.");
        history.back();
    </script>
<% } %>
</body>
</html>
