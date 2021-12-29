package com.help.project.model.dao;

import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import java.util.Properties;
import static com.help.common.JDBCTemplate.close;

import com.help.member.model.vo.Member;
import com.help.project.model.vo.Project;
import com.help.project.model.vo.ProjectAddMember;
import com.help.project.model.vo.ProjectContent;
import com.help.project.model.vo.ScheAttendName;
import com.help.project.model.vo.WorkFile;
import com.help.project.model.vo.WorkManagerName;
import com.help.project.normal.model.vo.NormalContent;
import com.help.project.work.model.vo.WorkManager;
import com.help.project.model.vo.NormalFile;
import com.help.project.model.vo.ProMemberJoinMember;

public class ProjectDao {

	private Properties prop = new Properties();

	public ProjectDao() {
		try {
			prop.load(
					new FileReader(ProjectDao.class.getResource("/").getPath() + "sql/project/project_sql.properties"));
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	public int insertProject(Connection conn, Project p) {

		PreparedStatement pstmt = null;
		int result = 0;
		String sql = prop.getProperty("insertProject");

		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, p.getMemberId());
			pstmt.setString(2, p.getProName());
			pstmt.setString(3, p.getProExplain());
			pstmt.setString(4, p.getProCommonYn());
			result = pstmt.executeUpdate();
		} catch (SQLException e) {

			e.printStackTrace();
		} finally {
			close(pstmt);
		}

		return result;

	}

