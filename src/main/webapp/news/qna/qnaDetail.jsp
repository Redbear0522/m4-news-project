<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="article.ArticleDAO, article.ArticleDTO" %>
<%
    // 파라미터, 세션 검증
    String numStr = request.getParameter("num");
    String pageNum = request.getParameter("pageNum");
    String ctx = request.getContextPath();
    String sid = (String) session.getAttribute("sid");

    if (numStr == null || numStr.trim().isEmpty()) {
        out.println("<script>alert('잘못된 접근입니다.'); history.back();</script>");
        return;
    }

    int num = Integer.parseInt(numStr);
    ArticleDAO dao = new ArticleDAO();
    dao.increaseReadcount(num);
    ArticleDTO dto = dao.getArticle(num);
    if (dto == null) {
        out.println("<script>alert('해당 글이 존재하지 않습니다.'); history.back();</script>");
        return;
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>QnA 상세보기 - <%= dto.getSubject() %></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
</head>
<body>
    <jsp:include page="/views/layout/header.jsp" />

    <div class="container mt-4">
        <!-- 제목 & 메타정보 -->
        <h2 class="mb-3"><%= dto.getSubject() %></h2>
        <div class="d-flex justify-content-between text-muted mb-3">
            <span>작성자: <%= dto.getWriter() %></span>
            <span>작성일: <%= dto.getWrite_date() %></span>
        </div>

        <!-- 글자 크기 조정 버튼 -->
        <div class="text-end mb-2">
            <button id="font-decrease" class="btn btn-sm btn-outline-secondary">A–</button>
            <button id="font-increase" class="btn btn-sm btn-outline-secondary">A+</button>
        </div>

        <hr/>

        <!-- 내용 -->
        <h4>내용</h4>
        <div id="article-content" class="mb-4" style="white-space: pre-wrap; word-wrap: break-word; font-size: 16px;">
            <%= dto.getContent() %>
        </div>

        <!-- 공감 버튼 -->
        <div class="text-center mb-4">
            <jsp:include page="/emotion/agreeButton.jsp" />
        </div>

        <!-- 하단 버튼 그룹 -->
        <div class="d-flex justify-content-between">
            <a href="qnaList.jsp?pageNum=<%= pageNum %>" class="btn btn-secondary">목록으로</a>
            <% if (sid != null && (sid.equals(dto.getWriter()) || "admin".equals(sid))) { %>
            <div>
                <a href="<%= ctx %>/article/update.jsp?num=<%= num %>&pageNum=<%= pageNum %>" class="btn btn-primary">수정</a>
                <a href="<%= ctx %>/member/admin/blindPro.jsp?num=<%= num %>&categori=<%= dto.getCategori() %>"
                   class="btn btn-warning" onclick="return confirm('정말 블라인드 처리하시겠습니까?');">
                   블라인드
                </a>
                <a href="<%= ctx %>/article/deleteForm.jsp?num=<%= num %>&pageNum=<%= pageNum %>" class="btn btn-danger">삭제</a>
            </div>
            <% } %>
        </div>
    </div>

    <jsp:include page="/views/layout/footer_new.jsp" />

    <!-- 글자 크기 조정 스크립트 -->
    <script>
    (function() {
        const content = document.getElementById('article-content');
        const minSize = 12, maxSize = 30, step = 2;

        function setSize(size) {
            content.style.fontSize = size + 'px';
            sessionStorage.setItem('qnaFontSize', size);
        }
        function getSize() {
            return parseInt(getComputedStyle(content).fontSize);
        }

        document.getElementById('font-increase')
            .addEventListener('click', () => {
                let size = getSize();
                if (size + step <= maxSize) setSize(size + step);
            });
        document.getElementById('font-decrease')
            .addEventListener('click', () => {
                let size = getSize();
                if (size - step >= minSize) setSize(size - step);
            });

        // 세션에 저장된 크기 로드
        const saved = parseInt(sessionStorage.getItem('qnaFontSize'));
        if (!isNaN(saved)) content.style.fontSize = saved + 'px';
    })();
    </script>
</body>
</html>
