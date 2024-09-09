<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>뉴眞스 홈페이지</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f9f9f9; /* 밝은 배경색 */
            color: #333; /* 어두운 텍스트 색상 */
            text-align: center;
            margin: 0;
            padding: 0;
        }
        .index {
            margin-top: 150px; /* 위쪽 여백 조정 */
            margin-bottom: 30px; /* 아래쪽 여백 조정 */
        }
        img {
            width: 500px; /* 이미지 크기 조정 */
            height: auto;
            margin-bottom: 20px;
        }
        a {
            text-decoration: none;
            color: black; /* 부드러운 파란색 텍스트 */
            font-size: 17px; /* 기본 폰트 크기 */
            font-weight: 600; /* 약간 두꺼운 글씨 */
            padding: 10px 20px; /* 패딩 추가 */
            border: 2px solid silver; /* 부드러운 파란색 테두리 */
            border-radius: 5px; /* 둥근 모서리 */
            background-color: #ffffff; /* 흰색 배경 */
            display: inline-block;
            transition: all 0.3s ease; /* 부드러운 전환 효과 */
            animation: colorChange 2s ease infinite; /* 색상 애니메이션 */
        }
        
        a:hover {
            background-color: #e7f0ff; /* 호버 시 배경색 변화 */
            border-color: #003d79; /* 호버 시 테두리 색상 변화 */
            color: #003d79; /* 호버 시 텍스트 색상 변화 */
            transform: scale(1.05); /* 호버 시 크기 약간 증가 */
        }

        @keyframes colorChange {
            0% { color: black; }
            50% { color: #4a90e2; border-color: #4a90e2; }
            100% { color: black; }
        }
    </style>
</head>
<body>
    <div class="index">
        <img src='/resources/img/newJeansLogo.png' alt="Logo">
    </div>
    <a href="/newjeans/list">홈페이지로 이동하기</a>
</body>
</html>