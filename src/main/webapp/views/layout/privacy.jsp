<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>개인정보처리방침 | M4 뉴스</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/resources/css/style.css">
</head>
<body>

<jsp:include page="/views/layout/header.jsp" />

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

<jsp:include page="/views/layout/footer_new.jsp" />

</body>
</html>
