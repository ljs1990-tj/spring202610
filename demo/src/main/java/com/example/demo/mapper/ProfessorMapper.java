package com.example.demo.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.model.Professor;

@Mapper
public interface ProfessorMapper {
	// 교수 목록
	List<Professor> selectProfessorList(HashMap<String, Object> map);
	// 교수 삭제
	int deleteProfessor(HashMap<String, Object> map);
	// 교수 추가
	int insertProfessor(HashMap<String, Object> map);
	// 교수 검색(교수번호-pk로 검색)
	Professor selectProfessor(HashMap<String, Object> map);
	
	
	// 학과 리스트
	List<Professor> selectDeptList(HashMap<String, Object> map);
}





