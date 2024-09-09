<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@include file="./includes/header.jsp"%>
		<div class="row">
			<div class="col-lg-12 member">
				<i class="fa fa-lock" aria-hidden="true" style="color:gray;"></i>
				<!--0902 채은열 추가 ***********************************************************************  -->
				<h3 class="bold">비밀번호 확인</h3>
				<form method='post' action="/member/customPass">
					<div class="member-info">
						<div>
							<input type='hidden' name='userid' value="${userid}">
						</div>
						<div>
							<input type='password' name='userpw' class="input" placeholder="비밀번호를 입력하세요.">
						</div>
						<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
						<div class="logout-info">	
							<c:if test="${not empty message}">
							    <div style="color: red;">
							        <p>${message}</p>
							    </div>
							</c:if>
						</div>
						<button class="inputButton" type="submit">확인</button>
					</div>
				</form>
			</div>
		</div>
<%@include file="./includes/footer.jsp"%>