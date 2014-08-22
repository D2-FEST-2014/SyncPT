package SyncPT.Model;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import javax.naming.InitialContext;
import javax.sql.DataSource;



public class DBofSyncPT {
	private Connection con = null;
	private PreparedStatement pstmt = null;
	private DataSource ds = null;

	public DBofSyncPT() {
		try {
			InitialContext ctx = new InitialContext();
			ds = (DataSource) ctx.lookup("java:comp/env/jdbc/mysql");
		} catch(Exception e) {
			e.printStackTrace();
		}
	}
	void connect() {
		try {
			con = ds.getConnection();
		} catch(Exception e) {
			e.printStackTrace();
		}
	}

	void disconnect() {
		if(pstmt!=null) {
			try {
				pstmt.close();
			} catch(SQLException e) {
				e.printStackTrace();
			}
		}
		if(con!=null) {
			try {
				con.close();
			} catch(SQLException e) {
				e.printStackTrace();
			}         
		}
	}

	// 로그인
	public synchronized String loginAuth(String name) {   
		connect();
		String u_id = null;

		Random_Key r = new Random_Key();
		String id = r.asciiout(10);

		String SQL = "INSERT INTO user_list(u_id, u_name) VALUES(?,?)";
		try {
			pstmt = con.prepareStatement(SQL);
			pstmt.setString(1, id);
			pstmt.setString(2, name);
			int i = pstmt.executeUpdate();   
			if(i==1){
				u_id = id;
			}                  
		} catch (SQLException e) {
			e.printStackTrace();         
		} 
		finally {
			disconnect();
		}
		return u_id;
	}  

	// 사용자 정보 삭제
	public synchronized boolean del_User(String u_id) {   
		connect();
		boolean result = false; 

		String SQL = "DELETE FROM user_list WHERE u_id = ?";
		try {
			pstmt = con.prepareStatement(SQL);
			pstmt.setString(1, u_id);
			int i = pstmt.executeUpdate();   
			if(i==1){
				result = true;
			}                  
		} catch (SQLException e) {
			e.printStackTrace();         
		} 
		finally {
			disconnect();
		}
		return result;
	} 

	// 방 정보 삭제
	public synchronized boolean del_Files(String access_code) {   
		connect();
		boolean result = false; 

		String SQL = "DELETE FROM file_list WHERE access_code = ?";
		try {
			pstmt = con.prepareStatement(SQL);
			pstmt.setString(1, access_code);
			int i = pstmt.executeUpdate();   
			if(i==1){
				result = true;
			}                  
		} catch (SQLException e) {
			e.printStackTrace();         
		} 
		finally {
			disconnect();
		}
		return result;
	} 

	// 방 정보 삭제
	public synchronized boolean del_Room(String access_code) {   
		connect();
		boolean result = false; 

		String SQL = "DELETE FROM room_list WHERE access_code = ?";
		try {
			pstmt = con.prepareStatement(SQL);
			pstmt.setString(1, access_code);
			int i = pstmt.executeUpdate();   
			if(i==1){
				result = true;
			}                  
		} catch (SQLException e) {
			e.printStackTrace();         
		} 
		finally {
			disconnect();
		}
		return result;
	} 

	// 접속 정보 삭제
	public synchronized boolean del_Access(String u_id) {   
		connect();
		boolean result = false; 

		String SQL = "DELETE FROM access_list WHERE u_id = ?";
		try {
			pstmt = con.prepareStatement(SQL);
			pstmt.setString(1, u_id);
			int i = pstmt.executeUpdate();   
			if(i==1){
				result = true;
			}                  
		} catch (SQLException e) {
			e.printStackTrace();         
		} 
		finally {
			disconnect();
		}
		return result;
	}

	// 접속 정보 삭제(모두 - 방장 나가기)
	public synchronized boolean del_Access_All(String access_code) {   
		connect();
		boolean result = false; 

		String SQL = "DELETE FROM access_list WHERE access_code = ?";
		try {
			pstmt = con.prepareStatement(SQL);
			pstmt.setString(1, access_code);
			int i = pstmt.executeUpdate();   
			if(i==1){
				result = true;
			}                  
		} catch (SQLException e) {
			e.printStackTrace();         
		} 
		finally {
			disconnect();
		}
		return result;
	} 


	// 회의방 생성(단, 개설자가 최종적으로 방에 입장하기 전까지는 host_id가 default 값)
	public synchronized boolean create_Room(String access_code) {   
		connect();
		boolean result=false;

		//Random_Key r = new Random_Key();
		//String id = r.asciiout(10);

		String SQL = "INSERT INTO room_list(access_code) VALUES(?)";
		try {
			pstmt = con.prepareStatement(SQL);
			pstmt.setString(1, access_code);
			int i = pstmt.executeUpdate();
			if(i==1){
				result = true;
			}                  
		} catch (SQLException e) {
			e.printStackTrace();         
		} 
		finally {
			disconnect();
		}
		return result;
	}

