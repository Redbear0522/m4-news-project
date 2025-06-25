<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="emotion.EmotionDAO, emotion.EmotionDTO" %>
<%
    request.setCharacterEncoding("UTF-8");

int commentId    = Integer.parseInt(request.getParameter("comment_id"));
String emotion   = request.getParameter("emotion_type");
String userId    = (String) session.getAttribute("sid"); // 로그인 세션
int newsNum      = Integer.parseInt(request.getParameter("news_num"));

EmotionDTO dto = new EmotionDTO();
dto.setCommentId(commentId);
dto.setEmotionType(emotion);
dto.setUserId(userId);

EmotionDAO dao = new EmotionDAO();
dao.insertEmotion(dto);

response.sendRedirect("view.jsp?num=" + newsNum);
%>
