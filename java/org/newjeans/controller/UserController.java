package org.newjeans.controller;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.newjeans.domain.AuthDTO;
import org.newjeans.domain.SignUpDTO;
import org.newjeans.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import lombok.extern.log4j.Log4j;
//채은열 0828 추가*******************************************************************************************************************
@Controller
@Log4j
@RequestMapping("/member/*")
public class UserController {

    @Autowired
    private UserService userService;

    @GetMapping("/customSignup")
    public String customSignup(Model model) {
        log.info("회원가입 페이지 호출");
        return "customSignup"; // JSP 파일의 이름 (확장자는 .jsp는 제외)
    }

    @PostMapping("/customSignup")
    public String handleSignup(
            @RequestParam("userid") String userid,
            @RequestParam("userpw") String userpw,
            @RequestParam("userName") String userName,
            @RequestParam(value = "enabled", defaultValue = "true") boolean enabled,
            Model model) {

        log.info("회원가입 요청: userid=" + userid);

        // DTO 객체 생성
        SignUpDTO signUpDTO = new SignUpDTO();
        signUpDTO.setUserid(userid);
        signUpDTO.setUserpw(userpw);
        signUpDTO.setUserName(userName);
        signUpDTO.setEnabled(enabled);
        
        // 권한 설정
        List<AuthDTO> authList = new ArrayList<>();
        AuthDTO authDTO = new AuthDTO();
        authDTO.setUserid(userid);
        authDTO.setAuth("ROLE_USER"); // 기본 권한 설정(리스트 읽기, 댓글 작성, 댓글수정)
        authList.add(authDTO);
        signUpDTO.setAuthList(authList);

        // 사용자 정보 저장
        userService.saveUser(signUpDTO);

        model.addAttribute("message", "회원가입이 완료되었습니다.<br>가입하신 정보로 로그인하시기 바랍니다.");
        return "signupSuccess"; // 회원가입 성공 후 이동할 페이지
    }

 
    
    @RequestMapping("/checkId")
    public String checkId(@RequestParam("userid") String userid, Model model) {
        boolean isAvailable = userService.isUserIdAvailable(userid);
        model.addAttribute("result", isAvailable ? -1 : 1);
        model.addAttribute("userid", userid);
        return "idCheckResult"; // checkId.jsp로 포워딩
    }
    
    @GetMapping("/login")
    public String showLoginPage() {
        return "login"; // 로그인 페이지를 반환
    }
    
    @PostMapping("/login")
    public String login(@RequestParam("userid") String userid,@RequestParam("userpw") String userpw, Model model) {
    
    	int result=userService.userCheck(userid, userpw);
    	
    	  if (result == 1) {
              // 로그인 성공 시
              return "redirect:/board/list"; // 로그인 후 이동할 페이지
          } else if (result == 0) {
              // 비밀번호 불일치 시
              model.addAttribute("message", "비밀번호가 일치하지 않습니다.");
          } else if (result == -1) {
              // 사용자 ID 없음
              model.addAttribute("message", "아이디가 존재하지 않습니다.");
          }
          
          return "Login"; // 로그인 페이지로 리턴
      
    }
    
  //0902 채은열 추가 **********************************************************************************
    @GetMapping("/customPass")
    public String showPassPage(Model model) {
    	  Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
          String username = authentication.getName(); 
          model.addAttribute("userid", username);
    	
    	return "customPass"; //비밀번호 확인 페이지 반환
    	
    }
    @PostMapping("/customPass")
    public String pass(@RequestParam("userid") String userid,@RequestParam("userpw") String userpw, Model model) {
    	
  
    	int result=userService.passCheck(userid, userpw);

  	  if (result == 1) {
            // 로그인 성공 시
            return "redirect:/member/customMember"; // 비밀번호 확인 후 이동할 페이지 회원정보수정
        } else if (result == 0) {
            // 비밀번호 불일치 시
        	model.addAttribute("message", "입력하신 비밀번호가 등록된 정보와 일치하지 않습니다.<br>확인 후 다시 시도해주시기 바랍니다.");
            model.addAttribute("userid", userid); // 비밀번호 불일치 시 userid 값 추가
        } 
  	  
  	  	return "customPass";
  	  
    }
    
    @GetMapping("/customMember")
    public String showCustomMemberPage(Model model) throws SQLException {  
    Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
    String userid = authentication.getName(); 
    // 사용자의 정보를 조회하기 위해 서비스 호출
    SignUpDTO user = userService.memberInfo(userid);

    // 모델에 사용자 정보 추가
    model.addAttribute("userid", user.getUserid());
    model.addAttribute("username", user.getUserName());
    model.addAttribute("email", user.getEmail());
    model.addAttribute("pnumber", user.getPnumber());
    model.addAttribute("address", user.getAddress());
    
    return "customMember"; //회원정보수정 페이지 반환
    }
    
    @PostMapping("/customMember")
    public String updateMemberInfo(@ModelAttribute SignUpDTO signUpDTO) {
    	
        // 사용자 정보 업데이트
        userService.updateUser(signUpDTO);

        return "redirect:/member/customMemberInfo"; // 수정 완료 후 리디렉션
    }
    
    
    @GetMapping("/customMemberInfo")
    public String showCustomMemberInfoPage(Model model) throws SQLException {  
    Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
    String userid = authentication.getName(); 
    // 사용자의 정보를 조회하기 위해 서비스 호출
    SignUpDTO user = userService.memberInfo(userid);

    // 모델에 사용자 정보 추가
    model.addAttribute("userid", user.getUserid());
    model.addAttribute("username", user.getUserName());
    model.addAttribute("email", user.getEmail());
    model.addAttribute("pnumber", user.getPnumber());
    model.addAttribute("address", user.getAddress());
    
    return "customMemberInfo"; //회원정보수정 페이지 반환
    }
    

    //0902 채은열 추가 **********************************************************************************

}
