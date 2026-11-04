package com.example.demo.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.common.Message;
import com.example.demo.mapper.BoardMapper;
import com.example.demo.model.Board;

@Service
public class BoardService {
	@Autowired
	BoardMapper boardMapper;
	
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
	
}
