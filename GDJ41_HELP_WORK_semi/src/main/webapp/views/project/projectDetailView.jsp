<%@page import="com.help.project.model.vo.ProjectAddMember"%>
<%@page import="java.util.Arrays"%>
<%@page import="com.help.project.model.vo.ProMemberJoinMember"%>
<%@page import="java.util.List"%>
<%@page import="com.help.project.model.vo.Project"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ include file="/views/common/header.jsp"%>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=2117f58ed9ba4b4e13a9bca2bc216232&&APIKEY&libraries=services"></script>
<link href="https://fonts.googleapis.com/css2?family=Do+Hyeon&display=swap" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Jua&family=Sunflower:wght@300&display=swap" rel="stylesheet">
<link rel ="stylesheet" href="<%=request.getContextPath()%>/css/projectDetailView.css" type="text/css">
<%
   Project p = (Project)request.getAttribute("projectInfo");
   List<ProMemberJoinMember> pMember = (List)request.getAttribute("ProMemberJoinMember");
%>
<style>
   /* .form-select{
      width: 120px;
   }
 */</style>
<script>
$(document).ready(()=>{
   contentListAjax();
   proInMemberList();
   
});

function contentListAjax(cPage){
   let projectNo = $("#projectNo").val();
   //프로젝트 게시글 가져오기
   $.ajax({
      url : "<%=request.getContextPath()%>/project/selectAllProjcetContent.do",
      type:"post",
      data:{"projectNo":projectNo,"cPage":cPage},
      dataType:"json",
      success:data=>{
         
         $("#contentArea").html("");
         $("#pageNavContainer").html("");
         const memberList = data["pList"];
         
         const table = $("<table style='text-align:center;'>");
         table.addClass("mytable");
         const thead = "<thead><tr><th scope='col'>구분</th><th scope='col'>제목</th><th scope='col'>작성자</th><th scope='col'>작성일</th><th scope='col'>상태</th><th scope='col'>순위</th></tr></thead>";
         table.append(thead);
         
         for(let i = 0; i< memberList.length;i++){
            
            const tr = $("<tr onclick='contentView(this);'>");
            
            let dist;
            if(memberList[i]['dist'] == "게시글"){
            	dist = $("<td>").html("<sapn style='margin-right:10px; color:rgb(235, 142, 4)'><i class='fas fa-align-justify'></i></sapn>"+memberList[i]['dist']);	
            	tr.prepend(dist);
            }else if(memberList[i]['dist'] == "업무"){
            	 dist = $("<td>").html("<sapn style='margin-right:10px;color:rgb(77, 0, 128)'><i class='fas fa-tasks'></i></sapn>"+memberList[i]['dist']);	
            	tr.prepend(dist);
            }else{
            	dist = $("<td>").html("<sapn style='margin-right:10px; color:rgba(66, 217, 255, 0.719);'><i class='far fa-calendar'></i></sapn>"+memberList[i]['dist']);	
            	tr.prepend(dist);
           }
            
            const contentTitle = $("<td style='cursor: pointer;'>").html(memberList[i]["contentTitle"]);
            const memberName = $("<td>").html(memberList[i]["memberName"]);
            const writeDate = $("<td>").html(memberList[i]["writeDate"]);
            const memberId = $("<td style='display:none;'>").html(memberList[i]["memberId"]);
            const contentNo = $("<td style='display:none;'>").html(memberList[i]["contentNo"]);
            
            tr.append(dist).append(contentTitle).append(memberName).append(writeDate);
            
            
            
            let workIng = $("<td>");
            if(memberList[i]["workIng"] =='요청'){
            	workIng = $("<td>").html("<span style='background-color:rgba(0, 204, 255, 0.753); padding:10px; border-radius:15px;'>"+memberList[i]["workIng"]+"</span>");
            }else if(memberList[i]["workIng"] =='진행'){
            	workIng = $("<td>").html("<span style='background-color:rgba(145, 255, 0, 0.753); padding:10px; border-radius:15px;'>"+memberList[i]["workIng"]+"</span>");
            }else if(memberList[i]["workIng"] =='피드백'){
            	workIng = $("<td>").html("<span style='background-color:rgba(255, 208, 0, 0.753); padding:10px; border-radius:15px;'>"+memberList[i]["workIng"]+"</span>");
            }else if(memberList[i]["workIng"] =='보류'){
            	workIng = $("<td>").html("<span style='background-color:rgba(161, 161, 161, 0.548); padding:10px; border-radius:15px;'>"+memberList[i]["workIng"]+"</span>");
            }else if(memberList[i]["workIng"] =='완료'){
            	workIng = $("<td>").html("<span style='background-color:rgb(108, 33, 230); padding:10px; border-radius:15px;'>"+memberList[i]["workIng"]+"</span>");
            }else{
            	tr.append(workIng);
            }
            tr.append(workIng);
            
            let workRank = $("<td>");
            if(memberList[i]["workRank"] =='긴급'){
            	workRank = $("<td style='color:red'>").html(memberList[i]["workRank"]);
            }else if(memberList[i]["workRank"] =='높음'){
            	workRank = $("<td style='color:orange'>").html(memberList[i]["workRank"]);
            }else if(memberList[i]["workRank"] =='보통'){
            	workRank = $("<td style='color:gray'>").html(memberList[i]["workRank"]);
            }else if(memberList[i]["workRank"]== '낮음'){
            	workRank = $("<td style='color:rgba(0, 204, 255, 0.753);'>").html(memberList[i]["workRank"]);
            }else{
            	tr.append(workRank);
            }
            tr.append(workRank);
           
           tr.append(memberId).append(contentNo);
           table.append(tr);
         }
         const div=$("<div style='text-align:center;'>").attr("id","pageBar").html(data["pageBar"]);
         $("#contentArea").append(table)
         $("#pageNavContainer").append(div);
         
      }
      
   });
}



//프로젝트 검색 게시글 가져오기
function searchListAjax(cPage){
   let dist = $("input[name=selectContentRadio]:checked").val();
   let projectNo = $("#projectNo").val();
   let searchType = $("#searchConSelect").val();
   let keyword = $("#searchConKeyword").val();
   
   $.ajax({
      url: "<%=request.getContextPath()%>/project/searchAllContent.do",
      dataType:"json",
      data:{keyword:keyword
         ,searchType:searchType
         ,projectNo:projectNo,
         dist:dist,
         cPage:cPage},
      success:data=>{
    	 $("#pageNavContainer").html("");
    	 
         $("#contentArea").html("");
         $("#searchConKeyword").val("");
         const memberList = data["pList"];
         
         const table = $("<table class='mytable' style='text-align:center;'>");
         const thead = "<thead><tr><th scope='col'>구분</th><th scope='col'>제목</th><th scope='col'>작성자</th><th scope='col'>작성일</th><th scope='col'>상태</th><th scope='col'>순위</th></tr></thead>";
         table.append(thead);
         
         for(let i = 0; i< memberList.length;i++){
             
             const tr = $("<tr onclick='contentView(this);'>");
             
             let dist;
             if(memberList[i]['dist'] == "게시글"){
             	dist = $("<td>").html("<sapn style='margin-right:10px; color:rgb(235, 142, 4)'><i class='fas fa-align-justify'></i></sapn>"+memberList[i]['dist']);	
             	tr.prepend(dist);
             }else if(memberList[i]['dist'] == "업무"){
             	 dist = $("<td>").html("<sapn style='margin-right:10px;color:rgb(77, 0, 128)'><i class='fas fa-tasks'></i></sapn>"+memberList[i]['dist']);	
             	tr.prepend(dist);
             }else{
             	dist = $("<td>").html("<sapn style='margin-right:10px; color:rgba(66, 217, 255, 0.719);'><i class='far fa-calendar'></i></sapn>"+memberList[i]['dist']);	
             	tr.prepend(dist);
            }
             
             const contentTitle = $("<td style='cursor: pointer;'>").html(memberList[i]["contentTitle"]);
             const memberName = $("<td>").html(memberList[i]["memberName"]);
             const writeDate = $("<td>").html(memberList[i]["writeDate"]);
             const memberId = $("<td style='display:none;'>").html(memberList[i]["memberId"]);
             const contentNo = $("<td style='display:none;'>").html(memberList[i]["contentNo"]);
             
             tr.append(dist).append(contentTitle).append(memberName).append(writeDate);
             
             
             
             let workIng = $("<td>");
             if(memberList[i]["workIng"] =='요청'){
             	workIng = $("<td>").html("<span style='background-color:rgba(0, 204, 255, 0.753); padding:10px; border-radius:15px;'>"+memberList[i]["workIng"]+"</span>");
             }else if(memberList[i]["workIng"] =='진행'){
             	workIng = $("<td>").html("<span style='background-color:rgba(145, 255, 0, 0.753); padding:10px; border-radius:15px;'>"+memberList[i]["workIng"]+"</span>");
             }else if(memberList[i]["workIng"] =='피드백'){
             	workIng = $("<td>").html("<span style='background-color:rgba(255, 208, 0, 0.753); padding:10px; border-radius:15px;'>"+memberList[i]["workIng"]+"</span>");
             }else if(memberList[i]["workIng"] =='보류'){
             	workIng = $("<td>").html("<span style='background-color:rgba(161, 161, 161, 0.548); padding:10px; border-radius:15px;'>"+memberList[i]["workIng"]+"</span>");
             }else if(memberList[i]["workIng"] =='완료'){
             	workIng = $("<td>").html("<span style='background-color:rgb(108, 33, 230); padding:10px; border-radius:15px;'>"+memberList[i]["workIng"]+"</span>");
             }else{
             	tr.append(workIng);
             }
             tr.append(workIng);
             
             let workRank = $("<td>");
             if(memberList[i]["workRank"] =='긴급'){
             	workRank = $("<td style='color:red'>").html(memberList[i]["workRank"]);
             }else if(memberList[i]["workRank"] =='높음'){
             	workRank = $("<td style='color:orange'>").html(memberList[i]["workRank"]);
             }else if(memberList[i]["workRank"] =='보통'){
             	workRank = $("<td style='color:gray'>").html(memberList[i]["workRank"]);
             }else if(memberList[i]["workRank"]== '낮음'){
             	workRank = $("<td style='color:rgba(0, 204, 255, 0.753);'>").html(memberList[i]["workRank"]);
             }else{
             	tr.append(workRank);
             }
             tr.append(workRank);
            
            tr.append(memberId).append(contentNo);
            table.append(tr);
          }
         const div=$("<div style='text-align:center;'>").attr("id","pageBar").html(data["pageBar"]);
         $("#contentArea").append(table);
         $("#pageNavContainer").append(div);
         
         
      }
      
   });
}


//프로젝트 참여자 리스트 가져오기
function proInMemberList(){
   let projectNo = $("#projectNo").val();
   $.ajax({
      url : "<%=request.getContextPath()%>/project/selectProjectInMember.do",
      type:"post",
      data : {"projectNo":projectNo},
      dataType:"json",
      success:data=>{
        console.log(data);
         const creatorId = data["creatorId"];
         $("#proCreator").html("<i class='far fa-user-circle'></i>&nbsp;"+creatorId);
         
         $("#proAttend").html("");
         const ul = $("<ul class='list-group list-group-flush'>");
         for(let i=0;i<data["proMemberList"].length;i++){
            if(creatorId != data['proMemberList'][i]['memberId']){
            	
            const li =$("<li class='list-group-item'>").html("<i class='fas fa-user-alt'></i>&nbsp;"+data["proMemberList"][i]["memberName"]);
            ul.append(li);
            $("#proAttend").append(ul);
            }      
         }
         
      }
   });      
}



