package com.example.demo.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.model.Board;

@Mapper
public interface BoardMapper {
	// 게시글 목록
	List<Board> selectBoardList(HashMap<String, Object> map);
	
	// 게시글 갯수
	int selectBoardCount(HashMap<String, Object> map);
	
	// 게시글 삭제
	int deleteBoard(HashMap<String, Object> map);
	
	// 게시글 여러개 삭제
	int deleteBoardAll(HashMap<String, Object> map);
}





