<%@ page contentType="text/html; charset=UTF-8" %>
<%
    String sid = (String) session.getAttribute("sid");  // 로그인 아이디
    int articleNum = Integer.parseInt(request.getParameter("num"));
    int disagreeCount = 0;
    boolean hasDisagreed = false;

    try {
        article.ArticleDAO dao = new article.ArticleDAO();
        disagreeCount = dao.getDisagreeCount(articleNum);
        if (sid != null) {
            hasDisagreed = dao.hasDisagreed(sid, articleNum);
        }
    } catch(Exception e) {
        e.printStackTrace();
    }
%>

<% if (sid == null) { %>
    <p>로그인 후 비공감할 수 있습니다.</p>
<% } else if (hasDisagreed) { %>
    <button disabled>👎 비공감 (<span id="disagreeCount"><%=disagreeCount%></span>)</button>
    <p>이미 비공감하셨습니다.</p>
<% } else { %>
    <button id="disagreeBtn">👎 비공감 (<span id="disagreeCount"><%=disagreeCount%></span>)</button>
<% } %>

<script>
document.getElementById('disagreeBtn')?.addEventListener('click', function() {
    fetch('<%=request.getContextPath()%>/emotion/increaseDisagree.jsp?num=<%=articleNum%>', {
        method: 'POST'
    })
    .then(response => response.text())
    .then(result => {
        if(result.trim() === 'success') {
            let countElem = document.getElementById('disagreeCount');
            countElem.textContent = parseInt(countElem.textContent) + 1;
            alert("비공감 완료!");
            location.reload();
        } else if(result.trim() === 'duplicate') {
            alert("공감, 비공감은 각 한번만 가능합니다.");
        } else {
            alert("비공감 처리 실패!");
        }
    })
    .catch(err => alert("서버 오류: " + err));
});
</script>
