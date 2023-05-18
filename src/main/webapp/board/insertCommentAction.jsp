<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.util.*"%>
<%@ page import = "java.net.*"%>
<%@ page import = "vo.*"%>
<%	
	// insertCommentAction.jsp	

	// 로그인 확인
	if(session.getAttribute("loginMemberId") == null){ // 로그인이면 홈으로
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	
	// 요청값 확인
	// boardNo_번호
	if(request.getParameter("boardNo") == null || request.getParameter("boardNo").equals("")){
	response.sendRedirect(request.getContextPath()+"/home.jsp");
	return;
	}
	
	// 댓글내용
	String msg = null;
	
	if(request.getParameter("commentContent") == null || request.getParameter("commentContent").equals("")){
		msg = URLEncoder.encode("댓글을 입력하세요.", "UTF-8");
		response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?boardNo="+request.getParameter("boardNo")+"&msg="+msg);
		return;
	}
	
	// 변수확인
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	String loginMemberId = (String)session.getAttribute("loginMemberId");
	String commentContent = request.getParameter("commentContent");
	
	System.out.println(boardNo + " : insertCommentAction boardNo");
	System.out.println(loginMemberId + " : insertCommentAction loginMemberId");
	System.out.println(commentContent + " : insertCommentAction commentContent");
	
	//DB
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	// 값입력 쿼리문
	PreparedStatement insertCommentStmt = null;
	String insertCommentSql = "INSERT INTO comment(board_no, comment_content, member_id, createdate, updatedate) VALUES (?,?,?,NOW(),NOW())";
	insertCommentStmt = conn.prepareStatement(insertCommentSql);
	insertCommentStmt.setInt(1, boardNo);
	insertCommentStmt.setString(2, commentContent);
	insertCommentStmt.setString(3, loginMemberId);
	
	// 쿼리실행 및 확인
	int row = insertCommentStmt.executeUpdate();
	
	if(row == 1){ // 입력 성공
		System.out.println("입력성공");
	} else {
		System.out.println("입력실패");
	}
	response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?boardNo="+boardNo); // 완료 후 상세정보pg이동
%>