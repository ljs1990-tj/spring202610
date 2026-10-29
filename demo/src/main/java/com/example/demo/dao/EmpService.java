package com.example.demo.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.mapper.EmpMapper;
import com.example.demo.model.Emp;

@Service
public class EmpService {
	@Autowired
	EmpMapper empMapper;
	
	public HashMap<String, Object> getEmpList(HashMap<String, Object> map){
		HashMap<String, Object> resultMap = new HashMap();
		List<Emp> list =  empMapper.selectEmpList(map);
		
		resultMap.put("list", list);
		resultMap.put("result", "success");
		
		return resultMap;
	}
	
	public HashMap<String, Object> removeEmp(HashMap<String, Object> map){
		HashMap<String, Object> resultMap = new HashMap();
		empMapper.deleteEmp(map);
		
		resultMap.put("result", "success");
		
		return resultMap;
	}
	
}







