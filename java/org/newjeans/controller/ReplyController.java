package org.newjeans.controller;

import java.io.BufferedReader;
import java.io.FileReader;

import javax.servlet.http.HttpServletRequest;

import org.newjeans.domain.Criteria;
import org.newjeans.domain.ReplyDTO;
import org.newjeans.domain.ReplyPageDTO;
import org.newjeans.service.ReplyService;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@RequestMapping("/replies/")
@RestController
@Log4j
@AllArgsConstructor
public class ReplyController {
	private ReplyService service; // 자동주입. 생성자의존성주입

	// 등록
	@PreAuthorize("isAuthenticated()")
	@PostMapping(value = "/new",
			consumes = "application/json", // FE에서 오는 data 형식
			produces = { MediaType.TEXT_PLAIN_VALUE }) // BE에서 나가는 data 형식
	public ResponseEntity<String> create(@RequestBody ReplyDTO vo) { 
		
		log.info("ReplyDTO: " + vo);

		int insertCount = service.register(vo); // 영향을 받은 행의 수가 넘어옴

		log.info("Reply INSERT COUNT: " + insertCount);
		// 영향을 받은 행의 수가 1이면 정상적으로 insert된 것임
		return insertCount == 1  
				?  new ResponseEntity<>("success", HttpStatus.OK)
				: new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
	}
	
//	// 조회
//	@GetMapping(value = "/{rno}", produces = { MediaType.APPLICATION_XML_VALUE, MediaType.APPLICATION_JSON_UTF8_VALUE }) 
//	public ResponseEntity<ReplyDTO> get(@PathVariable("rno") Long rno) {
//		log.info("get: " + rno);
//		return new ResponseEntity<>(service.get(rno), HttpStatus.OK);
//	}

	/*
	 * // 수정 //0903 채은열 권한부여
	 * *****************************************************************************
	 * ****************** // put 방식, patch 방식 모두 사용 가능(reply.js에서 put 방식 사용하고 있는 것
	 * 확인 가능)
	 * 
	 * @PreAuthorize("hasRole('ROLE_ADMIN') or principal.username == #vo.replyer")
	 * 
	 * @RequestMapping(method = { RequestMethod.PUT, RequestMethod.PATCH }, value =
	 * "/{rno}", consumes = "application/json", produces =
	 * {MediaType.TEXT_PLAIN_VALUE }) public ResponseEntity<String>
	 * modify(@RequestBody ReplyDTO vo, @PathVariable("rno") Long rno) {
	 * vo.setRno(rno); log.info("rno: " + rno); log.info("modify: " + vo); return
	 * service.remove(rno) == 1 ? new ResponseEntity<>("success", HttpStatus.OK) :
	 * new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR); }
	 */
	
	   @PreAuthorize("principal.username == #vo.replyer or hasRole('ROLE_ADMIN')")
	   @PutMapping("/{rno}")
	   public ResponseEntity<String> deleteReply(@PathVariable("rno") Long rno, @RequestBody ReplyDTO vo) {
	       // ReplyVO에서 삭제자 정보와 댓글 번호를 가져옴
	      // SecurityContextHolder에서 현재 인증된 사용자 정보 가져오기
	       Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
	       String deletedby = ((UserDetails)authentication.getPrincipal()).getUsername();  // 로그인한 사용자의 ID 가져오기


	      // ReplyVO에 삭제자 정보를 설정합니다.
	      vo.setDeletedby(deletedby);

	       // 댓글 삭제 처리
	       int result = service.deleteReply(rno, deletedby);
	       return result == 1 ? new ResponseEntity<>("success", HttpStatus.OK) 
	               : new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
	   }

	
	
	
	
	
	
	
	// 삭제
	//0903 채은열 권한부여 ***********************************************************************************************
//	@PreAuthorize("hasRole('ROLE_ADMIN') or principal.username == #vo.replyer")
//	@DeleteMapping(value = "/{rno}", produces = { MediaType.TEXT_PLAIN_VALUE }) 
//	public ResponseEntity<String> remove(@RequestBody ReplyDTO vo, @PathVariable("rno") Long rno) {
//
//		log.info("remove: " + rno);
//
//		return service.remove(rno) == 1 
//				? new ResponseEntity<>("success", HttpStatus.OK)
//				: new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
//
//	}
	
	// 특정 게시물의 댓글 목록
//	@GetMapping(value = "/pages/{bno}/{page}", produces = { MediaType.APPLICATION_XML_VALUE, MediaType.APPLICATION_JSON_UTF8_VALUE })
//	public ResponseEntity<List<ReplyDTO>> getList(@PathVariable("page") int page, @PathVariable("bno") Long bno) {
//		log.info("getList.................");
//		Criteria cri = new Criteria(page, 10);
//		log.info(cri);
//		return new ResponseEntity<>(service.getList(cri, bno), HttpStatus.OK);
//	}
	
	// 댓글의 페이지 계산과 출력 (댓글 목록)
	@GetMapping(value = "/pages/{bno}/{page}", produces = { MediaType.APPLICATION_XML_VALUE, MediaType.APPLICATION_JSON_UTF8_VALUE })
	public ResponseEntity<ReplyPageDTO> getList(@PathVariable("page") int page, @PathVariable("bno") Long bno) {
		Criteria cri = new Criteria(page, 10); // Criteria(페이지 번호, 페이지 당 글의 수)
		log.info("get Reply List bno: " + bno);
		log.info("cri:" + cri);

		ReplyPageDTO replyPageDTO = service.getListPage(cri, bno);
		// 삭제된 댓글 표시를 위해 필터링 , getList는 ReplypageDTO에서 list를 get방식으로 가져온 것 (댓글목록을 반환하는 메서드)
	    replyPageDTO.getList().forEach(reply -> {
	        if ("Y".equals(reply.getDeleted())) {
	            reply.setReply("삭제된 댓글입니다");
	        }
	    });

		return new ResponseEntity<>(replyPageDTO, HttpStatus.OK);
	}
	
	//js파일 로딩
	@GetMapping(value="/js",produces= {MediaType.TEXT_PLAIN_VALUE})
	public String getJS(Long bno,HttpServletRequest request){
		BufferedReader reader = null;
		String script=""; 
		 try{
			   String filePath = request.getRealPath("/resources/js/reply3.js"); 
			   reader = new BufferedReader(new FileReader(filePath));
			   //out.print("<script>\n");
			   script+="var bnoValue='"+bno+"'\n;";
			   while(true){
				   String str = reader.readLine();  
				   if(str==null)
				   	break;
				   
				   script+=str+"\n";  
			   }
			   //out.print("</script>");
		 }catch(Exception e){
			 e.printStackTrace();
		  	
		 }finally {
			  try 
			  {
			   reader.close();    
			  }
			  catch(Exception e){
				  e.printStackTrace();
			  }
		 }
		return script;
	}

}

