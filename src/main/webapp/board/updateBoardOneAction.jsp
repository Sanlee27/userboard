<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.util.*"%>
<%@ page import = "java.net.*"%>
<%@ page import = "vo.*"%>
<%
	request.setCharacterEncoding("utf-8");
	
	//세션 유효성 검사_ 로그인 전이면
	if(session.getAttribute("loginMemberId") == null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	
	//boardNo_글번호
	if(request.getParameter("boardNo") == null 
		|| request.getParameter("boardNo").equals("")){
			response.sendRedirect(request.getContextPath()+"/home.jsp");
			return;
	}
	
	// 변수저장
	String loginMemberId = (String)session.getAttribute("loginMemberId");
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	String localName = request.getParameter("localName");
	String boardTitle = request.getParameter("boardTitle");
	String boardContent = request.getParameter("boardContent");
	
	System.out.println(loginMemberId + " : updateBoardOneAction loginMemberId");
	System.out.println(boardNo + " : updateBoardOneAction boardNo");
	System.out.println(localName + " : updateBoardOneAction localName");
	System.out.println(boardTitle + " : updateBoardOneAction boardTitle");
	System.out.println(boardContent + " : updateBoardOneAction boardContent");
	
	String msg = null;
	
	if(localName == null || localName.equals("")
		|| boardTitle == null || boardTitle.equals("")
		|| boardContent == null || boardContent.equals("")){
			msg = URLEncoder.encode("공백을 확인하십시오.", "UTF-8");
			response.sendRedirect(request.getContextPath()+"/board/updateBoardOneForm.jsp?boardNo="+boardNo+"&msg="+msg);
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
	
	// 지역명 비교 쿼리
	PreparedStatement localNameStmt = null;
	ResultSet localNameRs = null;
	String localNamesql = "SELECT local_name localName FROM local";
	localNameStmt = conn.prepareStatement(localNamesql);
	
	System.out.println(localNameStmt + " : updateBoardOneAction localNameStmt");
	
	localNameRs = localNameStmt.executeQuery();
	
	// arraylist로 하여금 로컬네임 입력값을 싹다 비교, 없으면 null값 > 오류처리 = 수정실패
	ArrayList <Local> localList = new ArrayList <Local>();
	while(localNameRs.next()){
		Local l = new Local();
		l.setLocalName(localNameRs.getString("localName"));
		localList.add(l);
	}	
	
	// 쿼리
	PreparedStatement updateStmt = null;
	String updateSql = "UPDATE board SET local_name = ?, board_title = ?, board_content = ?, updatedate = NOW() WHERE board_no = ?";
	updateStmt = conn.prepareStatement(updateSql);
	updateStmt.setString(1, localName);
	updateStmt.setString(2, boardTitle);
	updateStmt.setString(3, boardContent);
	updateStmt.setInt(4, boardNo);
	
	System.out.println(updateStmt + " : updateBoardOneAction updateStmt");
	
	int updateRow = 0;
	
	// arrayList 이용, localName값이 db안에 localName 값 중 하나와 동일할 경우 execute.
	// 그게 아니면 메세지 표시 및 리다이렉션
	for(Local l : localList){
		if(localName.equals(l.getLocalName())){
			updateRow = updateStmt.executeUpdate();
		} else {
			System.out.println(updateRow + " : updateBoardOneAction arrayList > 없는 지역명 오류처리");
		}
	}	
	
	if(updateRow == 1){
		System.out.println(updateRow + " : updateBoardOneAction updateRow > 수정성공");
		response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?boardNo="+boardNo);
	} else {
		System.out.println(updateRow + " : updateBoardOneAction updateRow > 수정실패");
		msg = URLEncoder.encode("존재하지 않는 지역명입니다.","UTF-8");
		response.sendRedirect(request.getContextPath()+"/board/updateBoardOneForm.jsp?boardNo="+boardNo+"&msg="+msg);
	}
%>