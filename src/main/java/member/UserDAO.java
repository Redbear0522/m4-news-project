package member;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/** 회원 데이터베이스 접근 객체 (DAO) */
public class UserDAO {
    // 데이터베이스 연결에 사용할 객체들
    private Connection conn;
    private PreparedStatement pstmt;
    private ResultSet rs;

    /** 데이터베이스 연결을 수행하는 메서드 */
    private Connection getConnection() throws ClassNotFoundException, SQLException {
        // Oracle JDBC 드라이버 로드
        Class.forName("oracle.jdbc.driver.OracleDriver");
        // Oracle DB 연결 URL, 사용자명, 비밀번호 지정 (해당 값들은 환경에 맞게 수정 가능)
        String url = "jdbc:oracle:thin:@58.73.200.225:1521:orcl";
        return DriverManager.getConnection(url, "team01", "1234");
    }

    /** 데이터베이스 자원 해제를 처리하는 메서드 */
    private void disconnect() {
        try { if (rs != null && !rs.isClosed()) rs.close(); } catch (Exception e) { e.printStackTrace(); }
        try { if (pstmt != null && !pstmt.isClosed()) pstmt.close(); } catch (Exception e) { e.printStackTrace(); }
        try { if (conn != null && !conn.isClosed()) conn.close(); } catch (Exception e) { e.printStackTrace(); }
    }

    /** 1) 회원가입 처리 메서드 
     * 주어진 UserDTO 정보를 DB의 member 테이블에 저장 */
    public boolean input(UserDTO dto) {
        boolean success = false;
        // member 테이블에 새 회원 추가 (APPROVAL_STATUS, REG_DATE 등은 기본값 설정 가정)
        String sql = "INSERT INTO member "
                   + "(ID, PW, NAME, BIRTH, GENDER, PHONE1, PHONE2, JOB, ZIP, ADDR1, ADDR2, APPROVAL_STATUS, COMPANY)"
                   + " VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)";
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            // PreparedStatement를 사용해 각 ? 위치에 DTO의 데이터를 세팅
            pstmt.setString(1, dto.getId());
            pstmt.setString(2, dto.getPw());
            pstmt.setString(3, dto.getName());
            pstmt.setDate(4, dto.getBirth());        // Date 타입 (생일)
            pstmt.setInt(5, dto.getGender());        // 성별 (예: 0=여, 1=남 등 숫자로 표현)
            pstmt.setInt(6, dto.getPhone1());        // 연락처 앞자리 
            pstmt.setInt(7, dto.getPhone2());        // 연락처 뒷자리
            pstmt.setInt(8, dto.getJob());           // 직업 코드 (예: 1=기자 신청자 등)
            pstmt.setString(9, dto.getZip());        // 우편번호
            pstmt.setString(10, dto.getAddr1());     // 주소1
            pstmt.setString(11, dto.getAddr2());     // 주소2
            // 승인 상태: JOB이 1이면 관리자/특정직업으로 간주하여 즉시 승인 'Y', 아니면 승인 대기 'W'
            String approval = (dto.getJob() == 1) ? "Y" : "W";
            pstmt.setString(12, approval);
            pstmt.setString(13, dto.getCompany());   // 회사명 (기자 신청자의 소속 등)
            int cnt = pstmt.executeUpdate();         // INSERT 수행
            success = (cnt > 0);
        } catch (SQLException e) {
            if (e.getErrorCode() == 1) {
                // ORA-00001 (기본키 등 중복) 에러인 경우 회원 ID 중복으로 간주
                success = false;
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

    /** 2) 아이디 중복 여부 확인 */
    public boolean isIdExists(String id) {
        boolean exists = false;
        String sql = "SELECT 1 FROM member WHERE ID = ?";
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, id.trim());
            rs = pstmt.executeQuery();
            exists = rs.next();  // 쿼리 결과 존재 여부로 중복 확인
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            disconnect();
        }
        return exists;
    }

