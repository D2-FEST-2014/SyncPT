<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<script type="text/javascript">

  WebFontConfig = {
    custom: {
        families: ['Nanum Gothic'],
        urls: ['http://fonts.googleapis.com/earlyaccess/nanumgothic.css']
    }
  };
  (function() {
    var wf = document.createElement('script');
    wf.src = ('https:' == document.location.protocol ? 'https' : 'http') +
      '://ajax.googleapis.com/ajax/libs/webfont/1.4.10/webfont.js';
    wf.type = 'text/javascript';
    wf.async = 'true';
    var s = document.getElementsByTagName('script')[0];
    s.parentNode.insertBefore(wf, s);
  })(); 
  
   function setFileName(textbox,fileinName) {      
      textbox.value = fileinName.value.replace("C:\\fakepath\\", "");
   }
   
   
   
   var counter = 2;
   var limit = 4;
   function addInput(divName){
        if (counter == limit)  {
             alert("최대 3개의 파일까지 업로드 가능합니다.");
        }
        else {
             var newdiv = document.createElement('div');
             newdiv.innerHTML = '<div style="padding-top:5px; width: 100%; height: 50px; overflow: hidden;"><div style="float: left; width: 545px;"><input type="text" id="fileName'+counter+'" class="accessBox" readonly="readonly"></div><div style="float: left; position: relative; width: 120px; height: 50px; overflow: hidden;"><input type="button" class="buttonRed" value="파일 찾기" /><input type="file" class="file_hidden" name="file'+counter+'" id="filein'+counter+'" onchange="setFileName(fileName'+counter+',filein'+counter+')" /></div></div>';
             document.getElementById(divName).appendChild(newdiv);
             counter++;
        }
   }
  
 </script>
<style type="text/css">
header {
   position: fixed;
   background-color: #eee;
   width: 100%;
   height: 100px;
   z-index: 10;
   box-sizing: border-box;
   border-bottom: 1px solid #ccc;
}

#messageBox {
   color: #111111;
   width: 348px; /* 폭이나 높이가 일정해야 합니다. */
   border: 1px solid black;
   height: 198px; /* 폭이나 높이가 일정해야 합니다. */
   position: absolute;
   top: 50%; /* 화면의 중앙에 위치 */
   left: 50%; /* 화면의 중앙에 위치 */
   margin: -170px 0 0 -174px;
   /* 높이의 절반과 너비의 절반 만큼 margin 을 이용하여 조절 해 줍니다. */
   background-color: #eeeeee;
}

.file_hidden {
   font-size: 45px;
   position: absolute;
   right: 0px;
   top: 0px;
   opacity: 0;
   filter: alpha(opacity = 0);
   -ms-filter: "alpha(opacity=0)";
   -khtml-opacity: 0;
   -moz-opacity: 0;
}

#header_align{

   margin: 0 auto;
   width: 950px;
   overflow: hidden;
}

#content_wrap {
   min-height: 100vh;
   margin-bottom: -150px;
   width: 100%;
   background: url(./image/bgpatt.gif) repeat;
}

#content {
   padding: 100px 0 200px 0;
   margin: 0 auto;
   width: 950px;
   overflow: hidden;
}

#content_paper {
   background-color:white;
   border: 1px solid #eee;
   box-sizing: border-box;
   padding: 40px;
   margin: 0 10px 10px 10px;
   -moz-box-shadow: 0px 0px 2px 2px rgba(0, 0, 0, 0.2);
   -webkit-box-shadow: 0px 0px 2x 2px rgba(0, 0, 0, 0.2);
   box-shadow: 0px 0px 2px 2px rgba(0, 0, 0, 0.2);
}

#access_Area {
   display: none;
}

#access {
   float: left;
   height: 50px;
   line-height: 50px;
   font-size: 1.2em;
}

#result {
   font-weight: bold;
   font-size: 1.2em;
}

