package com.example.demo.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.mapper.ProfessorMapper;
import com.example.demo.model.Professor;

@Service
public class ProfessorService {
	@Autowired
	ProfessorMapper professorMapper;
	
	public HashMap<String, Object> getProfessorList(HashMap<String, Object> map){
		HashMap<String, Object> resultMap = new HashMap();
		List<Professor> list =  professorMapper.selectProfessorList(map);
		
		resultMap.put("list", list);
		resultMap.put("result", "success");
		
		return resultMap;
	}
	
	public HashMap<String, Object> getProfessor(HashMap<String, Object> map){
		HashMap<String, Object> resultMap = new HashMap();
		Professor info = professorMapper.selectProfessor(map);
		
		resultMap.put("info", info);
		resultMap.put("result", "success");
		
		return resultMap;
	}
	
	public HashMap<String, Object> removeProfessor(HashMap<String, Object> map){
		HashMap<String, Object> resultMap = new HashMap();
		professorMapper.deleteProfessor(map);
		
		resultMap.put("result", "success");
		
		return resultMap;
	}
	
	public HashMap<String, Object> addProfessor(HashMap<String, Object> map){
		HashMap<String, Object> resultMap = new HashMap();
		professorMapper.insertProfessor(map);
		
		resultMap.put("result", "success");
		
		return resultMap;
	}
	
	public HashMap<String, Object> getDeptList(HashMap<String, Object> map){
		HashMap<String, Object> resultMap = new HashMap();
		List<Professor> deptList =  professorMapper.selectDeptList(map);
		
		resultMap.put("deptList", deptList);
		resultMap.put("result", "success");
		
		return resultMap;
	}
}




