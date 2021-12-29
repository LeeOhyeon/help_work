package com.help.common.filter;

import java.nio.charset.Charset;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Base64;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;

public class PasswordEncryptorWrapper extends HttpServletRequestWrapper{
	
	public PasswordEncryptorWrapper(HttpServletRequest request) {
		super(request);
	}
	
	
	@Override
	   public String getParameter(String name) {
	      if(name.equals("memberPwd")||name.equals("password_new")) {
	         String oriPw=super.getParameter(name);
	         System.out.println(oriPw);
	         String encPw=getSHA512(oriPw);
	         System.out.println(encPw);
	         return encPw;
	      }else {
	         return super.getParameter(name);
	      }
	   }
	
	//암호화처리 메소드 생성
	private String getSHA512(String oriPw) {
		String encPwd="";
		MessageDigest md=null;
		try {
			md=MessageDigest.getInstance("SHA-512");
		}catch(NoSuchAlgorithmException e) {
			e.printStackTrace();
		}
		byte[] bytes=oriPw.getBytes(Charset.forName("UTF-8"));
		md.update(bytes);
		encPwd=Base64.getEncoder().encodeToString(md.digest());
		
		return encPwd;
	}
}
