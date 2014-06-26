package SyncPT.Model;

import java.awt.Color;
import java.awt.Dimension;
import java.awt.Graphics2D;
import java.awt.geom.Rectangle2D;
import java.awt.image.BufferedImage;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import javax.imageio.ImageIO;
import org.apache.poi.hslf.HSLFSlideShow;
import org.apache.poi.hslf.model.Slide;
import org.apache.poi.hslf.model.TextRun;
import org.apache.poi.hslf.usermodel.RichTextRun;
import org.apache.poi.hslf.usermodel.SlideShow;

public class ToImage {	
	private String Dir_path; // 저장 경로
	private String fileName; // 파일 이름
 
	public ToImage(String path, String fileName) {		
		this.Dir_path = path;	
		this.fileName = fileName;
	}
	
	public int convter(String type) throws IOException {
		
		int slide_count = 0;
		FileInputStream is = new FileInputStream(Dir_path + "\\" + fileName); // ppt파일 
		 
		SlideShow ppt = new  SlideShow(new HSLFSlideShow(is));
		is.close();
		Dimension pgsize = ppt.getPageSize();		
		
		Slide[] slide = ppt.getSlides(); // ppt의 슬라이드 수 만큼 슬라이드 배열 생성.		
		slide_count = slide.length; // ppt 슬라이드 수 저장
		
		// 각 슬라이드 변환 과정
		for (int i = 0; i < slide.length; i++) { 
			
			// 슬라이드 폰트 사이즈 변경 
			TextRun[] tr = slide[i].getTextRuns();
			for (int j=0; j<tr.length; j++) {
				RichTextRun[] rtr = tr[j].getRichTextRuns();
				for(int k=0; k<rtr.length; k++) {
					rtr[k].setFontSize(rtr[k].getFontSize() * 2);
				}				
			}
						
			BufferedImage img = new BufferedImage(pgsize.width, pgsize.height, BufferedImage.TYPE_INT_RGB);
			Graphics2D graphics = img.createGraphics();
			
			// 이미지 영역을 클리어
			graphics.setPaint(Color.white);
			graphics.fill(new Rectangle2D.Float(0, 0, pgsize.width,	pgsize.height));
 
			// 이미지 그리기(슬라이드)
			slide[i].draw(graphics);
			
			// 이미지 파일명은 파일명-(슬라이드 인덱스 번호).jpg
			FileOutputStream out = new FileOutputStream(Dir_path + "\\" + fileName + "-" + (i + 1)+ "."+ type); 				
			
			ImageIO.write(img, type, out); // 슬라이드 이미지를 저장해줌. 
			out.close();
		}
		
		return slide_count;
	}
}
