<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="./includes/header.jsp"%>
		<div class="row">
			<div class="col-lg-12 member">
				<h3 class="bold">회원정보확인</h3>
				<!--0902 채은열 추가 ***********************************************************************  -->
			    <form action="/member/customMember" method="post">
				    <div class="member-info">
					    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
				        <div class="form-group">
				            <label for="userid">아이디</label>
				            <input type="text" id="userid" name="userid" class="input" value="${userid}" readonly>
				        </div>
				        <div class="form-group">
				            <label for="userName">이름</label>
				            <input type="text" id="userName" name="userName" class="input" value="${username}" readonly>
				        </div>
				        <div class="form-group">
				            <label for="email">이메일</label>
				            <input type="text" id="email" name="email" class="input" value="${email}" readonly>
				        </div>
				        <div class="form-group">
				            <label for="pnumber">전화번호</label>
				            <input type="text" id="pnumber" name="pnumber" class="input" value="${pnumber}" readonly>
				        </div>
				        <!--0903 채은열 추가 *********************************************************************** 주소 삭제로 인한 hidden처리  -->
				        <input type="hidden" id="address" name="address" value="${address}">
				        <!--0903 채은열 추가 *********************************************************************** 버튼 변경 -->
				        <div class="form-actions">
				            <input class="inputButton" type="button" onclick="location.href='/member/customPass'" value="회원정보수정">
				            <input class="inputButton" type="button" onclick="location.href='/newjeans/list'" value="목록">
				        </div>
				    </div>
				</form>
			</div>
		</div>
<%@include file="./includes/footer.jsp"%>