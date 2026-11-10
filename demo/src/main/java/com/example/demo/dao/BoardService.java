package com.example.demo.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.common.Message;
import com.example.demo.mapper.BoardMapper;
import com.example.demo.model.Board;
import com.example.demo.model.File;

import jakarta.servlet.http.HttpSession;

@Service
public class BoardService {
	@Autowired
	BoardMapper boardMapper;
	
	@Autowired
	HttpSession session;
	
	public HashMap<String, Object> getBoardList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap();
		try {
			// object -> 문자열 -> 숫자
			String limit = (String) map.get("limit");
			String offset = (String) map.get("offset");
			
			map.put("limit", Integer.parseInt(limit));
			map.put("offset", Integer.parseInt(offset));
			
			List<Board> list = boardMapper.selectBoardList(map);
			int count = boardMapper.selectBoardCount(map);
			
			resultMap.put("list", list);
			resultMap.put("count", count);
			resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			System.out.println(e.getMessage());
		}
		return resultMap;
	}
	
	public HashMap<String, Object> getBoard(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap();
		try {
			
			Board info = boardMapper.selectBoard(map);
			List<File> fileList = boardMapper.selectBoardFile(map);
			
			// 상세보기 화면에서만 댓글목록 가져오기
			if(map.get("option").equals("VIEW")) {
				List<Board> commentList = boardMapper.selectBoardCommentList(map);
				resultMap.put("commentList", commentList);
			}
			
			resultMap.put("info", info);
			resultMap.put("fileList", fileList);
			resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			System.out.println(e.getMessage());
		}
		return resultMap;
	}
	
	public HashMap<String, Object> removeBoard(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap();
		try {
			int cnt = boardMapper.deleteBoard(map);
			resultMap.put("message", Message.DELETE_SUCCESS);
			resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			resultMap.put("message", Message.DELETE_FAIL);
			System.out.println(e.getMessage());
		}
		return resultMap;
	}
	
	public HashMap<String, Object> removeBoardAll(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap();
		try {
			int cnt = boardMapper.deleteBoardAll(map);
			resultMap.put("message", Message.DELETE_SUCCESS);
			resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			resultMap.put("message", Message.DELETE_FAIL);
			System.out.println(e.getMessage());
		}
		return resultMap;
	}
	
	public HashMap<String, Object> addBoard(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap();
		try {
			
			if(session.getAttribute("sessionId") != null) {
				map.put("sessionId", session.getAttribute("sessionId"));
				int cnt = boardMapper.insertBoard(map);
				resultMap.put("boardNo", map.get("boardNo"));
				resultMap.put("message", Message.INSERT_SUCCESS);
				resultMap.put("result", "success");
			} else {
				resultMap.put("message", "세션이 만료되었습니다.");
				resultMap.put("result", "fail");
			}
			
			
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			resultMap.put("message", Message.INSERT_FAIL);
			System.out.println(e.getMessage());
		}
		return resultMap;
	}
	
	public HashMap<String, Object> addBoardComment(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap();
		try {
			
			if(session.getAttribute("sessionId") != null) {
				map.put("sessionId", session.getAttribute("sessionId"));
				int cnt = boardMapper.insertBoardComment(map);
				
				resultMap.put("message", Message.INSERT_SUCCESS);
				resultMap.put("result", "success");
			} else {
				resultMap.put("message", "세션이 만료되었습니다.");
				resultMap.put("result", "fail");
			}
			
			
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			resultMap.put("message", Message.INSERT_FAIL);
			System.out.println(e.getMessage());
		}
		return resultMap;
	}
	
	public HashMap<String, Object> addBoardFile(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap();
		try {
			int cnt = boardMapper.insertBoardFile(map);
			resultMap.put("message", Message.INSERT_SUCCESS);
			resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			resultMap.put("message", Message.INSERT_FAIL);
			System.out.println(e.getMessage());
		}
		return resultMap;
	}
	
	public HashMap<String, Object> editBoard(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap();
		try {
			int cnt = boardMapper.updateBoard(map);
			resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			System.out.println(e.getMessage());
		}
		return resultMap;
	}
	
}
