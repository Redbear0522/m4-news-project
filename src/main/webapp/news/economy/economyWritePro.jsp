<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.File, java.util.Enumeration" %>
<%-- ✅ 1. cos.jar 라이브러리를 사용하도록 import문 수정 --%>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="article.ArticleDAO, article.ArticleDTO" %>
<%
    // ✅ 2. 기존과 동일한 파일 저장 경로 사용
    String saveDir = application.getRealPath("/resources/image");
    File dir = new File(saveDir);
    if (!dir.exists()) {
        dir.mkdirs();
    }

    int maxSize = 10 * 1024 * 1024; // 10MB
    String enc = "UTF-8";

    // ✅ 3. MultipartRequest 객체 생성 (파일 업로드가 이 시점에 완료됨)
    MultipartRequest mr = new MultipartRequest(
        request, saveDir, maxSize, enc, new DefaultFileRenamePolicy());

    // ✅ 4. DTO에 폼 데이터 저장 (기존 DTO 필드명 사용)
    ArticleDTO dto = new ArticleDTO();
    dto.setSubject(mr.getParameter("subject"));
    dto.setWriter(mr.getParameter("writer"));
    dto.setContent(mr.getParameter("content"));
    dto.setPasswd(mr.getParameter("passwd")); // 비밀번호 추가
    
    // "경제" 카테고리는 숫자 2로 가정하여 설정
    dto.setCategori(2); 
    
    // 단독 기사 여부 등 다른 필드 기본값 설정
    dto.setEmphasized(false);

    // ✅ 5. 기존 DAO 방식대로 객체 생성 및 메서드 호출
    ArticleDAO dao = new ArticleDAO();
    
    // 게시글을 먼저 저장하고, 방금 생성된 글 번호를 받아옴
    int newArticleNum = dao.insertArticleAndGetNum(dto);

    if (newArticleNum > 0) { // 글 저장이 성공했을 때
        
        // ✅ 6. 여러 파일 정보를 DB에 저장하는 로직 (기존 방식 재사용)
        Enumeration<?> files = mr.getFileNames(); 
        
        while(files.hasMoreElements()) {
            String name = (String) files.nextElement();
            String filename = mr.getFilesystemName(name);

            if (filename != null) {
                // ARTICLE_FILES 테이블에 파일 정보 저장
                dao.insertArticleFile(newArticleNum, filename);
            }
        }
        
        // ✅ 7. 해당 카테고리 목록 페이지로 이동
        // 경제 뉴스 목록 페이지 경로로 수정
        response.sendRedirect(request.getContextPath() + "/article/list.jsp?categori=2");

    } else { // 글 저장 실패
        out.println("<script>");
        out.println("alert('게시글 등록에 실패했습니다.');");
        out.println("history.back();");
        out.println("</script>");
    }
%>