function contentView(e){
   
   let val = $(e).children();   
   let dist = val.eq(0).text();
   let contentNo = val.eq(7).text();

   //프로젝트 생성자, 글 쓴 사람, 로그인 한사람
   let loginMember ="<%=loginMember.getMemberId()%>";
   let contentWriterId = val.eq(6).text();
   let projectCreator = "<%=p.getMemberId()%>";

   $(".updateBtnContainer").css("display","none");
   //글 쓴 사람이랑 로그인 한 사람 아이디가 같으면? 보임
   //로그인 한 사람이 프로젝트 만든 사람이면? 보임
   if(loginMember == contentWriterId || loginMember == projectCreator){
      $(".updateBtnContainer").css("display","block");
   }
   
   
   $.ajax({
      url:"<%=request.getContextPath()%>/project/selectContentView.do",
      type:"post",
      data : {"dist":dist,"contentNo":contentNo},
      traditional : true,
      datatype:"json",
      success:data=>{
         const mfile = data["mFile"];
         const pc = data["pc"];
         const memberNameList = data["memberNameList"];
        
         switch(dist){
            case '게시글' : 
               
               $("#writerName").html(pc["memberName"]);
               $("#writeDate").html(pc["writeDate"]);
               $("#normalReadCount").html("<span>조회수 "+pc["readCount"]+"</span>");
               $("#contentTitleView").html(pc["contentTitle"]);
               $("#contentBody").html(pc["content"]);
               $("#normalContentNo").html("<span style='border:1px solid lightgray;border-radius:17px; padding:5px;'>"+pc["contentNo"]+"</span>");
               $("#normalContentDist").html(pc["dist"]);
               $("#normalOriFileName").children().remove();
               $("#normalReFileName").children().remove();
               for(let i =0;i<mfile.length;i++){
                  const h5 =$("<div>");
                  const h6 = $("<div>");
                  h5.html("<a href=\"javascript:fn_normalFileDownload(\'"+mfile[i]['normalOriFileName']+"\',\'"+mfile[i]['normalReFileName']+"\');\">"+mfile[i]['normalOriFileName']+"</a>");
                  h6.html(mfile[i]["normalReFileName"]);
                  $("#normalOriFileName").append(h5)
                  $("#normalReFileName").append(h6);
               }
               normalCommentView();
               $("#viewBtn").click();
               
            break;
            case '업무' :
                 
                  $("#workWriterName").html(pc["memberName"]);
                     $("#workWriteDate").html(pc["writeDate"]);
                     $("#workContentTitleView").html(pc["contentTitle"]);
                     $("#workReadCount").html("<span>조회수 "+pc["readCount"]+"</span>");
                     $("#workIngView").html("<span style='margin-right:8px;'><i class='fas fa-history'></i> 진행상태 : </span>"+pc["workIng"]);
                    
                     $("#workManager").children().remove();
                     $("#workManager").html("<span><i class='fas fa-user'></i> 업무담당자 : </span>");
                     
                     for(let i=0;i<memberNameList.length;i++){
                           const span = $("<span style='padding-right:5px;'>");
                           span.html(memberNameList[i]["managerName"]);
                           $("#workManager").append(span);   
                     }
                     $("#workStartDate_view").html("<span style='padding-right:5px; color:rgb(1, 161, 36);'><i class='fas fa-calendar-plus'></i></span>"+pc["startDate"]);
                     $("#workEndDate_view").html("<span style='padding-right:5px;color:rgb(255, 83, 53);'><i class='fas fa-calendar-check'></i></span>"+pc["endDate"]);
                     $("#workRank_view").html("<span style='padding-right:5px;'><i class='fas fa-flag'></i></span>"+pc["workRank"])
                     $("#workContent_view").html(pc["content"]);
                     $("#workContentNo").html("<span style='border:1px solid lightgray;border-radius:17px; padding:5px;'>"+pc["contentNo"]+"</span>");
                     $("#workdist").html(pc["dist"]);
                     
                     $("#workOriFileName").children().remove();
                  $("#workReFileName").children().remove();
                  for(let i =0;i<mfile.length;i++){
                     const h5 =$("<div>");
                     const h6 = $("<div>");
                     h5.html("<a href=\"javascript:fn_workFileDownload(\'"+mfile[i]['workOriFileName']+"\',\'"+mfile[i]['workReFileName']+"\');\">"+mfile[i]['workOriFileName']+"</a>");
                     h6.html(mfile[i]["workReFileName"]);
                     $("#workOriFileName").append(h5)
                     $("#workReFileName").append(h6);
                  }

               workCommentView();
               $("#workViewBtn").click();
            break;
            case '일정' : 
               
                $("#scheWriterName").html(pc["memberName"]);
                     $("#scheWriteDate").html(pc["writeDate"]);
                     $("#scheContentTitleView").html(pc["contentTitle"]);
                     $("#scheReadCount").html("<span>조회수 "+pc["readCount"]+"</span>");
                     $("#scheContentNo").html("<span style='border:1px solid lightgray;border-radius:17px; padding:5px;'>"+pc["contentNo"]+"</span>");
                     $("#schedist").html(pc["dist"]);
                     
                     $("#scheAttendPeople").children().remove();
                     $("#scheAttendPeople").html("<span><i class='fas fa-user'></i> 일정참석자 : </span>");
                     for(let i=0;i<memberNameList.length;i++){
                        const span = $("<span style='padding-right:5px;'>");
                        span.html(memberNameList[i]["memberName"]);
                        $("#scheAttendPeople").append(span);
                     }
                     
                     $("#scheStartDate_view").html("<span style='padding-right:5px; color:rgb(1, 161, 36);'><i class='fas fa-calendar-plus'></i></span>"+pc["startDate"]);
                     $("#scheEndDate_view").html("<span style='padding-right:5px;color:rgb(255, 83, 53);'><i class='fas fa-calendar-check'></i></span>"+pc["endDate"]);
                     $("#schePlaceName").html("<span style='padding-right:5px;'><i class='fas fa-map-marker-alt'></i></span>"+pc["placeName"]);
                     $("#schePlaceAddr").html("<span style='padding-right:5px;'><i class='fas fa-map-marked-alt'></i></span>"+pc["address"]);
                     $("#scheContent_view").html(pc["content"]);
                     scheCommentView();
                     $("#scheViewBtn").click();
            break;
         }
      }
   });
}

const fn_workFileDownload=(workOriFileName,workReFileName)=>{
   
    const url = "<%=request.getContextPath()%>/project/workfileDownload.do";
    const encode = encodeURIComponent(workOriFileName);
    location.assign(url+"?workOriFileName="+encode+"&&workReFileName="+workReFileName);
}

const fn_normalFileDownload=(normalOriFileName,normalReFileName)=>{

    const url = "<%=request.getContextPath()%>/project/normalfileDownload.do";
    const encode = encodeURIComponent(normalOriFileName);
    location.assign(url+"?normalOriFileName="+encode+"&&normalReFileName="+normalReFileName);
}


</script>

<style>
#contentView{
   cursor: pointer;
}
</style>
<main>

<!-- 일반 게시글 상세화면 -->
<button class="btn btn-primary" type="button" id="viewBtn" style="display:none;" data-bs-toggle="offcanvas" data-bs-target="#contentView" aria-controls="offcanvasScrolling"></button>
<div class="offcanvas offcanvas-end" style="width: 40%;" data-bs-scroll="true" data-bs-backdrop="false" tabindex="-1"  id="contentView" aria-labelledby="offcanvasScrollingLabel">
  <div class="offcanvas-header" style="background-color:rgba(217, 170, 255, 0.082);"> 
  <button type="button" class="btn-close text-reset" data-bs-dismiss="offcanvas" aria-label="Close" id="normal_close_btn"></button>
  </div>
   <div class="offcanvas-title" style="border-bottom: 1px solid lightgray;background-color:rgba(217, 170, 255, 0.082);">
         <div id="normalContentDist" style="display:none;"></div>
         <div id="normalContentNo" style="text-align:right;font-family:'Do Hyeon'; margin-right: 15px; "></div>
         <div id="contentTitleView" style="font-size: 25px; font-family:'Do Hyeon';margin-left: 20px; "></div>
         <div id="writerName" style="font-size: 18px; font-family:'Do Hyeon'; display:inline-block; margin-left: 20px;"></div>
         <div id="writeDate"style="font-size: 18px; font-family:'Do Hyeon';  margin-left: 15px; display:inline-block;"></div>
   </div>
  <div class="offcanvas-body" id="contentBody"></div>
  <div>
   <div class="updateBtnContainer" style="display:none; text-align: right;">
        <button type="button" style="border:none;" class="btn btn-outline-secondary" data-bs-toggle="modal" data-bs-target="#normal_update" id="normal_update_btn">수정</button>
        <button type="button" style="border:none;" class="btn btn-outline-secondary" data-bs-toggle="modal" data-bs-target="#normal-delete">삭제</button>
   </div>
  <div id="normalReadCount" style="font-family:'Do Hyeon';text-align:right; margin-right:20px;"></div>
  <div style="margin-left: 10px;font-family:'Do Hyeon'; font-size: 20px;">첨부파일</div>
   <div id="normalFileContainer" style="margin-right: 20px;">
	        <div id="normalOriFileName" style="font-family:'Do Hyeon'; font-size: 18px; padding:10px;"></div>
	        <div id="normalReFileName" style="display: none;"></div>
	</div>
  </div>
  <div class="offcanvas-body" id="contentfooter" style="border-top: 1px solid lightgray; background-color:rgba(217, 170, 255, 0.082);">
 	
     <!-- 댓글 입력 -->
     <div id="normalCommentContainer"  style="width: 100%; text-align: center; ">
     	<div class="comment_editor">
     		<div style="display: inline-block; width: 70%; vertical-align: middle;">
     			<textarea rows="1" cols="60" style="resize:none;" placeholder="댓글입력" id="normal_comment" class="form-control"></textarea>
     		</div>
     		<div style="display: inline-block; vertical-align: middle;">
     			<button type="button" id="normal_comment_submit" class="btn btn-outline-secondary">등록</button>
     		</div>
     		
     	</div>
     </div>
     <!-- 댓글 출력 -->
     <div id="normalCommentOutputContainer" style="margin-top: 20px;">
     	
     </div>
  </div>
</div>

<script>
//댓글 입력
	$("#normal_comment_submit").click(e=>{
		let commentContent = $("#normal_comment").val();
		let contentNo = $("#normalContentNo").text();
		let writerId = "<%=loginMember.getMemberId()%>";
		
		$.ajax({
			
			url:"<%=request.getContextPath()%>/project/normal/insertNormalComment.do",
			type:"post",
			data:{
				commentContent:commentContent,
				contentNo:contentNo,
				writerId:writerId
			},
			
			success:data=>{
				normalCommentView();
				 $("#normal_comment").val("");
			}
		});
	});
//댓글 출력
	function normalCommentView(){
	
		let loginMember ="<%=loginMember.getMemberId()%>";
		let projectCreator = "<%=p.getMemberId()%>";
				   
		let contentNo = $("#normalContentNo").text();
		
		$.ajax({
			url : "<%=request.getContextPath()%>/project/normal/selectNormalComment.do",
			type:"post",
			dataType:"json",
			data:{contentNo:contentNo},
			success:data=>{
				$("#normalCommentOutputContainer").html("");
				for(let i=0;i<data.length;i++){
					
					const normalCommentNo = $("<div class='normalCommentNo' style='display:none;'>").text(data[i]["normalCommentNo"]);
					const normalCommentContent = $("<div class='normalCommentContent'>").text(data[i]["normalCommentContent"]);
					const normalCommentWriterName = $("<div class ='normalCommentWriterName' style='display: inline-block;'>").text(data[i]["writerName"]);
					const normalCommentDate = $("<div class='normalCommentDate' style='display: inline-block;'>").text(data[i]["commentDate"]);	
					const normalCommentOutput = $("<div class='normalCommentOutput' style='border-bottom:1px solid lightgray;'>");
					const normalCommentWriterId = $("<div class='normalCommentWriterId' style='display:none;'>").text(data[i]["writerId"]);
					normalCommentOutput.append(normalCommentWriterName).append(normalCommentDate).append(normalCommentContent).append(normalCommentNo).append(normalCommentWriterId)
					
					if(loginMember == data[i]["writerId"] || loginMember == projectCreator || loginMember =='admin' ){
						const deletBtn = $("<button class='btn btn-outline-secondary delBtn' onclick='deleteNormalComment(this);'>삭제</button>");
						normalCommentContent.append(deletBtn);
					}
					$("#normalCommentOutputContainer").append(normalCommentOutput);	
					
				}
			}	
		});
	}
	
	//댓글 삭제
	function deleteNormalComment(e){
		
		let normalCommentNo = $(e).parent().next().text();
		
		$.ajax({
			url : "<%=request.getContextPath()%>/project/normal/deleteNormalComment.do",
			type:"post",
			data:{normalCommentNo:normalCommentNo},
			success:data =>{
				normalCommentView();
			}
			
		});
		
	}
	
