<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@include file="../includes/header.jsp"%>
		<div class="row">
			<div class="col-lg-12 member">
				<h3 class="bold">글쓰기</h3>
				<form role="form" action="/newjeans/register" method="post" onsubmit="return validateForm(this);">
					<div class="board-info">
						<!-- CSRF Token -->
						<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
						<div class="form-group">
							<label>카테고리</label>
							<div class="dropdown">
						        <select id="cnoDropdownMenu" name="cno">
						            <option value="1">정치</option>
						            <option value="2">경제</option>
						            <option value="3">연예</option>
						            <option value="4">문화</option>
						        </select>
						    </div>
						</div>
						<div class="form-group">
							<label>제목</label>
							<input class="form-control" name="title">
						</div>
						<div class="form-group">
							<label>내용</label>
							<textarea class="form-control textarea input_txt" rows="13" name="content"></textarea>
							<p class="byte">0/2000</p>
						</div>
						<div class="form-group">
							<input type="hidden" class="form-control" name="writer" value='<sec:authentication property="principal.username"/>' >
						</div>
						<!-- 첨부파일 ------------------------------------------------------------>
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
					</div>
					<div>
						<button type="submit" class="btn btn-primary">등록</button>
						<button type="button" onclick="location.href='/newjeans/list';" class="btn btn-default">목록</button>
					</div>
				</form>
			</div>
		</div>
		<script>
			/* 필수 항목 입력 확인 ********************/
			function validateForm(form) {
				if(form.title.value == ""){
					alert("제목을 입력하세요.");
					form.title.focus();
					return false;
				}
				if(form.content.value == ""){
					alert("내용을 입력하세요.");
					form.content.focus();
					return false;
				}
				if(form.writer.value == ""){
					alert("작성자를 입력하세요.");
					form.writer.focus();
					return false;
				}
			}
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
			/* 첨부파일 목록 미리보기 ************************************************************/
			function showUploadResult(uploadResultArr){
				// 첨부파일 목록이 없으면 중지
				if(!uploadResultArr || uploadResultArr.length == 0){
					return;
				}
				// 출력할 ul 태그 미리 찾아놓기
				var uploadUL = $(".uploadResult ul");
				var str ="";
				// 첨부파일 목록에서 하나씩 처리
				$(uploadResultArr).each(function(i, obj){	
					if(obj.image){ // 이미지 파일일 때
						// 썸네일 경로
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
				uploadUL.append(str); // ul 태그에 추가
			}
			/* 첨부파일 목록 미리보기 end */
			
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
			$(document).ready(function(e){
				 // "여기를 클릭" 텍스트 클릭 시 파일 선택 창 열기
			    $(".file-upload .clickable-text").click(function(){
			        $(this).closest(".file-upload").find("input[type='file']").click();
			    });
				/* 첨부파일을 선택했을 때 이벤트 처리 ***************************************/
				$("input[type='file']").change(function(e){
					// form 태그 역할을 하는 객체
					var formData = new FormData();
					var inputFile = $("input[name='uploadFile']"); // input type="file" 미리 찾아놓기
					var files = inputFile[0].files; // 첨부파일 목록
					for(var i = 0; i < files.length; i++){
						// 파일 확장자, 파일 사이즈가 안 맞으면 중지
						if(!checkExtension(files[i].name, files[i].size) ){
							return false;
						}
						// formData에 파일 추가
						formData.append("uploadFile", files[i]);
					}
					$.ajax({
						url: '/uploadAjaxAction', // 서버 주소
						processData: false, // 파일 업로드 시 설정 필요
						contentType: false, // 파일 업로드 시 설정 필요
					    beforeSend: function(xhr) {
					        xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
					    },				
						data: formData, // 서버로 전송되는 데이터
						type: 'post', // 전송방식
						dataType:'json', // 서버에서 넘어오는 데이터의 형식
						success: function(result){ // 성공하면 호출되는 함수. result에 서버에서 넘어온 데이터가 저장됨.
							console.log(result); 
							showUploadResult(result); // 첨부파일 목록 미리보기 출력
						}
					});
				}); 
				/* x버튼 클릭 이벤트 처리. 파일 삭제 **********************************************/
				// 부모인 .uploadResult에 click이벤트를 위임
				$(".uploadResult").on("click", "button", function(e){
					console.log("delete file");
					var targetFile = $(this).data("file"); // data-file 속성값 읽어오기
					var type = $(this).data("type"); // data-type 속성값 읽어오기
					var targetLi = $(this).closest("li"); // 가장 가까운 부모태그 li 찾아오기
					$.ajax({
						url: '/deleteFile', // 서버주소
						data: {fileName: targetFile, type:type}, // 서버로 전송되는 데이터
					    beforeSend: function(xhr) {
					        xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
					    },				
						dataType:'text', // 서버에서 넘어오는 데이터 형식
						type: 'POST', // 전송방식
						success: function(result){ // 성공했을 때 호출되는 함수. 서버에서 넘어온 데이터는 result에 저장됨
							alert(result);
							targetLi.remove(); // li 태그 삭제. 첨부파일 목록 삭제
						}
					});
				});		
			    /* 등록버튼 이벤트 처리 *******************************************************/
				var formObj = $("form[role='form']"); // form 태그 찾아놓기
				$("button[type='submit']").on("click", function(e){
					e.preventDefault(); // 전송 방지
					var str = "";
					// 첨부파일 목록에서 하나씩 처리
					$(".uploadResult ul li").each(function(i, obj){ // li 태그가 매개변수 obj로 들어감
						var jobj = $(obj);
						str += "<input type='hidden' name='attachList["+i+"].fileName' value='"+jobj.data("filename")+"'>";
						str += "<input type='hidden' name='attachList["+i+"].uuid' value='"+jobj.data("uuid")+"'>";
						str += "<input type='hidden' name='attachList["+i+"].uploadPath' value='"+jobj.data("path")+"'>";
						str += "<input type='hidden' name='attachList["+i+"].fileType' value='"+ jobj.data("type")+"'>";
					});
					// formObj(form태그)에 hidden 태그 추가. 전송
					console.log(str);
					formObj.append(str).submit();
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
					    beforeSend: function(xhr) {
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