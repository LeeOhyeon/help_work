package com.help.member.model.dao;

import static com.help.common.JDBCTemplate.close;

import java.io.FileReader;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Properties;

import com.help.common.JDBCTemplate;
import com.help.member.model.vo.Member;

public class MemberDao {
	
	private Properties prop=new Properties();
	
	public MemberDao() {
		String path=MemberDao.class.getResource("/sql/member/member_sql.properties").getPath();
		try {
			prop.load(new FileReader(path));
		}catch(IOException e) {
			e.printStackTrace();
		}
	}
	
	//로그인
	public Member login(Connection conn,String memberId,String memberPwd) {
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		Member m=null;
		String sql=prop.getProperty("selectMember");
		try {
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1, memberId);
			pstmt.setString(2, memberPwd);
			rs=pstmt.executeQuery();
			if(rs.next()) {
				m=Member.builder()
						.memberId(rs.getString("MEMBER_ID"))
						.deptCode(rs.getString("DEPT_CODE"))
						.positionCode(rs.getString("POSITION_CODE"))
						.memberPwd(rs.getString("MEMBER_PWD"))
						.memberPhone(rs.getString("MEMBER_PHONE"))
						.memberProfile(rs.getString("MEMBER_PROFILE"))
						.memberName(rs.getString("MEMBER_NAME"))
						.memberUseYn(rs.getString("MEMBER_USE_YN"))
						.build();
			}
		}catch(SQLException e) {
			e.printStackTrace();
		}finally {
			close(rs);
			close(pstmt);
		}
		return m;
	}
//	public int login(String memberId,String memberPwd) {
//		PreparedStatement pstmt=null;
//		Connection conn=null;
//		ResultSet rs=null;
////		Member m=null;
//		String sql=prop.getProperty("loginMember");
//		try {
//			conn=JDBCTemplate.getConnection();
//			pstmt=conn.prepareStatement(sql);
//			pstmt.setString(1, memberId);
//			rs=pstmt.executeQuery();
//			if(rs.next()) {
////				m=Member.builder()
////						.memberId(rs.getString("MEMBER_ID"))
////						.deptCode(rs.getString("DEPT_CODE"))
////						.positionCode(rs.getString("POSITION_CODE"))
////						.memberPwd(rs.getString("MEMBER_PWD"))
////						.memberPhone(rs.getString("MEMBER_PHONE"))
////						.memberProfile(rs.getString("MEMBER_PROFILE"))
////						.memberName(rs.getString("MEMBER_NAME"))
////						.memberUseYn(rs.getString("MEMBER_USE_YN"))
////						.emailHash(rs.getString("EMAIL_HASH"))
////						.emailChecked(rs.getBoolean("EMAIL_CHECKED"))
////						.build();
//				if(rs.getString(1).equals(memberPwd)) {
//					return 1;// 로그인 성공
//				}
//				else {
//					return 0; // 비밀번호 틀림
//				}
//			}
//			return -1; //아이디 없음
//		}catch(SQLException e) {
//			e.printStackTrace();
//		}finally {
//			try {if(conn != null) conn.close();} catch (Exception e) {e.printStackTrace();}
//	        try {if(pstmt != null) pstmt.close();} catch (Exception e) {e.printStackTrace();}
//	        try {if(rs != null) rs.close();} catch (Exception e) {e.printStackTrace();}
//		}
//		return -2;// 데이터베이스 오류
//	}
	
	
	//id중복확인
	public Member checkIdDuplicate(Connection conn,String memberId) {
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		Member m=null;
		String sql=prop.getProperty("selectId");
		try {
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1, memberId);
			rs=pstmt.executeQuery();
			if(rs.next()) {
				m=Member.builder()
						.memberId(rs.getString("MEMBER_ID"))
						.memberPwd(rs.getString("MEMBER_PWD"))
						.memberPhone(rs.getString("MEMBER_PHONE"))
						.memberProfile(rs.getString("MEMBER_PROFILE"))
						.memberName(rs.getString("MEMBER_NAME"))
						.build();
			}
		}catch(SQLException e) {
			e.printStackTrace();
		}finally {
			close(rs);
			close(pstmt);
		}return m;
	}
	
	//회원가입
	public int insertMember(Connection conn,Member m) {
		PreparedStatement pstmt=null;
		int result=0;
		String sql=prop.getProperty("insertMember");
		try {
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1, m.getMemberId());
			pstmt.setString(2, m.getMemberPwd());
			pstmt.setString(3, m.getMemberPhone());
			pstmt.setString(4, m.getMemberProfile());
			pstmt.setString(5, m.getMemberName());
			result=pstmt.executeUpdate();
		}catch(SQLException e) {
			e.printStackTrace();
		}finally {
			close(pstmt);
		}return result;
	}
