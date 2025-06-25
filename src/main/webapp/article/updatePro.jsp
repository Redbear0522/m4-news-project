<%-- /article/updatePro.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="article.ArticleDAO, article.ArticleDTO" %>
<%
    // 1. 한글 인코딩 처리
    request.setCharacterEncoding("UTF-8");

    // 2. updateForm에서 넘어온 파라미터 받기
    String pageNum = request.getParameter("pageNum");
    
    // DTO에 담을 정보들
    int num = Integer.parseInt(request.getParameter("num"));
    String subject = request.getParameter("subject");
    String content = request.getParameter("content");
    String passwd = request.getParameter("passwd");
    int categori = Integer.parseInt(request.getParameter("categori"));
    
    // 체크박스는 체크된 경우에만 값이 넘어오므로, null 여부로 true/false를 판단합니다.
    boolean emphasized = request.getParameter("emphasized") != null;

    // 파라미터 검증 (필요한 값이 비어있는지 확인)
    if (subject == null || content == null || passwd == null ||
        subject.trim().isEmpty() || content.trim().isEmpty() || passwd.trim().isEmpty()) {
        out.println("<script>alert('제목, 내용, 비밀번호는 필수 입력 항목입니다.'); history.back();</script>");
        return;
    }

    // 3. DTO 객체에 수정할 정보 담기
    ArticleDTO dto = new ArticleDTO();
    dto.setNum(num);
    dto.setSubject(subject);
    dto.setContent(content);
    dto.setPasswd(passwd);
    dto.setCategori(categori);
    dto.setEmphasized(emphasized);

    // 4. DAO 객체 생성 및 수정 메소드 호출
    ArticleDAO dao = new ArticleDAO();
    int result = dao.updateArticle(dto); // updateArticle은 성공 시 1, 비밀번호 틀리면 0을 반환

    // 5. 결과에 따라 페이지 이동
    if (result > 0) {
        // 수정 성공
        // 성공 메시지를 띄우고, 해당 게시글 내용 보기 페이지로 이동
        // pageNum을 계속 가지고 다녀야, 목록으로 돌아갔을 때 보던 페이지를 유지할 수 있습니다.
        out.println("<script>alert('게시글이 성공적으로 수정되었습니다.');");
        out.println("location.href='content.jsp?num=" + num + "&pageNum=" + pageNum + "';</script>");
    } else {
        // 수정 실패 (대부분 비밀번호 불일치)
        out.println("<script>alert('비밀번호가 일치하지 않습니다.'); history.back();</script>");
    }
%>