	// 업로드 파일 정보 관리 
	public synchronized boolean upload_file(String access_code, String filename, int slide_count) {   
		connect();
		boolean result=false;

		String SQL = "INSERT INTO file_list(access_code,file_name,slide_count) VALUES(?,?,?)";
		try {
			pstmt = con.prepareStatement(SQL);
			pstmt.setString(1, access_code);
			pstmt.setString(2, filename);
			pstmt.setInt(3, slide_count);
			int i = pstmt.executeUpdate();   
			if(i==1){
				result = true;
			}                  
		} catch (SQLException e) {
			e.printStackTrace();         
		} 
		finally {
			disconnect();
		}
		return result;
	} 
	
	// 방정보 업데이트
	public synchronized boolean Update_room(String u_id, String room_name, String access_code, String media_type) {   
		connect();
		boolean result = false; 
		String SQL = "UPDATE room_list SET host_id = ?, room_name = ?, media_type=? WHERE access_code = ?";
		System.out.println(room_name);
		try {
			pstmt = con.prepareStatement(SQL);
			pstmt.setString(1, u_id);
			pstmt.setString(2, room_name);	
			pstmt.setInt(3, Integer.parseInt(media_type));
			pstmt.setString(4, access_code);
			int i = pstmt.executeUpdate();   
			if(i==1){
				result = true;
			}                  
		} catch (SQLException e) {
			e.printStackTrace();         
		} 
		finally {
			disconnect();
		}
		return result;
	}  
	
	// 공개방 상태 업데이트
	public synchronized boolean Update_isopen(String access_code) {   
		connect();
		boolean result = false; 
		String SQL = "UPDATE room_list SET isopen = 1 WHERE access_code = ?";
		try {
			pstmt = con.prepareStatement(SQL);
			pstmt.setString(1, access_code);
			int i = pstmt.executeUpdate();   
			if(i==1){
				result = true;
			}                  
		} catch (SQLException e) {
			e.printStackTrace();         
		} 
		finally {
			disconnect();
		}
		return result;
	} 
	
	// 방 접속 정보 관리
	public synchronized boolean insert_Access(String access_code, String u_id) {   
		connect();
		boolean result=false;                

		String SQL = "INSERT INTO access_list VALUES(?,?,?)";
		try {
			pstmt = con.prepareStatement(SQL);
			pstmt.setString(1, u_id+access_code);
			pstmt.setString(2, u_id);
			pstmt.setString(3, access_code);
			int i = pstmt.executeUpdate();   
			if(i==1){
				result = true;
			}                  
		} catch (SQLException e) {
			e.printStackTrace();         
		} 
		finally {
			disconnect();
		}
		return result;
	} 

	// 엑세스 폴더에 저장된 파일 정보 가져오기
	public synchronized ArrayList<File_Entity> get_FileInfo(String access_code) {   
		connect();
		ArrayList<File_Entity> result = new ArrayList<File_Entity>();         

		String SQL = "SELECT file_name, slide_count FROM file_list WHERE access_code = ?";
		try {
			pstmt = con.prepareStatement(SQL);
			pstmt.setString(1, access_code);
			ResultSet rs = pstmt.executeQuery();   
			while(rs.next()) {
				File_Entity f = new File_Entity();
				f.setFile_name(rs.getString(1));
				f.setSlide_count(rs.getInt(2));
				result.add(f);
			}                  
		} catch (SQLException e) {
			e.printStackTrace();         
		} 
		finally {
			disconnect();
		}
		return result;
	} 

	// 슬라이드 장수 가져오기
	public synchronized int get_SlideNum(String access_code, String filename) {   
		connect();
		int result=0;           

		String SQL = "SELECT slide_count FROM file_list WHERE access_code = ? and file_name = ?";
		try {
			pstmt = con.prepareStatement(SQL);
			pstmt.setString(1, access_code);
			pstmt.setString(2, filename);
			ResultSet rs = pstmt.executeQuery();   
			if(rs.next()) {
				result = rs.getInt(1);
			}                  
		} catch (SQLException e) {
			e.printStackTrace();         
		} 
		finally {
			disconnect();
		}
		return result;
	}  

