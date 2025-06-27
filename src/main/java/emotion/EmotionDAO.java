// emotion/EmotionDAO.java
package emotion;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class EmotionDAO {
    private Connection conn;
    private PreparedStatement pstmt;
    private ResultSet rs;

    // 1) DB 연결 (기존과 동일)
    private Connection getConnection() throws ClassNotFoundException, SQLException {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        String url = "jdbc:oracle:thin:@58.73.200.225:1521:orcl";
        //String url = "jdbc:oracle:thin:@192.168.219.198:1521:orcl";
        return DriverManager.getConnection(url, "team01", "1234");
    }

    // 2) 자원 해제 (기존과 동일)
    private void disconnect() {
        try { if (rs   != null && !rs.isClosed())   rs.close();   } catch (Exception e) { e.printStackTrace(); }
        try { if (pstmt != null && !pstmt.isClosed()) pstmt.close(); } catch (Exception e) { e.printStackTrace(); }
        try { if (conn  != null && !conn.isClosed())  conn.close();  } catch (Exception e) { e.printStackTrace(); }
    }

    // 3) 댓글 감정 표현 추가
    public boolean insertEmotion(EmotionDTO dto) {
        String checkSql = "SELECT 1 FROM COMMENT_EMOTION WHERE COMMENT_ID = ? AND USER_ID = ?";
        String insertSql =
            "INSERT INTO COMMENT_EMOTION (ID, COMMENT_ID, EMOTION_TYPE, USER_ID, CREATED_AT) " +
            "VALUES (comment_emotion_seq.nextval, ?, ?, ?, SYSDATE)";
        try {
            conn = getConnection();

            // 1) 먼저 중복 확인
            pstmt = conn.prepareStatement(checkSql);
            pstmt.setInt(1, dto.getCommentId());
            pstmt.setString(2, dto.getUserId());
            rs = pstmt.executeQuery();
            if (rs.next()) {
                return false;
            }
            pstmt.close();

            // 2) 삽입
            pstmt = conn.prepareStatement(insertSql);
            pstmt.setInt(1, dto.getCommentId());
            pstmt.setString(2, dto.getEmotionType());
            pstmt.setString(3, dto.getUserId());
            return pstmt.executeUpdate() == 1;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            disconnect();
        }
    }


    // 4) 특정 댓글의 감정 개수 조회 (기존과 동일, 문제 없음)
    public int getEmotionCount(int commentId, String emotionType) {
        String sql =
            "SELECT COUNT(*) FROM COMMENT_EMOTION " +
            "WHERE COMMENT_ID = ? AND EMOTION_TYPE = ?";
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt   (1, commentId);
            pstmt.setString(2, emotionType);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            disconnect();
        }
        return 0;
    }
    
    // 5) 사용자가 특정 댓글에 특정 감정을 이미 표현했는지 확인 (기존과 동일, 문제 없음)
    public boolean hasUserReacted(int commentId, String userId, String emotionType) {
        String sql = "SELECT 1 FROM COMMENT_EMOTION WHERE COMMENT_ID = ? AND USER_ID = ? AND EMOTION_TYPE = ?";
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, commentId);
            pstmt.setString(2, userId);
            pstmt.setString(3, emotionType);
            rs = pstmt.executeQuery();
            return rs.next();
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            disconnect();
        }
    }
    
    // 6) 사용자의 감정 표현 삭제 (기존과 동일, 문제 없음)
    public boolean deleteEmotion(int commentId, String userId, String emotionType) {
        String sql = "DELETE FROM COMMENT_EMOTION WHERE COMMENT_ID = ? AND USER_ID = ? AND EMOTION_TYPE = ?";
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, commentId);
            pstmt.setString(2, userId);
            pstmt.setString(3, emotionType);
            return pstmt.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            disconnect();
        }
    }
    
 // 사용자가 특정 댓글에 남긴 감정이 있는지 확인
    public String getUserEmotionForComment(String userId, int commentId) throws Exception {
        String sql = "SELECT emotion_type FROM COMMENT_EMOTION WHERE user_id = ? AND comment_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, userId);
            pstmt.setInt(2, commentId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getString("emotion_type");
            }
        }
        return null;
    }


}