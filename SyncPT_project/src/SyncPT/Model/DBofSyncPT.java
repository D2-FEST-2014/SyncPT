package SyncPT.Model;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import javax.naming.InitialContext;
import javax.servlet.http.HttpSession;
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
	public synchronized String loginAuth(String name, String jsess) {   
	      connect();
	      String u_id = null;
	      
	      Random_Key r = new Random_Key();
	      String id = r.asciiout(10);
	      
	      String SQL = "INSERT INTO user_list(u_id,u_name,jsession_id) VALUES(?,?,?)";
	      try {
	         pstmt = con.prepareStatement(SQL);
	         pstmt.setString(1, id);
	         pstmt.setString(2, name);
	         pstmt.setString(3, jsess);
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
	
	// 웹 소켓 session id 저장
	public synchronized boolean Update_SessionAuth(String u_id, String session_id) {   
	      connect();
	      boolean result = false; 
	      
	      String SQL = "UPDATE user_list SET wsession_id = ? WHERE u_id = ?";
	      try {
	         pstmt = con.prepareStatement(SQL);
	         pstmt.setString(1, session_id);
	         pstmt.setString(2, u_id);
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
	      
	      Random_Key r = new Random_Key();
	      String id = r.asciiout(10);
	      
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
	
	
	// 방정 정보
	public synchronized boolean Update_host(String u_id, String access_code) {   
	      connect();
	      boolean result = false; 
	      
	      String SQL = "UPDATE room_list SET host_id = ? WHERE access_code = ?";
	      try {
	         pstmt = con.prepareStatement(SQL);
	         pstmt.setString(1, u_id);
	         pstmt.setString(2, access_code);
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
	
    // 슬라이드 장수 가져오기
	public synchronized int get_SlideNum(String access_code) {   
	      connect();
	      int result=0;   	     
	      
	      String SQL = "SELECT slide_num FROM room_list WHERE access_code = ?";
	      try {
	         pstmt = con.prepareStatement(SQL);
	         pstmt.setString(1, access_code);
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
		
	// 웹 소켓 세션 아이디 가져오기(그룹방)
	public synchronized ArrayList<String> get_Wsession(String access_code) {   
	      connect();
	      ArrayList<String> result = new ArrayList<String>(); 	     
	      
	      String SQL = "SELECT u.wsession_id FROM user_list AS u INNER JOIN access_list AS a ON u.u_id = a.u_id WHERE a.access_code = ?";
	      try {
	         pstmt = con.prepareStatement(SQL);
	         pstmt.setString(1, access_code);
	         ResultSet rs = pstmt.executeQuery();   
	         while(rs.next()) {
	        	 String s = rs.getString(1);
	        	 result.add(s);
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
		
	      String SQL = "SELECT u.u_name, u.wsession_id FROM user_list AS u INNER JOIN access_list AS a ON u.u_id = a.u_id WHERE a.access_code = ?";
	      try {
	         pstmt = con.prepareStatement(SQL);
	         pstmt.setString(1, access_code);
	         ResultSet rs = pstmt.executeQuery();   
	         while(rs.next()) {
	        	 User_Entity u = new User_Entity();
	        	 u.setName(rs.getString(1));
	        	 u.setW_sess(rs.getString(2));
	        	 result.add(u);
	         }	               
	      } catch (SQLException e) {
	         e.printStackTrace();         
	      } 
	      finally {
	         disconnect();
	      }
	      return result;
	}
	
	// 방장 웹소켓 세션 id 가져오기
	public synchronized String check_Host(String access_code) {   
	      connect();
	      String result="";   	     
	      
	      String SQL = "SELECT u.wsession_id FROM room_list AS r INNER JOIN user_list AS u ON u.u_id = r.host_id WHERE access_code = ?";
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
	
	// 방 접속 확인
	public synchronized boolean check_accessuser(String access_code, String wsession_id) {   
	      connect();
	      boolean result=false;   	     
	      
	      String SQL = "SELECT u.u_id FROM user_list AS u INNER JOIN access_list AS a ON u.u_id = a.u_id WHERE u.wsession_id = ? AND a.access_code = ?";
	      try {
	         pstmt = con.prepareStatement(SQL);
	         pstmt.setString(1, wsession_id);
	         pstmt.setString(2, access_code);
	         ResultSet rs = pstmt.executeQuery();   
	         if(rs.next()) {
	        	 result=true;
	         }	               
	      } catch (SQLException e) {
	         e.printStackTrace();         
	      } 
	      finally {
	         disconnect();
	      }
	      return result;
	} 
	
	/*
	public String check_jsession(String session) {
	      connect();
	      String result=null;  
	      
	      String SQL = "SELECT u_id FROM user_list WHERE jsession_id = ?";
	      try {
	         pstmt = con.prepareStatement(SQL);
	         pstmt.setString(1, session);
	         ResultSet rs = pstmt.executeQuery();   
	         if(rs.next()) {
	        	 result=rs.getString(1);
	         }	               
	      } catch (SQLException e) {
	         e.printStackTrace();         
	      } 
	      finally {
	         disconnect();
	      }
	      return result;
	}*/
}