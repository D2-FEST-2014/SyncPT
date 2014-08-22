package SyncPT.Model;

import java.awt.Color;
import java.awt.Dimension;
import java.awt.Graphics2D;
import java.awt.geom.AffineTransform;
import java.awt.geom.Rectangle2D;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.List;

import javax.imageio.ImageIO;

import org.apache.poi.hslf.HSLFSlideShow;
import org.apache.poi.hslf.model.Slide;
import org.apache.poi.hslf.model.Hyperlink;
import org.apache.poi.hslf.model.TextRun;
import org.apache.poi.hslf.usermodel.RichTextRun;
import org.apache.poi.hslf.usermodel.SlideShow;
import org.apache.poi.hslf.model.Shape;
import org.apache.poi.xslf.usermodel.XMLSlideShow;
import org.apache.poi.xslf.usermodel.XSLFSlide;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDPage;

public class ToImage {	
	private String Dir_path; // 저장 경로
	private String fileName; // 파일 이름
 
	public ToImage(String path, String fileName) {		
		this.Dir_path = path;	
		this.fileName = fileName;
	}
	
	@SuppressWarnings("unchecked")
	public int convter(String type) throws IOException {
		
		int slide_count = 0;
		FileInputStream is = new FileInputStream(Dir_path + "\\" + fileName); // ppt파일 
		 
		// 확장자 확인하기. ppt는 hslf, pptx는 xslf		
		String[] temp = fileName.split("\\.");		
		String fileType = temp[temp.length-1];
		
		if(fileType.equals("ppt")) {
			SlideShow ppt = new  SlideShow(new HSLFSlideShow(is));
			is.close();
			Dimension pgsize = ppt.getPageSize();		
			
			Slide[] slide = ppt.getSlides(); // ppt의 슬라이드 수 만큼 슬라이드 배열 생성.		
			slide_count = slide.length; // ppt 슬라이드 수 저장
			
			// 각 슬라이드 변환 과정
			for (int i = 0; i < slide.length; i++) { 
				
				// 하이퍼링크 위치 
				System.out.println("reading hyperlinks from the text runs");
				
				
				// 슬라이드 폰트 사이즈 변경 
				TextRun[] tr = slide[i].getTextRuns();
				for (int j=0; j<tr.length; j++) {
					RichTextRun[] rtr = tr[j].getRichTextRuns();
					for(int k=0; k<rtr.length; k++) {
						rtr[k].setFontSize(rtr[k].getFontSize() * 2);
					}			
					
					String text = tr[j].getText();
					System.out.println("테스트 : " + text);
					Hyperlink[] links = tr[j].getHyperlinks();

					if(links != null) 
					{
						System.out.println("링크 수 : " + links.length);
						for (int l = 0; l < links.length; l++) {				
							Hyperlink link = links[l];
							String title = link.getTitle();
							String address = link.getAddress();
							System.out.println("내용: " + title);
							System.out.println(" 하이퍼링크 : " + address);
							String substring = text.substring(link.getStartIndex(), link.getEndIndex());//in ppt end index is inclusive
							System.out.println("  " + substring);
						}
					}
				}
				
				Shape[] sh = slide[i].getShapes();
				for (int k = 0; k < sh.length; k++) {
					Hyperlink link = sh[k].getHyperlink();
				    if(link != null)  {
				    	String title = link.getTitle();
				        String address = link.getAddress();
				        System.out.println("  " + title);
				        System.out.println("  " + address);
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
			
			
		}				
		
		// pptx
		else if(fileType.equals("pptx")) {	   			
			XMLSlideShow ppt = new XMLSlideShow(is);
	        is.close();

	        
	        double zoom = 2; // magnify it by 2
	        AffineTransform at = new AffineTransform();
	        at.setToScale(zoom, zoom);

	        Dimension pgsize = ppt.getPageSize();

	        XSLFSlide[] slide = ppt.getSlides();
	        slide_count = slide.length;
	        System.out.println("사이즈 : " + slide.length);
	        
	        for (int i = 0; i < slide.length; i++) {
	            BufferedImage img = new BufferedImage((int)Math.ceil(pgsize.width*zoom), (int)Math.ceil(pgsize.height*zoom), BufferedImage.TYPE_INT_RGB);
	            Graphics2D graphics = img.createGraphics();
	            graphics.setTransform(at);

	            graphics.setPaint(Color.white);
	            graphics.fill(new Rectangle2D.Float(0, 0, pgsize.width, pgsize.height));
	            slide[i].draw(graphics);
	            FileOutputStream out = new FileOutputStream(Dir_path + "\\" + fileName + "-" + (i + 1)+ "."+ type);
	            javax.imageio.ImageIO.write(img, type, out);
	            out.close();
	        }	        
		}
		
		// pdf
		else {
			
			PDDocument document = PDDocument.load(new File(Dir_path + "\\" + fileName));
			List<PDPage> pages = document.getDocumentCatalog().getAllPages();
			slide_count = pages.size();
			for (int i = 0; i < pages.size(); i++) {
				PDPage page = pages.get(i);
				BufferedImage buffImage = page.convertToImage(
						BufferedImage.TYPE_INT_RGB, 2 * 72);
				ImageIO.write(buffImage, type, new File(Dir_path + "\\" + fileName + "-" + (i+1) + "." + type));
			}
			
			document.close();
		
            
			//String sourceDir = "C:/PDFCopy/04-Request-Headers.pdf";
            //String destinationDir = "C:/PDFCopy/";
            //File oldFile = new File(sourceDir);
            //String fileName = oldFile.getName().replace(".pdf", "");
            //if (oldFile.exists()) {*/
			
			/*
			try {
				File file = new File(Dir_path + "/" + fileName);
				
	            PDDocument document = PDDocument.load(file);
	            List<PDPage> list = document.getDocumentCatalog().getAllPages();	
	            slide_count = list.size();
	            
	            int pageNumber= 1;
	            for (PDPage page : list) {
	                BufferedImage image = page.convertToImage();
	                File outputfile = new File(Dir_path + "\\" + fileName +"_"+ pageNumber+"."+type);
	                ImageIO.write(image, type, outputfile);
	                pageNumber++;
	            }
	            document.close();
			} catch (Exception e) {
		        e.printStackTrace();
		    }*/

		}
		
		return slide_count;
	}
}
