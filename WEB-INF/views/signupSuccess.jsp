<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="./includes/header.jsp"%>
		<div class="row">
			<div class="col-lg-12 member">
				<i class="fa fa-check" aria-hidden="true" style="color:green;"></i>
			    <h3 class="bold">회원가입 완료</h3>
			    <div class="member-info">
				    <div class="logout-info">
					    <p>${message}</p>
		    		</div>
			    	<a id="goToLogin" href="/customLogin">로그인 하러가기</a>
		    	</div>
		    </div>
	    </div>
<%@include file="./includes/footer.jsp"%>