</script>

<!-- 업무 게시글 상세화면 -->

<button class="btn btn-primary"  id="workViewBtn" type="button" style="display:none;" data-bs-toggle="offcanvas" data-bs-target="#workContentView" aria-controls="offcanvasScrolling"></button>
<div class="offcanvas offcanvas-end" style="width: 40%;" data-bs-scroll="true" data-bs-backdrop="false" tabindex="-1"  id="workContentView" aria-labelledby="offcanvasScrollingLabel">
  <div class="offcanvas-header" style="background-color:rgba(217, 170, 255, 0.082);"> 
  <button type="button" class="btn-close text-reset" data-bs-dismiss="offcanvas" aria-label="Close" id="work_close_btn"></button>
  </div>
   <div class="offcanvas-title" style="border-bottom: 1px solid lightgray;background-color:rgba(217, 170, 255, 0.082);">
         <div id="workContentNo" style="text-align:right;font-family:'Do Hyeon'; margin-right: 15px; "></div>
         <div id="workContentTitleView" style="font-size: 25px; font-family:'Do Hyeon';margin-left: 20px; "></div>
         <div id="workWriterName" style="font-size: 18px; font-family:'Do Hyeon'; display:inline-block; margin-left: 20px;"></div>
         <div id="workWriteDate" style="font-size: 18px; font-family:'Do Hyeon';  margin-left: 15px; display:inline-block;"></div>
   </div>
  <div class="offcanvas-body" id="contentBody">
        <div id="workIngView" style="font-family:'Do Hyeon'; font-size: 18px; margin-bottom: 5px;"></div>
        <div id="workManager" style="font-family:'Do Hyeon'; font-size: 18px; margin-bottom: 5px;"></div>
        <div id="workStartDate_view" style="font-family:'Do Hyeon'; font-size: 18px; margin-bottom: 5px;"></div>
        <div id="workEndDate_view" style="font-family:'Do Hyeon'; font-size: 18px; margin-bottom: 5px;"></div>
        <div id="workRank_view" style="font-family:'Do Hyeon'; font-size: 18px; margin-bottom: 5px;"></div>
        <div id="workContent_view" style="word-break:break-word;white-space:pre-line"></div>
        <div id="workdist" style="display:none;"></div>
  </div>
     <div class="updateBtnContainer" style="display: none;text-align: right;">
        <button type="button" style="border:none;" class="btn btn-outline-secondary" data-bs-toggle="modal" data-bs-target="#updateWorkModal" id="updateWork_">수정</button>
        <button type="button" style="border:none;" class="btn btn-outline-secondary" data-bs-toggle="modal" data-bs-target="#work-delete" id="del_btn2">삭제</button>
     </div>
   <div id="workReadCount" style="font-family:'Do Hyeon'; text-align:right; margin-right:20px;"></div>
   <div style="margin-left: 10px;font-family:'Do Hyeon'; font-size: 20px;" >첨부파일</div>
   <div id="workFileContainer" style="margin-right: 20px;">
        <div id="workOriFileName" style="font-family:'Do Hyeon'; font-size: 18px; padding:10px;"></div>
        <div id="workReFileName" style="display:none;"></div>
    </div>
     
  <div class="offcanvas-body" id="contentfooter" style="background-color:rgba(217, 170, 255, 0.082);">
     
     <!-- 댓글 입력 -->
     <div id="normalCommentContainer" style="width: 100%; text-align: center;">
     	<div class="comment_editor">
     		<div style="display: inline-block; width: 70%; vertical-align: middle;">
     			<textarea rows="1" cols="60" style="resize:none;" id="work_comment" placeholder="댓글입력" class="form-control"></textarea>
     		</div>
     		<div style="display: inline-block; vertical-align: middle;">
     		<button type="button" id="work_comment_submit" class="btn btn-outline-secondary">등록</button>
     		</div>
    	 </div>
     </div>
     <!-- 댓글 출력 -->
     <div id="workCommentOutputContainer" style="margin-top: 20px;">
     	
     </div>
  </div>
</div>

<script>
//댓글 입력
$("#work_comment_submit").click(e=>{
	let commentContent = $("#work_comment").val();
	let contentNo = $("#workContentNo").text();
	let writerId = "<%=loginMember.getMemberId()%>";
	
	$.ajax({
		
		url:"<%=request.getContextPath()%>/project/work/insertWorkComment.do",
		type:"post",
		data:{
			commentContent:commentContent,
			contentNo:contentNo,
			writerId:writerId
		},
		
		success:data=>{
			workCommentView();
			 $("#work_comment").val("");
		}
	});
});
//댓글 출력
function workCommentView(){
	let contentNo = $("#workContentNo").text();

	let loginMember ="<%=loginMember.getMemberId()%>";
	let projectCreator = "<%=p.getMemberId()%>";
	
	$.ajax({
		url : "<%=request.getContextPath()%>/project/work/selectWorkComment.do",
		type:"post",
		dataType:"json",
		data:{contentNo:contentNo},
		success:data=>{
			
			$("#workCommentOutputContainer").html("");
			for(let i=0;i<data.length;i++){
				const workCommentNo = $("<div class='workCommentNo' style='display:none;'>").text(data[i]["workCommentNo"]);
				const workCommentContent = $("<div class='workCommentContent'>").text(data[i]["workCommentContent"]);
				const workCommentWriterId = $("<div class='workCommentWriterId' style='display:none;'>").text(data[i]["writerId"]);
				const workCommentWriter = $("<div class ='workCommentWriter' style='display: inline-block;'>").text(data[i]["writerName"]);
				const workCommentDate = $("<div class='workCommentDate' style='display: inline-block;'>").text(data[i]["commentDate"]);	
				const workCommentOutput = $("<div class='workCommentOutput' style='border-bottom:1px solid lightgray;'>");
				
				workCommentOutput.append(workCommentWriter).append(workCommentDate).append(workCommentContent).append(workCommentNo).append(workCommentWriterId);
				if(loginMember == data[i]["writerId"] || loginMember == projectCreator || loginMember =='admin' ){
					const deletBtn = $("<button class='btn btn-outline-secondary delBtn' onclick='deleteWorkComment(this);'>삭제</button>");
					workCommentContent.append(deletBtn);
				}
				$("#workCommentOutputContainer").append(workCommentOutput);
			}
		}	
	});
}
//댓글 삭제
function deleteWorkComment(e){
	
	let workCommentNo = $(e).parent().next().text();
	
	$.ajax({
		url : "<%=request.getContextPath()%>/project/work/deleteWorkComment.do",
		type:"post",
		data:{workCommentNo:workCommentNo},
		success:data =>{
			workCommentView();
		}
	});
	
}
</script>

<!-- 일정 게시글 상세화면 -->

<button class="btn btn-primary"  id="scheViewBtn" type="button" style="display:none;" data-bs-toggle="offcanvas" data-bs-target="#scheContentView" aria-controls="offcanvasScrolling"></button>
<div class="offcanvas offcanvas-end" style="width: 40%;" data-bs-scroll="true" data-bs-backdrop="false" tabindex="-1"  id="scheContentView" aria-labelledby="offcanvasScrollingLabel">
  <div class="offcanvas-header" style="background-color:rgba(217, 170, 255, 0.082);"> 
  <button type="button" class="btn-close text-reset" data-bs-dismiss="offcanvas" aria-label="Close" id="sche_close_btn"></button>
  </div>
   <div class="offcanvas-title" style="border-bottom: 1px solid lightgray;background-color:rgba(217, 170, 255, 0.082);">
         <div id="scheContentNo"style="text-align:right;font-family:'Do Hyeon'; margin-right: 15px; "></div>
         <div id="scheContentTitleView" style="font-size: 25px; font-family:'Do Hyeon';margin-left: 20px; "></div>
         <div id="scheWriterName" style="font-size: 18px; font-family:'Do Hyeon'; display:inline-block; margin-left: 20px;"></div>
         <div id="scheWriteDate" style="font-size: 18px; font-family:'Do Hyeon';  margin-left: 15px; display:inline-block;"></div>
         
         <div id="scheReadCount" style="font-family:'Do Hyeon'; text-align:right; margin-right:20px;"></div>
         
   </div>
  <div class="offcanvas-body" id="contentBody">
        <div id="scheAttendPeople" style="font-family:'Do Hyeon'; font-size: 18px; margin-bottom: 5px;"></div>
        <div id="scheStartDate_view"  style="font-family:'Do Hyeon'; font-size: 18px; margin-bottom: 5px;"></div>
        <div id="scheEndDate_view" style="font-family:'Do Hyeon'; font-size: 18px; margin-bottom: 5px;"></div>
        <div id="schePlaceName" style="font-family:'Do Hyeon'; font-size: 18px; margin-bottom: 5px;"></div>
        <div id="schePlaceAddr" style="font-family:'Do Hyeon'; font-size: 18px; margin-bottom: 5px;"></div>
        <div id="scheContent_view" style="word-break:break-word;white-space:pre-line"></div>
       
        <div id="schedist"style="display:none;"></div>
  </div>
  <div class="updateBtnContainer" style="display: none;text-align: right;">
           <button  type="button" style="border:none;" class="btn btn-outline-secondary" data-bs-toggle="modal" data-bs-target="#updateScheModal" id="updateSche_">수정</button>
           <button type="button"  style="border:none;" class="btn btn-outline-secondary" data-bs-toggle="modal" data-bs-target="#sche-delete" id="del_btn3">삭제</button>
  </div>
   <div id="scheReadCount"></div>
   <div class="offcanvas-body" id="contentfooter" style="background-color:rgba(217, 170, 255, 0.082);">
        
      <!-- 댓글 입력 -->
     <div id="scheCommentContainer" style="width: 100%; text-align: center;">
     	<div class="comment_editor">
     		<div style="display: inline-block; width: 70%; vertical-align: middle;">
     		<textarea rows="1" cols="60" style="resize:none;" id="sche_comment"  placeholder="댓글입력" class="form-control"></textarea>
     		</div>
     		<div style="display: inline-block; vertical-align: middle;">
     		<button type="button" id="sche_comment_submit" class="btn btn-outline-secondary">등록</button>
     		</div>
     	</div>
     </div>
     <!-- 댓글 출력 -->
     <div id="scheCommentOutputContainer" style="margin-top: 20px;">
     </div>
     </div>
</div>

