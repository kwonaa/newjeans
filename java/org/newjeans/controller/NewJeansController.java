package org.newjeans.controller;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

import org.newjeans.domain.Criteria;
import org.newjeans.domain.NewJeansAttachDTO;
import org.newjeans.domain.NewJeansDTO;
import org.newjeans.domain.PageDTO;
import org.newjeans.security.domain.CustomUser;
import org.newjeans.service.NewJeansService;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Controller
@Log4j
@RequestMapping("/newjeans/*")
@AllArgsConstructor
public class NewJeansController {
	
	private NewJeansService service; // 자동주입. 생성자의존성주입 (@AllArgsConstructor를 써줬기 때문에 어노테이션을 따로 안 써줘도 됨)

	
	// 등록화면으로 이동
	//0903 채은열 권한부여 ***********************************************************************************************
	@GetMapping("/register")
	@PreAuthorize("hasRole('ROLE_MEMBER')or hasRole('ROLE_ADMIN')")  // MEMBER OR ADMIN 권한이 있어야 작성가능
	public void register() {
	}
	
	// 등록
	//0903 채은열 권한부여 ***********************************************************************************************
	@PostMapping("/register")
	@PreAuthorize("hasRole('ROLE_MEMBER')or hasRole('ROLE_ADMIN')") // MEMBER OR ADMIN 권한이 있어야 작성가능
	public String register(NewJeansDTO board, RedirectAttributes rttr) {
		service.register(board);
		rttr.addFlashAttribute("result", board.getBno()); // result라는 이름으로 글번호 전달
		return "redirect:/newjeans/list"; // 주소가 변경될 때 사용 // sendRedirect() 역할
	}
	
	// 상세보기
	@GetMapping({ "/get", "/modify" })
	public void get(@RequestParam("bno") Long bno, @ModelAttribute("cri") Criteria cri, Model model) {
		model.addAttribute("board", service.get(bno));
		
		// 사이드바에 상위 5개의 게시글 정보 전달
        List<NewJeansDTO> topPosts = service.getTop5PostsByReplyCount();
        model.addAttribute("topPosts", topPosts);
	}
	
	// 수정
	@PreAuthorize("principal.username == #board.writer") // 자기가 쓴 글만 수정
	@PostMapping("/modify")
	public String modify(NewJeansDTO board, @ModelAttribute("cri") Criteria cri, RedirectAttributes rttr) {
		log.info("modify:" + board);

		if (service.modify(board)) {
			rttr.addFlashAttribute("result", "success");
		}

		rttr.addAttribute("pageNum", cri.getPageNum());
		rttr.addAttribute("amount", cri.getAmount());
		rttr.addAttribute("type", cri.getType());
		rttr.addAttribute("keyword", cri.getKeyword());

		return "redirect:/newjeans/list";
	}
	
	// 삭제
	//0903 채은열 권한부여 ***********************************************************************************************
	@PreAuthorize("hasRole('ROLE_ADMIN') or principal.username == #writer") // 자기가 쓴 글 or ADMIN만 삭제
	@PostMapping("/remove")
	public String remove(@RequestParam("bno") Long bno, Criteria cri, RedirectAttributes rttr, String writer) {
		List<NewJeansAttachDTO> attachList = service.getAttachList(bno);
		if (service.remove(bno)) {
			// 첨부파일 삭제
			deleteFiles(attachList);
			rttr.addFlashAttribute("result", "success");
		}
		return "redirect:/newjeans/list" + cri.getListLink();
	}
	
	private void deleteFiles(List<NewJeansAttachDTO> attachList) {
		// 첨부파일이 없으면 중지
		if(attachList == null || attachList.size() == 0) {
			return;
		}
		
		attachList.forEach(attach -> {
			try {
				Path file  = Paths.get("C:\\upload\\"+attach.getUploadPath()+"\\" + attach.getUuid()+"_"+ attach.getFileName());
				Files.deleteIfExists(file); // 원본파일 삭제
				// 이미지이면
//				if(Files.probeContentType(file).startsWith("image")) {
//					Path thumbNail = Paths.get("C:\\upload\\"+attach.getUploadPath()+"\\s_" + attach.getUuid()+"_"+ attach.getFileName());
//					Files.delete(thumbNail); // 썸네일 삭제
//				}
			} catch (Exception e) {
				log.error("delete file error" + e.getMessage());
			}
		});
	}
	
