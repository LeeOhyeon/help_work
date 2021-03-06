package com.help.attendance.controller;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.gson.Gson;
import com.help.attendance.model.service.AttendanceService;
import com.help.attendance.model.vo.Attendance;
import com.help.member.model.vo.Member;

@WebServlet("/attendance/LoadAttTime.do")
public class LoadAttTimeServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public LoadAttTimeServlet() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session=request.getSession();
		Member loginMember=(Member)session.getAttribute("loginMember");
		String memberId=loginMember.getMemberId();
		
		String attDate = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
		
		Attendance a = null;
		String leaveTime=null;
		String attTime=null;
		
		try {
			a = new AttendanceService().outputAttTime(memberId,attDate);
			attTime=a.getAttTime();
			if(a.getLeaveTime().equals("퇴근 정보가 없습니다")) {
				leaveTime="";
			} else {
				leaveTime=a.getLeaveTime();
			}
		} catch(NullPointerException e) {
			leaveTime="";
			attTime="";
		}
		
		Map<String, String> param = Map.of("leaveTime",leaveTime,"attTime",attTime);
		response.setContentType("application/json;charset=utf-8");
		new Gson().toJson(param,response.getWriter());
	
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
