<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="member.UserDAO, member.UserDTO" %>
<%
    request.setCharacterEncoding("UTF-8");

    // 로그인 체크
    String sid = (String) session.getAttribute("sid");
    if (sid == null) {
%>
    <script>
        alert("로그인이 필요합니다.");
        location.href = "<%= request.getContextPath() %>/member/loginForm.jsp";
    </script>
<%
        return;
    }

    // DB에서 사용자 정보 조회
    UserDAO dao = new UserDAO();
    UserDTO user = dao.getUserById(sid);

    // ✅ 기자(job==2)가 아니면 작성 불가
    if (user == null || user.getJob() != 2) {
%>
    <script>
        alert("기자 회원만 게시글을 작성할 수 있습니다.");
        history.back();
    </script>
<%
        return;
    }
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>뉴스 작성하기</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script>
        function addFile() {
            const fileArea = document.getElementById("fileArea");
            const newDiv = document.createElement("div");
            newDiv.className = "mt-2";
            const input = document.createElement("input");
            input.type = "file";
            input.name = "img"; // ✅ name을 'img'로 통일
            input.className = "form-control";
            newDiv.appendChild(input);
            fileArea.appendChild(newDiv);
        }
    </script>
</head>
<body >
<jsp:include page="/views/layout/header.jsp" />
<div class="container p-4">
<h2 class="mb-4">📰 뉴스 게시글 작성</h2>
<form action="writePro.jsp" method="post" enctype="multipart/form-data" class="mb-5">

    <div class="mb-3">
        <label class="form-label">작성자</label>
        <%-- ✅ 작성자는 로그인된 아이디로 고정 --%>
        <input type="text" class="form-control" value="<%= sid %>" readonly>
        <input type="hidden" name="writer" value="<%= sid %>">
    </div>

    <div class="mb-3">
        <label class="form-label">제목</label>
        <input type="text" name="subject" class="form-control" required>
    </div>

    <div class="mb-3">
        <label class="form-label">카테고리</label>
        <select name="categori" class="form-control" required>
		  <option value="">-- 선택하세요 --</option>
		  <option value="1">정치</option>
		  <option value="2">경제</option>
		  <option value="3">사회</option>
		  <option value="4">연예</option>
		  <option value="5">스포츠</option>
		  <option value="6">블라인드</option>
		  <option value="7">기타</option>
		  <option value="8">Q&A</option>
		</select>
    </div>

    <div class="mb-3">
        <label class="form-label">내용</label>
        <textarea name="content" rows="10" class="form-control" required></textarea>
    </div>

    <div class="mb-3">
        <label class="form-label">사진 업로드</label>
        <div id="fileArea">
            <div>
                 <input type="file" name="img" class="form-control">
            </div>
        </div>
        <button type="button" class="btn btn-sm btn-outline-secondary mt-2" onclick="addFile()">파일 추가</button>
    </div>

    <div class="mb-3">
        <label class="form-label">비밀번호 (글 수정/삭제시 필요)</label>
        <input type="password" name="passwd" class="form-control" required>
    </div>

    <div class="d-flex justify-content-between">
        <button type="submit" class="btn btn-primary">등록</button>
        <a href="list.jsp" class="btn btn-secondary">목록으로</a>
    </div>
</form>
</div>
<%@ include file="/views/layout/footer_new.jsp" %>
</body>
</html>