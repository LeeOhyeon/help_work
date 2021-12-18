package com.help.project.model.vo;

import java.sql.Date;

import com.help.member.model.vo.Member;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class NormalContent {

	private int normalContentNo;
	private int projectNo;
	//private Member memberId;
	private String memberId;
	private String normalContentTitle;
	private String normalContentContent;
	private Date normalContentDate;
	private int normalContentReadCount;
	
	
	
}