	public synchronized ArrayList<User_Entity> get_User(String access_code) {
		connect();
		ArrayList<User_Entity> result = new ArrayList<User_Entity>();

		String SQL = "SELECT u.u_id, u.u_name FROM user_list AS u INNER JOIN access_list AS a ON u.u_id = a.u_id WHERE a.access_code = ?";
		try {
			pstmt = con.prepareStatement(SQL);
			pstmt.setString(1, access_code);
			ResultSet rs = pstmt.executeQuery();
			System.out.println("ㅁ니아만아민아ㅣㅇㄴ마ㅣㅇ나ㅣㅇㄴ마ㅣㅁㅇㄴ");
			while(rs.next()) {
				User_Entity u = new User_Entity();
				u.setU_id(rs.getString(1));
				u.setName(rs.getString(2));
				result.add(u);
				
				System.out.println(u.getU_id() + " : " + u.getName());
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} 
		finally {
			disconnect();
		}
		return result;
	}

	// 방장 u_id 가져오기
	public synchronized String get_Host(String access_code) {   
		connect();
		String result="";           

		String SQL = "SELECT host_id FROM room_list WHERE access_code = ?";
		try {
			pstmt = con.prepareStatement(SQL);
			pstmt.setString(1, access_code);
			ResultSet rs = pstmt.executeQuery();   
			if(rs.next()) {
				result = rs.getString(1);
			}                  
		} catch (SQLException e) {
			e.printStackTrace();         
		} 
		finally {
			disconnect();
		}
		return result;
	}    

	// rtcMax설정
	public synchronized boolean setRtcMax(String roomid, int rtcMax, int isOpen) {
		connect();
		boolean result = false;

		String SQL;
		if (isOpen == 0) {
			SQL = "UPDATE room_list SET rtc_max=?, rtc_now=1 WHERE access_code=?";
		} else {
			SQL = "UPDATE room_list SET rtc_max=?, rtc_now=1, isopen=1 WHERE access_code=?";
		}
		try {
			pstmt = con.prepareStatement(SQL);
			pstmt.setInt(1, rtcMax);
			pstmt.setString(2, roomid);
			int i = pstmt.executeUpdate();
			if(i==1){
				result = true;
			} 
		} catch (SQLException e) {
			e.printStackTrace();
		}
		finally {
			disconnect();
		}
		return result;
	}

	// rtcNow값 UP (접속자 JOIN Handle)
	public synchronized int upRtcNow(String roomid) {
		connect();
		/*
		 *  0 -> 실패
		 *  1 -> 나 = 성공, 다른사람 = 불가능
		 *  2 -> 나 = 성공, 다른사람 = 가능
		 */
		int result = 0;
		String SQL = "";
		int rtc_now, rtc_max;

		try {
			SQL = "SELECT rtc_now, rtc_max FROM room_list WHERE access_code=?";
			pstmt = con.prepareStatement(SQL);
			pstmt.setString(1, roomid);
			ResultSet rs = pstmt.executeQuery();   
			if(rs.next()) {
				rtc_now = rs.getInt("rtc_now");
				rtc_max = rs.getInt("rtc_max");
				System.out.println(rtc_now + " : " + rtc_max);

				if (rtc_now < rtc_max) {
					SQL = "UPDATE room_list SET rtc_now=? WHERE access_code=?";
					pstmt = con.prepareStatement(SQL);
					pstmt.setInt(1, rtc_now + 1);
					pstmt.setString(2, roomid);
					int i = pstmt.executeUpdate();
					if(i==1) {
						result++;
						if (rtc_now + 1 < rtc_max) {
							result++;
						}
					}
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		finally {
			disconnect();
		}
		return result;
	}
	
	// 공개방 리스트 
	public synchronized ArrayList<Room_Entity> get_Openrooms() {
		connect();
		ArrayList<Room_Entity> result = new ArrayList<Room_Entity>();

		String SQL = "SELECT r.access_code, r.room_name, r.media_type, "
				+ "(SELECT u.u_name FROM user_list AS u WHERE u.u_id=r.host_id) AS hostname, "
				+ "(SELECT f.file_name FROM file_list AS f WHERE f.access_code=r.access_code) AS filename "
				+ "FROM room_list AS r WHERE r.isopen=1";
		try {
			pstmt = con.prepareStatement(SQL);			
			ResultSet rs = pstmt.executeQuery();
			while(rs.next()) {
				Room_Entity room = new Room_Entity();
				room.setAccess_code(rs.getString("access_code"));
				room.setRoom_name(rs.getString("room_name"));
				room.setHost_name(rs.getString("hostname"));
				room.setFile_name(rs.getString("filename"));
				room.setMedia_type(rs.getInt("media_type"));
				result.add(room);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} 
		finally {
			disconnect();
		}
		return result;
	}
	
	// rtcNow값 DOWN (접속자 LEAVE Handle)
	public synchronized boolean downRtcNow(String roomid) {
		connect();
		boolean result = false;
		String SQL = "";
		int rtc_now;

		try {
			SQL = "SELECT rtc_now FROM room_list WHERE access_code=?";
			pstmt = con.prepareStatement(SQL);
			pstmt.setString(1, roomid);
			ResultSet rs = pstmt.executeQuery();   
			if(rs.next()) {
				rtc_now = rs.getInt("rtc_now");

				if (rtc_now > 0) {
					SQL = "UPDATE room_list SET rtc_now=? WHERE access_code=?";
					pstmt = con.prepareStatement(SQL);
					pstmt.setInt(1, rtc_now - 1);
					pstmt.setString(2, roomid);
					int i = pstmt.executeUpdate();
					if(i==1) {
						result = true;
					}
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		finally {
			disconnect();
		}
		return result;
	}
	
	// 회의방에서 참여자 정보 삭제
	public synchronized boolean leave_room(String u_id) {
		connect();
		boolean result = false;
		String SQL = "DELETE FROM access_list WHERE u_id = ?";
		
		try {
			pstmt = con.prepareStatement(SQL);
			pstmt.setString(1, u_id);
			int i = pstmt.executeUpdate();   
			if(i==1){
				result = true;
			}                  
		} catch (SQLException e) {
			e.printStackTrace();         
		} 
		finally {
			disconnect();
		}
		return result;
	}
}