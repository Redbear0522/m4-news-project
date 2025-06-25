<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List, java.text.SimpleDateFormat" %>
<%@ page import="comment.CommentDAO, comment.CommentDTO, emotion.EmotionDAO" %>
<%
    // 1. 파라미터 및 세션 정보 받기
     String articleIdStr = request.getParameter("num");
	    if (articleIdStr == null) {
	        articleIdStr = request.getParameter("article_id");
	    }

    String sid = (String) session.getAttribute("sid"); // 로그인 사용자 ID

    // 2. 파라미터 검증
    if (articleIdStr == null || articleIdStr.trim().isEmpty()) {
        out.println("<p>게시글 정보가 올바르지 않아 댓글을 표시할 수 없습니다.</p>");
        return;
    }
    int articleId = Integer.parseInt(articleIdStr);

    // 3. DAO 객체 생성 및 댓글 목록 조회
    CommentDAO commentDAO = new CommentDAO();
    EmotionDAO emotionDAO = new EmotionDAO();
    List<CommentDTO> commentList = commentDAO.getCommentsByArticle(articleId);

    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
%>
<hr>
<div class="container my-4">
    <h4>댓글 (<%= commentList.size() %>)</h4>

    <%-- 댓글 목록 --%>
    <% if (commentList.isEmpty()) { %>
        <p>등록된 댓글이 없습니다.</p>
    <% } else { %>
        <ul class="list-group">
        <% for (CommentDTO comment : commentList) { 
                int commentId = comment.getComment_id();
                // 각 댓글의 감정 수치 조회
                int likeCount = emotionDAO.getEmotionCount(commentId, "like");
                int dislikeCount = emotionDAO.getEmotionCount(commentId, "dislike");
        %>
            <li class="list-group-item">
                <div class="d-flex justify-content-between">
                    <strong><%= comment.getUser_id() %></strong>
                    <small><%= sdf.format(comment.getComment_date()) %></small>
                </div>
                <p class="mt-2"><%= comment.getContent() %></p>
                
                <%-- 감정 표현 버튼 (로그인한 경우에만 표시) --%>
                <% if (sid != null) { %>
                <form action="<%= request.getContextPath() %>/comment/commentEmotionPro.jsp" method="post" style="display:inline;">
                    <input type="hidden" name="comment_id" value="<%= commentId %>">
                    <input type="hidden" name="article_id" value="<%= articleId %>">
                    <input type="hidden" name="user_id" value="<%= sid %>">
                    <input type="hidden" name="emotion_type" value="like">
                    <button type="submit" class="btn btn-sm btn-outline-primary">👍 추천 <%= likeCount %></button>
                </form>
                <form action="<%= request.getContextPath() %>/comment/commentEmotionPro.jsp" method="post" style="display:inline;">
                    <input type="hidden" name="comment_id" value="<%= commentId %>">
                    <input type="hidden" name="article_id" value="<%= articleId %>">
                    <input type="hidden" name="user_id" value="<%= sid %>">
                    <input type="hidden" name="emotion_type" value="dislike">
                    <button type="submit" class="btn btn-sm btn-outline-danger">👎 비추천 <%= dislikeCount %></button>
                </form>
                <% } %>
            </li>
        <% } %>
        </ul>
    <% } %>

    <%-- 댓글 작성 폼 (로그인한 경우에만 표시) --%>
    <% if (sid != null) { %>
    <div class="mt-4">
        <h5>댓글 작성</h5>
        <form action="<%= request.getContextPath() %>/comment/commentInsertPro.jsp" method="post">
             <input type="hidden" name="article_id" value="<%= articleId %>">
  			 <input type="hidden" name="user_id"    value="<%= sid %>">
            <div class="input-group">
                <textarea name="content" class="form-control" rows="3" placeholder="댓글을 입력하세요." required></textarea>
                <button class="btn btn-primary" type="submit">등록</button>
            </div>
        </form>
    </div>
    <% } else { %>
        <div class="alert alert-secondary mt-4" role="alert">
            댓글을 작성하려면 <a href="<%= request.getContextPath() %>/member/loginForm.jsp">로그인</a>이 필요합니다.
        </div>
    <% } %>
</div>