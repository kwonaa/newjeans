package org.newjeans.service;

import java.util.ArrayList;
import java.util.List;

import org.newjeans.domain.Criteria;
import org.newjeans.domain.NewJeansAttachDTO;
import org.newjeans.domain.NewJeansDTO;
import org.newjeans.mapper.MemberMapper;
import org.newjeans.mapper.NewJeansAttachMapper;
import org.newjeans.mapper.NewJeansMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Log4j
@Service
public class NewJeansServiceImpl implements NewJeansService {

	@Setter(onMethod_ = @Autowired)
	private NewJeansMapper mapper; // 주입. setter 의존성 주입

	@Setter(onMethod_ = @Autowired)
	private NewJeansAttachMapper attachMapper; // 주입. setter 의존성 주입
	
	@Setter(onMethod_ = @Autowired)
	private MemberMapper member; // 주입. setter 의존성 주입
	
	@Override
	public List<NewJeansDTO> getList() {		
		return mapper.getList(); // mapper의 getList()호출
	}
	
	// 채은열 0830 추가*******************************************************************************************************************
	@Override
	public List<NewJeansDTO> getListCategory() {
		return mapper.getListCategory(); 
	}
	// 채은열 0830 추가*******************************************************************************************************************
	
	@Transactional
	@Override
	public void register(NewJeansDTO board) {
		// 부모글 등록
		mapper.insertSelectKey(board);
		
		// 첨부파일이 없으면 중지
		if (board.getAttachList() == null || board.getAttachList().size() <= 0) {
			return;
		}
		board.getAttachList().forEach(attach -> {
			attach.setBno(board.getBno()); // 부모글번호 저장
			attachMapper.insert(attach); // 첨부파일 등록
		});
	}

	@Override
	public NewJeansDTO get(Long bno) {		
		NewJeansDTO board = mapper.read(bno);
		
        // NewJeansDTO의 writer로 MemberMapper username을 조회해서 NewJeansDTO의 username에 넣어줌
        String writer = board.getWriter(); // 실제 사용자의 ID 필드 확인 필요
        String username = member.getUsernameById(writer);
        board.setUsername(username);
        
	    board.setAttachList(attachMapper.findByBno(bno));
	    return board;
	}

	
	@Transactional
	@Override
	public boolean modify(NewJeansDTO board) {
		// 기존 첨부파일 모두 삭제
		attachMapper.deleteAll(board.getBno()); 
		// 부모글을 먼저 수정
		boolean modifyResult = mapper.update(board) == 1;
		// 첨부파일을 하나씩 insert. 부모글이 수정되고, 첨부파일 목록이 있는 경우.
		if (modifyResult && board.getAttachList() != null) {
			if (board.getAttachList().size() > 0) {
				board.getAttachList().forEach(attach -> { // forEach문으로 하나씩 꺼내서 insert
					attach.setBno(board.getBno()); // 부모글번호 저장
					attachMapper.insert(attach);
				});
			}
		}
		return modifyResult;
	}	
	
	
	@Transactional
	@Override
	public boolean remove(Long bno) {
		mapper.deleteReply(bno);
		attachMapper.deleteAll(bno);
		return mapper.deleteBoard(bno)==1;
	}

	@Override
	public List<NewJeansDTO> getList(Criteria cri) {		
		List<NewJeansDTO> list = new ArrayList<>();
		list = mapper.getListWithPaging(cri);
		list.forEach(board -> {
	        board.setAttachList(attachMapper.findByBno(board.getBno()));
	    });
	    return list;
	}

	@Override
	public int getTotal(Criteria cri) {		
		return mapper.getTotalCount(cri);
	}

	@Override
	public List<NewJeansAttachDTO> getAttachList(Long bno) {
		return attachMapper.findByBno(bno);
	}	
	// 가장 최근 뉴스
	@Override
	public NewJeansDTO getLast() {
	return mapper.getLast();
	}
	
	// 채은열 0830 추가*******************************************************************************************************************
	@Override
	public List<NewJeansDTO> getListCategory(Criteria cri) {
		return mapper.getListWithPagingCategory(cri);
	}



	@Override
	public int getTotalCategory(Criteria cri) {
		return mapper.getTotalCountCategory(cri);
	}
	// 채은열 0830 추가*******************************************************************************************************************
	
	// 가장 댓글이 많이 달린 뉴스
    @Override
    public List<NewJeansDTO> getTop5PostsByReplyCount() {
        return mapper.getTop5PostsByReplyCount();
    }

	@Override
	public void updateReplyCount(Long bno, int amount) {
	    // 게시글의 댓글 수를 업데이트하는 메서드
	    mapper.updateReplyCnt(bno, amount);
	}

}
