package org.newjeans.service;

import java.util.List;

import org.newjeans.domain.Criteria;
import org.newjeans.domain.NewJeansAttachDTO;
import org.newjeans.domain.NewJeansDTO;
import org.newjeans.domain.PageDTO;

public interface NewJeansService {
	//목록
	public List<NewJeansDTO> getList();
	// 가장 최근 뉴스
	public NewJeansDTO getLast();
	//등록
	public void register(NewJeansDTO board);
	//상세보기
	public NewJeansDTO get(Long bno);
	//수정처리
	public boolean modify(NewJeansDTO board);
	//삭제
	public boolean remove(Long bno);
	//목록 with paging
	public List<NewJeansDTO> getList(Criteria cri);
	//전체글수
	public int getTotal(Criteria cri);
	
	// 채은열 0830 추가*******************************************************************************************************************
	//카테고리별 목록
	public List<NewJeansDTO> getListCategory();
	//목록 with paging 카테고리
	public List<NewJeansDTO> getListCategory(Criteria cri);
	//전체글수 카테고리
	public int getTotalCategory(Criteria cri);
	// 채은열 0830 추가*******************************************************************************************************************
		
	//첨부파일목록
	public List<NewJeansAttachDTO> getAttachList(Long bno);
	
    // 댓글 수가 가장 많은 게시글 5개 조회
    public List<NewJeansDTO> getTop5PostsByReplyCount();
    // 게시글의 댓글 수를 업데이트하는 메서드
    public void updateReplyCount(Long bno, int amount);
}