footer {
   bottom: 0;
   height: 150px;
   width: 100%;
   background-color: #eee;
   box-sizing: border-box;
   border-top: 1px solid #ccc;
   border-bottom: 1px solid #ccc;
}
</style>
<link rel="stylesheet" type="text/css" href="css/global.css" />
<meta charset="UTF-8">
<title></title>
<script type="text/javascript" src="./js/jquery-1.11.1.min.js"></script>
<script type="text/javascript" src="./js/jquery.form.min.js"></script>
<script type="text/javascript" src="./js/json2.js"></script>
<script type="text/javascript">
   // 준비 핸들러 
   $(document).ready(function() {
      
      var u_id = "${u_id}";
      // ajaxForm. 페이지 이동없이 파일 업로드   
      $('#upload').ajaxForm(
                              {
                                 dataType : 'text',
                                 beforeSerialize : function() {
                                    // form을 직렬화하기전 엘레먼트의 속성을 수정할 수도 있다.
                                    $('#data').attr('value', '야호');
                                 },
                                 beforeSubmit : function() {
                                    $('#result')
                                          .html(
                                                '<div id=\"messageBox\"><div style=\"font-size:0.8em; width: 100%; height: 20%; background-color:#ffffff; height:22px;\">Uploading...</div><div style=\"width: 100%; height: 60%; text-align: center;\"><br /><br />업로드 중입니다.<br /><img alt=\"uploading\" src=\"./image/ing.gif\" style="width:30px; padding-top:20px;\"/></div></div></div>');
                                 },
                                 success : function(data) {
                                    // 크롬, FF에서 반환되는 데이터(String)에는 pre태그가 쌓여있으므로
                                    // 정규식으로 태그 제거. IE의 경우 정상적으로 값이 반환된다.
                                    data = data.replace(
                                          /[<][^>]*[>]/gi, '');

                                    // JSON 객체로 변환
                                    var jData = JSON.parse(data);

                                    $('#result').html('회의를 개설하였습니다.');
                                    $('#access').html('엑세스 코드는 <b>' + jData.access_code + '</b> 입니다.');
                                    $('#code_Area').attr('style', "display:none;");
                                    $('#access_Area').attr('style', "display:block;");
                                    $('#a_code').attr('value', jData.access_code);
                                    $('#slide_preview').attr('src', jData.resulturl);
                                 }
                              });
               });


	function setFileName(textbox, fileinName) {
		textbox.value = fileinName.value.replace("C:\\fakepath\\", "");
	}

	var counter = 2;
	var limit = 4;
	function addInput(divName) {
		if (counter == limit) {
			alert("최대 3개의 파일까지 업로드 가능합니다.");
		} else {
			var newdiv = document.createElement('div');
			newdiv.innerHTML = '<div style="padding-top:5px; width: 100%; height: 50px; overflow: hidden;"><div style="float: left; width: 545px;"><input type="text" id="fileName'+counter+'" class="accessBox" readonly="readonly"></div><div style="float: left; position: relative; width: 120px; height: 50px; overflow: hidden;"><input type="button" class="buttonRed" value="파일 찾기" /><input type="file" class="file_hidden" name="file'
					+ counter
					+ '" id="filein'
					+ counter
					+ '" onchange="setFileName(fileName'
					+ counter
					+ ',filein'
					+ counter + ')" /></div></div>';
			document.getElementById(divName).appendChild(newdiv);
			counter++;
		}
	}
</script>
</head>
<body>
   <header>
   	<div id="header_align"><img src="./image/sptLogo.png" style="padding-top:15px;  padding-left:10px; width:200px; height: auto;"/></div>
   </header>
   <div id="content_wrap">
      <div id="content">
         <div id="content_paper">
            <div style="font-size: 1.5em; padding: 40px 0;">
               ${name}님 SyncPT에 방문하신 것을 환영합니다!</div>
            <hr />
            <div style="font-size: 1.0em; font-weight:bold; padding: 10px 0;">SyncPT는 본인의 회의를 개설하거나 타인의 회의에 입장할 수 있습니다.</div>

            <div style="font-size: 0.85em; padding: 10px 0;">파일을 업로드 하여 회의    개설하기</div>

            <div style="font-size: 0.85em;">
               
               <form id="upload" action="FileUploadppt.do" method="POST" enctype="multipart/form-data">
               
                  <div id="dynamicAdd">
                     <div style="width: 100%; height: 50px; overflow: hidden;">
                        <div style="float: left; width: 545px;">
                           <input type="text" id="fileName1" class="accessBox" readonly="readonly">
                        </div>
                        <div style="float: left; position: relative; width: 120px; height: 50px; overflow: hidden;">
                           <input type="button" class="buttonRed" value="파일 찾기" />
                           <input type="file" class="file_hidden" name="file1" id="filein" onchange="setFileName(fileName1,filein)" />
                        </div>
                     </div>
                  </div>

                  
                  <div style="padding-top:5px;">
                     <input type="button" value="파일 추가" class="buttonRed" onclick="addInput('dynamicAdd')" />
                     
                     <input type="submit" class="buttonRed" value="업로드" />
                  </div>

               </form>    

               <br> <b></b>
               <div id="result"></div>
               <br />
            </div>

            <form id="code_Area" method="post" action="Access">
               <input type="hidden" name="u_id" value="${u_id}" />
                  <input type="hidden" name="u_type" value="guest" />

               <hr />
               <div style="font-size: 1.0em; font-weight: bold; padding: 10px 0;">
               타인의 엑세스 코드를 입력하면 회의에 참여 할 수 있습니다.
               </div>

               <div style="font-size: 0.85em; padding: 10px 0;">
               코드를 입력하여 회의에 참여하기
               </div>

               <div style="width: 100%; height: 50px; overflow: hidden;">
                  <div style="float: left; width: 545px;">
                     <input type="text" class="accessBox" name="access_code" />
                  </div>
                  <div style="float: left;">
                     <input type="submit" value="확인" class="buttonRed">
                  </div>
               </div>
            </form>

			<form id="access_Area" method="post" action="Access">
            	<div style="width: 100%;  overflow: hidden; height:60px;">
                  <div id="access" style="float: left; paading: 20px 0;"></div>
                  <div style="float: left;">
                     <input type="submit" value="입장하기" class="buttonRed" />
                  </div>
                  <input type="hidden" name="u_id" value="${u_id}" />
                  <input type="hidden" name="u_type" value="host" />
                  <input id="a_code" type="hidden" name="access_code" value="" />
                  <br />
               </div>
               <div style="width:100%;">
                  <div style="width:800px; margin: 0 auto; font-size:0.85em;">
                  슬라이드 미리보기<br /><br />
                  <img id="slide_preview" src="./image/prev.png" alt="슬라이드 이미지"    style="width: 100%; height: auto; background-color: white;" />
                  </div>
               </div>
            </form>
            
          </div>
      </div>
   </div>
   <footer> </footer>
</body>
</html>