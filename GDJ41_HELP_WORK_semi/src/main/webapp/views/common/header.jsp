<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.help.member.model.vo.Member, com.help.attendance.model.vo.Attendance, java.util.List
,java.text.SimpleDateFormat" %>
<% 
   Member loginMember=(Member)session.getAttribute("loginMember");
	Attendance a = (Attendance)request.getAttribute("outputAttTime");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <meta name="description" content="" />
    <meta name="author" content="" />
    <title>HELP_WORK</title>
    <link href="https://cdn.jsdelivr.net/npm/simple-datatables@latest/dist/style.css" rel="stylesheet" />
    <link href="<%=request.getContextPath() %>/css/styles.css" type="text/css" rel="stylesheet" />
    <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/js/all.min.js" crossorigin="anonymous"></script>
    <script src="<%=request.getContextPath() %>/js/jquery-3.6.0.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.1/moment.min.js"></script>
    <script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
    <!-- JavaScript Bundle with Popper -->
<link href="https://fonts.googleapis.com/css2?family=Do+Hyeon&display=swap" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ka7Sk0Gln4gmtz2MlQnikT1wXgYsOg+OMhuP+IlRH9sENBO0LRn5q+8nbTov4+1p" crossorigin="anonymous"></script>
<!-- CSS only -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
<script type="text/javascript">
window.addEventListener('DOMContentLoaded', event => {
    // Toggle the side navigation
    const sidebarToggle = document.body.querySelector('#sidebarToggle');
    if (sidebarToggle) {
        // Uncomment Below to persist sidebar toggle between refreshes
        // if (localStorage.getItem('sb|sidebar-toggle') === 'true') {
        //     document.body.classList.toggle('sb-sidenav-toggled');
        // }
        sidebarToggle.addEventListener('click', event => {
            event.preventDefault();
            document.body.classList.toggle('sb-sidenav-toggled');
            localStorage.setItem('sb|sidebar-toggle', document.body.classList.contains('sb-sidenav-toggled'));
        });
    }
});
</script>

<style>
img {
    object-fit: cover;
    object-position: top;
    border-radius: 50%;
    width: 30px; 
    height: 30px;
}
</style>   
</head>

<body class="sb-nav-fixed">

<!--프로젝트 생성 Modal -->
 <form action="<%=request.getContextPath() %>/project/insertProject.do" method="post" onsubmit="return create_pro(this);" id="create_pro_frm">
<div class="modal fade" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
 <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel">새 프로젝트 생성</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <input class="form-control form-control-m" type="text" placeholder="프로젝트명(100자 이내)" aria-label=".form-control-lg example" name="proName" id="proName_" autocomplete="off">
        <span id="proName-result"></span>
       <div class="form-floating">
        <textarea class="form-control" placeholder="프로젝트 설명(600자이내)" id="floatingTextarea2"  style="height: 200px; margin-top: 10px; margin-bottom:10px; resize:none"
        name ="proExplain"></textarea>
        <label for="floatingTextarea2">프로젝트 설명(600자이내)</label>
        <span id="proExplain-result"></span>
      </div>
        <div class="form-check form-switch" style="padding: 0px;">

  			<label class="form-check-label" for="flexSwitchCheckDefault">회사 공용 프로젝트 여부</label>
  			<input class="form-check-input" type="checkbox" role="switch" id="flexSwitchCheckDefault" style="float:right;" name="proCommonYN">
  			<input type="hidden" name="memberId" value="<%=loginMember.getMemberId()%>">
		</div>

      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal" id="close-project">닫기</button>
        <button type="submit" class="btn btn-primary">프로젝트 생성</button>
         </div>
          </div>
  </div>
