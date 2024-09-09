package org.newjeans.mapper;

import java.util.List;

import org.newjeans.domain.NewJeansAttachDTO;

public interface NewJeansAttachMapper {
	// 등록
	public void insert(NewJeansAttachDTO vo);
	// 목록 (목록이라서 List)
	public List<NewJeansAttachDTO> findByBno(Long bno);
	// 첨부파일 목록 모두 삭제
	public void deleteAll(Long bno);
	// 어제 날짜 첨부파일 목록
	public List<NewJeansAttachDTO> getOldFiles();
	
	public void delete(String uuid);
	

}