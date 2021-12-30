package com.help.project.work.model.dao;

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
import java.util.Map;
import java.util.Map.Entry;
import java.util.Properties;

import static com.help.common.JDBCTemplate.*;
import com.help.project.model.vo.Project;
import com.help.project.normal.model.vo.NormalComment;
import com.help.project.work.model.vo.Work;
import com.help.project.work.model.vo.WorkComment;
import com.help.project.work.model.vo.WorkDetailJoin;
import com.help.project.work.model.vo.WorkSelectManagerJoin;

public class WorkDao {
	private Properties prop = new Properties();

	public WorkDao() {
		try {
			prop.load(
					new FileReader(WorkDao.class.getResource("/").getPath() + "sql/project/work/work_sql.properties"));
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}

	}

	public HashMap<Integer, List<Work>> selectWorkFive(Connection conn, List<Project> pro) {
		// 키값: 해당 사원이 참여하고 있는 프로젝트 번호
		// 밸류: 그 프로젝트번호에 해당하는 업무 게시글 list
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		HashMap<Integer, List<Work>> worksAll = new HashMap<Integer, List<Work>>();
		String sql = prop.getProperty("selectWorkFive");
		try {
			pstmt = conn.prepareStatement(sql);
			for (Project p : pro) {
				pstmt.setInt(1, p.getProjectNo());
				rs = pstmt.executeQuery();
				List<Work> works = new ArrayList<Work>();
				while (rs.next()) {
					Work w = Work.builder().workNo(rs.getInt("WORK_NO")).projectNo(rs.getInt("PROJECT_NO"))
							.memberId(rs.getString("MEMBER_ID")).workTitle(rs.getString("WORK_TITLE"))
							.workContent(rs.getString("WORK_CONTENT")).workStartDate(rs.getDate("WORK_START_DATE"))
							.workEndDate(rs.getDate("WORK_END_DATE")).workIng(rs.getString("WORK_ING"))
							.workRank(rs.getString("WORK_RANK")).workReadcount(rs.getInt("WORK_READCOUNT"))
							.workDate(rs.getDate("WORK_DATE")).build();
					works.add(w);
				}
				worksAll.put(p.getProjectNo(), works);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {

			close(rs);
			close(pstmt);
		}
		return worksAll;
	}

	public int insertWorkContent(Connection conn, Work w) {
		// 업무 게시글 작성

		PreparedStatement pstmt = null;
		int result = 0;
		String sql = prop.getProperty("insertWorkContent");

		try {
			pstmt = conn.prepareStatement(sql);

			pstmt.setInt(1, w.getProjectNo());
			pstmt.setString(2, w.getMemberId());
			pstmt.setString(3, w.getWorkTitle());
			pstmt.setString(4, w.getWorkContent());
			pstmt.setDate(5, w.getWorkStartDate());
			pstmt.setDate(6, w.getWorkEndDate());
			pstmt.setString(7, w.getWorkIng());
			pstmt.setString(8, w.getWorkRank());

			result = pstmt.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			close(pstmt);
		}

		return result;
	}

	public int selectWorkNo(Connection conn, Work w) {
		// 업무 게시글 번호 가져오기
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = prop.getProperty("selectWorkNo");
		int workNo = 0;

		try {
			pstmt = conn.prepareStatement(sql);

			pstmt.setInt(1, w.getProjectNo());
			pstmt.setString(2, w.getMemberId());
			pstmt.setString(3, w.getWorkTitle());
			pstmt.setString(4, w.getWorkContent());

			rs = pstmt.executeQuery();

			if (rs.next())
				workNo = rs.getInt("WORK_NO");

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			close(rs);
			close(pstmt);
		}

		return workNo;
	}

	public int insertWorkFile(Connection conn, List<Map<String, Object>> fileList, int workNo) {
		// 업무 파일 등록
		PreparedStatement pstmt = null;
		int result = 0;
		String sql = prop.getProperty("insertWorkFile");

		try {

			for (int i = 0; i < fileList.size(); i++) {
				pstmt = conn.prepareStatement(sql);

				pstmt.setInt(1, workNo);
				pstmt.setString(2, (String) fileList.get(i).get("oriName"));
				pstmt.setString(3, (String) fileList.get(i).get("newFileName"));
				pstmt.setString(4, (String) fileList.get(i).get("exts"));
				pstmt.setString(5, (String) fileList.get(i).get("filePath"));

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

	public int insertWorkManager(Connection conn, List<Map<String, Object>> wmList) {
		// 업무 담당자 등록
		PreparedStatement pstmt = null;
		int result = 0;
		String sql = prop.getProperty("insertWorkManager");

		try {

			for (int i = 0; i < wmList.size(); i++) {
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, (int) wmList.get(i).get("workNo"));
				pstmt.setString(2, (String) wmList.get(i).get("managerId"));
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

	public List<WorkSelectManagerJoin> selectWorkMine(Connection conn, List<Project> pro, String logId) {
		// 내가 담당자인 업무들만
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		// HashMap<Integer, List<Work>> works=new HashMap<Integer, List<Work>>();
		List<WorkSelectManagerJoin> works = new ArrayList<WorkSelectManagerJoin>();
		String sql = prop.getProperty("selectWorkMine");
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, logId);
			for (Project p : pro) {
				pstmt.setInt(2, p.getProjectNo());
				rs = pstmt.executeQuery();
				while (rs.next()) {

					WorkSelectManagerJoin wo = WorkSelectManagerJoin.builder().proName(rs.getString("PRO_NAME"))
							.projectNo(rs.getInt("PROJECT_NO")).workNo(rs.getInt("WORK_NO"))
							.projectNo(rs.getInt("PROJECT_NO")).workIng(rs.getString("WORK_ING"))
							.workRank(rs.getString("WORK_RANK")).workTitle(rs.getString("WORK_TITLE"))
							.memberId(rs.getString("MEMBER_ID")).managerId(rs.getString("MANAGER_ID"))
							.workDate(new SimpleDateFormat("yyyy-MM-dd").format(rs.getDate("WORK_DATE"))).build();
					works.add(wo);
				}
				// works.put(p.getProjectNo(), w);//플젝번호-해당업무들
			}

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			close(rs);
			close(pstmt);
		}
		return works;
	}

	public List<WorkSelectManagerJoin> selectWorkMine(Connection conn, List<Project> pro, String logId, int cPage, int numPerPage) {
		// 내가 담당자인 업무들만 ----페이징
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		// HashMap<Integer, List<Work>> works=new HashMap<Integer, List<Work>>();
		List<WorkSelectManagerJoin> works = new ArrayList<WorkSelectManagerJoin>();
		String sql = prop.getProperty("selectWorkMinePaging");
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, logId);// 로그인한 아이디
			pstmt.setInt(2, (cPage - 1) * numPerPage + 1);
			pstmt.setInt(3, cPage * numPerPage);
			for (Project p : pro) {// 해당하는 프로젝트 번호따라 돌려 돌려
				pstmt.setInt(4, p.getProjectNo());
				rs = pstmt.executeQuery();
				while (rs.next()) {
					WorkSelectManagerJoin wo = WorkSelectManagerJoin.builder().proName(rs.getString("PRO_NAME"))
							.projectNo(rs.getInt("PROJECT_NO")).workNo(rs.getInt("WORK_NO"))
							.projectNo(rs.getInt("PROJECT_NO")).workIng(rs.getString("WORK_ING"))
							.workRank(rs.getString("WORK_RANK")).workTitle(rs.getString("WORK_TITLE"))
							.memberId(rs.getString("MEMBER_ID")).managerId(rs.getString("MANAGER_ID"))
							.workDate(new SimpleDateFormat("yyyy-MM-dd").format(rs.getDate("WORK_DATE"))).build();
					works.add(wo);
				}
				// works.put(p.getProjectNo(), w);//플젝번호-해당업무들
			}

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			close(rs);
			close(pstmt);
		}
		return works;
	}

	// ------------나의 업무 조건 검색
	public List<WorkSelectManagerJoin> searchMine(Connection conn, String ing, String prior, String logId) {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List<WorkSelectManagerJoin> result = new ArrayList<WorkSelectManagerJoin>();
		String sql = "";
		try {

			if (ing.equals("진행상황") && !prior.equals("우선순위")) {// 우선순위 조건
				sql = prop.getProperty("searchWorkPrior").replace("#COL", "W.WORK_RANK");
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, logId);
				pstmt.setString(2, prior);

			} else if (!ing.equals("진행상황") && prior.equals("우선순위")) {// 진행상황조건
				sql = prop.getProperty("searchWorkPrior").replace("#COL", "W.WORK_ING");
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, logId);
				pstmt.setString(2, ing);

			} else if (!ing.equals("진행상황") && !prior.equals("우선순위")) {// 우선순위&&진행상황 조건
				sql = prop.getProperty("searchWorkPriorTwo").replace("#COL", "W.WORK_RANK").replace("#BOL",
						"W.WORK_ING");

				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, logId);
				pstmt.setString(2, prior);
				pstmt.setString(3, ing);
			}
			rs = pstmt.executeQuery();
			while (rs.next()) {
				WorkSelectManagerJoin wo = WorkSelectManagerJoin.builder().proName(rs.getString("PRO_NAME"))
						.projectNo(rs.getInt("PROJECT_NO")).workNo(rs.getInt("WORK_NO"))
						.projectNo(rs.getInt("PROJECT_NO")).workIng(rs.getString("WORK_ING"))
						.workRank(rs.getString("WORK_RANK")).workTitle(rs.getString("WORK_TITLE"))
						.memberId(rs.getString("MEMBER_ID")).managerId(rs.getString("MANAGER_ID"))
						.workDate(new SimpleDateFormat("yyyy-MM-dd").format(rs.getDate("WORK_DATE"))).build();
				result.add(wo);
			}

		} catch (SQLException e) {

		} finally {
			close(rs);
			close(pstmt);
		}
		return result;

	}

