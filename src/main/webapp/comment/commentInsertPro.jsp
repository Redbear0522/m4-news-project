<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="comment.CommentDAO, comment.CommentDTO" %>
<%
    request.setCharacterEncoding("UTF-8");

    // 1. 파라미터 받기
    String articleIdStr = request.getParameter("article_id");
    String userId 		= request.getParameter("user_id");
    String content 		= request.getParameter("content");
    String redirectUri  = request.getParameter("redirectUri");
    
    // 2. 파라미터 검증
    if (articleIdStr == null || userId == null || content == null ||
        articleIdStr.trim().isEmpty() || userId.trim().isEmpty() || content.trim().isEmpty()) {
        out.println("<script>alert('입력 값이 올바르지 않습니다.'); history.back();</script>");
        return;
    }
    
    // 3. DTO에 데이터 담기
    CommentDTO dto = new CommentDTO();
    dto.setArticle_id(Integer.parseInt(articleIdStr));
    dto.setUser_id(userId);
    dto.setContent(content);

    // 4. DAO를 통해 DB에 저장
    CommentDAO dao = new CommentDAO();
    boolean success = dao.insertComment(dto);

    // 5. 결과에 따라 페이지 이동
    if (success) {
    	  if (redirectUri == null || redirectUri.trim().isEmpty()) {
              redirectUri = request.getHeader("Referer");
    	  } // 성공 시, 원래 보던 게시글 페이지로 리다이렉트
        %>
        <script>
        alert("댓글이 정상등록되었습니다.");
        location.href = '<%=redirectUri%>';
        </script>
        <%
    } else {
        out.println("<script>alert('댓글 등록 중 오류가 발생했습니다.'); history.back();</script>");
    }
%>