<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="article.ArticleDAO" %>
<%
    request.setCharacterEncoding("UTF-8");
    int num = Integer.parseInt(request.getParameter("num"));
    String passwd = request.getParameter("passwd");

    ArticleDAO dao = new ArticleDAO();
    // ✅ 수정된 DAO 메서드 호출 (트랜잭션 처리됨)
    boolean success = dao.deleteArticle(num, passwd);

    if (success) {
        response.sendRedirect("list.jsp");
    } else {
        out.println("<script>");
        out.println("alert('비밀번호가 일치하지 않거나 삭제에 실패했습니다.');");
        out.println("history.back();");
        out.println("</script>");
    }
%>