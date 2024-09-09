package org.newjeans.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.newjeans.domain.NewJeansDTO;
import org.newjeans.domain.Criteria;

public interface NewJeansMapper {
	//목록
	public List<NewJeansDTO> getList();
	// 가장 최근 뉴스
	public NewJeansDTO getLast();
	//등록
	public void insert(NewJeansDTO board);
	//등록 with select key
	public void insertSelectKey(NewJeansDTO board);
	//상세보기
	public NewJeansDTO read(Long bno);
	//수정처리
	public int update(NewJeansDTO board);
	//삭제
	public void deleteReply(Long bno);
	public int deleteBoard(Long bno);
	//목록 with paging
	public List<NewJeansDTO> getListWithPaging(Criteria cri);
	//전체글수
	public int getTotalCount(Criteria cri);
	
	// 채은열 0830 추가*******************************************************************************************************************
	//카테고리별 목록
	public List<NewJeansDTO> getListCategory();
	//목록 with paging category
	public List<NewJeansDTO> getListWithPagingCategory(Criteria cri);
	//카테고리 별 전체 글 수
	public int getTotalCountCategory(Criteria cri);
	// 채은열 0830 추가*******************************************************************************************************************
		
		
	// 댓글 트랜잭션 처리
	public void updateReplyCnt(@Param("bno") Long bno, @Param("amount") int amount);
	
	// 댓글 수가 가장 많은 게시글 5개 조회
	public List<NewJeansDTO> getTop5PostsByReplyCount();
}