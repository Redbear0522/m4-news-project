<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!-- ✅ 사이트 하단 푸터 영역 -->
<footer class="site-footer">
  
  <!-- ▶ 푸터 기본 정보 영역 -->
  <div class="footer-info">
    <p>&copy; M4뉴스.</p>

    <!-- ▶ 푸터 내 링크 메뉴 -->
  <ul class="footer-links">
  <li><a href="<%= request.getContextPath() %>/company_intro.jsp">회사 소개</a></li>
  
  <li><a href="#" onclick="openModal('privacyModal'); return false;">개인정보처리방침</a></li>

  <li><a href="#" onclick="openModal('termsModal'); return false;">이용약관</a></li>
  
  <li><a href="<%= request.getContextPath() %>/news/qna/qnaWrite.jsp">문의하기</a></li>
</ul>
  </div>

  <!-- ▶ 회사 주소 및 연락처 정보 -->
  <address class="footer-address">
    서울특별시 관악구 남부순환로 , 에그옐로우<br>
    대표전화: 02-***-**** | 이메일: M4@naver.com
  </address>
</footer>

<!-- ✅ header.jsp에서 열었던 page-container 닫는 태그 -->
</div>
<div id="termsModal" class="modal">
  <div class="modal-content">
    <span class="close-button">&times;</span>
    <main class="container my-5">
    <h1 class="mb-4">이용약관</h1>

    <section>
        <h2>제1장 총칙</h2>
        <h3>제1조 (목적)</h3>
        <p>이 약관은 M4미디어(이하 “회사”)가 제공하는 인터넷 관련 제반 서비스(이하 “서비스”)를 이용함에 있어 회사와 이용자의 권리·의무 및 책임 사항 등을 규정함을 목적으로 합니다.<br>
        “M4미디어”라 함은 M4일보, M4비즈, 헬스M4, M4뉴스프레스, M4교육문화미디어, ITM4, 에듀M4, 엠딕을 포함합니다.</p>

        <h3>제2조 (약관의 명시·효력 및 개정)</h3>
        <ol>
            <li>약관 내용은 서비스 화면에 게시하여 회원이 쉽게 확인할 수 있도록 합니다.</li>
            <li>회사는 관련 법령을 위배하지 않는 범위에서 언제든지 약관을 변경할 수 있으며, 적용 일자 및 변경 사유를 명시하여 게시합니다. 불리한 변경의 경우 30일 이전 공지 및 개별 통지합니다.</li>
            <li>변경된 약관에 동의하지 않을 경우 서비스 이용 중단 및 계약 해지가 가능합니다.</li>
        </ol>

        <h3>제3조 (약관 이외의 준칙)</h3>
        <ol>
            <li>약관에 명시되지 않은 사항은 개인정보보호법 등 관련 법령 및 상관례에 따릅니다.</li>
            <li>본 약관은 회사가 제공하는 개별 서비스 안내와 함께 적용됩니다.</li>
        </ol>
    </section>

    <section class="mt-5">
        <h2>제2장 서비스 이용 계약</h2>
        <h3>제4조 (이용계약의 성립)</h3>
        <ol>
            <li>회원이 약관 동의 후 회원가입 신청을 하고, 회사가 이를 승낙함으로써 성립됩니다.</li>
            <li>필요시 회사는 추가 서류 제출 또는 실명확인 절차를 요청할 수 있습니다.</li>
            <li>회사 정책에 따라 등급별 이용 제한을 둘 수 있습니다.</li>
        </ol>

        <h3>제5조 (이용신청의 승낙·유보·거절)</h3>
        <ol>
            <li>회사는 원칙적으로 이용 신청을 승낙하나, 설비 여유 부족·기술적 장애 등 사유 시 보류할 수 있습니다.</li>
            <li>다른 사람 명의 도용, 허위 기재, 미성년자 무단 가입 등 사유가 있을 경우 승낙하지 않을 수 있습니다.</li>
        </ol>

        <h3>제6조 (회원정보의 변경)</h3>
        <ol>
            <li>회원은 개인정보 관리 화면에서 언제든지 정보 조회·수정이 가능합니다. 단, 실명·아이디 등은 수정할 수 없습니다.</li>
            <li>변경사항 미통지로 인한 불이익은 회원 책임입니다.</li>
        </ol>

        <h3>제7조 (개인정보보호 의무)</h3>
        <p>회사는 관계 법령에 따라 회원 개인정보 보호를 위해 노력하며, 개인정보처리방침을 적용합니다.</p>

        <h3>제8조 (아이디 및 비밀번호 관리)</h3>
        <ol>
            <li>아이디·비밀번호 관리 책임은 회원에게 있으며, 부정 사용 시 모든 책임은 회원에게 있습니다.</li>
            <li>도용 또는 제3자 사용 인지 시 즉시 회사에 통보해야 합니다.</li>
        </ol>

        <h3>제9조 (회원에 대한 통지)</h3>
        <ol>
            <li>회원 통지는 이메일 등 전자적 수단으로 할 수 있습니다.</li>
            <li>전체 회원 통지는 7일 이상 게시판 게재로 갈음할 수 있습니다.</li>
        </ol>
    </section>

    <!-- 추가 장·조항은 같은 형식으로 작성 -->

    <section class="mt-5">
        <h2>제3장 계약 당사자의 의무</h2>
        <!-- 회사 및 회원 의무 조항 -->
    </section>

    <section class="mt-5">
        <h2>제4장 서비스 제공 및 이용</h2>
        <!-- 관련 조항 -->
    </section>

    <section class="mt-5">
        <h2>제5장 기타</h2>
        <h3>제22조 (양도 금지)</h3>
        <p>회원은 이용 권한 및 계약상 지위를 타인에게 양도 또는 담보 제공할 수 없습니다.</p>

        <h3>제23조 (청소년 보호)</h3>
        <p>회사는 청소년 보호를 위해 별도 정책을 시행하며 초기 화면에서 확인 가능합니다.</p>

        <h3>제24조 (면책 조항)</h3>
        <ol>
            <li>불가항력 사유 발생 시 책임을 지지 않습니다.</li>
            <li>회원 귀책사유로 인한 장애는 책임지지 않습니다.</li>
        </ol>

        <h3>제25조 (분쟁 해결 및 관할 법원)</h3>
        <ol>
            <li>분쟁 발생 시 원만 해결을 위해 노력합니다.</li>
            <li>소송 제기 시 회사 소재지 관할 법원을 관할 법원으로 합니다.</li>
            <li>대한민국법을 준거법으로 합니다.</li>
        </ol>
    </section>

    <section class="mt-5">
        <h2>부칙</h2>
        <p>이 약관은 2023년 09월 08일부터 시행합니다.</p>
    </section>
