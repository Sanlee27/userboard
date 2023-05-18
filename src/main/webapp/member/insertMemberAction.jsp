<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.util.*"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.net.*"%>
<%@ page import = "vo.*"%>
<%
	request.setCharacterEncoding("UTF-8");

	String memberId = request.getParameter("memberId");
	String memberPw = request.getParameter("memberPw");
	
	System.out.println(memberId + " : insertMemberAction memberId");
	System.out.println(memberPw + " : insertMemberAction memberPw");
	
	// 세션 유효성 검사
	if(session.getAttribute("loginMemberId") != null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	
	String msg = null;

	// 요청값 유효성 검사
	if(memberId.equals("") || memberId == null
		|| memberPw.equals("") || memberPw == null){
			// id pw 가 null/공백이면 가입폼으로 보냄
			msg = URLEncoder.encode("아이디 또는 비밀번호를 입력하세요.","UTF-8");
			response.sendRedirect(request.getContextPath()+"/member/insertMemberForm.jsp?msg="+msg);
			System.out.println("공백 발생");
			return;
	}
	
	// 요청값 묶어서 저장
	Member paramMember = new Member();
	paramMember.setMemberId(memberId);
	paramMember.setMemberPw(memberPw);

	System.out.println(paramMember.getMemberId() + " : insertMemberAction paramMember.memberId");
	System.out.println(paramMember.getMemberPw() + " : insertMemberAction paramMember.memberPw");

	// DB
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	
	Class.forName(driver);
	Connection conn = null;
	PreparedStatement stmt = null;
	PreparedStatement stmt2 = null;
	ResultSet rs = null;
	
	
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	// 동적 쿼리 1) 가입정보 입력
	String sql = "INSERT INTO member(member_id, member_pw, createdate, updatedate) VALUES(?, PASSWORD(?), NOW(), NOW())";
	stmt = conn.prepareStatement(sql);
	stmt.setString(1, paramMember.getMemberId());
	stmt.setString(2, paramMember.getMemberPw());
	
	System.out.println(stmt + " : insertMemberAction stmt");

	// 2) 중복아이디
	String sql2 = "SELECT member_id FROM member WHERE member_id = ?";
	stmt2 = conn.prepareStatement(sql2);
	stmt2.setString(1, paramMember.getMemberId());
	
	System.out.println(stmt2 + " : insertMemberAction stmt2");
	
	rs = stmt2.executeQuery();
	
	// 중복아이디 존재
	if(rs.next()){
		msg = URLEncoder.encode("ID가 이미 존재합니다.","UTF-8"); // msg표시된 가입페이지로 리다이렉션
		response.sendRedirect(request.getContextPath()+"/member/insertMemberForm.jsp?msg="+msg);
		return;
	}
	
	int row = stmt.executeUpdate();
	
	System.out.println(row + " : insertMemberAction row");
	
	if(row == 1){ // 가입성공시
		System.out.println("가입완료");
		response.sendRedirect(request.getContextPath()+"/home.jsp");
	} else {
		System.out.println("가입실패");
		msg = URLEncoder.encode("가입실패. 확인 바랍니다.","UTF-8");
		response.sendRedirect(request.getContextPath()+"/member/insertMemberForm.jsp?msg="+msg);
	}
%>