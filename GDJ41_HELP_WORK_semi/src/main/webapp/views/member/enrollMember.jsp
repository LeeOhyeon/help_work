<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.help.gmail.SHA256" %>
<%@ page import="com.help.member.model.dao.MemberDao" %>
<%@ page import="com.help.member.model.vo.Member" %>
<%@ page import="java.io.PrintWriter" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입</title>
	 <script src="<%=request.getContextPath() %>/js/jquery-3.6.0.min.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ka7Sk0Gln4gmtz2MlQnikT1wXgYsOg+OMhuP+IlRH9sENBO0LRn5q+8nbTov4+1p" crossorigin="anonymous"></script>
	<!-- CSS only -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
	<script type="text/javascript"></script>
	<link href="https://fonts.googleapis.com/css2?family=Do+Hyeon&display=swap" rel="stylesheet">
<style>
	* {
	  margin: 0;
	  padding: 0;
	  box-sizing: border-box;
	  font-family: 'Do Hyeon', sans-serif;
	  color:#6710f242
	}
	.wrap {
	  width: 100%;
	  height: 100%;
	  display: flex;
	  align-items: center;
	  justify-content: center;
	  background: rgba(0, 0, 0, 0);
	  margin-top: 100px;
	  margin-bottom: 100px;
	}
	.btn-outline-secondary:hover{
	   background-color: #6710f242;
	   border: 1px solid #6710f242;
	}
	.btn-outline-secondary{
	   border: 1px solid #6710f242;
	   color:#6710f242;
	}
	th,h1{
		text-align:center;
		color:purple;
	}
	form{
		overflow:auto;
	}
	img {
    object-fit: cover;
    object-position: top;
    border-radius: 50%;
    width: 200px; 
    height: 200px;
}
</style>
</head>
<body>
	<section id=enroll-container >
		<div class="wrap">
	     	<form name="enrollMemberFrm" action="<%=request.getContextPath() %>/member/enrollMemberEnd.do" method="post" enctype="multipart/form-data" onsubmit="return checks()" >
	    	<%-- <form name="enrollMemberFrm" action="<%=request.getContextPath() %>/views/member/memberEnrollAction.jsp" method="post" enctype="multipart/form-data" onsubmit="return checks()" > --%>
	    		<table class="table" style="margin-left: auto; margin-right: auto;">
					<h1>회원 가입 정보 입력</h1>
					<tr>
						<th>아 이 디</th>
						<td>
							<div class="form-floating mb-3">
								<input type="text" class="form-control" id="memberId" name="memberId" placeholder="name@example.com">
								<label for="floatingInput">아이디 입력</label>
								<span>이메일 형식으로 입력해주세요 ex)silver@world.com</span>
							</div>
						</td>
						<td>
		 					<input type="button" value="아이디 중복검사" id="idDuplicateBtn" class="btn btn-outline-secondary">
		 					<br>
						</td>
					</tr>
					<tr>
						<th>비밀번호</th>
						<td colspan="2">
							<div class="form-floating">
								<input type="password" class="form-control" id="memberPwd" name="memberPwd" placeholder="비밀번호">
								<label for="floatingPassword">비밀번호 입력</label>
								<span>비밀번호는 영문 대소문자+숫자+특수문자 조합 최소 8자리 이상으로 작성해주세요</span>
							</div>
						</td>
					</tr>
					<tr>
						<th>비밀번호 확인</th>
						<td colspan="2">
							<div class="form-floating">
								<input type="password" class="form-control" id="memberPwd_2" name="memberPwd_2" placeholder="비밀번호">
								<label for="floatingPassword">비밀번호 확인</label>
								<span id="pwresult"></span>
							</div>	
						</td>
					</tr>  
					<tr>
						<th>이 름</th>
						<td colspan="2">	 
							<div class="form-floating mb-3">
								<input type="text" class="form-control" id="memberName" name="memberName" placeholder="">
								<label for="floatingInput">이름 입력</label> 
							</div>
						</td>
					</tr>
					<tr>
						<th>휴대폰번호</th>
						<td colspan="2">	
							<div class="form-floating mb-3">
								<input type="tel" class="form-control" id="memberPhone" name="memberPhone" placeholder="휴대폰번호를 '-'없이 입력">
								<label for="floatingInput">휴대폰번호를 '-'없이 입력</label>
							</div> 
						</td>
					</tr>
					<tr>
						<th>프로필사진</th>
						<td colspan="2">	
							<div id="imageContainer"></div>
							<div class="mb-3">
		  						<input class="form-control" type="file" id="memberProfile" name="memberProfile" >
							</div>
						</td>
					</tr>
				</table>
				<input type="submit" value="가입" class="btn btn-outline-secondary" >
				<input type="reset" value="취소" class="btn btn-outline-secondary">
			</form>
			<form name="idDuplicateFrm">
				<input type="hidden" name="memberId">
			</form>
		</div>
	</section>
	<script>
		//비밀번호 일치 확인
	   	$(()=>{
	   		$("#memberPwd_2").keyup(e=>{
	   			if($(e.target).val().trim().length>3){
	   				if($(e.target).val()==$("#memberPwd").val()){
	   					$("#pwresult").text("비밀번호가 일치합니다.").css({"color":"green"});
	   				}else{
	   					$("#pwresult").text("비밀번호가 불일치합니다.").css({"color":"red"});
	   				}
	   			}
	   		});
	   	});
	   
	   //아이디,비번,전화번호,이름 확인(정규표현식 적용)
	   	const checks=()=>{
	   		const checkId=RegExp(/^[A-Za-z0-9_\.\-]+@[A-Za-z0-9\-]+\.[A-Za-z0-9\-]+/);
	   		const checkPw=RegExp(/^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?&])[A-Za-z\d$@$!%*#?&]{8,25}$/);
			const checkPhone=RegExp(/^((01[1|6|7|8|9])[1-9]+[0-9]{6,7})|(010[1-9][0-9]{7})$/);
			const getName= RegExp(/^[가-힣]+$/);
			
			if(!checkId.test($("#memberId").val())){
	   			alert("이메일 형식으로 작성해주세요");
	   			$("#memberId").val("");
	   			$("#memberId").focus();
	   			return false;
	   		}

			if(!checkPw.test($("#memberPwd").val())){
				alert("비밀번호는 영문 대소문자+숫자+특수문자 조합 최소 8자리 이상으로 작성해주세요");				
	   			$("#memberPwd").val("");
	   			$("#memberPwd").focus();
	   			return false;
			}
			
			if(!checkPhone.test($("#memberPhone").val())){
				alert("전화번호를 정확하게 입력해주세요!");
				$("#memberPhone").val("");
				$("#memberPhone").focus();
				return false;
			}
			
			if (!getName.test($("#memberName").val())) {
		        alert("이름 똑띠 쓰세용");
		        $("#memberName").val("");
		        $("#memberName").focus();
		        return false;
		      }
	   		
	   	}
	   	
	   	//아이디 중복확인하기
	   	$(()=>{
	   		$("#idDuplicateBtn").click(e=>{
	   			const memberId=$("#memberId").val().trim();
	   			if(memberId.match("@")){
	   				const url="<%=request.getContextPath()%>/member/idDuplicate.do";
	   				const title="idDuplicate";
	   				const style="width=350,height=100";
	   				open("",title,style);
	   				idDuplicateFrm.memberId.value=memberId;
	   				idDuplicateFrm.action=url;
	   				idDuplicateFrm.method="post";
	   				idDuplicateFrm.target=title;
	   				idDuplicateFrm.submit();
	   				
	   			}else{
	   				alert("이메일 형식으로 작성해주세요");
	   				$("#memberId").focus();
	   			}
	   		});
	   	});
	   	
	   	$("#target").click(e=>{
	   		$("input[name=memberProfile]").click();
	   	});
	   	$("input[name=memberProfile]").change(e=>{
	   		if(e.target.files[0].type.includes("image")){
	   			let reader=new FileReader();
	   			reader.onload=(e)=>{
	   				const img=$("<img>").attr({
	   					src:e.target.result,
	   					width:"100px",
	   					height:"100px",
	   				});
	   				$("#imageContainer").append(img);
	   				$("#target").attr("src",e.target.result);
	   			}
	   			reader.readAsDataURL(e.target.files[0]);
	   		}
	   	});
   
   </script>
</body>
</html>