package org.newjeans.domain;


import java.util.Date;
import java.util.List;



import lombok.Data;
//채은열 0828 추가*******************************************************************************************************************
@Data
public class SignUpDTO {
	private String userid;
	private String userpw;
	private String userName;
	private Date regDate;
	private Date updateDate;
	private boolean enabled;

	private String email;
	private String pnumber;
	private String address;
	
	private List<AuthDTO> authList;
}
