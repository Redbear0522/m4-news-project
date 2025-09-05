package article;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/** 기사(게시글) 데이터베이스 접근 객체 */
public class ArticleDAO {
    private Connection conn;
    private PreparedStatement pstmt;
    private ResultSet rs;

    /** DB 연결 (Oracle JDBC 사용) */
    private Connection getConnection() throws ClassNotFoundException, SQLException {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        // DB 접속 정보 (URL, 사용자, 비밀번호)
        return DriverManager.getConnection("jdbc:oracle:thin:@58.73.200.225:1521:orcl", "team01", "1234");
    }

    /** 자원 해제 */
    private void disconnect() {
        try { if (rs != null) rs.close(); } catch (Exception e) { e.printStackTrace(); }
        try { if (pstmt != null) pstmt.close(); } catch (Exception e) { e.printStackTrace(); }
        try { if (conn != null) conn.close(); } catch (Exception e) { e.printStackTrace(); }
    }

    /** 전체 게시글 개수 조회 */
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

    /** 전체 게시글 목록 조회 (페이징) 
     * @param start 시작 행번호 (1부터 시작), @param end 끝 행번호 */
    public List<ArticleDTO> getArticleList(int start, int end) {
        List<ArticleDTO> list = new ArrayList<>();
        // 최신 글 순으로 주어진 범위만큼 조회 (ROWNUM을 이용한 페이징)
        String sql =
          "SELECT * FROM (" +
          "  SELECT ROWNUM rn, A.* FROM (" +
          "    SELECT num, subject, content, writer, write_date, readcount, categori " +
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
                // ResultSet에서 각 컬럼 값을 꺼내 DTO에 저장
                dto.setNum(rs.getInt("num"));
                dto.setSubject(rs.getString("subject"));
                dto.setContent(rs.getString("content"));      // 글 내용 일부 (리스트에서는 프리뷰로 사용 가능)
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

    /** 특정 회원이 작성한 게시글 목록 조회 */
    public List<ArticleDTO> getArticleList(String writerId) {
        List<ArticleDTO> list = new ArrayList<>();
        String sql = "SELECT * FROM ARTICLE WHERE writer = ? ORDER BY num DESC";
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
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

    /** 게시글 번호로 특정 게시글 조회 (조회수 증가 없이 조회만 수행) */
    public ArticleDTO getArticle(int num) {
        ArticleDTO dto = null;
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
                dto.setReadcount(rs.getInt("readcount")); // 조회수 (증가 전 조회된 현재 값)
                dto.setLike_count(rs.getInt("like_count"));
                dto.setGood_count(rs.getInt("good_count"));
                dto.setSad_count(rs.getInt("sad_count"));
                dto.setAngry_count(rs.getInt("angry_count"));
                dto.setWow_count(rs.getInt("wow_count"));
                dto.setCategori(rs.getInt("categori"));
                dto.setEmphasized(rs.getBoolean("emphasized"));
                dto.setAgree_count(rs.getInt("agree_count"));
                dto.setDisagree_count(rs.getInt("disagree_count"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            disconnect();
        }
        return dto;
    }

    /** 조회수 1 증가 처리 (게시글을 열람할 때 호출) */
    public int increaseReadcount(int num) throws ClassNotFoundException, SQLException {
        String sql = "UPDATE ARTICLE SET readcount = readcount + 1 WHERE num = ?";
        // try-with-resources 사용: Conn, pstmt 자동 close
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, num);
            return pstmt.executeUpdate();  // 업데이트된 행 수 반환 (1 이상이면 성공)
        }
    }

    /** 새로운 게시글 작성 (글을 등록하고, 생성된 글 번호를 반환) */
    public int insertArticleAndGetNum(ArticleDTO dto) {
        int newArticleNum = 0;
        // 1. ARTICLE 테이블에 새 글 INSERT (글 번호는 시퀀스 사용)
        String insertSql = "INSERT INTO ARTICLE (num, writer, subject, content, passwd, write_date, categori, emphasized) "
                         + "VALUES (article_seq.nextval, ?, ?, ?, ?, SYSDATE, ?, ?)";
        // 2. 방금 INSERT한 시퀀스 값(글 번호) 얻기
        String currvalSql = "SELECT article_seq.currval FROM dual";
        try {
            conn = getConnection();
            conn.setAutoCommit(false); // 트랜잭션 시작

            // INSERT 실행
            pstmt = conn.prepareStatement(insertSql);
            pstmt.setString(1, dto.getWriter());
            pstmt.setString(2, dto.getSubject());
            pstmt.setString(3, dto.getContent());
            pstmt.setString(4, dto.getPasswd());
            pstmt.setInt(5, dto.getCategori());
            pstmt.setBoolean(6, dto.isEmphasized());
            int insertCount = pstmt.executeUpdate();
            pstmt.close();

            if (insertCount > 0) {
                // INSERT 성공 시, 새로 발급된 글 번호 조회
                pstmt = conn.prepareStatement(currvalSql);
                rs = pstmt.executeQuery();
                if (rs.next()) {
                    newArticleNum = rs.getInt(1);
                }
                rs.close();
                pstmt.close();
                conn.commit(); // 모든 작업 성공 -> 커밋
            } else {
                conn.rollback(); // INSERT 실패 시 롤백
            }
        } catch (Exception e) {
            try { if (conn != null) conn.rollback(); } catch (SQLException se) { se.printStackTrace(); }
            e.printStackTrace();
        } finally {
            // 트랜잭션 종료: AutoCommit 원상복구 및 연결 해제
            try { if (conn != null) conn.setAutoCommit(true); } catch (SQLException e) { e.printStackTrace(); }
            disconnect();
        }
        return newArticleNum;
    }

    /** 첨부 이미지 파일 정보 저장 메서드 
     *  (새 글 작성 시 업로드된 이미지 파일들을 ARTICLE_FILES 테이블에 기록) */
    public void insertArticleFile(int articleNum, String fileName) {
        String sql = "INSERT INTO ARTICLE_FILES (FILE_NUM, ARTICLE_NUM, FILE_NAME) "
                   + "VALUES (article_files_seq.nextval, ?, ?)";
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

    /** 게시글 수정 (제목, 내용, 카테고리 등 변경. 비밀번호로 권한 체크) */
    public int updateArticle(ArticleDTO dto) {
        int result = 0;
        // 비밀번호가 일치하는 경우에만 업데이트
        String sql = "UPDATE ARTICLE SET subject = ?, content = ?, update_date = SYSDATE, "
                   + "categori = ?, emphasized = ? WHERE num = ? AND passwd = ?";
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, dto.getSubject());
            pstmt.setString(2, dto.getContent());
            pstmt.setInt(3, dto.getCategori());
            pstmt.setBoolean(4, dto.isEmphasized());
            pstmt.setInt(5, dto.getNum());
            pstmt.setString(6, dto.getPasswd());
            result = pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            disconnect();
        }
        return result;
    }

