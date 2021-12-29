package com.help.project.ajaxController;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONObject;

import com.google.gson.Gson;
import com.help.project.model.service.ProjectService;
import com.help.project.model.vo.ProMemberJoinMember;
import com.help.project.model.vo.Project;

/**
 * Servlet implementation class SelectProjectInMemberServlet
 */
@WebServlet("/project/selectProjectInMember.do")
public class SelectProjectInMemberServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public SelectProjectInMemberServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		//현재 프로젝트에 참여중인 사원 목록
		int projectNo = Integer.parseInt(request.getParameter("projectNo"));
		List<ProMemberJoinMember> proMemberList = new ProjectService().selectProjectJoinMemberList(projectNo);

		//해당 프로젝트 작성자 가져오기
		Project pinfo = new ProjectService().selectProjectOne(projectNo);
		
		System.out.println(pinfo);
		
		Map<String, Object> data = new HashMap<String, Object>();
		data.put("proMemberList", proMemberList);
		data.put("creatorId", pinfo.getMemberName());
		
		
		response.setContentType("application/json; charset=utf-8");
		new Gson().toJson(data,response.getWriter());

		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
