package com.help.project.work.ajaxController;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;
import com.help.project.work.model.service.WorkService;
import com.help.project.work.model.vo.WorkSelectManagerJoin;

/**
 * Servlet implementation class SelectWorkAllSearchServlet
 */
@WebServlet("/work/SelectWorkAllSearchServlet.do")

public class SelectWorkAllSearchServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public SelectWorkAllSearchServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		//전체 업무조회 검색기능 
		String ing=request.getParameter("ing").trim().replace(" ","");//진행상황(요청,진행,피드백,완료,보류)
		String prior=request.getParameter("prior").trim().replace(" ", "");//우선순위(긴급,높음,보통,낮음)
		String h4=request.getParameter("h4").trim().replace(" ", "");
		String logId=request.getParameter("logId");
		
		//전체 업무 개수 구하기
		List<WorkSelectManagerJoin> result=new WorkService().searchMine(ing, prior, h4,logId);
		int totalData=result.size();//전체 데이터 개수 
		System.out.println("전체데이터"+totalData);
		//페이징 처리
		int cPage;
		try {
			cPage=Integer.parseInt(request.getParameter("cPage"));
		}catch(NumberFormatException e) {
			cPage=1;
		}
		int numPerPage = 20;
		//try {
		//	numPerPage=Integer.parseInt(request.getParameter("numPerPage"));
		//}catch(NumberFormatException e) {
		//	numPerPage=10;
		//}
		
		//페이징 처리해서 가져온 목록
		List<WorkSelectManagerJoin> resultList=new WorkService().searchMine(ing, prior, h4,logId,cPage,numPerPage);
		
		int totalPage=(int)Math.ceil((double)totalData/numPerPage);
		int pageBarSize=5;
		int pageNo=((cPage-1)/pageBarSize)*pageBarSize+1;//시작
		int pageEnd=pageNo+pageBarSize-1;//끝
		
		String pageBar="";
		if(pageNo==1) {
			pageBar+="<span>[이전]</span>";
		}else {
			pageBar+="<a href='javascript:workSearchPaging("+(pageNo-1)+");'>[이전]</a>";
		}
		while(!(pageNo>pageEnd||pageNo>totalPage)) {
			if(pageNo==cPage) {
				pageBar+="<span>"+pageNo+"</span>";	
			}else {
				pageBar+="<a href='javascript:workSearchPaging("+(pageNo)+");'>"+pageNo+"</a>";
			}
			pageNo++;
		}
		if(pageNo>totalPage) {
			pageBar+="<span>[다음]</span>";	
		}else {
			pageBar+="<a href='javascript:workSearchPaging("+(pageNo)+");'>"+"[다음]"+"</a>";
		}
		
		
		
		
		Map<String, Object> param=Map.of("pageBar",pageBar,"list",resultList);
		response.setContentType("application/json;charset=utf-8");
		new Gson().toJson(param,response.getWriter());
		
	
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
