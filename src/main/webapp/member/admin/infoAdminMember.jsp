<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="member.UserDAO, member.UserDTO, java.util.List, java.net.URLEncoder, java.text.SimpleDateFormat" %>
<%!
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
%>
<%
    // 관리자 권한 체크
    String admin = (String) session.getAttribute("sid");
    if (admin == null || !"admin".equals(admin)) {
        response.sendRedirect("main.jsp");
        return;
    }
    // 승인 대기 회원 리스트 조회
    List<UserDTO> pending = new UserDAO().getPendingMembers();
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>가입 승인 대기 목록</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="p-4">
<jsp:include page="/views/layout/header.jsp" />
    <div class="container">
        <h1 class="mb-4">가입 승인 대기 목록</h1>
        <a href="<%= request.getContextPath() %>/member/info.jsp" class="btn btn-secondary mb-3">관리자 메인으로 돌아가기</a>
        <table class="table table-bordered">
            <thead class="table-light">
                <tr>
                    <th>아이디</th>
                    <th>이름</th>
                    <th>가입일</th>
                    <th>처리</th>
                </tr>
            </thead>
            <tbody>
                <% if (pending == null || pending.isEmpty()) { %>
                    <tr>
                        <td colspan="4" class="text-center">승인 대기중인 회원이 없습니다.</td>
                    </tr>
                <% } else {
                       for (UserDTO u : pending) { %>
                    <tr>
                        <td><%= u.getId() %></td>
                        <td><%= u.getName() %></td>
                        <td><%= sdf.format(u.getRegDate()) %></td>
                        <td>
                            <a class="btn btn-sm btn-success"
                               href="approvePro.jsp?id=<%= URLEncoder.encode(u.getId(), "UTF-8") %>&status=Y">
                                승인
                            </a>
                            <a class="btn btn-sm btn-danger"
                               href="approvePro.jsp?id=<%= URLEncoder.encode(u.getId(), "UTF-8") %>&status=N">
                                거절
                            </a>
                        </td>
                    </tr>
                <%   }
                   } %>
            </tbody>
        </table>
    </div>
<%@ include file="/views/layout/footer_new.jsp" %>
</body>
</html>
