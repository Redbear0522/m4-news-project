<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>비밀번호 변경</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <script>
    function validateForm() {
      const pw   = document.forms["pwChangeForm"]["pw"].value.trim();
      const pw1  = document.forms["pwChangeForm"]["pw1"].value.trim();
      const pw2  = document.forms["pwChangeForm"]["pw2"].value.trim();

      if (!pw) {
        alert("기존 비밀번호를 입력하세요.");
        return false;
      }
      if (pw1.length < 4) {
        alert("새 비밀번호를 4자 이상 입력하세요.");
        return false;
      }
      if (pw1 !== pw2) {
        alert("새 비밀번호와 확인이 일치하지 않습니다.");
        return false;
      }
      return true;
    }
  </script>
</head>
<body class="p-4">
 <jsp:include page="/views/layout/header.jsp" />
  <div class="container" style="max-width: 400px;">
    <h1 class="mb-4">비밀번호 변경</h1>
    <form name="pwChangeForm" action="pwChangePro.jsp" method="post" onsubmit="return validateForm();">
      <div class="mb-3">
        <label for="pw" class="form-label">기존 비밀번호</label>
        <input type="password" id="pw" name="pw" class="form-control" required>
      </div>
      <div class="mb-3">
        <label for="pw1" class="form-label">새 비밀번호</label>
        <input type="password" id="pw1" name="pw1" class="form-control" required>
      </div>
      <div class="mb-3">
        <label for="pw2" class="form-label">비밀번호 확인</label>
        <input type="password" id="pw2" name="pw2" class="form-control" required>
      </div>
      <div class="d-flex justify-content-between">
        <button type="submit" class="btn btn-primary">변경</button>
        <a href="info.jsp" class="btn btn-secondary">취소</a>
      </div>
    </form>
  </div>
  <%@ include file="/views/layout/footer_new.jsp" %>
</body>
</html>
