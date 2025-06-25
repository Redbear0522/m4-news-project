package member;

import java.sql.Date;

public class UserDTO {
    private String  id;               // ID            VARCHAR2(100)
    private String  pw;               // PW            VARCHAR2(100)
    private String  name;             // NAME          VARCHAR2(100)
    private Date    birth;            // BIRTH         DATE
    private Integer gender;           // GENDER        NUMBER
    private Integer phone1;           // PHONE1        NUMBER
    private Integer phone2;           // PHONE2        NUMBER
    private Integer job;              // JOB           NUMBER
    private String  zip;              // ZIP           VARCHAR2(100)
    private String  addr1;            // ADDR1         VARCHAR2(100)
    private String  addr2;            // ADDR2         VARCHAR2(100)
    private Date    regDate;          // REG_DATE      DATE
    private String  approvalStatus;   // APPROVAL_STATUS CHAR(1)
    private String company;
    private String status;  // 회원 상태: active / blocked
    
    // --- getters & setters ---
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getPw() { return pw; }
    public void setPw(String pw) { this.pw = pw; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public Date getBirth() { return birth; }
    public void setBirth(Date birth) { this.birth = birth; }

    public Integer getGender() { return gender; }
    public void setGender(Integer gender) { this.gender = gender; }

    public Integer getPhone1() { return phone1; }
    public void setPhone1(Integer phone1) { this.phone1 = phone1; }

    public Integer getPhone2() { return phone2; }
    public void setPhone2(Integer phone2) { this.phone2 = phone2; }

    public Integer getJob() { return job; }
    public void setJob(Integer job) { this.job = job; }

    public String getZip() { return zip; }
    public void setZip(String zip) { this.zip = zip; }

    public String getAddr1() { return addr1; }
    public void setAddr1(String addr1) { this.addr1 = addr1; }

    public String getAddr2() { return addr2; }
    public void setAddr2(String addr2) { this.addr2 = addr2; }

    public Date getRegDate() { return regDate; }
    public void setRegDate(Date regDate) { this.regDate = regDate; }

    public String getApprovalStatus() { return approvalStatus; }
    public void setApprovalStatus(String approvalStatus) { this.approvalStatus = approvalStatus; }
    
    public String getStatus() { return status;}
    public void setStatus(String status) { this.status = status;}
    
    public String getCompany() {return company;}
    public void setCompany(String company) {this.company=company;}
}