    /** 3) 로그인 검증 (ID와 PW가 일치하는지 확인) */
    public boolean checkIdPwd(String id, String pw) {
        boolean valid = false;
        String sql = "SELECT 1 FROM member WHERE ID = ? AND PW = ?";
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, id);
            pstmt.setString(2, pw);
            rs = pstmt.executeQuery();
            valid = rs.next();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            disconnect();
        }
        return valid;
    }

    /** 4) 회원 ID 찾기 (이름과 연락처로 ID 조회) */
    public String findId(String name, String phone2) {
        String foundId = null;
        String sql = "SELECT id FROM member WHERE name = ? AND phone2 = ?";
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, name);
            pstmt.setString(2, phone2);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                foundId = rs.getString("id");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            disconnect();
        }
        return foundId;
    }

    /** 5) 비밀번호 찾기 (ID, 이름, 연락처로 PW 조회) */
    public String findPw(String id, String name, String phone2) {
        String foundPw = null;
        String sql = "SELECT pw FROM member WHERE id = ? AND name = ? AND phone2 = ?";
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, id);
            pstmt.setString(2, name);
            pstmt.setString(3, phone2);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                foundPw = rs.getString("pw");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            disconnect();
        }
        return foundPw;
    }

    /** 6) 특정 회원 정보 조회 (ID로 검색) */
    public UserDTO getUserById(String id) {
        UserDTO dto = null;
        String sql = "SELECT * FROM member WHERE ID = ?";
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, id);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                // 조회된 회원 정보를 UserDTO 객체에 담는다.
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
                dto.setStatus(rs.getString("STATUS"));  // 활동 상태 (예: 차단 여부) 
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            disconnect();
        }
        return dto;
    }

    /** 7) 프로필 이미지 파일명 저장/업데이트 */
    public boolean updateProfile(String id, String filename) {
        boolean success = false;
        String sql = "UPDATE member SET profile_img = ? WHERE id = ?";
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

    /** 8) 프로필 이미지 파일명 조회 (없을 경우 기본 이미지명 반환) */
    public String getProfile(String id) {
        String filename = "default.png"; // 기본 프로필 이미지
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

    /** 9) 비밀번호 변경 */
    public boolean pwChange(String id, String newPw) {
        boolean ok = false;
        String sql = "UPDATE member SET PW = ? WHERE ID = ?";
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, newPw);
            pstmt.setString(2, id);
            ok = (pstmt.executeUpdate() > 0);
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            disconnect();
        }
        return ok;
    }

    /** 10) 회원 정보 수정 (이름, 연락처, 주소 등 변경) */
    public boolean updateUser(UserDTO dto) {
        boolean ok = false;
        String sql = "UPDATE member SET NAME=?, BIRTH=?, PHONE1=?, PHONE2=?, GENDER=?, "
                   + "ZIP=?, ADDR1=?, ADDR2=?, COMPANY=?, JOB=? WHERE ID = ?";
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            // 변경할 정보를 DTO에서 꺼내 설정
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
            pstmt.setString(11, dto.getId());
            ok = (pstmt.executeUpdate() > 0);
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            disconnect();
        }
        return ok;
    }

    /** 11) 회원 탈퇴 처리: member 및 관련 테이블에서 삭제 */
    public boolean deleteMember(String id) {
        boolean ok = false;
        String sqlMember = "DELETE FROM member WHERE ID = ?";
        String sqlImage  = "DELETE FROM memberimage WHERE ID = ?";
        // ※ memberimage 테이블은 현재 사용되지 않으므로 이 SQL은 실행되지 않을 수 있음
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sqlMember);
            pstmt.setString(1, id);
            int deleted1 = pstmt.executeUpdate();
            pstmt.close();
            // 참고: 실제 프로필 이미지는 member.profile_img로 관리되므로 memberimage는 미사용
            pstmt = conn.prepareStatement(sqlImage);
            pstmt.setString(1, id);
            int deleted2 = pstmt.executeUpdate();
            ok = (deleted1 > 0); // 회원 테이블 삭제 성공을 성공 기준으로 함
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            disconnect();
        }
        return ok;
    }

    /** 12) 승인 대기 회원 목록 조회 (관리자용) */
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

    /** 13) 회원 승인 상태 변경 (승인 또는 반려 처리) */
    public boolean updateApprovalStatus(String id, String status) {
        boolean success = false;
        String sql = "UPDATE member SET APPROVAL_STATUS = ? WHERE id = ?";
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, status); // 'Y' 또는 'N' 등의 상태값
            pstmt.setString(2, id);
            success = (pstmt.executeUpdate() > 0);
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            disconnect();
        }
        return success;
    }

    /** 14) 전체 회원 목록 조회 (관리자용) */
    public List<UserDTO> getAllUsers() {
        List<UserDTO> list = new ArrayList<>();
        String sql = "SELECT * FROM member";
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                UserDTO dto = new UserDTO();
                dto.setId(rs.getString("ID"));
                dto.setName(rs.getString("NAME"));
                dto.setGender(rs.getInt("GENDER"));
                dto.setJob(rs.getInt("JOB"));
                dto.setStatus(rs.getString("STATUS")); // 탈퇴나 차단 상태 (NULL이면 정상)
                list.add(dto);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /** 15) 회원 차단 처리 (status 필드를 'blocked'로 설정) */
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

    /** 16) 회원 차단 해제 (status 필드를 NULL로 되돌림) */
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
