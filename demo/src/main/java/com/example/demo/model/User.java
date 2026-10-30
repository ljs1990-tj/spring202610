package com.example.demo.model;


public class User {
	private String userId;
	private String pwd;
	private String userName;
	private String addr;
	private String role;
	
	// lombok을 이용하면 자동으로 get, set 메소드를 만들어 줘서
	// 아래처럼 직접 선언할 필요가 없다.
	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}
}
