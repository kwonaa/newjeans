<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@include file="../includes/header.jsp"%>
		<div class="row">
			<div class="col-lg-12 member">
				<h3 class="bold">수정/삭제</h3>
				<form role="form" action="/newjeans/modify" method="post">
					<div class="board-info">
						<!-- CSRF Token -->	
						<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
				        <input type='hidden' name='pageNum' value='<c:out value="${cri.pageNum }"/>'>
				        <input type='hidden' name='amount' value='<c:out value="${cri.amount }"/>'>
					    <input type='hidden' name='type' value='<c:out value="${cri.type }"/>'>
						<input type='hidden' name='keyword' value='<c:out value="${cri.keyword }"/>'>
						<input type='hidden' name='bno' value='<c:out value="${board.bno }"/>'>
				   <%-- <input type='hidden' name='writer' value='<c:out value="${board.writer }"/>'> --%>
					   <%-- <div class="form-group">
								<label>Bno</label> 
								<input class="form-control" name='bno' value='<c:out value="${board.bno}"/>' readonly="readonly">
							</div> --%>
						<div class="form-group">
					    	<label>카테고리</label> <br>
						    <div class="dropdown">
							    <select id="cnoDropdownMenu" name="cno">
							        <option value="1" ${board.cno == '1' ? 'selected' : ''}>정치</option>
							        <option value="2" ${board.cno == '2' ? 'selected' : ''}>경제</option>
							        <option value="3" ${board.cno == '3' ? 'selected' : ''}>연예</option>
							        <option value="4" ${board.cno == '4' ? 'selected' : ''}>문화</option>
							    </select>
							</div>
						</div>
						<div class="form-group">
							<label>제목</label> 
							<input class="form-control" name='title' value='<c:out value="${board.title}"/>' >
						</div>
						<div class="form-group">
							<label>내용</label>
							<textarea class="form-control textarea input_txt" rows="13" name='content'><c:out value="${board.content}"/></textarea>
							<p class="byte">0/2000</p>
						</div>
						<input type="hidden" class="form-control" name='writer' value='<c:out value="${board.writer}"/>' readonly="readonly">
						<input type="hidden" class="form-control" name='regDate' value='<fmt:formatDate pattern = "yyyy.MM.dd. HH:mm" value = "${board.regdate}" />' readonly="readonly">
						<input type="hidden" class="form-control" name='updateDate' value='<fmt:formatDate pattern = "yyyy/MM/dd" value = "${board.updateDate}" />' readonly="readonly">
						<!-- 첨부파일 목록 --------------------------------------------------------------------->
						<div class="row">
							<div class="col-lg-12">
								<label>첨부파일</label>
								<div class="panel-body uploadDiv">
									<div class="form-group">
									    <div class="file-upload">
										    <span class="clickable-text">여기를 클릭</span>
										    하여 파일을 첨부하거나 원하는 파일을 마우스로 끌어오세요.
										    <input type="file" name="uploadFile" multiple>
										</div>
									</div>
									<div class="uploadResult">
									    <!-- 첨부파일이 들어갈 자리 -->
									    <ul></ul>									    
								    </div>
								</div>
							</div>
						</div>
						<!-- 첨부파일 목록. end -->
					</div>
					<div>     
               			<sec:authorize access="hasRole('ROLE_MEMBER')">
							<button type="submit" data-oper='modify' class="btn btn-default">수정</button>
						</sec:authorize>
						<button type="submit" data-oper='remove' class="btn btn-danger">삭제</button>
						<button type="submit" data-oper='list' class="btn btn-info">목록</button>
					</div>
				</form>
			</div>
			<!-- /.col-lg-12 -->
		</div>
		<!-- row -->
		<!-- 원본 이미지 출력 --------------------------------------------------------->
		<div class='bigPictureWrapper'>
			<div class='bigPicture'>
			</div>
		</div>
		<!-- 원본 이미지 출력. end -->
		<script>
			/* 파일 크기. 파일 확장자 체크 (함수는 document.ready 밖에 만들기) *******************************************/
			function checkExtension(fileName, fileSize){
				var regex = new RegExp("(.*?)\.(jpg|jpeg|png|gif|bmp|webp|jfif)$", "i");
				var maxSize = 5242880; //5MB
				if(fileSize >= maxSize){
					alert("파일 사이즈 초과");
					return false;
				}
				if(!regex.test(fileName)){
					alert("해당 종류의 파일은 업로드할 수 없습니다.");
					return false;
				}
				return true;
			}
			/* 파일 크기. 파일 확장자 체크. end */
			/* 첨부파일목록 미리보기  ******************************************************************************/
			function showUploadResult(uploadResultArr){
				//첨부파일목록이 없으면 중지
				if(!uploadResultArr || uploadResultArr.length==0){
					return;
				}
				//출력할 ul태그 미리 찾아놓기
				var uploadUL=$(".uploadResult ul");
				var str="";
				// 첨부파일목록에서 하나씩 처리 
				$(uploadResultArr).each(function(i,obj){
					// 이미지인경우
					if(obj.image){
						// 썸네일경로
						var fileCallPath=encodeURIComponent(obj.uploadPath+"/"+obj.uuid+"_"+obj.fileName);
						str += "<li data-path='"+obj.uploadPath+"'";
						str += " data-uuid='"+obj.uuid+"' data-filename='"+obj.fileName+"' data-type='"+obj.image+"'>";
						str += "	<div>";
						str += "		<span>"+obj.fileName+"</span>";
						str += "        <button type='button' data-file='" + fileCallPath + "' ";
						str += "            data-type='image' class='btn btn-warning btn-circle'>";
						str += "            <i class='fa fa-times-circle' style='font-size: 18px; color: #ff6347;'></i>";
						str += "        </button><br>";
						str += "		<img src='/display?fileName="+fileCallPath+"'>";
						str += "	</div>";
						str += "</li>";					
					}
				});
				//ul태그에 출력
				uploadUL.append(str);
			}
			
			/* textarea 글자수 체크 ***************************************/
		    function calcBytes(str) {
		        let count = 0;
		        for (let i = 0; i < str.length; i++) {
		            let charCode = str.charCodeAt(i);
		            if (charCode <= 127) {
		                count++;
		            } else {
		                count += 2;
		            }
		        }
		        return count;
		    }
		
		    function truncateToBytes(str, maxBytes) {
		        let count = 0;
		        let truncated = '';
		        for (let i = 0; i < str.length; i++) {
		            let charCode = str.charCodeAt(i);
		            if (charCode <= 127) {
		                count++;
		            } else {
		                count += 2;
		            }
		            if (count > maxBytes) {
		                break;
		            }
		            truncated += str.charAt(i);
		        }
		        return truncated;
		    }
		    /* textarea 글자수 체크 end */
		    
			/* csrf토큰 처리 *****************************************************************/
			var csrfHeaderName ="${_csrf.headerName}"; 
			var csrfTokenValue="${_csrf.token}";
			$(document).ajaxSend(function(e, xhr, options) { 
		       xhr.setRequestHeader(csrfHeaderName, csrfTokenValue); 
		   	}); 
			$(document).ready(function() {
				/* csrf토큰 **********************************************************/
				var csrfHeaderName ="${_csrf.headerName}"; 
				var csrfTokenValue="${_csrf.token}";
				/* 버튼 이벤트 처리 **********************************************************/
				var formObj = $("form"); // form 태그 찾아놓기
				$('button').on("click", function(e) {
					e.preventDefault(); // 전송 방지
					var operation = $(this).data("oper"); // "data-oper" 속성값 읽기
					if (operation === 'remove') {
						formObj.attr("action", "/newjeans/remove"); // action 속성값 변경
					} else if (operation === 'list') {
						formObj.attr("action", "/newjeans/list").attr("method", "get"); // action 속성값 변경 // method 속성값 변경
						// bno, regdate, updatedate는 제외하고 전송
						var pageNumTag = $("input[name='pageNum']").clone(); // 복제
						var amountTag = $("input[name='amount']").clone();
						var keywordTag = $("input[name='keyword']").clone();
						var typeTag = $("input[name='type']").clone();      
						formObj.empty(); // 폼태그 내부의 자식태그를 모두 삭제
						formObj.append(pageNumTag); // 폼태그에 다시 추가
						formObj.append(amountTag);
						formObj.append(keywordTag);
						formObj.append(typeTag);	 
					} else if (operation === 'modify') {
						var str = "";
						// 첨부파일 목록에서 하나씩 처리
						$(".uploadResult ul li").each(function(i, obj){ // li 태그가 매개변수 obj로 들어감
							var jobj = $(obj);
							// hidden태그 생성
							str += "<input type='hidden' name='attachList["+i+"].fileName' value='"+jobj.data("filename")+"'>";
							str += "<input type='hidden' name='attachList["+i+"].uuid' value='"+jobj.data("uuid")+"'>";
							str += "<input type='hidden' name='attachList["+i+"].uploadPath' value='"+jobj.data("path")+"'>";
							str += "<input type='hidden' name='attachList["+i+"].fileType' value='"+ jobj.data("type")+"'>";
						});
						// formObj(form태그)에 hidden 태그 추가. 전송
						console.log(str);
						formObj.append(str).submit();
					}
					formObj.submit(); // 전송
				});
				/* 첨부파일 목록 **********************************************************/
			    var bno = '<c:out value="${board.bno}"/>'; //부모글번호  
			    $.getJSON("/newjeans/getAttachList", {bno: bno}, function(arr){  
			       var str = "";
			       //첨부파일목록 하나씩 처리
			       $(arr).each(function(i, attach){       
			         //이미지이면
			         if(attach.fileType){
			           //썸네일경로	
			           var fileCallPath = encodeURIComponent(attach.uploadPath+ "/"+attach.uuid +"_"+attach.fileName);
						str += "<li data-path='"+attach.uploadPath+"'";
						str += " data-uuid='"+attach.uuid+"' data-filename='"+attach.fileName+"' data-type='"+attach.fileType+"'>"
						str += "	<div>";
						str += "		<span>"+ attach.fileName+"</span>";
						str += "		<button type='button' data-file='"+fileCallPath+"' ";
						str += " 			data-type='image' class='btn btn-warning btn-circle'><i class='fa fa-times-circle' style='font-size: 18px; color: #ff6347;'></i>";
						str += "        </button><br>";
						str += "		<img src='/display?fileName="+fileCallPath+"'>";
						str += "	</div>";
						str += "</li>";
			         }
			       });
			       //ul태그에 출력
			       $(".uploadResult ul").html(str);
			     });
			    /* 첨부파일목록 x 버튼 이벤트 처리 *************************************************************/
			    $(".uploadResult").on("click", "button", function(e){
					console.log("delete file");
			        if(confirm("삭제하시겠습니까?")){
						var targetLi = $(this).closest("li"); // 가장 가까운 부모 li 태그를 찾음
						targetLi.remove();
					}
				}); 
			    /* 첨부파일을 선택했을 때 이벤트 처리 ******************************************************************/
				$("input[type='file']").change(function(e){
					//form태그 역할하는 객체
					var formData=new FormData();
					var inputFile=$("input[name='uploadFile']"); // input type='file' 미리 찾아놓기.
					var files=inputFile[0].files; // 첨부파일목록
					for(var i=0;i<files.length;i++){
						//파일확장자,파일사이즈가 안맞으면 중지
						if(!checkExtension(files[i].name,files[i].size)){
							return false;
						}
						//formData에 파일추가
						formData.append("uploadFile",files[i]);
					}
					$.ajax({
						url:'/uploadAjaxAction', //서버주소
						processData: false, // 파일업로드시 설정필요
						contentType: false, // 파일업로드시 설정필요
						beforeSend: function(xhr) { // csrf토큰적용
					          xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
					      },				
						data:formData, // 서버로 전송되는 데이터
						type: "post",  //전송방식
						dataType: 'json', //서버에서 넘어오는 데이터의 형식
						success:function(result){ //성공하면 호출되는 함수. result에 서버에서 넘어온 데이터가 저장됨.
							showUploadResult(result); //첨부파일목록 미리보기 출력
						}
					});
				});
				/* 파일 드래그 시 새창으로 열리는 것 방지 ******************************************/
				$(".uploadResult").on("dragenter dragover",function(event){ // 이벤트를 두개 써도 됨.(dragenter, dragover)
					// 기본 이벤트 취소. 새창이 열리는 것 방지
					event.preventDefault();
				});
				/* 파일 드롭 시 새창으로 열리는 것 방지. 파일 업로드 **********************************/
			    $(".uploadResult").on("drop",function(e){
					// 기본 이벤트 취소.새창이 열리는 것 방지
					event.preventDefault();
					//form태그 역할하는 객체
					var formData=new FormData();
					// drop했을 때 파일 목록 구하기
					var files=e.originalEvent.dataTransfer.files;
					for(var i=0;i<files.length;i++){
						//파일확장자,파일사이즈가 안맞으면 중지
						if(!checkExtension(files[i].name,files[i].size)){
							return false;
						}
						//formData에 파일추가
						formData.append("uploadFile",files[i]);
					}
					$.ajax({
						url:'/uploadAjaxAction', //서버주소
						processData: false, // 파일업로드시 설정필요
						contentType: false, // 파일업로드시 설정필요
						beforeSend: function(xhr) { //csrf토큰적용
					          xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
					      },				
						data:formData, // 서버로 전송되는 데이터
						type: "post",  //전송방식
						dataType: 'json', //서버에서 넘어오는 데이터의 형식
						success:function(result){ //성공하면 호출되는 함수. result에 서버에서 넘어온 데이터가 저장됨.
							showUploadResult(result); //첨부파일목록 미리보기 출력
						}
					});
			    });
				
			    /* textarea 글자수 체크 */
			    $('.textarea.input_txt').on('input', function() {
			        let content = $(this).val(); 
			        let bytes = calcBytes(content);
			        const maxLength = 2000;

			        $('.byte').text(bytes + '/' + maxLength);

			        if (bytes > maxLength) {
			            alert("최대 2000바이트까지 입력 가능합니다.");
			            let trimmedContent = truncateToBytes(content, maxLength);
			            $(this).val(trimmedContent);
			            $('.byte').text(maxLength + '/' + maxLength);
			        }
			    });
			    
			});
		</script>
<%@include file="../includes/footer.jsp"%>