<%@page import="java.net.URLEncoder"%>
<%@page import="java.awt.dnd.DragGestureListener"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.ArrayList"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.util.*"%>
<%@ page import = "vo.*"%>
<%
	// 모델 계층
	//DB
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	
	Class.forName(driver);
	Connection conn = null;
	
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	// ==================================================
	
	/* 1. 요청분석(컨트롤러 계층)
		1.1 session JSP내장(기본)객체
		1.2 request / response
	*/
	// 전체로 초기화
	String localName = "전체"; // null이든 전체든 전체표시
	if(request.getParameter("localName") != null){
		localName = request.getParameter("localName");
	}
	
	System.out.println(localName + " : home.jsp localName");
	
	// ================== 페이지 ===================
	// 현재 페이지
	int currentPage = 1;
	if(request.getParameter("currentPage") != null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	// 페이지 당 행 개수
	int rowPerPage  = 10;
	if(request.getParameter("rowPerPage") != null) {
	      rowPerPage = Integer.parseInt(request.getParameter("rowPerPage"));
	}
	
	// 총 행의 수
	int totalRow = 0; 
	String totalRowSql = null;
	PreparedStatement totalRowStmt = null;
	ResultSet totalRowRs = null; 
	
	// 전체일 경우 전체 조회 / 전체가 아니면(=localName이 선택되었을떄) where local_name~~~
	if(localName.equals("전체")){
		totalRowSql = "SELECT COUNT(*) FROM board";
		totalRowStmt = conn.prepareStatement(totalRowSql);
	} else{
		totalRowSql = "SELECT COUNT(*) FROM board WHERE local_name=?";
		totalRowStmt = conn.prepareStatement(totalRowSql);
		totalRowStmt.setString(1, localName);
	}
	System.out.println(totalRowStmt + " : home.jsp totalRowStmt");
	
	totalRowRs = totalRowStmt.executeQuery();
	
	if(totalRowRs.next()){
		totalRow = totalRowRs.getInt("COUNT(*)"); // count((*) = 1
	}
	System.out.println(totalRow + " : home.jsp totalRow");
	
	// 시작행 = ((현재 페이지 - 1) x 페이지당 개수 10개) ex) 1페이지 > 0~9번 행
	int startRow = (currentPage-1) * rowPerPage;
	
	// 마지막행 = 시작행 + (페이지당 개수 10개 - 1 = 9);
	int endRow = startRow + (rowPerPage - 1);
	if(endRow > totalRow){
		endRow = totalRow;
	}
	
	// 각 페이지 선택 버튼 몇개 표시?
	int pagePerPage = 10;
	
	// 마지막 페이지
	int lastPage = totalRow / rowPerPage; 
	if(totalRow % rowPerPage != 0){ // 페이지가 떨어지지않아 잔여 행이 있다면 
		lastPage = lastPage + 1; // 1 추가, 잔여 행을 lastPage에 배치
	}
	
	System.out.println(lastPage + " : home.jsp lastPage");
	
	// 페이지 선택 버튼 최소값 >> 1~10 / 11~20 에서 1 / 11 / 21 ,,,
	int minPage = ((currentPage-1) / pagePerPage * pagePerPage) + 1;
		
	// 페이지 선택 버튼 최대값 >> 1~10 / 11~20 에서 10 / 20 / 30 ,,,
	int maxPage = minPage + (pagePerPage - 1);
	if(maxPage > lastPage){ // ex) lastPage는 27, maxPage가 30(21~30) 일 경우
		maxPage = lastPage;  // maxPage를 lastPage == 27로 한다. 
	}
	
	
	// ==================================================
	
	/*  SELECT '전체' localName, COUNT(local_name) cnt FROM board
	UNION ALL
	SELECT local_name, COUNT(local_name) FROM board GROUP BY local_name; 
	*/
	
	// 서브메뉴 쿼리, 전체 포함 그룹명(지역명)으로 리스트
	PreparedStatement subMenuStmt = null;
	ResultSet subMenuRs = null;
	
	// 1쿼리 union all 2쿼리 union all 3쿼리
	// 1쿼리 = local_name이 전체인 게시물 수 == 전체 게시물 수를 board에서 뽑아옴
	// 2쿼리 = 각 local_name에 해당하면 지역명과 게시물수를 board에서 뽑아옴
	// 3쿼리 = 게시물이 없는 local_name을 local에서 뽑아옴 
	String subMenuSql = "SELECT '전체' localName, COUNT(local_name) cnt FROM board UNION ALL SELECT local_name, COUNT(local_name) FROM board GROUP BY local_name UNION ALL SELECT local_name, 0 FROM local WHERE local_name != All(SELECT local_name FROM board GROUP BY local_name)";
	subMenuStmt = conn.prepareStatement(subMenuSql);
	
	System.out.println(subMenuStmt + " : home.jsp subMenuStmt");
	
	subMenuRs = subMenuStmt.executeQuery();
	
	// subMenuList <-- HashMap<String, Object>의 데이터를 가진 ArrayList 모델 데이터
	ArrayList<HashMap<String, Object>> subMenuList = new ArrayList<HashMap<String, Object>>();
	while(subMenuRs.next()){
		HashMap<String, Object> m = new HashMap<String, Object>();
		m.put("localName",subMenuRs.getString("localName"));
		m.put("cnt",subMenuRs.getInt("cnt"));
		subMenuList.add(m);
	}
	
	//지역 이름만 따로 저장
	ArrayList<String> localList = new ArrayList<String>();
	for(HashMap<String, Object> m : subMenuList){
		String currLocal = (String)m.get("localName");
		if(!currLocal.equals("전체")){
	localList.add(currLocal);
		}
	}
	
	// 게시판 목록 결과셋(모델)
	PreparedStatement boardStmt = null;
	ResultSet boardRs = null;
	
	/*
	SELECT 
		board_no boardNo, 
		local_name localName, 
		board_title boardTitle,
		createdate
	FROM board 
	WHERE local_name = ?
	ORDER BY createdate DESC
	LIMIT ?,?
	*/

	String boardSql = "";
	if(localName.equals("전체")){
		boardSql = "SELECT board_no boardNo, local_name localName, board_title boardTitle, member_id memberId, createdate FROM board ORDER BY createdate DESC LIMIT ?,?";
		boardStmt = conn. prepareStatement(boardSql);
		boardStmt.setInt(1,startRow);
		boardStmt.setInt(2,rowPerPage);
	} else {
		boardSql = "SELECT board_no boardNo, local_name localName, board_title boardTitle, member_id memberId, createdate FROM board WHERE local_name = ? ORDER BY createdate DESC LIMIT ?,?";
		boardStmt = conn. prepareStatement(boardSql);
		boardStmt.setString(1,localName);
		boardStmt.setInt(2,startRow);
		boardStmt.setInt(3,rowPerPage);
	}
	boardRs = boardStmt.executeQuery(); // DB쿼리 결과셋 모델
	
	// 모델데이터 boardList
	ArrayList<Board> boardList = new ArrayList<Board>(); // 애플리케이션에서 사용할 모델(사이즈0) 	
	
	// boardRs > boardList
	
	while(boardRs.next()){
		Board b = new Board(); 
		b.setBoardNo(boardRs.getInt("boardNo"));
		b.setLocalName(boardRs.getString("localName"));
		b.setBoardTitle(boardRs.getString("boardTitle"));
		b.setMemberId(boardRs.getString("memberId"));
		b.setCreatedate(boardRs.getString("createdate"));
		boardList.add(b);
	}
	
	System.out.println(boardList);
	System.out.println(boardList.size());
	
	System.out.println(currentPage);
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>home.jsp</title>
<!-- Latest compiled and minified CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- Latest compiled JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
	<div class="p-4 bg-dark text-white text-center">
	  <h1>유저게시판</h1>
	  <p>
	  	UserBoard_게시판작성<br>
	  	기간 : 23.05.02 - 23.05.20 / 	인원 : 1명<br>
	  	개발환경 : Tool_Eclipse/HeidiSQL DB_MariaDB(3.1.3) WAS_Tomcat (10.1.7 > 9.0.75)<br> 
	  	개발(구현) 내용 : 페이지별, 10단위 이동 / 로그인, 회원가입 / 지역(카테고리)목록, 게시물 및 댓글 목록 / 목록 별 작성, 수정, 삭제
	  </p> 
	</div>
	<%
		// request.getRequestDispatcher(request.getContextPath()+"/inc/mainmenu.jsp").include(request, response);
		// ↑ 이걸 액션태그로 변경하면 아래와 같다
	%>
	<!-- 메인메뉴(가로) -->
	<div>
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
	</div>
	<br>	
	<!-- 로그인폼 메인메뉴에 병합 -->
		<%-- <div>
			<!-- home 내용 : 로그인 폼 -->
			<!-- 로그인 폼 -->
			<%
				if(session.getAttribute("loginMemberId") == null){// 로그인 전이면 로그인 폼 출력
			%>
					<form action="<%=request.getContextPath()%>/member/loginAction.jsp" method="post">
						<table class="table table-hover">
							<tr>
								<td>아이디</td>
								<td><input type="text" name="memberId"></td>
							</tr>	
							<tr>
								<td>패스워드</td>
								<td><input type="password" name="memberPw"></td>
							</tr>	
						</table>
						<button type="submit" class="btn btn-outline-secondary">로그인</button>
					</form>	
			<%
				}
			%>
		</div> --%>
	<br>
	<div class="row">
		<!-- 서브메뉴(세로) subMenuList 모델을 출력 -->
		<div class="col-sm-2">
			<ul class="list-group list-group-flush">
			<%
					for(HashMap<String, Object> m : subMenuList){
			%>
					<li style="text-align: center;" class="list-group-item">
						<a href = "<%=request.getContextPath()%>/home.jsp?localName=<%=(String)m.get("localName")%>" class="text-decoration-none">
							<%=(String)m.get("localName")%>(<%=(Integer)(m.get("cnt"))%>)
						</a>
					</li>
			<%
					}
			%>
			</ul>
		</div>
		
		<!-- ================ 리스트 ================ --> <!-- css 확인 -->
		<div class="col-sm-10">
			<table class="table table-hover">
				<tr>
					<th>지역명</th>
					<th>작성자</th>
					<th>글 제목</th>
					<th>작성일자</th>
				</tr>
				<%
							for(Board b : boardList){
				%>
						<tr>
							<td><%=b.getLocalName()%></td>
							<td><%=b.getMemberId()%></td>
							<td>
								<a href = "<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=b.getBoardNo()%>" class="text-decoration-none">
									<%=b.getBoardTitle()%>
								</a>
							</td>
							<td><%=b.getCreatedate()%></td>
						</tr>
				<%
					}
				%>
			</table>
		</div>
	</div>
	
	<!-- ================ 페이지 ================ -->
	<div class="container mt-3">
		<ul class="pagination justify-content-center">
		<!-- 첫 페이지 버튼 항상 표시 -->
		<li>
		<a type="button" class="btn btn-outline-secondary" href="<%=request.getContextPath()%>/home.jsp?currentPage=1&localName=<%=localName%>">첫페이지</a>&nbsp;
		</li>
	<%
		// 첫페이지가 아닐 경우 이전 버튼 표시 == 첫 페이지에선 표시 x 
		// 다음 pagePerPage의 첫행으로 넘기기 ex) pagePerPage=10(1~10) 중 4 페이지 에서 다음 버튼 누르면 11페이지 첫행으로 
		if(minPage > 1){
	%>		
			<li>
			<a type="button" class="btn btn-outline-secondary" href="<%=request.getContextPath()%>/home.jsp?currentPage=<%=minPage-rowPerPage%>&localName=<%=localName%>">이전</a>&nbsp;
			</li>
	<%	
		}
		
		// 첫페이지부터 마지막 페이지까지 버튼 표시
		// 현재 페이지 일 경우 숫자만 표시 / 나머지 페이지는 링크로 표시
		for(int i = minPage; i<=maxPage; i++){
			if(i == currentPage){
	%>
				<li>
				<a class="btn btn-secondary"><%=i%></a>
				</li>
	<%	
			} else {
	%>			
				<li>
				<a type="button" class="btn btn-outline-secondary" href="<%=request.getContextPath()%>/home.jsp?currentPage=<%=i%>&localName=<%=localName%>"><%=i%></a>&nbsp;
				</li>
	<%			
			}
		}
		
		// 각 페이지 표시버튼이 마지막이 아닌 경우 다음 버튼 표시 == 마지막 페이지에선 표시x
		// 이전 pagePerPage의 첫행으로 넘기기 ex) pagePerPage=10(31~40) 중 37 페이지 에서 이전 버튼 누르면 21페이지 첫행으로
		if(maxPage != lastPage){
	%>	
			<li>
			<a type="button" class="btn btn-outline-secondary" href="<%=request.getContextPath()%>/home.jsp?currentPage=<%=minPage+rowPerPage%>&localName=<%=localName%>">다음</a>&nbsp;
			</li>
	<%
		}
	%>
		<!-- 마지막 페이지 버튼 -->	
	<%
		// 게시물이 없어 활성화된 페이지가 없으면 현재 페이지(1p) 고정
		if(lastPage == 0){
	%>
			<li>
			<a type="button" class="btn btn-outline-secondary" href="<%=request.getContextPath()%>/home.jsp?currentPage=1&localName=<%=localName%>">마지막페이지</a>&nbsp;
			</li>
	<%
		} else {
	%>	
			<li>
			<a type="button" class="btn btn-outline-secondary" href="<%=request.getContextPath()%>/home.jsp?currentPage=<%=lastPage%>&localName=<%=localName%>">마지막페이지</a>&nbsp;
			</li>
	<%
		}
	%>		
		</ul>
	</div>
	<br>
	<div>
		<!-- include 페이지 : copyright &copy; 구디아카데미 -->
		<jsp:include page="/inc/copyright.jsp"></jsp:include>
	</div>
</body>
</html>