</main>
  </div>
</div>



<div id="privacyModal" class="modal">
  <div class="modal-content">
    <span class="close-button">&times;</span>
<main class="container my-5">
    <h1 class="mb-4">개인정보처리방침</h1>
    <p>㈜M4일보사(이하 ‘회사’)는 『개인정보보호법』 등 관련 법령을 준수하며, 이용자의 개인정보 보호에 최선을 다하고 있습니다.</p>

    <section class="mt-5">
        <h2>1. 개인정보의 수집 항목 및 이용 목적</h2>
        <p>회사는 회원가입, 서비스 제공, 고객 상담 등 아래의 목적을 위해 개인정보를 처리하며, 목적 외 이용 시 사전 동의를 받습니다.</p>
        <div class="table-responsive">
            <table class="table table-bordered align-middle">
                <thead class="table-light">
                    <tr>
                        <th>구분</th>
                        <th>항목</th>
                        <th>이용 목적</th>
                        <th>보유 기간</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>통합 회원</td>
                        <td>아이디, 비밀번호, 이름(닉네임)</td>
                        <td>회원 식별, 서비스 제공, 고객 상담</td>
                        <td>회원 탈퇴 시</td>
                    </tr>
                    <tr>
                        <td>본인 인증 (선택)</td>
                        <td>이름, 휴대폰번호, 생년월일, 성별, DI</td>
                        <td>법적 준수를 위한 인증</td>
                        <td>회원 탈퇴 또는 철회 시</td>
                    </tr>
                    <!-- 이하 필요한 행 추가 -->
                </tbody>
            </table>
        </div>
    </section>

    <section class="mt-5">
        <h2>2. 개인정보 보유기간 및 파기</h2>
        <ul>
            <li>회원 탈퇴, 서비스 종료, 보유 기간 만료 시 지체 없이 파기</li>
            <li>전자적 파일: 복구 불가능한 기술적 방법으로 영구 삭제</li>
        </ul>
        <p>법령에 따른 보존 항목:</p>
        <ul>
            <li>전자상거래 기록: 5년</li>
            <li>소비자 불만·분쟁 기록: 3년</li>
            <li>기타: 관련 법령에서 정한 기간</li>
        </ul>
    </section>

    <section class="mt-5">
        <h2>3. 개인정보 제3자 제공</h2>
        <p>이용자 동의 없이 개인정보를 외부에 제공하지 않으며, 다음의 예외에 해당할 경우에만 제공합니다.</p>
        <ul>
            <li>법령에 특별 규정이 있는 경우</li>
            <li>정보주체 또는 법정대리인이 동의한 경우</li>
            <li>긴급 상황으로 생명·재산 보호가 필요한 경우</li>
        </ul>
    </section>

    <section class="mt-5">
        <h2>4. 개인정보 처리 위탁</h2>
        <p>서비스 제공을 위해 일부 업무를 외부 업체에 위탁하며, 안전하게 처리되도록 관리·감독합니다.</p>
        <ul>
            <li>전자결제: ㈜케이지이니시스, Amazon Web Services 등</li>
            <li>본인확인: SCI평가정보(주)</li>
            <!-- 추가 위탁처 기재 -->
        </ul>
    </section>

    <section class="mt-5">
        <h2>5. 이용자 권리 · 의무 및 행사 방법</h2>
        <p>이용자는 언제든지 자신의 개인정보 조회, 수정, 삭제, 처리 정지를 요청할 수 있습니다.</p>
        <p>‘회원 정보’ 페이지 또는 개인정보 보호책임자에게 서면·전화·이메일로 요청 가능합니다.</p>
    </section>

    <section class="mt-5">
        <h2>6. 개인정보 보호책임자</h2>
        <p>회사는 개인정보 보호를 위해 아래 책임자 및 담당부서를 지정하고 있습니다.</p>
        <ul>
            <li>책임자: 정보보호실 실장 (privacy@M4.com)</li>
            <li>담당부서: IT팀 (privacy_1@M4.com)</li>
            <li>문의: 1588-****, 1577-****</li>
        </ul>
    </section>

    <section class="mt-5">
        <h2>7. 고지 의무</h2>
        <p>본 방침은 2025년 06월 05일부터 시행합니다. 개정 시 공지사항을 통해 사전 안내합니다.</p>
    </section>
</main>
  </div>
</div>
<script>
// --- 모달 제어 스크립트 ---

// 모달을 여는 함수
function openModal(modalId) {
  var modal = document.getElementById(modalId);
  if (modal) {
    modal.style.display = "block";
  }
}

// 닫기(X) 버튼을 누르면 모달을 닫는 기능
// 모든 닫기 버튼에 이벤트 리스너 추가
var closeButtons = document.getElementsByClassName("close-button");
for (var i = 0; i < closeButtons.length; i++) {
  closeButtons[i].onclick = function() {
    this.parentElement.parentElement.style.display = "none";
  }
}

// 모달의 배경(회색 영역)을 클릭하면 모달이 닫히는 기능
window.onclick = function(event) {
  // event.target은 사용자가 클릭한 요소를 의미
  if (event.target.classList.contains('modal')) {
    event.target.style.display = "none";
  }
}
</script>

</body>
</html>
