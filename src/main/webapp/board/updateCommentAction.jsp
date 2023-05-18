<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.util.*"%>
<%@ page import="java.net.*" %>
<%@ page import = "vo.*"%> 
<%
	request.setCharacterEncoding("utf-8");
	
	//세션 유효성 검사_ 로그인 전이면
	if(session.getAttribute("loginMemberId") == null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	
	//boardNo_글번호
	if(request.getParameter("boardNo") == null 
		|| request.getParameter("boardNo").equals("")){
			response.sendRedirect(request.getContextPath()+"/home.jsp");
			return;
	}
	
	//commentNo_댓글번호
	if(request.getParameter("commentNo") == null 
		|| request.getParameter("commentNo").equals("")){
			response.sendRedirect(request.getContextPath()+"/home.jsp");
			return;
	}
	
	// 댓글 빈값 메세지
	String msg = null;
	
	if(request.getParameter("commentContent") == null || request.getParameter("commentContent").equals("")){
		msg = URLEncoder.encode("댓글내용을 확인하세요.","UTF-8");
		response.sendRedirect(request.getContextPath()+"/board/updateCommentForm.jsp?boardNo="+request.getParameter("boardNo")+"&commentNo="+request.getParameter("commentNo")+"&msg="+msg);
		return;
	}
	
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	int commentNo = Integer.parseInt(request.getParameter("commentNo"));
	String commentContent = request.getParameter("commentContent");
	
	System.out.println(boardNo + " : updateCommetnAction boardNo");
	System.out.println(commentNo + " : updateCommetnAction commentNo");
	System.out.println(commentContent + " : updateCommetnAction commentContent");
	
	
	// DB
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	
	Class.forName(driver);
	Connection conn = null;
	
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	// 쿼리
	PreparedStatement updateStmt = null;
	String updateSql = "UPDATE comment SET comment_content = ?, updatedate = NOW() WHERE board_no = ? AND comment_no = ?";
	updateStmt = conn.prepareStatement(updateSql);
	updateStmt.setString(1, commentContent);
	updateStmt.setInt(2, boardNo);
	updateStmt.setInt(3, commentNo);
	
	System.out.println(updateStmt + " : updateCommentAction updateStmt");
	
	int updateRow = 0;
	updateRow = updateStmt.executeUpdate();
	
	if(updateRow == 1){
		System.out.println(updateRow + " : updateCommentAction updateRow > 수정성공");
		response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?boardNo="+boardNo);
	} else {
		System.out.println(updateRow + " : updateCommentAction updateRow > 수정실패");
		msg = URLEncoder.encode("수정실패","UTF-8");
		response.sendRedirect(request.getContextPath()+"/board/updateCommentForm.jsp?boardNo="+boardNo+"&commentNo="+commentNo+"&msg="+msg);
	}
%>