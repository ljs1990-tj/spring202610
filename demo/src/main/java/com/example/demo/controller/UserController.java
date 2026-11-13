package com.example.demo.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;

import com.example.demo.dao.UserService;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;

import ch.qos.logback.core.recovery.ResilientSyslogOutputStream;

@Controller
public class UserController {
	@Autowired
	UserService userService;

	@Value("${client_id}")
	private String client_id;

	@Value("${redirect_uri}")
	private String redirect_uri;

	@RequestMapping("/login.do")
	public String test(Model model) throws Exception {
		String location = "https://kauth.kakao.com/oauth/authorize?response_type=code&client_id=" + client_id
				+ "&redirect_uri=" + redirect_uri;
		model.addAttribute("location", location);

		return "/user/login";
	}

	@RequestMapping("/join.do")
	public String join(Model model) throws Exception {

		return "/user/join";
	}

	@RequestMapping("/addr.do")
	public String addr(Model model) throws Exception {

		return "/user/jusoPopup";
	}

	// 비밀번호 찾기
	@RequestMapping("/password.do")
	public String password(Model model) throws Exception {

		return "/user/password";
	}

	@RequestMapping(value = "/auth.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String password(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		String impUid = (String) map.get("impUid");
		try {
			// 1. 포트원 Access Token 발급
			String tokenUrl = "https://api.iamport.kr/users/getToken";

			RestTemplate restTemplate = new RestTemplate();

			HttpHeaders tokenHeaders = new HttpHeaders();
			tokenHeaders.setContentType(MediaType.APPLICATION_JSON);

			Map<String, String> tokenParams = new HashMap<>();
			tokenParams.put("imp_key", "");
			tokenParams.put("imp_secret", "");

			HttpEntity<Map<String, String>> tokenEntity = new HttpEntity<>(tokenParams, tokenHeaders);

			ResponseEntity<Map> tokenResponse = restTemplate.postForEntity(tokenUrl, tokenEntity, Map.class);

			Map tokenBody = tokenResponse.getBody();

			if (tokenBody == null || tokenBody.get("code") == null
					|| ((Number) tokenBody.get("code")).intValue() != 0) {

				throw new Exception("포트원 토큰 발급 실패");
			}

			Map tokenData = (Map) tokenBody.get("response");

			String accessToken = (String) tokenData.get("access_token");

			// 2. 본인인증 정보 조회
			String certUrl = "https://api.iamport.kr/certifications/" + impUid;

			HttpHeaders certHeaders = new HttpHeaders();
			certHeaders.set("Authorization", accessToken);

			HttpEntity<Void> certEntity = new HttpEntity<>(certHeaders);

			ResponseEntity<Map> certResponse = restTemplate.exchange(certUrl, HttpMethod.GET, certEntity, Map.class);

			Map certBody = certResponse.getBody();

			if (certBody == null || certBody.get("code") == null || ((Number) certBody.get("code")).intValue() != 0) {

				throw new Exception("본인인증 정보 조회 실패");
			}

			// 3. 인증정보 추출
			Map userInfo = (Map) certBody.get("response");

			if (userInfo == null || !impUid.equals(userInfo.get("imp_uid"))) {

				throw new Exception("인증정보가 일치하지 않습니다.");
			}
			
			System.out.println(userInfo);
			String name = (String) userInfo.get("name");
			String phone = (String) userInfo.get("phone");
			String birthday = (String) userInfo.get("birthday");

			System.out.println("===== 본인인증 성공 =====");
			System.out.println("이름 : " + name);
			System.out.println("휴대폰 : " + phone);
			System.out.println("생년월일 : " + birthday);

			map.put("phone", phone);
			resultMap = userService.getUserAuth(map);
			// 4. 인증정보 반환
//			resultMap.put("success", true);
//			resultMap.put("name", name);
//			resultMap.put("phone", phone);
//			resultMap.put("birthday", birthday);

		} catch (Exception e) {

			e.printStackTrace();

			resultMap.put("success", false);
			resultMap.put("message", "본인인증 정보 조회에 실패했습니다.");
		}

		return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/login.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String login(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		resultMap = userService.login(map);

		return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/join.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String add(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		resultMap = userService.addUser(map);

		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/edit-pwd.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String edit_pwd(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		resultMap = userService.editPassword(map);

		return new Gson().toJson(resultMap);
	}

	@RequestMapping(value = "/kakao.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String kakao(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		String tokenUrl = "https://kauth.kakao.com/oauth/token";

		RestTemplate restTemplate = new RestTemplate();
		MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
		params.add("grant_type", "authorization_code");
		params.add("client_id", client_id);
		params.add("redirect_uri", redirect_uri);
		params.add("code", (String) map.get("code"));
		// (String) map.get("code")

		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

		HttpEntity<MultiValueMap<String, String>> request = new HttpEntity<>(params, headers);
		ResponseEntity<Map> response = restTemplate.postForEntity(tokenUrl, request, Map.class);

		Map<String, Object> responseBody = response.getBody();
		resultMap = (HashMap<String, Object>) getUserInfo((String) responseBody.get("access_token"));
		System.out.println(resultMap);

		return new Gson().toJson(resultMap);
	}

	private Map<String, Object> getUserInfo(String accessToken) {
		String userInfoUrl = "https://kapi.kakao.com/v2/user/me";

		RestTemplate restTemplate = new RestTemplate();
		HttpHeaders headers = new HttpHeaders();
		headers.setBearerAuth(accessToken);
		HttpEntity<String> entity = new HttpEntity<>(headers);

		ResponseEntity<String> response = restTemplate.exchange(userInfoUrl, HttpMethod.GET, entity, String.class);

		try {
			ObjectMapper objectMapper = new ObjectMapper();
			return objectMapper.readValue(response.getBody(), Map.class);
		} catch (Exception e) {
			e.printStackTrace();
			return null; // 예외 발생 시 null 반환
		}
	}

}