<script>
//댓글 입력
$("#sche_comment_submit").click(e=>{
	let commentContent = $("#sche_comment").val();
	let contentNo = $("#scheContentNo").text();
	let writerId = "<%=loginMember.getMemberId()%>";
	
	$.ajax({
		
		url:"<%=request.getContextPath()%>/project/sche/insertScheComment.do",
		type:"post",
		data:{
			commentContent:commentContent,
			contentNo:contentNo,
			writerId:writerId
		},
		
		success:data=>{
			scheCommentView();
			 $("#sche_comment").val("");
		}
	});
});
//댓글 출력
function scheCommentView(){
	let contentNo = $("#scheContentNo").text();

	let loginMember ="<%=loginMember.getMemberId()%>";
	let projectCreator = "<%=p.getMemberId()%>";
	$.ajax({
		url : "<%=request.getContextPath()%>/project/sche/selectScheComment.do",
		type:"post",
		dataType:"json",
		data:{contentNo:contentNo},
		success:data=>{


			$("#scheCommentOutputContainer").html("");
			for(let i=0;i<data.length;i++){
				const scheCommentNo = $("<div class='scheCommentNo' style='display:none;'>").text(data[i]["scheCommentNo"]);
				const scheCommentContent = $("<div class='scheCommentContent'>").text(data[i]["scheCommentContent"]);
				const scheCommentWriter = $("<div class ='scheCommentWriter' style='display: inline-block;'>").text(data[i]["writerName"]);
				const scheCommentWriterId = $("<div class='scheCommentWriterId' style='display:none;'>").text(data[i]["writerId"]);
				const scheCommentDate = $("<div class='scheCommentDate' style='display: inline-block;'>").text(data[i]["commentDate"]);	
				const scheCommentOutput = $("<div class='scheCommentOutput' style='border-bottom:1px solid lightgray;'>");
				
				scheCommentOutput.append(scheCommentWriter).append(scheCommentDate).append(scheCommentContent).append(scheCommentNo).append(scheCommentWriterId);
				if(loginMember == data[i]["writerId"] || loginMember == projectCreator || loginMember =='admin' ){
					const deletBtn = $("<button class='btn btn-outline-secondary delBtn' onclick='deleteScheComment(this);'>삭제</button>");
					scheCommentContent.append(deletBtn);
				}
				
				$("#scheCommentOutputContainer").append(scheCommentOutput);
			}
		}	
	});
}
//댓글 삭제
function deleteScheComment(e){
	
	let scheCommentNo = $(e).parent().next().text();
	
	$.ajax({
		url : "<%=request.getContextPath()%>/project/sche/deleteScheComment.do",
		type:"post",
		data:{scheCommentNo:scheCommentNo},
		success:data =>{
			scheCommentView();
		}
	});
	
}

</script>



<!-- 프로젝트 초대 모달 -->
<div class="modal fade" id="addProjectMemberModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable">
    <div class="modal-content">
      <div class="modal-header">
        <div class="modal-title" id="exampleModalLabel" style="font-family:'Do Hyeon'; font-size: 25px;">사원 목록</div>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div>
      <div style="width: 100%; text-align: center; margin-top: 20px;">
      <div style="display: inline-block;">
           <select class="form-select" style="width: 100px;" aria-label=".form-select-sm example" id="searchType_select" >              
                 <option value="M.MEMBER_NAME">사원명</option>
                 <option value="D.DEPT_NAME">부서명</option>
                 <option value="P.POSITION_NAME">직급명</option>
            </select>
       </div>
            <div style="display: inline-block; width: 40%;">
            	<div class="input-group mb-3" >
               		<input type="text" class="form-control" aria-label="Recipient's username" aria-describedby="button-addon2" id="searchKeyword_Member">
               		<button class="btn btn-outline-secondary" type="button" id="search_Member_btn"><i class="fas fa-search"></i></button>
             </div>
            </div>
      </div>
      
      </div>
      <div class="modal-body">
          <div id="addProjectMemberListContainer">
             <table class="table table-hover" style="text-align: center;">
                
             </table>
          </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal" id="proAddMember_close">Close</button>
        <button type="button" class="btn btn-primary" id="proAddMember_submit">추가</button>
      </div>
    </div>
  </div>
</div>

<!-- 프로젝트정보 -->

<input type="hidden" id="memberId" value="<%=loginMember.getMemberId()%>">
<input type="hidden" id="projectNo" value="<%=p.getProjectNo()%>">

<!-- 일반게시글 작성 모달 -->
<button style="display:none;" type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#exampleModal1" id="insertNormal_">글작성</button>
<div class="modal fade" id="exampleModal1" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true" onsubmit="return checkContent();">
  <div class="modal-dialog modal-dialog-centered modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel">게시물 작성</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
      <input class="form-control" type="text" placeholder="제목" aria-label="default input example" id="normalTitle" name="title">
      <span id="titleResult"></span>
        <textarea class="form-control" placeholder="내용을 입력하세요" id="normalContent" style="height: 200px; margin-top: 20px; margin-bottom:10px; resize:none"></textarea>
        <div class="mb-3">
       <label for="formFile" class="form-label"></label>
        <input class="form-control" type="file" id="uploadNormal" name="upfile" multiple>
      </div>
      <div id="fileNameList">
         
      </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal" id="close_content">닫기</button>
        <button type="button" class="btn btn-primary" id="normal_submit_Btn">등록</button>
      </div>
    </div>
  </div>
</div>

<!-- 일반게시글 수정 모달 -->

<div class="modal fade" id="normal_update" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel">게시물 수정</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
      <input class="form-control" type="text" placeholder="제목" aria-label="default input example" id="normal_update_title_" name="normal_update_title">
      <span id="titleResult_"></span>
        <textarea class="form-control" placeholder="내용을 입력하세요" id="normal_update_Content" style="height: 200px; margin-top: 20px; margin-bottom:10px; resize:none"></textarea>
      <!--  <div class="mb-3">
       <label for="formFile" class="form-label"></label>
        <input class="form-control" type="file" id="upload_update_Normal" name="normal_upfile" multiple>
      </div>
      -->
      <div id="fileNameList_update"></div>
      <div id="fileReNameList_update" style="display:none;"></div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal" id="normal_update_close">닫기</button>
        <button type="button" class="btn btn-primary" id="normal_updateSubmit_Btn">등록</button>
      </div>
    </div>
  </div>
</div>
<script>
//일반 게시글 수정.. 파일은..못해..
   $("#normal_update_btn").click(e=>{
      let contentNo = $("#normalContentNo").text();
      let dist = $("#normalContentDist").text();
      $.ajax({
         url:"<%=request.getContextPath()%>/project/selectContentView.do",
         type:"post",
         data : {"dist":dist,"contentNo":contentNo},
         traditional : true,
         datatype:"json",
         success:data=>{
            const mfile = data["mFile"];
            const pc = data["pc"];
            const memberNameList = data["memberNameList"];
            
            switch(dist){
               case '게시글' : 
                  $("#normal_update_title_").val(pc["contentTitle"]);
                  $("#normal_update_Content").val(pc["content"]);
                  $("#fileNameList_update").children().remove();
                  $("#fileReNameList_update").children().remove();
                  for(let i =0;i<mfile.length;i++){
                     const h5 =$("<h5>");
                     const h6 = $("<h6>");
                     h5.html(mfile[i]["normalOriFileName"]);
                     h6.html(mfile[i]["normalReFileName"]);
                     $("#fileNameList_update").append(h5)
                     $("#fileReNameList_update").append(h6);
                  }
            }
         }
      });

      
   });
   
   $("#normal_updateSubmit_Btn").click(e=>{
      let normalTitle = $("#normal_update_title_").val();
      let normalContent = $("#normal_update_Content").val();
      let contentNo = $("#normalContentNo").text();
         
      $.ajax({
         url : "<%=request.getContextPath()%>/project/normal/updateNormalContent.do",
         type:"post",
         data:{normalTitle:normalTitle,normalContent:normalContent,contentNo:contentNo},
         success:data=>{   
            $("#normal_update_close").click();
            contentListAjax();   
            $("#normal_close_btn").click();
         },
         error:(a)=>{
            alert("실팽");
         }
      });
   });
</script>

<!-- 업무게시글 작성 모달 -->

<button style="display:none;" type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#insertWork_modal" id="insertWork_">업무작성</button>
<div class="modal fade" id="insertWork_modal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel">업무 작성</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
      <input class="form-control" type="text" placeholder="제목" aria-label="default input example" id="workTitle">
      <span id="work_titleResult"></span>
      <div id="work_Ing_container" style="padding-left: 20px; padding-top: 20px;">
         <span style="font-size: 20px; margin-right: 15px;"><i class="fas fa-history"></i></span>
         <label for="call" class="workIngLa"><input type="radio" value="요청" id="call" name="work_ing"><span style="background-color: #00b2ff">요청</span></label>
         <label for="ing" class="workIngLa"><input type="radio" value="진행" id="ing" name="work_ing"><span style="background-color: #00b01c" >진행</span></label>
         <label for="feedback" class="workIngLa"><input type="radio" value="피드백" id="feedback" name="work_ing"><span style="background-color:#fd7900;">피드백</span></label>
         <label for="hold" class="workIngLa"><input type="radio" value="보류" id="hold" name="work_ing"><span style="background-color: #777;">보류</span></label>
         <label for="complete" class="workIngLa"><input type="radio"value="완료" id="complete" name="work_ing"><span style="background-color:#402a9d;">완료</span></label>
      </div>
      <div id="work_addMember_container" style="padding-left: 20px; padding-top: 10px;">
         <span style="font-size: 20px; margin-right: 15px;"><i class="fas fa-user"></i></span>
         <div style="display: inline-block;"><select class="form-select" id="work_addMember"></select></div>
         <div id="work_addMember_area"></div>
      </div>
      <div id="workStart_container" style="padding-left: 20px; padding-top: 5px;">
         <span style="font-size: 20px; margin-right: 15px;"><i class="fas fa-calendar-plus"></i></span>
         <input type="date" id="workStart">
      </div>
      <div id="workEnd_container" style="padding-left: 20px;padding-top: 8px;">
         <span style="font-size: 20px; margin-right: 15px;"><i class="fas fa-calendar-check"></i></span>
         <input type="date" id="workEnd">
      </div>
      <div id="workRank_container" style="padding-left: 20px;padding-top: 8px;">
         <span><i class="fas fa-flag"></i></span>
          <label for="normal" class="workRankLa"><input type="radio" value="보통" id="normal" name="work_rank"><span>보통</span></label>
          <label for="row" class="workRankLa"><input type="radio" value="낮음" id="row" name="work_rank"><span>낮음</span></label>
          <label for="emergency" class="workRankLa"><input type="radio" value="긴급" id="emergency" name="work_rank"><span>긴급</span></label>
          <label for="high" class="workRankLa"><input type="radio" value="높음" id="high" name="work_rank"><span>높음</span></label>
      </div>
      
        <textarea class="form-control" placeholder="내용을 입력하세요" id="workContent" style="height: 200px; margin-top: 20px; margin-bottom:10px; resize:none"></textarea>
        <div class="mb-3">
       <label for="formFile" class="form-label"></label>
        <input class="form-control" type="file" id="uploadWorkfile_" name="uploadWorkfile" multiple>
      </div>
      <div id="workFileNameContainer"></div>
      <input type="hidden" id="memberId" value="<%=loginMember.getMemberId()%>">
      <input type="hidden" id="projectNo" value="<%=p.getProjectNo() %>">
      
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal" id="close_work_content">닫기</button>
        <button type="button" class="btn btn-primary" id="work_submit_Btn">등록</button>
      </div>
    </div>
  </div>
