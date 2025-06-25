<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="article.ArticleDAO, article.ArticleDTO" %>
<%
    request.setCharacterEncoding("UTF-8");

    // ✅ 세션에서 사용자 ID 가져오기
    String sid = (String) session.getAttribute("sid");
    if (sid == null) {
        // 혹시 모를 비정상 접근 방지
        response.sendRedirect(request.getContextPath() + "/member/loginForm.jsp");
        return;
    }

    String subject = request.getParameter("subject");
    String content = request.getParameter("content");

    // ✅ DTO 생성 및 데이터 설정
    ArticleDTO dto = new ArticleDTO();
    dto.setSubject(subject);
    dto.setContent(content);
    dto.setWriter(sid);
    dto.setCategori(8); // ✅ 카테고리를 8번 (QnA) 으로 지정
    dto.setPasswd("none"); // ✅ 기존 DAO insert 메서드에 맞춰 임시 비밀번호 설정
    dto.setEmphasized(false);

    // ✅ DAO를 통해 저장
    ArticleDAO dao = new ArticleDAO();
    int newArticleNum = dao.insertArticleAndGetNum(dto); // 글 번호를 반환하는 메서드 사용

    if (newArticleNum > 0) {
        response.sendRedirect("qnaList.jsp"); // 등록 성공 → 목록으로 이동
    } else {
        out.println("<script>");
        out.println("alert('등록에 실패했습니다.');");
        out.println("history.back();");
        out.println("</script>");
    }
%>