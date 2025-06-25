<%@ page contentType="text/html; charset=UTF-8" %>
<%
    String userId = (String) session.getAttribute("sid");
    String emotionType = request.getParameter("emotionType");
    int articleNum = Integer.parseInt(request.getParameter("articleNum"));

    if (userId == null) {
        response.getWriter().write("로그인이 필요합니다.");
        return;
    }

    article.ArticleDAO dao = new article.ArticleDAO();
    boolean result = false;
    try {
        result = dao.insertEmotion(userId, articleNum, emotionType);
    } catch (Exception e) {
        e.printStackTrace();
    }

    if (result) {
        response.sendRedirect(request.getContextPath() + "/article/content.jsp?num=" + articleNum);
    } else {
        out.print("<script>alert('이미 공감 또는 비공감을 하셨습니다.'); location.href='" 
                  + request.getContextPath() + "/article/content.jsp?num=" + articleNum + "';</script>");
    }
%>