</div>
<!-- 업무 게시글 수정 모달 -->
<div class="modal fade" id="updateWorkModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel">업무 수정</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
      <input class="form-control" type="text" placeholder="제목" aria-label="default input example" id="workTitle_update">
      <span id="work_titleResult"></span>
      <div id="work_Ing_container" style="padding-left: 20px; padding-top: 20px;">
         <span style="font-size: 20px; margin-right: 15px;"><i class="fas fa-history"></i></span>
         
        <label for="call2" class="workIngLa"><input type="radio" value="요청" id="call2" name="work_ing_update"><span style="background-color: #00b2ff">요청</span></label>
         <label for="ing2" class="workIngLa"><input type="radio" value="진행" id="ing2" name="work_ing_update"><span style="background-color: #00b01c" >진행</span></label>
         <label for="feedback2" class="workIngLa"><input type="radio" value="피드백" id="feedback2" name="work_ing_update"><span style="background-color:#fd7900;">피드백</span></label>
         <label for="hold2" class="workIngLa"><input type="radio" value="보류" id="hold2" name="work_ing_update"><span style="background-color: #777;">보류</span></label>
         <label for="complete2" class="workIngLa"><input type="radio"value="완료" id="complete2" name="work_ing_update"><span style="background-color:#402a9d;">완료</span></label>
         
      </div>
      <!-- <div id="work_addMember_container">
         <span><i class="fas fa-user"></i></span>
         <div><select class="form-select" id="work_addMember_update"></select></div>
         <div id="work_addMember_area_update"></div>
      </div> -->
      <div id="workStart_container" style="padding-left: 20px; padding-top: 10px;">
          <span style="font-size: 20px; margin-right: 15px;"><i class="fas fa-calendar-plus"></i></span>
         <input type="date" id="workStart_update">
      </div>
      <div id="workEnd_container" style="padding-left: 20px;padding-top: 8px;">
          <span style="font-size: 20px; margin-right: 15px;"><i class="fas fa-calendar-check"></i></span>
         <input type="date" id="workEnd_update">
      </div>
      <div id="workRank_container_update" style="padding-left: 20px;padding-top: 8px;">
         <span><i class="fas fa-flag"></i></span>
          
          <label for="normal2" class="workRankLa"><input type="radio" value="보통" id="normal2" name="work_rank_update"><span>보통</span></label>
          <label for="row2" class="workRankLa"><input type="radio" value="낮음" id="row2" name="work_rank_update"><span>낮음</span></label>
          <label for="emergency2" class="workRankLa"><input type="radio" value="긴급" id="emergency2" name="work_rank_update"><span>긴급</span></label>
          <label for="high2" class="workRankLa"><input type="radio" value="높음" id="high2" name="work_rank_update"><span>높음</span></label>
      </div>
      
        <textarea class="form-control" placeholder="내용을 입력하세요" id="workContent_update" style="height: 200px; margin-top: 20px; margin-bottom:10px; resize:none"></textarea>
      <!-- <div class="mb-3">
          <label for="formFile" class="form-label"></label>
           <input class="form-control" type="file" id="uploadWorkfile_" name="uploadWorkfile" multiple>
      </div>
       -->
      <div id="workFileNameContainer"></div>
      <input type="hidden" id="memberId" value="<%=loginMember.getMemberId()%>">
      <input type="hidden" id="projectNo" value="<%=p.getProjectNo() %>">
      
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal" id="close_work_content_update">닫기</button>
        <button type="button" class="btn btn-primary" id="work_update_Btn">등록</button>
      </div>
    </div>
  </div>
</div>

<script>
//업무 게시글 업데이트
//기존 값 받아오기 -> 화면에 출력해주기 -> 업무 담당자 추가 삭제
$("#updateWork_").click(e=>{
   let contentNo = $("#workContentNo").text();
   let dist = $("#workdist").text(); 
 
   $.ajax({
      url:"<%=request.getContextPath()%>/project/selectContentView.do",
      type:"post",
      data : {"dist":dist,"contentNo":contentNo},
      traditional : true,
      datatype:"json",
      success:data=>{
         const mfile = data["mFile"];
         const pc = data["pc"];
         const memberNameList = data["memberNameList"];
         switch(dist){
            case '업무' : 
               $("#workTitle_update").val(pc["contentTitle"]);
               $("#workContent_update").val(pc["content"]);
               $("input[name=work_ing_update]").each(function(i,v){
           			if($(this).val() == pc["workIng"]){
           				$(this).attr('checked',true);
           				return false;
           			}
            	 });
               
               $("#workStart_update").val(pc["startDate"]);
               $("#workEnd_update").val(pc["endDate"]);
               $("input[name=work_rank_update]").each(function(i,v){
            	  if($(this).val() == $("#workRank_view").text()){
            		  $(this).attr('checked',true);
            		  return false;
            	  } 
               });
            }
         }
   });
});


//시작 날짜 
$("#workStart_update").change(e=>{
   workStart = $("#workStart_update").val();
   let startDateArr = workStart.split("-");
   let endDateArr = workEnd.split("-");
	 
   let startDateCompare = new Date(startDateArr[0], parseInt(startDateArr[1])-1, startDateArr[2]);
   let endDateCompare = new Date(endDateArr[0], parseInt(endDateArr[1])-1, endDateArr[2]);
   if(startDateCompare.getTime() > endDateCompare.getTime()) {
       alert("시작날짜와 종료날짜를 확인해 주세요.");
       document.getElementById('workStart_update').value= new Date().toISOString().substring(0, 10);
       $("#workStart_update").focus();
       return false;
   }
});      

//마감 날짜

$("#workEnd_update").change(e=>{
   workEnd = $("#workEnd_update").val();
   //날짜 
   let startDateArr = workStart.split("-");
   let endDateArr = workEnd.split("-");
	 
   let startDateCompare = new Date(startDateArr[0], parseInt(startDateArr[1])-1, startDateArr[2]);
   let endDateCompare = new Date(endDateArr[0], parseInt(endDateArr[1])-1, endDateArr[2]);
   if(startDateCompare.getTime() > endDateCompare.getTime()) {
       alert("시작날짜와 종료날짜를 확인해 주세요.");
       document.getElementById('workEnd_update').value= new Date().toISOString().substring(0, 10);
       $("#workEnd_update").focus();
       return false;
   }
});


$("#work_update_Btn").click(e=>{
	
	let workTitle =  $("#workTitle_update").val();
	let workContent =  $("#workContent_update").val();
	let workIng =  $("input[name=work_ing_update]:checked").val();
	let workRank =  $("input[name=work_rank_update]:checked").val();
	let startDate =  $("#workStart_update").val();
	let endDate =$("#workEnd_update").val();
	let contentNo = $("#workContentNo").text();
	
	$.ajax({
		url : "<%=request.getContextPath()%>/project/work/updateWorkContent.do",
		type:"post",
		data : {workTitle:workTitle,
			workContent:workContent,
			workIng:workIng,
			workRank:workRank,
			startDate:startDate,
			endDate:endDate,
			contentNo:contentNo
			},
		success:data=>{
			$("#close_work_content_update").click();
			contentListAjax();   
			$("#work_close_btn").click();
		}
	});
});


</script>

<!-- 일정게시글 작성 모달 -->
<button style="display:none;" type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#exampleModal3" id="insertSche_">일정작성</button>

<div class="modal fade" id="exampleModal3" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel">일정 등록</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
      <input class="form-control" type="text" placeholder="제목" aria-label="default input example" id="scheTitle">
      <span id="sche_titleResult"></span>
      
      <div id="sche_addMember_container" style="padding-left: 20px; padding-top: 10px;">
         <span style="font-size: 20px; margin-right: 15px;" ><i class="fas fa-user"></i></span>
         <div style="display: inline-block;"><select class="form-select" id="sche_addMember">
         </select></div>
         <div id="sche_addMember_area"></div>
      </div>
     
     
      <div id="scheStart_container" style="padding-left: 20px; padding-top: 5px;">
         <span style="font-size: 20px; margin-right: 15px;"><i class="fas fa-calendar-plus"></i></span>
         <input type="date" id="scheStartDate">
      </div>
      <div id="scheEnd_container" style="padding-left: 20px;padding-top: 8px;">
         <span style="font-size: 20px; margin-right: 15px;"><i class="fas fa-calendar-check"></i></span>
         <input type="date" id="scheEndDate">
      </div>

      <div  style="padding-left: 20px;padding-top: 8px;">
      	<span style="font-size: 20px; margin-right: 15px;"><i class="fas fa-map-marker-alt"></i></span>
           <button type="button" class="btn" id="sche_place_btn" style="font-family: 'Do Hyeon';font-size: 20px;">장소검색</button>
           <div style="width: 200px;">
           	  <div id="test" style="display:none;"class="input-group mb-3" >
                 <input type="text" id="searchKeyword" class="form-control">
                 <button id="searchBtn" class="btn btn-outline-secondary">검색</button>
              </div>
           </div>
              
       </div>
       <div id="searchContainer" style="display:none; width: 100%; height: 500px;">
          <div class="map_wrap">
             <div id="map" style="width: 100%;height: 100%;position: relative;overflow: hidden; background: url(https://t1.daumcdn.net/mapjsapi/images/bg_tile.png);"></div>
             <div id="menu_wrap" class="bg_white">
             <ul id="placeList"></ul>
             <div id="pagination"></div>
             </div>
          </div>
      </div>
      <div id="searchResultContainer" style="padding-left: 20px; padding-top: 5px; font-family: 'Do Hyeon'">
      </div>

    <textarea class="form-control" placeholder="내용을 입력하세요" id="scheContent" style="height: 200px; margin-top: 20px; margin-bottom:10px; resize:none"></textarea>
      <input type="hidden" id="memberId" value="<%=loginMember.getMemberId() %>">
      <input type="hidden" id="projectNo" value="<%=p.getProjectNo()%>">
      
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal" id="close_sche_content">닫기</button>
        <button type="button" class="btn btn-primary" id="sche_submit_Btn">등록</button>
      </div>
    </div>
  </div>
</div>

<!-- 일정 게시글 수정 모달 -->

<div class="modal fade" id="updateScheModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel">일정 등록</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
      <input class="form-control" type="text" placeholder="제목" aria-label="default input example" id="scheTitle_update">
      <span id="sche_titleResult_update"></span>
      <div id="scheStart_container" style="padding-left: 20px; padding-top: 5px;">
         <span style="font-size: 20px; margin-right: 15px;"><i class="fas fa-calendar-plus"></i></span>
         <input type="date" id="scheStartDate_update">
      </div>
      <div id="scheEnd_container" style="padding-left: 20px; padding-top: 8px;">
         <span style="font-size: 20px; margin-right: 15px;"><i class="fas fa-calendar-check"></i></span>
         <input type="date" id="scheEndDate_update">
      </div>
    <textarea class="form-control" placeholder="내용을 입력하세요" id="scheContent_update" style="height: 200px; margin-top: 20px; margin-bottom:10px; resize:none"></textarea>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal" id="close_sche_content_update">닫기</button>
        <button type="button" class="btn btn-primary" id="sche_update_Btn">등록</button>
      </div>
    </div>
  </div>
</div>

<script>
//일정 수정
$("#updateSche_").click(e=>{
	let contentNo = $("#scheContentNo").text();
	   let dist = $("#schedist").text(); 
	 
	   $.ajax({
	      url:"<%=request.getContextPath()%>/project/selectContentView.do",
	      type:"post",
	      data : {"dist":dist,"contentNo":contentNo},
	      traditional : true,
	      datatype:"json",
	      success:data=>{
	         const pc = data["pc"];
	         const memberNameList = data["memberNameList"];
	         switch(dist){
	            case '일정' : 
	               $("#scheTitle_update").val(pc["contentTitle"]);
	               $("#scheContent_update").val(pc["content"]);
	               $("#scheStartDate_update").val(pc["startDate"]);
	               $("#scheEndDate_update").val(pc["endDate"]);
	            }
	         }
	   });
	
});

//시작 날짜 
$("#scheStartDate_update").change(e=>{
   workStart = $("#scheStartDate_update").val();
   let startDateArr = workStart.split("-");
   let endDateArr = workEnd.split("-");
	 
   let startDateCompare = new Date(startDateArr[0], parseInt(startDateArr[1])-1, startDateArr[2]);
   let endDateCompare = new Date(endDateArr[0], parseInt(endDateArr[1])-1, endDateArr[2]);
   if(startDateCompare.getTime() > endDateCompare.getTime()) {
       alert("시작날짜와 종료날짜를 확인해 주세요.");
       document.getElementById('scheStartDate_update').value= new Date().toISOString().substring(0, 10);
       $("#scheStartDate_update").focus();
       return false;
   }
});      

