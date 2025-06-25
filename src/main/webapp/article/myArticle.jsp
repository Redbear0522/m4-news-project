<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List, article.ArticleDAO, article.ArticleDTO" %>
<%
    String ctx = request.getContextPath();
    String sid = (String) session.getAttribute("sid");
    if (sid == null) {
        response.sendRedirect(ctx + "/member/loginForm.jsp");
        return;
    }

    ArticleDAO dao = new ArticleDAO();
    List<ArticleDTO> list = dao.getArticleList(sid);
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>내가 쓴 글</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="<%= ctx %>/resources/css/style.css">
</head>
<body>
<jsp:include page="/views/layout/header.jsp" />

<div class="container mt-5">
    <h2 class="text-center mb-4">✍️ 내가 쓴 글 목록</h2>

    <% if (list == null || list.isEmpty()) { %>
        <p class="text-center">작성된 게시글이 없습니다.</p>
    <% } else { %>
        <table class="table table-striped table-hover text-center">
            <thead class="table-light">
                <tr>
                    <th>번호</th>
                    <th>제목</th>
                    <th>작성일</th>
                    <th>조회수</th>
                    <th>추천수</th>
                </tr>
            </thead>
            <tbody>
                <% for (ArticleDTO dto : list) { %>
                    <tr>
                        <td><%= dto.getNum() %></td>
                        <td>
                            <a href="<%= ctx %>/article/content.jsp?num=<%= dto.getNum() %>">
                                <%= dto.getSubject() %>
                            </a>
                        </td>
                        <td><%= dto.getWrite_date() %></td>
                        <td><%= dto.getReadcount() %></td>
                        <td><%= dto.getAngry_count() + dto.getGood_count() + dto.getLike_count() + dto.getSad_count() + dto.getWow_count() %></td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    <% } %>
</div>

<jsp:include page="/views/layout/footer_new.jsp" />
</body>
</html>
