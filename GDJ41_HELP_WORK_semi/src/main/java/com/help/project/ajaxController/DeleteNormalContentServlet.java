package com.help.project.ajaxController;

import java.io.File;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.help.project.model.service.ProjectService;

/**
 * Servlet implementation class deleteNormalContentServlet
 */
@WebServlet("/project/deleteNormalContent.do")
public class DeleteNormalContentServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public DeleteNormalContentServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		int normalContentNo = Integer.parseInt(request.getParameter("normalContentNo"));
		
		//파일 삭제
		String[] fileArr = request.getParameterValues("fileArr");
		String realPath = request.getServletContext().getRealPath("/upfile/normal/");
		
		if(fileArr.length != 0) {
			for(int i=0;i<fileArr.length;i++) {
				File f = new File(realPath+fileArr[i]);
				if(f.exists()) {
					f.delete();
				}
			}	
		}
		
		
		
		int result = new ProjectService().deleteNormalContent(normalContentNo);
		
		if(result<0) {
			response.getWriter().write("삭제 실패!");
		}
		
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
