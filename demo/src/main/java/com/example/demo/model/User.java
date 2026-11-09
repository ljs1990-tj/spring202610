package com.example.demo.model;

import lombok.Data;

@Data
public class User {
	private String userId;
	private String pwd;
	private String userName;
	private String addr;
	private String role;
	
	// lombok을 이용하면 자동으로 get, set 메소드를 만들어 줘서
	// lombok은 어노테이션 @Data
	// 아래처럼 직접 선언할 필요가 없다.
	
}
