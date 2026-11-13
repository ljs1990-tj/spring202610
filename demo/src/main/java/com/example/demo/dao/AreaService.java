package com.example.demo.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.mapper.AreaMapper;
import com.example.demo.model.Area;

@Service
public class AreaService {
	@Autowired
	AreaMapper areaMapper;
	
	public HashMap<String, Object> getSiList(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap();
		try {
			List<Area> siList = areaMapper.selectSiList(map);
			resultMap.put("siList", siList);
			resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			System.err.println(e.getMessage());
		}
		return resultMap;
	}
	public HashMap<String, Object> getGuList(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap();
		try {
			List<Area> guList = areaMapper.selectGuList(map);
			resultMap.put("guList", guList);
			resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			System.err.println(e.getMessage());
		}
		return resultMap;
	}
	public HashMap<String, Object> getDongList(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap();
		try {
			List<Area> dongList = areaMapper.selectDongList(map);
			resultMap.put("dongList", dongList);
			resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			System.err.println(e.getMessage());
		}
		return resultMap;
	}
	
}





