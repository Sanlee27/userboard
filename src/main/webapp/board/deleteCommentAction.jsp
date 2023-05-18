<%@page import="org.apache.catalina.tribes.group.interceptors.NonBlockingCoordinator.CoordinationMessage"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.util.*"%>
<%@ page import = "java.net.*"%>
<%@ page import = "vo.*"%>   
<%
	request.setCharacterEncoding("UTF-8");
	
	//유효성 검사 _ 로그인전이면 홈으로 돌아가게; 페이지 표시x
	if(session.getAttribute("loginMemberId") == null){ 
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;		
	}
	
	// 아이디 비밀번호
	String loginMemberId = (String)session.getAttribute("loginMemberId");
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	int commentNo = Integer.parseInt(request.getParameter("commentNo"));
	
	System.out.println(loginMemberId + " : deleteCommentAction loginMemeberId");
	System.out.println(boardNo + " : deleteCommentAction boardNo");
	System.out.println(commentNo + " : deleteCommentAction commentNo");
	
	// DB
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	
	Class.forName(driver);
	Connection conn = null;
	
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	// 쿼리
	PreparedStatement deleteCommentStmt = null;
	int deleteCommentRow = 0;
	
	String deleteCommentSql = "DELETE FROM comment WHERE member_id = ? AND comment_no = ?";
	deleteCommentStmt = conn.prepareStatement(deleteCommentSql);
	deleteCommentStmt.setString(1, loginMemberId);
	deleteCommentStmt.setInt(2, commentNo);
	
	System.out.println(deleteCommentStmt + " : deleteCommentAction deleteCommentStmt");
	
	// 삭제실행시
	deleteCommentRow = deleteCommentStmt.executeUpdate();
	
	System.out.println(deleteCommentRow + " : deleteCommentAction deleteCommentRow");
	
	if(deleteCommentRow > 0){
		System.out.println(deleteCommentRow + " : 삭제성공");
		response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?boardNo="+boardNo);
	} else {
		System.out.println(deleteCommentRow + " : 삭제실패");
		response.sendRedirect(request.getContextPath()+"/board/deleteCommentForm.jsp?boardNo="+boardNo+"&commentNo="+commentNo);
	}
%>