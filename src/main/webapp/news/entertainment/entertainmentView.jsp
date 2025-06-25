<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="article.ArticleDAO, article.ArticleDTO, article.ArticleFileDTO" %>
<%
    request.setCharacterEncoding("UTF-8");
    String ctx = request.getContextPath();

    // 1) num 파라미터 검증
    String numParam = request.getParameter("num");
    if (numParam == null || numParam.trim().isEmpty()) {
%>
<script>
  alert("잘못된 접근입니다. 게시글 번호가 없습니다.");
  history.back();
</script>
<%
      return;
    }
    int num = Integer.parseInt(numParam);

    // 2) DAO에서 글 조회 (조회수 자동 증가 포함)
    ArticleDAO dao = new ArticleDAO();
	 				 dao.increaseReadcount(num);
    ArticleDTO dto = dao.getArticle(num);
    if (dto == null) {
%>
<script>
  alert("해당 게시글을 찾을 수 없습니다.");
  history.back();
</script>
<%
      return;
    }

    // 3) ✅ DAO에서 이미지 파일 목록 조회 (수정된 메서드 호출)
    List<ArticleFileDTO> fileList = dao.getImgFileList(num);

    // 4) 세션에서 로그인 정보
    String sid    = (String) session.getAttribute("sid");
    String status = (String) session.getAttribute("status"); // 관리자 여부 확인용
%>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>게시글 상세보기</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
</head>
<body>
<jsp:include page="/views/layout/header.jsp" /><div class="container p-4"> 
  <h2 class="mb-4">📰 연예 뉴스 게시글 상세</h2>
  <table class="table table-bordered">
    <tr><th style="width:15%;">제목</th><td><%= dto.getSubject() %></td></tr>
    <tr><th>작성자</th><td><%= dto.getWriter() %></td></tr>
    <tr><th>등록일</th><td><%= dto.getWrite_date() %></td></tr>
    <tr><th>조회수</th><td><%= dto.getReadcount() %></td></tr>
    <tr>
      <th>사진</th>
      <td>
        <%-- ✅ 수정된 파일 목록 출력 로직 --%>
	    <% if (fileList != null && !fileList.isEmpty()) {
	         for (ArticleFileDTO fileDto : fileList) { %>
	           <img src="<%= ctx %>/upload/<%= fileDto.getFile_name() %>" style="max-width:300px; height:auto;" class="me-2"

	                class="img-fluid mb-2" alt="게시글 이미지"/>

	    <%   }
	       } else { %>
	         <span>등록된 이미지가 없습니다.</span>
	    <% } %>
 	  </td>
    </tr>
    <tr>
        <div class="text-end mb-2">
		  <button type="button" id="font-decrease" class="btn btn-sm btn-outline-secondary">A–</button>
		  <button type="button" id="font-increase" class="btn btn-sm btn-outline-secondary">A+</button>
		</div>
		</tr>
    <tr>
            <th>내용</th>
            <td><div id="article-content" style="white-space: pre-wrap; word-wrap: break-word; font-size: 16px;">
                <pre style="white-space: pre-wrap; word-wrap: break-word;"><%= dto.getContent() %>
                </pre>
                </div>
            </td>
        </tr>
    
    
  </table>
  <div align="center">
	  <jsp:include page="/emotion/agreeButton.jsp" /><jsp:include page="/emotion/disagreeButton.jsp" /> 
	  </div>

  <div class="mt-3 text-center">
    <a href="<%= ctx %>/news/entertainment/entertainmentList.jsp" class="btn btn-secondary">[목록으로]</a>

    <%-- ✅ 본인 글이거나 관리자('admin' ID)인 경우에만 수정/삭제 --%>
    <% if (sid != null && (sid.equals(dto.getWriter()) || sid.equals("admin"))) { %>
      <a href="<%= request.getContextPath() %>/article/updateForm.jsp?num=<%= dto.getNum() %>" class="btn btn-primary">수정하기</a>
      <a href="<%= request.getContextPath() %>/member/admin/blindPro.jsp?num=<%= dto.getNum() %>&categori=6" class="btn btn-primary">블라인드</a>
      <a href="<%= request.getContextPath() %>/article/deleteForm.jsp?num=<%= dto.getNum() %>" class="btn btn-danger">삭제하기</a>
    <% } %>
  </div>

  <hr>
  
  <%-- ✅ [추가] 댓글 컴포넌트 포함 --%>
  <jsp:include page="/comment/comments.jsp">
      <jsp:param name="article_id" value="<%= dto.getNum() %>"/>
  </jsp:include>
  </div>
  <%@ include file="/views/layout/footer_new.jsp" %>
 <script>
  (function() {
    const content = document.getElementById('article-content');
    const minSize = 12, maxSize = 30, step = 2;

    function getSize() {
      return parseInt(window.getComputedStyle(content).fontSize);
    }

    function saveSize(size) {
      localStorage.setItem('articleFontSize', size);
    }

    function loadSize() {
      let stored = parseInt(localStorage.getItem('articleFontSize'));
      if (!isNaN(stored)) content.style.fontSize = stored + 'px';
    }

    function clearSize() {
      localStorage.removeItem('articleFontSize');
    }

    document.getElementById('font-increase')
      .addEventListener('click', () => {
        let size = getSize();
        if (size + step <= maxSize) {
          content.style.fontSize = (size + step) + 'px';
          saveSize(size + step);
        }
      });

    document.getElementById('font-decrease')
      .addEventListener('click', () => {
        let size = getSize();
        if (size - step >= minSize) {
          content.style.fontSize = (size - step) + 'px';
          saveSize(size - step);
        }
      });

    // 페이지 로드 시 마지막 설정 불러오기
    loadSize();

    // 페이지 떠날 때 초기화
    window.addEventListener('beforeunload', clearSize);
  })();
</script>
</body>
</html>