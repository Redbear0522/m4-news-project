<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>프로필 변경</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
        rel="stylesheet">
</head>
<body >
 <jsp:include page="/views/layout/header.jsp" />
 <div class="d-flex align-items-center justify-content-center vh-100">
  <div class="card p-4" style="width: 360px;">
    <h3 class="card-title text-center mb-4">프로필 변경</h3>
    <form action="<%=ctx%>/member/profilePro.jsp"
          method="post"
          enctype="multipart/form-data">
      <div class="mb-3">
        <label for="profile" class="form-label">이미지 파일</label>
        <input type="file" id="profile" name="profile"
               class="form-control" accept="image/*" required>
      </div>
      <div class="d-flex justify-content-between">
        <button type="submit" class="btn btn-primary">업로드</button>
        <button type="button" class="btn btn-secondary"
                onclick="location.href='<%=ctx%>/member/info.jsp'">
          취소
        </button>
      </div>
    </form>
  </div>
  </div><br>
<%@ include file="/views/layout/footer_new.jsp" %>
  
</body>
</html>
