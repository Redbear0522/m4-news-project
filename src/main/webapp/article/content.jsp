<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List, article.ArticleDAO, article.ArticleDTO, article.ArticleFileDTO" %>
<%
    String ctx      = request.getContextPath();
    String sid      = (String) session.getAttribute("sid");
 	
    // 1. 글 번호(num) 및 파라미터 검증
    String numParam = request.getParameter("num");
    if (numParam == null || numParam.trim().isEmpty()) {
        return;
    }
    int num = Integer.parseInt(numParam);

    // 목록으로 링크용 파라미터
    String categori = request.getParameter("categori");
    String pageNum  = request.getParameter("pageNum");

    // DAO 호출
    ArticleDAO dao    = new ArticleDAO();
    dao.increaseReadcount(num);
    ArticleDTO dto    = dao.getArticle(num);
    if (dto == null) {
        response.sendError(HttpServletResponse.SC_NOT_FOUND);
        return;
    }
    List<ArticleFileDTO> fileList = dao.getImgFileList(num);

    // list.jsp로 돌아갈 파라미터 빌드
    StringBuilder listUrlParams = new StringBuilder("?");
    if (categori != null && !categori.isEmpty()) {
        listUrlParams.append("categori=").append(categori);
    }
    if (pageNum != null && !pageNum.isEmpty()) {
        if (listUrlParams.length() > 1) listUrlParams.append("&");
        listUrlParams.append("pageNum=").append(pageNum);
    }

    // 카테고리 이름 매핑
    String categoryName;
    switch(dto.getCategori()) {
        case 1: categoryName = "정치";    break;
        case 2: categoryName = "경제";    break;
        case 3: categoryName = "사회";    break;
        case 4: categoryName = "연예";    break;
        case 5: categoryName = "스포츠";  break;
        case 6: categoryName = "블라인드"; break;
        case 7: categoryName = "기타";    break;
        case 8: categoryName = "Q&A";    break;
        default: categoryName = "";       break;
    }

    // 공감/비공감 중복 여부 체크 (추가)
    boolean alreadyReacted = false;
    if (sid != null) {
        try {
            String emotion = dao.getEmotionType(sid, num);
            alreadyReacted = (emotion != null);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title><%= dto.getSubject() %></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">
    <link rel="stylesheet" href="<%= ctx %>/resources/css/style.css">
</head>
<body >
    <jsp:include page="/views/layout/header.jsp" />
<div class="container p-4">
    <h2 class="mb-4">📰 뉴스 게시글 상세</h2>
    <table class="table table-bordered" >
        <tr>
            <th style="width:15%;">제목</th>
            <td><%= dto.getSubject() %></td>
        </tr>
        <tr>
            <th>작성자</th>
            <td><%= dto.getWriter() %></td>
        </tr>
        <tr>
            <th>등록일</th>
            <td><%= dto.getWrite_date() %></td>
        </tr>
        <tr>
            <th>조회수</th>
            <td><%= dto.getReadcount() %></td>
        </tr>
        <tr>
            <th>분야</th>
            <td><%= categoryName %></td>
        </tr>
        <tr>
            <th>사진</th>
            <td>
                <% if (fileList != null && !fileList.isEmpty()) {
                    for (ArticleFileDTO f : fileList) { %>
                        <img src="<%= ctx %>/upload/<%= f.getFile_name() %>"
                             class="img-fluid mb-2" alt="게시글 이미지"/>
                <%  }
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

    <!-- 공감/비공감 버튼 -->
    <div align="center" class="mb-3">
        <% if (sid != null) { %>
            <form action="<%= ctx %>/emotion/insertEmotion.jsp" method="post" style="display:inline-block;">
                <input type="hidden" name="emotionType" value="agree">
                <input type="hidden" name="articleNum" value="<%= num %>">
                <button type="submit" class="btn btn-outline-success" <%= alreadyReacted ? "disabled" : "" %>>
                    👍 공감
                </button>
            </form>

            <form action="<%= ctx %>/emotion/insertEmotion.jsp" method="post" style="display:inline-block; margin-left:10px;">
                <input type="hidden" name="emotionType" value="disagree">
                <input type="hidden" name="articleNum" value="<%= num %>">
                <button type="submit" class="btn btn-outline-danger" <%= alreadyReacted ? "disabled" : "" %>>
                    👎 비공감
                </button>
            </form>
        <% } else { %>
            <p><a href="<%= ctx %>/member/login.jsp">로그인</a> 후 공감/비공감이 가능합니다.</p>
        <% } %>
    </div>

    <div class="mt-3 text-center">
        <a href="<%= ctx %>/article/list.jsp<%= listUrlParams %>"	class="btn btn-secondary">	[목록으로]</a>
        <% if (sid != null && (sid.equals(dto.getWriter()) || "admin".equals(sid))) { %>
        <a href="updateForm.jsp?num=<%= dto.getNum() %>" 			class="btn btn-primary">	[수정하기]</a>
         <% request.setAttribute("dto", dto); %>
        <a 
		    href="${pageContext.request.contextPath}/member/admin/blindPro.jsp?num=${dto.num}&categori=${dto.categori}"
		    class="btn btn-danger"
		    onclick="return confirm('정말 블라인드 처리하시겠습니까?');"
		 >[블라인드]</a>
        <a href="deleteForm.jsp?num=<%= dto.getNum() %>" class="btn btn-danger">				[삭제하기]</a>
        <% } %>
    </div>

    <hr/>
</div>
<jsp:include page="/comment/comments.jsp" />
<jsp:include page="/views/layout/footer_new.jsp" />
</body>
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
</html>
