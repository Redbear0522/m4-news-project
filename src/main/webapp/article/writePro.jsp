<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.File, java.util.Enumeration" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="article.ArticleDAO, article.ArticleDTO" %>
<%
    // 1) 업로드 디렉터리 설정 (상대 경로 → 절대 경로)
    String saveDir = application.getRealPath("/upload");
    File dir = new File(saveDir);
    if (!dir.exists()) {dir.mkdirs();    }

    int maxSize = 10 * 1024 * 1024; // 10MB
    String enc = "UTF-8";

    // 2) MultipartRequest 생성하여 파일 업로드 실행
    MultipartRequest mr = new MultipartRequest(
        request, saveDir, maxSize, enc, new DefaultFileRenamePolicy());

    // 3) DTO에 일반 파라미터 세팅
    ArticleDTO dto = new ArticleDTO();
    dto.setWriter(mr.getParameter("writer"));
    dto.setSubject(mr.getParameter("subject"));
    dto.setContent(mr.getParameter("content"));
    dto.setPasswd(mr.getParameter("passwd"));
    dto.setCategori(Integer.parseInt(mr.getParameter("categori")));
    dto.setEmphasized(false); // 기본값 설정

    ArticleDAO dao = new ArticleDAO();
    
    // 4) DB에 글 저장하고, 새로 생성된 글 번호 받아오기
    int newArticleNum = dao.insertArticleAndGetNum(dto);

    if (newArticleNum > 0) { // 글 저장이 성공했을 때만 파일 정보 저장
        
        // 5) 업로드된 파일들의 정보 저장
        Enumeration<?> files = mr.getFileNames(); // form에서 전송된 input type="file"의 name들을 모두 가져옴
        
        while(files.hasMoreElements()) {
            String name = (String) files.nextElement(); // 각 파일 input의 name (e.g., "img")
            String filename = mr.getFilesystemName(name); // 서버에 저장된 실제 파일 이름

            if (filename != null) {
                // 이미지 파일 타입인지 간단히 확장자로 체크
                String fileType = mr.getContentType(name);
                if (fileType != null && fileType.startsWith("image")) {
                    // DB의 ARTICLE_FILES 테이블에 파일 정보 저장
                    dao.insertArticleFile(newArticleNum, filename);
                } else {
                    // 이미지 파일이 아니면 서버에서 삭제 (선택적)
                    File uploadedFile = new File(saveDir + "/" + filename);
                    if (uploadedFile.exists()) {
                        uploadedFile.delete();
                    }
                }
            }
        }
        
        out.println("<script>");
        out.println("alert('게시글이 성공적으로 등록되었습니다.');");
        out.println("</script>");
        response.sendRedirect("content.jsp?num=" + newArticleNum);

    } else { // 글 저장 실패
        out.println("<script>");
        out.println("alert('게시글 등록에 실패했습니다. 다시 시도해주세요.');");
        out.println("history.back();");
        out.println("</script>");
    }
%>