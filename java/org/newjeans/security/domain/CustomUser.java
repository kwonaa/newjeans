package org.newjeans.security.domain;

import java.util.Collection;
import java.util.stream.Collectors;

import org.newjeans.domain.SignUpDTO;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;

import lombok.Getter;

@Getter
public class CustomUser extends User {

	private static final long serialVersionUID = 1L;

	private SignUpDTO member; // 선언

	// 부모 생성자 초기화 (에러 방지용)
	public CustomUser(String username, String password, Collection<? extends GrantedAuthority> authorities) {
		super(username, password, authorities); // 부모 생성자 호출(에러 방지)
	}

	// 생성자 오버로딩
	public CustomUser(SignUpDTO dto) {
		super(dto.getUserid(), dto.getUserpw(), dto.getAuthList().stream()
				.map(auth -> new SimpleGrantedAuthority(auth.getAuth())).collect(Collectors.toList())); // 부모 생성자 호출 (에러 방지)
		this.member = dto; // dto를 받아서 member에 넣음
	}

	
}
