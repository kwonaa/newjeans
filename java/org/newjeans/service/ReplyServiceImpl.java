package org.newjeans.service;

import java.util.List;

import org.newjeans.domain.Criteria;
import org.newjeans.domain.ReplyDTO;
import org.newjeans.domain.ReplyPageDTO;
import org.newjeans.mapper.NewJeansMapper;
import org.newjeans.mapper.ReplyMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Service
@Log4j
@AllArgsConstructor
public class ReplyServiceImpl implements ReplyService {

	private ReplyMapper mapper; // 자동주입. 생성자 의존성 주입
	private NewJeansMapper boardMapper; // 자동주입. 생성자 의존성 주입
	

//	@Override
//	public int register(ReplyDTO vo) { // C
//		return mapper.insert(vo);
//	}
	
	@Transactional
	@Override
	public int register(ReplyDTO vo) {
		boardMapper.updateReplyCnt(vo.getBno(), 1); // 댓글 개수 1 증가
		return mapper.insert(vo);
	}

	@Override
	public ReplyDTO get(Long rno) { // R
		return mapper.read(rno);
	}

	@Override
	public int modify(ReplyDTO vo) { // U
		return mapper.update(vo);
	}

//	@Override
//	public int remove(Long rno) { // D
//		return mapper.delete(rno);
//	}
	
	@Transactional
	@Override
	public int remove(Long rno) {
		ReplyDTO vo = mapper.read(rno);
		boardMapper.updateReplyCnt(vo.getBno(), -1); // 댓글 개수 1 감소
		return mapper.updateDeleted(rno);
	}
	
	@Override
	public int setDeleted(Long rno) {		
		return mapper.updateDeleted(rno);
	}
	
//	// 특정 게시물의 댓글 목록
//	@Override
//	public List<ReplyDTO> getList(Criteria cri, Long bno) {
//		return mapper.getListWithPaging(cri, bno);
//	}

	// 댓글의 페이지 계산과 출력 (댓글 목록)
	@Override
	public ReplyPageDTO getListPage(Criteria cri, Long bno) {
		return new ReplyPageDTO(mapper.getCountByBno(bno), mapper.getListWithPaging(cri, bno));
	}

	@Override
	public int deleteReply(Long rno, String deletedby) {
		
		 return mapper.deleteReply(rno, deletedby);

	}

}
