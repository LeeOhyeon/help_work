<%@page import="java.util.HashMap"%>
<%@page import="com.help.project.model.vo.Project"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/views/common/header.jsp"%>
<link href="https://fonts.googleapis.com/css2?family=Do+Hyeon&display=swap" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Jua&family=Nanum+Gothic&family=Sunflower:wght@300&display=swap" rel="stylesheet">
<%
	Member logMem=(Member)session.getAttribute("loginMember");
	String memId=logMem.getMemberId();
	//로그인한 사원이 참여중인 모든 프로젝트 리스트
	List<Project> join=(List<Project>)request.getAttribute("joinPro");
	//키값:플젝번호 밸류:참여자수
	HashMap<Integer,Integer> joinNum=(HashMap<Integer,Integer>)request.getAttribute("joinNum");


%>
<style>
#wrapper-Project {
	width: 100%;
	padding : 30px;
	display: grid;
}

#project_favor, .project_ing {
	width: 100%;
	margin: 30px 30px;
}

.input-group {
	width: 400px;
}

.project_content_favor {
	width: 20%;
	height: 20%;
	background-color: yellow;
	float: left;
	margin: 10px 10px;
}

.project_content_ing {
	width: 210px;
	height: 210px;
	float: left;
	margin: 10px 10px;
	border-radius: 30px;
	padding: 20px;
	overflow: hidden;
	border: 1px solid #6308f575;
}
.project_content_ing:hover {
	color:black;
	background-color:#6710f242;
}

.search_Project{
	margin-left: 30px;
}
.project_content{
font-family:'Do Hyeon';
font-size: 20px;
}
.input-group{
 margin-top: 15px;
}
.btn-outline-secondary{
 	border:1px solid #6710f242;
    color: #6710f242;
}
.btn-outline-secondary:hover{
 	border:1px solid #6710f242;
    color: #6710f242;
    background-color: #6710f242;
}
</style>



<main>
	<div id="wrapper-Project">
		<!-- 내프로젝트를 눌렀을때 보여지는 첫 화면  -->
		<div class="search_Project">
			<div class="project_content" style="font-size: 25px;"><%=loginMember.getMemberName()%>님의 프로젝트</div>
			<div style="display: inline-block;">
				<select name="search-project-op" class="form-select">
					<option value="projectTitle">프로젝트 명</option>
					<option value="ProjectMember">프로젝트 생성자</option>
					<option value="ProjectNo">프로젝트 번호</option>
				</select>
			</div>
			<div style="display: inline-block;">
				<div class="input-group mb-3">
				 <input id="searchText" type="text" class="form-control"
					aria-label="Recipient's username" aria-describedby="button-addon2">
				<button class="btn btn-outline-secondary" type="button"
					id="button-addon2" onclick="search();">
					<i class="fas fa-search"></i>
				</button>
			</div>
			</div>
			
		</div>
		<div class="project_ing">
			<h2 style="font-family:'Do Hyeon'; ">참여 프로젝트</h2>
			<div>
				<!-- 	출력될공간 -->
				<%
				if(join!=null){
					for (Project p:join) {
					%>

					<div name="defaultView">
						<div class="project_content_ing" style="cursor:pointer;"
						onclick="location.assign('<%=request.getContextPath()%>/project/selectProjectDetailViewToList.do?projectNo=<%=p.getProjectNo() %>')">
							<div class="project_content" style="text-align: right;"><%=p.getProjectNo() %></div>
							<div class="project_content" style="font-size: 23px;"><%=p.getProName() %></div>
							<div style="font-family:'Do Hyeon';font-size:16px; height: 50px; overflow: hidden; font-family: 'Nanum Gothic'; "><%=p.getProExplain() %></div>
							<div class="project_content" style="font-size: 16px;"><i class="fas fa-user-edit"></i>&nbsp;<%=p.getMemberId() %></div>
							
							<div class="project_content" style="font-size: 16px;"><i class="fas fa-users"></i>&nbsp;<%=joinNum.get(p.getProjectNo()) %></div>
						</div>
					</div>
				
					<% } %>
					
				<div name="searchView" style="display:none;">
					
				</div>
				
				<% }%>
			</div>
		</div>
	</div>



<script>
	function search(callBack){
		const memberId="<%=memId%>";
		var searchText=$("#searchText").val();//검색할 단어
		var searchKey=$("select[name=search-project-op]").val();//검색옵션
		$.ajax({
			url: "<%=request.getContextPath()%>/project/SelectProjectNameMainViewServlet.do",
			type : 'post',
			data: {"memId":memberId,"searchText":searchText,"searchKey":searchKey},
			dataType : 'json',
			success : data=>{   
				if(data.length!=0){
					$("div[name=defaultView]").hide();
					$("div[name=searchView]").show();
					let div0=$("<div>");
					for(let i=0;i<data.length;i++){
						console.log(data[i]);
						let div=$("<div class='project_content_ing' style='cursor:pointer;' onclick='pageTrans(this);'>");
						let proNo=$("<div>").html(data[i]["projectNo"]);
						let proName=$("<div>").html(data[i]["proName"]);
						let proExp=$("<div>").html(data[i]["proExplain"]);
						let writer=$("<div>").html(data[i]["memberName"]);
						let memCount=$("<div>").html("참여인원:"+findCount(data[i]["projectNo"]));
						div.append(proNo).append(proName).append(proExp).append(writer).append(memCount);
						div0.append(div);
					}
					$("div[name=searchView]").html(div0); //여기다출력해
				}else{
					alert("검색 결과가 없어요~~!")
				}
			}
		});
		
	}
	function findCount(proNo){
		//참여자 수를 구해옵니다
		let memCount;
		$.ajax({
			url: "<%=request.getContextPath()%>/project/SelectProMemberCountServlet.do",
			type:"post",
			data:{"proNo":proNo },
			async:false,
			dataType:'json',
			success : data =>{
				memCount=data;
			}
		});
		return memCount;
	}
	function pageTrans(e){
		let proNo=$(e).children().eq(0).text();
		url = "<%=request.getContextPath()%>/project/selectProjectDetailViewToList.do?projectNo=";
		location.assign(url+proNo);
	}
</script>
</main>


<%@ include file="/views/common/footer.jsp"%>