<%@page import="com.help.project.model.vo.ProjectAddMember"%>
<%@page import="java.util.Arrays"%>
<%@page import="com.help.project.model.vo.ProMemberJoinMember"%>
<%@page import="java.util.List"%>
<%@page import="com.help.project.model.vo.Project"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/views/common/header.jsp" %>
<!-- projectDetailView의 css가져옴 -->
<link href="https://fonts.googleapis.com/css2?family=Do+Hyeon&display=swap" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Jua&family=Sunflower:wght@300&display=swap" rel="stylesheet">
<link rel ="stylesheet" href="<%=request.getContextPath()%>/css/projectDetailView.css" type="text/css">
<%//project -> '파일' 눌렀을때 뜨는 상세 화면입니다. 
   Project p = (Project)request.getAttribute("projectInfo");
   List<ProMemberJoinMember> pMember = (List)request.getAttribute("ProMemberJoinMember");
   
%>
<style>
#input-group{
	display:flex;
	justify-content:center;
	align-items:center;
}
</style>

<main>

<div id="title-container">
   <div id="pro-bookmark-star"><i class="fas fa-star"></i></div>
   <div id="project-title" style="font-family:'Jua'"><span><%=p.getProName() %></span></div>
  <div id="project-explain" style="font-family:'Do Hyeon'; font-size:22px;"><%=p.getProExplain() %></div>
   <div style="float:right;">
   <%if(loginMember.getMemberId().equals(p.getMemberId())){ %> <!-- 현재 로그인된 멤버와, 프로젝트 생성자 아이디가 같으면 초대 버튼 활성화 -->
   <button type="button" class="btn btn-outline-secondary" data-bs-toggle="modal" data-bs-target="#addProjectMemberModal" id="add_btn">사원 추가</button>
   <%} %>
   </div>
</div>


<div id="menu-container">
   <ul class="nav">
      <li class="nav-item" style="font-family:'Sunflower'"><a class="nav-link active" aria-current="page" href="#" onclick="location.assign('<%=request.getContextPath()%>/project/selectProjectDetailViewToList.do?projectNo=<%=p.getProjectNo()%>')">홈</a></li>
      <li class="nav-item" style="font-family:'Sunflower'"><a class="nav-link" href="#">파일</a></li>
   </ul>
</div>


<div id="pro_container">
   <div id="inner_pro_container" style="padding: 20px;">

<!-- 	   파일 검색  -->
	   <div class="input-group mb-3"  style="width: 400px;">
            <div>
               <select class="form-select" aria-label="Default select example" style="width: 140px;" id="searchFileForWhat">
                  <option value="fileName" selected>파일 이름</option>
               </select>
            </div>        
            <input type="text" class="form-control" id="FileSearchText"placeholder="keyword" aria-label="Recipient's username" aria-describedby="button-addon2" id="searchConKeyword">
            <button class="btn btn-outline-secondary" type="button" id="searchFile">검색</button>
      </div>
      
	   <!-- 파일출력공간 -->
	   <div id="fileList">
	   		<div id="AllFileList"></div>
	   		<!-- 검색결과출력 -->
	   		<div id="SearchResult"></div>
	   </div>
	   
   </div>


