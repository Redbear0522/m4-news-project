package comment;

import java.sql.Timestamp;

public class CommentDTO {
	private int comment_id;
	private int article_id;
	private String user_id;
	private String content;
	private Timestamp comment_date;
    private int ref;
    private int re_step;	
    private int re_level;
    
    // ✅ 아래 두 변수를 추가합니다.
    private String articleSubject; // 원문 기사 제목을 담을 변수
    private int likeCount;         // 댓글이 받은 추천수를 담을 변수
    private int dislikeCount;	   // 댓글이 받은 비추천수를 담을 변수	

	// --- 기존 Getter/Setter는 여기에 그대로 둡니다. ---
	public int getComment_id() { return comment_id; }
	public void setComment_id(int comment_id) { this.comment_id = comment_id; }
	public int getArticle_id() { return article_id; }
	public void setArticle_id(int article_id) { this.article_id = article_id; }
	public String getUser_id() { return user_id; }
	public void setUser_id(String user_id) { this.user_id = user_id; }
	public String getContent() { return content; }
	public void setContent(String content) { this.content = content; }
	public Timestamp getComment_date() { return comment_date; }
	public void setComment_date(Timestamp comment_date) { this.comment_date = comment_date; }
	public int getRef() { return ref; }
	public void setRef(int ref) { this.ref = ref; }
	public int getRe_step() { return re_step; }
	public void setRe_step(int re_step) { this.re_step = re_step; }
	public int getRe_level() { return re_level; }
	public void setRe_level(int re_level) { this.re_level = re_level; }
    
    // ✅ 추가된 변수들의 Getter/Setter
    public String getArticleSubject() {
        return articleSubject;
    }
    public void setArticleSubject(String articleSubject) {
        this.articleSubject = articleSubject;
    }
    public int getLikeCount() {
        return likeCount;
    }
    public void setLikeCount(int likeCount) {
        this.likeCount = likeCount;
    }
    public int getDislikeCount() {
  		return dislikeCount;
  	}
  	public void setDislikeCount(int dislikeCount) {
  		this.dislikeCount = dislikeCount;
  	}
    
}