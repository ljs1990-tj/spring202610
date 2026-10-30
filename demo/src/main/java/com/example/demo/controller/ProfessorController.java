package com.example.demo.controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.dao.ProfessorService;
import com.google.gson.Gson;

@Controller
public class ProfessorController {
	@Autowired
	ProfessorService professorService;
	// 목록 페이지
	@RequestMapping("/professor/list.do")
	public String test(Model model) throws Exception{
		
		return "/professor/list";
	}
	// 추가 페이지
	@RequestMapping("/professor/add.do")
	public String add(Model model) throws Exception{
		
		return "/professor/add";
	}
	// 상세 보기
	@RequestMapping("/professor/view.do")
	public String view(Model model, @RequestParam HashMap<String, Object> map) throws Exception{
		System.out.println(map);
		model.addAttribute("profNo", map.get("profNo"));
		
		return "/professor/view";
	}
	// 수정 페이지
	@RequestMapping("/professor/edit.do")
	public String edit(Model model, @RequestParam HashMap<String, Object> map) throws Exception{
		model.addAttribute("profNo", map.get("profNo"));
		
		return "/professor/edit";
	}
	
	@RequestMapping(value = "/professor/list.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String login(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap = professorService.getProfessorList(map);
		
		return new Gson().toJson(resultMap); 
	}
	
	@RequestMapping(value = "/professor/remove.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String remove(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap = professorService.removeProfessor(map);
		
		return new Gson().toJson(resultMap); 
	}
	
	@RequestMapping(value = "/professor/add.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String add(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap = professorService.addProfessor(map);
		
		return new Gson().toJson(resultMap); 
	}
	
	@RequestMapping(value = "/professor/info.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String info(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap = professorService.getProfessor(map);
		
		return new Gson().toJson(resultMap); 
	}
	
		@RequestMapping(value = "/professor/edit.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String edit_(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap = professorService.editProfessor(map);
		
		return new Gson().toJson(resultMap); 
	}
		
	// Department		
	@RequestMapping(value = "/professor/dept-list.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String deptList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap = professorService.getDeptList(map);
		
		return new Gson().toJson(resultMap); 
	}
		
	
}
