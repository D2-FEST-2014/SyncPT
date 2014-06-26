package SyncPT.Model;




import java.io.File;
import java.io.IOException;
import java.nio.ByteBuffer;
import java.nio.CharBuffer;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.catalina.websocket.MessageInbound;
import org.apache.catalina.websocket.StreamInbound;
import org.apache.catalina.websocket.WsOutbound;
import org.json.simple.JSONArray;


public class UserStream extends MessageInbound{
	private ConcurrentHashMap<String, StreamInbound> clients;
	private HttpSession ssion;
	private String name;
	private DBofSyncPT db = new DBofSyncPT();
	private String access_code="";
	private String u_id="";	
	private boolean slide_show = false; // 슬라이드쇼 진행상태 
	private String host_session=""; // 방장 웹소켓 세션 
	private ArrayList<File_Entity> files = new ArrayList<File_Entity>(); // 파일 객체 ArrayList
	private String filename_now = ""; // 현재 보고있는 ppt
	private int slide_max = 0; // 현재 보고있는 ppt 슬라이드 수

	private WsOutbound myoutbound;

	public UserStream(HttpServletRequest httpSerbletRequest) {
	}
	public UserStream(HttpServletRequest httpSerbletRequest, ConcurrentHashMap<String, StreamInbound> clients) {
		this.ssion = httpSerbletRequest.getSession();
		
		this.clients = clients;
	}
	@Override
	public void onOpen(WsOutbound outbound) {
		System.out.println("on open.."); 
		this.myoutbound = outbound;	
	}

	@Override
	public void onClose(int status) {		
		
		// 우선 방을 개설한 방장인지 아닌지 여부부터 판단.
		if(host_session.equals(ssion.getId())) { // 방장
			db.del_Access_All(access_code); // 엑세스 코드로 접속해 있는 모든 유저의 정보 지우기
			db.del_Files(access_code); // 파일 정보 삭제
			db.del_Room(access_code); // 방 정보 삭제하기
			db.del_User(u_id);
			
		    String uploadPath = ssion.getServletContext().getRealPath("uploadStorage") + "\\" + access_code; 		    		
		    		    
			File tempDir = new File(uploadPath);
			String[] list = tempDir.list();
			
			if(list!=null) {
				for(int i=0; i<list.length; i++) {
					File f = new File(tempDir,list[i]);
					f.delete(); 
				}
			}
			
			tempDir.delete();	
		}
		
		// 참여자가 나가는 경우
		else { 
			db.del_Access(u_id);
			db.del_User(u_id);
			
			//remove from list		
			clients.remove(ssion.getId());
			update_userlist(access_code);	
		}	
	}

	@Override
	protected void onBinaryMessage(ByteBuffer arg0) throws IOException {
		System.out.println("onbinary");
	}
	
	@Override
	protected void onTextMessage(CharBuffer inChar) throws IOException {
				
		System.out.println("메세지 들어옴");
		
		String message = inChar.toString();
		String[] m = message.split(",");			
		
		// 회의방 입장
		if(m[0].equals("enter")) {			
			// 웹 소켓 세션 id DB에 설정.
			
			if(db.Update_SessionAuth(m[2], ssion.getId())) {
				access_code = m[1]; // 엑세스 코드
				u_id=m[2]; // 접속자 id
				host_session = db.check_Host(access_code); // 방장 웹소켓 세션	
				files = db.get_FileInfo(access_code); // 파일 정보 가져오기
				filename_now = files.get(0).getFile_name(); // 첫번째 파일의 이름을 default 값으로 설정
				slide_max = files.get(0).getSlide_count(); // 첫번째 ppt 파일의 슬라이드 수
			}			
			// 방 접속자  갱신 및 리스트 전달하기.
			update_userlist(access_code);
		}
		
		// ppt파일 선택 
		else if(m[0].equals("select_ppt")) {
			int i = Integer.parseInt(m[1]);
			filename_now = files.get(i).getFile_name();
			slide_max = files.get(i).getSlide_count();
			
			CharBuffer msg = CharBuffer.wrap("change," + filename_now + "," + slide_max);			
			this.myoutbound.writeTextMessage(msg);
			this.myoutbound.flush();			
		}
		
		else if(m[0].equals("chat")) {
			chat_send(access_code,m[1]);
		}
		
		else if(m[0].equals("pre")) {
			int slide_index = Integer.parseInt(m[1]); 
			if(slide_index>1) {
				slide_index = slide_index - 1;
			}
			else {
				slide_index = 1;
			}
			
			if(slide_show) {
				go_slide(slide_index,access_code);
			}
			else {
				CharBuffer msg = CharBuffer.wrap("page_control," + Integer.toString(slide_index));
				this.myoutbound.writeTextMessage(msg);
				this.myoutbound.flush();
			}
		}
		
		else if(m[0].equals("next")) {	
			int slide_index = Integer.parseInt(m[1]); 
			System.out.println("index : " + slide_index);
			if(slide_index<slide_max) {
				slide_index = slide_index + 1;
			}
			else {
				slide_index = slide_max;
			}
			if(slide_show) {
				go_slide(slide_index,access_code);	
			}
			else {
				System.out.println("index2 : " + slide_index);
				CharBuffer msg = CharBuffer.wrap("page_control,"+Integer.toString(slide_index));
				this.myoutbound.writeTextMessage(msg);
				this.myoutbound.flush();
			}
		}	
		
		// 슬라이도쇼 시작
		else if(m[0].equals("show")) {
			slide_show = true; // 슬라이도쇼 진행 상태값 변경
			start_Slideshow();
		}
		
		// 슬라이드쇼 중지
		else if(m[0].equals("stop")) {
			slide_show = false;  // 슬라이도쇼 진행 상태값 변경
			stop_Slideshow(access_code);
		}
		
		else if(m[0].equals("check") || m[0].equals("star") || m[0].equals("eraser")) {
			System.out.println("확인입니다." + m[0] + "," + m[1] + "," + m[2]);
			String t = m[0];
			String y = m[1];
			String x = m[2];
			draw_pointer(t,y,x,access_code);
		}
	}
	@Override
	public int getReadTimeout() {
		// TODO Auto-generated method stub
		return 0;
	}
	
