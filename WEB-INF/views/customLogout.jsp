<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@include file="./includes/header.jsp"%>
		<div class="row">
			<div class="col-lg-12 member">
				<i class="fa fa-sign-out" aria-hidden="true" style="color:red;"></i>
				<h3 class="bold">로그아웃 안내</h3>
				<form method='post' action="/customLogout">
					<div class="member-info">
						<input type="hidden"name="${_csrf.parameterName}"value="${_csrf.token}"/>
						<div>
							<div class="logout-info">
								로그아웃 시 작업하던 내용이 유실될 수 있습니다.<br>
								작업하던 내용을 저장해주시기 바랍니다.<br>
								정말 로그아웃 하시겠습니까?<br>
							</div>
							<input class="inputButton" type='submit' value="로그아웃">
							<input class="inputButton" type='button' value="돌아가기" onclick="history.back()">
						</div>
					</div>
				</form>
			</div>
		</div>
		<script>
	        function goBack() {
	            window.history.back();
	        }
   		</script>
<%@include file="./includes/footer.jsp"%>