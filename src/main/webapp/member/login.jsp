<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>로그인 - M4 뉴스</title>
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

  <!-- 메인 (세로·가로 중앙 정렬) -->
  <main class="flex-grow-1 d-flex justify-content-center align-items-center bg-light">
    <div class="card shadow-sm" style="max-width: 400px; width: 100%;">
      <div class="card-body p-4">
        <h3 class="card-title text-center mb-4" style="color: var(--primary-color);">
          로그 인
        </h3>
        <form action="<%=ctx%>/member/loginPro.jsp" method="post">
          <div class="mb-3">
            <label for="id" class="form-label">아이디</label>
            <input type="text" id="id" name="id" class="form-control" 
                   placeholder="아이디를 입력하세요" required>
          </div>
          <div class="mb-3">
            <label for="pw" class="form-label">비밀번호</label>
            <input type="password" id="pw" name="pw" class="form-control"
                   placeholder="비밀번호를 입력하세요" required>
          </div>
          <div class="d-grid mb-3">
            <button type="submit" class="btn btn-primary">
              로그인
            </button>
          </div>
        </form>
        <div class="text-center">
          <a href="<%=ctx%>/member/findId.jsp" class="link-secondary me-3">ID 찾기</a>
          <a href="<%=ctx%>/member/findPw.jsp" class="link-secondary me-3">PW 찾기</a>
          <a href="<%=ctx%>/member/sinIn.jsp" class="link-secondary">회원가입</a>
        </div>
      </div>
    </div>
  </main>

  <!-- 푸터 -->
  <jsp:include page="/views/layout/footer_new.jsp" />

  <script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
  </script>
</body>
</html>
