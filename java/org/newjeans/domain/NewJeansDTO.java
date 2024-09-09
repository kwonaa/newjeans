package org.newjeans.domain;

import java.util.Date;
import java.util.List;

import lombok.Data;

@Data // lombok 어노테이션
public class NewJeansDTO {
	private Long bno;
	private String title;
	private String content;
	private String writer;
	private Date regdate;
	private Date updateDate;
	private int cno; // 추가된 부분
	

	// 댓글수 추가
	private int replyCnt;
	
	// 첨부파일 목록 추가
	private List<NewJeansAttachDTO> attachList;
	
	// username 추가
	private String username; // 사용자 이름
}