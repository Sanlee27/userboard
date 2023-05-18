<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.util.*"%>
<%@ page import="java.net.*" %>
<%@ page import = "vo.*"%> 
<%
	request.setCharacterEncoding("utf-8");
	
	String msg = null;
	
	//세션 유효성 검사_ 로그인 전이면
	if(session.getAttribute("loginMemberId") == null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	
	//요청값 유효성 검사
	if(request.getParameter("localName") == null	// 지역명이 null이거나 공백이면
		|| request.getParameter("localName").equals("")) {
			response.sendRedirect(request.getContextPath()+"/board/selectLocal.jsp");
			return;
	}
	
	String localName = request.getParameter("localName");
	String newLocalName = request.getParameter("newLocalName");
	
	System.out.println(localName + " : updateLocalAction localName");
	System.out.println(newLocalName + " : updateLocalAction newLocalName");
	
	if(newLocalName == null	// 새 지역명이 null이거나 공백이면
		|| newLocalName.equals("")
		|| newLocalName.equals(localName)) {
				msg = URLEncoder.encode("지역이름을 확인하세요.", "UTF-8");
				String requestLocal = URLEncoder.encode(localName, "utf-8");
				response.sendRedirect(request.getContextPath()+"/board/updateLocalForm.jsp?localName="+requestLocal+"&msg="+msg);
				return;
		}
	
	// DB
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	
	Class.forName(driver);
	Connection conn = null;
	
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	// 수정 전 게시물 확인 쿼리
	PreparedStatement checkLocalStmt = null;
	ResultSet checkLocalRs = null;
	
	String checkLocalSql = "SELECT COUNT(*) cnt FROM board WHERE local_name = ?";
	checkLocalStmt = conn.prepareStatement(checkLocalSql);
	checkLocalStmt.setString(1, localName);
	
	System.out.println(checkLocalStmt + " : updateLocalForm checkLocalStmt");
	
	checkLocalRs = checkLocalStmt.executeQuery();
	
	int cnt = 0;
	if(checkLocalRs.next()){
		cnt = checkLocalRs.getInt("cnt");
	}
	System.out.println(cnt + "<-- cnt");
	
	// 게시물 남아있으면 다시 목록으로
	if(cnt != 0){
		msg = URLEncoder.encode("게시물이 존재합니다.","UTF-8");
		String requestLocal = URLEncoder.encode(localName, "utf-8");
		response.sendRedirect(request.getContextPath()+"/board/updateLocalForm.jsp?localName="+requestLocal+"&msg="+msg);
		return;
	}
	
	// 수정 쿼리
	PreparedStatement updateLocalStmt = null;
	
	String updateLocalSql = "UPDATE local SET local_name = ?, updatedate = NOW() where local_name = ?";
	updateLocalStmt = conn.prepareStatement(updateLocalSql);
	updateLocalStmt.setString(1, newLocalName);
	updateLocalStmt.setString(2, localName);
	
	System.out.println(updateLocalStmt + " : updateLocalAction updateLocalStmt");
	
	int updateLocalRow = 0;
	updateLocalRow = updateLocalStmt.executeUpdate();
	
	if(updateLocalRow == 1){
		System.out.println(updateLocalRow + " : updateLocalAction updateLocalRow > 수정완료");
		response.sendRedirect(request.getContextPath()+"/board/selectLocal.jsp");
	} else {
		System.out.println(updateLocalRow + " : updateLocalAction updateLocalRow > 수정실패");
		msg = URLEncoder.encode("수정실패","UTF-8");
		response.sendRedirect(request.getContextPath()+"/board/updateLocalForm.jsp?&msg="+msg);
	}
	
%>

