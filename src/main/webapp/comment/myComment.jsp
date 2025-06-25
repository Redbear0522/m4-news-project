<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List, java.text.SimpleDateFormat, comment.CommentDAO, comment.CommentDTO" %>
<%
    String ctx = request.getContextPath();
    String sid = (String) session.getAttribute("sid");
    if (sid == null) {
        response.sendRedirect(ctx + "/member/loginForm.jsp");
        return;
    }
    CommentDAO dao = new CommentDAO();
    // ✅ 수정된 DAO 메서드가 호출되면, 기사 제목과 추천수가 포함된 list가 반환됩니다.
    List<CommentDTO> list = dao.getCommentsByUserId(sid);
    
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
%>
<!DOCTYPE html>
<html>
<head>
    <title>내가 쓴 댓글 목록</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="<%= ctx %>/resources/css/style.css">
</head>
<body>

<jsp:include page="/views/layout/header.jsp" />
<div class="container mt-4">
    <h2 class="text-center">✍️ 내가 쓴 댓글 목록</h2>

<% if (list == null || list.isEmpty()) { %>
    <p class="text-center mt-4">작성한 댓글이 없습니다.</p>
<% } else { %>
    <table class="table table-hover mt-3">
        <thead class="table-light">
            <%-- ✅ 테이블 헤더를 요청하신 대로 수정 --%>
            <tr>
                <th style="width: 45%;">댓글 내용</th>
                <th style="width: 30%;">원문 기사</th>
                <th style="width: 15%;">작성일</th>
                <th style="width: 10%;">추천수</th>
            </tr>
        </thead>
        <tbody>
        <% for (CommentDTO dto : list) { %>
            <tr>
                <td><%= dto.getContent() %></td>
                <td>
                    <%-- ✅ 기사 제목을 보여주고, 해당 기사로 링크 --%>
                    <a href="<%= ctx %>/article/content.jsp?num=<%= dto.getArticle_id() %>">
                        <%= dto.getArticleSubject() %>
                    </a>
                </td>
                <td><%= sdf.format(dto.getComment_date()) %></td>
                <%-- ✅ 추천수 표시 --%>
                <td>👍 <%= dto.getLikeCount() %></td>
            </tr>
        <% } %>
        </tbody>
    </table>
<% } %>
</div>
<jsp:include page="/views/layout/footer_new.jsp" />
</body>
</html>