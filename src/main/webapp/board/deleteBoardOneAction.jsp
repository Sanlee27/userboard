<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.util.*"%>
<%@ page import = "java.net.*"%>
<%@ page import = "vo.*"%>
<%
	request.setCharacterEncoding("utf-8");

	//유효성 검사 _ 로그인전이면 홈으로 돌아가게; 페이지 표시x
	if(session.getAttribute("loginMemberId") == null){ 
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;		
	}
	
	// 변수저장
	String loginMemberId = (String)session.getAttribute("loginMemberId");
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	
	// DB
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	
	Class.forName(driver);
	Connection conn = null;
	
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);

	// 쿼리
	PreparedStatement deleteBoardStmt = null;
	int deleteBoardRow = 0;
	
	String deleteBoardSql = "DELETE FROM board WHERE member_id = ? AND board_no = ?";
	deleteBoardStmt = conn.prepareStatement(deleteBoardSql);
	deleteBoardStmt.setString(1, loginMemberId);
	deleteBoardStmt.setInt(2, boardNo);

	System.out.println(deleteBoardStmt + " : deleteBoardOneAction deleteBoardStmt");
	
	// 삭제실행시
	deleteBoardRow = deleteBoardStmt.executeUpdate();
	
	System.out.println(deleteBoardRow + " : deleteCommentAction deleteCommentRow");
	
	String msg = null;
	if(request.getParameter("msg") != null){
		msg = request.getParameter("msg");
	}
	
	if(deleteBoardRow == 1){
		System.out.println(deleteBoardRow + " : 삭제성공");
		response.sendRedirect(request.getContextPath()+"/home.jsp");
	} else {
		System.out.println(deleteBoardRow + " : 삭제실패");
		msg = URLEncoder.encode("삭제를 실패했습니다.", "UTF-8");
		response.sendRedirect(request.getContextPath()+"/board/deleteBoardOneForm.jsp?boardNo="+boardNo+"&msg="+msg);
	}
%>