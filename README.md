# M4 뉴스 프로젝트

![Java](https://img.shields.io/badge/Java-21-orange)
![JSP](https://img.shields.io/badge/JSP-3.0-blue)
![Oracle](https://img.shields.io/badge/Database-Oracle-red)
![Maven](https://img.shields.io/badge/Build-Maven-blue)

## 📖 프로젝트 소개

M4 뉴스는 Java JSP/Servlet 기반의 뉴스 포털 웹사이트입니다. 사용자들이 다양한 카테고리의 뉴스를 읽고, 댓글을 달고, 감정을 표현할 수 있는 기능을 제공합니다.

## ✨ 주요 기능

### 👥 회원 관리
- 회원가입 및 로그인
- 프로필 관리 (이미지 업로드)
- 비밀번호 변경
- ID/PW 찾기
- 관리자 승인 시스템

### 📰 뉴스 시스템
- 카테고리별 뉴스 (정치, 경제, 사회, 연예, 스포츠)
- 기사 작성/수정/삭제
- 이미지 첨부 기능
- 조회수 추적
- 추천/비추천 시스템

### 💬 소셜 기능
- 댓글 시스템
- 감정 표현 (좋아요, 공감, 비공감)
- Q&A 게시판
- 인기글/추천글 표시

### 👨‍💼 관리자 기능
- 회원 승인/거부
- 게시글 블라인드 처리
- 사용자 차단/해제
- 전체 회원 관리

## 🛠 기술 스택

- **Backend**: Java 21, JSP, Servlet
- **Database**: Oracle Database
- **Build Tool**: Maven
- **Frontend**: HTML, CSS, JavaScript
- **Server**: Jakarta EE

## 📁 프로젝트 구조

```
m4-news-project/
├── src/main/
│   ├── java/
│   │   ├── article/          # 기사 관련 DTO, DAO
│   │   ├── comment/          # 댓글 관련 DTO, DAO  
│   │   ├── emotion/          # 감정 표현 DTO, DAO
│   │   └── member/           # 회원 관리 DTO, DAO
│   └── webapp/
│       ├── article/          # 기사 관련 JSP
│       ├── comment/          # 댓글 관련 JSP
│       ├── emotion/          # 감정 표현 JSP
│       ├── member/           # 회원 관리 JSP
│       ├── news/             # 뉴스 카테고리별 JSP
│       ├── views/            # 레이아웃 JSP
│       └── WEB-INF/
├── pom.xml                   # Maven 설정
└── render.yaml              # 배포 설정
```

## 🗄️ 데이터베이스 구조

### 주요 테이블
- **MEMBER**: 회원 정보
- **ARTICLE**: 기사/게시글
- **COMMENTS**: 댓글
- **ARTICLE_FILES**: 첨부 파일
- **ARTICLE_EMOTION**: 기사에 대한 감정 표현

## 🚀 실행 방법

### 사전 요구사항
- Java 21 이상
- Maven 3.6 이상
- Oracle Database
- Apache Tomcat 10

### 실행 단계

1. **프로젝트 클론**
   ```bash
   git clone https://github.com/Redbear0522/m4-news-project.git
   cd m4-news-project
   ```

2. **데이터베이스 설정**
   - Oracle Database 설치 및 실행
   - 필요한 테이블 생성 (DDL 스크립트 별도 제공)
   - `src/main/java/*/DAO.java` 파일에서 DB 연결 정보 수정

3. **프로젝트 빌드**
   ```bash
   mvn clean install
   ```

4. **서버 실행**
   - 생성된 WAR 파일을 Tomcat에 배포
   - 또는 IDE에서 직접 실행

5. **접속**
   ```
   http://localhost:8080/m4-news/
   ```

## ⚠️ 주요 개선점

### 🔒 보안 강화 필요
- [ ] 데이터베이스 연결 정보 환경변수화
- [ ] SQL Injection 방지 강화
- [ ] 비밀번호 암호화 (BCrypt 등)
- [ ] 세션 보안 강화

### 🏗️ 아키텍처 개선
- [ ] Connection Pool 도입 (HikariCP)
- [ ] Service Layer 분리
- [ ] Exception Handler 구현
- [ ] 로깅 시스템 도입 (Logback)

### 🔄 현대화
- [ ] Spring Boot 마이그레이션 고려
- [ ] REST API 구조로 변경
- [ ] PostgreSQL 지원 추가
- [ ] Docker 컨테이너화

### 📊 성능 최적화
- [ ] 페이징 성능 개선
- [ ] 인덱스 최적화
- [ ] 캐싱 도입 (Redis)
- [ ] 이미지 최적화

### 🧪 테스트
- [ ] Unit Test 추가
- [ ] Integration Test
- [ ] E2E Test

## 👨‍💻 기여 방법

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 라이선스

이 프로젝트는 MIT 라이선스를 따릅니다. 자세한 내용은 `LICENSE` 파일을 참조하세요.

## 📧 연락처

프로젝트 관련 문의사항이 있으시면 Issues 탭을 이용해 주세요.

---

⭐ 이 프로젝트가 유용하다면 Star를 눌러주세요!
