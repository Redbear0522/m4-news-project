package article;

import java.sql.Timestamp;

public class ArticleDTO {
    private int num;
    private String writer;
    private String subject;
    private String content;
    private String passwd;
    private Timestamp write_date;
    private Timestamp update_date;
    private int readcount;
    private int like_count;
    private int good_count;
    private int sad_count;
    private int angry_count;
    private int wow_count;
    private int categori;
    private int file_num;
    private boolean emphasized;
    private String filename;
    private int cmtCnt;
    private int agree_count; // 기사 공감
    private int disagree_count; // 기사 비공감


    
    // --- Getters & Setters ---
    public int getNum() { return num; }
    public void setNum(int num) { this.num = num; }

    public String getWriter() { return writer; }
    public void setWriter(String writer) { this.writer = writer; }

    public String getSubject() { return subject; }
    public void setSubject(String subject) { this.subject = subject; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public String getPasswd() { return passwd; }
    public void setPasswd(String passwd) { this.passwd = passwd; }

    public Timestamp getWrite_date() { return write_date; }
    public void setWrite_date(Timestamp write_date) { this.write_date = write_date; }

    public Timestamp getUpdate_date() { return update_date; }
    public void setUpdate_date(Timestamp update_date) { this.update_date = update_date; }

    public int getReadcount() { return readcount; }
    public void setReadcount(int readcount) { this.readcount = readcount; }

    public int getLike_count() { return like_count; }
    public void setLike_count(int like_count) { this.like_count = like_count; }

    public int getGood_count() { return good_count; }
    public void setGood_count(int good_count) { this.good_count = good_count; }

    public int getSad_count() { return sad_count; }
    public void setSad_count(int sad_count) { this.sad_count = sad_count; }

    public int getAngry_count() { return angry_count; }
    public void setAngry_count(int angry_count) { this.angry_count = angry_count; }

    public int getWow_count() { return wow_count; }
    public void setWow_count(int wow_count) { this.wow_count = wow_count; }

    public int getCategori() { return categori; }
    public void setCategori(int categori) { this.categori = categori; }

    public int getFile_num() { return file_num; }
    public void setFile_num(int file_num) { this.file_num = file_num; }

    public boolean isEmphasized() { return emphasized; }
    public void setEmphasized(boolean emphasized) { this.emphasized = emphasized; }

    public String getFilename() { return filename; }
    public void setFilename(String filename) { this.filename = filename; }

    public int getCmtCnt() { return cmtCnt; }
    public void setCmtCnt(int cmtCnt) { this.cmtCnt = cmtCnt; }
    
    public int getAgree_count() { return agree_count; }
	public void setAgree_count(int agree_count) { this.agree_count = agree_count; }
	
    public int getDisagree_count() { return disagree_count; }
    public void setDisagree_count(int disagree_count) {this.disagree_count = disagree_count;}
}