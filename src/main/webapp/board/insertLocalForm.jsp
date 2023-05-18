<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.util.*"%>
<%@ page import = "vo.*"%> 
<%
	//세션 유효성 검사_ 로그인 전이면
	if(session.getAttribute("loginMemberId") == null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}

	//이전 페이지에서 넘어온 메시지가 있으면 저장
	String msg = "";
	if(request.getParameter("msg") != null
		&& !request.getParameter("msg").equals("")){
			msg = request.getParameter("msg");
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>insert Local Form</title>
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
	<h2>지역 추가</h2>
	<form action="<%=request.getContextPath()%>/board/insertLocalAction.jsp" method="post">
		<table class="table table-hover">
			<tr>
				<th>신규 지역명</th>
				<td>
					<input type="text" name="localName">
				</td>
			</tr>
		</table>
		<%=msg%>
		<div>
		<br>
			<input type="submit" class="btn btn-outline-secondary" value="저장">
			<a type="button" class="btn btn-outline-secondary" href = "<%=request.getContextPath()%>/board/selectLocal.jsp">목록으로</a>
		</div>
	</form>
</body>
</html>