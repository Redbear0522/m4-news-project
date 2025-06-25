<%@ page contentType="text/html; charset=UTF-8" %>
<%
    String sid = (String) session.getAttribute("sid");  // 로그인 아이디
    int articleNum = Integer.parseInt(request.getParameter("num"));
    int agreeCount = 0;
    boolean hasAgreed = false;

    try {
        article.ArticleDAO dao = new article.ArticleDAO();
        agreeCount = dao.getAgreeCount(articleNum);
        if (sid != null) {
            hasAgreed = dao.hasAgreed(sid, articleNum);
        }
    } catch(Exception e) {
        e.printStackTrace();
    }
%>

<% if (sid == null) { %>
    <p>로그인 후 공감할 수 있습니다.</p>
<% } else if (hasAgreed) { %>
    <button disabled>👍 공감 (<span id="agreeCount"><%=agreeCount%></span>)</button>
    <p>이미 공감하셨습니다.</p>
<% } else { %>
    <button id="agreeBtn">👍 공감 (<span id="agreeCount"><%=agreeCount%></span>)</button>
<% } %>

<script>
document.getElementById('agreeBtn')?.addEventListener('click', function() {
    fetch('<%=request.getContextPath()%>/emotion/increaseAgree.jsp?num=<%=articleNum%>', {
        method: 'POST'
    })
    .then(response => response.text())
    .then(result => {
        if(result.trim() === 'success') {
            let countElem = document.getElementById('agreeCount');
            countElem.textContent = parseInt(countElem.textContent) + 1;
            alert("공감 완료!");
            location.reload();
        } else if(result.trim() === 'duplicate') {
            alert("공감, 비공감은 각 한번만 가능합니다.");
        } else {
            alert("공감 처리 실패!");
        }
    })
    .catch(err => alert("서버 오류: " + err));
});
</script>
