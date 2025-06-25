<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ page import="member.UserDAO, member.UserDTO, java.text.SimpleDateFormat" %>
<%
    // 1) 문자 인코딩
    request.setCharacterEncoding("UTF-8");

    // 2) 로그인 세션 확인
    String sid = (String) session.getAttribute("sid");
    if (sid == null) {
        response.sendRedirect("loginForm.jsp");
        return;
    }

    // 3) DAO로 사용자 정보 조회
    UserDAO dao = new UserDAO();
    UserDTO dto = dao.getUserById(sid);
    				
    if (dto == null) {
        out.println("<script>alert('사용자 정보를 불러올 수 없습니다.'); history.back();</script>");
        return;
    }

    // 4) 생년월일 포맷팅
    String birthVal = "";
    if (dto.getBirth() != null) {
        birthVal = new SimpleDateFormat("yyyy-MM-dd")
                       .format(dto.getBirth());
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>회원 정보 수정</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">
</head>
<body>
<div  class="p-4">
     <jsp:include page="/views/layout/header.jsp" />
     
    <div class="container">
        <h1 class="mb-4">회원 정보 수정</h1>
        <form action="updatePro.jsp" method="post" class="row g-3">
            <input type="hidden" name="id" value="<%= dto.getId() %>" />
			<input type="hidden" name="job" value="<%= dto.getJob() != null ? dto.getJob() : 0 %>" />
            <!-- 아이디 (읽기 전용) -->
            <div class="col-12">
                <label class="form-label">아이디</label>
                <input type="text" class="form-control"
                       value="<%= dto.getId() %>" disabled />
            </div>

            <!-- 이름 -->
            <div class="col-md-6">
                <label class="form-label">이름</label>
                <input type="text" name="name" class="form-control"
                       value="<%= dto.getName() %>" required />
            </div>

            <!-- 생년월일 -->
            <div class="col-md-6">
                <label class="form-label">생년월일</label>
                <input type="date" name="birth" class="form-control"
                       value="<%= birthVal %>" />
            </div>

            <!-- 성별 -->
            <div class="col-md-4">
                <label class="form-label">성별</label>
                <select name="gender" class="form-select">
                    <option value="1"
                      <%= dto.getGender()!=null && dto.getGender()==1
                         ? "selected" : "" %>>남</option>
                    <option value="2"
                      <%= dto.getGender()!=null && dto.getGender()==2
                         ? "selected" : "" %>>여</option>
                </select>
            </div>

            <!-- 통신사 -->
            <div class="col-md-4">
                <label class="form-label">통신사</label>
                <select name="phone1" class="form-select">
                    <option value="1"
                      <%= dto.getPhone1()==1 ? "selected" : "" %>>SKT</option>
                    <option value="2"
                      <%= dto.getPhone1()==2 ? "selected" : "" %>>KT</option>
                    <option value="3"
                      <%= dto.getPhone1()==3 ? "selected" : "" %>>LGU+</option>
                </select>
            </div>

            <!-- 전화번호 -->
            <div class="col-md-4">
                <label class="form-label">전화번호</label>
                <input type="text" name="phone2" class="form-control"
                       value="<%= dto.getPhone2() %>" required />
            </div>

            <!-- 회사 -->
            <div class="col-md-4">
                <label class="form-label">회사</label>
                <input type="text" name="company" class="form-control"
                    		value="<%=dto.getCompany()%>" required/>
                    
                </select>
            </div>

            <!-- 주소 찾기 -->
            <div class="col-md-4">
                <label class="form-label">우편번호</label>
                <div class="input-group">
                    <input type="text" id="zip" name="zip" class="form-control"
                           value="<%= dto.getZip() %>" readonly />
                    <button type="button" class="btn btn-outline-secondary"
                            onclick="execDaumPostcode()">
                        찾기
                    </button>
                </div>
            </div>

            <!-- 주소1 -->
            <div class="col-md-4">
                <label class="form-label">주소1</label>
                <input type="text" id="addr1" name="addr1" class="form-control"
                       value="<%= dto.getAddr1() %>" readonly />
            </div>

            <!-- 주소2 -->
            <div class="col-12">
                <label class="form-label">주소2</label>
                <input type="text" id="addr2" name="addr2" class="form-control"
                       value="<%= dto.getAddr2() != null ? dto.getAddr2() : "" %>" />
            </div>

            <!-- 버튼 -->
            <div class="col-12 d-flex gap-2">
                <button type="submit" class="btn btn-primary">수정하기</button>
                <a href="info.jsp" class="btn btn-secondary">취소</a>
            </div>
        </form>
    </div>

    <!-- Daum Postcode API -->
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
    <script>
      function execDaumPostcode() {
        new daum.Postcode({
          oncomplete: function(data) {
            // 우편번호, 주소1 자동 채움
            document.getElementById('zip').value   = data.zonecode;
            document.getElementById('addr1').value = data.address;
            document.getElementById('addr2').focus();
          }
        }).open();
      }
    </script>
    <%@ include file="/views/layout/footer_new.jsp" %>
    </div>
</body>
</html>
