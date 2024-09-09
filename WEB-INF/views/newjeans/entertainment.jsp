<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@include file="../includes/header.jsp"%>
		<!-- 검색폼 ----------------------------------------------------------->
        <div class="row">
        	<div class="col-sm-12">
		        <form id="searchForm" action="/newjeans/list" method="get" class="input-group mb-3" style="display: flex">
		         	<select name="type" class="form-control" style="width: 130px;">
		         		<%-- <option value="" <c:out value="${pageMaker.cri.type==null?'selected':''}"/>>--</option> --%>
	              		<option value="T" <c:out value="${pageMaker.cri.type eq 'T'?'selected':''}"/>>제목</option>
	              		<option value="C" <c:out value="${pageMaker.cri.type eq 'C'?'selected':''}"/>>내용</option>
	              		<option value="TC" <c:out value="${pageMaker.cri.type eq 'TC'?'selected':''}"/>>제목 + 내용</option>
	            	</select>
		         	<input type="text" name="keyword" value='<c:out value="${pageMaker.cri.keyword }"/>' class="form-control" placeholder="검색어를 입력하세요." style="width: 170px;">
		         	<input type="hidden" name="pageNum" value="${pageMaker.cri.pageNum}">
		         	<input type="hidden" name="amount" value="${pageMaker.cri.amount}">
		         	<button class="btn btn-primary btn-md"><i class="fa fa-search"></i></button>
		        </form>
        	</div>
        </div>
        <!-- 검색폼.end -->  
		<div class="row">
			<div class="col-lg-12">
				<h3 class="page-header noBorder">연예</h3>
			</div>
		</div>
		<div class="row">
			<div class="col-lg-12">
				<div class="panel panel-default noborder">
					<div class="panel-body" style="position:relative;">
						<table class="table table-hover">
							<c:forEach items="${listEtm}" var="board">
								<tr>
									<td style="position: relative; width:230px; height: 170px;">
										<c:forEach items="${board.attachList}" var="attach">
											<c:if test="${attach.fileType}">
												<img class="pic" src="/display?fileName=${fn:replace(attach.uploadPath,'\\','/')}/${attach.uuid}_${attach.fileName}" alt="기사 이미지" style="width: 100%; height: 100%; object-fit: cover;">                      
											</c:if>
										</c:forEach>							
									</td>
									<td>
										<c:choose>
							                <c:when test="${board.cno == 1}">정치</c:when>
							                <c:when test="${board.cno == 2}">경제</c:when>
							                <c:when test="${board.cno == 3}">연예</c:when>
							                <c:when test="${board.cno == 4}">문화</c:when>
							            </c:choose> &gt;<br>
										<h4><a class="title" href='/newjeans/get?bno=<c:out value="${board.bno}"/>'><c:out value="${board.title}"/></a></h4><br>
										<p class="ellipsis"><c:out value="${board.content}" /></p>
										<fmt:formatDate pattern="yyyy.MM.dd. HH:mm" value="${board.updateDate}" />
									</td> 
								</tr>
							</c:forEach>
						</table>
		                <!-- 더보기 버튼 -->
		                <div class="text-center">
		                    <button id="loadMore" class="btn btn-primary">더보기</button>
		                </div>
		
				   <%-- <!-- page번호 출력 ------------------------------------------------------>
		                <div class="pull-right">
						    <ul class="pagination">
						        <c:if test="${pageMaker.prev}">
						            <li class="paginate_button previous">
						                <a href="?cno=${param.cno}&pageNum=${pageMaker.startPage-1}">Previous</a>
						            </li>
						        </c:if>
						
						        <c:forEach var="num" begin="${pageMaker.startPage}" end="${pageMaker.endPage}">
						            <li class="paginate_button ${pageMaker.cri.pageNum==num? 'active' : ''}">
						                <a href="?cno=${param.cno}&pageNum=${num}">${num}</a>
						            </li>
						        </c:forEach>
						
						        <c:if test="${pageMaker.next}">
						            <li class="paginate_button next">
						                <a href="?cno=${param.cno}&pageNum=${pageMaker.endPage+1}">Next</a>
						            </li>
						        </c:if>
						    </ul>
						</div>
		                <!-- page번호출력.end --> --%>
		                <!-- page번호 이벤트 처리시 필요한 form -------------------------------------------->
		                <form id="actionForm" action="/newjeans/entertainment" method="get">
		                	<input type="hidden" name="pageNum" value="${pageMaker.cri.pageNum}">
		                	<input type="hidden" name="amount" value="${pageMaker.cri.amount}">
		                	<input type="hidden" name="type" value='<c:out value="${pageMaker.cri.type}"/>'>
		                	<input type="hidden" name="keyword" value='<c:out value="${pageMaker.cri.keyword}"/>'>
		                	<input type="hidden" name="total" value="${total}"> <!-- 총 데이터 개수 -->
		                </form>
		                <!-- page번호 이벤트 처리시 필요한 form.end -->
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
						<!-- 모달 --------------------------------------------------------------------------------->
						<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
							<div class="modal-dialog">
								<div class="modal-content">
									<div class="modal-header">
										<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
										<h4 class="modal-title" id="myModalLabel">알림</h4>
									</div>
									<div class="modal-body">처리가 완료되었습니다.</div>
									<div class="modal-footer">
										<button type="button" class="btn btn btn-primary" data-dismiss="modal">닫기</button>
									</div>
								</div>
								<!-- /.modal-content -->
							</div>
							<!-- /.modal-dialog -->
						</div>
						<!-- 모달 end -->
					</div>
					<!-- /.panel-body -->
				</div>
				<!-- /.panel -->
			</div>
			<!-- /.col-lg-12 -->
		</div>
		<!-- col -->
		<script>
			$(document).ready(function() {
				/* 등록된 글번호 *********************/
				var result = '<c:out value="${result}"/>';
				checkModal(result);
				/* 모달창 띄우기 *********************/
				function checkModal(result) {
					if (result === '') {
						return;
					}
					if (parseInt(result) > 0) {
						$(".modal-body").html("게시글 " + parseInt(result) + " 번이 등록되었습니다.");
					}
					$("#myModal").modal("show");
				}
				/* 페이지 번호 이벤트 처리 *********************/
				var actionForm = $("#actionForm"); // id "actionForm"을 미리 찾아놓음
				$(".paginate_button a").on("click", function(e) {
				    e.preventDefault(); // 링크를 클릭했을 때 다음 주소로 넘어가는 것을 방지
				    var pageNum = $(this).text(); // 링크의 텍스트를 사용하여 페이지 번호 설정
				    if (pageNum === 'Previous') {
				        pageNum = pageMaker.startPage - 1; // 이전 페이지 번호
				    } else if (pageNum === 'Next') {
				        pageNum = pageMaker.endPage + 1; // 다음 페이지 번호
				    }
				    actionForm.find("input[name='pageNum']").val(pageNum);
				    actionForm.attr("action","/newjeans/entertainment"); // 목록으로 전송
				    actionForm.submit(); // Form 전송
				});
		        /* 제목 클릭 시 이벤트처리 **********************************/
		        $(".move").on("click",function(e){
		           e.preventDefault(); //기본이벤트방지.다른페이지로 넘어가는 것 방지
		           
		           // if문으로 제어해서 bno가 한번만 append되도록 변경
		            if(!actionForm.find("input[name='bno']").val()) {               
						actionForm.append("<input type='hidden' name='bno' value='"+$(this).attr("href")+"'>");
						actionForm.attr("action","/newjeans/get"); //상세보기로 변경                                    
		            } else {
		            	actionForm.find("input[name='bno']").val($(this).attr("href"));
		            }
		            actionForm.attr("action","/newjeans/get");
					actionForm.submit();//폼전송
		        });
			/*	$(".move").on("click",function(e) {
					e.preventDefault(); // 기본이벤트 방지. 다른 페이지로 넘어가는 것 방지.
					$("#actionForm").append("<input type='hidden' name='bno' value='" + $(this).attr("href") + "'>")
					.attr("action", "/newjeans/get") // 상세보기로 변경
					.submit(); // 폼전송
				}); */
				/* 더보기 버튼 이벤트 처리 ******************************************************************************/
		        let pageNum = ${pageMaker.cri.pageNum}; // 현재 페이지 번호
		        const pageSize = 10; // 페이지당 데이터 수 (서버와 일치해야 함)
		        const totalDataCount = ${total}; // 서버에서 반환된 총 데이터 개수
		        $('#loadMore').on('click', function() {
		            pageNum += 1; // 다음 페이지 번호로 업데이트
		            $.ajax({
		                url: '/newjeans/entertainment', // 데이터 요청 URL
		                type: 'GET',
		                data: {
		                    pageNum: pageNum
		                },
		                success: function(response) {
		                    const $response = $(response);
		                    const newItems = $response.find('.table tbody').html(); // 새로 로드된 데이터의 HTML
		                    const newTotal = $response.find('input[name="total"]').val(); // 새로 로드된 총 데이터 개수
		                    // 기존 테이블에 새 데이터 추가
		                    $('table.table tbody').append(newItems);
		                    // 페이지 네비게이션 업데이트 (Optional)
		                    const newPageMaker = $response.find('.pagination').html();
		                    $('.pagination').html(newPageMaker);
		                    // 로드된 데이터 개수
		                    const loadedDataCount = $('table.table tbody tr').length;
		                    // 전체 데이터와 비교하여 버튼 표시 여부 결정
		                    if (loadedDataCount >= totalDataCount) {
		                        $('#loadMore').hide(); // 전체 데이터가 로드되었으면 버튼 숨기기
		                    }
		                },
		                error: function() {
		                    alert('데이터를 로드하는 중 오류가 발생했습니다.');
		                }
		            });
		        });
		        // 페이지 로드 시 초기 상태 결정
		        const initialLoadedDataCount = $('table.table tbody tr').length;
		        if (initialLoadedDataCount >= totalDataCount) {
		            $('#loadMore').hide(); // 초기 페이지 로드 시 전체 데이터가 로드되었으면 버튼 숨기기
		        } else {
		            $('#loadMore').show(); // 초기 페이지 로드 시 전체 데이터가 로드되지 않았으면 버튼 표시
		        }		
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
<%@include file="../includes/footer.jsp"%>