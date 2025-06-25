<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="member.UserDAO"%>
<%
String id = request.getParameter("id");
System.out.println("▶ 팝업으로 전달된 id: [" + id + "]");
boolean duplicate = id != null && !id.trim().isEmpty() && new UserDAO().isIdExists(id);
String message;
String btnLabel;
if (id == null || id.trim().isEmpty()) {
	message = "아이디를 입력해주세요.";
	btnLabel = "닫기";
} else if (duplicate) {
	message = "입력한 아이디 (" + id + ")는 이미 사용 중입니다.";
	btnLabel = "닫기";
} else {
	message = "입력한 아이디 (" + id + ")는 사용 가능합니다.";
	btnLabel = "사용하기";
}
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>아이디 중복확인</title>
</head>
<body>
	<%@ include file="/views/layout/header.jsp" %>
	<p><%=message%></p>
	<button id="actionBtn"><%=btnLabel%></button>
	<script>
   document.getElementById('actionBtn').onclick = function() {
       // 성공 시 hidden 값을 true 로
       <%if (!duplicate && id != null && !id.trim().isEmpty()) {%>
           opener.document.getElementById('idChecked').value = 'true';
       <%}%>
       // 항상 메시지 출력
       opener.document.getElementById('idCheckMessage').innerText = '<%=message%>';
       // 팝업 닫기
       window.close();
   };
    </script>
    <%@ include file="/views/layout/footer_new.jsp" %>
</body>
</html>