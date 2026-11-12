package com.example.demo.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class ChartController {
	@RequestMapping("/chart1.do")
	public String test(Model model) throws Exception{
		
		return "/chart/chart1";
	}
}


