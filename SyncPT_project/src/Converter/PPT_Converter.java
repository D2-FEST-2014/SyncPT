package Converter;

import java.awt.Color;
import java.awt.Dimension;
import java.awt.Graphics2D;
import java.awt.RenderingHints;
import java.awt.geom.AffineTransform;
import java.awt.geom.Rectangle2D;
import java.awt.image.BufferedImage;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;

import javax.imageio.ImageIO;

import org.apache.poi.hslf.HSLFSlideShow;
import org.apache.poi.hslf.model.Slide;
import org.apache.poi.hslf.usermodel.SlideShow;
import org.apache.poi.xslf.usermodel.XMLSlideShow;
import org.apache.poi.xslf.usermodel.XSLFSlide;

public class PPT_Converter {
	private String Dir_path; // 저장 경로
	private String File_name; // 파일 이름
 
	public PPT_Converter(String path, String fileName) {		
		this.Dir_path = path;	
		this.File_name = fileName;
	}
	
	// ppt -> image
	public int ppttoimage(String type) throws IOException {
		int Slide_count = 0; // 슬라이드 갯수 
		
		System.out.println(Dir_path + "\\" + File_name);
		
		FileInputStream file = new FileInputStream(Dir_path + "\\" + File_name); 
						
		SlideShow ppt = new SlideShow(new HSLFSlideShow(file));
		file.close();
		
        double zoom = 2;
        AffineTransform at = new AffineTransform();
        at.setToScale(zoom, zoom);
		
		Dimension pgsize = ppt.getPageSize();		
		
		Slide[] slide = ppt.getSlides(); // ppt의 슬라이드 수 만큼 슬라이드 배열 생성.		
		Slide_count = slide.length; // ppt 슬라이드 수 저장
		
		// 각 슬라이드를 이미지 파일로 변환
		for (int i = 0; i < slide.length; i++) { 			
			BufferedImage img = new BufferedImage((int)Math.ceil(pgsize.width*zoom), (int)Math.ceil(pgsize.height*zoom), BufferedImage.TYPE_INT_RGB);
            Graphics2D graphics = img.createGraphics();
            graphics.setTransform(at);

            graphics.setPaint(Color.white);
            graphics.fill(new Rectangle2D.Float(0, 0, pgsize.width, pgsize.height));
            
            slide[i].draw(graphics);
            FileOutputStream out = new FileOutputStream(Dir_path + "\\" + File_name + "-" + (i + 1)+ "."+ type);
            ImageIO.write(img, type, out);
            out.close();
		}
		
		return Slide_count;
	}
	
	public int pptxtoimage(String type) throws IOException {
		int Slide_count = 0; // 슬라이드 갯수
		
		FileInputStream file = new FileInputStream(Dir_path + "\\" + File_name); 
			
		XMLSlideShow ppt = new XMLSlideShow(file);
        file.close();
        
        double zoom = 2;
        AffineTransform at = new AffineTransform();
        at.setToScale(zoom, zoom);

        Dimension pgsize = ppt.getPageSize();
  
        XSLFSlide[] slide = ppt.getSlides();
        Slide_count = slide.length;
        
        for (int i = 0; i < slide.length; i++) {
        	        	
            BufferedImage img = new BufferedImage((int)Math.ceil(pgsize.width*zoom), (int)Math.ceil(pgsize.height*zoom), BufferedImage.TYPE_INT_RGB);
            Graphics2D graphics = img.createGraphics();
            
            graphics.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
            graphics.setRenderingHint(RenderingHints.KEY_RENDERING, RenderingHints.VALUE_RENDER_QUALITY);
            graphics.setRenderingHint(RenderingHints.KEY_INTERPOLATION, RenderingHints.VALUE_INTERPOLATION_BICUBIC);
            graphics.setRenderingHint(RenderingHints.KEY_FRACTIONALMETRICS, RenderingHints.VALUE_FRACTIONALMETRICS_ON);
            
            graphics.setTransform(at);

            graphics.setPaint(Color.white);
            graphics.fill(new Rectangle2D.Float(0, 0, pgsize.width, pgsize.height));
            slide[i].draw(graphics);
            FileOutputStream out = new FileOutputStream(Dir_path + "\\" + File_name + "-" + (i + 1)+ "."+ type);
            ImageIO.write(img, type, out);
            out.close();
        }	
		
		return Slide_count;
	}
}
