<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="article.ArticleDAO" %>
<%
	String numParam      = request.getParameter("num");
	String categoriParam = request.getParameter("categori");
	if (numParam == null || numParam.trim().isEmpty()
	 || categoriParam == null || categoriParam.trim().isEmpty()) {
	    response.sendError(400);
	    return;
	}
	int num, categori;
	try {
	    num      = Integer.parseInt(numParam.trim());
	    categori = Integer.parseInt(categoriParam.trim());
	} catch (NumberFormatException e) {
	    response.sendError(400);
	    return;
	}
    // DAO 호출: 카테고리만 변경
    ArticleDAO dao = new ArticleDAO();
    dao.changeCategory(num, categori);  // 아래 메서드 구현 필요
    
    
    out.println("DEBUG ▶ num=" + request.getParameter("num")
              + ", categori=" + request.getParameter("categori"));
  

    // 처리 후 상세보기로 리다이렉트
    String viewPath;
  	switch(categori) {
    case 1: viewPath = "/news/politics/politicsView.jsp"; break;
    case 2: viewPath = "/news/economy/economyView.jsp";  break;
    case 3: viewPath = "/news/society/societyView.jsp";  break;
    case 4: viewPath = "/news/entertainment/entertainmentView.jsp";  break;
    case 5: viewPath = "/news/sports/sportsView.jsp";  break;
    case 6: viewPath = "/member/admin/blind.jsp";  break;
    case 7: viewPath = "/main.jsp";  break;
    case 8: viewPath = "/news/qna/qnaDetail.jsp";  break;
    default: viewPath = "/article/content.jsp";
  }
  response.sendRedirect(request.getContextPath() + viewPath + "?num=" + num);

%>
