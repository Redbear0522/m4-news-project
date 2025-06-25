<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.text.SimpleDateFormat, article.ArticleDAO, article.ArticleDTO" %>
<%
    request.setCharacterEncoding("UTF-8");
    String ctx = request.getContextPath();

    // ✅ 1. 페이징 처리 로직 추가
    
    int pageSize = 10;
    String pageNum = request.getParameter("pageNum");
    if (pageNum == null || pageNum.isEmpty()) pageNum = "1";
    int currentPage = Integer.parseInt(pageNum);
    int startRow    = (currentPage - 1) * pageSize + 1;
    int endRow      = currentPage * pageSize;

    // ✅ 2. DAO를 통해 QnA 게시물 목록과 전체 개수 조회
    ArticleDAO dao = new ArticleDAO();
    int count = dao.getQnaCount();
    List<ArticleDTO> list = dao.getQnaList(startRow, endRow );
    
    int number = count - (currentPage - 1) * pageSize; // 화면에 표시할 글 번호
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>QnA 건의 게시판</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="<%= ctx %>/resources/css/style.css"> <%-- CSS 경로 확인 필요 --%>
</head>
<body>
 <jsp:include page="/views/layout/header.jsp" />
<div class="container mt-4">
    <h2 class="text-center">QnA 건의 게시판</h2>
    
    <table class="table table-hover mt-3">
        <thead class="table-light">
            <tr>
                <th>번호</th>
                <th>제목</th>
                <th>작성자</th>
                <th>작성일</th>
            </tr>
        </thead>
        <tbody>
        <% if (list == null || list.isEmpty()) { %>
            <tr>
                <td colspan="4" class="text-center">등록된 QnA가 없습니다.</td>
            </tr>
        <% } else {
               for (ArticleDTO dto : list) { %>
            <tr>
                <td><%= number-- %></td>
                <td><a href="qnaDetail.jsp?num=<%= dto.getNum() %>&pageNum=<%= currentPage %>"><%= dto.getSubject() %></a></td>
                <td><%= dto.getWriter() %></td>
                <td><%= sdf.format(dto.getWrite_date()) %></td>
            </tr>
        <%     }
           } %>
        </tbody>
    </table>

    <div class="d-flex justify-content-center mt-4 pagination-custom">
    <%
        if (count > 0) {
            // 1. 전체 페이지 수 계산
            int pageCount = count / pageSize + (count % pageSize == 0 ? 0 : 1);
            
            // 2. 한 화면에 보여줄 페이지 번호의 수
            int pageBlock = 10;
            
            // 3. 현재 페이지가 속한 블록의 시작 페이지 번호 계산
            // (예: 현재 페이지가 7이면 시작페이지는 1, 15이면 11)
            int startPage = ((currentPage - 1) / pageBlock) * pageBlock + 1;
            
            // 4. 현재 페이지가 속한 블록의 끝 페이지 번호 계산
            int endPage = startPage + pageBlock - 1;
            if (endPage > pageCount) {
                endPage = pageCount;
            }

            // 5. [이전] 링크: 시작 페이지가 10보다 클 때만 표시
            if (startPage > 10) {
    %>
                <a href="<%= request.getContextPath() %>/news/qna/qnaList.jsp?pageNum=<%= startPage - 10 %>">[이전]</a>
    <%
            }

            // 6. 페이지 번호 링크: 시작 페이지부터 끝 페이지까지 반복
            for (int i = startPage; i <= endPage; i++) {
                if (i == currentPage) {
                    // 현재 페이지는 링크 없이 강조 표시
    %>
                    <span class="active">[<%= i %>]</span>
    <%
                } else {
                    // 다른 페이지는 링크 설정
    %>
                    <a href="<%= request.getContextPath() %>/news/qna/qnaList.jsp?pageNum=<%= i %>">[<%= i %>]</a>
    <%
                }
            } // for end

            // 7. [다음] 링크: 끝 페이지가 전체 페이지 수보다 작을 때만 표시
            if (endPage < pageCount) {
    %>
                <a href="<%= request.getContextPath() %>/news/qna/qnaList.jsp?pageNum=<%= startPage + 10 %>">[다음]</a>
    <%
            }
        }
    %>
    </div>
</div>

<%@ include file="/views/layout/footer_new.jsp" %>
</body>
</html>