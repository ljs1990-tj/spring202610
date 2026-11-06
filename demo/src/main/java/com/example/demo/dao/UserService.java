package com.example.demo.dao;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.common.Message;
import com.example.demo.mapper.UserMapper;
import com.example.demo.model.User;

@Service
public class UserService {
	@Autowired
	UserMapper userMapper;
	
	public HashMap<String, Object> login(HashMap<String, Object> map){
		HashMap<String, Object> resultMap = new HashMap();
		
		try {
			User user =  userMapper.selectUser(map);
			if(user != null) {
				resultMap.put("loginFlg", true);
				resultMap.put("message", user.getUserName() + "님 환영합니다.");
			} else {
				resultMap.put("loginFlg", false);
				resultMap.put("message", Message.LOGIN_FAIL);
			}
			resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			resultMap.put("message", Message.DB_ERR);
			System.out.println(e.getMessage());
		}
		
		return resultMap;
	}
	
	public HashMap<String, Object> addUser(HashMap<String, Object> map){
		HashMap<String, Object> resultMap = new HashMap();
		
		try {
			int result = userMapper.insertUser(map);			
			resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			resultMap.put("message", Message.DB_ERR);
			System.out.println(e.getMessage());
		}
		
		return resultMap;
	}
	
}
