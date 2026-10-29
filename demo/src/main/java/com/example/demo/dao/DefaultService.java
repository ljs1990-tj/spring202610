package com.example.demo.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.mapper.DefaultMapper;
import com.example.demo.model.User;


@Service
public class DefaultService {
	@Autowired
	DefaultMapper defaultMapper;
	
	public HashMap<String, Object> getUserList() {
		HashMap<String, Object> resultMap = new HashMap();
		List<User> list = defaultMapper.selectUserList();
		
		resultMap.put("list", list);
		resultMap.put("result", "success");
		return resultMap;
	}
	
	
//	get, remove, edit, add => 서비스에서 쓰는 이름으로 사용하고
//  select, delete, update, insert => mapper, xml에서 쓰는 이름으로 사용
//  이런식으로 구분하면 함수 이름만 보고 어느 로직인지 구분 쉽게 가능
	public HashMap<String, Object> removeUser(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap();
		defaultMapper.deleteUser(map);
		
		resultMap.put("result", "success");
		return resultMap;
		
	}
}




