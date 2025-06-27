package article;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ArticleDAO {
    private Connection conn;
    private PreparedStatement pstmt;
    private ResultSet rs;

    private Connection getConnection() throws ClassNotFoundException, SQLException {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        //return DriverManager.getConnection("jdbc:oracle:thin:@192.168.219.198:1521:orcl", "team01", "1234");
        return DriverManager.getConnection("jdbc:oracle:thin:@58.73.200.225:1521:orcl", "team01", "1234");
    }

    private void disconnect() {
        try { if (rs != null) rs.close(); } catch (Exception e) { e.printStackTrace(); }
        try { if (pstmt != null) pstmt.close(); } catch (Exception e) { e.printStackTrace(); }
        try { if (conn != null) conn.close(); } catch (Exception e) { e.printStackTrace(); }
    }

    // [기존] 전체 글 개수 (수정 없음)
    public int getArticleCount() {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM ARTICLE";
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            if (rs.next()) count = rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            disconnect();
        }
        return count;
    }

    // [기존] 페이징된 글 목록 (수정 없음)
    public List<ArticleDTO> getArticleList(int start, int end) {
        List<ArticleDTO> list = new ArrayList<>();
        String sql =
          "SELECT * FROM (" +
          "  SELECT ROWNUM rn, A.* FROM (" +
          "    SELECT num, subject, content, writer, write_date, readcount, categori " +  // ◀ content 추가
          "    FROM ARTICLE " +
          "    ORDER BY num DESC" +
          "  ) A WHERE ROWNUM <= ?" +
          ") WHERE rn >= ?";
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, end);
            pstmt.setInt(2, start);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                ArticleDTO dto = new ArticleDTO();
                dto.setNum        (rs.getInt("num"));
                dto.setSubject    (rs.getString("subject"));
                dto.setContent    (rs.getString("content"));      // ◀ content 매핑
                dto.setWriter     (rs.getString("writer"));
                dto.setWrite_date (rs.getTimestamp("write_date"));
                dto.setReadcount  (rs.getInt("readcount"));
                dto.setCategori   (rs.getInt("categori"));
                list.add(dto);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            disconnect();
        }
        return list;
    }


    // [수정] 내가 쓴 글 목록 조회 (writer id로 조회)
    public List<ArticleDTO> getArticleList(String writerId) {
        List<ArticleDTO> list = new ArrayList<>();
        // ✅ SQL 쿼리를 writer 기준으로 변경
        String sql = "SELECT * FROM ARTICLE WHERE writer = ? ORDER BY num DESC";
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            // ✅ 파라미터를 writerId로 설정
            pstmt.setString(1, writerId);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                ArticleDTO dto = new ArticleDTO();
                dto.setNum(rs.getInt("num"));
                dto.setWriter(rs.getString("writer"));
                dto.setSubject(rs.getString("subject"));
                dto.setWrite_date(rs.getTimestamp("write_date"));
                dto.setReadcount(rs.getInt("readcount"));
                list.add(dto);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            disconnect();
        }
        return list;
    }

 // ArticleDAO.java

    // 사용자님이 주신 조회수 증가 메서드 (이 코드는 그대로 사용)
    public int increaseReadcount(int num) throws ClassNotFoundException, SQLException {
        String sql = "UPDATE ARTICLE SET readcount = readcount + 1 WHERE num = ?";
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, num);
            return pstmt.executeUpdate();  // 변경: 몇 건이 업데이트 됐는지 반환
        }
    }

    // ✅ 조회수 증가 로직이 제거된, 순수 SELECT 기능만 하는 getArticle 메서드
    public ArticleDTO getArticle(int num) {
        ArticleDTO dto = null;
        // ✅ UPDATE 쿼리 없이 SELECT만 수행
        String sql = "SELECT * FROM ARTICLE WHERE num = ?";
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, num);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                dto = new ArticleDTO();
                dto.setNum(rs.getInt("num"));
                dto.setWriter(rs.getString("writer"));
                dto.setSubject(rs.getString("subject"));
                dto.setContent(rs.getString("content"));
                dto.setPasswd(rs.getString("passwd"));
                dto.setWrite_date(rs.getTimestamp("write_date"));
                dto.setUpdate_date(rs.getTimestamp("update_date"));
                dto.setReadcount(rs.getInt("readcount")); // ✅ DB에서 읽어온 값 그대로 설정
                dto.setLike_count(rs.getInt("like_count"));
                dto.setGood_count(rs.getInt("good_count"));
                dto.setSad_count(rs.getInt("sad_count"));
                dto.setAngry_count(rs.getInt("angry_count"));
                dto.setWow_count(rs.getInt("wow_count"));
                dto.setCategori(rs.getInt("categori"));
                dto.setEmphasized(rs.getBoolean("emphasized"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            disconnect();
        }
        return dto;
    }

    // [추가] 글 삽입 후, 생성된 글 번호(num)를 반환하는 메서드
    public int insertArticleAndGetNum(ArticleDTO dto) {
        int newArticleNum = 0;
        
        String insertSql = "INSERT INTO ARTICLE (num, writer, subject, content, passwd, write_date, categori, emphasized) "
                         + "VALUES (article_seq.nextval, ?, ?, ?, ?, SYSDATE, ?, ?)";
        
        // ✅ 방금 사용한 시퀀스 값을 가져오는 쿼리
        String selectSql = "SELECT article_seq.currval FROM dual";

        try {
            conn = getConnection();
            // ✅ 트랜잭션 시작: 여러 쿼리를 하나의 작업으로 묶음
            conn.setAutoCommit(false); 

            // 1. INSERT 실행
            pstmt = conn.prepareStatement(insertSql);
            pstmt.setString(1, dto.getWriter());
            pstmt.setString(2, dto.getSubject());
            pstmt.setString(3, dto.getContent());
            pstmt.setString(4, dto.getPasswd());
            pstmt.setInt(5, dto.getCategori());
            pstmt.setBoolean(6, dto.isEmphasized());
            
            int cnt = pstmt.executeUpdate();
            
            if (cnt > 0) {
                // INSERT 성공 시, 방금 생성된 시퀀스 번호(글 번호)를 조회
                pstmt.close(); // 이전 pstmt는 닫아줌
                pstmt = conn.prepareStatement(selectSql);
                rs = pstmt.executeQuery();
                
                if (rs.next()) {
                    newArticleNum = rs.getInt(1);
                    conn.commit(); // ✅ 모든 작업이 성공했으므로 최종 반영
                } else {
                    conn.rollback(); // currval 조회 실패 시 롤백
                }
            } else {
                conn.rollback(); // INSERT 실패 시 롤백
            }

        } catch (Exception e) {
            try {
                if (conn != null) conn.rollback(); // ✅ 예외 발생 시 모든 작업 취소
            } catch (SQLException se) {
                se.printStackTrace();
            }
            e.printStackTrace();
        } finally {
            try {
                if (conn != null) conn.setAutoCommit(true); // ✅ 커넥션 풀에 돌려주기 전 기본 상태로 복원
            } catch (SQLException e) {
                e.printStackTrace();
            }
            disconnect();
        }
        return newArticleNum;
    }

    // [추가] 파일 정보를 ARTICLE_FILES 테이블에 저장하는 메서드
    public void insertArticleFile(int articleNum, String fileName) {
        String sql = "INSERT INTO ARTICLE_FILES (FILE_NUM, ARTICLE_NUM, FILE_NAME) VALUES (article_files_seq.nextval, ?, ?)";
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, articleNum);
            pstmt.setString(2, fileName);
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            disconnect();
        }
    }

    // [기존] 글 수정 (수정 없음)
    public int updateArticle(ArticleDTO at) {
        int result = 0;
        String sql = "UPDATE ARTICLE SET subject = ?, content = ?, update_date = SYSDATE, categori = ?, emphasized = ? WHERE num = ? AND passwd = ?";
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, at.getSubject());
            pstmt.setString(2, at.getContent());
            pstmt.setInt(3, at.getCategori());
            pstmt.setBoolean(4, at.isEmphasized());
            pstmt.setInt(5, at.getNum());
            pstmt.setString(6, at.getPasswd());
            result = pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            disconnect();
        }
        return result;
    }

    // [수정] 글 삭제 (연관된 파일, 댓글, 감정표현까지 모두 삭제 - 트랜잭션 처리)
    public boolean deleteArticle(int num, String passwd) {
        boolean success = false;
        // ✅ 1. 비밀번호 확인
        String checkSql = "SELECT COUNT(*) FROM ARTICLE WHERE num = ? AND passwd = ?";
        // ✅ 2. 글 삭제 SQL (관련 데이터는 ON DELETE CASCADE로 자동 삭제됨을 가정)
        String deleteSql = "DELETE FROM ARTICLE WHERE num = ?"; 
        
        try {
            conn = getConnection();
            // 트랜잭션 시작
            conn.setAutoCommit(false); 

            // 1단계: 비밀번호 검증
            pstmt = conn.prepareStatement(checkSql);
            pstmt.setInt(1, num);
            pstmt.setString(2, passwd);
            rs = pstmt.executeQuery();
            
            int count = 0;
            if (rs.next()) {
                count = rs.getInt(1);
            }
            
            if (count == 1) { // 비밀번호 일치
                rs.close();
                pstmt.close();

                // 2단계: 게시글 삭제 (FK 제약조건에 ON DELETE CASCADE가 설정되어 있으면 관련 파일, 댓글이 자동 삭제됩니다.)
                pstmt = conn.prepareStatement(deleteSql);
                pstmt.setInt(1, num);
                int deleteCount = pstmt.executeUpdate();
                
                if (deleteCount == 1) {
                    conn.commit(); // 성공 시 커밋
                    success = true;
                } else {
                    conn.rollback(); // 실패 시 롤백
                }
            } else {
                 // 비밀번호 불일치, 롤백할 필요 없음
            }

        } catch (Exception e) {
            try {
                if (conn != null) conn.rollback(); // 예외 발생 시 롤백
            } catch (SQLException se) {
                se.printStackTrace();
            }
            e.printStackTrace();
        } finally {
            try {
                if (conn != null) conn.setAutoCommit(true); // 커넥션 풀에 반환하기 전 기본값으로 복원
            } catch (SQLException e) {
                e.printStackTrace();
            }
            disconnect();
        }
        return success;
    }

    // [수정] 글 번호(num)에 해당하는 이미지 목록 조회
    public List<ArticleFileDTO> getImgFileList(int articleNum) {
        List<ArticleFileDTO> list = new ArrayList<>();
        // ✅ ARTICLE_FILES 테이블에서 조회하도록 수정
        String sql = "SELECT FILE_NUM, FILE_NAME FROM ARTICLE_FILES WHERE ARTICLE_NUM = ?";
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, articleNum);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                // ✅ ArticleFileDTO에 담도록 수정
                ArticleFileDTO dto = new ArticleFileDTO();
                dto.setFile_num(rs.getInt("FILE_NUM"));
                dto.setFile_name(rs.getString("FILE_NAME"));
                dto.setArticle_num(articleNum);
                list.add(dto);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            disconnect();
        }
        return list;
    }
        // [추가] QnA 게시판 전체 글 개수 조회 (categori = 8)
        public int getQnaCount() {
            int count = 0;
            String sql = "SELECT COUNT(*) FROM ARTICLE WHERE categori = 8"; // ✅ categori = 8 조건 추가
            try {
                conn = getConnection();
                pstmt = conn.prepareStatement(sql);
                rs = pstmt.executeQuery();
                if (rs.next()) {
                    count = rs.getInt(1);
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                disconnect();
            }
            return count;
        }

        // [추가] 페이징된 QnA 게시판 글 목록 조회 (categori = 8)
        public List<ArticleDTO> getQnaList(int start, int end) {
            List<ArticleDTO> list = new ArrayList<>();
            String sql =
              "SELECT * FROM (" +
              "  SELECT ROWNUM rn, A.* FROM (" +
              "    SELECT * FROM ARTICLE WHERE categori = 8 ORDER BY num DESC" + // ✅ categori = 8 조건 추가
              "  ) A WHERE ROWNUM <= ?" +
              ") WHERE rn >= ?";
            try {
                conn = getConnection();
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, end);
                pstmt.setInt(2, start);
                rs = pstmt.executeQuery();
                while (rs.next()) {
                    ArticleDTO dto = new ArticleDTO();
                    dto.setNum(rs.getInt("num"));
                    dto.setWriter(rs.getString("writer"));
                    dto.setSubject(rs.getString("subject"));
                    dto.setWrite_date(rs.getTimestamp("write_date"));
                    dto.setReadcount(rs.getInt("readcount"));
                    list.add(dto);
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                disconnect();
            }
            return list;
        }
        // ✅ [추가] 추천수 높은 순으로 N개 게시물 조회 (like_count 기준)
        public List<ArticleDTO> getRecommendedTopN(int n) {
            List<ArticleDTO> list = new ArrayList<>();
            // ROWNUM을 사용하여 상위 N개의 결과만 가져옴
            String sql =    "SELECT * FROM (" +
            	      "  SELECT * FROM ARTICLE " +
            	      "  WHERE categori <> 6 " +
            	      "  ORDER BY agree_count DESC" +
            	      ") WHERE ROWNUM <= ?";
            try {
                conn = getConnection();
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, n);
                rs = pstmt.executeQuery();
                while (rs.next()) {
                    ArticleDTO dto = new ArticleDTO();
                    dto.setNum(rs.getInt("num"));
                    dto.setWriter(rs.getString("writer"));
                    dto.setSubject(rs.getString("subject"));
                    dto.setAgree_count(rs.getInt("agree_count"));
                    // 필요한 다른 필드들도 여기서 채울 수 있습니다.
                    list.add(dto);
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                disconnect();
            }
            return list;
        }

        // ✅ [추가] 편집장 Pick 게시물 N개 조회 (emphasized = true)
        public List<ArticleDTO> getEditorsPickTopN(int n) {
            List<ArticleDTO> list = new ArrayList<>();
            // emphasized 컬럼이 1 (true)인 게시물을 최신순으로 정렬
            String sql =   "SELECT * FROM (" +
            	      "  SELECT * FROM ARTICLE " +
            	      "  WHERE emphasized = 1 AND categori <> 6 " +
            	      "  ORDER BY write_date DESC" +
            	      ") WHERE ROWNUM <= ?";
            try {
                conn = getConnection();
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, n);
                rs = pstmt.executeQuery();
                while (rs.next()) {
                    ArticleDTO dto = new ArticleDTO();
                    dto.setNum(rs.getInt("num"));
                    dto.setSubject(rs.getString("subject"));
                    dto.setContent(rs.getString("content")); // 요약에 필요
                    // 필요한 다른 필드들도 여기서 채울 수 있습니다.
                    list.add(dto);
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                disconnect();
            }
            return list;
        }

        // ✅ [추가] 조회수 높은 순으로 N개 게시물 조회 (readcount 기준)
        public List<ArticleDTO> getMostViewedTopN(int n) {
            List<ArticleDTO> list = new ArrayList<>();
            String sql =   "SELECT * FROM (" +
            	      "  SELECT * FROM ARTICLE " +
            	      "  WHERE categori <> 6 " +
            	      "  ORDER BY readcount DESC" +
            	      ") WHERE ROWNUM <= ?";
            try {
                conn = getConnection();
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, n);
                rs = pstmt.executeQuery();
                while (rs.next()) {
                    ArticleDTO dto = new ArticleDTO();
                    dto.setNum(rs.getInt("num"));
                    dto.setSubject(rs.getString("subject"));
                    dto.setReadcount(rs.getInt("readcount"));
                    list.add(dto);
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                disconnect();
            }
            return list;
        }
        
        // ✅ [추가] 댓글 많은 순으로 N개 게시물 조회 (서브쿼리 사용)
        public List<ArticleDTO> getMostCommentedTopN(int n) {
            List<ArticleDTO> list = new ArrayList<>();
            // 스칼라 서브쿼리를 이용해 각 게시물의 댓글 수를 계산하고, 그 수로 정렬
            String sql =  "SELECT * FROM (" +
            	      "  SELECT a.*, (SELECT COUNT(*) FROM COMMENTS c WHERE c.article_id = a.num) as cmt_cnt " +
            	      "  FROM ARTICLE a " +
            	      "  WHERE a.categori <> 6 " +
            	      "  ORDER BY cmt_cnt DESC" +
            	      ") WHERE ROWNUM <= ?";
            try {
                conn = getConnection();
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, n);
                rs = pstmt.executeQuery();
                while (rs.next()) {
                    ArticleDTO dto = new ArticleDTO();
                    dto.setNum(rs.getInt("num"));
                    dto.setSubject(rs.getString("subject"));
                    dto.setCmtCnt(rs.getInt("cmt_cnt")); // DTO에 추가한 필드에 값 설정
                    list.add(dto);
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                disconnect();
            }
            return list;
        }
     // ✅ 특정 카테고리의 전체 글 개수 조회
        public int getArticleCount(int categori) {
            int count = 0;
            String sql = "SELECT COUNT(*) FROM ARTICLE WHERE categori = ?";
            try {
                conn = getConnection();
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, categori);
                rs = pstmt.executeQuery();
                if (rs.next()) count = rs.getInt(1);
            } catch (Exception e) { e.printStackTrace(); }
              finally { disconnect(); }
            return count;
        }

        // ✅ 페이징된 특정 카테고리의 글 목록 조회
        public List<ArticleDTO> getArticleList(int start, int end, int categori) {
            List<ArticleDTO> list = new ArrayList<>();
            String sql =
              "SELECT * FROM ("
            + "  SELECT ROWNUM rn, A.* FROM ("
            + "    SELECT num, subject, content,"
            + "           writer, write_date, readcount, categori"
            + "      FROM ARTICLE"
            + "     WHERE categori = ?"
            + "     ORDER BY num DESC"
            + "  ) A WHERE ROWNUM <= ?"
            + ") WHERE rn >= ?";
            try {
                conn = getConnection();
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, categori);
                pstmt.setInt(2, end);
                pstmt.setInt(3, start);
                rs = pstmt.executeQuery();
                while (rs.next()) {
                    ArticleDTO dto = new ArticleDTO();
                    dto.setNum(rs.getInt("num"));
                    dto.setSubject(rs.getString("subject"));
                    dto.setContent(rs.getString("content"));    // ← 여기를 반드시!
                    dto.setWriter(rs.getString("writer"));
                    dto.setWrite_date(rs.getTimestamp("write_date"));
                    dto.setReadcount(rs.getInt("readcount"));
                    dto.setCategori(rs.getInt("categori"));
                    list.add(dto);
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                disconnect();
            }
            return list;
        }
        //기사 블라인드 처리
        public void changeCategory(int num, int categori) throws SQLException {
            String sql = "UPDATE article SET categori = ? WHERE num = ?";
            try { 
            	conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setInt(1, categori);
                ps.setInt(2, num);
                ps.executeUpdate();
            }catch(Exception e) {
            	e.printStackTrace();
            }finally {
            	disconnect();
            }
            
        }
        public void updateLikesCount(int articleId, int change) {
            Connection conn = null;
            PreparedStatement pstmt = null;
            String sql = "UPDATE Article SET likes_count = likes_count + ? WHERE article_id = ?";
            try {
                conn = getConnection();
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, change); // +1 또는 -1
                pstmt.setInt(2, articleId);
                pstmt.executeUpdate();
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                disconnect();
            }
        }
        
        public int getSearchArticleCount(String searchType, String keyword) {
            int count = 0;
            // ⚠️ 주의: SQL Injection에 취약할 수 있습니다.
            String sql = "SELECT COUNT(*) FROM ARTICLE WHERE " + searchType + " LIKE ?";
            try {
                conn = getConnection();
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, "%" + keyword + "%");
                rs = pstmt.executeQuery();
                if (rs.next()) {
                    count = rs.getInt(1);
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                disconnect();
            }
            return count;
        }
        public List<ArticleDTO> getSearchArticleList(int start, int end, String searchType, String keyword) {
            List<ArticleDTO> list = new ArrayList<>();
            String sql =
                "SELECT * FROM (" +
                "  SELECT ROWNUM rn, A.* FROM (" +
                "    SELECT * FROM ARTICLE WHERE " + searchType + " LIKE ? ORDER BY num DESC" +
                "  ) A WHERE ROWNUM <= ?" +
                ") WHERE rn >= ?";
            try {
                conn = getConnection();
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, "%" + keyword + "%");
                pstmt.setInt(2, end);
                pstmt.setInt(3, start);
                rs = pstmt.executeQuery();
                while (rs.next()) {
                    ArticleDTO dto = new ArticleDTO();
                    dto.setNum(rs.getInt("num"));
                    dto.setWriter(rs.getString("writer"));
                    dto.setSubject(rs.getString("subject"));
                    dto.setWrite_date(rs.getTimestamp("write_date")); 
                    dto.setReadcount(rs.getInt("readcount"));
                    list.add(dto);
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                disconnect();
            }
            return list;
        }
        //  공감 수 가져오기
        public int getAgreeCount(int num) throws SQLException, ClassNotFoundException {
            int count = 0;
            String sql = "SELECT agree_count FROM article WHERE num = ?";
            try (Connection conn = getConnection();
                 PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setInt(1, num);
                try (ResultSet rs = pstmt.executeQuery()) {
                    if(rs.next()) {
                        count = rs.getInt("agree_count");
                    }
                }
            }
            return count;
        }
        // 비공감 수 가져오기
        public int getDisagreeCount(int num) throws SQLException, ClassNotFoundException {
            int count = 0;
            String sql = "SELECT disagree_count FROM article WHERE num = ?";
            try (Connection conn = getConnection();
                 PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setInt(1, num);
                try (ResultSet rs = pstmt.executeQuery()) {
                    if(rs.next()) {
                        count = rs.getInt("disagree_count");
                    }
                }
            }
            return count;
        }
        //  아이디당 공감 여부 체크
        public boolean hasAgreed(String userId, int articleNum) throws SQLException, ClassNotFoundException {
            String sql = "SELECT COUNT(*) FROM article_emotion WHERE user_id = ? AND article_num = ? AND emotion = 'agree'";
            try (Connection conn = getConnection();
                 PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setString(1, userId);
                pstmt.setInt(2, articleNum);
                try (ResultSet rs = pstmt.executeQuery()) {
                    if(rs.next()) {
                        return rs.getInt(1) > 0;
                    }
                }
            }
            return false;
        }
        
        // 아이디당 비공감 여부 체크
        public boolean hasDisagreed(String userId, int articleNum) throws SQLException, ClassNotFoundException {
            String sql = "SELECT COUNT(*) FROM article_emotion WHERE user_id = ? AND article_num = ? AND emotion = 'disagree'";
            try (Connection conn = getConnection();
                 PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setString(1, userId);
                pstmt.setInt(2, articleNum);
                try (ResultSet rs = pstmt.executeQuery()) {
                    if(rs.next()) {
                        return rs.getInt(1) > 0;
                    }
                }
            }
            return false;
        }
        // 5. 공감 증가 및 기록 저장 (중복 시 false 반환)
        public boolean increaseAgreeCount(String userId, int articleNum) throws SQLException, ClassNotFoundException {
            if(hasAgreed(userId, articleNum)) return false;

            Connection conn = null;
            PreparedStatement pstmt1 = null;
            PreparedStatement pstmt2 = null;
            try {
                conn = getConnection();
                conn.setAutoCommit(false);

                // article 테이블 agree_count 증가
                String sql1 = "UPDATE article SET agree_count = agree_count + 1 WHERE num = ?";
                pstmt1 = conn.prepareStatement(sql1);
                pstmt1.setInt(1, articleNum);
                int updateCount = pstmt1.executeUpdate();

                // article_emotion 테이블에 기록 추가
                String sql2 = "INSERT INTO article_emotion(user_id, article_num, emotion) VALUES (?, ?, 'agree')";
                pstmt2 = conn.prepareStatement(sql2);
                pstmt2.setString(1, userId);
                pstmt2.setInt(2, articleNum);
                pstmt2.executeUpdate();

                conn.commit();
                return updateCount > 0;
            } catch(Exception e) {
                if(conn != null) conn.rollback();
                e.printStackTrace();
                return false;
            } finally {
                if(pstmt1 != null) pstmt1.close();
                if(pstmt2 != null) pstmt2.close();
                if(conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            }
        }
        // 6. 비공감 증가 및 기록 저장 (중복 시 false 반환)
        public boolean increaseDisagreeCount(String userId, int articleNum) throws SQLException, ClassNotFoundException {
            if(hasDisagreed(userId, articleNum)) return false;

            Connection conn = null;
            PreparedStatement pstmt1 = null;
            PreparedStatement pstmt2 = null;
            try {
                conn = getConnection();
                conn.setAutoCommit(false);

                // article 테이블 disagree_count 증가
                String sql1 = "UPDATE article SET disagree_count = disagree_count + 1 WHERE num = ?";
                pstmt1 = conn.prepareStatement(sql1);
                pstmt1.setInt(1, articleNum);
                int updateCount = pstmt1.executeUpdate();

                // article_emotion 테이블에 기록 추가
                String sql2 = "INSERT INTO article_emotion(user_id, article_num, emotion) VALUES (?, ?, 'disagree')";
                pstmt2 = conn.prepareStatement(sql2);
                pstmt2.setString(1, userId);
                pstmt2.setInt(2, articleNum);
                pstmt2.executeUpdate();

                conn.commit();
                return updateCount > 0;
            } catch(Exception e) {
                if(conn != null) conn.rollback();
                e.printStackTrace();
                return false;
            } finally {
                if(pstmt1 != null) pstmt1.close();
                if(pstmt2 != null) pstmt2.close();
                if(conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            }
        }

        // ✅ 공감 수 증가 메서드
        public int increaseAgreeCount(int num) throws SQLException, ClassNotFoundException {
            int result = 0;
            String sql = "UPDATE article SET agree_count = agree_count + 1 WHERE num = ?";
            try {
                conn = getConnection();
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, num);
                result = pstmt.executeUpdate();
            } finally {
                if(pstmt != null) pstmt.close();
                if(conn != null) conn.close();
            }
            return result;
        }
    
        
       // 비공감 수 증가 메서드
        public int increaseDisagreeCount(int num) throws SQLException, ClassNotFoundException {
            int result = 0;
            String sql = "UPDATE article SET disagree_count = disagree_count + 1 WHERE num = ?";
            try {
                conn = getConnection();
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, num);
                result = pstmt.executeUpdate();
            } finally {
                if(pstmt != null) pstmt.close();
                if(conn != null) conn.close();
            }
            return result;
        }
        
     // 감정 여부 조회 (공감인지 비공감인지)
     // 이미 감정 남겼는지 체크 (공감/비공감 구분 없이)
        public String getEmotionType(String userId, int articleNum) throws SQLException, ClassNotFoundException {
            String sql = "SELECT EMOTION FROM ARTICLE_EMOTION WHERE USER_ID = ? AND ARTICLE_NUM = ?";
            try (Connection conn = getConnection();
                 PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setString(1, userId);
                pstmt.setInt(2, articleNum);
                try (ResultSet rs = pstmt.executeQuery()) {
                    if (rs.next()) {
                        return rs.getString("EMOTION"); // "agree" 또는 "disagree"
                    }
                }
            }
            return null;
        }

        
     // 감정 삽입 및 카운트 증가 (공감 or 비공감 중 선택)
        public boolean insertArticleEmotion(String id, int articleNum, String emotionType) throws SQLException, ClassNotFoundException {
            String checkSql = "SELECT EMOTION FROM ARTICLE_EMOTION WHERE USER_ID = ? AND ARTICLE_NUM = ?";
            String insertSql = "INSERT INTO ARTICLE_EMOTION (USER_ID, ARTICLE_NUM, EMOTION) VALUES (?, ?, ?)";
            String updateSql = emotionType.equals("agree")
                ? "UPDATE article SET agree_count = agree_count + 1 WHERE num = ?"
                : "UPDATE article SET disagree_count = disagree_count + 1 WHERE num = ?";

            try (Connection conn = getConnection()) {
                // 1. 중복 체크 (USER_ID + ARTICLE_NUM 중복 검사)
                try (PreparedStatement pstmt = conn.prepareStatement(checkSql)) {
                    pstmt.setString(1, id);
                    pstmt.setInt(2, articleNum);
                    try (ResultSet rs = pstmt.executeQuery()) {
                        if (rs.next()) {
                            // 이미 감정 남긴 경우 - 공감/비공감 구분 없이 중복 제한
                            return false;
                        }
                    }
                }

                // 2. 감정 등록
                try (PreparedStatement pstmt = conn.prepareStatement(insertSql)) {
                    pstmt.setString(1, id);
                    pstmt.setInt(2, articleNum);
                    pstmt.setString(3, emotionType);
                    pstmt.executeUpdate();
                }

                // 3. 카운트 증가
                try (PreparedStatement pstmt = conn.prepareStatement(updateSql)) {
                    pstmt.setInt(1, articleNum);
                    pstmt.executeUpdate();
                }
            }
            return true;
        }


        public boolean insertEmotion(String userId, int articleNum, String emotion) throws SQLException, ClassNotFoundException {
            String checkSql = "SELECT EMOTION FROM ARTICLE_EMOTION WHERE USER_ID = ? AND ARTICLE_NUM = ?";
            String insertSql = "INSERT INTO ARTICLE_EMOTION (USER_ID, ARTICLE_NUM, EMOTION) VALUES (?, ?, ?)";
            String updateSql = emotion.equals("agree")
                ? "UPDATE article SET agree_count = agree_count + 1 WHERE num = ?"
                : "UPDATE article SET disagree_count = disagree_count + 1 WHERE num = ?";

            try (Connection conn = getConnection()) {
                // 1. 중복 체크
                try (PreparedStatement pstmt = conn.prepareStatement(checkSql)) {
                    pstmt.setString(1, userId);
                    pstmt.setInt(2, articleNum);
                    try (ResultSet rs = pstmt.executeQuery()) {
                        if (rs.next()) {
                            return false; // 이미 공감/비공감 했음
                        }
                    }
                }

                // 2. 등록
                try (PreparedStatement pstmt = conn.prepareStatement(insertSql)) {
                    pstmt.setString(1, userId);
                    pstmt.setInt(2, articleNum);
                    pstmt.setString(3, emotion);
                    pstmt.executeUpdate();
                }

                // 3. 카운트 증가
                try (PreparedStatement pstmt = conn.prepareStatement(updateSql)) {
                    pstmt.setInt(1, articleNum);
                    pstmt.executeUpdate();
                }
            }
            return true;
        }


}