//마감 날짜

$("#scheEndDate_update").change(e=>{
   workEnd = $("#scheEndDate_update").val();
   //날짜 
   let startDateArr = workStart.split("-");
   let endDateArr = workEnd.split("-");
	 
   let startDateCompare = new Date(startDateArr[0], parseInt(startDateArr[1])-1, startDateArr[2]);
   let endDateCompare = new Date(endDateArr[0], parseInt(endDateArr[1])-1, endDateArr[2]);
   if(startDateCompare.getTime() > endDateCompare.getTime()) {
       alert("시작날짜와 종료날짜를 확인해 주세요.");
       document.getElementById('scheEndDate_update').value= new Date().toISOString().substring(0, 10);
       $("#scheEndDate_update").focus();
       return false;
   }
});


$("#sche_update_Btn").click(e=>{
	let scheTitle =  $("#scheTitle_update").val();
	let scheContent =  $("#scheContent_update").val();
	let scheStartDate =  $("#scheStartDate_update").val();
	let scheEndDate =$("#scheEndDate_update").val();
	let contentNo = $("#scheContentNo").text();
	
	$.ajax({
		url : "<%=request.getContextPath()%>/project/schedule/updateScheduleContent.do",
		type:"post",
		data : {scheTitle:scheTitle,
			scheContent:scheContent,
			scheStartDate:scheStartDate,
			scheEndDate:scheEndDate,
			contentNo:contentNo
			},
		success:data=>{
			$("#close_sche_content_update").click();
			contentListAjax();   
			$("#sche_close_btn").click();
		}
	});
	
});


</script>



    
<script>
   //지도 API 사용
   
   //검색한 주소 가져오는 함수
   
   let shce_place_name;
   let shce_place_Loadaddr;
   
   function getAddress(){
	 $("#searchResultContainer").html("");
    shce_place_name = $("#shce_place_name").text();
    shce_place_Loadaddr = $("#shce_place_Loadaddr").text();
   //화면 출력 꺼지게 하기
   $("#searchContainer").hide();
   
   $("#searchResultContainer").append("<p> 장소명 : "+shce_place_name+"</p>").append("<p> 주소 : "+shce_place_Loadaddr+"</p>");
    
   }
   
   
$("#sche_place_btn").click(e=>{
   $("#test").show();
});

   $("#searchBtn").click(e=>{
      
      $("#searchContainer").show(e=>{
          
         let keyword = $("#searchKeyword").val();
         //마커를 담을 배열입니다
         var markers = [];

         var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
             mapOption = {
                 center: new kakao.maps.LatLng(37.566826, 126.9786567), // 지도의 중심좌표
                 level: 3 // 지도의 확대 레벨
             };  

         // 지도를 생성합니다    
         var map = new kakao.maps.Map(mapContainer, mapOption); 

         // 장소 검색 객체를 생성합니다
         var ps = new kakao.maps.services.Places();  

         // 검색 결과 목록이나 마커를 클릭했을 때 장소명을 표출할 인포윈도우를 생성합니다
         var infowindow = new kakao.maps.InfoWindow({zIndex:1});

          ps.keywordSearch( keyword, placesSearchCB); 
         
         // 장소검색이 완료됐을 때 호출되는 콜백함수 입니다
         function placesSearchCB(data, status, pagination) {
             if (status === kakao.maps.services.Status.OK) {
                 // 정상적으로 검색이 완료됐으면
                 // 검색 목록과 마커를 표출합니다
                 displayPlaces(data);

                 // 페이지 번호를 표출합니다
                 displayPagination(pagination);

             } else if (status === kakao.maps.services.Status.ZERO_RESULT) {

                 alert('검색 결과가 존재하지 않습니다.');
                 return;

             } else if (status === kakao.maps.services.Status.ERROR) {

                 alert('검색 결과 중 오류가 발생했습니다.');
                 return;

             }
         }

         // 검색 결과 목록과 마커를 표출하는 함수입니다
         function displayPlaces(places) {

             var listEl = document.getElementById('placeList'), 
             menuEl = document.getElementById('menu_wrap'),
             fragment = document.createDocumentFragment(), 
             bounds = new kakao.maps.LatLngBounds(), 
             listStr = '';
             
             // 검색 결과 목록에 추가된 항목들을 제거합니다
             removeAllChildNods(listEl);

             // 지도에 표시되고 있는 마커를 제거합니다
             removeMarker();
             
             for ( var i=0; i<places.length; i++ ) {

                 // 마커를 생성하고 지도에 표시합니다
                 var placePosition = new kakao.maps.LatLng(places[i].y, places[i].x),
                     marker = addMarker(placePosition, i), 
                     itemEl = getListItem(i, places[i]); // 검색 결과 항목 Element를 생성합니다

                 // 검색된 장소 위치를 기준으로 지도 범위를 재설정하기위해
                 // LatLngBounds 객체에 좌표를 추가합니다
                 bounds.extend(placePosition);

                 // 마커와 검색결과 항목에 mouseover 했을때
                 // 해당 장소에 인포윈도우에 장소명을 표시합니다
                 // mouseout 했을 때는 인포윈도우를 닫습니다
                 (function(marker, title) {
                     kakao.maps.event.addListener(marker, 'mouseover', function() {
                         displayInfowindow(marker, title);
                     });

                     kakao.maps.event.addListener(marker, 'mouseout', function() {
                         infowindow.close();
                     });

                     itemEl.onmouseover =  function () {
                         displayInfowindow(marker, title);
                     };

                     itemEl.onmouseout =  function () {
                         infowindow.close();
                     };
                 })(marker, places[i].place_name);

                 fragment.appendChild(itemEl);
             }

             // 검색결과 항목들을 검색결과 목록 Elemnet에 추가합니다
             listEl.appendChild(fragment);
             menuEl.scrollTop = 0;

             // 검색된 장소 위치를 기준으로 지도 범위를 재설정합니다
             map.setBounds(bounds);
         }

         // 검색결과 항목을 Element로 반환하는 함수입니다
         function getListItem(index, places) {

             var el = document.createElement('li'),
             itemStr = '<span class="markerbg marker_' + (index+1) + '"></span>' +
                         '<div onclick="getAddress();" style="cursor:pointer;" class="info">' +
                         '   <h5 id="shce_place_name" style="font-weight:bold; font-size:15px;">' + places.place_name + '</h5>';

             if (places.road_address_name) {
                 itemStr += '    <h4 id="shce_place_Loadaddr">' + places.road_address_name + '</h4>' +
                             '   <h5 class="jibun gray">' +  places.address_name  + '</h5>';
             } else {
                 itemStr += '    <span>' +  places.address_name  + '</span>'; 
             }
                          
               itemStr += '  <h5 class="tel">' +"tel : "+ places.phone  + '</h5><hr>' +
                         '</div>';           

             el.innerHTML = itemStr;
             el.className = 'item';
             
            
             
             return el;
         }
         

         // 마커를 생성하고 지도 위에 마커를 표시하는 함수입니다
         function addMarker(position, idx, title) {
             var imageSrc = 'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/marker_number_blue.png', // 마커 이미지 url, 스프라이트 이미지를 씁니다
                 imageSize = new kakao.maps.Size(36, 37),  // 마커 이미지의 크기
                 imgOptions =  {
                     spriteSize : new kakao.maps.Size(36, 691), // 스프라이트 이미지의 크기
                     spriteOrigin : new kakao.maps.Point(0, (idx*46)+10), // 스프라이트 이미지 중 사용할 영역의 좌상단 좌표
                     offset: new kakao.maps.Point(13, 37) // 마커 좌표에 일치시킬 이미지 내에서의 좌표
                 },
                 markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize, imgOptions),
                     marker = new kakao.maps.Marker({
                     position: position, // 마커의 위치
                     image: markerImage 
                 });

             marker.setMap(map); // 지도 위에 마커를 표출합니다
             markers.push(marker);  // 배열에 생성된 마커를 추가합니다

             return marker;
         }

         // 지도 위에 표시되고 있는 마커를 모두 제거합니다
         function removeMarker() {
             for ( var i = 0; i < markers.length; i++ ) {
                 markers[i].setMap(null);
             }   
             markers = [];
         }

         // 검색결과 목록 하단에 페이지번호를 표시는 함수입니다
         function displayPagination(pagination) {
             var paginationEl = document.getElementById('pagination'),
                 fragment = document.createDocumentFragment(),
                 i; 

             // 기존에 추가된 페이지번호를 삭제합니다
             while (paginationEl.hasChildNodes()) {
                 paginationEl.removeChild (paginationEl.lastChild);
             }

             for (i=1; i<=pagination.last; i++) {
                 var el = document.createElement('a');
                 el.href = "#";
                 el.innerHTML = i;

                 if (i===pagination.current) {
                     el.className = 'on';
                 } else {
                     el.onclick = (function(i) {
                         return function() {
                             pagination.gotoPage(i);
                         }
                     })(i);
                 }

                 fragment.appendChild(el);
             }
             paginationEl.appendChild(fragment);
         }

         // 검색결과 목록 또는 마커를 클릭했을 때 호출되는 함수입니다
         // 인포윈도우에 장소명을 표시합니다
         function displayInfowindow(marker, title) {
             var content = '<div style="padding:5px;z-index:1;">' + title + '</div>';

             infowindow.setContent(content);
             infowindow.open(map, marker);
         }

          // 검색결과 목록의 자식 Element를 제거하는 함수입니다
         function removeAllChildNods(el) {   
             while (el.hasChildNodes()) {
                 el.removeChild (el.lastChild);
             }
         }
          
         
         
      });
   });
</script>


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
      <li class="nav-item" style="font-family:'Sunflower'"><a class="nav-link " aria-current="page" href="#">홈</a></li>
      <li class="nav-item" style="font-family:'Sunflower'"><a class="nav-link" href="#" onclick="location.assign('<%=request.getContextPath()%>/project/FileInProjectServlet.do?projectNo=<%=p.getProjectNo()%>')">파일</a></li>
   </ul>
</div>

