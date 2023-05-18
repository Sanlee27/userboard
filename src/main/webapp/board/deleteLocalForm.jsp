<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.util.*"%>
<%@ page import = "vo.*"%> 
<%
	response.setCharacterEncoding("UTF-8");

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
%>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>delete Local</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- Latest compiled JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
	<div>
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
	</div>
	<br>
	
	<h2>지역 삭제</h2>
	<form action="<%=request.getContextPath()%>/board/deleteLocalAction.jsp" method="post">
		<table class="table table-hover">
			<tr>
				<th>삭제대상</th>
				<td><input type="text" name="localName" value="<%=localName%>" readonly="readonly"></td>
			</tr>
		</table>
		<div>
		<%
			if(msg !=null){
		%>
				<%=msg%>
		<%
			}
		%>
		</div>
		<br>
		<input type="submit" class="btn btn-outline-secondary" value="삭제">
		<a type="button" class="btn btn-outline-secondary" href = "<%=request.getContextPath()%>/board/selectLocal.jsp">목록으로</a>
	</form>
	<br>
	<div>
		<!-- include 페이지 : Copyright &copy; 구디아카데미 -->
		<jsp:include page="/inc/copyright.jsp"></jsp:include>
	</div>
</body>
</html>