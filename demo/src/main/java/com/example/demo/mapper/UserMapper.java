package com.example.demo.mapper;

import java.util.HashMap;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.model.User;

@Mapper
public interface UserMapper {
	// 사용자 조회
	User selectUser(HashMap<String, Object> map);
	
	
	
	
}
