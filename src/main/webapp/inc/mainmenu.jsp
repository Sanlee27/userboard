<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String loginMemberId = (String)session.getAttribute("loginMemberId");
%>
<div>
	<ul class="list-group list-group-horizontal">
		<li class="list-group-item">
			<a type="button" class="btn btn-outline-secondary" href="<%=request.getContextPath()%>/home.jsp">홈으로</a></li>
		<!--
			로그인전 : 회원가입
			로그인후 : 회원정보 / 로그아웃 / 카테고리 목록 / 게시물 작성 / (로그인정보 세션 loginMemberId
		  -->
		  
		 <%
		 	if(session.getAttribute("loginMemberId") == null){ // 로그인전
		 %> 
		 		<li class="list-group-item">
			 		<form action="<%=request.getContextPath()%>/member/loginAction.jsp" method="post">
						<table>
							<tr>
								<td class=".text-secondary">아이디</td>
								<td><input type="text" class="form-control" name="memberId"></td>
								<td>패스워드</td>
								<td><input type="password" class="form-control" name="memberPw"></td>
								<td><input type="submit" class="btn btn-outline-secondary" value="로그인"></td>
							</tr>	
						</table>
					</form>	
				</li>
		 		<li class="list-group-item"><a type="button" class="btn btn-outline-secondary" href="<%=request.getContextPath()%>/member/insertMemberForm.jsp">회원가입</a></li>
		 <%		 		
		 	} else { // 로그인후
		 %>
				<li class="list-group-item"><a type="button" class="btn btn-outline-secondary" href="<%=request.getContextPath()%>/member/memberInformation.jsp">회원정보</a></li>
				<li class="list-group-item"><a type="button" class="btn btn-outline-secondary" href="<%=request.getContextPath()%>/member/logoutAction.jsp">로그아웃</a></li>
				<li class="list-group-item"><a type="button" class="btn btn-outline-secondary" href = "<%=request.getContextPath()%>/board/selectLocal.jsp">카테고리 목록</a></li>
				<li class="list-group-item"><a type="button" class="btn btn-outline-secondary" href = "<%=request.getContextPath()%>/board/insertBoardOneForm.jsp">게시글 작성</a></li>
				<li class="list-group-item"><a style="vertical-align: center;"><%=loginMemberId%>님이 접속 중입니다.</a></li>
		<%
		 	}
		%> 
	</ul>
</div>