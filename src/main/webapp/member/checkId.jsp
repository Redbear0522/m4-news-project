<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="member.UserDAO" %>
<%
  String id = request.getParameter("id");
  boolean exists = new UserDAO().isIdExists(id);
%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>아이디 중복확인</title>
</head>
<body>
  <% if (exists) { %>
    <p>❌ 사용 불가능한 아이디입니다: <strong><%= id %></strong></p>
  <% } else { %>
    <p>✅ 사용 가능한 아이디입니다: <strong><%= id %></strong></p>
  <% } %>
  <button onclick="window.close()">닫기</button>
</body>
</html>