</div>
   
   
<script>
	$(()=>{//로드되자마자 실행 
		$("#SearchResult").hide();//검색결과출력하는거 기본으로 숨김처리
	
		let proNo=<%=p.getProjectNo()%>;//프로젝트번호 
		//테이블만들자 
		let table=$("<table class='mytable'>");
		table.html("<thead><tr><th style='padding-left:20px;'>게시글명</th><th style='padding-left:20px;'>파일명</th></td></thead>")				
		//업무 파일 불러오기
		$.ajax({
			url: "<%=request.getContextPath()%>/project/WorkFileInProjectEndServlet.do",
			type: "post",
			data : {"proNo":proNo},
			success : data =>{
				//위의 테이블에 이어붙일거란다 
				for(let i=0;i<data.length;i++){
					let tr2=$("<tr>");
					let title=$("<td>").html(data[i]["contentTitle"]);
					let oriFileName=$("<td onclick='WorkfileDownload(this);' style='cursor:pointer;'>").html(data[i]["workOriFileName"])
					let reFileName=$("<td style='visibility:hidden'>").html(data[i]["workReFileName"]);
					tr2.append(title).append(oriFileName).append(reFileName);
					table.append(tr2);
				}
			}
		});
		//일반 파일 불러오기
		$.ajax({
			url: "<%=request.getContextPath()%>/project/NormalFileInProjectEndServlet.do",
			type: "post",
			data : {"proNo":proNo},
			success : data =>{
				//위의 업무파일에 이어붙일거란다 
				for(let i=0;i<data.length;i++){
					let tr2=$("<tr >");
					let title=$("<td>").html(data[i]["contentTitle"]);
					let oriFileName=$("<td onclick='NormalfileDownload(this);' style='cursor:pointer;'>").html(data[i]["workOriFileName"])
					let reFileName=$("<td style='visibility:hidden'>").html(data[i]["workReFileName"]);
					tr2.append(title).append(oriFileName).append(reFileName);
					table.append(tr2);
				}
				$("#AllFileList").html(table);//이걸써줘야 써지겠지
			}
		});
		
	});
	
	//검색하기 기능
	$("#searchFile").click(e=>{
		searchFile();
	});
	
	//검색하기 기능
	function searchFile(){
		//기존테이블 지워줘 
		$("#AllFileList").hide();
		$("#SearchResult").show();
		let proNo=<%=p.getProjectNo()%>;//프로젝트번호 
		//테이블
		let table=$("<table class='mytable'>");
		let tr=$("<tr>");
		let th=$("<th>").html("게시글 제목");
		let th1=$("<th>").html("첨부된 파일");
		tr.append(th).append(th1);
		table.append(tr);
		
		
		let searchWhat= $("#searchFileForWhat option:selected").val();//파일이름인지,확장자인지
		let text=$("#FileSearchText").val();//입력한 글자
		let choName1="fileName";
		//let choName2="fileExt";
		console.log(searchWhat);
		console.log(text);
		//if(searchWhat==choName1){
			$.ajax({//업무파일검색
				url: "<%=request.getContextPath()%>/project/SelectWorkFileInProjectServlet.do",
				type: "post",
				data : {"proNo":proNo, "text":text},
				success : data =>{
					//위의 테이블에 이어붙임
					for(let i=0;i<data.length;i++){
						let tr2=$("<tr >");
						let title=$("<td>").html(data[i]["contentTitle"]);
						let oriFileName=$("<td onclick='WorkfileDownload(this);' style='cursor:pointer;'>").html(data[i]["workOriFileName"])
						let reFileName=$("<td style='visibility:hidden'>").html(data[i]["workReFileName"]);
						tr2.append(title).append(oriFileName).append(reFileName);
						table.append(tr2);
					}
					$("#SearchResult").html(table);//이걸써줘야 써지겠지
				}
			});
			
			$.ajax({//일반 파일 검색 
				url: "<%=request.getContextPath()%>/project/SelectNormalFileInProjectServlet.do",
				type: "post",
				data : {"proNo":proNo,"text":text},
				success : data =>{
					//위의 업무파일에 이어붙일거란다 
					for(let i=0;i<data.length;i++){
						let tr2=$("<tr >");
						let title=$("<td>").html(data[i]["contentTitle"]);
						let oriFileName=$("<td onclick='NormalfileDownload(this);' style='cursor:pointer;'>").html(data[i]["workOriFileName"])
						let reFileName=$("<td style='visibility:hidden'>").html(data[i]["workReFileName"]);
						tr2.append(title).append(oriFileName).append(reFileName);
						table.append(tr2);
					}
					$("#SearchResult").html(table);//이걸써줘야 써지겠지
				}
			});
			
		/* }else{
			alert("확장자ㅗㄹ 찾으세용");//근데확장자도,..같이저장이되어있어서....나중에 보충하자...
		} */
	}
	

	function WorkfileDownload(e){//업무파일다운
		let oriFileName=$(e).text();
		let reFileName=$(e).next().text();
		
		//workFIleDownServlet으로보내
		const url = "<%=request.getContextPath()%>/project/workfileDownload.do";
	    const encode = encodeURIComponent(oriFileName);
	    location.assign(url+"?workOriFileName="+encode+"&&workReFileName="+reFileName);
	}
	
	function NormalfileDownload(e){//일반파일다운
		let oriFileName=$(e).text();
		let reFileName=$(e).next().text();
		
		const url = "<%=request.getContextPath()%>/project/normalfileDownload.do";
	    const encode = encodeURIComponent(oriFileName);
	    location.assign(url+"?normalOriFileName="+encode+"&&normalReFileName="+reFileName); 
	}
	
			
			
			
</script>




</main>
<%@ include file="/views/common/footer.jsp" %>