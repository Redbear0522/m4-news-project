package comment;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/** 댓글 관련 데이터베이스 접근 객체 */
public class CommentDAO {
    private Connection conn;
    private PreparedStatement pstmt;
    private ResultSet rs;

    private Connection getConnection() throws Exception {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        return DriverManager.getConnection("jdbc:oracle:thin:@58.73.200.225:1521:orcl","team01", "1234");
    }

    private void disconnect() {
        try { if (rs != null) rs.close(); } catch (Exception e) {}
        try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
        try { if (conn != null) conn.close(); } catch (Exception e) {}
    }

    /** 새 댓글 등록 (원글 댓글) */
    public boolean insertComment(CommentDTO dto) {
        boolean ok = false;
        // 새 댓글의 ref 값을 현재 최대 ref+1 로 설정 (새로운 스레드 시작)
        String getRefSql  = "SELECT NVL(MAX(ref),0) + 1 FROM comments";
        String insertSql =
            "INSERT INTO comments (comment_id, article_id, user_id, content, comment_date, ref, re_step, re_level) "
          + "VALUES (comment_seq.nextval, ?, ?, ?, SYSDATE, ?, 0, 0)";
        try {
            conn = getConnection();
            // 1) 새로운 ref 값 계산
            pstmt = conn.prepareStatement(getRefSql);
            rs = pstmt.executeQuery();
            int newRef = 1;
            if (rs.next()) {
                newRef = rs.getInt(1);
            }
            rs.close();
            pstmt.close();
            // 2) 댓글 INSERT
            pstmt = conn.prepareStatement(insertSql);
            pstmt.setInt   (1, dto.getArticle_id());
            pstmt.setString(2, dto.getUser_id());
            pstmt.setString(3, dto.getContent());
            pstmt.setInt   (4, newRef);
            ok = (pstmt.executeUpdate() == 1);
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            disconnect();
        }
        return ok;
    }

    /** (추가) 대댓글 등록 메서드 - 특정 댓글에 답글 달기 */
    public boolean insertReply(CommentDTO replyDto, int parentCommentId) {
        boolean ok = false;
        // 1) 부모 댓글 정보 조회 (ref, re_step, re_level 확보)
        CommentDTO parent = getCommentById(parentCommentId);
        if (parent == null) {
            return false; // 부모 댓글이 없으면 실패
        }
        int ref       = parent.getRef();
        int parentStep  = parent.getRe_step();
        int parentLevel = parent.getRe_level();
        try {
            conn = getConnection();
            conn.setAutoCommit(false);
            // 2) 같은 스레드(ref)의 기존 댓글들 re_step 증가 (부모 이후에 오는 댓글들의 순서를 뒤로 밀기)
            String updateStepSql = "UPDATE comments SET re_step = re_step + 1 "
                                  + "WHERE ref = ? AND re_step > ?";
            pstmt = conn.prepareStatement(updateStepSql);
            pstmt.setInt(1, ref);
            pstmt.setInt(2, parentStep);
            pstmt.executeUpdate();
            pstmt.close();
            // 3) 답글 INSERT (ref는 부모와 동일, re_step은 부모 바로 다음, re_level은 부모레벨+1)
            String insertSql = "INSERT INTO comments "
                             + "(comment_id, article_id, user_id, content, comment_date, ref, re_step, re_level) "
                             + "VALUES (comment_seq.nextval, ?, ?, ?, SYSDATE, ?, ?, ?)";
            pstmt = conn.prepareStatement(insertSql);
            pstmt.setInt   (1, parent.getArticle_id());
            pstmt.setString(2, replyDto.getUser_id());
            pstmt.setString(3, replyDto.getContent());
            pstmt.setInt   (4, ref);
            pstmt.setInt   (5, parentStep + 1);
            pstmt.setInt   (6, parentLevel + 1);
            int inserted = pstmt.executeUpdate();
            pstmt.close();
            conn.commit();
            ok = (inserted == 1);
        } catch (Exception e) {
            try { if(conn != null) conn.rollback(); } catch (SQLException se) { se.printStackTrace(); }
            e.printStackTrace();
        } finally {
            try { if(conn != null) conn.setAutoCommit(true); } catch (SQLException se) { se.printStackTrace(); }
            disconnect();
        }
        return ok;
    }

