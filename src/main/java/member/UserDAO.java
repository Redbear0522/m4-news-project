package member;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;


public class UserDAO {
    private Connection conn;
    private PreparedStatement pstmt;
    private ResultSet rs;

    // 1) DB 연결
    private Connection getConnection() throws ClassNotFoundException, SQLException {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        String url = "jdbc:oracle:thin:@58.73.200.225:1521:orcl";
        //String url= "jdbc:oracle:thin:@192.168.219.198:1521:orcl";
        return DriverManager.getConnection(url, "team01", "1234");
    }

    // 2) 자원 해제
    private void disconnect() {
        try { if (rs    != null && !rs.isClosed())    rs.close();    } catch (Exception e) { e.printStackTrace(); }
        try { if (pstmt != null && !pstmt.isClosed()) pstmt.close(); } catch (Exception e) { e.printStackTrace(); }
        try { if (conn  != null && !conn.isClosed())  conn.close();  } catch (Exception e) { e.printStackTrace(); }
    }

    // 3) 회원가입 처리 (member + memberimage)
    public boolean input(UserDTO dto) {
        boolean success = false;

        String sql1 = "INSERT INTO member (ID, PW, NAME, BIRTH, GENDER, PHONE1, PHONE2, JOB, ZIP, ADDR1, ADDR2, APPROVAL_STATUS, COMPANY)"
                    + " VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)";
        String sql2 = "INSERT INTO memberimage (ID) VALUES (?)";

        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql1);

            pstmt.setString(1, dto.getId());
            pstmt.setString(2, dto.getPw());
            pstmt.setString(3, dto.getName());
            pstmt.setDate(4, dto.getBirth());
            pstmt.setInt(5, dto.getGender());
            pstmt.setInt(6, dto.getPhone1());
            pstmt.setInt(7, dto.getPhone2());
            pstmt.setInt(8, dto.getJob());
            pstmt.setString(9, dto.getZip());
            pstmt.setString(10, dto.getAddr1());
            pstmt.setString(11, dto.getAddr2());
            

            // ✅ job이 1번이면 Y, 아니면 N 또는 null
            String approval = (dto.getJob() == 1) ? "Y" : "W";
            pstmt.setString(12, approval);

            pstmt.setString(13, dto.getCompany());

            int cnt1 = pstmt.executeUpdate();

            try {
                pstmt.close();
                pstmt = conn.prepareStatement(sql2);
                pstmt.setString(1, dto.getId());
                pstmt.executeUpdate();
            } catch (SQLException e) {
                if (e.getErrorCode() != 942) { // ORA-00942: 테이블 또는 뷰 없음
                    throw e;
                }
            }

