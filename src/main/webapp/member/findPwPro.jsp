<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ page import="member.UserDAO" %>
<%
    request.setCharacterEncoding("UTF-8");

    String id     = request.getParameter("id");
    String name   = request.getParameter("name");
    String phone2 = request.getParameter("phone2");

    UserDAO dao = new UserDAO();
    String foundPw = dao.findPw(id, name, phone2);
%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>비밀번호 찾기 결과</title>
  <link
    href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
    rel="stylesheet">
</head>
<body class="d-flex align-items-center justify-content-center vh-100">
  <div class="card text-center p-4" style="width:360px;">
    <h3 class="card-title mb-4">비밀번호 찾기 결과</h3>
    <% if (foundPw != null) { %>
      <p class="fs-5">회원님의 비밀번호는</p>
      <p class="display-6 text-primary"><strong><%= foundPw %></strong></p>
      <button class="btn btn-primary mt-3"
              onclick="location.href='<%=request.getContextPath()%>/member/login.jsp'">
        로그인하기
      </button>
    <% } else { %>
      <p class="text-danger">입력하신 정보로 조회된 비밀번호가 없습니다.</p>
      <button class="btn btn-secondary mt-3" onclick="history.back();">
        다시 시도
      </button>
    <% } %>
  </div>
  
</body>
</html>
