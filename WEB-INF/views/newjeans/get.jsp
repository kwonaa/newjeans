<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags"
	prefix="sec"%>
<%@ include file="../includes/header.jsp"%>
		<!--0903 채은열 추가 ***********************************************************************************  -->
		<sec:authorize access="hasRole('ROLE_ADMIN')">
			<script type="text/javascript">var isAdmin = true;</script>
		</sec:authorize>
		<sec:authorize access="!hasRole('ROLE_ADMIN')">
			<script type="text/javascript">var isAdmin = false;</script>
		</sec:authorize>
		<sec:authorize access="hasRole('ROLE_ADMIN')">
			<c:set var="isAdmin" value="true" />
		</sec:authorize>
		<sec:authorize access="!hasRole('ROLE_ADMIN')">
			<c:set var="isAdmin" value="false" />
		</sec:authorize>
		<!--0903 채은열 추가 ***********************************************************************************  -->
		<div class="row">
			<div class="col-lg-12">
				<div class="panel panel-default get">
					<div class="panel-body" style="position:relative">
						<input class="form-control" name="cno" value='<c:choose><c:when test="${board.cno == 1}">정치</c:when><c:when test="${board.cno == 2}">경제</c:when><c:when test="${board.cno == 3}">연예</c:when><c:when test="${board.cno == 4}">문화</c:when></c:choose> &gt;' readonly>
						<div class="form-group">
							<!-- <label>Title</label> -->
							<%-- <input class="form-control" name="title" value='<c:out value="${board.title}"/>' readonly> --%>
							<h2 class="bold" name="title"><c:out value="${board.title}" /></h2>
							<!-- <label>Writer</label> -->
							<input class="form-control" name="writer"
								value='<c:out value="${board.username} 기자"/>' readonly>
							<!-- <label>UpdateDate</label> -->
							<input class="form-control" name="updateDate"
								value='업데이트 <fmt:formatDate value="${board.updateDate}" pattern="yyyy.MM.dd. HH:mm"/>' readonly>
						</div>
						<div class="form-group">
							<!-- <label>Content</label> -->
							<div class="row">
								<div class="col-lg-12">
									<div class="panel panel-default noborder">
										<div class="panel-body">
											<!-- 첨부파일 목록 출력 -->
											<div class='uploadResult'>
												<ul>
												</ul>
											</div>
										</div>
									</div>
								</div>
							</div>
							<div class="row">
								<div class="col-sm-12 getContent">
							        <div class="content-div">
							            <c:out value="${board.content}" />
							        </div>
							    </div>
							</div>
						</div>
						<!-- 첨부파일 크게 보기 ------------------------------------------------------------------->
						<div class='bigPictureWrapper'>
							<div class='bigPicture'></div>
						</div>
						<div class>
							<!-- principal을 pinfo 변수에 저장 -->
							<sec:authentication property="principal" var="pinfo" />
							<!-- 로그인을 했으면 -->
							<sec:authorize access="isAuthenticated()">
								<!-- 아이디가 작성자와 같으면 -->
								<!--0903 채은열 수정 ***********************************************************************************  -->
								<c:if test="${pinfo.username eq board.writer || isAdmin}">
									<button data-oper='modify' class="btn btn-danger">
										<a href="/newjeans/modify?bno=<c:out value='${board.bno}'/>">수정/삭제</a>
									</button>
								</c:if>
							</sec:authorize>
							<button data-oper='list' class="btn btn-info">
								<a href="/newjeans/list">목록</a>
							</button>
						</div>
					</div>
					<!-- 사이드바 영역 ------------------------------------------------------------------------->
					<div class="panel panel-default top5Posts">
						<div class="panel-body">
							<ul>
								<!-- 여기서 top5Posts.jsp를 포함하여 사이드바 내용을 로드 -->
								<%@ include file="./top5Posts.jsp"%>
							</ul>
						</div>
					</div>
					<!-- 위로 가기, 아래로 가기 ------------------------------------------------------------------>
					<div id="upDown">
					    <a href="#header" class="scroll-link" data-target="#header">
					        <img src='/resources/img/up.png' alt="up">
					    </a>
					    <a href="#footer" class="scroll-link" data-target="#footer">
					        <img src='/resources/img/down.png' alt="down">
					    </a>
					</div>
				</div>
			</div>
		</div>
		<!-- 댓글목록 ---------------------------------------------------------------->
		<div class="row comments">
			<div class="col-lg-12">
				<div class="panel panel-default">
				    <div class="panel-heading">
				        <i class="fa fa-comments fa-fw"></i> 댓글
				        <!-- 로그인한 경우만 댓글등록 버튼 출력 -->
				        <sec:authentication property="principal" var="pinfo" />
				        <sec:authorize access="isAuthenticated()">
				            <div class="comment-form">
				                <input id="replyer" class="form-control" name="replyer"
				                    type="text" value="${pinfo.username}" readonly style="display: none;">
				                <input id="reply" class="form-control" name="reply"
				                    type="text" placeholder="댓글을 입력해주세요.">
				                <button id="RegisterBtn" type="button" class="btn btn-info">등록</button>
				            </div>
				        </sec:authorize>
				        <!-- 로그인하지 않은 경우 표시되는 입력 필드 -->
				        <sec:authorize access="!isAuthenticated()">
				            <input type="text" name="reply" class="form-control"
				                placeholder="로그인 해주세요" id="nologin">
				        </sec:authorize>
				    </div>
				    <div class="panel-body">
				        <!-- 댓글목록 출력 UL태그 -->
				        <ul class="chat"></ul>
				    </div>
				    <div class="panel-footer"></div>
				</div>
			</div>
		</div>
		<!-- 댓글목록.end ---------------------------------------------------------->
		<!-- 로그인 알림 모달 ------------------------------------------------------->
		<div class="modal fade" id="loginModal" tabindex="-1" role="dialog"
			aria-labelledby="loginModalLabel" aria-hidden="true">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal"
							aria-hidden="true">&times;</button>
						<h4 class="modal-title" id="loginModalLabel">로그인 후 사용해주세요.</h4>
					</div>
					<div class="modal-body">댓글을 작성하려면 로그인이 필요합니다.</div>
					<div class="modal-footer">
						<button id="goToLoginBtn" type="button" class="btn btn-primary">로그인
							이동</button>
						<button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>
					</div>
				</div>
			</div>
		</div>
		<!-- 삭제창 알림 모달 -->
		<div class="modal fade" id="RemoveModal" tabindex="-1" role="dialog"
			aria-labelledby="RemoveModalLabel" aria-hidden="true">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal"
							aria-hidden="true">&times;</button>
						<h4 class="modal-title" id="RemoveModalLabel">삭제</h4>
					</div>
					<div class="modal-body">삭제하시겠습니까?</div>
					<div class="modal-footer">
						<button id='modalRemoveBtn' type="button" class="btn btn-danger">삭제</button>
						<button id='modalCloseBtn' type="button" class="btn btn-default">닫기</button>
					</div>
				</div>
			</div>
		</div>
		<!-- 히든태그에 값을 넣어서 전송하기위한 폼 ---------------------------------------->
		<form id="operForm" action="/newjeans/modify" method="get">
			<input type="hidden" id="bno" name="bno" value='<c:out value="${board.bno}"/>'> 
			<input type="hidden" name="pageNum" value='<c:out value="${cri.pageNum}"/>'> 
			<input type="hidden" name="amount" value='<c:out value="${cri.amount}"/>'>
			<input type="hidden" name="keyword"	value='<c:out value="${cri.keyword}"/>'> 
			<input type="hidden" name="type" value='<c:out value="${cri.type}"/>'>
		</form>
		<!-- 히든태그에 값을 넣어서 전송하기위한 폼.end -->
		<script>
			/* csrf 토큰 처리 *******************************************************************************/
			var csrfHeaderName ="${_csrf.headerName}"; 
			var csrfTokenValue="${_csrf.token}";
		/* 	$(document).ajaxSend(function(e, xhr, options) { 
				xhr.setRequestHeader(csrfHeaderName, csrfTokenValue); 
			});  */
			/* 댓글작성자 + js에 삭제버튼에 replyer 넘기기 ****************************************************************************/
			var replyer="";
			<sec:authorize access="isAuthenticated()">	
				replyer = '<sec:authentication property="principal.username"/>';   		    
			</sec:authorize>
			/* upDown button smooth */
			document.querySelectorAll('.scroll-link').forEach(link => {
			    link.addEventListener('click', function (e) {
			        e.preventDefault(); // 기본 링크 동작 방지

			        const targetId = this.getAttribute('data-target');
			        const targetElement = document.querySelector(targetId);

			        if (targetElement) {
			            window.scrollTo({
			                top: targetElement.offsetTop,
			                behavior: 'smooth' // 부드러운 스크롤 애니메이션
			            });
			        }
			    });
			});
			/* upDown button smooth */
			document.querySelectorAll('.scroll-link').forEach(link => {
			    link.addEventListener('click', function (e) {
			        e.preventDefault(); // 기본 링크 동작 방지

			        const targetId = this.getAttribute('data-target');
			        const targetElement = document.querySelector(targetId);

			        if (targetElement) {
			            window.scrollTo({
			                top: targetElement.offsetTop,
			                behavior: 'smooth' // 부드러운 스크롤 애니메이션
			            });
			        }
			    });
			});
		</script>
		<script src="/resources/js/reply3.js?bno=<c:out value='${board.bno}'/>"></script>
<%@ include file="../includes/footer.jsp"%>
