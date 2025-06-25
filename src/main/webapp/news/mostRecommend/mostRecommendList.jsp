<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ page import="java.util.List, java.text.SimpleDateFormat, article.ArticleDAO, article.ArticleDTO" %>
<%
    request.setCharacterEncoding("UTF-8");
    String ctx = request.getContextPath();

    // DAO 호출: 조회수 상위 10개 게시물
    ArticleDAO dao = new ArticleDAO();
    List<ArticleDTO> list = dao.getRecommendedTopN(10);

    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>추천수 많은 기사</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
      rel="stylesheet">
    <link rel="stylesheet" href="<%=ctx%>/resources/css/style.css">
</head>
<body>
<jsp:include page="/views/layout/header.jsp" />

<div class="container mt-4">
    <h2 class="text-center">📈 추천수 많은 기사</h2>
    <table class="table table-hover mt-3">
        <thead class="table-light">
            <tr>
                <th style="width:10%;">순위</th>
                <th style="width:60%;">제목</th>
                <th style="width:15%;">작성자</th>
                <th style="width:15%;">등록일</th>
                <th style="width:15%;">추천수</th>
            </tr>
        </thead>
        <tbody>
        <% if (list == null || list.isEmpty()) { %>
            <tr>
                <td colspan="5" class="text-center">등록된 게시물이 없습니다.</td>
            </tr>
        <% } else {
               int rank = 1;
               for (ArticleDTO dto : list) {
        %>
            <tr>
                <td><%= rank++ %></td>
                <td>
                  <a href="<%=request.getContextPath() %>/article/content.jsp?num=<%= dto.getNum() %>">
                    <%= dto.getSubject() %>
                  </a>
                </td>
                <td><%= dto.getWriter() %></td>
                <td><%= sdf.format(dto.getWrite_date()) %></td>
                <td><%= dto.getAgree_count() %></td>
            </tr>
            <%
                // content 미리보기 (최대 50자, 줄바꿈 제거)
                String full    = dto.getContent();
                String preview = (full != null ? full : "");
                int maxLen     = 50;
                if (preview.length() > maxLen) {
                    preview = preview.substring(0, maxLen) + "...";
                }
                preview = preview.replaceAll("\\r?\\n", " ");
            %>
            <tr>
                <td colspan="5" class="text-muted small"><%= preview %></td>
            </tr>
        <%   }
           }
        %>
        </tbody>
    </table>
</div>

<jsp:include page="/views/layout/footer_new.jsp" />
<script
  src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>
</body>
</html>
