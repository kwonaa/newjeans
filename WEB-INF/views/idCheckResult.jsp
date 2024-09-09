<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>아이디 중복체크</title>
	<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
	<style>
        body {
            background-color: #fff; /* 배경을 흰색으로 설정 */
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        .container {
            background: #fff; /* 카드 배경을 흰색으로 설정 */
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            text-align: center; /* 컨테이너 내 텍스트 중앙 정렬 */
        }
        .error {
            color: #dc3545;
        }
        .ok {
            color: #28a745;
        }
        .btn-custom {
            background-color: #8c8c8c; /* 진한 회색 배경 */
            color: #fff;
            border: none; /* 테두리 없음 */
            font-size:13px;
        }
        .btn-custom:hover {
            background-color: #6c757d; /* 어두운 회색 배경 */
            color: #000; /* 텍스트 색상 검정 */
        }
        .form-inline {
            display: flex;
            justify-content: center; /* 중앙 정렬 */
            align-items: center;
        }
        .form-inline .form-group {
            margin-bottom: 0;
        }
        .form-inline .form-control {
            width: auto;
            flex: 1;
            margin-right: 10px; /* 버튼과 입력 필드 사이의 간격 */
            background-color: #fff; /* 입력 필드 배경을 흰색으로 설정 */
            border: 1px solid #ced4da; /* 입력 필드의 테두리 색상 */
        }
        .form-inline .btn {
            margin-bottom: 0;
            background-color: #8c8c8c; /* 진한 회색 배경 */
            color: #fff;
            border: none;
            font-size:13px;
        }
        .form-inline .btn:hover {
            background-color: #6c757d; /* 어두운 회색 배경 */
            color: #000; /* 텍스트 색상 검정 */
        }
        .text-center-custom {
            text-align: center;
        }
    </style>
    <script>
        function idok(id, isAvailable) {
            if (window.opener && !window.opener.closed) {
                window.opener.document.getElementById('userid').value = id;
                window.opener.setIdAvailability(isAvailable);
            }
            window.close(); // 현재 창 닫기
        }
    </script>
</head>
<body>
    <div class="container">
        <h5 class="text-center mb-4">아이디 중복체크</h5>
        <form action="checkId" method="get" name="frm">
            <div class="form-inline mb-3">
                <div class="form-group">
                    <label for="userid" class="sr-only">아이디</label>
                    <input type="text" id="userid" name="userid" class="form-control" value="${param.userid}" required placeholder="아이디 입력">
                </div>
                <button type="submit" class="btn btn-custom">중복체크</button>
            </div>
            <div class="text-center-custom mt-3">
                <c:if test="${result == 1}">
                    <p>${param.userid}는 <span class="error">이미 사용 중인</span> 아이디입니다.</p>
                </c:if>
                <c:if test="${result == -1}">
                    <p>${param.userid}는 <span class="ok">사용 가능한</span> 아이디입니다.</p>
                    <button type="button" class="btn btn-custom" onclick="idok('${param.userid}',true)">사용</button>
                </c:if>
            </div>
        </form>
    </div>
</body>
</html>