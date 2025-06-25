<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%  
    request.setCharacterEncoding("UTF-8");
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>회원가입 - M4 뉴스</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <!-- Bootstrap & 커스텀 CSS -->
  <link
    href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
    rel="stylesheet">
  <link rel="stylesheet" href="<%=ctx%>/resources/theme.css">
  <link rel="stylesheet" href="<%=ctx%>/resources/all.css">
  <!-- 다음 우편번호 API -->
  <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
  <!-- ID 중복/유효성 검사 -->
  <script>
    function execDaumPostcode() {
      new daum.Postcode({
        oncomplete: function(data) {
          document.getElementById('zip').value   = data.zonecode;
          document.getElementById('addr1').value = data.address;
          document.getElementById('addr2').focus();
        }
      }).open();
    }
    function checkId() {
      var id = document.getElementById('id').value.trim();
      if (!id) { alert('아이디를 입력해주세요.'); return; }
      window.open(
        '<%=ctx%>/member/checkId.jsp?id=' + encodeURIComponent(id),
        'chk','width=400,height=200,scrollbars=no'
      );
    }
    function validate() {
      var pw  = document.getElementById('pw').value;
      var pw2 = document.getElementById('pw2').value;
      if (pw.length < 4) {
        alert('비밀번호를 4자 이상 입력하세요.'); return false;
      }
      if (pw !== pw2) {
        alert('비밀번호가 일치하지 않습니다.'); return false;
      }
      return true;
    }
  </script>
</head>
<body class="d-flex flex-column min-vh-100">

  <!-- 헤더 -->
  <jsp:include page="/views/layout/header.jsp" />

  <!-- 메인 -->
  <main class="flex-grow-1 d-flex justify-content-center align-items-center bg-light">
    <div class="card shadow-sm" style="max-width: 600px; width:100%;">
      <div class="card-body p-4">
        <h3 class="card-title text-center mb-4" style="color: var(--primary-color);">
          회원가입
        </h3>
        <form name="joinForm"
              action="<%=ctx%>/member/inputPro.jsp"
              method="post"
              onsubmit="return validate();">
          <input type="hidden" name="job"     value="1">
          <input type="hidden" name="company" value="null">

          <!-- 아이디 -->
          <div class="row mb-3">
            <label for="id" class="col-sm-3 col-form-label text-end">아이디</label>
            <div class="col-sm-9 d-flex">
              <input type="text" id="id" name="id"
                     class="form-control"
                     maxlength="100" required>
              <button type="button" class="btn btn-outline-secondary ms-2"
              		  style="min-width:120px;"
                      onclick="checkId()">중복확인</button>
            </div>
          </div>
          <!-- 비밀번호 -->
          <div class="row mb-3">
            <label for="pw" class="col-sm-3 col-form-label text-end">비밀번호</label>
            <div class="col-sm-9">
              <input type="password" id="pw" name="pw"
                     class="form-control"
                     maxlength="100" required>
            </div>
          </div>
          <!-- 비밀번호 확인 -->
          <div class="row mb-3">
            <label for="pw2" class="col-sm-3 col-form-label text-end">비밀번호 확인</label>
            <div class="col-sm-9">
              <input type="password" id="pw2" name="pw2"
                     class="form-control"
                     maxlength="100" required>
            </div>
          </div>
          <!-- 이름 -->
          <div class="row mb-3">
            <label for="name" class="col-sm-3 col-form-label text-end">이름</label>
            <div class="col-sm-9">
              <input type="text" id="name" name="name"
                     class="form-control"
                     maxlength="100" required>
            </div>
          </div>
          <!-- 생년월일 -->
          <div class="row mb-3">
            <label for="birth" class="col-sm-3 col-form-label text-end">생년월일</label>
            <div class="col-sm-9">
              <input type="date" id="birth" name="birth"
                     class="form-control">
            </div>
          </div>
          <!-- 성별 -->
          <div class="row mb-3">
            <label class="col-sm-3 col-form-label text-end">성별</label>
            <div class="col-sm-9 d-flex align-items-center">
              <div class="form-check me-3">
                <input class="form-check-input" type="radio"
                       name="gender" id="gender1" value="1" checked>
                <label class="form-check-label" for="gender1">남자</label>
              </div>
              <div class="form-check">
                <input class="form-check-input" type="radio"
                       name="gender" id="gender2" value="2">
                <label class="form-check-label" for="gender2">여자</label>
              </div>
            </div>
          </div>
          <!-- 전화번호 -->
          <div class="row mb-3">
            <label for="phone2" class="col-sm-3 col-form-label text-end">전화번호</label>
            <div class="col-sm-9 d-flex">
              <select name="phone1" class="form-select" style="max-width:120px;">
                <option value="1">SKT</option>
                <option value="2">KT</option>
                <option value="3">LGU+</option>
              </select>
              <input type="text" name="phone2"
                     class="form-control ms-2"
                     style="max-width:200px;" required>
            </div>
          </div>
          <!-- 우편번호 -->
          <div class="row mb-3">
            <label for="zip" class="col-sm-3 col-form-label text-end">우편번호</label>
            <div class="col-sm-9 d-flex">
              <input type="text" id="zip" name="zip"
                     class="form-control" readonly>
              <button type="button"
                      class="btn btn-outline-secondary ms-2"
                      style="min-width:80px;"
                      onclick="execDaumPostcode()">찾기</button>
            </div>
          </div>
          <!-- 주소 -->
          <div class="row mb-3">
            <label for="addr1" class="col-sm-3 col-form-label text-end">주소</label>
            <div class="col-sm-9">
              <input type="text" id="addr1" name="addr1"
                     class="form-control" readonly>
            </div>
          </div>
          <!-- 상세주소 -->
          <div class="row mb-4">
            <label for="addr2" class="col-sm-3 col-form-label text-end">상세주소</label>
            <div class="col-sm-9">
              <input type="text" id="addr2" name="addr2"
                     class="form-control">
            </div>
          </div>
          <!-- 버튼 -->
          <div class="d-grid gap-2">
            <button type="submit" class="btn btn-primary">가입하기</button>
            <button type="reset"  class="btn btn-secondary">취소</button>
            <button type="button" class="btn btn-outline-secondary"
                    onclick="history.back()">돌아가기</button>
          </div>
        </form>
      </div>
    </div>
  </main>

  <!-- 푸터 -->
  <jsp:include page="/views/layout/footer_new.jsp" />

  <script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
  </script>
</body>
</html>
