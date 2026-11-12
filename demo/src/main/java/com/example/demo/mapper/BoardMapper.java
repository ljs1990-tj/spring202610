package com.example.demo.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.model.Board;
import com.example.demo.model.File;

@Mapper
public interface BoardMapper {
	// 게시글 목록
	List<Board> selectBoardList(HashMap<String, Object> map);
	
	// 게시글 상세정보
	Board selectBoard(HashMap<String, Object> map);
	
	// 댓글 목록
	List<Board> selectBoardCommentList(HashMap<String, Object> map);
	
	// 게시글 갯수
	int selectBoardCount(HashMap<String, Object> map);
	
	// 게시글 삭제
	int deleteBoard(HashMap<String, Object> map);
	
	// 게시글 여러개 삭제
	int deleteBoardAll(HashMap<String, Object> map);
	
	// 게시글 등록
	int insertBoard(HashMap<String, Object> map);
	
	// 게시글 수정
	int updateBoard(HashMap<String, Object> map);
	
	// 파일 업로드
	int insertBoardFile(HashMap<String, Object> map);
	
	// 첨부파일 목록
	List<File> selectBoardFile(HashMap<String, Object> map);
	
	// 댓글 등록
	int insertBoardComment(HashMap<String, Object> map);
	
	// 댓글 수정
	int updateBoardComment(HashMap<String, Object> map);
	
	// 댓글 삭제
	int deleteBoardComment(HashMap<String, Object> map);
}





