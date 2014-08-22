package SyncPT.Controller;

import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import SyncPT.Model.DBofSyncPT;
import SyncPT.Model.File_Entity;

/**
 * SyncPT 로그인 컨트롤
 */
public class LoginController extends HttpServlet {
	private static final long serialVersionUID = 1L;       
   
    public LoginController() {
        super();      
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {	
		request.setCharacterEncoding("UTF-8");
	    response.setCharacterEncoding("UTF-8");
	    HttpSession session = request.getSession(); 
	    DBofSyncPT db =new DBofSyncPT(); // 데이터베이스 객체
	    
	    RequestDispatcher view = request.getRequestDispatcher("main.jsp"); // 기본 이동경로를 대기방으로 설정. 
	    
		String name=request.getParameter("u_name"); // 사용자가 입력한 이름
		String u_id=db.loginAuth(name);  // 이름을 데이터베이스에 저장, 유저 id가 리턴됨.

		if(u_id!=null){ // 데이터베이스에 사용자 정보가 정상적으로 저장이 되었음.
			session.setAttribute("u_id", u_id); // 세션으로 유저 아이디 값 유지
			session.setAttribute("u_name", name);
			// 엑세스 코드가 존재하면 로그인 후 회의방으로 바로가기 
			if(request.getParameter("access_code")!=null){
		    	if(db.insert_Access(request.getParameter("access_code"), u_id)) {	// 회의방으로 입장하기 전에 접속 정보를 데이터베이스에 저장하여 사용자가 어떤 회의방에 있는지 구분  	
		    		
		    		ArrayList<File_Entity> files = db.get_FileInfo(request.getParameter("access_code"));
	    			request.setAttribute("fileList", files); // 파일 리스트		    	
	    			request.setAttribute("file_name", files.get(0).getFile_name()); // 첫번재 ppt 이름 
	    			request.setAttribute("slide_count", files.get(0).getSlide_count()); // 첫번째 ppt 슬라이드 장수
	    			request.setAttribute("u_type", "guest"); // 방장 
	    			request.setAttribute("access_code", request.getParameter("access_code")); // 엑세스 코드
	    			request.setAttribute("u_id", u_id); // 유저 id
					request.setAttribute("media_type", request.getParameter("media_type"));
		    		
	    			view = request.getRequestDispatcher("ptroom.jsp"); // 회의방으로 이동 	    			
	    		}	
			}
			// 엑세스 코드가 존재하지 않는다면 대기방.
			else {
				request.setAttribute("u_id", u_id); // 유저 id
				request.setAttribute("name", name); // 이름
			}
		}
		// 데이터베이스 저장 실패, 다시 처음 로그인 페이지로 이동.
		else {
			view = request.getRequestDispatcher("index.jsp");
		}
		view.forward(request, response);	
	}
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {		
		doGet(request, response);
	} 
}
