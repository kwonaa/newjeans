package org.newjeans.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.newjeans.domain.Criteria;
import org.newjeans.domain.ReplyDTO;

public interface ReplyMapper {

	public int insert(ReplyDTO vo); // 등록

	public ReplyDTO read(Long rno); // 조회

	public int remove(Long rno); // 삭제

	public int update(ReplyDTO reply); // 수정

	public List<ReplyDTO> getListWithPaging(@Param("cri") Criteria cri, @Param("bno") Long bno); // 댓글목록 with paging // MyBatis에서 parameter가 두 개 이상일 땐 @Param을 적어줘야 함.

	public int getCountByBno(Long bno); // 댓글 수

	public int updateDeleted(Long rno); // 삭제된 댓글
	//삭제한 사람 기록
	public int deleteReply(@Param("rno") Long rno, @Param("deletedby") String deletedby);

}
