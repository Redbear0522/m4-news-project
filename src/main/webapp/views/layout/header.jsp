<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="member.UserDAO" %> <%-- 이런 import 구문은 남겨둬도 괜찮습니다. --%>
<%
    String sid = (String) session.getAttribute("sid");
%>
<header>
<!DOCTYPE html>
<html lang="ko">
    <%-- 4단계에서 만든 CSS 파일을 링크합니다. --%>
     <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/resources/css/style.css">

<%-- 모든 페이지를 감싸는 컨테이너 시작 --%>
<div class="page-container">

    <header class="site-header">
        <div class="logo">
            <a href="<%=request.getContextPath()%>/main.jsp">M4뉴스</a>
        </div>
        <div class="user-menu">
            <%-- 세션 정보를 이용한 로그인/로그아웃 분기 처리 (예시) --%>
            <% if (session.getAttribute("sid") != null) { %>
                <span><strong><%= session.getAttribute("sid") %></strong>님 환영합니다!</span>
                <a href="${pageContext.request.contextPath}/member/info.jsp">마이페이지</a>
                <a href="${pageContext.request.contextPath}/member/logout.jsp">로그아웃</a>
            <% } else { %>
                <a href="${pageContext.request.contextPath}/member/login.jsp">로그인</a>
                <a href="${pageContext.request.contextPath}/member/sinIn.jsp">회원가입</a>
            <% } %>
        </div>
    </header>

    <nav class="site-nav">
        <ul class="main-menu">
        <li><a href="${pageContext.request.contextPath}/company_intro.jsp">						M4 소개</a></li>
	    <li><a href="${pageContext.request.contextPath}/news/politics/politicsList.jsp">		정치</a></li>
	    <li><a href="${pageContext.request.contextPath}/news/economy/economyList.jsp">			경제</a></li>
        <li><a href="${pageContext.request.contextPath}/news/society/societyList.jsp">			사회</a></li>
        <li><a href="${pageContext.request.contextPath}/news/entertainment/entertainmentList.jsp">연예</a></li>
        <li><a href="${pageContext.request.contextPath}/news/sports/sportsList.jsp">			스포츠</a></li>
        <% if ("admin".equals(sid)) { %>
        <li><a href="${pageContext.request.contextPath}/article/list.jsp">					전체 기사</a></li>
        <li><a href="${pageContext.request.contextPath}/member/admin/blind.jsp">					블라인드</a></li>
        <%} %>
        <li><a href="${pageContext.request.contextPath}/news/qna/qnaList.jsp">					건의 사항</a></li>
        <li><a href="${pageContext.request.contextPath}/views/sitemap/siteMap.jsp">				사이트맵</a></li>
            
        </ul>
        <div class="search-bar">
            <form method="get" action="<%= request.getContextPath()%>/article/list.jsp">
			    <select name="searchType">
			        <option value="subject">제목</option>
			        <option value="writer">기자</option>
			        <option value="content">내용</option>
			    </select>
			    <input type="text" name="keyword" placeholder="검색어를 입력하세요">
			    <button type="submit">검색</button>
            </form>
        </div>
    </nav>