    /** 게시글 삭제 (글에 달린 첨부파일, 댓글 등도 함께 삭제됨 - ON DELETE CASCADE 가정) */
    public boolean deleteArticle(int num, String passwd) {
        boolean success = false;
        String checkSql = "SELECT COUNT(*) FROM ARTICLE WHERE num = ? AND passwd = ?";
        String deleteSql = "DELETE FROM ARTICLE WHERE num = ?";
        try {
            conn = getConnection();
            conn.setAutoCommit(false); // 트랜잭션 시작

            // 1단계: 비밀번호 검증
            pstmt = conn.prepareStatement(checkSql);
            pstmt.setInt(1, num);
            pstmt.setString(2, passwd);
            rs = pstmt.executeQuery();
            int matchCount = 0;
            if (rs.next()) {
                matchCount = rs.getInt(1);
            }
            rs.close();
            pstmt.close();
            if (matchCount == 1) {
                // 2단계: 게시글 삭제 실행
                pstmt = conn.prepareStatement(deleteSql);
                pstmt.setInt(1, num);
                int delCount = pstmt.executeUpdate();
                if (delCount == 1) {
                    conn.commit();   // 삭제 성공 시 commit
                    success = true;
                } else {
                    conn.rollback(); // 삭제된 행이 없으면 rollback
                }
            }
        } catch (Exception e) {
            try { if (conn != null) conn.rollback(); } catch (SQLException se) { se.printStackTrace(); }
            e.printStackTrace();
        } finally {
            try { if (conn != null) conn.setAutoCommit(true); } catch (SQLException e) { e.printStackTrace(); }
            disconnect();
        }
        return success;
    }

