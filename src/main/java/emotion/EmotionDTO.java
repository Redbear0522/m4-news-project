// emotion/EmotionDTO.java
package emotion;

import java.sql.Timestamp;

public class EmotionDTO {
    // ✅ 수정: DB 컬럼명에 맞게 필드명 변경 (reactionId -> id, reactionType -> emotionType, reactionDate -> createdAt)
    private int       id;             // DB의 ID 컬럼
    private int       commentId;      // DB의 COMMENT_ID 컬럼
    private String    userId;         // DB의 USER_ID 컬럼
    private String    emotionType;    // DB의 EMOTION_TYPE 컬럼
    private Timestamp createdAt;      // DB의 CREATED_AT 컬럼

    // ✅ 수정: 변경된 필드명에 맞게 Getter/Setter 전체 수정
    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id = id;
    }

    public int getCommentId() {
        return commentId;
    }
    public void setCommentId(int commentId) {
        this.commentId = commentId;
    }

    public String getUserId() {
        return userId;
    }
    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getEmotionType() {
        return emotionType;
    }
    public void setEmotionType(String emotionType) {
        this.emotionType = emotionType;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}