	// 목록 with paging	
	@GetMapping("/list")
	public void list(Criteria cri, Model model) {
		List<NewJeansDTO> dto = service.getList(cri);
		model.addAttribute("list", dto);
		model.addAttribute("last", service.getLast());
		for(NewJeansDTO board: dto) {
			board.setAttachList(service.getAttachList(board.getBno()));
		}
		
		int total = service.getTotal(cri);
		model.addAttribute("total", total); // 총 데이터 개수 모델에 추가
		model.addAttribute("pageMaker", new PageDTO(cri, total));
		
		// 사이드바에 상위 5개의 게시글 정보 전달
        List<NewJeansDTO> topPosts = service.getTop5PostsByReplyCount();
        model.addAttribute("topPosts", topPosts);
	}
	
	// 목록 with paging
	@GetMapping("/politics")
	public void listpolitics(Criteria cri, Model model) {
	    cri.setCno(1);
	    // 리스트를 한번만 가져오도록 변경
	    List<NewJeansDTO> dto = service.getListCategory(cri);
	    // 리스트를 모델에 추가
	    model.addAttribute("listpolitics", dto);
	    
	    // 각 게시글에 대한 첨부파일 목록 설정
	    for (NewJeansDTO board : dto) {
	        board.setAttachList(service.getAttachList(board.getBno()));
	    }

	    // 페이지 정보를 모델에 추가
	    int total = service.getTotalCategory(cri);
	    model.addAttribute("total", total); // 총 데이터 개수 모델에 추가
	    model.addAttribute("pageMaker", new PageDTO(cri, total));
	    
	    // 사이드바에 상위 5개의 게시글 정보 전달
        List<NewJeansDTO> topPosts = service.getTop5PostsByReplyCount();
        model.addAttribute("topPosts", topPosts);
	}

	// 목록 with paging	
	@GetMapping("/financial")
	public void listfinancial(Criteria cri, Model model) {
		cri.setCno(2);
		List<NewJeansDTO> dto = service.getListCategory(cri);
		model.addAttribute("listfinancial", dto);
		for (NewJeansDTO board : dto) {
	        board.setAttachList(service.getAttachList(board.getBno()));
	    }
		int total = service.getTotalCategory(cri);
		model.addAttribute("total", total); // 총 데이터 개수 모델에 추가
		model.addAttribute("pageMaker", new PageDTO(cri, total));
		
		// 사이드바에 상위 5개의 게시글 정보 전달
        List<NewJeansDTO> topPosts = service.getTop5PostsByReplyCount();
        model.addAttribute("topPosts", topPosts);
	}
	
	// 목록 with paging	
	@GetMapping("/entertainment")
	public void listEtm(Criteria cri, Model model) {
		cri.setCno(3);
		List<NewJeansDTO> dto = service.getListCategory(cri);
		model.addAttribute("listEtm", dto);
		for (NewJeansDTO board : dto) {
	        board.setAttachList(service.getAttachList(board.getBno()));
	    }
		int total = service.getTotalCategory(cri);
		model.addAttribute("total", total); // 총 데이터 개수 모델에 추가
		model.addAttribute("pageMaker", new PageDTO(cri, total));
		// 사이드바에 상위 5개의 게시글 정보 전달
        List<NewJeansDTO> topPosts = service.getTop5PostsByReplyCount();
        model.addAttribute("topPosts", topPosts);
	}
	
	// 목록 with paging	
	@GetMapping("/culture")
	public void listculture(Criteria cri, Model model) {
		cri.setCno(4);
		List<NewJeansDTO> dto = service.getListCategory(cri);
		model.addAttribute("listculture", dto);
		for (NewJeansDTO board : dto) {
	        board.setAttachList(service.getAttachList(board.getBno()));
	    }
		int total = service.getTotalCategory(cri);
		model.addAttribute("total", total); // 총 데이터 개수 모델에 추가
		model.addAttribute("pageMaker", new PageDTO(cri, total));
		
		// 사이드바에 상위 5개의 게시글 정보 전달
        List<NewJeansDTO> topPosts = service.getTop5PostsByReplyCount();
        model.addAttribute("topPosts", topPosts);
	}
	
	// 첨부파일목록
	@GetMapping(value = "/getAttachList", produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public ResponseEntity<List<NewJeansAttachDTO>> getAttachList(Long bno) {
		return new ResponseEntity<>(service.getAttachList(bno), HttpStatus.OK);
	}
	
	// 사이드바에 표시할 게시글 목록 조회
    @GetMapping("/top5posts")
    @ResponseBody
    public ResponseEntity<List<NewJeansDTO>> getTop5Posts() {
        List<NewJeansDTO> topPosts = service.getTop5PostsByReplyCount();
        return new ResponseEntity<>(topPosts, HttpStatus.OK);
    }	
}
