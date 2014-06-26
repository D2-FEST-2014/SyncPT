package SyncPT.Controller;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Enumeration;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONObject;

import SyncPT.Model.DBofSyncPT;
import SyncPT.Model.ToImage;
import SyncPT.Model.Random_Key;

import com.oreilly.servlet.MultipartRequest;

// ppt파일 업로드 관련 서블릿 
public class FileUpload extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet() 
     */
    public FileUpload() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	@SuppressWarnings("unchecked")
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		request.setCharacterEncoding("UTF-8");
	    response.setCharacterEncoding("UTF-8");	    
	    
	    DBofSyncPT db = new DBofSyncPT(); // 데이터베이스 
		int count = 0; // 업로드한 ppt의 슬라이드 장수 
		String url = ""; // 첫 슬라이드의 url 주소 
		Random_Key r = new Random_Key(); // 랜덤키 생성 
		String access_code = r.asciiout(7);  // 엑세스 코드를 랜덤하게 생성해줌.     
		String Img_type = "jpg"; // 이미지 파일 파입
			 
		db.create_Room(access_code); // 엑세스 코드로 방 개설(db)
		
		// uploadStroage(서버측 업로드 파일 관리 폴더)의 실제 경로 가져오기 
	    String uploadPath = request.getServletContext().getRealPath("uploadStorage") + "\\" + access_code; 
	    	    
		File tempDir = new File(uploadPath);
		if(!tempDir.exists()) // 엑세스 코드와 같은 이름의 폴더가 존재하지 않는지 확인 후 엑세스 코드 이름의 저장 폴더 생성. 
			tempDir.mkdir();	
	    
		// MultipartRequest 클래스. MultipartRequest(request 객체, 서버측 저장 경로, 파일의 최대 크기, 인코딩 방식) 
	    MultipartRequest mRequest = new MultipartRequest(request, uploadPath, 40 * 1024 * 1024, "UTF-8");
	    
	    Enumeration files = mRequest.getFileNames(); 
	    	    
	    // ppt 저장 및 각 슬라이드를 이미지로 변환
	    while(files.hasMoreElements()) {
	    	String name = (String)files.nextElement();
	    	String filename = mRequest.getFilesystemName(name);    	
	    	
			String tmp = uploadPath + "\\" + filename; 
			ToImage cvtImage = new ToImage(uploadPath,filename); // (저장경로,파일이름)
			
			try {
				count = cvtImage.convter(Img_type); // 슬라이드 수 반환
				db.upload_file(access_code, filename, count); // 파일 정보 DB에 저장(엑세스 코드, 파일 이름, 슬라이드 수)	
				
				url = ".\\uploadStorage\\" + access_code + "\\" + filename +"-1."+ Img_type;
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
	    }    
	    
	    
	    JSONObject result = new JSONObject();
	    result.put("resulturl", url);	
	    result.put("access_code", access_code);
	    
	    PrintWriter out = response.getWriter();
	    out.write(result.toString());
	    out.flush();
	    out.close(); 
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request,response);
	}
}