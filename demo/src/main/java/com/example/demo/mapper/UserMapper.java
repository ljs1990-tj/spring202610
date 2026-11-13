package com.example.demo.mapper;

import java.util.HashMap;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.model.User;

@Mapper
public interface UserMapper {
	// 사용자 조회
	User selectUser(HashMap<String, Object> map);
	
	// 회원가입
	int insertUser(HashMap<String, Object> map);
	
	// 비밀번호 변경
	int updatePassword(HashMap<String, Object> map);
	
	// 사용자 조회(아이디 + 핸드폰)
	int selectUserAuth(HashMap<String, Object> map);
	
}