</div>
  </form>
    <nav class="sb-topnav navbar navbar-expand navbar-dark bg-dark">
        <!-- Navbar Brand-->
        <a class="navbar-brand ps-3" href="">HELP_WORK</a>
        <!-- Sidebar Toggle-->
         <button class="btn btn-link btn-sm order-1 order-lg-0 me-4 me-lg-0" id="sidebarToggle" href="#!"><i
                class="fas fa-bars"></i></button>
        <!-- Navbar Search-->

        <div class="d-none d-md-inline-block form-inline ms-auto me-0 me-md-3 my-2 my-md-0">
            <!-- <div class="input-group">
                <input class="form-control" type="text" placeholder="Search for..." aria-label="Search for..."
                    aria-describedby="btnNavbarSearch" />
           
                <button class="btn btn-primary" id="btnNavbarSearch" type="button"><i
                        class="fas fa-search"></i></button>
            </div>
            -->
        </div>

        <!-- Navbar-->
        <ul class="navbar-nav ms-auto ms-md-0 me-3 me-lg-4">
            <li class="nav-item">
                <a class="nav-link">
                    <i class="fas fa-bell"></i>
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link">
                    <i class="fas fa-comment-dots"></i>
                </a>
            </li>
            <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle" id="navbarDropdown" href="#" role="button" data-bs-toggle="dropdown"
                    aria-expanded="false"><i class="fas fa-user fa-fw"></i></a>
                <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="navbarDropdown">
                    <li class="dropdown-item"><img src="<%=request.getContextPath() %>/upfile/member/<%=loginMember.getMemberProfile() %>"> <%=loginMember.getMemberName() %></li>
                    <li> 
                        <hr class="dropdown-divider" />
                    </li>
                    <li><a class="dropdown-item" href="<%=request.getContextPath()%>/member/viewMember.do?memberId=<%=loginMember.getMemberId()%>"><i class="fas fa-user-cog"></i>&nbsp;내 정보 수정</a></li>
                    <li><a class="dropdown-item" href="<%=request.getContextPath()%>/member/logoutMember.do"><i class="fas fa-sign-out-alt"></i>&nbsp;로그아웃</a></li>
                </ul>
            </li>
        </ul>
    </nav>
    <div id="layoutSidenav">
        <div id="layoutSidenav_nav">
            <nav class="sb-sidenav accordion sb-sidenav-dark" id="sidenavAccordion">
                <div class="sb-sidenav-menu">
                    <div class="nav">
                        
                        <% if(!(loginMember.getMemberId().equals("admin"))){%>	
                        <div class="sb-sidenav-menu-heading">Attendance/Leave Work</div>
                        
                          <a  class="nav-link" href="#"id="insertAttTime">
                          
                            <div class="sb-nav-link-icon" style="color:green; "><i class="fas fa-battery-full"></i>
                            </div>
                            attendance&nbsp;
                            <div class="sb-nav-link-icon"><span>
                                    <div id="attTime"></div>
                                </span>
                            </div>
                             
                        </a>
                        
                        <a class="nav-link" href="#" id="insertLeaveTime">
                            <div class="sb-nav-link-icon" style="color:rgb(255, 38, 0);"><i class="fas fa-battery-empty"></i>
                            </div>
                            leave work&nbsp;
                            <div class="sb-nav-link-icon"><span>
                                    <div id="leaveTime"></div>
                                </span>
                            </div>
                        </a>
                        <a id="attendanceList" class="nav-link" href="<%=request.getContextPath()%>/attendance/attendanceList.do">
                            <div class="sb-nav-link-icon" ><i class="fas fa-business-time"></i>
                            </div>
                            My A/L Information
                            
                        </a>
                        <%} else{%>
                     	<div class="sb-sidenav-menu-heading">Management</div>
                        <a class="nav-link" href="<%=request.getContextPath()%>/admin/memberList.do">
                            <div class="sb-nav-link-icon"><i class="far fa-address-book"></i>
                            </div>
                            Member
                        </a>
                        <a class="nav-link" href="<%=request.getContextPath()%>/admin/deptAndPositionList.do">
                            <div class="sb-nav-link-icon"><i class="fas fa-building"></i>
                            </div>
                            D/P Management
                        </a>
                        
                        <div class="sb-sidenav-menu-heading">Attendance</div>
                        <a class="nav-link" href="<%=request.getContextPath()%>/admin/memberAttendanceList.do">
                            <div class="sb-nav-link-icon"><i class="fas fa-user-edit"></i>
                            </div>
                            Attendance
                        </a>
                        
                        
                        <%}%>
                        <div class="sb-sidenav-menu-heading">MY PROJECT</div>
                        <a class="nav-link" href="<%=request.getContextPath()%>/project/selectProjectMain.do">
                            <div class="sb-nav-link-icon"><i class="fas fa-house-user"></i>
                            </div>
                            My Project List
                        </a>
                        <a class="nav-link" href="#" id="create-project">
                            <div class="sb-nav-link-icon"><i class="far fa-file"></i></div>    
                            New Project
                        </a>
                       
                        
                        
                        <div class="sb-sidenav-menu-heading">MenuList</div>

                        <a class="nav-link collapsed" href="<%=request.getContextPath() %>/work/SelectWorkMainView.do?logId=<%=loginMember.getMemberId()%>" >
                            <div class="sb-nav-link-icon"><i class="fas fa-align-justify"></i></div>
                            All Work
                        </a>
                        <a class="nav-link collapsed" href="#" data-bs-toggle="collapse" data-bs-target="#collapsePages"
                            aria-expanded="false" aria-controls="collapsePages">
                            <div class="sb-nav-link-icon"><i class="far fa-calendar"></i></div>
                            Notice
                            <!-- <div class="sb-sidenav-collapse-arrow"><i class="fas fa-angle-down"></i></div> -->
                        </a>
                        <a class="nav-link collapsed" href="#" data-bs-toggle="collapse" data-bs-target="#collapsePages"
                            aria-expanded="false" aria-controls="collapsePages">
                            <div class="sb-nav-link-icon"><i class="fas fa-archive"></i></div>
                            File Box
                            <!-- <div class="sb-sidenav-collapse-arrow"><i class="fas fa-angle-down"></i></div> -->
                        </a>
                        <a class="nav-link collapsed" href="#" data-bs-toggle="collapse" data-bs-target="#collapsePages"
                            aria-expanded="false" aria-controls="collapsePages">
                            <div class="sb-nav-link-icon"><i class="far fa-bookmark"></i></div>
                            Book mark
                            <!-- <div class="sb-sidenav-collapse-arrow"><i class="fas fa-angle-down"></i></div> -->
                        </a>
                        <a class="nav-link collapsed" href="#" data-bs-toggle="collapse" data-bs-target="#collapsePages"
                            aria-expanded="false" aria-controls="collapsePages">
                            <div class="sb-nav-link-icon"><i class="fas fa-user-edit"></i></div>
                            My Contents
                            <!-- <div class="sb-sidenav-collapse-arrow"><i class="fas fa-angle-down"></i></div> -->
                        </a>

                        <div class="sb-sidenav-menu-heading">Public PROJECT</div>
                        <a class="nav-link" href="#">
                            <div class="sb-nav-link-icon"><i class="far fa-building"></i>
                            </div>
                            Company project
                        </a>

                        <div class="sb-sidenav-menu-heading">New Update</div>
                        <a class="nav-link" href="#">
                            <div class="sb-nav-link-icon"><i class="fas fa-certificate"></i></div>
                            오똔 프로젝트1
                        </a>
                      

                    </div>
                </div>

            </nav>
        </div>
      
        <div id="layoutSidenav_content">
        
         <button id="create-projectBtn" type="button" class="btn btn-primary"
         data-bs-toggle="modal" data-bs-target="#exampleModal" style="display: none;">New Project</button> 
        <script>
        
        $("#create-project").click(e=>{
         $("#create-projectBtn").click();
      });
        
        const create_pro=()=>{
           //1.제목 입력 안했을때
           if($("#proName_").val().trim().length == 0){
              $("#proName_").focus();
              return false;
           }     
        }
        
        //제목 글자수 초과 100자
        $("#proName_").change(e=>{
            if($("#proName_").val().trim().length>100){
              $("#proName-result").text("100자 이하로 입력하세요");
              $("#proName-result").css("color","red");            
           }else{
              $("#proName-result").text("");
           }           
           
        });
        
        
        $(()=>{
           $("#floatingTextarea2").keyup(e=>{
                const length = $(e.target).val().length;
                if(length>600){
                   temp = $(e.target).val().substring(0,598);
                   $(e.target).val(temp);
                }
                $("#proExplain-result").text(length+"/600");
            });
           
           
           $("#close-project").click(e=>{
              $("#proName_").val("");
              $("#floatingTextarea2").val("");
              $("#proExplain-result").text("");
              
           });
           
           
        });
        
        //출근등록
     	$("#insertAttTime").click(e=>{
        	var d = new Date();
          	var attTime = moment(d).format('HH:mm');
     		const memberId ="<%=loginMember.getMemberId()%>";
     		$.ajax({
     			url : "<%=request.getContextPath()%>/attendance/insertAttTime.do",
     			type:'post',
     			data : {"memberId":memberId,"attTime":attTime},
     			dataType:'json',
     				success:data=>{
     					$("#attTime").html(data["attTime"]);
     					swal(data["attSuccess"]);
     				}
     		})
     	});
        
     
        //퇴근등록

     	$("#insertLeaveTime").click(e=>{
        	var d = new Date();
          	var leaveTime = moment(d).format('HH:mm');
     		const memberId ="<%=loginMember.getMemberId()%>";
     		$.ajax({
     			url : "<%=request.getContextPath()%>/attendance/insertLeaveTime.do",
     			type:'post',
     			data : {"memberId":memberId,"leaveTime":leaveTime},
     			dataType:'json',
     				success:data=>{
     					$("#leaveTime").html(data["leaveTime"]);
     					swal(data["leaveSuccess"]);
     				}
     				
     		})
     	});

        
        //출근, 퇴근 시간 화면 유지
        <% if(!(loginMember.getMemberId().equals("admin"))){%>
	 	$(document).ready(()=>{
	 		$.ajax({
     			url : "<%=request.getContextPath()%>/attendance/LoadAttTime.do",
     			type:'post',
     			dataType:'json',
     			success:data=>{
     				$("#attTime").html(data["attTime"]);
     				$("#leaveTime").html(data["leaveTime"]);
     				console.log($("#leaveTime").html());
     				console.log($("#attTime").html());
     			}
     		})
     	});  
        <% } %>
        
        
      
        
        
      
        </script>