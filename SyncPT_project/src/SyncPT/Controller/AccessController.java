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
 * Servlet implementation class AccessController
 */
public class AccessController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AccessController() {
        super();
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
	    response.setCharacterEncoding("UTF-8");
	    
	    HttpServletRequest httpRequest = (HttpServletRequest)request;
	    HttpSession session = httpRequest.getSession();
	    
	    DBofSyncPT db = new DBofSyncPT(); // 데이터베이스	    
	    String u_type = request.getParameter("u_type");	// 사용자 유형 구분
	   
	    // 사용자 유형 구분에 대한 값이 없으면 필터에 의해 처리됨.
	    if(u_type != null) {
		    // 방장
		    if(u_type.equals("host")) {
		    	// 방 정보 테이블에 방장 id 설정( + 방 제목을 추가해줘야 한다. )
		    	System.out.println("룸 네임 확인 : " + request.getParameter("room_name"));
		    	if(db.Update_room(request.getParameter("u_id"),request.getParameter("room_name"),request.getParameter("access_code"),request.getParameter("media_type"))) {	
		    		// 만약 rtc를 쓰지 않는 방인데 공개방인 경우 isopen 업데이트 --> 일단 넣어두는 것이니 아까 하던거 생각 정리 끝나면 수정바람(to.혁)
		    		// 엑세스 정보 설정.(사용자가 어느 회의방에 들어가 있는지 구분하기 위함) 
		    		if(db.insert_Access(request.getParameter("access_code"), request.getParameter("u_id"))){
		    			ArrayList<File_Entity> files = db.get_FileInfo(request.getParameter("access_code"));
		    			
			    		if(request.getParameter("media_type").equals("0") && request.getParameter("isopen").equals("1")) {
			    			db.Update_isopen(request.getParameter("access_code"));
			    		}
		    			// 업로드되어 저장된 파일 정보 가져오기(엑세스 코드로 구분)
		    			
		    			request.setAttribute("fileList", files); // 파일 리스트
		    			request.setAttribute("file_name", files.get(0).getFile_name()); // 첫번재 ppt 이름 
		    			request.setAttribute("slide_count", files.get(0).getSlide_count()); // 첫번째 ppt 슬라이드 장수
		    			request.setAttribute("u_type", u_type); // 방장 
		    			request.setAttribute("access_code", request.getParameter("access_code")); // 엑세스 코드
		    			request.setAttribute("media_type", request.getParameter("media_type"));
		    			request.setAttribute("isopen", request.getParameter("isopen"));
		    			request.setAttribute("u_id", request.getParameter("u_id")); // 유저 id
		    		}	    		
		    	}	  		    	
		    }
		    // 참여자
		    else {
		    	String access_code = request.getParameter("access_code").substring(0, 7);
		    	String media = request.getParameter("access_code").substring(7, 8);

		    	if(db.insert_Access(access_code, request.getParameter("u_id"))) {
		    		ArrayList<File_Entity> files = db.get_FileInfo(access_code);
		    		request.setAttribute("fileList", files); // 파일 리스트             
		    		request.setAttribute("file_name", files.get(0).getFile_name()); // 첫번재 ppt 이름 
		    		request.setAttribute("slide_count", files.get(0).getSlide_count()); // 첫번째 ppt 슬라이드 장수
		    		request.setAttribute("u_type", u_type); // 방장 
		    		request.setAttribute("access_code", access_code); // 엑세스 코드
		    		request.setAttribute("media_type", media);
		    		request.setAttribute("u_id", request.getParameter("u_id")); // 유저 id  
		    	}    
		    }
		    
		    RequestDispatcher view = request.getRequestDispatcher("ptroom.jsp");
		    view.forward(request, response);
		    return;
	    }
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request,response);
	}

}
