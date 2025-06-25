<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.text.SimpleDateFormat, article.ArticleDTO" %>

<%-- 1. 헤더 포함시키기 --%>
<%@ include file="/views/layout/header.jsp" %>

<%-- 2. 서버(컨트롤러)로부터 전달받은 데이터 준비 --%>
<%
    List<ArticleDTO> recList  = (List<ArticleDTO>) request.getAttribute("recList");
    // 다른 뉴스 리스트들도 필요하다면 여기에 추가 (예: pickList, viewList 등)
    
    SimpleDateFormat sdf = new SimpleDateFormat("MM.dd HH:mm");
%>

<%-- 3. 본문 콘텐츠 시작 --%>
<main class="site-content">
    <h1>오늘의 뉴스</h1>
    
    <div class="news-grid">
        <%
            // 1. 추천수 목록(recList)이 있는지, 그리고 비어있지 않은지 확인합니다.
            if (recList != null && !recList.isEmpty()) {
            
                // 2. 목록에 있는 기사만큼 반복해서 카드를 생성합니다.
                for (ArticleDTO a : recList) {
        %>
                    <a href="article?id=<%= a.getWriter() %>" class="news-card">
                        <div class="news-card-img-wrapper">
                            <img src="<%= a.getFile_num()%>" 
                                 onerror="this.src='${pageContext.request.contextPath}/static/images/noimg_big.png'" 
                                 class="news-card-img">
                        </div>
                        <div class="news-card-body">
                            <h5 class="news-card-title"><%= a.getSubject() %></h5>
                            <p class="news-card-info"><%= a.getWriter() %></p>
                        </div>
                    </a>
        <%
                } // for 반복문 끝
            
            } else {
                // 3. 표시할 뉴스가 없을 경우 메시지를 보여줍니다.
        %>
                <p>표시할 뉴스가 없습니다.</p>
        <%
            } // if-else 문 끝
        %>
    </div>

</main>
<%-- 본문 콘텐츠 끝 --%>

<%-- 4. 푸터 포함시키기 --%>
<%@ include file="/views/layout/footer_new.jsp" %>