            success = (cnt1 > 0);
        } catch (SQLException e) {
            if (e.getErrorCode() == 1) {
                success = false; // PK 중복
            } else {
                e.printStackTrace();
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            disconnect();
        }
        return success;
    }


    // 4) 아이디 중복 확인
    public boolean isIdExists(String id) {
        boolean exists = false;
        String sql = "SELECT 1 FROM member WHERE ID = ?";
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, id.trim());
            rs = pstmt.executeQuery();
            exists = rs.next();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            disconnect();
        }
        return exists;
    }

    // 5) 로그인 체크 (ID + PW)
    public boolean checkIdPwd(String id, String pw) {
        boolean ok = false;
        String sql = "SELECT 1 FROM member WHERE ID = ? AND PW = ?";
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, id);
            pstmt.setString(2, pw);
            rs = pstmt.executeQuery();
            ok = rs.next();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            disconnect();
        }
        return ok;
    }

    // 6) 아이디 찾기
    public String findId(String name, String phone2) {
        String sql = "SELECT id FROM member WHERE name = ? AND phone2 = ?";
        String result = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, name);
            pstmt.setString(2, phone2);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                result = rs.getString("id");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            disconnect();
        }
        return result;
    }

    // 7) 비밀번호 찾기
    public String findPw(String id, String name, String phone2) {
        String found = null;
        // 기존 birth, date 조건 제거, 파라미터 순서도 id, name, phone2 순으로 변경
        String sql = "SELECT pw FROM member WHERE id = ? AND name = ? AND phone2 = ?";
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, id);
            pstmt.setString(2, name);
            pstmt.setString(3, phone2);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                found = rs.getString("pw");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            disconnect();
        }
        return found;
    }
 

    // 8) 회원 정보 조회 (getUserById)
    public UserDTO getUserById(String id) {
        UserDTO dto = null;
        String sql = "SELECT * FROM member WHERE ID = ?";
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, id);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                dto = new UserDTO();
                dto.setId(rs.getString("ID"));
                dto.setPw(rs.getString("PW"));
                dto.setName(rs.getString("NAME"));
                dto.setBirth(rs.getDate("BIRTH"));
                dto.setGender(rs.getInt("GENDER"));
                dto.setPhone1(rs.getInt("PHONE1"));
                dto.setPhone2(rs.getInt("PHONE2"));
                dto.setJob(rs.getInt("JOB"));
                dto.setZip(rs.getString("ZIP"));
                dto.setAddr1(rs.getString("ADDR1"));
                dto.setAddr2(rs.getString("ADDR2"));
                dto.setRegDate(rs.getDate("REG_DATE"));
                dto.setApprovalStatus(rs.getString("APPROVAL_STATUS"));
                dto.setCompany(rs.getString("company"));
                dto.setStatus(rs.getString("STATUS")); 
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            disconnect();
        }
        return dto;
    }
    // 9)프로필 업데이트
    public boolean updateProfile(String id, String filename) {
        String sql = "UPDATE member SET profile_img = ? WHERE id = ?";
        boolean success = false;
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, filename);
            ps.setString(2, id);
            success = ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return success;
    }

    // 10) 프로필 조회 (기본 이미지 처리)
    public String getProfile(String id) {
        String filename = "default.png";
        String sql = "SELECT profile_img FROM member WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next() && rs.getString("profile_img") != null) {
                    filename = rs.getString("profile_img");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return filename;
    }

    // 11) 비밀번호 변경
    public boolean pwChange(String id, String pw) {
        boolean ok = false;
        String sql = "UPDATE member SET PW = ? WHERE ID = ?";
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, pw);
            pstmt.setString(2, id);
            ok = (pstmt.executeUpdate() > 0);
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            disconnect();
        }
        return ok;
    }

    // 12) 회원 정보 수정
    public boolean updateUser(UserDTO dto) {
        boolean ok = false;
        String sql = "UPDATE member SET NAME=?, BIRTH=?, PHONE1=?, PHONE2=?, GENDER=?, ZIP=?, ADDR1=?, ADDR2=?, COMPANY=?, job=? WHERE ID = ?";
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1,  dto.getName());
            pstmt.setDate(2,    dto.getBirth());
            pstmt.setInt(3,     dto.getPhone1());
            pstmt.setInt(4,     dto.getPhone2());
            pstmt.setInt(5,     dto.getGender());
            pstmt.setString(6,  dto.getZip());
            pstmt.setString(7,  dto.getAddr1());
            pstmt.setString(8,  dto.getAddr2());
            pstmt.setString(9,  dto.getCompany());
            pstmt.setInt(10,    dto.getJob());
            pstmt.setString(11, dto.getId()); // WHERE 절
            ok = (pstmt.executeUpdate() > 0);
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            disconnect();
        }
        return ok;
    }


    // 13) 회원 탈퇴
    public boolean deleteMember(String id) {
        boolean ok = false;
        String sql1 = "DELETE FROM member WHERE ID = ?";
        String sql2 = "DELETE FROM memberimage WHERE ID = ?";
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql1);
            pstmt.setString(1, id);
            int d1 = pstmt.executeUpdate();
            pstmt.close();
            pstmt = conn.prepareStatement(sql2);
            pstmt.setString(1, id);
            int d2 = pstmt.executeUpdate();
            ok = (d1 > 0 && d2 > 0);
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            disconnect();
        }
        return ok;
    }

    // 14) 회원 정보 조회 (getInfo)
    public UserDTO getInfo(String id) {
        UserDTO dto = null;
        String sql = "SELECT * FROM member WHERE ID = ?";
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, id);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                dto = new UserDTO();
                dto.setId(rs.getString("ID"));
                dto.setPw(rs.getString("PW"));
                dto.setName(rs.getString("NAME"));
                dto.setBirth(rs.getDate("BIRTH"));
                dto.setGender(rs.getInt("GENDER"));
                dto.setPhone1(rs.getInt("PHONE1"));
                dto.setPhone2(rs.getInt("PHONE2"));
                dto.setJob(rs.getInt("JOB"));
                dto.setZip(rs.getString("ZIP"));
                dto.setAddr1(rs.getString("ADDR1"));
                dto.setAddr2(rs.getString("ADDR2"));
                dto.setRegDate(rs.getDate("REG_DATE"));
                dto.setApprovalStatus(rs.getString("APPROVAL_STATUS"));
                dto.setCompany(rs.getString("COMPANY"));
                dto.setStatus(rs.getString("status")); 
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            disconnect();
        }
        return dto;
    }

    // 15) 승인 대기 회원 목록 조회 (getPendingMembers)
    public List<UserDTO> getPendingMembers() {
        List<UserDTO> list = new ArrayList<>();
        String sql = "SELECT * FROM member WHERE APPROVAL_STATUS = 'W' ORDER BY REG_DATE DESC";
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                UserDTO dto = new UserDTO();
                dto.setId(rs.getString("ID"));
                dto.setName(rs.getString("NAME"));
                dto.setRegDate(rs.getDate("REG_DATE"));
                dto.setApprovalStatus(rs.getString("APPROVAL_STATUS"));
                list.add(dto);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            disconnect();
        }
        return list;
    }
    public boolean updateApprovalStatus(String id, String status) {
        boolean success = false;
        String sql = "UPDATE member SET approval_status = ? WHERE id = ?";
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, status);
            pstmt.setString(2, id);
            int cnt = pstmt.executeUpdate();
            success = (cnt > 0);
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            disconnect();
        }
        return success;
    }
 // 16) 전체 회원 조회
    public List<UserDTO> getAllUsers() {
        List<UserDTO> list = new ArrayList<>();
        String sql = "SELECT * FROM member";
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                UserDTO dto = new UserDTO();
                dto.setId(rs.getString("ID"));
                dto.setName(rs.getString("name"));
                dto.setGender(rs.getInt("gender"));
                dto.setJob(rs.getInt("job"));
                dto.setStatus(rs.getString("status")); // 상태 필드 추가
                list.add(dto);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    // 17) 차단 처리
    public void blockUser(String id) {
        String sql = "UPDATE member SET status = 'blocked' WHERE ID = ?";
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, id);
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    // 차단 해제 메서드
    public void unblockUser(String userId) {
        String sql = "UPDATE member SET status = NULL WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, userId);
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }



}
