<%@ page import="comment.CommentDAO" %>
<%
    String sid = (String) session.getAttribute("sid");
    int commentId = Integer.parseInt(request.getParameter("commentId"));
    String emotion = request.getParameter("emotion");

    CommentDAO dao = new CommentDAO();
    String existing = dao.getCommentEmotion(sid, commentId);

    if (existing == null) {
        dao.insertCommentEmotion(sid, commentId, emotion);
        if ("like".equals(emotion)) dao.increaseLikeCount(commentId);
        else if ("dislike".equals(emotion)) dao.increaseDislikeCount(commentId);
    }

    response.sendRedirect(request.getHeader("Referer"));
%>
