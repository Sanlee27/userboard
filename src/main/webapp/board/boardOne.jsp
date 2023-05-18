<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.util.*"%>
<%@ page import = "vo.*"%>
<%
	// 1. 컨트롤러 계층
	if(request.getParameter("boardNo") == null || request.getParameter("boardNo").equals("")){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	
	// 변수
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	
    System.out.println(boardNo + " : boardOne.jsp boardNo");
    
	// 2. 모델 계층
	//DB
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	// 2-1. board one 결과셋_ 상세정보 뽑아온다
	PreparedStatement boardStmt = null;
	ResultSet boardRs = null;
	String boardSql = "SELECT board_no boardNo, local_name, board_title, board_content, member_id, createdate, updatedate FROM board WHERE board_no = ?;";
	boardStmt = conn.prepareStatement(boardSql);
	boardStmt.setInt(1, boardNo);
	
	boardRs = boardStmt.executeQuery(); // row > 1
	
	System.out.println(boardStmt + " : boardOne.jsp boardStmt");
	
	// 상세정보-1개 <-> 댓글 여러개 arraylist
	Board board = null;
	if(boardRs.next()){
		board = new Board();
		board.setBoardNo(boardRs.getInt("boardNo"));
		board.setLocalName(boardRs.getString("local_name"));
		board.setBoardTitle(boardRs.getString("board_title"));
		board.setBoardContent(boardRs.getString("board_content"));
		board.setMemberId(boardRs.getString("member_id"));
		board.setCreatedate(boardRs.getString("createdate"));
		board.setUpdatedate(boardRs.getString("updatedate"));
	}
	
	
	// 2-2. comment list 결과셋_댓글
	
	/*  SELECT comment_no, board_no, comment_content
		FROM comment
		WHERE board_no = ?
		LIMIT ?,?; */
		
	// ================== 페이지_댓글 ===================
	// 현재 페이지
	int currentPage = 1;
	if(request.getParameter("currentPage") != null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	// 페이지 당 보여줄 댓글 개수
	int rowPerPage = 5;
	if(request.getParameter("rowPerPage") != null) {
	      rowPerPage = Integer.parseInt(request.getParameter("rowPerPage"));
	}
	
	// 총 댓글 수
	int totalRow = 0; 
	String totalRowSql = null;
	PreparedStatement totalRowStmt = null;
	ResultSet totalRowRs = null; 
	
	totalRowSql = "SELECT COUNT(*) FROM comment WHERE board_no = ?";
	totalRowStmt = conn.prepareStatement(totalRowSql);
	totalRowStmt.setInt(1, boardNo);
	
	System.out.println(totalRowStmt + " : boardOne totalRowStmt");
	
	totalRowRs = totalRowStmt.executeQuery();
	
	if(totalRowRs.next()){
		totalRow = totalRowRs.getInt("COUNT(*)"); // count((*) = 1
	}
	System.out.println(totalRow + " : boardOne totalRow");
	
	// 시작행 = ((현재 페이지 - 1) x 페이지당 개수 5개) + 1 ex) 2페이지 > 6번 행~ 10번 행
	int startRow = (currentPage-1) * rowPerPage;
	
	// 마지막행 = 시작행 + (페이지당 개수 5개 - 1 = 4);
	int endRow = startRow + (rowPerPage - 1);
	if(endRow > totalRow){
		endRow = totalRow;
	}

	// 각 페이지 선택 버튼 몇개 표시?
	int pagePerPage = 5;
	
	// 마지막 페이지
	// 총 행의 수_페이지 당 행의 수 의 나머지가 0이 아니면 마지막 페이지 + 1
	int lastPage = totalRow / rowPerPage; 
	if(totalRow % rowPerPage != 0){
		lastPage = lastPage + 1;
	}
	
	System.out.println(lastPage + " : boardOne lastPage");
	
	// 페이지 선택 버튼 최소값 >> 1~5 / 6~10 에서 1 / 6 / 11 ,,,
	int minPage = ((currentPage-1) / pagePerPage * pagePerPage) + 1;
		
	// 페이지 선택 버튼 최대값 >> 1~5 / 6~10 에서 5 / 10 / 15 ,,,
	int maxPage = minPage + (pagePerPage - 1);
	if(maxPage > lastPage){ // ex) lastPage는 13, maxPage가 15(11~15) 일 경우
		maxPage = lastPage;  // maxPage를 lastPage == 13로 한다. 
	}

	
	// =========================================
	PreparedStatement commentListStmt = null;
	ResultSet commentListRs = null;
	String commentListSql = "SELECT comment_no commentNo, board_no boardNo, comment_content commentContent, member_id memberId, createdate, updatedate FROM comment WHERE board_no = ? LIMIT ?,?;";
	commentListStmt = conn.prepareStatement(commentListSql);
	commentListStmt.setInt(1, boardNo);
	commentListStmt.setInt(2, startRow);
	commentListStmt.setInt(3, rowPerPage);
	
	commentListRs =  commentListStmt.executeQuery(); // row > 최대 10
	
	System.out.println(commentListStmt + " : boardOne.jsp commentListStmt");
	
	// 댓글 여러개 arraylist <-> 상세정보-1개
	ArrayList <Comment> commentList = new ArrayList <Comment>();
	while(commentListRs.next()){
		Comment c = new Comment();
		c.setCommentNo(commentListRs.getInt("commentNo"));
		c.setBoardNo(commentListRs.getInt("boardNo"));
		c.setCommentContent(commentListRs.getString("commentContent"));
		c.setMemberId(commentListRs.getString("memberId"));
		c.setCreatedate(commentListRs.getString("createdate"));
		c.setUpdatedate(commentListRs.getString("updatedate"));
		commentList.add(c);
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
<title>boardOne.jsp</title>
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
	<!-- 3-1) board one 결과셋 -->
	<h2>상세정보</h2>
	<table class="table table-hover">
		<tr>
			<th>게시번호</th>
			<td><%=board.getBoardNo()%></td>
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
	</table>
	<div>
		<a type="button" class="btn btn-outline-secondary" href="<%=request.getContextPath()%>/board/updateBoardOneForm.jsp?boardNo=<%=boardNo%>">수정</a>
		<a type="button" class="btn btn-outline-secondary" href="<%=request.getContextPath()%>/board/deleteBoardOneForm.jsp?boardNo=<%=boardNo%>">삭제</a>
	</div>
	<br>
	
	<!-- 3-2) comment 입력 : 세션유무에 따른 분기 -->
	<%
		// 로그인 사용자만 댓글 입력 허용 ,,, 로그인안하면 안보이게
		if(session.getAttribute("loginMemberId") != null){
			String loginMemberId = (String)session.getAttribute("loginMemberId");
	%>
			<form action="<%=request.getContextPath()%>/board/insertCommentAction.jsp">
				<input type = "hidden" name = "boardNo" value = "<%=board.getBoardNo()%>">
				<input type = "hidden" name = "memberId" value = "<%=loginMemberId%>">
				<table class="table table-hover">
					<tr>
						<th>댓글</th>
						<td>
							<textarea rows="2" cols="80" name="commentContent"></textarea>
						</td>
					</tr>
				</table>
				<%
					if(msg != null){
				%>
						<%=msg%>
				<%
					}
				%>
				<br>
				<button type = "submit" class="btn btn-outline-secondary">댓글입력</button>
			</form>	
			<br>		
	<%
		}
	%>
	<!-- 3-3 comment list 결과셋 -->
	<table class="table table-hover">
		<tr>
			<th>작성자</th>
			<th>댓글 내용</th>
			<th>작성일자</th>
			<th>수정일자</th>
			<th>수정</th>
			<th>삭제</th>
		</tr>
		<%
			for(Comment c : commentList){
		%>
				<tr>
					<td><%=c.getMemberId()%></td>
					<td><%=c.getCommentContent()%></td>
					<td><%=c.getCreatedate()%></td>
					<td><%=c.getUpdatedate()%></td>
					<td><a type="button" class="btn btn-outline-secondary" href = "<%=request.getContextPath()%>/board/updateCommentForm.jsp?boardNo=<%=boardNo%>&commentNo=<%=c.getCommentNo()%>">수정</a></td>
					<td><a type="button" class="btn btn-outline-secondary" href = "<%=request.getContextPath()%>/board/deleteCommentForm.jsp?boardNo=<%=boardNo%>&commentNo=<%=c.getCommentNo()%>">삭제</a><td>
				</tr>
		<%		
			}
		%>
	</table>
	
	<!-- ================ 페이지 ================ -->
	<div class="btn-group">
		<!-- 첫 페이지 버튼 항상 표시 -->
		<a type="button" class="btn btn-outline-secondary" href="<%=request.getContextPath()%>/board/boardOne.jsp?currentPage=1&boardNo=<%=boardNo%>">첫페이지</a>&nbsp;
	<%
		// 첫페이지가 아닐 경우 이전 버튼 표시 == 첫 페이지에선 표시 x 
		// 다음 pagePerPage의 첫행으로 넘기기 ex) pagePerPage=5(1~5) 중 4 페이지 에서 다음 버튼 누르면 6페이지 첫행으로
		if(minPage > 1){
	%>
			<a type="button" class="btn btn-outline-secondary" href="<%=request.getContextPath()%>/board/boardOne.jsp?currentPage=<%=minPage-rowPerPage%>&boardNo=<%=boardNo%>">이전</a>&nbsp;
	<%	
		}
		
		// 첫페이지부터 마지막 페이지까지 버튼 표시
		// 현재 페이지 일 경우 숫자만 표시 / 나머지 페이지는 링크로 표시
		for(int i = minPage; i<=maxPage; i++){
			if(i == currentPage){
	%>
				<span class="btn btn-secondary"><%=i%></span>
	<%	
			} else {
	%>
				<a type="button" class="btn btn-outline-secondary" href="<%=request.getContextPath()%>/board/boardOne.jsp?currentPage=<%=i%>&boardNo=<%=boardNo%>"><%=i%></a>&nbsp;
	<%			
			}
		}
		
		// 각 페이지 표시버튼이 마지막이 아닌 경우 다음 버튼 표시 == 마지막 페이지에선 표시x
		// 이전 pagePerPage의 첫행으로 넘기기 ex) pagePerPage=5(21~25) 중 23 페이지 에서 이전 버튼 누르면 16페이지 첫행으로
		if(maxPage != lastPage){
	%>
			<a type="button" class="btn btn-outline-secondary" href="<%=request.getContextPath()%>/board/boardOne.jsp?currentPage=<%=minPage+rowPerPage%>&boardNo=<%=boardNo%>">다음</a>&nbsp;
	<%
		}
	%>	
		<!-- 마지막 페이지 버튼 -->
	<%
		// 댓글 없어 활성화된 페이지가 없으면 현재 페이지(1p) 고정
		if(lastPage == 0){
	%>
			<a type="button" class="btn btn-outline-secondary" href="<%=request.getContextPath()%>/board/boardOne.jsp?currentPage=1&boardNo=<%=boardNo%>">마지막페이지</a>&nbsp;
	<%
		} else {
	%>
		<a type="button" class="btn btn-outline-secondary" href="<%=request.getContextPath()%>/board/boardOne.jsp?currentPage=<%=lastPage%>&boardNo=<%=boardNo%>">마지막페이지</a>&nbsp;
	<%
		}
	%>	
	</div>
	<br>
	<div>
		<!-- include 페이지 : Copyright &copy; 구디아카데미 -->
		<jsp:include page="/inc/copyright.jsp"></jsp:include>
	</div>
</body>
</html>