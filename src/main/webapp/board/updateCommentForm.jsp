<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.util.*"%>
<%@ page import = "java.net.*"%>
<%@ page import = "vo.*"%> 
<%
	request.setCharacterEncoding("UTF-8");
	
	// 비로그인시 홈으로
	if(session.getAttribute("loginMemberId") == null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}

	//boardNo_번호
	if(request.getParameter("boardNo") == null 
		|| request.getParameter("boardNo").equals("")){
			response.sendRedirect(request.getContextPath()+"/home.jsp");
			return;
	}
	
	String loginMemberId = (String)session.getAttribute("loginMemberId");
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	int commentNo = Integer.parseInt(request.getParameter("commentNo"));
	
	System.out.println(boardNo + " : updateCommentForm boardNo");
	System.out.println(commentNo + " : updateCommentForm commentNo");
	
	//DB
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	PreparedStatement commentStmt = null;
	ResultSet commentRs = null;
	
	String commentSql = "SELECT board_no boardNo, comment_no commentNo, member_id memberId, comment_content commentContent, createdate, updatedate FROM comment WHERE board_no = ? AND comment_no = ?";
	commentStmt = conn.prepareStatement(commentSql);
	commentStmt.setInt(1, boardNo);
	commentStmt.setInt(2, commentNo);
	
	commentRs = commentStmt.executeQuery();
	
	System.out.println(commentStmt + " : updateCommentForm commentStmt");
	
	Comment comment = null;
	if(commentRs.next()){
		comment = new Comment();
		comment.setBoardNo(commentRs.getInt("boardNo"));
		comment.setCommentNo(commentRs.getInt("commentNo"));
		comment.setMemberId(commentRs.getString("memberId"));
		comment.setCommentContent(commentRs.getString("commentContent"));
		comment.setCreatedate(commentRs.getString("createdate"));
		comment.setUpdatedate(commentRs.getString("updatedate"));
	}
	
	String msg = null;
	
	if(request.getParameter("msg") != null){
		msg = request.getParameter("msg");
	}
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>updateCommentForm</title>
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
	<h2>댓글 수정</h2>
	<%
		// ========= 로그인 당사자만 삭제 가능(일치할때만 폼표시) =========
		if(loginMemberId.equals(comment.getMemberId())){
	%>
			<form action="<%=request.getContextPath()%>/board/updateCommentAction.jsp" method="post">
				<table class="table table-hover">
					<tr>
						<th>작성자</th>
						<td>	
							<input type="hidden" name="boardNo" value="<%=comment.getBoardNo()%>">
							<input type="hidden" name="commentNo" value="<%=comment.getCommentNo()%>">
							<%=comment.getMemberId()%>
						</td>
					</tr>
					<tr>
						<th>댓글 내용</th>
						<td>
							<textarea rows ="2" cols="80" name="commentContent"><%=comment.getCommentContent()%></textarea>
						</td>
					</tr>
					<tr>
						<th>작성일자</th>
						<td><%=comment.getCreatedate()%></td>
					</tr>
					<tr>
						<th>수정일자</th>
						<td><%=comment .getUpdatedate()%></td>
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
				<div>
					<input type="submit" class="btn btn-outline-secondary" value="수정">
					<a type="button" class="btn btn-outline-secondary" href = "<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=boardNo%>">목록으로</a>
				</div>
			</form>
	<%
		} else {
	%>
			<div>
				<a>삭제 권한이 없습니다.</a><br>
				<a type="button" class="btn btn-outline-secondary" href = "<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=boardNo%>">목록으로</a>
			</div>
	<%
		}
	%>
	<br>
	<div>
		<!-- include 페이지 : Copyright &copy; 구디아카데미 -->
		<jsp:include page="/inc/copyright.jsp"></jsp:include>
	</div>
</body>
</html>