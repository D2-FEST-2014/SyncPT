package SyncPT.Filter;

import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import SyncPT.Model.DBofSyncPT;
import SyncPT.Model.File_Entity;

/**
 * Servlet Filter implementation class Login_Filter
 */
public class Login_Filter implements Filter {

 
    public Login_Filter() { }
	
	public void destroy() {	}

	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {		
		request.setCharacterEncoding("UTF-8");
	    response.setCharacterEncoding("UTF-8");
		HttpServletRequest httpRequest = (HttpServletRequest)request;
		HttpSession session = httpRequest.getSession();
		DBofSyncPT db = new DBofSyncPT();
		
		// 로그인이 되어있지 않다는 뜻.
		if(session.getAttribute("u_id") == null && request.getParameter("u_type") == null) {
			System.out.println("로그인이 되어있지 않음.");
			String tmp = request.getParameter("access_code");			
			
			request.setAttribute("access_code", tmp.substring(0, 7));
			request.setAttribute("media_type", tmp.substring(7, 8)); 
			RequestDispatcher dispatcher = request.getRequestDispatcher("/index.jsp");
			dispatcher.forward(request, response);
		}
		// 로그인이 이미 되어 잇는 상태
		else {
			System.out.println("로그인이 이미 되어있는 상태");
			// url을 통한 회의방 바로 접근
			if(request.getParameter("u_type") == null)
			{
				String tmp = request.getParameter("access_code");				
		    	if(db.insert_Access(tmp.substring(0, 7), (String)session.getAttribute("u_id"))) {  		
		    		System.out.println("인설트 엑세스 : " + tmp.substring(0, 7));
		    		ArrayList<File_Entity> files = db.get_FileInfo(tmp.substring(0, 7));
		    		System.out.println("사이즈 : " + files.size());
	    			request.setAttribute("fileList", files); // 파일 리스트		    	
	    			request.setAttribute("file_name", files.get(0).getFile_name()); // 첫번재 ppt 이름 
	    			request.setAttribute("slide_count", files.get(0).getSlide_count()); // 첫번째 ppt 슬라이드 장수
	    			request.setAttribute("u_type", request.getParameter("u_type")); // 방장
	    			request.setAttribute("access_code", tmp.substring(0, 7)); // 엑세스 코드
	    			request.setAttribute("media_type", tmp.substring(7, 8)); // 
	    			request.setAttribute("u_id", (String)session.getAttribute("u_id")); // 유저 id
	    			
	    			RequestDispatcher dispatcher = request.getRequestDispatcher("/ptroom.jsp"); // 회의방으로 이동
	    			dispatcher.forward(request, response);	    			
	    		}	
			}
		}
		
		chain.doFilter(request, response);
	}

	/**
	 * @see Filter#init(FilterConfig)
	 */
	public void init(FilterConfig fConfig) throws ServletException {
	}

}
