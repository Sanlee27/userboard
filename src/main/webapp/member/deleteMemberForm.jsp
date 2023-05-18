<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.util.*"%>
<%@ page import = "vo.*"%>   
<%
	//유효성 검사 _ 로그인전이면 홈으로 돌아가게; 페이지 표시x
	if(session.getAttribute("loginMemberId") == null){ 
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;		
	}
	
	String loginMemberId = (String)session.getAttribute("loginMemberId");
	
	System.out.println(loginMemberId + " : deleteMemberForm loginMemeberId");
	
	String msg = null;
	if(request.getParameter("msg")!= null){
		msg = request.getParameter("msg");
	}
%>		
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>delete Membership</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- Latest compiled JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
	<div>
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
	</div>
	<br>
	<h2>회원 탈퇴</h2>
	<div>
	<%
		if(msg !=null){
	%>
			<%=msg%>
	<%
		}
	%>
	</div>
	<form action="<%=request.getContextPath()%>/member/deleteMemberAction.jsp" method="post">
		<table class="table table-hover">
			<tr>
				<th>회원ID</th>
				<td><%=loginMemberId%></td>
			</tr>
			<tr>
				<th>회원PW</th>
				<td>
					<input type="password" name="memberPw" placeholder="비밀번호를 입력하세요"> 
				</td>
			</tr>
		</table>
		<div>
			<input class="btn btn-outline-secondary" type="submit" value="탈퇴">
		</div>
	</form>
	<br>
	<div>
		<!-- include 페이지 : Copyright &copy; 구디아카데미 -->
		<jsp:include page="/inc/copyright.jsp"></jsp:include>
	</div>
</body>
</html>