	public List<Project> selectJoin(Connection conn, String memId) {
		// 로그인한 사원이 참여한 모든 프로젝트
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List<Project> result = new ArrayList<Project>();
		// Project p=null;
		String sql = prop.getProperty("selectJoinProject");
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, memId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				Project p = Project.builder().projectNo(rs.getInt("PROJECT_NO")).memberId(rs.getString("MEMBER_ID"))
						.proName(rs.getString("PRO_NAME")).proExplain(rs.getString("PRO_EXPLAIN"))
						.proCommonYn(rs.getString("PRO_COMMON_YN")).proIsActive(rs.getString("PRO_ISACTIVE"))
						.proDate(rs.getDate("PRO_DATE")).build();

				result.add(p);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			close(rs);
			close(pstmt);
		}
		return result;
	}

	public int proMemberCount(Connection conn,int proNo) {
		//로그인한 사원이 참가한 프로젝트의 총 참여인원
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		int joinNum=0;
		String sql=prop.getProperty("joinProjectNumber");
		try {
			pstmt=conn.prepareStatement(sql);
			pstmt.setInt(1, proNo);
			rs=pstmt.executeQuery();
			if(rs.next()) {
				joinNum=rs.getInt("COUNT(*)");
			}
		}catch(SQLException e) {
			e.printStackTrace();
		}finally {
			close(rs);
			close(pstmt);
		}
		return joinNum;
	}
	public HashMap<Integer, Integer> selectJoinNumber(Connection conn, HashMap<Integer, Integer> peopleNum) {
		// 키:프로젝트번호 밸류:해당프로젝트 참가자수 해서 반환함
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		HashMap<Integer, Integer> result = peopleNum;
		String sql = prop.getProperty("joinProjectNumber");
		try {
			pstmt = conn.prepareStatement(sql);
			for (Entry<Integer, Integer> entry : peopleNum.entrySet()) {
				pstmt.setInt(1, entry.getKey());
				rs = pstmt.executeQuery();
				if (rs.next()) {
					result.put(entry.getKey(), rs.getInt("COUNT(*)"));
				}
			}

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			close(rs);
			close(pstmt);
		}
		return result;
	}

	public Project selectProjectNewinsert(Connection conn,String memberId) {

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = prop.getProperty("selectProjectNewinsert");
		Project p = null;

		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, memberId);	
			rs = pstmt.executeQuery();
			if (rs.next()) {
				p = Project.builder().projectNo(rs.getInt("PROJECT_NO")).memberId(rs.getString("MEMBER_ID"))
						.proName(rs.getString("PRO_NAME")).proExplain(rs.getString("PRO_EXPLAIN"))
						.proCommonYn(rs.getString("PRO_COMMON_YN")).proIsActive(rs.getString("PRO_ISACTIVE"))
						.proDate(rs.getDate("PRO_DATE")).build();
			}

		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			close(rs);
			close(pstmt);
		}
		return p;
	}

	public int insertProMemberCreator(Connection conn, Project pinfo) {

		PreparedStatement pstmt = null;
		int result = 0;
		String sql = prop.getProperty("insertProMemberCreator");

		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, pinfo.getProjectNo());
			pstmt.setString(2, pinfo.getMemberId());

			result = pstmt.executeUpdate();

		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			close(pstmt);
		}

		return result;
	}

	public Project selectProjectOne(Connection conn, int projectNo) {

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = prop.getProperty("selectProjectOne");
		Project p = null;

		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, projectNo);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				p = Project.builder().projectNo(rs.getInt("PROJECT_NO")).memberId(rs.getString("MEMBER_ID"))
						.proName(rs.getString("PRO_NAME")).proExplain(rs.getString("PRO_EXPLAIN")).memberName(rs.getString("MEMBER_NAME"))
						.proCommonYn(rs.getString("PRO_COMMON_YN")).proIsActive(rs.getString("PRO_ISACTIVE"))
						.proDate(rs.getDate("PRO_DATE")).build();
			}

		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			close(rs);
			close(pstmt);
		}
		return p;
	}

	// 프로젝트에 참여중인 사원 리스트
	public List<ProMemberJoinMember> selectProjectJoinMemberList(Connection conn, int projectNo) {

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List<ProMemberJoinMember> mList = new ArrayList();
		ProMemberJoinMember m = null;
		String sql = prop.getProperty("selectProjectJoinMemberList");

		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, projectNo);

			rs = pstmt.executeQuery();

			while (rs.next()) {

				m = ProMemberJoinMember.builder().proMemberNo(rs.getInt("PRO_MEMBER_NO"))
						.projectNo(rs.getInt("PROJECT_NO")).memberId(rs.getString("MEMBER_ID"))
						.deptCode(rs.getString("DEPT_CODE")).positionCode(rs.getString("POSITION_CODE"))
						.memberPhone(rs.getString("MEMBER_PHONE")).memberProfile(rs.getString("MEMBER_PROFILE"))
						.memberName(rs.getString("MEMBER_NAME")).memberUseYn(rs.getString("MEMBER_USE_YN")).build();
				mList.add(m);

			}

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			close(rs);
			close(pstmt);
		}

		return mList;
	}

	public int selectProjectNo(Connection conn, Project pinfo) {

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int projectNo = 0;
		String sql = prop.getProperty("selectProjectNo");

		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, pinfo.getMemberId());
			pstmt.setString(2, pinfo.getProName());
			pstmt.setString(3, pinfo.getProExplain());
			rs = pstmt.executeQuery();

			if (rs.next())
				projectNo = rs.getInt(1);

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			close(rs);
			close(pstmt);
		}
		return projectNo;
	}

	public List<ProjectAddMember> selectAllMember(Connection conn) {

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List<ProjectAddMember> mAllList = new ArrayList();
		ProjectAddMember m = null;
		String sql = prop.getProperty("selectAllMember");

		try {
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();

			while (rs.next()) {

				m = ProjectAddMember.builder().memberId(rs.getString("MEMBER_ID"))
						.memberName(rs.getString("MEMBER_NAME")).memberProfile(rs.getString("MEMBER_PROFILE"))
						.deptName(rs.getString("DEPT_NAME")).positionName(rs.getString("POSITION_NAME")).build();

				mAllList.add(m);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			close(rs);
			close(pstmt);
		}
		return mAllList;
	}

	public int insertProMember(Connection conn, List<Map<String, Object>> mList) {
		// 프로젝트 사원 추가
		PreparedStatement pstmt = null;
		int result = 0;
		String sql = prop.getProperty("insertProMemberCreator");

		try {
			for (int i = 0; i < mList.size(); i++) {
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, (int) mList.get(i).get("projectNo"));
				pstmt.setString(2, (String) mList.get(i).get("memberId"));

				result = pstmt.executeUpdate();
			}

		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			close(pstmt);
		}

		return result;
	}

	public List<ProjectAddMember> selectSearchMember(Connection conn, String searchType, String keyword) {
		// 프로젝트 사원 검색
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List<ProjectAddMember> searchMemberList = new ArrayList();
		ProjectAddMember m = null;
		String sql = prop.getProperty("selectSearchMember");
		sql = sql.replace("#COL", searchType);
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, "%" + keyword + "%");
			rs = pstmt.executeQuery();

			while (rs.next()) {

				m = ProjectAddMember.builder().memberId(rs.getString("MEMBER_ID"))
						.memberName(rs.getString("MEMBER_NAME")).memberProfile(rs.getString("MEMBER_PROFILE"))
						.deptName(rs.getString("DEPT_NAME")).positionName(rs.getString("POSITION_NAME")).build();

				searchMemberList.add(m);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			close(rs);
			close(pstmt);
		}

		return searchMemberList;
	}

	public List<ProjectContent> selectAllProjectContent(Connection conn, int projectNo, int cPage, int numPerPage) {

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ProjectContent pc = null;
		List<ProjectContent> pList = new ArrayList();
		String sql = prop.getProperty("selectAllProjectContent");

		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, projectNo);
			pstmt.setInt(2, (cPage - 1) * numPerPage + 1);
			pstmt.setInt(3, cPage * numPerPage);

			rs = pstmt.executeQuery();

			while (rs.next()) {

				pc = ProjectContent.builder().projectNo(rs.getInt("PROJECT_NO")).contentNo(rs.getInt("CONTENT_NO"))
						.memberId(rs.getString("MEMBER_ID")).memberName(rs.getString("MEMBER_NAME"))
						.contentTitle(rs.getString("CONTENT_TITLE")).content(rs.getString("CONTENT"))
						.startDate(rs.getDate("START_DATE") == null ? ""
								: new SimpleDateFormat("yyyy-MM-dd").format(rs.getDate("START_DATE")))
						.endDate(rs.getDate("END_DATE") == null ? ""
								: new SimpleDateFormat("yyyy-MM-dd").format(rs.getDate("END_DATE")))
						.workIng(rs.getString("WORK_ING")).workRank(rs.getString("WORK_RANK"))
						.address(rs.getString("ADDRESS")).placeName(rs.getString("PLACE_NAME"))
						.readCount(rs.getInt("READCOUNT"))
						.writeDate(rs.getDate("WRITE_DATE") == null ? ""
								: new SimpleDateFormat("yyyy-MM-dd").format(rs.getDate("WRITE_DATE")))
						.dist(rs.getString("DIST")).build();

				pList.add(pc);
			}

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			close(rs);
			close(pstmt);
		}

		return pList;
	}

	public int selectAllProjectContentCount(Connection conn, int projectNo) {

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int result = 0;
		String sql = prop.getProperty("selectAllProjectContentCount");

		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, projectNo);
			rs = pstmt.executeQuery();

			if (rs.next()) {
				// 컬럼이 한개니까 인덱스 번호로 쓸 수도 있다!
				result = rs.getInt(1);
			}

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			close(rs);
			close(pstmt);
		}

		return result;
	}

	public ProjectContent selectContentOne(Connection conn, String dist, int contentNo) {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ProjectContent pc = null;
		String sql = prop.getProperty("selectContentOne");

		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dist);
			pstmt.setInt(2, contentNo);
			rs = pstmt.executeQuery();

			if (rs.next()) {
				// 컬럼이 한개니까 인덱스 번호로 쓸 수도 있다!
				pc = ProjectContent.builder().projectNo(rs.getInt("PROJECT_NO")).contentNo(rs.getInt("CONTENT_NO"))
						.memberId(rs.getString("MEMBER_ID")).memberName(rs.getString("MEMBER_NAME"))
						.contentTitle(rs.getString("CONTENT_TITLE")).content(rs.getString("CONTENT"))
						.startDate(rs.getDate("START_DATE") == null ? ""
								: new SimpleDateFormat("yyyy-MM-dd").format(rs.getDate("START_DATE")))
						.endDate(rs.getDate("END_DATE") == null ? ""
								: new SimpleDateFormat("yyyy-MM-dd").format(rs.getDate("END_DATE")))
						.workIng(rs.getString("WORK_ING")).workRank(rs.getString("WORK_RANK"))
						.address(rs.getString("ADDRESS")).placeName(rs.getString("PLACE_NAME"))
						.readCount(rs.getInt("READCOUNT"))
						.writeDate(rs.getDate("WRITE_DATE") == null ? ""
								: new SimpleDateFormat("yyyy-MM-dd").format(rs.getDate("WRITE_DATE")))
						.dist(rs.getString("DIST")).build();
			}

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			close(rs);
			close(pstmt);
		}

		return pc;
	}

	public List<WorkManagerName> selectWorkManager(Connection conn, int contentNo) {
		// 업무 담당쟈 갸져오깅
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = prop.getProperty("selectWorkManagerName");
		WorkManagerName wm = null;
		List<WorkManagerName> wmList = new ArrayList();

		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, contentNo);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				wm = WorkManagerName.builder().workNo(rs.getInt("WORK_NO")).managerId(rs.getString("MANAGER_ID"))
						.managerName(rs.getString("MEMBER_NAME")).build();
				wmList.add(wm);
			}

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			close(rs);
			close(pstmt);
		}
		return wmList;
	}

	public List<ScheAttendName> selectScheAttendName(Connection conn, int contentNo) {
		// 업무 담당쟈 갸져오깅
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = prop.getProperty("selectScheAttendName");
		ScheAttendName sa = null;
		List<ScheAttendName> saList = new ArrayList();

		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, contentNo);
			rs = pstmt.executeQuery();

			while (rs.next()) {

				sa = ScheAttendName.builder().scheduleNo(rs.getInt("SCHEDULE_NO")).memberId(rs.getString("MEMBER_ID"))
						.memberName(rs.getString("MEMBER_NAME")).build();
				saList.add(sa);

			}

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			close(rs);
			close(pstmt);
		}
		return saList;
	}

	public List<ProjectContent> selectSearchProjectContent(Connection conn, int projectNo, int cPage, int numPerPage,
			String searchType, String keyword, String dist) {

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ProjectContent pc = null;
		List<ProjectContent> pList = new ArrayList();
		String sql = prop.getProperty("selectSearchProjectContent");
		sql = sql.replace("#COL", searchType);

		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, projectNo);
			pstmt.setString(2, dist);
			pstmt.setString(3, "%" + keyword + "%");
			pstmt.setInt(4, (cPage - 1) * numPerPage + 1);
			pstmt.setInt(5, cPage * numPerPage);

			rs = pstmt.executeQuery();

			while (rs.next()) {

				pc = ProjectContent.builder().projectNo(rs.getInt("PROJECT_NO")).contentNo(rs.getInt("CONTENT_NO"))
						.memberId(rs.getString("MEMBER_ID")).memberName(rs.getString("MEMBER_NAME"))
						.contentTitle(rs.getString("CONTENT_TITLE")).content(rs.getString("CONTENT"))
						.startDate(rs.getDate("START_DATE") == null ? ""
								: new SimpleDateFormat("yyyy-MM-dd").format(rs.getDate("START_DATE")))
						.endDate(rs.getDate("END_DATE") == null ? ""
								: new SimpleDateFormat("yyyy-MM-dd").format(rs.getDate("END_DATE")))
						.workIng(rs.getString("WORK_ING")).workRank(rs.getString("WORK_RANK"))
						.address(rs.getString("ADDRESS")).placeName(rs.getString("PLACE_NAME"))
						.readCount(rs.getInt("READCOUNT"))
						.writeDate(rs.getDate("WRITE_DATE") == null ? ""
								: new SimpleDateFormat("yyyy-MM-dd").format(rs.getDate("WRITE_DATE")))
						.dist(rs.getString("DIST")).build();

				pList.add(pc);
			}

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			close(rs);
			close(pstmt);
		}

		return pList;

	}

	public int selectSearchProjectContentCount(Connection conn, int projectNo, String searchType, String keyword,
			String dist) {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int result = 0;
		String sql = prop.getProperty("selectSearchProjectContentCount");
		sql = sql.replace("#COL", searchType);
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, projectNo);
			pstmt.setString(2, dist);
			pstmt.setString(3, "%" + keyword + "%");
			rs = pstmt.executeQuery();

			if (rs.next()) {
				result = rs.getInt(1);
			}

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			close(rs);
			close(pstmt);
		}

		return result;
	}

	public List<NormalFile> selectNormalFile(Connection conn, int contentNo, String dist) {

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = prop.getProperty("selectNormalFile");
		NormalFile nf = null;
		List<NormalFile> mFile = new ArrayList();

		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, contentNo);
			pstmt.setString(2, dist);

			rs = pstmt.executeQuery();

			while (rs.next()) {
				nf = NormalFile.builder().normalContentNo(rs.getInt("NORMAL_CONTENT_NO"))
						.normalOriFileName(rs.getString("NORMAL_CON_ORI_FILENAME"))
						.normalReFileName(rs.getString("NORMAL_CON_RE_FILENAME")).build();

				mFile.add(nf);
			}
		} catch (SQLException e) {

			e.printStackTrace();
		} finally {
			close(rs);
			close(pstmt);
		}

		return mFile;

	}

	public List<WorkFile> selectWorklFile(Connection conn, int contentNo, String dist) {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = prop.getProperty("selectWorklFile");
		WorkFile wf = null;
		List<WorkFile> wFile = new ArrayList();

		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, contentNo);
			pstmt.setString(2, dist);

			rs = pstmt.executeQuery();

			while (rs.next()) {
				wf = WorkFile.builder().workNo(rs.getInt("WORK_NO"))
						.workOriFileName(rs.getString("WORK_ORI_FILENAME"))
						.workReFileName(rs.getString("WORK_RE_FILENAME"))
						.build();

				wFile.add(wf);
			}
		} catch (SQLException e) {

			e.printStackTrace();
		} finally {
			close(rs);
			close(pstmt);
		}

		return wFile;
	}

	public int deleteNormalContent(Connection conn, int normalContentNo) {
		
		PreparedStatement pstmt = null;
		int result = 0;
		String sql = prop.getProperty("deleteNormalContent");
		
		try {
			pstmt =conn.prepareStatement(sql);
			pstmt.setInt(1, normalContentNo);
			result = pstmt.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			close(pstmt);
		}
		return result;
	}

	public int deleteWorkContent(Connection conn, int workContentNo) {
		PreparedStatement pstmt = null;
		int result = 0;
		String sql = prop.getProperty("deleteWorkContent");
		
		try {
			pstmt =conn.prepareStatement(sql);
			pstmt.setInt(1, workContentNo);
			result = pstmt.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			close(pstmt);
		}
		return result;
	}

	public int deleteScheContent(Connection conn, int scheContentNo) {
		PreparedStatement pstmt = null;
		int result = 0;
		String sql = prop.getProperty("deleteScheContent");
		
		try {
			pstmt =conn.prepareStatement(sql);
			pstmt.setInt(1, scheContentNo);
			result = pstmt.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			close(pstmt);
		}
		return result;
	}

	public int insertNormalReadCount(Connection conn, int contentNo) {
		PreparedStatement pstmt = null;
		int result = 0;
		String sql = prop.getProperty("insertNormalReadCount");
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, contentNo);
			
			result = pstmt.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			close(pstmt);
		}
		return result;
	}

	public int insertWorkReadCount(Connection conn, int contentNo) {
		PreparedStatement pstmt = null;
		int result = 0;
		String sql = prop.getProperty("insertWorkReadCount");
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, contentNo);
			
			result = pstmt.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			close(pstmt);
		}
		return result;
	}

	public int insertScheReadCount(Connection conn, int contentNo) {
		PreparedStatement pstmt = null;
		int result = 0;
		String sql = prop.getProperty("insertScheReadCount");
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, contentNo);
			
			result = pstmt.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			close(pstmt);
		}
		return result;
	}
	
	public List<Project> selectSearchProName(Connection conn,String memId,String searchText){
		//프로젝트 이름 검색하기
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		List<Project> result=new ArrayList<Project>();
		String sql=prop.getProperty("selectSearchProName");
		try {
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1, memId);
			pstmt.setString(2, "%"+searchText+"%");
			rs=pstmt.executeQuery();
			
			while(rs.next()) {
				Project p=Project.builder()
						.projectNo(rs.getInt("PROJECT_NO"))
						.memberId(rs.getString("MEMBER_ID"))
						.proName(rs.getString("PRO_NAME"))
						.proExplain(rs.getString("PRO_EXPLAIN"))
						.proDate(rs.getDate("PRO_DATE"))
						.memberName(rs.getString("MEMBER_NAME"))
						.build();
				result.add(p);
			}
		}catch(SQLException e) {
			e.printStackTrace();
		}finally {
			close(rs);
			close(pstmt);
		}return result;
	}
	public List<Project> selectSearchProMemberName(Connection conn,String memId,String searchText){
		//프로젝트 생성자 검색하기
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		List<Project> result=new ArrayList<Project>();
		String sql=prop.getProperty("selectSearchProMemberName");
		try {
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1, memId);
			pstmt.setString(2, "%"+searchText+"%");
			rs=pstmt.executeQuery();
			
			while(rs.next()) {
				Project p=Project.builder()
						.projectNo(rs.getInt("PROJECT_NO"))
						.memberId(rs.getString("MEMBER_ID"))
						.proName(rs.getString("PRO_NAME"))
						.proExplain(rs.getString("PRO_EXPLAIN"))
						.proDate(rs.getDate("PRO_DATE"))
						.memberName(rs.getString("MEMBER_NAME"))
						.build();
				result.add(p);
			}
		}catch(SQLException e) {
			e.printStackTrace();
		}finally {
			close(rs);
			close(pstmt);
		}return result;
	}
	public List<Project> selectSearchProNumber(Connection conn,String memId,String searchText){
		//프로젝트 번호로 검색하기
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		List<Project> result=new ArrayList<Project>();
		String sql=prop.getProperty("selectSearchProNumber");
		System.out.println(sql);
		try {
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1, memId);
			pstmt.setString(2, "%"+searchText+"%");
			rs=pstmt.executeQuery();
			
			while(rs.next()) {
				Project p=Project.builder()
						.projectNo(rs.getInt("PROJECT_NO"))
						.memberId(rs.getString("MEMBER_ID"))
						.proName(rs.getString("PRO_NAME"))
						.proExplain(rs.getString("PRO_EXPLAIN"))
						.proDate(rs.getDate("PRO_DATE"))
						.memberName(rs.getString("MEMBER_NAME"))
						.build();
				result.add(p);
			}
		}catch(SQLException e) {
			e.printStackTrace();
		}finally {
			close(rs);
			close(pstmt);
		}return result;
	}
}