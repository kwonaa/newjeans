package org.newjeans.service;

import java.util.List;

import org.newjeans.domain.Criteria;
import org.newjeans.domain.ReplyPageDTO;
import org.newjeans.domain.ReplyDTO;

public interface ReplyService {

	public int register(ReplyDTO vo); // C

	public ReplyDTO get(Long rno); // R

	public int modify(ReplyDTO vo); // U

	public int remove(Long rno); // D
	
//	public List<ReplyDTO> getList(Criteria cri, Long bno); // 특정 게시물의 댓글 목록
	
	public ReplyPageDTO getListPage(Criteria cri, Long bno); // 댓글의 페이지 계산과 출력 (댓글 목록)

	public int setDeleted(Long rno); //삭제된 댓글
	
	 //삭제한 사람
	 public int deleteReply(Long rno, String deletedby);

}