	public synchronized boolean draw_pointer(String t, String y, String x, String access_code) {   
		boolean result = false;
		ArrayList<String> list = db.get_Wsession(access_code); // 현재 회의방에 접속한 사람들의 웹 소켓 세션 id(해쉬맵의 key값)을 확인
		
		for(int i=0; i<list.size(); i++) {					

			CharBuffer msg = CharBuffer.wrap(t+","+x+","+y);
			WsOutbound other = clients.get(list.get(i)).getWsOutbound();
			
			try {
				other.writeTextMessage(msg);					
				other.flush();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}	
		return result;
	} 
	
	
	public synchronized boolean go_slide(int index, String access_code) {   
		boolean result = false;
		ArrayList<String> list = db.get_Wsession(access_code); // 현재 회의방에 접속한 사람들의 웹 소켓 세션 id(해쉬맵의 key값)을 확인
		
		for(int i=0; i<list.size(); i++) {					

			CharBuffer msg = CharBuffer.wrap("page_control,"+Integer.toString(index));
			WsOutbound other = clients.get(list.get(i)).getWsOutbound();
			
			try {
				other.writeTextMessage(msg);					
				other.flush();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}	
		return result;
	} 
	
	// 슬라이드 쇼 시작을 위한 메소드 
	public synchronized boolean start_Slideshow() {   
		boolean result = false;
		ArrayList<String> list = db.get_Wsession(access_code); // 현재 회의방에 접속한 사람들의 웹 소켓 세션 id(해쉬맵의 key값)을 확인	
		
		for(int i=0; i<list.size(); i++) {	
			
			// 방장
			if(list.get(i).equals(ssion.getId())) {
				CharBuffer msg = CharBuffer.wrap("show_start,"+ filename_now + "," + slide_max + ",host");			
				WsOutbound other = clients.get(list.get(i)).getWsOutbound();
				
				try {
					other.writeTextMessage(msg);					
					other.flush();
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
			// 참여자
			else {
				CharBuffer msg = CharBuffer.wrap("show_start,"+ filename_now + "," + slide_max +",guest");			
				WsOutbound other = clients.get(list.get(i)).getWsOutbound();
				
				try {
					other.writeTextMessage(msg);					
					other.flush();
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}

		}	
		return result;
	} 
	
	// 슬라이드 쇼 종료을 위한 메소드 
	public synchronized boolean stop_Slideshow(String access_code) {   
		boolean result = false;
		ArrayList<String> list = db.get_Wsession(access_code); // 현재 회의방에 접속한 사람들의 웹 소켓 세션 id(해쉬맵의 key값)을 확인	
		
		for(int i=0; i<list.size(); i++) {	
			
			CharBuffer msg = CharBuffer.wrap("show_stop,");			
			WsOutbound other = clients.get(list.get(i)).getWsOutbound();
			
			try {
				other.writeTextMessage(msg);					
				other.flush();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}	
		return result;
	} 
	
	public synchronized boolean update_userlist(String access_code) {   
		boolean result = false;
		ArrayList<User_Entity> list = db.get_User(access_code);	
		
		String u_list = "";
		
		for(int j=0; j<list.size(); j++) {
			if(list.get(j).getW_sess().equals(ssion.getId())) {
				name = list.get(j).getName();
			}
			
			// 방장
			if(list.get(j).getW_sess().equals(host_session)) {
				u_list = u_list + "," + list.get(j).getName() + "H";				
			}
			else {
				u_list = u_list + "," + list.get(j).getName() + "G";
			}			
		}	
		
		for(int i=0; i<list.size(); i++) {	
									
			CharBuffer msg = CharBuffer.wrap("enter"+ u_list);			
			WsOutbound other = clients.get(list.get(i).getW_sess()).getWsOutbound();
						
			try {
				other.writeTextMessage(msg);					
				other.flush();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}			
		}	
		return result;
	} 
	
	public synchronized boolean chat_send(String access_code,String m) {   
		boolean result = false;
		ArrayList<User_Entity> list = db.get_User(access_code);	
				
		for(int i=0; i<list.size(); i++) {			
			
			CharBuffer msg = CharBuffer.wrap("chat," + name + " : " + m);			
			WsOutbound other = clients.get(list.get(i).getW_sess()).getWsOutbound();
			
			try {
				other.writeTextMessage(msg);					
				other.flush();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}	
		return result;
	} 
	
	public synchronized boolean change_PPT(String access_code, int index) {   
		boolean result = false;
		ArrayList<User_Entity> list = db.get_User(access_code);	
				
		for(int i=0; i<list.size(); i++) {			
			
			CharBuffer msg = CharBuffer.wrap("change," + files.get(index).getFile_name() + "," + files.get(index).getSlide_count());			
			WsOutbound other = clients.get(list.get(i).getW_sess()).getWsOutbound();
			
			try {
				System.out.println("메시지 : " + msg);
				other.writeTextMessage(msg);					
				other.flush();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}	
		return result;
	} 
}