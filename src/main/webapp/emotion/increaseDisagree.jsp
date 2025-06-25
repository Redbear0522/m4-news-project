<%@ page contentType="text/html; charset=UTF-8" %>
<%
    String sid = (String) session.getAttribute("sid");
    int articleNum = Integer.parseInt(request.getParameter("num"));

    if (sid == null) {
        out.print("not_logged_in");
        return;
    }

    article.ArticleDAO dao = new article.ArticleDAO();

    try {
        // 1. 중복 체크 (이미 공감 or 비공감 했는지)
        String existingEmotion = dao.getEmotionType(sid, articleNum); // null or "agree" or "disagree"
        if (existingEmotion != null) {
            out.print("duplicate");  // 이미 감정 남김
            return;
        }

        // 2. 감정 등록 (비공감)
        boolean inserted = dao.insertArticleEmotion(sid, articleNum, "disagree");
        if (inserted) {
            out.print("success");
        } else {
            out.print("fail");
        }
    } catch(Exception e) {
        e.printStackTrace();
        out.print("error");
    }
%>
