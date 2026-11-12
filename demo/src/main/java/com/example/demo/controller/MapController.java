package com.example.demo.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class MapController {

	@RequestMapping("/map1.do")
	public String test(Model model) throws Exception{
		
		return "/map/map1";
	}
	
	@RequestMapping("/map2.do")
	public String map2(Model model) throws Exception{
		
		return "/map/map2";
	}
	
}
