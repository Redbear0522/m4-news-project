<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="member.UserDAO, member.UserDTO, java.text.SimpleDateFormat" %>
<html>
<%
    String sid = (String) session.getAttribute("sid");
    UserDTO dto = null;
    String profile = null;

    if (sid != null) {
        UserDAO dao = new UserDAO();
        dto = dao.getUserById(sid);
        profile = dao.getProfile(sid);
    }
%>
<head>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
<link rel="stylesheet" href="<%= request.getContextPath()%>/resources/css/style.css">
<jsp:include page="/views/layout/header.jsp" />
<div class="page-container site-content">
<title>사이트 맵</title>
</head>
<body>
<div class="container mt-4">
    <h1>사이트 맵</h1>
    <hr><br>
    <ul>
        <li><a href="<%= request.getContextPath() %>/main.jsp">메인페이지</a></li>
        <hr>
        <% if ("admin".equals(sid)) { %>
        <li><a href="<%= request.getContextPath() %>/member/profile.jsp">				프로필사진 변경</a></li>
        <li><a href="<%= request.getContextPath() %>/member/info.jsp">					회원정보</a></li>
        <li><a href="<%= request.getContextPath() %>/member/updateForm.jsp">			회원정보수정</a></li>
        <li><a href="<%= request.getContextPath() %>/member/pwChangeForm.jsp">			비밀번호 변경</a></li>
        <li><a href="<%= request.getContextPath() %>/member/admin/infoAdminMember.jsp">	가입승인대기목록</a></li>
        <li><a href="<%= request.getContextPath() %>/article/list.jsp">					전체 기사</a></li>
        <li><a href="<%= request.getContextPath() %>/member/logout.jsp">				로그아웃</a></li>

        <% } else if (sid != null && dto != null && dto.getJob() == 2) { %>
        <li><a href="<%= request.getContextPath() %>/member/profile.jsp">				프로필사진 변경</a></li>
        <li><a href="<%= request.getContextPath() %>/member/info.jsp">					회원정보</a></li>
        <li><a href="<%= request.getContextPath() %>/member/updateForm.jsp">회원정보수정</a></li>
        <li><a href="<%= request.getContextPath() %>/member/pwChangeForm.jsp">비밀번호 변경</a></li>
        <li><a href="<%= request.getContextPath() %>/article/myArticle.jsp">내가 쓴 기사</a></li>
        <li><a href="<%= request.getContextPath() %>/article/writeForm.jsp">기사작성</a></li>
        <li><a href="<%= request.getContextPath() %>/member/deleteForm.jsp">회원탈퇴</a></li>
        <li><a href="<%= request.getContextPath() %>/member/logout.jsp">로그아웃</a></li>

        <% } else if (sid != null) { %>
        <li><a href="<%= request.getContextPath() %>/member/profile.jsp">프로필사진 변경</a></li>
        <li><a href="<%= request.getContextPath() %>/member/info.jsp">회원정보</a></li>
        <li><a href="<%= request.getContextPath() %>/member/updateForm.jsp">회원정보수정</a></li>
        <li><a href="<%= request.getContextPath() %>/member/pwChangeForm.jsp">비밀번호 변경</a></li>
        <li><a href="<%= request.getContextPath() %>/comment/myComment.jsp">내가 쓴 댓글</a></li>
        <li><a href="<%= request.getContextPath() %>/member/deleteForm.jsp">회원탈퇴</a></li>
        <li><a href="<%= request.getContextPath() %>/member/logout.jsp">로그아웃</a></li>
        <% } else{%>
        <li><a href="<%= request.getContextPath() %>/member/sinIn.jsp">회원가입</a></li>
        <li><a href="<%= request.getContextPath() %>/member/login.jsp">로그인</a></li>
        <li><a href="<%= request.getContextPath() %>/member/findId.jsp">아이디찾기</a></li>
        <li><a href="<%= request.getContextPath() %>/member/findPw.jsp">비밀번호찾기</a></li>
		<%} %>
        <hr>
        <li><a href="${pageContext.request.contextPath}/news/politics/politicsList.jsp">정치</a></li>
        <li><a href="${pageContext.request.contextPath}/news/economy/economyList.jsp">경제</a></li>
        <li><a href="${pageContext.request.contextPath}/news/society/societyList.jsp">사회</a></li>
        <li><a href="${pageContext.request.contextPath}/news/entertainment/entertainmentList.jsp">연예</a></li>
        <li><a href="${pageContext.request.contextPath}/news/sports/sportsList.jsp">스포츠</a></li>
		<hr>
        <li><a href="${pageContext.request.contextPath}#">많이 본 기사</a></li>
        <li><a href="${pageContext.request.contextPath}#">추천수 많은 기사</a></li>
        <li><a href="${pageContext.request.contextPath}/news/qna/qnaList.jsp">Q & A</a></li>
        <li><a href="${pageContext.request.contextPath}/company_intro.jsp">M4 소개</a></li>
    </ul>
</div>
</div>
<%@ include file="/views/layout/footer_new.jsp"%>
</body>
</html>
