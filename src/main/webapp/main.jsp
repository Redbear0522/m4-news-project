<%-- WebContent/views/main.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, article.ArticleDAO, article.ArticleDTO" %>
<%
    ArticleDAO dao = new ArticleDAO();
    List<ArticleDTO> recList  = dao.getRecommendedTopN(10);
    List<ArticleDTO> pickList = dao.getEditorsPickTopN(4);
    List<ArticleDTO> viewList = dao.getMostViewedTopN(5);
    List<ArticleDTO> cmtList  = dao.getMostCommentedTopN(5);

    // 블라인드(6) 카테고리 제거
    recList.removeIf(a -> a.getCategori() == 6);
    pickList.removeIf(a -> a.getCategori() == 6);
    viewList.removeIf(a -> a.getCategori() == 6);
    cmtList.removeIf(a -> a.getCategori() == 6);

    String sid = (String) session.getAttribute("sid");
    if (sid == null) sid = "방문자";

    int hour = Calendar.getInstance().get(Calendar.HOUR_OF_DAY);
    String greet;
    if (hour >= 6 && hour < 12)       greet = "좋은 아침입니다!";
    else if (hour < 18)                greet = "즐거운 오후되세요.";
    else                               greet = "편안한 저녁되세요.";

    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>M4 News Portal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="<%= ctx %>/resources/css/style.css">
</head>
<body>

<jsp:include page="/views/layout/header.jsp" />

<main class="container py-4">
    <div class="alert alert-info mt-4 mb-5 text-center shadow-sm">
        <h4><strong><%= sid %></strong> 님, <%= greet %></h4>
        <p class="mb-0">M4뉴스 포털의 오늘의 뉴스를 확인해보세요. 매일 새롭고 중요한 소식들을 만나보세요.</p>
    </div>

    <div class="row">
        <div class="col-lg-8">

            <h2 class="mb-4">⭐ 편집장 Pick</h2>
            <div class="row row-cols-1 row-cols-md-2 g-4 mb-5">
                <% if (!pickList.isEmpty()) { %>
                    <% for (ArticleDTO article : pickList) {
                           String summary = article.getContent();
                           if (summary != null && summary.length() > 60) {
                               summary = summary.substring(0, 60) + "...";
                           }
                    %>
                    <div class="col">
                        <div class="card h-100 shadow-sm" style="cursor:pointer;"
                             onclick="location.href='<%= ctx %>/article/content.jsp?num=<%= article.getNum() %>'">
                            <div class="card-body">
                                <h5 class="card-title"><%= article.getSubject() %></h5>
                                <p class="card-text small text-muted"><%= summary %></p>
                            </div>
                        </div>
                    </div>
                    <% } %>
                <% } else { %>
                    <div class="col-12">
                        <p class="text-center text-muted">표시할 편집장 Pick 뉴스가 없습니다.</p>
                    </div>
                <% } %>
            </div>

            <hr class="my-5">

            <h2 class="mb-4">🔥 추천수 TOP 10</h2>
            <div class="list-group mb-5">
                <% if (!recList.isEmpty()) { %>
                    <% for (ArticleDTO article : recList) { %>
                    <a href="<%= ctx %>/article/content.jsp?num=<%= article.getNum() %>"
                       class="list-group-item list-group-item-action">
                        <div class="d-flex w-100 justify-content-between">
                            <h6 class="mb-1"><%= article.getSubject() %></h6>
                            <small>👍 <%= article.getAgree_count() %></small>
                        </div>
                        <small class="text-muted"><%= article.getWriter() %></small>
                    </a>
                    <% } %>
                <% } else { %>
                    <p class="text-center text-muted">표시할 추천 뉴스가 없습니다.</p>
                <% } %>
            </div>

        </div>
        <div class="col-lg-4">

            <div class="p-3 mb-4 bg-light rounded">
                <h4 class="fst-italic">랭킹 뉴스</h4>
            </div>

            <h5 class="mb-3">👀 많이 본 뉴스 TOP 5</h5>
            <table class="table table-sm table-borderless">
                <tbody>
                <% if (!viewList.isEmpty()) { int rank = 1; %>
                    <% for (ArticleDTO article : viewList) { %>
                    <tr>
                        <th scope="row"><%= rank++ %>.</th>
                        <td>
                            <a href="<%= ctx %>/article/content.jsp?num=<%= article.getNum() %>"
                               class="text-decoration-none">
                                <%= article.getSubject() %>
                            </a>
                        </td>
                    </tr>
                    <% } %>
                <% } else { %>
                    <tr><td class="text-center">표시할 뉴스가 없습니다.</td></tr>
                <% } %>
                </tbody>
            </table>

            <hr>

            <h5 class="mb-3">💬 댓글 많은 뉴스 TOP 5</h5>
            <ul class="list-group list-group-flush">
                <% if (!cmtList.isEmpty()) { %>
                    <% for (ArticleDTO article : cmtList) { %>
                    <a href="<%= ctx %>/article/content.jsp?num=<%= article.getNum() %>"
                       class="list-group-item list-group-item-action d-flex justify-content-between align-items-center">
                        <%= article.getSubject() %>
                        <span class="badge bg-primary rounded-pill"><%= article.getCmtCnt() %></span>
                    </a>
                    <% } %>
                <% } else { %>
                    <li class="list-group-item text-center">표시할 뉴스가 없습니다.</li>
                <% } %>
            </ul>

        </div>
    </div>
</main>

<jsp:include page="/views/layout/footer_new.jsp" />

</body>
</html>
