package com.example.demo.controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.dao.AreaService;
import com.google.gson.Gson;

@Controller
public class AreaController {
	@Autowired
	AreaService areaService;
	
	@RequestMapping("/weather.do")
	public String weather(Model model) throws Exception{
		
		return "/area/weather";
	}
	
	@RequestMapping(value = "/area/si.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String si(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap = areaService.getSiList(map);
		
		return new Gson().toJson(resultMap); 
	}
	@RequestMapping(value = "/area/gu.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String gu(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap = areaService.getGuList(map);
		
		return new Gson().toJson(resultMap); 
	}
	@RequestMapping(value = "/area/dong.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String dong(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap = areaService.getDongList(map);
		
		return new Gson().toJson(resultMap); 
	}
}





