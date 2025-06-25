<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="/views/layout/header.jsp" />

<%
    String contextPath = request.getContextPath();
%>

<div class="write-container">
    <h2>경제 뉴스 작성</h2>
    <form action="<%= contextPath %>/news/economyWritePro.jsp" method="post" enctype="multipart/form-data">
        <input type="text" name="title" placeholder="제목을 입력하세요" required style="width: 100%; padding: 10px; margin-bottom: 10px;" />
        <input type="text" name="writer" placeholder="기자 이름" required style="width: 100%; padding: 10px; margin-bottom: 10px;" />
        <textarea name="content" placeholder="뉴스 내용을 입력하세요" required style="width: 100%; height: 200px; padding: 10px;"></textarea>

        <!-- 이미지 파일 첨부 -->
        <input type="file" name="thumbnail" accept="image/*" style="margin-top: 10px;" />

        <div style="margin-top: 16px; text-align: right;">
            <button type="submit" class="write-btn">등록</button>
        </div>
    </form>
</div>

<%@ include file="/views/layout/footer_new.jsp" %>