    /** 댓글 ID로 특정 댓글 하나 조회 */
    public CommentDTO getCommentById(int commentId) {
        CommentDTO dto = null;
        String sql = "SELECT * FROM comments WHERE comment_id = ?";
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, commentId);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                dto = new CommentDTO();
                dto.setComment_id(rs.getInt("comment_id"));
                dto.setArticle_id(rs.getInt("article_id"));
                dto.setUser_id(rs.getString("user_id"));
                dto.setContent(rs.getString("content"));
                dto.setComment_date(rs.getTimestamp("comment_date"));
                dto.setRef(rs.getInt("ref"));
                dto.setRe_step(rs.getInt("re_step"));
                dto.setRe_level(rs.getInt("re_level"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            disconnect();
        }
        return dto;
    }

    /** 특정 게시글의 전체 댓글 목록 조회 (대댓글 포함, 정렬: ref ASC, re_step ASC) */
    public List<CommentDTO> getCommentsByArticle(int articleId) {
        List<CommentDTO> list = new ArrayList<>();
        String sql =
            "SELECT comment_id, article_id, user_id, content, comment_date, ref, re_step, re_level "
          + "FROM comments WHERE article_id = ? ORDER BY ref ASC, re_step ASC";
        try {
            conn  = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, articleId);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                CommentDTO c = new CommentDTO();
                c.setComment_id  (rs.getInt("comment_id"));
                c.setArticle_id  (rs.getInt("article_id"));
                c.setUser_id     (rs.getString("user_id"));
                c.setContent     (rs.getString("content"));
                c.setComment_date(rs.getTimestamp("comment_date"));
                c.setRef         (rs.getInt("ref"));
                c.setRe_step     (rs.getInt("re_step"));
                c.setRe_level    (rs.getInt("re_level"));
                list.add(c);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            disconnect();
        }
        return list;
    }

    /** 댓글 수정 (내용만 변경) */
    public boolean updateComment(CommentDTO dto) {
        boolean ok = false;
        String sql = "UPDATE comments SET content = ? WHERE comment_id = ?";
        try {
            conn  = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, dto.getContent());
            pstmt.setInt   (2, dto.getComment_id());
            ok = (pstmt.executeUpdate() == 1);
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            disconnect();
        }
        return ok;
    }

    /** 댓글 삭제 */
    public boolean deleteComment(int commentId) {
        boolean ok = false;
        String sql = "DELETE FROM comments WHERE comment_id = ?";
        try {
            conn  = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, commentId);
            ok = (pstmt.executeUpdate() == 1);
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            disconnect();
        }
        return ok;
    }

    /** 내가 쓴 댓글 목록 조회 (특정 사용자의 모든 댓글 + 각 댓글의 좋아요/싫어요 수 포함) */
    public List<CommentDTO> getCommentsByUserId(String userId) {
        List<CommentDTO> list = new ArrayList<>();
        // COMMENT_EMOTION 테이블과 ARTICLE 테이블을 활용해 각 댓글의 좋아요/싫어요 count, 해당 댓글이 달린 글 제목까지 조회
        String sql =
            "SELECT c.comment_id, c.article_id, c.user_id, c.content, c.comment_date, a.subject, "
          + "  (SELECT COUNT(*) FROM COMMENT_EMOTION ce WHERE ce.COMMENT_ID = c.comment_id AND ce.EMOTION_TYPE = 'like')    AS like_count, "
          + "  (SELECT COUNT(*) FROM COMMENT_EMOTION ce WHERE ce.COMMENT_ID = c.comment_id AND ce.EMOTION_TYPE = 'dislike') AS dislike_count "
          + "FROM comments c JOIN article a ON c.article_id = a.num "
          + "WHERE c.user_id = ? "
          + "ORDER BY c.comment_date DESC";
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, userId);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                CommentDTO dto = new CommentDTO();
                dto.setComment_id(rs.getInt("comment_id"));
                dto.setArticle_id(rs.getInt("article_id"));
                dto.setUser_id(rs.getString("user_id"));
                dto.setContent(rs.getString("content"));
                dto.setComment_date(rs.getTimestamp("comment_date"));
                // 부가 정보
                dto.setArticleSubject(rs.getString("subject"));     // 해당 댓글이 달린 글 제목
                dto.setLikeCount(rs.getInt("like_count"));          // 댓글 추천 수
                dto.setDislikeCount(rs.getInt("dislike_count"));    // 댓글 비추천 수
                list.add(dto);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            disconnect();
        }
        return list;
    }
}
