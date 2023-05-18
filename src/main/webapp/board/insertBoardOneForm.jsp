<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.util.*"%>
<%@ page import = "java.net.*"%>
<%@ page import = "vo.*"%>     
<%
	//다른 페이지에서 넘어온 메시지 있으면 저장
	String msg = "";
	if(request.getParameter("msg") != null){
		msg = request.getParameter("msg");
	}
	
	//세션 유효성 검사_ 로그인 전이면
	if(session.getAttribute("loginMemberId") == null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	
	//아이디 확인
	String loginMemberId = (String)session.getAttribute("loginMemberId");
	
	System.out.println(loginMemberId + "insertBoardOneForm loginMemberId");
	
	//세션에 저장된 localList불러옴
	// 유형 검사없이 원시 유형을 매개 변수화 된 유형으로 캐스팅 할 때 [Unchecked Cast] 경고 표시
	@SuppressWarnings("unchecked")
	ArrayList<String> localList = (ArrayList<String>)session.getAttribute("localList");
	
	System.out.println(localList + " : localList");
%>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert Board Form</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
	<div>
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
	</div>
	<br>
	<h2>게시글 작성</h2>
	<form action="<%=request.getContextPath()%>/board/insertBoardOneAction.jsp" method="post">
		<table class="table table-hover">
			<tr>
				<th>지역명</th>
				<td>
					<select name="localName">
							<option value="">지역선택</option>
						<%
							for(String local : localList){
						%>
							<option>
								<%=local%>
							</option>
						<%
							}
						%>
					</select>
				</td>
			</tr>
			<tr>
				<th>제목</th>
				<td>
					<input type="text" name="boardTitle">
				</td>
			</tr>
			<tr>
				<th>내용</th>
				<td>
					<input type="text" name="boardContent">
				</td>
			</tr>
			<tr>
				<th>작성자</th>
				<td>
					<input type="text" name="loginMemberId" value="<%=loginMemberId%>" readonly="readonly">
				</td>
			</tr>
		</table>
		<div>
			<%=msg%>
			<br>
			<input type="submit" class="btn btn-outline-secondary" value="저장">
		</div>
	</form>
</body>
</html>