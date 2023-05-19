<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.util.*"%>
<%@ page import="java.net.*" %>
<%@ page import = "vo.*"%>    
<%
    response.setCharacterEncoding("utf-8");
    	
    	//유효성 검사
    	if(session.getAttribute("loginMemberId") == null){ // 로그인전
    		response.sendRedirect(request.getContextPath()+"/home.jsp");
    		return;		
    	}

    	String loginMemberId = (String)session.getAttribute("loginMemberId");
    	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
    	
    	System.out.println(loginMemberId + " : deleteBoardOneForm loginMemeberId");
    	System.out.println(boardNo + " : deleteBoardOneForm boardNo");
    	
    	//DB
    	String driver = "org.mariadb.jdbc.Driver";
    	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
    	String dbuser = "root";
    	String dbpw = "java1234";
    	
    	Class.forName(driver);
    	Connection conn = null;
    	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
    	
    	PreparedStatement boardStmt = null;
    	ResultSet boardRs = null;
    	
    	String boardSql = "SELECT board_no boardNo, local_name localName, board_title boardTitle, board_content boardContent, member_id memberId, createdate, updatedate FROM board WHERE board_no = ?";
    	boardStmt = conn.prepareStatement(boardSql);
    	boardStmt.setInt(1, boardNo);
    	
    	boardRs = boardStmt.executeQuery();
    	
    	System.out.println(boardStmt + " : deleteBoardOneForm boardStmt");
    	
    	Comment comment = null;
    	Board board = null;
    	if(boardRs.next()){
    		board = new Board();
    		board.setBoardNo(boardRs.getInt("boardNo"));
    		board.setLocalName(boardRs.getString("localName"));
    		board.setBoardTitle(boardRs.getString("boardTitle"));
    		board.setBoardContent(boardRs.getString("boardContent"));
    		board.setMemberId(boardRs.getString("memberId"));
    		board.setCreatedate(boardRs.getString("createdate"));
    		board.setUpdatedate(boardRs.getString("updatedate"));
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
<title>delete BoardOne Form</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
	<div>
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
	</div>
	<br>
	<h2>상세정보 삭제</h2>
	<%
		// ========= 로그인 당사자만 삭제 가능(일치할때만 폼표시) =========	
		if(loginMemberId.equals(board.getMemberId())){ 
	%>
			<form action="<%=request.getContextPath()%>/board/deleteBoardOneAction.jsp" method="post">
				<table class="table table-hover">
					<tr>
						<th>게시번호</th>
						<td>
							<input type="hidden" name="boardNo" value="<%=board.getBoardNo()%>">
							<%=board.getBoardNo()%>
						</td>
					</tr>
					<tr>
						<th>지역명</th>
						<td><%=board.getLocalName()%></td>
					</tr>
					<tr>
						<th>제목</th>
						<td><%=board.getBoardTitle()%></td>
					</tr>
					<tr>
						<th>내용</th>
						<td><%=board.getBoardContent()%></td>
					</tr>
					<tr>
						<th>작성자</th>
						<td><%=board.getMemberId()%></td>
					</tr>
					<tr>
						<th>작성일자</th>
						<td><%=board.getCreatedate()%></td>
					</tr>
					<tr>
						<th>수정일자</th>
						<td><%=board.getUpdatedate()%></td>
					</tr>
					<tr>
						<td colspan="2">정말 삭제하시겠습니까?</td>
					</tr>
				</table>
				<%
					if(msg != null){
				%>
						<%=msg%>
				<%
					}
				%>
				<div>
					<input type="submit" class="btn btn-outline-secondary" value="삭제">
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