<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*" %> 
<%
	//요청값 유효성 검사
	String msg = null;

	if(request.getParameter("localName") == null
		|| request.getParameter("localName").equals("")){
			msg = URLEncoder.encode("지역을 선택하세요.", "UTF-8");
	} else if (request.getParameter("boardTitle") == null
		|| request.getParameter("boardTitle").equals("")){
			msg = URLEncoder.encode("제목을 입력하세요.", "UTF-8");
	} else if (request.getParameter("boardContent") == null
		|| request.getParameter("boardContent").equals("")){
			msg = URLEncoder.encode("내용을 입력하세요.", "UTF-8");
	} else if (request.getParameter("loginMemberId") == null
		|| request.getParameter("loginMemberId").equals("")){
			msg = URLEncoder.encode("로그인 후 작성 가능합니다.", "UTF-8");
	}
	
	//빈값이 있을경우 insertBoardOneForm으로 redirection
	if(msg != null){
		response.sendRedirect(request.getContextPath() + "/board/insertBoardOneForm.jsp?msg=" + msg);
		return;
	}
	
	//요청값 저장
	String localName = request.getParameter("localName");
	String boardTitle = request.getParameter("boardTitle");
	String boardContent = request.getParameter("boardContent");
	String loginMemberId = request.getParameter("loginMemberId");
	
	System.out.println(localName + " : insertBoardOneAction localName");
	System.out.println(boardTitle + " : insertBoardOneAction boardTitle");
	System.out.println(boardContent + " : insertBoardOneAction boardContent");
	System.out.println(loginMemberId + " : insertBoardOneAction loginMemberId");
	
	// DB
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	
	Class.forName(driver);
	Connection conn = null;
	
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	// 쿼리
	PreparedStatement insertStmt = null;
	int insertRow= 0;
	
	String insertsql = "INSERT INTO board(local_name, board_title, board_content, member_id, createdate, updatedate) values (?, ?, ?, ?, now(), now())";
	insertStmt = conn.prepareStatement(insertsql);
	insertStmt.setString(1, localName);
	insertStmt.setString(2, boardTitle);
	insertStmt.setString(3, boardContent);
	insertStmt.setString(4, loginMemberId);
	
	System.out.println(insertStmt + " : insertBoardOneAction insertStmt");
	
	// 실행시
	insertRow = insertStmt.executeUpdate();
	
	//저장 실패시 insertBoardForm, 성공시 home으로
		if(insertRow == 0){
			String err = URLEncoder.encode("작성실패", "utf-8");
			response.sendRedirect(request.getContextPath() + "/board/insertBoardOneForm.jsp?msg=" + err);
			return;
		}else{
			response.sendRedirect(request.getContextPath() + "/home.jsp");
		}
%>

