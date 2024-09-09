package org.newjeans.mapper;

import org.newjeans.domain.SignUpDTO;

public interface MemberMapper {
	// 회원 정보
	public SignUpDTO read(String userid);
	
	// 사용자 ID로 username 조회
    public String getUsernameById(String userid);
}
