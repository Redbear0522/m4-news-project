<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="emotion.EmotionDAO, emotion.EmotionDTO" %>
<%
    request.setCharacterEncoding("UTF-8");

    String commentIdStr = request.getParameter("comment_id");
    String articleIdStr = request.getParameter("article_id");
    String userId = request.getParameter("user_id");
    String emotionType = request.getParameter("emotion_type");

    if (commentIdStr == null || articleIdStr == null || userId == null || emotionType == null ||
        commentIdStr.trim().isEmpty() || articleIdStr.trim().isEmpty() || 
        userId.trim().isEmpty() || emotionType.trim().isEmpty()) {
        out.println("<script>alert('잘못된 요청입니다.'); history.back();</script>");
        return;
    }

    int commentId = Integer.parseInt(commentIdStr);
    EmotionDAO dao = new EmotionDAO();

    try {
        // 사용자가 이미 남긴 감정을 조회
        String existingEmotion = dao.getUserEmotionForComment(userId, commentId);

        if (existingEmotion != null) {
            if (existingEmotion.equals(emotionType)) {
                // 같은 감정을 다시 눌렀으면 토글(삭제)
                dao.deleteEmotion(commentId, userId, emotionType);
            } else {
                // 다른 감정을 눌렀으면 알림 후 뒤로가기
                out.println("<script>alert('이미 " + existingEmotion + "를 선택하셨습니다. 다른 감정을 선택하려면 먼저 취소하세요.'); history.back();</script>");
                return;
            }
        } else {
            // 감정이 없으면 새로 추가
            EmotionDTO dto = new EmotionDTO();
            dto.setCommentId(commentId);
            dto.setUserId(userId);
            dto.setEmotionType(emotionType);
            dao.insertEmotion(dto);
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<script>alert('서버 오류가 발생했습니다.'); history.back();</script>");
        return;
    }

    // 조회수 증가 방지 플래그 세션에 설정
    session.setAttribute("skipReadcountIncrease", true);

    // 게시글 상세 페이지로 리다이렉트
    response.sendRedirect(request.getContextPath() + "/article/content.jsp?num=" + articleIdStr);
%>
