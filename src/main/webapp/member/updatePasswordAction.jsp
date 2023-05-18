<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.net.*"%>
<%@ page import = "vo.*" %>
<%
	request.setCharacterEncoding("utf-8");

	// 세션 유효성 검사_ 로그인 전이면
	if(session.getAttribute("loginMemberId") == null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	
	// 아이디 변수저장
	String loginMemberId = (String)session.getAttribute("loginMemberId");
	
	System.out.println(loginMemberId + " : updatePasswordForm loginMemeberId");
	
	// 요청 유효성 검사
	String memberPw = request.getParameter("memberPw");
	String newMemberPw = request.getParameter("newMemberPw");
	String newMemberPw2 = request.getParameter("newMemberPw2");
	
	System.out.println(memberPw + " << updatePasswordAction memberPw");
	System.out.println(newMemberPw + " << updatePasswordAction newMemberPw");
	System.out.println(newMemberPw2 + " << updatePasswordAction newMemberPw2");
	
	// 비밀번호 확인메시지
	String msg = null;
	
	// 각각의 경우의수
	if(memberPw == null || memberPw.equals("")){
		msg = URLEncoder.encode("이전 비밀번호를 확인해주세요.","UTF-8");
	} else if(newMemberPw == null || newMemberPw.equals("")){
		msg = URLEncoder.encode("새로운 비밀번호를 확인해주세요.","UTF-8");
	} else if(newMemberPw2 == null || newMemberPw2.equals("")){
		msg = URLEncoder.encode("새로운 비밀번호 재입력을 확인해주세요.","UTF-8");
	} else if(memberPw.equals(newMemberPw)){
		msg = URLEncoder.encode("현재와 다른 비밀번호를 입력하세요.","UTF-8");
	} else if(!newMemberPw.equals(newMemberPw2)){
		msg = URLEncoder.encode("새로운 비밀번호가 일치하지 않습니다.","UTF-8");
	}
	
	// 메세지가 표시될경우 null 이 아닐경우 메세지와 함께 뿌려줌
	if(msg != null){
		response.sendRedirect(request.getContextPath()+"/member/updatePasswordForm.jsp?msg="+ msg);
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
	PreparedStatement updatePwStmt = null;
	int updatePwRow = 0;
	
	String updatePwSql = "UPDATE member SET member_pw = PASSWORD(?), updatedate = NOW() WHERE member_id = ? AND member_pw = PASSWORD(?)"; 
	updatePwStmt = conn.prepareStatement(updatePwSql);
	updatePwStmt.setString(1, newMemberPw);
	updatePwStmt.setString(2, loginMemberId);
	updatePwStmt.setString(3, memberPw);
	
	updatePwRow = updatePwStmt.executeUpdate();
	
	System.out.println(updatePwRow + " : updatePasswordAction updatePwRow");
		
	if(updatePwRow == 1){ // 수정완
		System.out.println(updatePwRow + " : updatePasswordAction updatePwRow > 성공");
		msg = URLEncoder.encode("수정 완료","UTF-8");
		response.sendRedirect(request.getContextPath()+"/member/updatePasswordForm.jsp?msg="+ msg);
	} else { // 수정실패
		System.out.println(updatePwRow + " : updatePasswordAction updatePwRow > 실패");
		msg = URLEncoder.encode("다시 확인해주세요","UTF-8");
		response.sendRedirect(request.getContextPath()+"/member/updatePasswordForm.jsp?msg="+ msg);
	}
%>