<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>비밀번호 찾기 - M4 뉴스</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link
    href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
    rel="stylesheet">
  <link rel="stylesheet" href="<%=ctx%>/resources/theme.css">
  <link rel="stylesheet" href="<%=ctx%>/resources/all.css">
</head>
<body class="d-flex flex-column min-vh-100">

  <!-- 헤더 -->
  <jsp:include page="/views/layout/header.jsp" />

  <!-- 메인 -->
  <main class="flex-grow-1 d-flex justify-content-center align-items-center bg-light">
    <div class="card p-4" style="max-width: 360px; width:100%;">
      <h3 class="card-title text-center mb-4" style="color: var(--primary-color);">
        비밀번호 찾기
      </h3>
      <form action="<%=ctx%>/member/findPwPro.jsp" method="post">
        <div class="mb-3">
          <label for="id" class="form-label">아이디</label>
          <input type="text" id="id" name="id" class="form-control" required>
        </div>
        <div class="mb-3">
          <label for="name" class="form-label">이름</label>
          <input type="text" id="name" name="name" class="form-control" required>
        </div>
        <div class="mb-3">
          <label for="phone2" class="form-label">전화번호 뒤 4자리</label>
          <input type="text" id="phone2" name="phone2" class="form-control"
                 maxlength="4" pattern="\\d{4}" required>
          <div class="form-text">예: 1234</div>
        </div>
        <div class="d-grid gap-2 mb-2">
          <button type="submit" class="btn btn-primary">비밀번호 찾기</button>
        </div>
        <div class="text-center">
          <button type="button" class="btn btn-secondary"
                  onclick="location.href='<%=ctx%>/member/login.jsp'">
            로그인으로 돌아가기
          </button>
        </div>
      </form>
    </div>
  </main>

  <!-- 푸터 -->
  <jsp:include page="/views/layout/footer_new.jsp" />

  <script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
  </script>
</body>
</html>