<div id="pro_container" style="bordert">
   <div id="inner_pro_container">
   <div id="inputContent_container">
      <div id="input-group">
         <div id="insertNormal" style="font-family: 'Do Hyeon'"><a href="#"><span><i class="fas fa-edit"></i></span>&nbsp;글</a></div>
         <div id="insertWork" style="font-family: 'Do Hyeon'"><a href="#"><span><i class="fas fa-list"></i></span>&nbsp;업무</a></div>
         <div id="insertSche" style="font-family: 'Do Hyeon'"><a href="#"><span><i class="far fa-calendar"></i></span>&nbsp;일정</a></div>
      <div style="border-top: 1px solid lightgray;
       height: 50%; width: 100%; display: block; margin-top: 13px; font-size: 20px;
       padding:15px; text-align: left;"> 내용을 입력하세요 </div>
      </div>
      
   </div>
   
   
   
   <div id="contentContainer">
   <div style="display: inline-block; display: flex; justify-content: center; height: 40px; margin-bottom: 20px;">
      <div class="input-group mb-3"  style="width:650px;">
            <div>
               <select class="form-select" aria-label="Default select example" style="width: 100px;" id="searchConSelect">
                  <option value="MEMBER_NAME">작성자명</option>
                  <option value="CONTENT_TITLE">게시글명</option>
               </select>
            </div>        
            <input type="text" class="form-control" placeholder="keyword" aria-label="Recipient's username" aria-describedby="button-addon2" id="searchConKeyword">
            <button class="btn btn-outline-secondary" type="button" id="searchConBtn"><i class="fas fa-search"></i></button>
      </div>
       <div id="filterDist" style="display: inline-block; margin-left: 5px;">
         <div class="dropdown" style="margin-left: 5px;">
              <button class="btn btn-secondary dropdown-toggle" style="border:none;" type="button" id="dropdownMenuButton1" data-bs-toggle="dropdown" aria-expanded="false"><i class="fas fa-filter"></i></button>
              <ul class="dropdown-menu" aria-labelledby="dropdownMenuButton1">
                   <li>
                      <div class="form-check" style="margin-left: 8px;">
                         <input class="form-check-input" type="radio" name="selectContentRadio" checked value="게시글" id="normal_radio">
                          <label class="form-check-label" for="normal_radio">게시글</label>
                     </div>
                  </li>
                  <li>
                     <div class="form-check" style="margin-left: 8px;">
                          <input class="form-check-input" type="radio" name="selectContentRadio"  value="업무" id="work_radio">
                          <label class="form-check-label" for="work_radio">업무</label>
                     </div>
                  </li>
                  <li>
                     <div class="form-check" style="margin-left: 8px;">
                          <input class="form-check-input" type="radio" name="selectContentRadio" value="일정" id="sche_radio">
                          <label class="form-check-label" for="sche_radio">일정</label>
                     </div>
                  </li>
              </ul>
         </div>
      </div>
      <div style="display: inline-block; margin-left: 5px;">
         <button type="button" class="btn btn-outline-secondary" onclick="contentListAjax();">전체보기</button>
      </div>
   </div>
     
      
      <div id ="contentArea" style="margin-top: 15px;">
      </div>
      <div id="pageNavContainer" style="display: flex; justify-content: center; margin-top: 15px; "></div>
   </div>
   
   </div>
   <div id="proMemberViewContainer">
      <div id="innder_proMemberViewContainer" style="font-family:'Do Hyeon'; ">
      	<div style="background-color: rgba(213, 124, 255, 0.26);  border-radius: 30px 30px 0 0; padding: 20px;">
      		<div style="font-size: 21px; font-weight: bold;">프로젝트 관리자</div>
         	<div id="proCreator" style="font-size: 20px; font-weight: bold;"></div>
      	</div>
         <div style="padding: 20px; ">
         	<div style="font-size: 21px; font-weight: bold;"><i class="fas fa-users"></i>&nbsp;참여자</div>
         	<div id="proAttend" style="font-size: 18px; font-weight: 400;"></div>
         </div>
         
      </div>
   </div>
</div>

<!-- 게시글 삭제 모달 -->
<div class="modal fade" id="normal-delete" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-sm modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body">
       <div style="text-align: center;"> 정말 삭제 하시겠습니까?</div>
      </div>
      <div class="modal-footer" style="height: 50px; padding-top: 5px;padding-right: 10px; ">
        <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal" id="normal_ck_close_btn">닫기</button>
        <button type="button" class="btn btn-primary btn-sm" onclick="normal_delComplete();">삭제</button>
      </div>
    </div>
  </div>
</div>
<!-- 업무 삭제 모달 -->
<div class="modal fade" id="work-delete" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-sm modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body">
       <div style="text-align: center;"> 정말 삭제 하시겠습니까?</div>
      </div>
      <div class="modal-footer" style="height: 50px; padding-top: 5px;padding-right: 10px; ">
        <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal" id="work_close_ck_btn">닫기</button>
        <button type="button" class="btn btn-primary btn-sm" onclick="work_delComplete();">삭제</button>
      </div>
    </div>
  </div>
</div>

<!-- 일정 삭제 모달 -->
<div class="modal fade" id="sche-delete" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-sm modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body">
       <div style="text-align: center;"> 정말 삭제 하시겠습니까?</div>
      </div>
      <div class="modal-footer" style="height: 50px; padding-top: 5px;padding-right: 10px; ">
        <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal" id="sche_close_ck_btn">닫기</button>
        <button type="button" class="btn btn-primary btn-sm" onclick="sche_delComplete();">삭제</button>
      </div>
    </div>
  </div>
</div>

</main>

<script>



//일정 삭제
function sche_delComplete(){
   let scheContentNo = $("#scheContentNo").text();
   $.ajax({
      url : "<%=request.getContextPath()%>/project/deleteScheContent.do",
      type:"post",
      data:{scheContentNo:scheContentNo},
      success:data=>{
         $("#sche_close_ck_btn").click();
         contentListAjax();
         $("#sche_close_btn").click();
      }
   });
}

//업무 삭제
function work_delComplete(){
   let workContentNo = $("#workContentNo").text();
   let fileArr = [];
   
	$("#workReFileName").find("div").each(function(i,v){
		fileArr.push($(this).text());
	});   
   
   $.ajax({
      url : "<%=request.getContextPath()%>/project/deleteWorkContent.do",
      traditional : true,
      type:"post",
      data:{workContentNo:workContentNo,fileArr:fileArr},
      success:data=>{
         $("#work_close_ck_btn").click();
         contentListAjax();
         $("#work_close_btn").click();
      }
   });
}

//게시글 삭제
function normal_delComplete(){
   let normalContentNo = $("#normalContentNo").text();
   let fileArr = [];
   $("#normalReFileName").find("div").each(function(i,v){
      fileArr.push($(this).text());
   });
   
   
   $.ajax({
      url : "<%=request.getContextPath()%>/project/deleteNormalContent.do",
      type:"post",
      traditional : true,
      data:{normalContentNo:normalContentNo
         ,fileArr:fileArr},
      success:data=>{
         $("#normal_ck_close_btn").click();
         contentListAjax();
         $("#normal_close_btn").click();
      }
   });
}



//게시글 검색 기능
$("#searchConBtn").click(e=>{
   searchListAjax();
});


//사원 프로젝트 초대
$("#add_btn").click(e=>{
   let projectNo = $("#projectNo").val();
   $.ajax({
      url: "<%=request.getContextPath()%>/project/selectAllMember.do",
      dataType:"json",
      data:{"projectNo":projectNo},
      success : data=>{
      
         $("#addProjectMemberListContainer").find("table").remove();
         const table = $("<table class='mytable2' style='text-align:center;'>");
         table.html("<thead><tr><th>이름</th><th scope='col'>부서명</th><th scope='col'>직급</th><th scope='col'>선택</th></tr></thead>");
         for(let i=0;i<data.length;i++){
         const tr = $("<tr>");
         const memberName = $("<td>").html(data[i]["memberName"]);
         const deptName = $("<td>").html(data[i]["deptName"]);
         const positionName = $("<td>").html(data[i]["positionName"]);
         const check = $("<td>");
         check.html("<input type='checkbox' name='proAddMember_Ck' value='"+data[i]["memberId"]+"'>");
         tr.append(memberName).append(deptName).append(positionName).append(check);
         table.append(tr);
         }
         $("#addProjectMemberListContainer").append(table);
      }
      
   });
});


$("#proAddMember_submit").click(e=>{
   let addMemberArr = new Array();
   let projectNo = $("#projectNo").val();
   
   //체크박스로 선택된 사원 아이디 가져와서 배열에 저장함
   $("input[name=proAddMember_Ck]:checked").each(function(){
      let temp = $(this).val();
      addMemberArr.push(temp);
   });
   //tb_pro_member 테이블에 보내줘야함.
   
   $.ajax({
      url : "<%=request.getContextPath()%>/project/addProjectMember.do",
      type:"post",
      data : {"addMemberArr":addMemberArr,
            "projectNo":projectNo},
      success: data=>{
         proInMemberList();
         $("#proAddMember_close").click();
      },
      error: a=>{
         alert("시일패에..");
      }
   });
});

