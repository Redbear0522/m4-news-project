<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page
	import="member.UserDAO, member.UserDTO, java.text.SimpleDateFormat"%>
<%
// 1) 한글 파라미터 처리
request.setCharacterEncoding("UTF-8");

// 2) 로그인 세션 확인
String sid = (String) session.getAttribute("sid");
if (sid == null) {
	response.sendRedirect(request.getContextPath() + "/main.jsp");
	return;
}

// 3) DAO로 사용자 정보 조회
UserDAO dao = new UserDAO();
UserDTO dto = dao.getUserById(sid);
String profile = dao.getProfile(sid);

// 4) 생년월일 포맷팅
String birth = "";
if (dto.getBirth() != null) {
	birth = new SimpleDateFormat("yyyy-MM-dd").format(dto.getBirth());
}
%>

<%
String ctx = request.getContextPath();
if (sid == null) {
	response.sendRedirect(ctx + "/member/login.jsp");
	return;
}
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>회원 정보</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
</head>
<body>
	<jsp:include page="/views/layout/header.jsp" />

	<div class="container" align="center">

		<%
		if ("admin".equals(sid)) {
		%>
		<!-- 관리자 뷰 -->
		<h1 class="mb-4">관리자 정보</h1>
		<div class="card mx-auto my-4" style="width: 70%;">
			<img src="<%=ctx%>/resources/image/<%=profile%>" alt="프로필 이미지"
				class="card-img-top img-fluid d-block mx-auto" style="width: 30%;" />
			<div class="card-body text-center">
				<h5 class="card-title">
					[<%=sid%>] 관리자
				</h5>
			</div>
			<ul class="list-group list-group-flush">
				<li class="list-group-item">이 름 : <%=dto.getName()%></li>
				<li class="list-group-item">생년월일 : <%=birth%></li>
				<li class="list-group-item">성별: <%
				if (dto.getGender() != null && dto.getGender() == 1) {
					out.print("남자");
				} else {
					out.print("여자");
				}
				%>
				</li>
				<li class="list-group-item">연 락 처 : [<%
				if (dto.getPhone1() != null && dto.getPhone1() == 1) {
					out.print("SKT");
				} else if (dto.getPhone1() == 2) {
					out.print("KT");
				} else {
					out.print("LGU+");
				}
				%>]
					<%=dto.getPhone2()%></li>
				<li class="list-group-item">직 업 : 관리자</li>
				<li class="list-group-item">주 소 : <%=dto.getZip()%> <%=dto.getAddr1()%>
					<%=dto.getAddr2()%></li>
			</ul>
			<div class="card-body d-flex flex-wrap gap-2">
				<a href="<%=request.getContextPath()%>/member/profile.jsp"
					class="btn btn-outline-primary">사진 변경</a> <a
					href="<%=request.getContextPath()%>/member/updateForm.jsp"
					class="btn btn-outline-secondary">정보 수정</a> <a
					href="<%=request.getContextPath()%>/member/pwChangeForm.jsp"
					class="btn btn-outline-warning">비밀번호 변경</a> <a
					href="<%=request.getContextPath()%>/member/admin/infoAdminMember.jsp"
					class="btn btn-outline-info">승인 대기 리스트</a> <a
					href="<%=request.getContextPath()%>/member/admin/blockUser.jsp"
					class="btn btn-outline-danger">불량 회원 차단</a> <a
					href="<%=request.getContextPath()%>/article/list.jsp"
					class="btn btn-outline-secondary">전체 기사</a> <a
					href="<%=request.getContextPath()%>/main.jsp"
					class="btn btn-outline-dark">메인으로</a> <a
					href="<%=request.getContextPath()%>/member/logout.jsp"
					class="btn btn-outline-danger">로그아웃</a>
			</div>
		</div>

		<%
		} else if (dto.getJob() == 2) {
		%>
		<!-- 기자 뷰 -->
		<h1 class="mb-4">기자 정보</h1>
		<div class="card mx-auto my-4" style="width: 70%;">
			<img src="<%=ctx%>/resources/image/<%=profile%>" alt="프로필 이미지"
				class="card-img-top img-fluid d-block mx-auto" style="width: 30%;" />
			<div class="card-body text-center">
				<h5 class="card-title">
					[<%=sid%>] 기자님
				</h5>
			</div>
			<ul class="list-group list-group-flush">
				<li class="list-group-item">이름: <%=dto.getName()%></li>
				<li class="list-group-item">생년월일: <%=birth%></li>
				<li class="list-group-item">성별: <%
				if (dto.getGender() != null && dto.getGender() == 1) {
					out.print("남자");
				} else {
					out.print("여자");
				}
				%>
				</li>
				<li class="list-group-item">연락처: [<%
				if (dto.getPhone1() != null && dto.getPhone1() == 1) {
					out.print("SKT");
				} else if (dto.getPhone1() == 2) {
					out.print("KT");
				} else {
					out.print("LGU+");
				}
				%>]
					<%=dto.getPhone2()%></li>
				<li class="list-group-item">직업: <%
				if (dto.getJob() != null && dto.getJob() == 1) {
					out.print("일반");
				} else {
					out.print("기자");
				}
				%></li>
				<li class="list-group-item">소속: <%=dto.getCompany()%></li>
				<li class="list-group-item">주소: <%=dto.getZip()%> <%=dto.getAddr1()%>
					<%=dto.getAddr2()%></li>
			</ul>
			<div class="card-body d-flex flex-wrap gap-2">
				<a href="<%=request.getContextPath()%>/member/profile.jsp"
					class="btn btn-outline-info">사진 변경</a> <a
					href="<%=request.getContextPath()%>/member/updateForm.jsp"
					class="btn btn-outline-secondary">정보 수정</a> <a
					href="<%=request.getContextPath()%>/article/myArticle.jsp"
					class="btn btn-outline-primary">내 기사목록</a> <a
					href="<%=request.getContextPath()%>/article/writeForm.jsp"
					class="btn btn-outline-success">기사 작성</a> <a
					href="<%=request.getContextPath()%>/member/deleteForm.jsp"
					class="btn btn-outline-danger">회원 탈퇴</a> <a
					href="<%=request.getContextPath()%>/member/pwChangeForm.jsp"
					class="btn btn-outline-warning">비밀번호 변경</a> <a
					href="<%=request.getContextPath()%>/main.jsp"
					class="btn btn-outline-dark">메인으로</a> <a
					href="<%=request.getContextPath()%>/member/logout.jsp"
					class="btn btn-outline-danger">로그아웃</a>
			</div>
		</div>

		<%
		} else {
		%>
		<!-- 일반 회원 뷰 -->
		<h1 class="mb-4">내 정보</h1>
		<div class="card mx-auto my-4" style="width: 70%;">
			<img src="<%=ctx%>/resources/image/<%=profile%>" alt="프로필 이미지"
				class="card-img-top img-fluid d-block mx-auto" style="width: 30%;" />
			<div class="card-body text-center">
				<h5 class="card-title">
					[<%=sid%>] 님
				</h5>
			</div>
			<ul class="list-group list-group-flush">
				<li class="list-group-item">이름: <%=dto.getName()%></li>
				<li class="list-group-item">생년월일: <%=birth%></li>
				<li class="list-group-item">성별: <%
				if (dto.getGender() != null && dto.getGender() == 1) {
					out.print("남자");
				} else {
					out.print("여자");
				}
				%>
				</li>
				<li class="list-group-item">연락처: [<%
				if (dto.getPhone1() != null && dto.getPhone1() == 1) {
					out.print("SKT");
				} else if (dto.getPhone1() == 2) {
					out.print("KT");
				} else {
					out.print("LGU+");
				}
				%>]
					<%=dto.getPhone2()%></li>
				<li class="list-group-item">직업: <%
				if (dto.getJob() != null && dto.getJob() == 1) {
					out.print("일반");
				} else {
					out.print("기자");
				}
				%></li>
				<li class="list-group-item">주소: <%=dto.getZip()%> <%=dto.getAddr1()%>
					<%=dto.getAddr2()%></li>
			</ul>
			<div class="card-body d-flex flex-wrap gap-2">
				<a href="<%=request.getContextPath()%>/member/profile.jsp"
					class="btn btn-outline-primary">사진 변경</a> <a
					href="<%=request.getContextPath()%>/member/updateForm.jsp"
					class="btn btn-outline-secondary">정보 수정</a> <a
					href="<%=request.getContextPath()%>/member/pwChangeForm.jsp"
					class="btn btn-outline-warning">비밀번호 변경</a> <a
					href="<%=request.getContextPath()%>/comment/myComment.jsp"
					class="btn btn-outline-info">내가 쓴 댓글</a> <a
					href="<%=request.getContextPath()%>/member/deleteForm.jsp"
					class="btn btn-outline-danger">회원 탈퇴</a> <a
					href="<%=request.getContextPath()%>/main.jsp"
					class="btn btn-outline-dark">메인으로</a> <a
					href="<%=request.getContextPath()%>/member/logout.jsp"
					class="btn btn-outline-danger">로그아웃</a>
			</div>
		</div>
		<%
		}
		%>

	</div>
	<%@ include file="/views/layout/footer_new.jsp"%>
</body>
</html>
