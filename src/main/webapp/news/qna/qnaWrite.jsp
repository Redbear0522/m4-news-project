<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // ✅ 로그인한 사용자만 작성 가능하도록 세션 체크
    String sid = (String) session.getAttribute("sid");
    if (sid == null) {%>
        <script>alert("로그인 후 작성하세요");
        history.go(-1);</script>
        <%return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>QnA 작성</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
</head>
<body class="container mt-4">
<jsp:include page="/views/layout/header.jsp" />
    <h2 class="text-center">QnA 글쓰기</h2>
    <form method="post" action="qnaWritePro.jsp">
        <div class="mb-3">
            <label for="writer" class="form-label">작성자</label>
            <input type="text" id="writer" class="form-control" value="<%= sid %>" readonly>
        </div>
        <div class="mb-3">
            <label for="subject" class="form-label">제목</label>
            <input type="text" id="subject" name="subject" class="form-control" required>
        </div>
        <div class="mb-3">
            <label for="content" class="form-label">내용</label>
            <textarea id="content" name="content" class="form-control" rows="10" required></textarea>
        </div>
        <div class="d-flex justify-content-end">
            <button type="submit" class="btn btn-primary">등록하기</button>
            <a href="qnaList.jsp" class="btn btn-secondary ms-2">목록으로</a>
        </div>
    </form>
<%@ include file="/views/layout/footer_new.jsp" %>
</body>
</html>