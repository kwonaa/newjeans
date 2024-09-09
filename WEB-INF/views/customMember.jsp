<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@include file="./includes/header.jsp"%>
		<script>
			 function validateForm() {
	            var form = document.forms["userForm"];
	            var password = form["userpw"].value;
	            var passwordCheck = form["userpw_check"].value;
	            if (password !== passwordCheck) {
	                alert("비밀번호가 일치하지 않습니다.");
	                form["userpw_check"].focus();
	                return false; // 폼 제출 방지
	            }
		 		<!--0903 채은열 추가 ***********************************************************************  -->
				var phonePattern = /^\d{3}-\d{4}-\d{4}$/;
				var emailPattern = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
				if (!emailPattern.test(document.userForm.email.value)) {
					alert("이메일 형식이 올바르지 않습니다. example@.com 형식으로 입력하세요");
					document.userForm.email.focus();
					return false;
				}
				if (!phonePattern.test(document.userForm.pnumber.value)) {
					alert("전화번호 형식이 올바르지 않습니다. 010-1234-5678 형식으로 입력하세요.");
					document.userForm.pnumber.focus();
					return false;
				}
				return true;
			 }
		</script>
		<div class="row">
			<div class="col-lg-12 member">
				<!--0902 채은열 추가 ***********************************************************************  -->
				<h3 class="bold">회원정보수정</h3>
				<form name="userForm" action="/member/customMember" method="post" onsubmit="return validateForm()">
				    <div class="member-info">
				        <input type="hidden" name="${_csrf.parameterName}" class="input" value="${_csrf.token}" />
				        <div class="form-group">
				            <label for="userName">이름</label>
				            <input type="text" id="userName" name="userName" class="input" value="${username}" required>
				        </div>
				        <div class="form-group">
				            <label for="userid">아이디</label>
				            <input type="text" id="userid" name="userid" class="input" value="${userid}" readonly>
				        </div>
				        <div class="form-group">
				            <label for="userpw">비밀번호</label>
				            <input type="password" id="userpw" name="userpw" class="input" required>
				        </div>
				        <div class="form-group">
				            <label for="userpw_check">비밀번호확인</label>
				            <input type="password" id="userpw_check" name="userpw_check" class="input" required>
				        </div>
				        <div class="form-group">
				            <label for="email">이메일</label>
				            <input type="text" id="email" name="email" class="input" value="${email}">
				        </div>
				        <div class="form-group">
				            <label for="pnumber">전화번호</label>
				            <input type="text" id="pnumber" name="pnumber" class="input" value="${pnumber}">
				        </div>
				        <!--0903 채은열 추가 *********************************************************************** 주소 삭제로 인한 hidden처리 -->
				        <input type="hidden" id="address" name="address" value="${address}">
				        <div class="form-actions">
				            <input class="inputButton" type="submit" value="회원정보 수정하기">
				            <input class="inputButton" type="button" onclick="location.href='/member/customMemberInfo'" value="취소">
				        </div>
				    </div>
				</form>
			</div>
		</div>
<%@include file="./includes/footer.jsp"%>