//	public int insertMember(Member m) {
//        Connection conn = null; 
//		PreparedStatement pstmt=null;
//		ResultSet rs=null;
//		String sql=prop.getProperty("insertMember");
//		try {
//			conn=JDBCTemplate.getConnection();
//			pstmt=conn.prepareStatement(sql);
//			pstmt.setString(1, m.getMemberId());
//			pstmt.setString(2, m.getMemberPwd());
//			pstmt.setString(3, m.getMemberPhone());
//			pstmt.setString(4, m.getMemberProfile());
//			pstmt.setString(5, m.getMemberName());
//			pstmt.setString(6, m.getEmailHash());
//			return pstmt.executeUpdate();
//		}catch(SQLException e) {
//			e.printStackTrace();
//		}finally {
//			try {if(conn != null) conn.close();} catch (Exception e) {e.printStackTrace();}
//			try {if(pstmt != null) pstmt.close();} catch (Exception e) {e.printStackTrace();}
//			try {if(rs != null) rs.close();} catch (Exception e) {e.printStackTrace();}
//		}return -1; //회원가입 실패
//	}
	
	//이메일 인증여부
	
//	public boolean getEmailChecked(String memberId) { 
//		String sql=prop.getProperty("selectEmailChecked");    
//        Connection conn = null; 
//        PreparedStatement pstmt = null;
//        ResultSet rs = null; 
//			boolean flag = false;
//			int result = 0;        
//	try {          
//            conn = JDBCTemplate.getConnection(); 
//            pstmt = conn.prepareStatement(sql); 
//            pstmt.setString(1, memberId);
//            rs = pstmt.executeQuery();
//            if(rs.next()) {
//              result = rs.getInt(1);
//            }
//        } catch (Exception e) {
//             e.printStackTrace();
//        } finally { 
//          try {if(conn != null) conn.close();} catch (Exception e) {e.printStackTrace();}
//          try {if(pstmt != null) pstmt.close();} catch (Exception e) {e.printStackTrace();}
//          try {if(rs != null) rs.close();} catch (Exception e) {e.printStackTrace();}
//       }
	
//			if(result>0) {
//				flag = true;
//			}else {
//				flag = false;
//			}
//			return flag;
	
//        return false; // 데이터베이스 오류
//	}
//	
//	
//	//이메일 인증받기
//	
//	
//	public boolean setEmailChecked(String memberId) { //이메일 인증을 완료해주는 함수
//	    String sql=prop.getProperty("updateEmailChecked");
//        Connection conn = null; 
//        PreparedStatement pstmt = null;
//        ResultSet rs = null; 
//        try {          
//            conn = JDBCTemplate.getConnection(); 
//            pstmt = conn.prepareStatement(sql); 
//            pstmt.setString(1, memberId);
//            pstmt.executeUpdate();
//            return true;
//        } catch (Exception e) {
//             e.printStackTrace();
//        } finally { 
//          try {if(conn != null) conn.close();} catch (Exception e) {e.printStackTrace();}
//          try {if(pstmt != null) pstmt.close();} catch (Exception e) {e.printStackTrace();}
//          try {if(rs != null) rs.close();} catch (Exception e) {e.printStackTrace();}
//       }
//        return false; // 데이터베이스 오류
//       }          
//  
//	//이메일 확인
//	public String getMemberEmail(String memberId) {
//    	  String sql=prop.getProperty("getMemberEmail");
//          Connection conn = null; 
//          PreparedStatement pstmt = null; 
//          ResultSet rs = null; 
//          try {          
//              conn = JDBCTemplate.getConnection();
//              pstmt = conn.prepareStatement(sql); 
//              pstmt.setString(1, memberId);
//              rs = pstmt.executeQuery();
//              if(rs.next()) {
//                  return rs.getString(1);
//              }
//          } catch (Exception e) {
//               e.printStackTrace();
//          } finally { 
//            try {if(conn != null) conn.close();} catch (Exception e) {e.printStackTrace();}
//            try {if(pstmt != null) pstmt.close();} catch (Exception e) {e.printStackTrace();}
//            try {if(rs != null) rs.close();} catch (Exception e) {e.printStackTrace();}
//         }
//          return null; // 데이터베이스 오류
//    }
	
	//회원정보수정
	public int updateMember(Connection conn,Member m) {
		PreparedStatement pstmt=null;
		int result=0;
		String sql=prop.getProperty("updateMember");
		try {
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1, m.getMemberPhone());
			pstmt.setString(2, m.getMemberProfile());
			pstmt.setString(3, m.getMemberName());
			pstmt.setString(4, m.getMemberId());
			result=pstmt.executeUpdate();
		}catch(SQLException e) {
			e.printStackTrace();
		}finally {
			close(pstmt);
		}return result;
	}
	
	//비밀번호변경
	public int updatePassword(Connection conn,String memberId,String memberPwd) {
		PreparedStatement pstmt=null;
		int result=0;
		String sql=prop.getProperty("updatePassword");
		try {
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1, memberPwd);
			pstmt.setString(2, memberId);
			result=pstmt.executeUpdate();
		}catch(SQLException e) {
			e.printStackTrace();
		}finally {
			close(pstmt);
		}
		return result;
	}
	
	//아이디 찾기
	public String findMemberId(Connection conn,String memberName,String memberPhone) {
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		String memberId=null;
		String sql=prop.getProperty("findMemberId");
		try {
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1, memberName);
			pstmt.setString(2, memberPhone);
			rs=pstmt.executeQuery();
			if(rs.next()) {
				memberId = rs.getString("MEMBER_ID"); 
			}
			
		}catch(SQLException e) {
			e.printStackTrace();
		}finally {
			close(rs);
			close(pstmt);
		}
		return memberId;
	}
	
	
}	
        

