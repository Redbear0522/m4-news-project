<%-- /article/updateForm.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="article.ArticleDAO, article.ArticleDTO" %>
<%
    // 1. 세션에서 로그인 아이디 가져오기
    String sid = (String) session.getAttribute("sid");
    if (sid == null) {
        // 로그인이 안된 경우, 접근 불가 처리
        out.println("<script>alert('로그인이 필요합니다.'); location.href='../member/loginForm.jsp';</script>");
        return;
    }

    // 2. 파라미터 받기 (수정할 글 번호, 페이지 번호)
    String numStr = request.getParameter("num");
    String pageNum = request.getParameter("pageNum");
    String ctx = request.getContextPath();

    // 파라미터 검증
    if (numStr == null || numStr.trim().isEmpty()) {
        out.println("<script>alert('잘못된 접근입니다.'); history.back();</script>");
        return;
    }
    int num = Integer.parseInt(numStr);

    // 3. DAO를 통해 기존 글 정보 가져오기
    ArticleDAO dao = new ArticleDAO();
    ArticleDTO dto = dao.getArticle(num);

    // 4. 권한 확인 (로그인한 사용자와 글 작성자가 같은지)
    if (!( sid.equals(dto.getWriter()) || "admin".equals(sid) )) {
    out.println("<script>alert('수정 권한이 없습니다.'); history.back();</script>");
    return;
    }
    
    String escSubject = dto.getSubject()
            .replace("&", "&amp;")
            .replace("\"", "&quot;")
            .replace("<", "&lt;")
            .replace(">", "&gt;");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>게시글 수정</title>
    <%-- 부트스트랩 등 CSS 링크가 필요하다면 여기에 추가 --%>
      <meta name="viewport" content="width=device-width, initial-scale=1">
  <link
    href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
    rel="stylesheet">
  <link rel="stylesheet" href="<%=ctx%>/resources/theme.css">
  <link rel="stylesheet" href="<%=ctx%>/resources/all.css">
</head>
<body>
  <jsp:include page="/views/layout/header.jsp" />
<div class="container mt-5">

    <h2>게시글 수정</h2>
    <hr>
    <form action="updatePro.jsp" method="post">
        <%-- 수정 완료 후 원래 페이지로 돌아가기 위해 글번호와 페이지번호를 hidden으로 넘김 --%>
        <input type="hidden" name="num" value="<%= dto.getNum() %>">
        <input type="hidden" name="pageNum" value="<%= pageNum %>">

        <div class="mb-3">
            <label for="writer" class="form-label">작성자</label>
            <input type="text" class="form-control" id="writer" name="writer" value="<%= dto.getWriter() %>" readonly>
        </div>
        <div class="mb-3">
            <label for="subject" class="form-label">제목</label>
            
            <input  type="text"  class="form-control"  id="subject"  name="subject"  value="<%= escSubject %>"  required/>
        </div>
        <div class="mb-3">
            <label for="content" class="form-label">내용</label>
            <textarea class="form-control" id="content" name="content" rows="10" required><%= dto.getContent() %></textarea>
        </div>
        <div class="row mb-3">
            <div class="col-md-6">
                <label for="categori" class="form-label">카테고리</label>
                <select class="form-select" id="categori" name="categori">
                    <%-- DTO에서 가져온 카테고리 값과 일치하는 옵션을 'selected'로 표시 --%>
                    <option value="1" <%= dto.getCategori() == 1 ? "selected" : "" %>>정치</option>
                    <option value="2" <%= dto.getCategori() == 2 ? "selected" : "" %>>경제</option>
                    <option value="3" <%= dto.getCategori() == 3 ? "selected" : "" %>>사회</option>
                    <option value="4" <%= dto.getCategori() == 4 ? "selected" : "" %>>연예</option>
                    <option value="5" <%= dto.getCategori() == 5 ? "selected" : "" %>>스포츠</option>
                    <option value="6" <%= dto.getCategori() == 6 ? "selected" : "" %>>일상</option>
                    <option value="7" <%= dto.getCategori() == 7 ? "selected" : "" %>>일상</option>
                </select>
            </div>
            <div class="col-md-6 d-flex align-items-center pt-4">
                 <div class="form-check">
                    <%-- emphasized 값이 true이면 체크박스를 'checked' 상태로 표시 --%>
                    <input class="form-check-input" type="checkbox" id="emphasized" name="emphasized" value="true" <%= dto.isEmphasized() ? "checked" : "" %>>
                    <label class="form-check-label" for="emphasized">
                        편집장 Pick (강조)
                    </label>
                </div>
            </div>
        </div>
        <div class="mb-3">
            <label for="passwd" class="form-label">비밀번호 확인</label>
            <input type="password" class="form-control" id="passwd" name="passwd" placeholder="게시글 비밀번호를 입력하세요." required>
        </div>
        <div class="d-flex justify-content-end">
            <button type="submit" class="btn btn-primary me-2">수정하기</button>
            <button type="button" class="btn btn-secondary" onclick="history.back()">취소</button>
        </div>
    </form>
</div>
<jsp:include page="/views/layout/footer_new.jsp" />
<script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
  </script>
</body>
</html>