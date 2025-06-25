<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="member.UserDAO , java.io.File " %>
<%
    request.setCharacterEncoding("UTF-8");
    String ctx = request.getContextPath();

    // 1) 세션 체크
    String sid = (String) session.getAttribute("sid");
    if (sid == null) {
        response.sendRedirect(ctx + "/member/login.jsp");
        return;
    }

    // 2) MultipartRequest 생성
    String saveDir  = application.getRealPath("/resources/image");
    if (saveDir == null) {
        out.println("saveDir가 null입니다. 경로 확인 요망.");
        return;
    }
 	// 이 부분 추가
 	File dir = new File(saveDir);
	 if (!dir.exists()) {
	     dir.mkdirs();
	 }

	 int maxSize  = 10 * 1024 * 1024;   // 10MB
	 String encoding = "UTF-8";
	 MultipartRequest mr = new MultipartRequest(
	     request, saveDir, maxSize, encoding, new DefaultFileRenamePolicy()
	 );
 

    // 3) 파일 타입 검사
    String ct = mr.getContentType("profile");
    if (ct == null || !ct.startsWith("image/")) {
        mr.getFile("profile").delete();
        out.println("<script>alert('이미지 파일만 가능합니다.'); history.back();</script>");
        return;
    }

    // 4) 파일명 꺼내서 DAO 호출
    String filename = mr.getFilesystemName("profile");
    boolean ok = new UserDAO().updateProfile(sid, filename);

    // 5) 결과 처리
    if (ok) {
        response.sendRedirect(ctx + "/member/info.jsp");
    } else {
        out.println("<script>alert('업로드 실패'); history.back();</script>");
    }
%>
