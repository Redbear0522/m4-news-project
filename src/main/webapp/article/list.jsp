<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.text.SimpleDateFormat, article.ArticleDAO, article.ArticleDTO" %>
<%
    String ctx = request.getContextPath();
    // 검색 파라미터
    String searchType = request.getParameter("searchType");
    String keyword    = request.getParameter("keyword");
    boolean isSearch  = (searchType != null && keyword != null && !keyword.trim().isEmpty());
    List<String> allowed = Arrays.asList("subject","writer","content");
    if (isSearch && !allowed.contains(searchType)) {
        isSearch = false;
    }

    // 카테고리 파라미터
    String categoriStr = request.getParameter("categori");
    Integer categori = null;
    String categoryTitle = "전체 기사";
    if (!isSearch && categoriStr != null && !categoriStr.trim().isEmpty()) {
        try {
            categori = Integer.parseInt(categoriStr);
            switch (categori) {
                case 1: categoryTitle = "정치 뉴스"; break;
                case 2: categoryTitle = "경제 뉴스"; break;
                case 3: categoryTitle = "사회 뉴스"; break;
                case 4: categoryTitle = "연예 뉴스"; break;
                case 5: categoryTitle = "스포츠 뉴스"; break;
                case 6: categoryTitle = "블라인드 뉴스"; break;
                case 7: categoryTitle = "기타"; break;
                case 8: categoryTitle = "QnA 건의사항"; break;
            }
        } catch (NumberFormatException e) { categori = null; }
    }

    // 페이징 설정
    int pageSize = 10;
    String pageNum = request.getParameter("pageNum");
    if (pageNum == null || pageNum.isEmpty()) pageNum = "1";
    int currentPage = Integer.parseInt(pageNum);
    int startRow    = (currentPage - 1) * pageSize + 1;
    int endRow      = currentPage * pageSize;

    ArticleDAO dao = new ArticleDAO();
    int count = 0;
    List<ArticleDTO> list;

    if (isSearch) {
        // 검색 모드
        count = dao.getSearchArticleCount(searchType, keyword);
        list  = dao.getSearchArticleList(startRow, endRow, searchType, keyword);
        categoryTitle = "검색 결과: '" + keyword + "' (" + count + "건)";
    } else if (categori != null) {
        // 카테고리 모드
        count = dao.getArticleCount(categori);
        list  = dao.getArticleList(startRow, endRow, categori);
    } else {
        // 전체 모드
        count = dao.getArticleCount();
        list  = dao.getArticleList(startRow, endRow);
    }

    int number = count - (currentPage - 1) * pageSize;
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

    // 링크 유지용 파라미터
    String pageUrlParams = "";
    if (isSearch) {
        pageUrlParams = "searchType="+searchType+"&keyword="+java.net.URLEncoder.encode(keyword,"UTF-8")+"&";
    } else if (categori != null) {
        pageUrlParams = "categori="+categori+"&";
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title><%= categoryTitle %></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="<%= ctx %>/resources/css/style.css">
    <style>
        .pagination-custom a { color: black; padding:8px 12px; text-decoration:none; border:1px solid #ddd; margin:0 2px; }
        .pagination-custom a:hover { background:#f1f1f1; }
        .pagination-custom .active { font-weight:bold; color:red; padding:8px 12px; margin:0 2px; }
    </style>
</head>
<body>
<%@ include file="/views/layout/header.jsp" %>
<div class="container mt-4">
    <h2 class="text-center">📰 <%= categoryTitle %></h2>
    <table class="table table-hover mt-3">
        <thead class="table-light">
            <tr><th>번호</th><th>제목</th><th>작성자</th><th>등록일</th><th>조회수</th></tr>
        </thead>
        <tbody>
        <% if (list.isEmpty()) { %>
            <tr><td colspan="5" class="text-center">등록된 글이 없습니다.</td></tr>
        <% } else {
               for (ArticleDTO dto : list) { %>
            <tr>
                <td><%= number-- %></td>
                <td><a href="content.jsp?num=<%= dto.getNum() %>&<%= pageUrlParams %>pageNum=<%= currentPage %>"><%= dto.getSubject() %></a></td>
                <td><%= dto.getWriter() %></td>
                <td><%= sdf.format(dto.getWrite_date()) %></td>
                <td><%= dto.getReadcount() %></td>
            </tr>
              </tr>
			    <%  // 내용 미리보기(최대 50자) 출력
				    String full = dto.getContent();
				    String preview;
				    int maxLen = 50;
				    if (full == null) {
				        preview = "";
				    } else if (full.length() > maxLen) {
				        preview = full.substring(0, maxLen) + "...";
				    } else {
				        preview = full;
				    }
				    // 줄바꿈(\r?\n)을 공백으로 치환
				    preview = preview.replaceAll("\\r?\\n", " ");
				%>
				<tr>
				    <td colspan="5" class="text-muted small">
				        <%= preview %>
				    </td>
				</tr>
        <% }} %>
        </tbody>
    </table>

    <div class="d-flex justify-content-center mt-4 pagination-custom">
    <%
        if (count > 0) {
            int pageCount = count / pageSize + (count % pageSize == 0 ? 0 : 1);
            int pageBlock = 10;
            int startPage = ((currentPage - 1) / pageBlock) * pageBlock + 1;
            int endPage   = Math.min(startPage + pageBlock - 1, pageCount);

            if (startPage > pageBlock) {
    %><a href="list.jsp?<%= pageUrlParams %>pageNum=<%= startPage - pageBlock %>">[이전]</a><%
            }
            for (int i = startPage; i <= endPage; i++) {
                if (i == currentPage) {
    %><span class="active">[<%= i %>]</span><%
                } else {
    %><a href="list.jsp?<%= pageUrlParams %>pageNum=<%= i %>">[<%= i %>]</a><%
                }
            }
            if (endPage < pageCount) {
    %><a href="list.jsp?<%= pageUrlParams %>pageNum=<%= startPage + pageBlock %>">[다음]</a><%
            }
        }
    %>
    </div>
</div>
<%@ include file="/views/layout/footer_new.jsp" %>
</body>
</html>
