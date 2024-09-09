/* parameter를 처리하는 함수 *************************************************/
  function scriptQuery() {
        var script = document.getElementsByTagName('script');
        script = script[script.length - 1].src
            .replace(/^[^\?]+\?/, '')
            .replace(/#.+$/, '')
            .split('&');

        var queries = {}
            , query;
        while (script.length) {
            query = script.shift().split('=');
            queries[query[0]] = query[1];
        }
        return queries;
    }
    var param = scriptQuery();
    console.log(param.bno); // parameter bno확인
 
 /* 날짜형식 출력 ***************************************************************/
 function displayTime(timeValue){
	var today=new Date(); //현재날짜시간
	var gap=today.getTime()-timeValue; //댓글등록이후 지난 시간
	var dateObj=new Date(timeValue); //댓글작성시간을 Date타입으로 변환
	
	//gap이 24시간이 안되면 시:분:초 출력
	if(gap<(24*60*60*1000)){
		var hh=dateObj.getHours();
		var mi=dateObj.getMinutes();
		var ss=dateObj.getSeconds();
		
		return [(hh>9?'':'0')+hh, ':' , (mi>9?'':'0')+mi , ':' , (ss>9?'':'0')+ss].join('');
	}else{
		var yy=dateObj.getFullYear();
		var mm=dateObj.getMonth()+1;
		var dd=dateObj.getDate();
		
		return [yy, '/', (mm>9?'':'0')+mm, '/', (dd>9?'':'0')+dd ].join('');
	}
}

/* 썸네일 클릭시 원본이미지 출력 *********************************************************/
function showImage(fileCallPath){
	$(".bigPictureWrapper").css("display","flex").show();//보이게하기
	$(".bigPicture").html("<img src='/display?fileName="+fileCallPath+"'>")
					.animate({width:'100%',height:'100%'},1000);
}		
            
$(document).ready(function(){
	/* 전역변수 & 미리 태그 찾아놓기 ********************************************************/
	
	/* csrf토큰 처리. $(document).ready() 안에서 호출해야 함 *********************************/
	$(document).ajaxSend(function(e, xhr, options) { 
	       xhr.setRequestHeader(csrfHeaderName, csrfTokenValue); 
	}); 
	
	/* 댓글목록 *************************************************************************/            	
	var bnoValue=param.bno;//부모글번호
	var replyUL=$(".chat"); // 댓글목록 출력되는 ul태그 찾아놓기
	
	showList(1); // 첫페이지 출력
	
	function showList(p){            		
		var bno=bnoValue; //부모글번호
		var page=p || 1; //페이지번호. 페이지번호가 넘어오면 page변수에 저장. 페이지번호가 넘어오지 않으면 page는 1.
		//var pageNum;
		$.getJSON("/replies/pages/"+bno+"/"+page+".json",function(data){
			//댓글목록출력
			//댓글등록시 마지막페이지로 이동. -1(eof를 의미)은 마지막페이지로 가기위한 약속
			if(page==-1){
				pageNum=Math.ceil(data.replyCnt/10.0); //전체페이지수==마지막페이지
				showList(pageNum); //재귀호출
				return;
			}
			var str="";
			//댓글이 없으면 종료
			if(data.list==null || data.list.length==0){
				replyUL.empty(); //댓글목록 초기화
				replyPageFooter.empty(); //페이지번호목록 초기화
				return;
			}
			for (var i = 0, len = data.list.length || 0; i < len; i++) {
          console.log("&&&&&&&"+data.list[i].deletedby);
            var reply = data.list[i];
            var replyText = (reply.deleted == 'Y')
                ? ((data.list[i].deletedby == 'admin') ? "관리자에 의해 삭제된 댓글입니다" : "삭제된 댓글입니다")
                : data.list[i].reply;
            
            str += "<li style='cursor:pointer;' data-rno='" + data.list[i].rno + "'>";
            str += "  <div>";
            str += "    <div class='header'>";
            str += "      <strong class='primary-font'>" + data.list[i].replyer + "</strong>";
            str += "      <small class='pull-right text-muted'>" + displayTime(reply.replyDate) + "</small>";
            str += "    </div>";
            str += "    <p>" + replyText + "</p>";
            if ((replyer === data.list[i].replyer && data.list[i].deleted != 'Y') || replyer == 'admin' && data.list[i].deleted != 'Y') {
                str += "  <button id='delBtn' type='button' class='btn btn-xs btn-success'>삭제</button>";
            }
            str += "  </div>";
            str += "</li>";
        }
        replyUL.html(str); // ul태그에 li태그 출력
        showReplyPage(data.replyCnt); // 페이지번호 출력            
    });

	}
	/* 댓글 페이징처리 페이지 번호출력 *******************************************************/
	var pageNum=1; // 기본 1페이지
	var replyPageFooter=$(".panel-footer"); // 페이지번호가 출력될 태그.
	
	function showReplyPage(replyCnt){
		var endNum=Math.ceil(pageNum/10.0)*10; // 계산으로 구한 현재구간의 마지막 페이지
		var startNum=endNum-9; // 첫번째 페이지
		var prev=startNum!=1; // prev 존재 유무. startNum가 1이 아니면 true
		var next=false; // next 존재 유무. false가 기본값
		
		//실제 마지막페이지가 계산으로 구한 마지막페이지보다 작으면 마지막페이지 변경
		if(endNum*10>=replyCnt){
			endNum=Math.ceil(replyCnt/10.0);
		}
		//실제 마지막페이지가 계산으로 구한 마지막페이지보다 크면 next가 true
		if(endNum*10<replyCnt){
			next=true;
		}
		//ul태그
		var str="<ul class='pagination pull-right'>";
		// li태그
		if(prev){
			str+="<li class='page-item'><a class='page-link' href='"+(startNum-1)+"'>Previous</a></li>";
		}
		for(var i=startNum;i<=endNum;i++){
			var active = pageNum==i?"active":""; //현재페이지와 페이지번호가 같으면 active 적용
			str+="<li class='page-item "+active+"'><a class='page-link' href='"+i+"'>"+i+"</a></li>";						
		}					
		if(next){
			str+="<li class='page-item'><a class='page-link' href='"+(endNum+1)+"'>Next</a></li>";
		}					
		str+="</ul>";
		replyPageFooter.html(str); //페이지번호출력	
	}
	
	/* 댓글 페이지 번호 이벤트 처리 *********************************************************/
	// 부모인 replyPageFooter에게 이벤트를 위임(Delegate)
	replyPageFooter.on("click","li a",function(e){
		e.preventDefault(); // 링크를 클릭했을 때 다음페이지로 넘어가는 것 방지
		var targetPageNum=$(this).attr("href"); //이벤트가 발생한 a태그의 href속성값 구하기
		pageNum=targetPageNum;
		showList(pageNum);  // 해당 페이지 댓글목록 출력
	});   
	
	
	
	/* 댓글등록 ************************************************************************/
	//nologin을 클릭했을 때
	$(document).ready(function() {
		// 로그인 상태가 아닌 경우 댓글 입력 필드를 클릭하면 모달 창 표시
		$("#nologin").on("click", function() {
			$("#loginModal").modal("show");  // 모달 창을 표시
		});
		// "로그인 이동" 버튼 클릭 시 로그인 페이지로 이동
		$("#goToLoginBtn").on("click", function() {
			window.location.href = "/customLogin";  // 로그인 페이지로 리디렉션
		});
	});
	
	
	// 댓글 등록버튼 이벤트처리
	$("#RegisterBtn").on("click",function(e){			        
		var reply = {
			reply : $("#reply").val(),
			replyer : $("#replyer").val(),
			bno : bnoValue
		};
		
		$.ajax({
			type:"post", //전송방식
			url: "/replies/new", //서버주소
			data: JSON.stringify(reply), // 서버로 전달되는 데이터
			contentType: "application/json; charset=utf-8", //서버로 전달되는 데이터형식,
			success:function(result,status,xhr){
				//성공했을 때 해야할 작업
				alert("등록됐습니다.");			          
				$("#reply").val(""); //댓글 입력필드 초기화
				//마지막페이지로 이동
				showList(1); // 1페이지
			}			
		});			        		        
	  });  
	
	/*댓글 삭제*********************************************************************************/
	//삭제 버튼 눌렀을 떄 모달창 띄우기
	$(document).ready(function() {
		// 상위 요소인 ul.chat에 이벤트를 위임
		$(".chat").on("click", "#delBtn", function(e) {
			// 모달에 rno를 설정
			var rno = $(this).closest("li").data("rno");
			var replyer = $("#replyer").val(); // 댓글 작성자 ID를 가져옴			
			$("#RemoveModal").data("rno", rno).data("replyer",replyer).modal("show"); // 모달 창을 띄우기
		});
	});
	
	// 모달창의 삭제버튼을 누르면 삭제되게 하기
	$(document).ready(function() {
		var modalRemoveBtn = $("#modalRemoveBtn");
		var modal = $("#RemoveModal");
		
		modalRemoveBtn.on("click", function(e) {
		   
			var rno = modal.data("rno"); // 모달에 저장된 댓글번호
			var replyer = modal.data("replyer"); // 모달에 저장된 댓글 작성자 ID
			
			$.ajax({
				type: "put", // 전송방식
				url: "/replies/" + rno, // 서버주소
				data: JSON.stringify({ rno: rno, replyer: replyer, deletedby : replyer }), // 서버로 전송되는 데이터
				contentType: "application/json; charset=utf-8", // 서버로 전송되는 데이터의 형식
				success: function(result, status, xhr) { // 성공했을 때 호출하는 함수
					modal.modal("hide"); // 모달창닫기
					showList(pageNum); // 목록갱신
				}
			});
		});
		 $("#modalCloseBtn").on("click",function(e){
			modal.modal("hide"); //모달창 안보이게
		});
	});
	
    /* 첨부파일목록 *********************************************************************************/    
    var bno=bnoValue; //부모글번호  
   
    $.getJSON("/newjeans/getAttachList", {bno: bno}, function(arr){  
       console.log(arr); // 서버에서 받은 데이터 로그 출력
       var str = "";
       
       //첨부파일목록 하나씩 처리
       $(arr).each(function(i, attach){   
       	console.log("Attach item:", attach); // 개별 아이템 로그 출력    
         //이미지이면
         if(attach.fileType){
           //이미지경로	
           var fileCallPath =  encodeURIComponent( attach.uploadPath+ "/"+attach.uuid +"_"+attach.fileName);
           
           str+="<li style='cursor:pointer;' data-path='"+attach.uploadPath+"' data-uuid='"+attach.uuid+"' data-filename='"+attach.fileName+"' data-type='"+attach.fileType+"'>";
           str+="	<div>";
           str+="		<img src='/display?fileName="+fileCallPath+"'>";
           str+="	</div>";
           str+="</li>";
         }
       });
       //ul태그에 출력
       $(".uploadResult ul").html(str);
     });

    /* 첨부파일목록 클릭시 이벤트처리 *******************************************************************************/
    $(".uploadResult").on("click","li",function(e){
    	console.log("테스트");
    	var liObj=$(this); // 클릭이벤트가 발생한 li태그
    	var path=encodeURIComponent(liObj.data("path")+"/"+liObj.data("uuid")+"_"+liObj.data("filename"));
    	if(liObj.data("type")){ //이미지인경우
    		showImage(path.replace(new RegExp(/\\/g),"/"));
    	}
    });
    
    /* 원본이미지 클릭시 이벤트처리 *******************************************************************************/
    $(".bigPictureWrapper").on("click",function(e){
    	$(".bigPicture").animate({width:'0%',height:'0%'},1000,function(){
    		$(".bigPictureWrapper").hide();//안보이게
    	});
    });
});