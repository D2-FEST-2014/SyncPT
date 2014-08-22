package Converter;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.util.List;

import javax.imageio.ImageIO;

import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDPage;

public class PDF_Converter {
	private String Dir_path; // 저장 경로
	private String File_name; // 파일 이름
 
	public PDF_Converter(String path, String fileName) {		
		this.Dir_path = path;	
		this.File_name = fileName;
	}
	
	// pdf -> image
	@SuppressWarnings("unchecked")
	public int pdftoimage(String type) throws IOException {
		int Slide_count = 0; // 슬라이드 갯수 
		
		PDDocument document = PDDocument.load(new File(Dir_path + "\\" + File_name));
		List<PDPage> pages = document.getDocumentCatalog().getAllPages();
		Slide_count = pages.size();
		for (int i = 0; i < pages.size(); i++) {
			PDPage page = pages.get(i);
			BufferedImage buffImage = page.convertToImage(BufferedImage.TYPE_INT_RGB, 2 * 72);
			ImageIO.write(buffImage, type, new File(Dir_path + "\\" + File_name + "-" + (i+1) + "." + type));
		}
		
		document.close();
		
		return Slide_count;
	}
}
