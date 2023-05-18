<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.util.*"%>
<%@page import="java.net.*"%>
<%@ page import = "vo.*"%> 
<%
	response.setCharacterEncoding("UFT-8");
	
	//유효성 검사
	if(session.getAttribute("loginMemberId") == null){ // 로그인전
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;		
	}
	
	//요청값 유효성 검사
	if(request.getParameter("localName") == null	// 지역명이 null이거나 공백이면
		|| request.getParameter("localName").equals("")) {
			response.sendRedirect(request.getContextPath()+"/board/selectLocal.jsp");
			return;
	}
	
	// 중복 메세지
	String msg = null;
	if(request.getParameter("msg") != null){
		msg = request.getParameter("msg");
	}
	
	String localName = request.getParameter("localName");
	System.out.println(localName + " : localName");
	
	// DB
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	
	Class.forName(driver);
	Connection conn = null;
	
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	// 삭제 전 게시물 확인 쿼리
	PreparedStatement checkLocalStmt = null;
	ResultSet checkLocalRs = null;
	
	String checkLocalSql = "SELECT COUNT(*) cnt FROM board WHERE local_name = ?";
	checkLocalStmt = conn.prepareStatement(checkLocalSql);
	checkLocalStmt.setString(1, localName);
	
	System.out.println(checkLocalStmt + " : deleteLocalForm checkLocalStmt");
	
	checkLocalRs = checkLocalStmt.executeQuery();
	
	int cnt = 0;
	if(checkLocalRs.next()){
		cnt = checkLocalRs.getInt("cnt");
	}
	
	// 남아있으면 다시 목록으로
	if(cnt != 0){
		msg = URLEncoder.encode("게시물이 존재합니다.","UTF-8");
		localName = URLEncoder.encode(localName, "UTF-8");
		response.sendRedirect(request.getContextPath()+"/board/deleteLocalForm.jsp?localName="+localName+"&msg="+msg);
		return;
	}
	
	// 삭제 쿼리
	String deleteSql = "DELETE FROM local WHERE local_name =?";
	PreparedStatement deleteStmt = conn.prepareStatement(deleteSql);
	deleteStmt.setString(1, localName);
	
	System.out.println(deleteStmt + " : deleteLocalAction deleteStmt");
	
	int deleteRow = deleteStmt.executeUpdate();
	
	if(deleteRow == 1){
		System.out.println(deleteRow + "삭제완료");
		response.sendRedirect(request.getContextPath()+"/board/selectLocal.jsp");
	} else {
		msg = URLEncoder.encode("삭제를 실패했습니다", "UTF-8"); 
		response.sendRedirect(request.getContextPath()+"/board/deleteLocalForm.jsp?msg="+msg);
		System.out.println(deleteRow + "삭제실패");
	}
%>