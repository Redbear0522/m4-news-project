<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ page import="member.UserDAO, member.UserDTO, java.util.List" %>
<h1>회원차단 페이지</h1>
<%
    request.setCharacterEncoding("UTF-8");
    String sid = (String) session.getAttribute("sid");
    if (sid == null || !"admin".equals(sid)) {
        response.sendRedirect(request.getContextPath() + "/main.jsp");
        return;
    }

    UserDAO dao = new UserDAO();
    List<UserDTO> userList = dao.getAllUsers();  // 모든 회원 조회 메서드가 있다고 가정
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>불량 회원 차단</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="p-4">
<jsp:include page="/views/layout/header.jsp" />

<div class="container">
    <h2 class="mb-4">⚠️ 불량 회원 차단</h2>
    <table class="table table-bordered">
        <thead class="table-dark">
        <tr>
            <th>아이디</th>
            <th>이름</th>
            <th>성별</th>
            <th>직업</th>
            <th>상태</th>
            <th>관리</th>
        </tr>
        </thead>
        <tbody>
        <%
            for (UserDTO dto : userList) {
                if (!"admin".equals(dto.getId())) {
        %>
        <tr>
            <td><%= dto.getId() %></td>
            <td><%= dto.getName() %></td>
            <td><%= dto.getGender() != null && dto.getGender() == 1 ? "남자" : "여자" %></td>
            <td><%= dto.getJob() != null && dto.getJob() == 2 ? "기자" : "일반" %></td>
            <td><%= dto.getStatus() != null ? dto.getStatus() : "active" %></td>
            <td>
                <% if (!"blocked".equalsIgnoreCase(dto.getStatus())) { %>
                    <form method="post" action="blockUserPro.jsp" onsubmit="return confirm('정말 차단하시겠습니까?');">
                        <input type="hidden" name="user_id" value="<%= dto.getId() %>">
                        <button type="submit" class="btn btn-danger btn-sm">차단</button>
                    </form>
                <% } else { %>
                    <form method="post" action="blockReleasePro.jsp" onsubmit="return confirm('정말 차단을 해제하시겠습니까?');">
                        <input type="hidden" name="user_id" value="<%= dto.getId() %>">
                        <button type="submit" class="btn btn-warning btn-sm">차단 해제</button>
                    </form>
                <% } %>
            </td>
        </tr>
        <%
                }
            }
        %>
        </tbody>
    </table>
    <a href="<%=request.getContextPath()%>/member/info.jsp" class="btn btn-secondary">뒤로 가기</a>
</div>

<%@ include file="/views/layout/footer_new.jsp" %>
</body>
</html>
