<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.net.*"%>
<%@ page import = "vo.*" %>
<%
	request.setCharacterEncoding("UTF-8");
	
	//유효성 검사 _ 로그인전이면 홈으로 돌아가게; 페이지 표시x
	if(session.getAttribute("loginMemberId") == null){ 
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;		
	}
	
	// 아이디 비밀번호
	String loginMemberId = (String)session.getAttribute("loginMemberId");
	String memberPw = request.getParameter("memberPw");
	
	System.out.println(loginMemberId + " : deleteMemberAction loginMemeberId");
	System.out.println(memberPw + " : deleteMemberAction memberPw");
	
	// 탈퇴시 메세지
	String msg = null;
	
    // 비밀번호 틀리면 탈퇴못하게
	if(memberPw == null || memberPw.equals("")){
		msg = URLEncoder.encode("비밀번호를 확인해주세요.","UTF-8");
		response.sendRedirect(request.getContextPath()+"/member/deleteMemberForm.jsp?msg="+ msg);
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
	
	// 쿼리
	PreparedStatement deleteMemberStmt = null;
	int deleteMemberRow = 0;
	
	String deleteMemberSql = "DELETE FROM member WHERE member_id = ? AND member_pw = PASSWORD(?)";
	deleteMemberStmt = conn.prepareStatement(deleteMemberSql);
	deleteMemberStmt.setString(1, loginMemberId);
	deleteMemberStmt.setString(2, memberPw);
	
	System.out.println(deleteMemberStmt + " : deleteMemberAction deleteMemberStmt");
	
    // 삭제되는 행있어야
	deleteMemberRow = deleteMemberStmt.executeUpdate();
	
	System.out.println(deleteMemberRow + " : deleteMemberAction deleteMemberRow");
	
	if(deleteMemberRow > 0){ // 삭제가 되어도 로그인 상태이기 때문에
		session.invalidate();
		System.out.println(deleteMemberRow + " : deleteMemberAction deleteMemberRow");
		response.sendRedirect(request.getContextPath()+"/home.jsp");
	} else { // 탈퇴실패시
		msg = URLEncoder.encode("비밀번호가 틀립니다.","UTF-8");
		System.out.println(deleteMemberRow + " : deleteMemberAction deleteMemberRow");
		response.sendRedirect(request.getContextPath()+"/member/deleteMemberForm.jsp?msg="+ msg);
	}
	
%>