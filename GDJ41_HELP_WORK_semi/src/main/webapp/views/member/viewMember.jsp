<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	Member m=(Member)request.getAttribute("member");
%>
<%@ include file="/views/common/header.jsp" %>
<style>
.updateMemberSection{
	font-family: 'Do Hyeon', sans-serif;
	color:#6710f242;
	height: 100%;
}
h2{
	color:#6710f242;
}
.btn-outline-secondary:hover{
   background-color: #6710f242;
   border: 1px solid #6710f242;
}
.btn-outline-secondary{
   border: 1px solid #6710f242;
   color:#6710f242;
}

.profileImg{
	align
}
.fas{
	font-size:500px;
}
h2,th{
	text-align:center;
	color:purple;
}
/* .profile-span{
	text-align:center;
} */
.profile-outer{
display: flex;
  justify-content: center;
}
img {
    object-fit: cover;
    object-position: top;
    border-radius: 50%;
    width: 150px; 
    height: 150px;
}
#enroll-container{
	
}

</style>
	<main>
		<div class="updateMemberSection">
	    	<div style="text-align: center; display: flex; justify-content: center; margin: 50px;">
	    		<form name="updateMemberFrm" action="<%=request.getContextPath() %>/member/updateMember.do" method="post" enctype="multipart/form-data" >
	    		<table class="updateTbl">
					<tr> 
						<td colspan="2">
						<div class="profile-outer">
							<%if(m.getMemberProfile()!=null){ %>
								<div class="profile-inner">
									<img class="profileImg" src="<%=request.getContextPath() %>/upfile/member/<%=m.getMemberProfile() %>">
								</div>
							<%}else{ %>
								<div class="profile-inner">
									<img class="profileImg" src="<%=request.getContextPath() %>/upfile/member/noImage2.png">
								</div>
							<%} %>
							<input type="hidden" name="oriProfile" value="<%=m.getMemberProfile() %>">
						</div>
							<span class="profile-inner">현재 프로필사진</span>
						</td>
					</tr>
					<tr>
						<th>아이디</th>
						<td>
							<div class="mb-3">
								<input class="form-control" type="text" value="<%=m.getMemberId() %>" id="memberId" name="memberId" aria-label="readonly input example" readonly>
							</div>
						</td>
					</tr>
					<tr>
						<th>이름</th>
						<td>	
							<%-- <input type="text"  name="memberName" id="memberName" required value="<%=m.getMemberName() %>" ><br> --%>
							<div class="mb-3">
							  <input type="text" class="form-control" id="memberName" name="memberName" required value="<%=m.getMemberName() %>">
							</div>
						</td>
					</tr>
					<tr>
						<th>휴대폰</th>
						<td>	
							<div class="mb-3">
							  <input type="text" class="form-control" id="memberPhone" name="memberPhone" required value="<%=m.getMemberPhone() %>">
							</div>
						</td>
					</tr>
					
					<tr>
						<th>프로필사진</th>
						<td>	
							<div id="imageContainer"></div>
							<div class="mb-3">
		  						<input class="form-control" type="file" id="memberProfile" name="memberProfile" >
							</div>
						</td>
					</tr>	
				</table>
			<div class="inner" style="width:100%; display: flex; justify-content: center;">
				<div style="width: 40%; text-align: center;">
					<div style="width: 100%; display: inline-block;">
						<input type="button" value="비밀번호 변경" class="btn btn-outline-secondary" id="pwChangeBtn" onclick="updatePassword();" style="width: 100%;">
					</div>
					<div style="width: 100%; display: inline-block; ">
						<input type="submit" value="회원정보수정" class="btn btn-outline-secondary" style="width: 100%">
					</div>
				</div>
			</div>
				</form>
	    		</div>
	<!-- 			<input type="submit" value="회원정보수정" >
				<input type="button" value="비밀번호 변경" id="pwChangeBtn" onclick="updatePassword();"> -->
			
		</div>
		
	</main>
	
	<script>
		//이미지 미리보기
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
	   					height:"100px"
	   				});
	   				$("#imageContainer").append(img);
	   				$("#target").attr("src",e.target.result);
	   			}
	   			reader.readAsDataURL(e.target.files[0]);
	   		}
	   	})
	   	
		//회원정보수정
		const updateMember=()=>{
			const url="<%=request.getContextPath()%>/member/updateMember.do";
			$("form[name=updateMemberFrm]").attr("action",url);
			$("form[name=updateMemberFrm]").submit();
		}
		
		//비밀번호 변경
		const updatePassword=()=>{
			const url="<%=request.getContextPath()%>/member/updatePassword.do?memberId=<%=m.getMemberId()%>";
			const style="width=600,height=300,top=200,left=500";
			open(url,"_blank",style);
		}
	</script>

<%@ include file="/views/common/footer.jsp"%>