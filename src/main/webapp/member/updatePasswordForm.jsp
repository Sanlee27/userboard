<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.util.*"%>
<%@ page import = "vo.*"%> 
<%
	//세션 유효성 검사_ 로그인전이면 홈으로 보냄
	if(session.getAttribute("loginMemberId") == null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	
	// 아이디 변수저장
	String loginMemberId = (String)session.getAttribute("loginMemberId");
	
	System.out.println(loginMemberId + " : updatePasswordForm loginMemeberId");
	
	// 중복메시지
	String msg = null;
	if(request.getParameter("msg")!= null){
		msg = request.getParameter("msg");
	}
	
	//DB
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	
	Class.forName(driver);
	Connection conn = null;
	
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	// 쿼리	
	PreparedStatement updatePwStmt = null;
	ResultSet updatePwRs = null;

	String updatePwSql = "SELECT member_id memberId, updatedate FROM member WHERE member_id = ?";
	updatePwStmt = conn.prepareStatement(updatePwSql);
	updatePwStmt.setString(1, loginMemberId);
	
	System.out.println(updatePwStmt + " : updatePasswordForm updatePwStmt");
	
	updatePwRs = updatePwStmt.executeQuery();
	
	Member m = new Member();
	if(updatePwRs.next()){
		m.setMemberId(updatePwRs.getString("memberId"));
		m.setUpdatedate(updatePwRs.getString("updatedate"));	
	}
%>   
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>updatePassword</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- Latest compiled JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
	<div>
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
	</div>
	<br>
	<h2>비밀번호 변경</h2>
	<div>
	<%
		if(msg !=null){
	%>
			<%=msg%>
	<%
		}
	%>
	</div>
	<form action="<%=request.getContextPath()%>/member/updatePasswordAction.jsp" method="post">
		<input type="hidden" name="memberId" value="<%=loginMemberId%>">
		<table class="table table-hover">
			<tr>
				<th>이전 비밀번호</th>
				<td>
					<input type="password" name="memberPw">
				</td>
			</tr>
			<tr>
				<th>새로운 비밀번호</th>
				<td>
					<input type="password" name="newMemberPw">
				</td>
			</tr>
			<tr>
				<th>새로운 비밀번호 확인</th>
				<td>
					<input type="password" name="newMemberPw2">
				</td>
			</tr>
		</table>
		<div>
			<input type="submit" class="btn btn-outline-secondary" value="저장">
		</div>
	</form>
	<br>
	<div>
		<!-- include 페이지 : copyright &copy; 구디아카데미 -->
		<jsp:include page="/inc/copyright.jsp"></jsp:include>
	</div>
</body>
</html>