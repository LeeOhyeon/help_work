<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="http://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ka7Sk0Gln4gmtz2MlQnikT1wXgYsOg+OMhuP+IlRH9sENBO0LRn5q+8nbTov4+1p" crossorigin="anonymous"></script>
	<!-- CSS only -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
	<script type="text/javascript"></script>
	<link href="https://fonts.googleapis.com/css2?family=Do+Hyeon&display=swap" rel="stylesheet">
<title>비밀번호 변경</title>
	<style>
    div#updatePassword-container table {
        margin:0 auto;
        border-spacing: 20px;
    }
    div#updatePassword-container table tr:last-of-type td {
        text-align:center;
    }
    #updatePassword-container{
		font-family: 'Do Hyeon', sans-serif;
		color:#6710f242
	}
	th{
		color:purple
	}
	.btn-outline-secondary:hover{
	   background-color: #6710f242;
	   border: 1px solid #6710f242;
	}
	.btn-outline-secondary{
	   border: 1px solid #6710f242;
	   color:#6710f242;
	}
    </style>
</head>
<body>
    <div id="updatePassword-container">
		<form name="updatePwdFrm" action="<%=request.getContextPath()%>/member/updatePasswordEnd.do" method="post" onsubmit="return passwordValidate();" >
			<table>
				<tr><td><br></td></tr>
				<tr>
					<th>현재 비밀번호</th>
					<td colspan="2">
						<div class="form-floating">
							<input type="password" class="form-control" id="memberPwd" name="memberPwd" required placeholder="비밀번호">
							<label for="floatingPassword">현재 비밀번호 입력</label>
						</div>
					</td>
				</tr>
				<tr>
					<th>비밀번호</th>
					<td colspan="2">
						<div class="form-floating">
							<input type="password" class="form-control" id="password_new" name="password_new" required placeholder="비밀번호">
							<label for="floatingPassword">새로운 비밀번호 입력</label>
							<span>비밀번호는 영문 대소문자+숫자+특수문자 조합 최소 8자리 이상으로 작성해주세요</span>
						</div>
					</td>
				</tr>
				<tr>
					<th>비밀번호 확인</th>
					<td colspan="2">
						<div class="form-floating">
							<input type="password" class="form-control" id="password_chk" name="password_chk" required placeholder="비밀번호">
							<label for="floatingPassword">비밀번호 확인</label>
							<span id="pwresult"></span>
						</div>	
					</td>
				</tr>
				<tr><td><br></td></tr>
				<tr>
					<td colspan="2">
						<input type="submit" class="btn btn-outline-secondary" value="변경" />&nbsp;
						<input type="button" class="btn btn-outline-secondary" value="닫기" onclick="window.close();"/>						
					</td>
				</tr>
			</table>
			<input type="hidden" name="memberId" value="<%=request.getParameter("memberId") %>"/>
		</form>
	</div>
	<script>
		//비밀번호 글자수확인
		const passwordValidate=()=>{
	  		const checkPw=RegExp(/^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?&])[A-Za-z\d$@$!%*#?&]{8,25}$/);
			if(!checkPw.test($("#password_new").val())){
				alert("비밀번호는 영문 대소문자+숫자+특수문자 조합 최소 8자리 이상으로 작성해주세요");				
	   			$("#password_new").val("");
	   			$("#password_new").focus();
	   			return false;
			}
	   	}
		
		//비밀번호 일치 확인
	   	$(()=>{
	   		$("#password_chk").keyup(e=>{
	   			if($(e.target).val().trim().length>3){
	   				if($(e.target).val()==$("#password_new").val()){
	   					$("#pwresult").text("비밀번호가 일치합니다.").css({"color":"green"});
	   				}else{
	   					$("#pwresult").text("비밀번호가 불일치합니다.").css({"color":"red"});
	   				}
	   			}
	   		});
	   	});
	   	/* const el=document.querySelector("#btn").addEventListener("click",e=>{
			close();
		}); */
	
	</script>
</body>
</html>