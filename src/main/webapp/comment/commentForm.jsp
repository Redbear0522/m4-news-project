<%@ page contentType="text/html; charset=UTF-8" %>
<%
	String ctx       = request.getContextPath();
    int ARTICLE_ID = Integer.parseInt(request.getParameter("ARTICLE_ID"));
	String id   = request.getParameter("article_id");
	String uri  = request.getRequestURI();               // ex) /m4/news/economy/economyView.jsp
	String qs   = "article_id=" + id;
%>
<form method="post" action="<%=ctx%>/comment/commentInsertPro.jsp">
    <input type="hidden" name="article_id" value="<%= ARTICLE_ID %>">
    <input type="hidden" name="redirectUri"  value="<%=uri + "?" + qs %>">
    
    <p>아이디: <input type="text" name="user_id" required></p>
    <p>댓글 내용:<br>
            <textarea name="comment" rows="4" cols="50" required></textarea>
    </p>
    <input type="submit" value="댓글 작성">
</form>
