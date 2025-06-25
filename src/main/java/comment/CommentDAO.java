package comment;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CommentDAO {
    private Connection        conn;
    private PreparedStatement pstmt;
    private ResultSet         rs;

    private Connection getConnection() throws Exception {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        return DriverManager.getConnection(
            "jdbc:oracle:thin:@192.168.219.198:1521:orcl",
            "team01", "1234"
        );
    }

    private void disconnect() {
        try { if (rs    != null) rs.close();    } catch (Exception e) {}
        try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
        try { if (conn  != null) conn.close();  } catch (Exception e) {}
    }

    /** 새 댓글(원글) 등록 */
    public boolean insertComment(CommentDTO dto) {
        boolean ok = false;
        String getRefSql  = "SELECT NVL(MAX(ref),0)+1 FROM comments";
        String insertSql =
            "INSERT INTO comments "
          + "(comment_id, article_id, user_id, content, comment_date, ref, re_step, re_level) "
          + "VALUES (comment_seq.nextval, ?, ?, ?, SYSDATE, ?, 0, 0)";

        try {
            conn = getConnection();

            // 1) 새 REF 값 계산
            pstmt = conn.prepareStatement(getRefSql);
            rs = pstmt.executeQuery();
            int newRef = 1;
            if (rs.next()) newRef = rs.getInt(1);
            pstmt.close();

            // 2) 댓글 insert
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

    /** 특정 게시글의 댓글 목록 조회 */
    public List<CommentDTO> getCommentsByArticle(int articleId) {
        List<CommentDTO> list = new ArrayList<>();
        String sql =
            "SELECT comment_id, article_id, user_id, content, comment_date, ref, re_step, re_level "
          + "FROM comments "
          + "WHERE article_id = ? "
          + "ORDER BY ref, re_step";

        try {
            conn  = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, articleId);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                CommentDTO c = new CommentDTO();
                c.setComment_id  (rs.getInt   ("comment_id"));
                c.setArticle_id  (rs.getInt   ("article_id"));
                c.setUser_id     (rs.getString("user_id"));
                c.setContent     (rs.getString("content"));
                c.setComment_date(rs.getTimestamp("comment_date"));
                c.setRef         (rs.getInt   ("ref"));
                c.setRe_step     (rs.getInt   ("re_step"));
                c.setRe_level    (rs.getInt   ("re_level"));
                list.add(c);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            disconnect();
        }
        return list;
    }

    /** 댓글 수정 */
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

    /** 내가 쓴 댓글 목록 조회 */
    public List<CommentDTO> getCommentsByUserId(String userId) {
        List<CommentDTO> list = new ArrayList<>();
        
        // ✅ 수정: 서브쿼리 내의 컬럼명을 DB 스키마에 맞게 대문자로 변경 (ce.comment_id -> ce.COMMENT_ID, ce.emotion_type -> ce.EMOTION_TYPE)
        String sql =
        	    "SELECT "
        	  + "  c.comment_id, c.article_id, c.user_id, c.content, c.comment_date, "
        	  + "  a.subject, "
        	  // like_count
        	  + "  (SELECT COUNT(*) "
        	  + "     FROM COMMENT_EMOTION ce "
        	  + "    WHERE ce.COMMENT_ID = c.comment_id "
        	  + "      AND ce.EMOTION_TYPE = 'like') AS like_count, "
        	  // dislike_count (쉼표 주의!)
        	  + "  (SELECT COUNT(*) "
        	  + "     FROM COMMENT_EMOTION ce "
        	  + "    WHERE ce.COMMENT_ID = c.comment_id "
        	  + "      AND ce.EMOTION_TYPE = 'dislike') AS dislike_count "
        	  + "FROM comments c "
        	  + "JOIN article a ON c.article_id = a.num "
        	  + "WHERE c.user_id = ? "
        	  + "ORDER BY c.comment_date DESC";
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

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
                
                dto.setArticleSubject(rs.getString("subject"));
                dto.setLikeCount(rs.getInt("like_count"));
                dto.setDislikeCount(rs.getInt("dislike_count"));

                
                list.add(dto);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            disconnect();
        }
        return list;
    }
    
    /** 댓글 추천 수 증가 */
    public int increaseLikeCount(int commentId) {
        int result = 0;
        String sql = "UPDATE comments SET like_count = like_count + 1 WHERE comment_id = ?";

        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, commentId);
            result = pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
            try { if (conn  != null) conn.close(); } catch (Exception e) {}
        }

        return result;
    }

    
    /** 댓글 비추천 수 증가 */
    public int increaseDislikeCount(int commentId) throws SQLException, ClassNotFoundException {
        int result = 0;
        String sql = "UPDATE comments SET dislike_count = dislike_count + 1 WHERE comment_id = ?";

        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, commentId);
            result = pstmt.executeUpdate();
        }catch(Exception e) {
        	e.printStackTrace();
        }finally {
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        }
        return result;
        
    }
    
    public String getCommentEmotion(String userId, int commentId) throws Exception {
        String sql = "SELECT EMOTION FROM COMMENT_EMOTION WHERE USER_ID = ? AND COMMENT_ID = ?";
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, userId);
            pstmt.setInt(2, commentId);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getString("EMOTION");  // "like" or "dislike"
            }
        } finally {
            disconnect();
        }
        return null;
    }

    public boolean insertCommentEmotion(String userId, int commentId, String emotion) throws Exception {
        String sql = "INSERT INTO COMMENT_EMOTION (ID, USER_ID, COMMENT_ID, EMOTION, CREATED_AT) VALUES (COMMENT_EMOTION_SEQ.NEXTVAL, ?, ?, ?, SYSDATE)";
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, userId);
            pstmt.setInt(2, commentId);
            pstmt.setString(3, emotion); // "like" or "dislike"
            return pstmt.executeUpdate() == 1;
        } finally {
            disconnect();
        } 
    }
    
    

}