//사원 초대에서 검색 기능
$("#search_Member_btn").click(e=>{
   let searchType =  $("#searchType_select").val();
   let searchKeyword = $("#searchKeyword_Member").val();
   let projectNo = $("#projectNo").val();
   
   $.ajax({
      url : "<%=request.getContextPath()%>/project/searchAddMember.do",
      data : {"searchType":searchType,"searchKeyword":searchKeyword,"projectNo":projectNo},
      dataType:"json",
      success : data=>{
         $("#addProjectMemberListContainer").find("table").remove();
         const table = $("<table class='table' style='text-align:center;'>");
         table.html("<thead><tr><th scope='col'>이름</th><th scope='col'>부서명</th><th scope='col'>직급</th><th scope='col'>선택</th></tr></thead>");
         for(let i=0;i<data.length;i++){
         const tr = $("<tr scope='row'>");
         const memberName = $("<td>").html(data[i]["memberName"]);
         const deptName = $("<td>").html(data[i]["deptName"]);
         const positionName = $("<td>").html(data[i]["positionName"]);
         const check = $("<td>");
         check.html("<input type='checkbox' name='proAddMember_Ck' value='"+data[i]["memberId"]+"'>");
         tr.append(memberName).append(deptName).append(positionName).append(check);
         table.append(tr);
         }
         $("#addProjectMemberListContainer").append(table);            
      }
   });
   
});

   
   /* 1.일반 게시글 작성 로직 */
   $("#insertNormal").click(e=>{
      $("#insertNormal_").click();
   });      
   
   $("#uploadNormal").change(e=>{
      if($("#fileNameList").find("p").length>0){
         $("#fileNameList").find("p").remove();
      }
      
      let fileName = $("input[name=upfile]");
         for(let i=0;i<fileName.length;i++){
            if(fileName[i].files.length>0){
               for(let j =0;j<fileName[i].files.length;j++){
                  let p = $("<p>");
               p.text(fileName[i].files[j].name);
               $("#fileNameList").append(p);
               }
            }
         }
   });
   
   
   $("#normal_submit_Btn").click(e=>{
      //제목 반드시 입력
      let title = $("input[name=title]").val();
      if(title.trim().length == 0){
         $("input[name=title]").focus();
         $("#titleResult").text("제목을 입력하세요").css("color","red");
      }else{
         
      const frm = new FormData();
      const fileInput = $("input[name=upfile]");
      for(let i=0; i<fileInput[0].files.length;i++){
         frm.append("upfile"+i,fileInput[0].files[i]);
         
      }
      frm.append("title", $("input[name=title]").val());
      frm.append("content", $("#normalContent").val());
      frm.append("memberId",$("#memberId").val());
      frm.append("projectNo", $("#projectNo").val());
   
      
      $.ajax({
         url : "<%=request.getContextPath()%>/project/normal/insertNormalContent.do",
         type:"post",
         data:frm,
         processData:false,
         contentType:false,
         success:data=>{
            $("#normalTitle").val("");
            $("#normalContent").val("");
            $("#uploadNormal").val("");
            $("#fileNameList").find("p").remove();         
            $("#close_content").click();
            contentListAjax();   
         },
         error:(a)=>{
            alert("실팽");
         }
         
      });

      }
         
   });
   
   /* 2.업무 게시글 작성 로직 */
   
   let selectedMember; //최종 선택된 멤버 이름
   let selectedManagerId; //최종 선택된 멤버 아이디
   let memberName;//현재 프로젝트에 참여중인 멤버 이름
   let managerId;// 현재 프로젝트에 참여중인 멤버 아이디
   let creatorPro = "<%=p.getMemberId()%>"; //프로젝트 생성자
   let select;
   let ophead;
   function selectAddWorkMember(){
      let projectNo = $("#projectNo").val();
      $.ajax({
         
         url : "<%=request.getContextPath()%>/project/selectAddWorkMember.do",
         type:"post",
         dataType:"json",
         data:{projectNo:projectNo},
         success:data=>{
            memberName = new Array();//현재 프로젝트에 참여중인 멤버 이름
            managerId = new Array();// 현재 프로젝트에 참여중인 멤버 아이디
            select = $("#work_addMember");
            
            
            select.children().remove();
            select.append(ophead);
            
            for(let i=0;i<data.length;i++){
               memberName.push(data[i]["memberName"]);
               managerId.push(data[i]["memberId"]);
               const option = $("<option>");
               option.text(memberName[i]);
               option.val(managerId[i]);
               select.append(option);
            }
         }
      });
   }
    //일정 참석자 리스트
    let selectSche;
    let opheadSche;
   function selectAddscheMember(){
      let projectNo = $("#projectNo").val();
      $.ajax({
         
         url : "<%=request.getContextPath()%>/project/selectAddWorkMember.do",
         type:"post",
         dataType:"json",
         data:{projectNo:projectNo},
         success:data=>{
            
            memberName = new Array();//현재 프로젝트에 참여중인 멤버 이름
            managerId = new Array();// 현재 프로젝트에 참여중인 멤버 아이디
            
            selectSche = $("#sche_addMember");
            selectSche.children().remove();
            selectSche.append(opheadSche);
            
            for(let i=0;i<data.length;i++){
               memberName.push(data[i]["memberName"]);
               managerId.push(data[i]["memberId"]);
               const option = $("<option>");
               option.text(memberName[i]);
               option.val(managerId[i]);
               selectSche.append(option);
            }
         }
      });
   }
   
   //해당 업무 관리자 리스트 .. 업무 작성시
   
   
   $("#insertWork").click(e=>{
      $("#insertWork_").click();
      selectedMember = new Array();
      selectedManagerId = new Array();
      selectAddWorkMember();
   });
   
   $("#uploadWorkfile_").change(e=>{
      if($("#workFileNameContainer").find("p").length>0){
         $("#workFileNameContainer").find("p").remove();
      }
      
      let fileName = $("input[name=uploadWorkfile]");
         for(let i=0;i<fileName.length;i++){
            if(fileName[i].files.length>0){
               for(let j =0;j<fileName[i].files.length;j++){
                  let p = $("<p>");
               p.text(fileName[i].files[j].name);
               $("#workFileNameContainer").append(p);
               }
            }
         }
   });

      $("#work_addMember").change(e=>{
         //선택된 유저 아이디 span으로 보여줌
         
         let span = $("<span>");
         let selectMemberName = $("#work_addMember option:selected").text();      
         let selectManaId = select.val();
   		
         span.text(selectMemberName);
         span.val(selectManaId);
         
         //선택된 유저id 배열에 넣어주기
         for(let i =0; i<memberName.length;i++){
            if(!selectedManagerId.includes(selectManaId)){
               selectedManagerId.push(selectManaId);
               $("#work_addMember_area").append(span);   
               break;
            }
            
         }
         
         if($("#work_addMember_area").find("span").length > memberName.length){
            span.remove();
         }
         
         //span에서 삭제하면 배열에서도 삭제해주기
         span.click(e=>{
            
            for(let i=0;i<memberName.length;i++){
               if(selectedManagerId.includes(span.val())){
                  selectedManagerId.splice(selectedManagerId.indexOf(span.val()),1);
                  break;
               }
               
            }
            span.remove();
            
         });
         //최종 값 selectedManagerId에 있음
         
      });
      
      //기본 날짜 설정
      
   
   
   let workStart =document.getElementById('workStart').value= new Date().toISOString().substring(0, 10);
   let workEnd = document.getElementById('workEnd').value= new Date().toISOString().substring(0, 10);   
      //시작 날짜 
      $("#workStart").change(e=>{
         workStart = $("#workStart").val();
         let startDateArr = workStart.split("-");
         let endDateArr = workEnd.split("-");
		 
         let startDateCompare = new Date(startDateArr[0], parseInt(startDateArr[1])-1, startDateArr[2]);
         let endDateCompare = new Date(endDateArr[0], parseInt(endDateArr[1])-1, endDateArr[2]);
         if(startDateCompare.getTime() > endDateCompare.getTime()) {
             alert("시작날짜와 종료날짜를 확인해 주세요.");
             document.getElementById('workStart').value= new Date().toISOString().substring(0, 10);
             $("#workStart").focus();
             return false;
         }
      });      
      
      //마감 날짜
      
      $("#workEnd").change(e=>{
         workEnd = $("#workEnd").val();
         //날짜 
         let startDateArr = workStart.split("-");
         let endDateArr = workEnd.split("-");
		 
         let startDateCompare = new Date(startDateArr[0], parseInt(startDateArr[1])-1, startDateArr[2]);
         let endDateCompare = new Date(endDateArr[0], parseInt(endDateArr[1])-1, endDateArr[2]);
         if(startDateCompare.getTime() > endDateCompare.getTime()) {
             alert("시작날짜와 종료날짜를 확인해 주세요.");
             document.getElementById('workEnd').value= new Date().toISOString().substring(0, 10);
             $("#workEnd").focus();
             return false;
         }
      });
      
      //저장 버튼
      $("#work_submit_Btn").click(e=>{   
         //제목 가져오기
         let workTitle = $("#workTitle").val();
         
         if(workTitle.trim().length == 0){
            $("#workTitle").focus();
            $("#work_titleResult").text("제목을 입력하세요").css("color","red");
         }else if(!$("input[name=work_ing]").is(":checked")){
            $("#call").prop("checked",true);
         }else if(!$("input[name=work_rank]").is(":checked")){
            $("#normal").prop("checked",true);
         }else if(selectedManagerId.length == 0){
            alert("담당자를 추가하세용");
            return false;
         }else {
            //업무 진행상황 값 가져오기
            let workIngVal  = $("input[name=work_ing]:checked").val();
            //순위
            let workRank = $("input[name=work_rank]:checked").val();
            //내용
            let workContent = $("#workContent").val();
         //파일업로드
         const frm = new FormData();
         const fileInput = $("input[name=uploadWorkfile]");
         
         for(let i=0; i<fileInput[0].files.length;i++){
            frm.append("upfile"+i,fileInput[0].files[i]);
         }
         
         frm.append("workTitle", workTitle);
         frm.append("workIng", workIngVal);
         frm.append("workManagers",selectedManagerId);
         frm.append("workStart", workStart);
         frm.append("workEnd", workEnd);
         frm.append("workRank", workRank);
         frm.append("workContent", workContent);
         frm.append("projectNo", $("#projectNo").val());
         frm.append("memberId",$("#memberId").val()); //업무작성자
         
         
         //데이터 보내기
         $.ajax({
            url : "<%=request.getContextPath()%>/project/work/insertWorkContent.do",
            type:"post",
            data:frm,
            processData:false,
            contentType:false,
            success:data=>{
               $("#work_addMember").find('option:first').attr('selected', 'selected');
               $("#workTitle").val("");
               $("#workStart").val("");
               $("#workEnd").val("");
               $("input[name=work_ing]").prop('checked',false);
               $("input[name=work_rank]").prop('checked',false);
               $("#workContent").val("");
               $("input[name=uploadWorkfile]").val("");   
               $("#workFileNameContainer").find("p").remove();
               $("#work_addMember_area").find("span").remove();
               workStart = document.getElementById('workStart').value= new Date().toISOString().substring(0, 10);
               workEnd = document.getElementById('workEnd').value= new Date().toISOString().substring(0, 10);
               $("#close_work_content").click();
               contentListAjax();   
            },
            error:(a)=>{
               alert("실팽");
            }
            
         });
         
         }
      });  

   //일정 작성
   $("#insertSche").click(e=>{
      $("#insertSche_").click();
      selectedMember = new Array();
      selectedManagerId = new Array();
      selectAddscheMember();
   });
   
   $("#sche_addMember").change(e=>{
      
      let span = $("<span>");
      let selectMemberName = $("#sche_addMember option:selected").text();      
      let selectManaId = selectSche.val();
      span.text(selectMemberName);
      span.val(selectManaId);   
     
      
      //선택된 유저id 배열에 넣어주기
      for(let i =0; i<memberName.length;i++){

         if(!selectedManagerId.includes(selectManaId)){
            selectedManagerId.push(selectManaId);
            $("#sche_addMember_area").append(span);
            break;
         }
      }
      
   
      if($("#sche_addMember_area").find("span").length > memberName.length){
         span.remove();
      }
      if($("#sche_addMember_area").find("span").text =="참석자 추가"){
         span.remove();
      }
      
      //span에서 삭제하면 배열에서도 삭제해주기
      span.click(e=>{
         for(let i=0;i<memberName.length;i++){
            if(selectedManagerId.includes(span.val())){
               selectedManagerId.splice(selectedManagerId.indexOf(span.val()),1);
               break;
            }
            
         }
         span.remove();
         
      }); 
      //최종 값 selectedManagerId에 있음
   
   });
   
 	  
 	//일정 기본 날짜
   let scheStartDate = document.getElementById('scheStartDate').value= new Date().toISOString().substring(0, 10);
   let scheEndDate = document.getElementById('scheEndDate').value= new Date().toISOString().substring(0, 10);
   //일정 시작 날짜
   
   $("#scheStartDate").change(e=>{
      scheStartDate = $("#scheStartDate").val();
    //날짜 
      let startDateArr = scheStartDate.split("-");
      let endDateArr = scheEndDate.split("-");
      
      let startDateCompare = new Date(startDateArr[0], parseInt(startDateArr[1])-1, startDateArr[2]);
      let endDateCompare = new Date(endDateArr[0], parseInt(endDateArr[1])-1, endDateArr[2]);
      
      if(startDateCompare.getTime() > endDateCompare.getTime()) {
          alert("시작날짜와 종료날짜를 확인해 주세요.");
          $("#scheEndDate").focus();
         document.getElementById('scheEndDate').value= new Date().toISOString().substring(0, 10);
          return false;
      }
   });
   
   //일정 마감 날짜
   
   $("#scheEndDate").change(e=>{
      scheEndDate = $("#scheEndDate").val();
    //날짜 
      let startDateArr = scheStartDate.split("-");
      let endDateArr = scheEndDate.split("-");
      
      let startDateCompare = new Date(startDateArr[0], parseInt(startDateArr[1])-1, startDateArr[2]);
      let endDateCompare = new Date(endDateArr[0], parseInt(endDateArr[1])-1, endDateArr[2]);
      
      if(startDateCompare.getTime() > endDateCompare.getTime()) {
          alert("시작날짜와 종료날짜를 확인해 주세요.");
          $("#scheEndDate").focus();
         	document.getElementById('scheEndDate').value= new Date().toISOString().substring(0, 10);
          return false;
      }
   });
   
   
   //일정등록
   $("#sche_submit_Btn").click(e=>{
      
      let scheTitle = $("#scheTitle").val();
      
      if(scheTitle.trim().length == 0){
         $("#scheTitle").focus();
         $("#sche_titleResult").text("제목을 입력하세요").css("color","red");
      }else{
         
       
         let projectNo = $("#projectNo").val();
         let memberId = $("#memberId").val();
         let scheContent = $("#scheContent").val();

         
         //데이터 보내기
         $.ajax({
            url : "<%=request.getContextPath()%>/project/sche/insertScheContent.do",
            type:"POST",
            traditional : true,      
            data:{"scheTitle":scheTitle,
               "scheContent":scheContent,
               "shce_place_name":shce_place_name,
               "shce_place_Loadaddr":shce_place_Loadaddr,
               "shceStart":scheStartDate,
               "scheEndDate":scheEndDate,
               "projectNo":projectNo,
               "memberId":memberId,
               "scheAttendMember":selectedManagerId
            },
            success:data=>{
               $("#scheTitle").val("");
               $("#searchKeyword").val("");
               $("#scheContent").val("");
               $("#sche_addMember").find('option:first').attr('selected', 'selected');
               $("#sche_addMember_area").find("span").remove();
               $("#searchResultContainer").find("p").remove();
               $("#close_sche_content").click();
               
               scheStartDate = document.getElementById('scheStartDate').value= new Date().toISOString().substring(0, 10);
               scheEndDate = document.getElementById('scheEndDate').value= new Date().toISOString().substring(0, 10);
               contentListAjax();   
            },
            error:(a)=>{
               alert("실팽");
               $("#close_sche_content").click();
            }
            
         });
      }
   });
</script>
     




<%@ include file="/views/common/footer.jsp"%>