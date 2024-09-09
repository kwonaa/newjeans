<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!-- 태그라이브러리 등록 -->
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>뉴眞스</title>
    
    <!-- Bootstrap Core CSS -->
    <link href="/resources/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <!-- MetisMenu CSS -->
    <link href="/resources/vendor/metisMenu/metisMenu.min.css" rel="stylesheet">
    <!-- DataTables CSS -->
    <link href="/resources/vendor/datatables-plugins/dataTables.bootstrap.css" rel="stylesheet">
    <!-- DataTables Responsive CSS -->
    <link href="/resources/vendor/datatables-responsive/dataTables.responsive.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="/resources/dist/css/sb-admin-2.css" rel="stylesheet">
    <!-- Custom Fonts -->
    <link href="/resources/vendor/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
        <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
        <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->
</head>
<body>
    <div id="wrapper">
        <div class="header1" id="header">
          	<%-- 현재 날짜를 java.util.Date 객체로 생성하고 페이지 스코프에 설정 --%>
			<%
			    java.util.Date today = new java.util.Date();
			    request.setAttribute("today", today); // JSP의 request 스코프에 날짜 설정
			%>
            <div class="today">
                <!-- 2024년 09월 06일 -->
                <fmt:formatDate value="${today}" pattern="yyyy년 MM월 dd일" />
            </div>
            <div class="newJeans">
                <a href="/newjeans/list"><img src='/resources/img/newJeans.png' alt="Logo"></a>
            </div>
            <div class="register">
                <sec:authorize access="hasRole('ROLE_ADMIN') OR hasRole('ROLE_MEMBER')">
                    <button type="button" onclick="location.href='/newjeans/register';" class="btn btn-default">기사 작성하기</button>
               </sec:authorize>
               <sec:authorize access="!hasRole('ROLE_ADMIN') AND !hasRole('ROLE_MEMBER')">
                  <button type="button" class="btn btn-default" style="visibility: hidden; width:110px;">&nbsp;</button>
              </sec:authorize>
            </div>
        </div>
        <div class="container header2">
            <div class="row text-center">
                <div class="col-sm-4">
                    <div>
                    </div>
                </div>
                <div class="col-sm-4">
                    <div class="link-container">
						<a href="/newjeans/politics">정치</a>
						<a href="/newjeans/financial">경제</a>
						<a href="/newjeans/entertainment">연예</a>
						<a href="/newjeans/culture">문화</a>
                    </div>
                </div>
                <div class="col-sm-4">
                    <nav class="navbar navbar-default">
                        <div class="container-fluid">
                            <ul class="nav navbar-nav navbar-right">
                                <li class="dropdown">
                                    <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">
                                        <i class="fa fa-user fa-fw"></i> <i class="fa fa-caret-down"></i>
                                    </a>
                                    <ul class="dropdown-menu">
                                        <sec:authorize access="isAnonymous()">
                                            <li><a href="/customLogin"><i class="fa fa-sign-in fa-fw"></i> 로그인</a></li>
                                            <li><a href="/member/customSignup"><i class="fa fa-user fa-fw"></i> 회원가입</a></li>
                                        </sec:authorize>
                                        <sec:authorize access="isAuthenticated()">
                                            <li><a href="/customLogout"><i class="fa fa-sign-out fa-fw"></i> 로그아웃</a></li>
	                                        <li class="divider"></li>
	                                        <li><a href="/member/customMemberInfo"><i class="fa fa-user fa-fw"></i> 회원정보확인</a></li>
                                        </sec:authorize>
                                    </ul>
                                </li>
                            </ul>
                        </div>
                    </nav>
                </div>
            </div>
        </div>
        <div id="page-wrapper">
    	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