    /** 특정 글의 첨부 이미지 목록 조회 */
    public List<ArticleFileDTO> getImgFileList(int articleNum) {
        List<ArticleFileDTO> list = new ArrayList<>();
        String sql = "SELECT FILE_NUM, FILE_NAME FROM ARTICLE_FILES WHERE ARTICLE_NUM = ?";
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, articleNum);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                ArticleFileDTO fileDto = new ArticleFileDTO();
                fileDto.setFile_num(rs.getInt("FILE_NUM"));
                fileDto.setFile_name(rs.getString("FILE_NAME"));
                fileDto.setArticle_num(articleNum);
                list.add(fileDto);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            disconnect();
        }
        return list;
    }

    /** Q&A 게시판 (카테고리=8) 전체 글 개수 조회 */
    public int getQnaCount() {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM ARTICLE WHERE categori = 8";
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

    /** Q&A 게시판 글 목록 조회 (페이징) */
    public List<ArticleDTO> getQnaList(int start, int end) {
        List<ArticleDTO> list = new ArrayList<>();
        String sql =
          "SELECT * FROM (" +
          "  SELECT ROWNUM rn, A.* FROM (" +
          "    SELECT * FROM ARTICLE WHERE categori = 8 ORDER BY num DESC" +
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

    /** 추천 많은 상위 N개 게시물 조회 (공감수가 많은 순) */
    public List<ArticleDTO> getRecommendedTopN(int n) {
        List<ArticleDTO> list = new ArrayList<>();
        // categori <> 6: 블라인드된 글은 제외 (블라인드=6인 글은 노출 안 함)
        String sql = "SELECT * FROM (" +
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
                // 제목과 작성자, 공감수 등 간략 정보만 DTO에 채움 (추가 정보 필요 시 확대 가능)
                list.add(dto);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            disconnect();
        }
        return list;
    }

    /** 편집장 Pick 상위 N개 게시물 조회 (관리자가 강조한 기사) */
    public List<ArticleDTO> getEditorsPickTopN(int n) {
        List<ArticleDTO> list = new ArrayList<>();
        String sql = "SELECT * FROM (" +
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
                dto.setContent(rs.getString("content")); // 본문 내용 (요약 용도)
                // 필요한 경우 작성자, 날짜 등 추가 세팅 가능
                list.add(dto);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            disconnect();
        }
        return list;
    }

    /** 조회수 많은 상위 N개 게시물 조회 */
    public List<ArticleDTO> getMostViewedTopN(int n) {
        List<ArticleDTO> list = new ArrayList<>();
        String sql = "SELECT * FROM (" +
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

    /** 댓글 많은 상위 N개 게시물 조회 */
    public List<ArticleDTO> getMostCommentedTopN(int n) {
        List<ArticleDTO> list = new ArrayList<>();
        // 서브쿼리로 각 글의 댓글 수(cmt_cnt)를 구하여 그 수로 내림차순 정렬
        String sql = "SELECT * FROM (" +
                     "  SELECT a.*, (SELECT COUNT(*) FROM COMMENTS c WHERE c.article_id = a.num) AS cmt_cnt " +
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
                dto.setCmtCnt(rs.getInt("cmt_cnt")); // ArticleDTO에 댓글수 필드를 추가하여 저장
                list.add(dto);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            disconnect();
        }
        return list;
    }

    /** 특정 카테고리의 전체 글 개수 조회 */
    public int getArticleCount(int categori) {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM ARTICLE WHERE categori = ?";
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, categori);
            rs = pstmt.executeQuery();
            if (rs.next()) count = rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            disconnect();
        }
        return count;
    }

    /** 특정 카테고리의 글 목록 조회 (페이징) */
    public List<ArticleDTO> getArticleList(int start, int end, int categori) {
        List<ArticleDTO> list = new ArrayList<>();
        String sql =
          "SELECT * FROM (" +
          "  SELECT ROWNUM rn, A.* FROM (" +
          "    SELECT num, subject, content, writer, write_date, readcount, categori " +
          "    FROM ARTICLE " +
          "    WHERE categori = ? " +
          "    ORDER BY num DESC" +
          "  ) A WHERE ROWNUM <= ?" +
          ") WHERE rn >= ?";
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
                dto.setContent(rs.getString("content"));
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

    /** 게시글 블라인드 처리 (관리자가 게시글을 숨길 때 사용) 
     *  - categori 값을 6(블라인드)으로 변경 */
    public void changeCategory(int num, int newCategori) {
        String sql = "UPDATE article SET categori = ? WHERE num = ?";
        try {
            conn = getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, newCategori);
            ps.setInt(2, num);
            ps.executeUpdate();
        } catch(Exception e) {
            e.printStackTrace();
        } finally {
            disconnect();
        }
    }

    /** (게시글에 대한) 좋아요 수 증가/감소 업데이트 메서드 */
    public void updateLikesCount(int articleId, int change) {
        String sql = "UPDATE Article SET likes_count = likes_count + ? WHERE num = ?";
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, change);    // change=+1이면 좋아요 증가, -1이면 감소
            pstmt.setInt(2, articleId);
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            disconnect();
        }
    }

    /** 검색 결과의 총 게시글 수 조회 
     *  (searchType 컬럼에 keyword가 포함된 건수) */
    public int getSearchArticleCount(String searchType, String keyword) {
        int count = 0;
        // 검색 타입을 동적으로 SQL에 삽입 (주의: searchType은 'subject','content','writer' 중 하나여야 함)
        String sql = "SELECT COUNT(*) FROM ARTICLE WHERE " + searchType + " LIKE ?";
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, "%" + keyword + "%");
            rs = pstmt.executeQuery();
            if (rs.next()) count = rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            disconnect();
        }
        return count;
    }

    /** 검색 결과 게시글 목록 조회 (페이징) */
    public List<ArticleDTO> getSearchArticleList(int start, int end, String searchType, String keyword) {
        List<ArticleDTO> list = new ArrayList<>();
        // searchType은 사용자 입력을 허용할 경우 보안 위험이 있으므로 제한 필요 (JSP에서 allowed 리스트로 제한함)
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

    /** 공감(좋아요) 수 가져오기 */
    public int getAgreeCount(int num) {
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
        } catch(Exception e) {
            e.printStackTrace();
        }
        return count;
    }

    /** 비공감(싫어요) 수 가져오기 */
    public int getDisagreeCount(int num) {
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
        } catch(Exception e) {
            e.printStackTrace();
        }
        return count;
    }

    /** 특정 사용자가 해당 글에 공감했는지 여부 확인 */
    public boolean hasAgreed(String userId, int articleNum) {
        String sql = "SELECT 1 FROM article_emotion WHERE user_id = ? AND article_num = ? AND emotion = 'agree'";
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, userId);
            pstmt.setInt(2, articleNum);
            try (ResultSet rs = pstmt.executeQuery()) {
                if(rs.next()) return true;
            }
        } catch(Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /** 특정 사용자가 해당 글에 비공감했는지 여부 확인 */
    public boolean hasDisagreed(String userId, int articleNum) {
        String sql = "SELECT 1 FROM article_emotion WHERE user_id = ? AND article_num = ? AND emotion = 'disagree'";
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, userId);
            pstmt.setInt(2, articleNum);
            try (ResultSet rs = pstmt.executeQuery()) {
                if(rs.next()) return true;
            }
        } catch(Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /** 공감 추가 기능 (중복 공감 방지) 
     *  - 특정 사용자가 해당 글에 처음 공감 시 article 테이블의 agree_count 증가 및 article_emotion에 기록 */
    public boolean increaseAgreeCount(String userId, int articleNum) {
        if (hasAgreed(userId, articleNum)) {
            return false; // 이미 공감한 사용자면 false 처리
        }
        try {
            conn = getConnection();
            conn.setAutoCommit(false);
            // 1. article 테이블 공감 수 +1
            String sql1 = "UPDATE article SET agree_count = agree_count + 1 WHERE num = ?";
            pstmt = conn.prepareStatement(sql1);
            pstmt.setInt(1, articleNum);
            int updateCount = pstmt.executeUpdate();
            pstmt.close();
            // 2. article_emotion 테이블에 공감 기록 추가
            String sql2 = "INSERT INTO article_emotion(user_id, article_num, emotion) VALUES (?, ?, 'agree')";
            pstmt = conn.prepareStatement(sql2);
            pstmt.setString(1, userId);
            pstmt.setInt(2, articleNum);
            pstmt.executeUpdate();
            pstmt.close();
            conn.commit();
            return updateCount > 0;
        } catch(Exception e) {
            try { if(conn != null) conn.rollback(); } catch(SQLException se) { se.printStackTrace(); }
            e.printStackTrace();
            return false;
        } finally {
            try { if(conn != null) conn.setAutoCommit(true); } catch(SQLException se) { se.printStackTrace(); }
            disconnect();
        }
    }

    /** 비공감 추가 기능 (중복 비공감 방지) */
    public boolean increaseDisagreeCount(String userId, int articleNum) {
        if (hasDisagreed(userId, articleNum)) {
            return false;
        }
        try {
            conn = getConnection();
            conn.setAutoCommit(false);
            // 1. article 테이블 비공감 수 +1
            String sql1 = "UPDATE article SET disagree_count = disagree_count + 1 WHERE num = ?";
            pstmt = conn.prepareStatement(sql1);
            pstmt.setInt(1, articleNum);
            int updateCount = pstmt.executeUpdate();
            pstmt.close();
            // 2. article_emotion 테이블에 비공감 기록 추가
            String sql2 = "INSERT INTO article_emotion(user_id, article_num, emotion) VALUES (?, ?, 'disagree')";
            pstmt = conn.prepareStatement(sql2);
            pstmt.setString(1, userId);
            pstmt.setInt(2, articleNum);
            pstmt.executeUpdate();
            pstmt.close();
            conn.commit();
            return updateCount > 0;
        } catch(Exception e) {
            try { if(conn != null) conn.rollback(); } catch(SQLException se) { se.printStackTrace(); }
            e.printStackTrace();
            return false;
        } finally {
            try { if(conn != null) conn.setAutoCommit(true); } catch(SQLException se) { se.printStackTrace(); }
            disconnect();
        }
    }

    /** (사용 여부에 따라) 간단한 공감 증가 메서드 - 현재 프로젝트에서는 미사용 */
    public int increaseAgreeCount(int num) {
        int result = 0;
        String sql = "UPDATE article SET agree_count = agree_count + 1 WHERE num = ?";
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, num);
            result = pstmt.executeUpdate();
        } catch(Exception e) {
            e.printStackTrace();
        } finally {
            disconnect();
        }
        return result;
    }

    /** (사용 여부에 따라) 간단한 비공감 증가 메서드 - 현재 미사용 */
    public int increaseDisagreeCount(int num) {
        int result = 0;
        String sql = "UPDATE article SET disagree_count = disagree_count + 1 WHERE num = ?";
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, num);
            result = pstmt.executeUpdate();
        } catch(Exception e) {
            e.printStackTrace();
        } finally {
            disconnect();
        }
        return result;
    }

    /** 사용자가 특정 글에 남긴 감정(공감/비공감) 종류 조회 */
    public String getEmotionType(String userId, int articleNum) {
        String emotionType = null;
        String sql = "SELECT EMOTION FROM ARTICLE_EMOTION WHERE USER_ID = ? AND ARTICLE_NUM = ?";
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, userId);
            pstmt.setInt(2, articleNum);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    emotionType = rs.getString("EMOTION"); // "agree" 또는 "disagree"
                }
            }
        } catch(Exception e) {
            e.printStackTrace();
        }
        return emotionType;
    }

    /** (선택적) 공감/비공감 추가 - 위 increaseAgree/DisagreeCount와 유사한 통합 메서드 */
    public boolean insertArticleEmotion(String userId, int articleNum, String emotionType) {
        String checkSql = "SELECT 1 FROM ARTICLE_EMOTION WHERE USER_ID = ? AND ARTICLE_NUM = ?";
        String insertSql = "INSERT INTO ARTICLE_EMOTION (USER_ID, ARTICLE_NUM, EMOTION) VALUES (?, ?, ?)";
        // emotionType에 따라 증가시킬 컬럼 결정
        String updateSql = emotionType.equals("agree")
                         ? "UPDATE article SET agree_count = agree_count + 1 WHERE num = ?"
                         : "UPDATE article SET disagree_count = disagree_count + 1 WHERE num = ?";
        try (Connection conn = getConnection()) {
            // 1. 이미 감정을 남겼는지 확인
            try (PreparedStatement ps = conn.prepareStatement(checkSql)) {
                ps.setString(1, userId);
                ps.setInt(2, articleNum);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        return false; // 이미 기록이 있으면 추가 안 함
                    }
                }
            }
            // 2. 감정 삽입
            try (PreparedStatement ps = conn.prepareStatement(insertSql)) {
                ps.setString(1, userId);
                ps.setInt(2, articleNum);
                ps.setString(3, emotionType);
                ps.executeUpdate();
            }
            // 3. 해당 공감/비공감 카운트 증가
            try (PreparedStatement ps = conn.prepareStatement(updateSql)) {
                ps.setInt(1, articleNum);
                ps.executeUpdate();
            }
        } catch(Exception e) {
            e.printStackTrace();
            return false;
        }
        return true;
    }
}
