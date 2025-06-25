<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%
    // 한글 처리
    request.setCharacterEncoding("UTF-8");
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>회원 탈퇴</title>
  <link
    href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
    rel="stylesheet">
</head>
<body >

  <jsp:include page="/views/layout/header.jsp" />
<div class="d-flex align-items-center justify-content-center vh-100">
  <div class="card p-4" style="width: 360px;">
    <h3 class="card-title mb-4 text-center">회원 탈퇴</h3>
    <form action="<%=ctx%>/member/deletePro.jsp" method="post"
          onsubmit="return confirm('정말 탈퇴하시겠습니까?');">
      <div class="mb-3">
        <label for="pw" class="form-label">비밀번호</label>
        <input type="password" id="pw" name="pw" class="form-control" required>
      </div>
      <div class="d-flex justify-content-between">
        <button type="submit" class="btn btn-danger">탈퇴</button>
        <button type="button" class="btn btn-secondary"
                onclick="location.href='<%=ctx%>/member/info.jsp'">
          돌아가기
        </button>
      </div>
    </form>
  </div>
  </div>
  <%@ include file="/views/layout/footer_new.jsp" %>
</body>
</html>
