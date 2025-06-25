<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%
    request.setCharacterEncoding("UTF-8");

    String newsId = request.getParameter("news_id");
    String userId = request.getParameter("user_id");
    String emotionType = request.getParameter("emotion_type");

    Connection conn = null;
    PreparedStatement pstmt = null;

    String dbUrl = "jdbc:oracle:thin:@58.73.200.225:1521:orcl"; 
    String dbUser = "team01";  
    String dbPass = "1234";   

    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        conn = DriverManager.getConnection(dbUrl, dbUser, dbPass);

        String sql = "INSERT INTO news_emotion (news_id, user_id, emotion_type) VALUES (?, ?, ?)";
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, Integer.parseInt(newsId));
        pstmt.setString(2, userId);
        pstmt.setString(3, emotionType);

        pstmt.executeUpdate();
%>
        <script>
            alert("감정이 등록되었습니다!");
            history.back(); // 이전 페이지로 이동
        </script>
<%
    } catch (Exception e) {
        out.println("감정 등록 중 오류: " + e.getMessage());
        %>
        <script>
        	alert("오류가 발생했습니다.")
        	history.back();
        </script>
        <%
    } finally {
        if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
        if (conn != null) try { conn.close(); } catch (Exception e) {}
    }
%>
