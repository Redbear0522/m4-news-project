<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%
    String ctx = request.getContextPath();
    String num = request.getParameter("num");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>글 삭제 - M4 뉴스</title>
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
    <div class="card p-4" style="max-width: 580px; width: 100%;">
      <h2 class="card-title text-center mb-4" style="color: var(--primary-color);">
        글을 삭제하려면 비밀번호를 입력하세요.
      </h3>
      <form action="<%=ctx%>/article/deletePro.jsp" method="post">
        <input type="hidden" name="num" value="<%= num %>">
        <div class="mb-3">
          <label for="passwd" class="form-label">비밀번호</label>
          <input type="password" id="passwd" name="passwd" class="form-control" required>
        </div>
        <div class="d-grid gap-2 mb-2">
          <button type="submit" class="btn btn-primary">글 삭제</button>
        </div>
        <div class="text-center">
          <button type="button" class="btn btn-secondary"
                  onclick="history.back()">
            돌아가기
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
