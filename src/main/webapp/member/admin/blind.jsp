<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.text.SimpleDateFormat, article.ArticleDAO, article.ArticleDTO" %>
<%
    request.setCharacterEncoding("UTF-8");
    String ctx = request.getContextPath();

    // 페이징 설정
    int pageSize = 10;
    String pageNum = request.getParameter("pageNum");
    if (pageNum == null) {
        pageNum = "1";
    }
    int currentPage = Integer.parseInt(pageNum);
    int startRow = (currentPage - 1) * pageSize + 1;
    int endRow = currentPage * pageSize;

    // ✅ 1. DAO를 통해 categori가 1인 게시물 목록과 전체 개수 조회
    ArticleDAO dao = new ArticleDAO();
    int count = dao.getArticleCount(6); // categori가 3인 글의 총 개수를 가져옴
    List<ArticleDTO> list = dao.getArticleList(startRow, endRow, 6); // categori가 3인 글의 목록을 가져옴
    
    int number = count - (currentPage - 1) * pageSize;
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <%-- ✅ 2. 페이지 제목 수정 --%>
    <title>블라인드 뉴스 게시판</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="<%= ctx %>/resources/css/style.css">
</head>
<body>
 <jsp:include page="/views/layout/header.jsp" />
<div class="container mt-4">
    <%-- ✅ 3. 화면 제목 수정 --%>
    <h2 class="text-center">블라인드 뉴스</h2>
    
    <table class="table table-hover mt-3">
        <thead class="table-light">
            <tr>
                <th>번호</th>
                <th>제목</th>
                <th>작성자</th>
                <th>작성일</th>
            </tr>
        </thead>
        <tbody>
        <% if (list == null || list.isEmpty()) { %>
            <tr>
                <%-- ✅ 4. 메시지 수정 --%>
                <td colspan="4" class="text-center">등록된 블라인드 뉴스가 없습니다.</td>
            </tr>
        <% } else {
               for (ArticleDTO dto : list) { %>
            <tr>
                <td><%= number-- %></td>
                <%-- ✅ 5. 상세 페이지 링크 수정 (링크 페이지 경로가 다르다면 수정 필요) --%>
                <td><a href="<%= request.getContextPath() %>/article/content.jsp?num=<%= dto.getNum() %>&pageNum=<%= currentPage %>"><%= dto.getSubject() %></a></td>
                <td><%= dto.getWriter() %></td>
                <td><%= sdf.format(dto.getWrite_date()) %></td>
            </tr>
        <%     }
           } %>
        </tbody>
    </table>

    <div class="d-flex justify-content-between mt-4">
        <div>
            <%-- 페이지네이션 UI --%>
            <% if (count > 0) {
                int pageCount = count / pageSize + (count % pageSize == 0 ? 0 : 1);
                int startPage = (currentPage - 1) / 10 * 10 + 1;
                int endPage = startPage + 9;
                if (endPage > pageCount) endPage = pageCount;
            %>
            <ul class="pagination">
                <% if (startPage > 10) { %>
                    <li class="page-item"><a class="page-link" href="<%= request.getContextPath() %>societyList.jsp?pageNum=<%= startPage - 10 %>">이전</a></li>
                <% } %>
                <% for (int i = startPage; i <= endPage; i++) { %>
                    <li class="page-item <%= (i == currentPage ? "active" : "") %>">
                        <a class="page-link" href="<%= request.getContextPath() %>societyList.jsp?pageNum=<%= i %>"><%= i %></a>
                    </li>
                <% } %>
                <% if (endPage < pageCount) { %>
                    <li class="page-item"><a class="page-link" href="<%= request.getContextPath() %>societyList.jsp?pageNum=<%= startPage + 10 %>">다음</a></li>
                <% } %>
            </ul>
            <% } %>
        </div>
    </div>
</div>

<%@ include file="/views/layout/footer_new.jsp" %>
</body>
</html>