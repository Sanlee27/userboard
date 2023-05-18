<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.util.*"%>
<%@ page import = "vo.*"%>   
<%
	//유효성 검사
	if(session.getAttribute("loginMemberId") == null){ // 로그인전
		response.sendRedirect(request.getContextPath()+"/home.jsp");
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
	PreparedStatement localStmt = null;
	ResultSet localRs = null;
	
	String localSql = "SELECT local_name localName, createdate, updatedate FROM local";
	localStmt = conn.prepareStatement(localSql);
	
	System.out.println(localStmt + " : selectLocal localStmt");
	
	localRs = localStmt.executeQuery();
	
	// 여러개 arraylist
	ArrayList <Local> localList = new ArrayList <Local>();
	while(localRs.next()){
		Local l = new Local();
		l.setLocalName(localRs.getString("localName"));
		l.setCreatedate(localRs.getString("createdate"));
		l.setUpdatedate(localRs.getString("updatedate"));
		localList.add(l);
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>select Local</title>
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
	<h2>지역 목록</h2>
	<table class="table table-hover">
		<tr>
			<th>지역명</th>
			<th>생성일자</th>
			<th>변경일자</th>
			<th>수정</th>
			<th>삭제</th>
		</tr>
		<%
			for(Local l : localList){
		%>
				<tr>
					<td><%=l.getLocalName()%></td>
					<td><%=l.getCreatedate()%></td>
					<td><%=l.getUpdatedate()%></td>
					<td><a type="button" class="btn btn-outline-secondary" href = "<%=request.getContextPath()%>/board/updateLocalForm.jsp?localName=<%=l.getLocalName()%>">수정</a></td>
					<td><a type="button" class="btn btn-outline-secondary" href = "<%=request.getContextPath()%>/board/deleteLocalForm.jsp?localName=<%=l.getLocalName()%>">삭제</a></td>
				</tr>
		<%
			}
		%>
	</table>
	<a type="button" class="btn btn-outline-secondary" href = "<%=request.getContextPath()%>/board/insertLocalForm.jsp" >지역 추가</a>
	<div>
	<br>
		<!-- include 페이지 : Copyright &copy; 구디아카데미 -->
		<jsp:include page="/inc/copyright.jsp"></jsp:include>
	</div>	
</body>
</html>