	public List<Integer> selectProjectNo(Connection conn, String logId) {
		// 내가 참여한 프로젝트 번호들
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = prop.getProperty("selectProjectNo");
		List<Integer> result = new ArrayList<Integer>();
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, logId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				int num;
				num = rs.getInt("PROJECT_NO");
				result.add(num);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			close(rs);
			close(pstmt);
		}
		return result;
	}

	public List<WorkSelectManagerJoin> selectWorkAll(Connection conn, List<Integer> proNum) {
		// 내가 속한 프로젝트의 모든 업무 게시글들
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = prop.getProperty("selectWorkAll");
		List<WorkSelectManagerJoin> result = new ArrayList<WorkSelectManagerJoin>();
		try {
			pstmt = conn.prepareStatement(sql);
			for (Integer i : proNum) {
				pstmt.setInt(1, i);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					WorkSelectManagerJoin j = WorkSelectManagerJoin.builder().proName(rs.getString("PRO_NAME"))
							.projectNo(rs.getInt("PROJECT_NO")).workNo(rs.getInt("WORK_NO"))
							.workIng(rs.getString("WORK_ING")).workRank(rs.getString("WORK_RANK"))
							.workTitle(rs.getString("WORK_TITLE")).memberId(rs.getString("MEMBER_ID"))
							.workDate(new SimpleDateFormat("yyyy-MM-dd").format(rs.getDate("WORK_DATE"))).build();
					result.add(j);
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

	public List<WorkSelectManagerJoin> selectWorkAll(Connection conn, String id, int cPage, int numPerPage) {
		// 내가 속한 프로젝트의 모든 업무 게시글들---페이징처리
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = prop.getProperty("selectWorkAllPaging");
		List<WorkSelectManagerJoin> result = new ArrayList<WorkSelectManagerJoin>();
		try {
			pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, id);
				pstmt.setInt(2, (cPage - 1) * numPerPage + 1);
				pstmt.setInt(3, cPage * numPerPage);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					WorkSelectManagerJoin j = WorkSelectManagerJoin.builder().proName(rs.getString("PRO_NAME"))
							.projectNo(rs.getInt("PROJECT_NO")).workNo(rs.getInt("WORK_NO"))
							.workIng(rs.getString("WORK_ING")).workRank(rs.getString("WORK_RANK"))
							.workTitle(rs.getString("WORK_TITLE")).memberId(rs.getString("MEMBER_ID"))
							.workDate(new SimpleDateFormat("yyyy-MM-dd").format(rs.getDate("WORK_DATE"))).build();
					result.add(j);
				}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			close(rs);
			close(pstmt);
		}
		return result;
	}

	public List<WorkSelectManagerJoin> searchAll(Connection conn, String ing, String prior, String userId, int cPage, int numPerPage) {
		// 전체업무 --검색기능 //페이징
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List<WorkSelectManagerJoin> result = new ArrayList<WorkSelectManagerJoin>();
		String sql = "";
		try {
			if (ing.equals("진행상황") && !prior.equals("우선순위")) {// 우선순위 조건
				sql = prop.getProperty("searchWorkAllPriorPaging").replace("#COL", "WORK_RANK");
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, userId);// userId
				pstmt.setString(2, prior);
				pstmt.setInt(3, (cPage - 1) * numPerPage + 1);
				pstmt.setInt(4, cPage * numPerPage);

			} else if (!ing.equals("진행상황") && prior.equals("우선순위")) {// 진행상황조건
				sql = prop.getProperty("searchWorkAllPriorPaging").replace("#COL", "WORK_ING");
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, userId);// userId
				pstmt.setString(2, ing);
				pstmt.setInt(3, (cPage - 1) * numPerPage + 1);
				pstmt.setInt(4, cPage * numPerPage);

			} else if (!ing.equals("진행상황") && !prior.equals("우선순위")) {// 우선순위&&진행상황 조건
				sql = prop.getProperty("searchWorkAllPriorTwoPaging").replace("#COL", "WORK_RANK").replace("#BOL", "WORK_ING");

				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, userId);// userId
				pstmt.setString(2, prior);
				pstmt.setString(3, ing);
				pstmt.setInt(4, (cPage - 1) * numPerPage + 1);
				pstmt.setInt(5, cPage * numPerPage);
			}
			rs = pstmt.executeQuery();

			while (rs.next()) {

				WorkSelectManagerJoin wo = WorkSelectManagerJoin.builder().proName(rs.getString("PRO_NAME"))
						.projectNo(rs.getInt("PROJECT_NO")).workNo(rs.getInt("WORK_NO"))
						.projectNo(rs.getInt("PROJECT_NO")).workIng(rs.getString("WORK_ING"))
						.workRank(rs.getString("WORK_RANK")).workTitle(rs.getString("WORK_TITLE"))
						.memberId(rs.getString("MEMBER_ID"))
						.workDate(new SimpleDateFormat("yyyy-MM-dd").format(rs.getDate("WORK_DATE"))).build();
				result.add(wo);
			}

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			close(rs);
			close(pstmt);
		}
		return result;

	}

	public List<WorkSelectManagerJoin> searchAll(Connection conn, String ing, String prior, List<Integer> proNum) {
		// 전체업무 --검색기능
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List<WorkSelectManagerJoin> result = new ArrayList<WorkSelectManagerJoin>();
		String sql = "";
		try {
			for (Integer i : proNum) {

				if (ing.equals("진행상황") && !prior.equals("우선순위")) {// 우선순위 조건
					sql = prop.getProperty("searchWorkAllPrior").replace("#COL", "WORK_RANK");
					pstmt = conn.prepareStatement(sql);
					pstmt.setInt(1, i);// Project_no
					pstmt.setString(2, prior);

				} else if (!ing.equals("진행상황") && prior.equals("우선순위")) {// 진행상황조건
					sql = prop.getProperty("searchWorkAllPrior").replace("#COL", "WORK_ING");
					pstmt = conn.prepareStatement(sql);
					pstmt.setInt(1, i);// project_no
					pstmt.setString(2, ing);

				} else if (!ing.equals("진행상황") && !prior.equals("우선순위")) {// 우선순위&&진행상황 조건
					sql = prop.getProperty("searchWorkAllPriorTwo").replace("#COL", "WORK_RANK").replace("#BOL",
							"WORK_ING");

					pstmt = conn.prepareStatement(sql);
					pstmt.setInt(1, i);
					pstmt.setString(2, prior);
					pstmt.setString(3, ing);
				}
				rs = pstmt.executeQuery();

				while (rs.next()) {

					WorkSelectManagerJoin wo = WorkSelectManagerJoin.builder().proName(rs.getString("PRO_NAME"))
							.projectNo(rs.getInt("PROJECT_NO")).workNo(rs.getInt("WORK_NO"))
							.projectNo(rs.getInt("PROJECT_NO")).workIng(rs.getString("WORK_ING"))
							.workRank(rs.getString("WORK_RANK")).workTitle(rs.getString("WORK_TITLE"))
							.memberId(rs.getString("MEMBER_ID"))
							.workDate(new SimpleDateFormat("yyyy-MM-dd").format(rs.getDate("WORK_DATE"))).build();
					result.add(wo);
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

	// <Work All 각 글 상세화면 >
	public WorkDetailJoin workDetailProject(Connection conn, int ProNo, WorkDetailJoin temp) {
		// 1) 프로젝트 제목
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = prop.getProperty("workDetailProject");
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, ProNo);// 프로젝트 번호
			rs = pstmt.executeQuery();
			if (rs.next()) {
				temp = WorkDetailJoin.builder().proName(rs.getString("PRO_NAME"))
						.proDate(new SimpleDateFormat("yyyy-MM-dd").format(rs.getDate("PRO_DATE"))).build();
				// 프로젝트 이름, 프로젝트 생성 시간
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			close(rs);
			close(pstmt);
		}
		return temp;
	}

	public WorkDetailJoin workDetailWork(Connection conn, int workNo, WorkDetailJoin temp) {
		// 2) 업무 번호 --> 업무 정보 : 업무 제목/내용/시작일/마감일/진행상태/우선순위
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = prop.getProperty("workDetailWork");
		WorkDetailJoin temp1 = null;
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, workNo);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				temp1 = WorkDetailJoin.builder().workNo(rs.getInt("WORK_NO")).workTitle(rs.getString("WORK_TITLE"))
						.workContent(rs.getString("WORK_CONTENT"))
						.startDate(new SimpleDateFormat("yyyy-MM-dd").format(rs.getDate("WORK_START_DATE")))
						.endDate(new SimpleDateFormat("yyyy-MM-dd").format(rs.getDate("WORK_END_DATE")))
						.workIng(rs.getString("WORK_ING")).workRank(rs.getString("WORK_RANK"))
						.proName(temp.getProName()).proDate(temp.getProDate()).build();
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			close(rs);
			close(pstmt);
		}
		return temp1;
	}

	public WorkDetailJoin workDetailWriter(Connection conn, int WorkNo, WorkDetailJoin temp) {
		// 3) 업무 작성자 : 업무 작성자 id를 이름으로 가져오기
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = prop.getProperty("workDetailWriter");
		WorkDetailJoin temp1 = null;
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, WorkNo);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				temp1 = WorkDetailJoin.builder().workNo(temp.getWorkNo()).workName(rs.getString("MEMBER_NAME"))
						.workTitle(temp.getWorkTitle()).workContent(temp.getWorkContent())
						.startDate(temp.getStartDate()).endDate(temp.getEndDate()).workIng(temp.getWorkIng())
						.workRank(temp.getWorkRank()).proName(temp.getProName()).proDate(temp.getProDate()).build();
				// 아이디 이름으로 변환
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			close(rs);
			close(pstmt);
		}
		return temp1;
	}

	public WorkDetailJoin workDetailManager(Connection conn, int workNo, WorkDetailJoin temp) {
		// 4) 업무 담당자 : 여러명임
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = prop.getProperty("workDetailManager");
		List<String> manager = new ArrayList<String>();
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, workNo);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				String ma = rs.getString("MEMBER_NAME");
				manager.add(ma);
			}
			temp.setWorkManager(manager);// 담당자들 리스트형식으로 추가
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			close(rs);
			close(pstmt);
		}
		return temp;
	}

	public int updateWorkContent(Connection conn, Work w, int contentNo) {
		PreparedStatement pstmt = null;
		int result = 0;
		String sql = prop.getProperty("updateWorkContent");
		
		try {
			pstmt =conn.prepareStatement(sql);
			pstmt.setString(1, w.getWorkTitle());
			pstmt.setString(2, w.getWorkContent());
			pstmt.setDate(3, w.getWorkStartDate());
			pstmt.setDate(4, w.getWorkEndDate());
			pstmt.setString(5, w.getWorkIng());
			pstmt.setString(6, w.getWorkRank());
			pstmt.setInt(7, contentNo);
			
			result = pstmt.executeUpdate();
			
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			close(pstmt);
		}
		
		
		return result;
	}

	public int insertWorkComment(Connection conn, WorkComment wc) {

		PreparedStatement pstmt = null;
		int result = 0;
		String sql = prop.getProperty("insertWorkComment");
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, wc.getWorkNo());
			pstmt.setString(2, wc.getWriterId());
			pstmt.setString(3,wc.getWorkCommentContent());
			
			result = pstmt.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			close(pstmt);
		}
		return result;
	}

	public List<WorkComment> selectWorkComment(Connection conn, int contentNo) {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = prop.getProperty("selectWorkComment");
		WorkComment wc = null;
		List<WorkComment> wcList = new ArrayList<WorkComment>();
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, contentNo);
			
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				wc = WorkComment.builder()
						.workNo(rs.getInt("WORK_NO"))
						.workCommentNo(rs.getInt("WORK_COMMENT_NO"))
						.writerId(rs.getString("MEMBER_ID"))
						.writerName(rs.getString("MEMBER_NAME"))
						.workCommentContent(rs.getString("WORK_COMMENT_CONTENT"))
						.commentDate(new SimpleDateFormat("yyyy-MM-dd").format(rs.getDate("WORK_COMMENT_DATE")))
						.build();
				wcList.add(wc);
			}
			
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			close(rs);
			close(pstmt);
		}
		
		return wcList;
	}

	public int deleteWorkComment(Connection conn, int contentNo) {
		PreparedStatement pstmt = null;
		int result = 0;
		String sql = prop.getProperty("deleteWorkComment");
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, contentNo);
			result = pstmt.executeUpdate();
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			close(pstmt);
		}
		
		return result;
	}
}
