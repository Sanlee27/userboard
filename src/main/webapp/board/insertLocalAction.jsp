<%@page import="java.net.URLEncoder"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.util.*"%>
<%@ page import = "vo.*"%> 
<%
	request.setCharacterEncoding("UTF-8");	

	//세션 유효성 검사_ 로그인 전이면
	if(session.getAttribute("loginMemberId") == null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	
	//요청값 유효성 검사
	String msg = null;
	
	if(request.getParameter("localName") == null	// 지역명이 null이거나 공백이면
		|| request.getParameter("localName").equals("")) {
			msg = URLEncoder.encode("지역이름을 입력하세요.", "UTF-8");
			response.sendRedirect(request.getContextPath()+"/board/insertLocalForm.jsp?msg="+msg);
			return;
	}
	
	String localName = request.getParameter("localName");
	System.out.println(localName + " : insertLocalAction localName");
	
	
	// DB
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	
	Class.forName(driver);
	Connection conn = null;
	
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	// 추가 전 지역명 확인 쿼리
	PreparedStatement checkLocalStmt = null;
	ResultSet checkLocalRs = null;
	
	String checkLocalSql = "SELECT COUNT(local_name) cnt FROM local WHERE local_name = ?";
	checkLocalStmt = conn.prepareStatement(checkLocalSql);
	checkLocalStmt.setString(1, localName);
	
	System.out.println(checkLocalStmt + " : updateLocalForm checkLocalStmt");
	
	checkLocalRs = checkLocalStmt.executeQuery();
	
	int cnt = 0;
	if(checkLocalRs.next()){
		cnt = checkLocalRs.getInt("cnt");
	}
	
	// 지역명 남아있으면 다시 목록으로
	if(cnt != 0){
		msg = URLEncoder.encode("이미 존재하는 지역명 입니다.","UTF-8");
		response.sendRedirect(request.getContextPath()+"/board/insertLocalForm.jsp?msg="+msg);
		return;
	}
	// 지역명 추가 쿼리
	PreparedStatement insertStmt = null;
	String insertSql = "INSERT INTO local(local_name, createdate, updatedate) VALUES (?, NOW(), NOW());";
	insertStmt = conn.prepareStatement(insertSql);	
	insertStmt.setString(1, localName);
	
	int insertRow = 0;
	
	insertRow = insertStmt.executeUpdate();
	
	if(insertRow == 1){
		System.out.println(insertRow + " : 지역명 추가 성공");
	} else {
		System.out.println(insertRow + " : 지역명 추가 실패");
		msg = URLEncoder.encode("지역명 추가 실패","UTF-8");
		response.sendRedirect(request.getContextPath()+"/board/insertLocalForm.jsp?msg="+msg);
		return;
	}
	
	response.sendRedirect(request.getContextPath()+"/board/selectLocal.jsp");
%>
