<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@include file="./includes/header.jsp"%>
		<div class="row">
			<div class="col-lg-12 member">
				<i class="fa fa-sign-in" aria-hidden="true" style="color:green;"></i>
				<h3 class="bold">로그인</h3>
				<form method='post' action="/login">
					<div class="member-info">
						<!-- username -->
						아이디
						<div>
							<input class="input" type='text' name='username'> 
						</div>
						<!-- password -->
						비밀번호
						<div>
							<input class="input" type='password' name='password'>
						</div>
						<!-- 자동로그인 -->
						<div id="remember-me">
							<input type='checkbox' name='remember-me'> 자동로그인
						</div>						
						<!-- login -->
						<div>
							<input class="inputButton" type='submit' value="로그인">
						</div>					
						<h5><c:out value="${error}"/></h5>
						<h5><c:out value="${logout}"/></h5>
					</div>
					<!-- hidden 태그 -->
					<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
				</form>
				로그인 아이디가 없으신가요? <a class="bold" href="/member/customSignup">회원가입</a>
			</div>
		</div>
<%@include file="./includes/footer.jsp"%>