package com.example.demo.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.model.Area;

@Mapper
public interface AreaMapper {
	List<Area> selectSiList(HashMap<String, Object> map);
	List<Area> selectGuList(HashMap<String, Object> map);
	List<Area> selectDongList(HashMap<String, Object> map);
}








