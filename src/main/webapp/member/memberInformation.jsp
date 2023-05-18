<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.util.*"%>
<%@ page import = "vo.*"%>
<%
	// 유효성 검사
	if(session.getAttribute("loginMemberId") == null){ // 로그인전
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;		
	}
	
	// 로그인아이디 변수저장
	String loginMemberId = (String)session.getAttribute("loginMemberId");
	
	System.out.println(loginMemberId + " : memberInformation loginMemeberId");
	
	// DB
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	// 쿼리
	PreparedStatement memberInfoStmt = null;
	ResultSet memberInfoRs = null;
	
	String memberInfoSql = "SELECT member_id memberId, createdate, updatedate FROM member WHERE member_id = ?";
	memberInfoStmt = conn.prepareStatement(memberInfoSql);
	memberInfoStmt.setString(1, loginMemberId);
	
	System.out.println(memberInfoStmt + " : memberInformation memberInfoStmt");
	
	// sql 실행값 반환
	memberInfoRs = memberInfoStmt.executeQuery();
	Member info = null;
	
	if(memberInfoRs.next()){
		info = new Member();
		info.setMemberId(memberInfoRs.getString("memberId"));
		info.setCreatedate(memberInfoRs.getString("createdate"));
		info.setUpdatedate(memberInfoRs.getString("updatedate"));
	}
	
%>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>member Information.jsp</title>
<!-- Latest compiled and minified CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- Latest compiled JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
	<div>
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
	</div>
	<br>
	<h2>회원 정보</h2>
	<table class="table table-hover">
		<tr>
			<th>회원 ID</th>
			<td><%=loginMemberId%></td>
		</tr>
		<tr>
			<th>생성 일자</th>
			<td><%=info.getCreatedate()%></td>
		</tr>
		<tr>
			<th>변경 일자</th>
			<td><%=info.getUpdatedate()%></td>
		</tr>
	</table>
	<div>
		<a type="button" class="btn btn-outline-secondary" href = <%=request.getContextPath()+"/member/updatePasswordForm.jsp"%>>비밀번호 수정</a>
		<a type="button" class="btn btn-outline-secondary" href = <%=request.getContextPath()+"/member/deleteMemberForm.jsp"%>>회원 탈퇴</a>
	</div>
	<br>
	<div>
		<!-- include 페이지 : Copyright &copy; 구디아카데미 -->
		<jsp:include page="/inc/copyright.jsp"></jsp:include>
	</div>
</body>
</html>