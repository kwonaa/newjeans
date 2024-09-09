package org.newjeans.domain;

import java.util.Date;

import lombok.Data;

@Data
public class ReplyDTO {
	private Long rno; // 댓글번호
	private Long bno; // 부모글번호

	private String reply; // 댓글 내용
	private String replyer; // 댓글 작성자
	private Date replyDate; // 댓글 작성일
	private Date updateDate; // 댓글 수정일
	private String deleted; //댓글 삭제여부
	private String deletedby;
//	 public String getDeleted() {
//	        return deleted;
//	    }
}
