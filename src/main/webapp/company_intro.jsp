<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>회사 소개 - M4뉴스</title>

    <!-- Bootstrap (기존) -->
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
      rel="stylesheet"
    >

    <!-- 메인 테마 CSS -->
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/resources/css/main.css"
    >
</head>
<body>

    <%-- 사이트 헤더 (site-header) --%>
    <jsp:include page="/views/layout/header.jsp" />


    <%-- 메인 콘텐츠 --%>
    <main class="container py-5">
        <header class="mb-5 text-center">
            <h1 class="display-4" style="color: var(--primary-color);">
                M4_team01
            </h1>
            <p class="lead">혁신과 가치를 창조하는 기업</p>
        </header>

        <section class="section mb-5">
            <h2>회사 소개</h2>
            <p>[M4_team01]은 2025년에 설립되어 IT 개발 분야에서 선도적인 역할을 수행하고 있습니다. 우리는 고객에게 제공하는 가치와 핵심 서비스를 통해 시장을 이끌어가고 있습니다.</p>
            <p>우리의 목표는 회사의 장기적인 비전을 달성하여 사회에 긍정적인 영향을 미치는 것입니다.</p>
        </section>

        <section class="section mb-5">
            <h2>우리의 미션</h2>
            <p>우리의 미션은 “세계화”입니다. 이를 통해 글로벌 시장에서 기술 혁신을 선도합니다.</p>
        </section>

        <section class="section mb-5">
            <h2>우리의 비전</h2>
            <p>우리의 비전은 “지구 장악”입니다. 첨단 기술을 바탕으로 미래를 선도합니다.</p>
        </section>

        <section class="section mb-5">
            <h2>핵심 가치</h2>
            <ul>
                <li><strong>혁신:</strong> 끊임없는 도전과 창의적 사고로 새로운 가치를 창출합니다.</li>
                <li><strong>고객 중심:</strong> 고객의 성공을 최우선으로 생각하며 최상의 솔루션을 제공합니다.</li>
                <li><strong>신뢰:</strong> 투명하고 정직한 경영으로 신뢰를 쌓아갑니다.</li>
                <li><strong>성장:</strong> 임직원의 역량 강화를 통해 지속적인 발전을 추구합니다.</li>
            </ul>
        </section>
    </main>

    <%-- 사이트 푸터 (site-footer) --%>
    <jsp:include page="/views/layout/footer_new.jsp" />

    <!-- Bootstrap JS (옵션) -->
    <script 
      src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
    </script>
</body>
</html>
