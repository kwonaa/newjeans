<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@include file="./includes/header.jsp"%>
	    <script>
		    <!--0902 채은열 추가 ***********************************************************************  -->
		    function validateForm() {
		        var form = document.forms["userForm"];
		        var password = form["userpw"].value;
		        var passwordCheck = form["userpw_check"].value;
		        if (password !== passwordCheck) {
		            alert("비밀번호가 일치하지 않습니다.");
		            form["userpw_check"].focus();
		            return false; // 폼 제출 방지
		        }
		        return true; // 폼 제출 허용
		    }
		    <!--0902 채은열 추가 ***********************************************************************  -->
	        var idAvailable = false; // 아이디 사용 가능 상태
	        function checkId() {
	            var userid = document.getElementById('userid').value;
	            if (userid === '') {
	                alert('아이디를 입력하세요.');
	                return;
	            }
	            // 새 창의 크기
	            var width = 400;
	            var height = 300;
	            // 새 창의 위치 (가로 중앙, 세로 중앙)
	            var left = Math.floor((window.innerWidth - width) / 2 + window.screenX);
	            var top = Math.floor((window.innerHeight - height) / 2 + window.screenY);
	            // 새 창 열기
	            var checkWindow = window.open('/member/checkId?userid=' + encodeURIComponent(userid), 'idCheckWindow', 
	                'width=' + width + ',height=' + height + ',left=' + left + ',top=' + top
	            );
	            // 중복 확인 창이 닫힐 때 부모 창의 버튼 상태를 업데이트
	            var interval = setInterval(function() {
	                if (checkWindow.closed) {
	                    clearInterval(interval);
	                    updateSignupButton();
	                }
	            }, 500);
	        }
	        function updateSignupButton() {
	            var signupButton = document.getElementById('signupButton');
	            signupButton.disabled = !idAvailable;
	        }
	        function setIdAvailability(available) {
	            idAvailable = available;
	            updateSignupButton();
	        }
	        function handleInputChange() {
	            // 아이디 입력 필드 값이 변경될 때 회원가입 버튼 비활성화
	            setIdAvailability(false);
	        }
	    </script>
	    <div class="row">
			<div class="col-lg-12 member">
				<h3 class="bold">회원가입</h3>
			    <form name="userForm" action="/member/customSignup" method="post" onsubmit="return validateForm()"><!--0902 채은열 추가  -->
				    <div class="member-info">
				        <!-- CSRF Token -->
				        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
				        <!-- 이름 -->
				        <div class="form-group">
				            <label for="userName">이름</label>
				            <input type="text" id="userName" name="userName" class="input" required>
				        </div>
				        <!-- 아이디 -->
				        <div class="form-group">
				            <label for="userid">아이디</label>
				            <button id="checkIdButton" type="button" onclick="checkId()">중복체크</button>
				            <input type="text" id="userid" name="userid" class="input" required oninput="handleInputChange()">
				        </div>
				        <!-- 비밀번호 -->
				        <div class="form-group">
				            <label for="userpw">비밀번호</label>
				            <input type="password" id="userpw" name="userpw" class="input" required>
				        </div>
				        <!-- 비밀번호 확인 -->
				        <div class="form-group">
				            <label for="userpw_check">비밀번호확인</label>
				            <input type="password" id="userpw_check" name="userpw_check" class="input" required>
				        </div>
				        <!-- 회원가입 버튼 -->
				        <div class="form-group">
				            <input class="inputButton" type="submit" id="signupButton" class="input" value="회원가입" disabled>
				        </div>
				        <div class="form-group"> ** 중복체크를 하지 않으면 가입버튼이 활성화되지 않습니다. **</div>
				    </div>
				</form>
		    </div>
	    </div>
<%@include file="./includes/footer.jsp"%>