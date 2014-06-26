<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="EUC-KR"%>
<!DOCTYPE html>
<html>
<head>
<script type="text/javascript" src="./js/jquery-1.11.1.min.js"></script>
<script type="text/javascript" src="./js/screenfull.js"></script>
<script type="text/javascript">


	var ws = new WebSocket("ws://220.69.203.57:8080/SyncPT_project/ws.do");
	ws.onopen = function() {   
	   var msg = "enter," + "${access_code}" + "," + "${u_id}"; 
	   ws.send(msg);   
	};   
	
	
	
	ws.onmessage = function(message) {
		var strArray = (message.data).split(','); // 메시지 구분 - 메시지의 첫 부분은 메시지 유형 구분
		
		// 방 입장, 접속자 갱신 - 
		if(strArray[0]=="enter") {			
			$('#user_info').html(''); // 접속자 리스트 초기화
			for(i=1; i<strArray.length; i++) {	
				
				var t = strArray[i].substring(strArray[i].length-1,strArray[i].length);
				
				if(t=="H") {					
					$('#user_info').append('<div style="background-color:rgba(0,0,0,0.4); font-size:1.0em;  margin-top:2px; color:white;">'+strArray[i].substring(0,strArray[i].length-1)+ '(진행자)</div>');
				}
				else {
					$('#user_info').append('<div style="background-color:rgba(0,0,0,0.4); font-size:1.0em;  margin-top:2px; color:white;">'+strArray[i].substring(0,strArray[i].length-1)+ '</div>');
				}								
			}
				
			var filename = document.getElementById("file_name").value + "-" + document.getElementById("index").value + ".jpg"; 				
				
			
			//document.getElementById("slide_count").value = document.getElementById("slide_max").value;			
			document.getElementById("slide_img").src = ".\\uploadStorage\\" + "${access_code}" + "\\" + filename;
			document.getElementById("slide_i").value = document.getElementById("index").value;			
		}
		
		// 채팅 - strArray[1] : 채팅 메세지 
		else if(strArray[0]=="chat") {
			$('#chat_a').append(strArray[1]+'<br/>');
		}
		
		// ppt파일 선택 - strArray[1] : 선택한 파일 이름, strArray[2] : 선택한 파일의 슬라이드 수 
		else if(strArray[0]=="change") {	
			// 선택한 파일 이름 변경, 슬라이드 인덱스 값 초기화, 슬라이드 전체 장 수 표시
			document.getElementById("file_name").value = strArray[1];
			document.getElementById("index").value = "1";
			document.getElementById("slide_max").value = strArray[2];
			$('#len').html(strArray[2]);
			//document.getElementById("slide_count").value = strArray[2]; 		
			
			var filename = strArray[1] + "-" + document.getElementById("index").value + ".jpg";			
			document.getElementById("slide_img").src = ".\\uploadStorage\\" + "${access_code}" + "\\" + filename;
			document.getElementById("slide_i").value = "1";
			
			boardE= document.getElementById('board');
	        boardE.innerHTML='';
		}
		
		// 슬라이드 변경 - strArray[1] : 이동할 슬라이드  
		else if(strArray[0]=="page_control") {
			
			boardE= document.getElementById('board');
	        boardE.innerHTML='';
			
			// 슬라이드쇼 진행중
			var status = document.getElementById("slideshow_status").value;
			if(status=="true") {
				var filename = document.getElementById("slideshow_file").value + "-" + strArray[1] + ".jpg";	
				document.getElementById("slide_img").src = ".\\uploadStorage\\" + "${access_code}" + "\\" + filename;
				document.getElementById("slide_i").value = strArray[1];				
			}
			// 
			else {
				var filename = document.getElementById("file_name").value + "-" + strArray[1] + ".jpg";			
				document.getElementById("index").value = strArray[1];
		    	document.getElementById("slide_img").src = ".\\uploadStorage\\" + "${access_code}" + "\\" + filename;
		        document.getElementById("slide_i").value = strArray[1]; // 현재 슬라이드 인덱스 번호 표시
			}
		}
		
		// 슬라이드쇼 시작 - strArray[1] : 슬라이드쇼가 진행될 ppt파일의 이름, strArray[2] : 슬라이드 수, strArray[3] : 사용자 유형 구분[방장|참여자]
		else if(strArray[0]=="show_start"){	 
			
			boardE= document.getElementById('board');
	        boardE.innerHTML='';
			
			document.getElementById("slideshow_status").value="true"; // 슬라이드쇼 진행 상태로 변경 
			document.getElementById("slide_i").value = "1";
			
			var filename = strArray[1] + "-1.jpg";	  
			
			document.getElementById("slideshow_file").value = strArray[1]; // 슬라이드쇼 진행되는 파일 이름
			
	      	document.getElementById("slide_img").src = ".\\uploadStorage\\" + "${access_code}" + "\\" + filename;
	      	document.getElementById("slide_i").value = "1"; // 현재 인덱스 표시
		$('#len').html(strArray[2]);
	      	
			// strArray[3]가  guest면 참여자. 
			if(strArray[3]=="guest") {
				// 슬라이드쇼가 진행되는 동안 메인 슬라이드 제어 권한 제거
				$('#next').attr('style', "display:none;");  
				$('#before').attr('style', "display:none;");
				$('#preview').attr('style',"display:none;");
				
				var count = strArray[2];
				document.getElementById("s_max").value = strArray[2];				
				
				// 하단 슬라이드 뷰어 
				$('#test').html(''); 
				for(i=1; i<=parseInt(count);i++) {
					var file = "./uploadStorage/" + "${access_code}" + "/" + strArray[1] + "-" + i + ".jpg";					
					$('#test').append('<img id="'+i+'" style="display:none;" class="slide_prev" src="' + file + '" />');	
				}							
				
				document.getElementById("s_index").value = "1"; // 하단 슬라이드 인덱스 
				
				$('#pt_select').attr('style',"width:0px;");
				
				// 하단 슬라이드 화면 활성화
				$('#1').attr('style',"display:block;");
				$('#before_p').attr('style',"cursor: pointer; display:block;");
				$('#next_p').attr('style',"cursor: pointer; display:block;");
			}
	    }
				
		// 슬라이드쇼 종료, 슬라이드 시작전에 자신이 보던 화면 그대로 살려주기
		else if(strArray[0]=="show_stop") {
			
			boardE= document.getElementById('board');
	        boardE.innerHTML='';
			
			document.getElementById("slideshow_status").value="false";
			
			var filename = document.getElementById("file_name").value + "-" + document.getElementById("index").value + ".jpg";
			document.getElementById("slide_img").src = ".\\uploadStorage\\" + "${access_code}" + "\\" + filename;
			var index = "#" + document.getElementById("s_index").value;
			
			$('#pt_select').attr('style',"width:80px;");
			
			//document.getElementById("slide_count").value = document.getElementById("slide_max").value;
			$('#preview').attr('style',"display:block;");
			$('#next').attr('style', "display:block;");
			$('#before').attr('style', "display:block;");
			$(index).attr('style', "display:none;");
			$('#before_p').attr('style',"cursor: pointer; display:none;");
			$('#next_p').attr('style',"cursor: pointer; display:none;");
		}
		
	      else if(strArray[0]=="star") {
	          xPercent=strArray[1];
	          yPercent=strArray[2];
	           
	          
	          boardE= document.getElementById('board');
	          boardE.innerHTML='<div class="pointer" style=" position:absolute; top:'+ yPercent+'%; left:'+xPercent+'%;"><img src="./image/point_star.png" style="width:'+parseInt(boardE.clientWidth/20)+'px; height:'+parseInt(boardE.clientWidth/20)+'px" /></div>';   
	        }
	       
	       else if(strArray[0]=="check") {
	          xPercent=strArray[1];
	          yPercent=strArray[2];
	        
	           boardE= document.getElementById('board');
	           boardE.innerHTML='<div class="pointer" style=" position:absolute; top:'+ yPercent+'%; left:'+xPercent+'%;"><img src="./image/point_chk.png" style="width:'+parseInt(boardE.clientWidth/20)+'px; height:'+parseInt(boardE.clientWidth/20)+'px" /></div>';   
	        }
	       else if(strArray[0]=="eraser") {

		           boardE= document.getElementById('board');
		           boardE.innerHTML='';   
		   }
	};
	
	function Select_PPT(value) {	
		var msg = "select_ppt," + value;
		ws.send(msg);
	}
	
    function Chat_msg() {
    	var chat_msg = document.getElementById("chat").value;
    	document.getElementById("chat").value="";
    	var msg = "chat," + chat_msg;
    	ws.send(msg);
    }
	
	function Slide_pre() {
    	var index = document.getElementById("slide_i").value;
    	var msg = "pre," + index;
    	ws.send(msg);
	}
    function Slide_next() {
    	var index = document.getElementById("slide_i").value;
    	var msg = "next," + index;
    	ws.send(msg);
    }
    
	function pSlide_pre() { 		
		var index = document.getElementById("s_index").value;		
    	if(parseInt(index)>1) {
    		var t = "#" + index;
    		$(t).attr('style',"display:none;");
    		index = parseInt(index) - parseInt('1');
    	}
    	var t2 = "#" + String(index);
    	$(t2).attr('style',"display:block;");
    	document.getElementById("s_index").value = parseInt(index);
	}
	
    function pSlide_next() {   
		var index = document.getElementById("s_index").value;
		var max = document.getElementById("s_max").value;		
    	if(parseInt(index)<parseInt(max)) {
    		var t = "#" + index;
    		$(t).attr('style',"display:none;");
    		index = parseInt(index) + parseInt('1');    		
    	}
    	var t2 = "#" + String(index);
    	$(t2).attr('style',"display:block;");
    	document.getElementById("s_index").value = parseInt(index);
    }    

    function Slide_show() {	   
   		$('#show_button').attr('onclick', "Slide_stop()");
		$('#show_button').attr('value', "종료");
		
    	var msg = "show,";
      	ws.send(msg);
	}
    
	function Slide_stop() {
		
		$('#show_button').attr('onclick', "Slide_show()");
		$('#show_button').attr('value', "시작");
		
		var msg = "stop,";
		ws.send(msg);
	}
    

	function closeConnect() {
    	ws.close();
	}


    
    function copyThis() {   
        var url = "http://220.69.203.57:8080/SyncPT_project/Access?access_code=${access_code}";
        var IE=(document.all)?true:false;
        if (IE) {
           window.clipboardData.setData("Text", url);
           alert('클립보드에 URL이 복사되었습니다.\n\nCtrl+V (붙여넣기) 단축키를 이용하시면,\nURL을 붙여 넣으실 수 있습니다.');
        } else {
           temp = prompt("Ctrl+C를 눌러 클립보드로 복사하세요", url);
        }
     }

    // 추가
    
       function doResize() {   
      var bd = document.getElementById('board');
       var slimg = document.getElementById('slide_img');
         tp = slimg.offsetTop;
         le = slimg.offsetLeft;
         wid=slimg.clientWidth;
         hei=slimg.clientHeight;
        bd.style.top=tp+"px";
        bd.style.left=le+"px";
        bd.style.width=wid +"px";
         bd.style.height=hei+"px";
         
         
   }


    function getMousePosition(evt, currentObj){
       var x, y;
       var xPercent,yPercent;
       if(evt.pageX){
          x = evt.pageX - currentObj.offsetLeft;
          y = evt.pageY - currentObj.offsetTop;
       }
       else if (evt.clientX){
          x = evt.clientX + document.body.scrollLeft - document.body.clientLeft - currentObj.offsetLeft;
          y = evt.clientY + document.body.scrollTop - document.body.clientTop - currentObj.offsetTop;
       }
       if(document.body.parentElement && document.body.parentElement.clientLeft){
          var b = document.body.parentElement;
          x += b.scrollLeft - b.clientLeft;
          y += b.scrollTop - b.clientTop;
       }
       xPercent = x/currentObj.clientWidth*100;
       yPercent = y/currentObj.clientHeight*100;
       
       
       chkval = $('input:radio[name=tool]:checked').val();
      if(chkval!='cursor'){    	 
        var msg = chkval+"," + yPercent + "," + xPercent; 
         ws.send(msg);   
      }
       //currentObj.innerHTML='<div class="click pointer" style=" position:absolute; top:'+ yPercent+'%; left:'+xPercent+'%;"><img src="./image/point_chk.png" style="width:'+parseInt(currentObj.clientWidth/20)+'px; height:'+parseInt(currentObj.clientWidth/20)+'px" /></div>';
    }
    
    


	$('#chat').keypress(function(e) { //크롬 브라우저 esc이벤트 1회 무시 방지 (이미지 토글 안됨 방지)
		if (e.keyCode === 13) {
			Chat_msg();
		}
	});
	
	$(document).keyup(function(e) { //크롬 브라우저 esc이벤트 1회 무시 방지 (이미지 토글 안됨 방지)
		if (e.keyCode == 27) {
			$('#full_button').attr('src', './image/full.png');
		}
	});
	$(document).keydown(function(e) { //f11 전체화면 무시 (토글 이미지 및 screenfull.js 버그 방지)
		if (e.keyCode == 122) {
			e.preventDefault();
		}
	});
	$(document).ready(function() {
		var target = $('body')[0];
		$('#full_button').click(function() {
			if (screenfull.enabled) {
				screenfull.toggle(target);
			}
			if (screenfull.isFullscreen) {
				$('#full_button').attr('src', './image/unfull.png');
			} else {
				$('#full_button').attr('src', './image/full.png');
			}
		});
	});
</script>

<style type="text/css">
html,body {
   width: 100%;
   height: 100%;
   overflow: hidden;
}
* {
   font-family: 'malgun gothic';
   margin: 0;
   padding: 0;
}
.left_60px{
   position:absolute;
   left:-60px;
}
.container {
   width: 100%;
   height: 100%;
}
.slide_area {
   display: table;
   width: 100%;
   height: 100%;
   /*padding-bottom:40px;*/
}
.image_cell {
   display: table-cell;
   vertical-align: middle;
   text-align: center;
}
.start_button {
   background: -webkit-gradient(linear, left top, left bottom, color-stop(0.05, #ededed), color-stop(1, #dfdfdf));
   background: -moz-linear-gradient(center top, #ededed 5%, #dfdfdf 100%);
   filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#ededed',   endColorstr='#dfdfdf');
   background-color: #ededed;
   -webkit-border-top-left-radius: 42px;
   -moz-border-radius-topleft: 42px;
   border-top-left-radius: 42px;
   -webkit-border-top-right-radius: 0px;
   -moz-border-radius-topright: 0px;
   border-top-right-radius: 0px;
   -webkit-border-bottom-right-radius: 42px;
   -moz-border-radius-bottomright: 42px;
   border-bottom-right-radius: 42px;
   -webkit-border-bottom-left-radius: 0px;
   -moz-border-radius-bottomleft: 0px;
   border-bottom-left-radius: 0px;
   text-indent: 0;
   border: 1px solid #dcdcdc;
   display: inline-block;
   color: #777777;
   font-family: arial;
   font-size: 15px;
   font-weight: bold;
   font-style: normal;
   height: 38px;
   line-height: 38px;
   width: 90px;
   text-decoration: none;
   text-align: center;
   text-shadow: 1px 1px 0px #ffffff;
   */
}
.start_button:hover {
   background: -webkit-gradient(linear, left top, left bottom, color-stop(0.05, #dfdfdf), color-stop(1, #ededed));
   background: -moz-linear-gradient(center top, #dfdfdf 5%, #ededed 100%);
   filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#dfdfdf',endColorstr='#ededed');
   background-color: #dfdfdf;
}
.start_button:active {
   position: relative;
   top: 1px;
}
#slide_img {
   width: auto;
   height: 90vh;
   background-color: white;
   -moz-box-shadow:0px 0px 3px 3px rgba(0, 0, 0, 0.2);
   -webkit-box-shadow:0px 0px 3px 3px rgba(0, 0, 0, 0.2);
   box-shadow:0px 0px 3px 3px rgba(0, 0, 0,0.2);   
   
}
#content_wrap {
   width: 100%;
   height: 100vh;
   background-color: rgb(201,205,210);
   margin-bottom: -40px;

}
#bottom_nav {
   height: 40px;
   line-height: 40px;
   display: table-cell;
   vertical-align: middle;
   position: absolute;
   text-align: center;
   margin: 0;
   padding: 0;
   bottom: 0px;
   width: 100%;
   overflow: hidden;
   background-color: #eeeeee;
   z-index:299;
}


#right_bar {
   width: 15%;
   min-width: 180px;
   height: 100vh;
   background-color: rgba(0, 0, 0, 0.2);
   right: 0;
   position: absolute;
}

#content_area {
   width: 85%;
   height: 100vh;
   padding-bottom:40px;
   box-sizing:border-box;  
   float: left;
}
#top_status {
   position:absolute;
   z-index: 200;
   width: 100%;
   height: 40px;
   text-align: center;
}

#stop {
   display: none;
}

.user_info {
   z-index: 210;
   position:absolute;
   width: 100%;
   top:40px;
   min-height: 200px;
   background-color:rgba(0,0,0,0.1);
   overflow-y:scroll;
}

#slide_i{
   margin: 0;
   padding: 0; 
   width: 40px; 
   height: 20px; 
   text-align: center; 
   border: 1px solid #333333;
}

#slide_list_menu {
   z-index: 303;
   position: absolute;
   bottom: 0;
   left: 0;
   height: 40px;
   width: 40px;
   overflow: hidden;
   text-align: center;
}


#file_list_menu {
   z-index: 304;
   position: absolute;
   bottom: 0;
   left: 90px;
   height: 40px;
   width: 250px;
   overflow: hidden;
}



#tool_list_menu{
   z-index: 314;
   position: absolute;
   bottom: 0;
   left: 45px;
   height: 40px;
   width: 40px;
   overflow: hidden;
   text-align: center;
}
#tool_list {
   border: 1px solid #111111;
   position: absolute;
   bottom: 40px;
   left: 45px;
   width: 40px;
   height:172px;
   z-index:220;
   background: #eeeeee;
   display:none;
}


#tool_list_menu:hover+#tool_list {
   display: block;
}

#tool_list:hover {
   display: block;
}



#slide_list {
   border: 1px solid #111111;
   position: absolute;
   bottom: 40px;
   left: 0;
   width: 30%;
   min-width: 410px;
   min-height: 340px;
   background: #eeeeee;
   display:none;
}

#slide_list_menu:hover+#slide_list {
   display: block;
}

#slide_list:hover {
   display: block;
}




.slide_prev {
   min-width: 400px;
   min-height: 300px;
   padding-bottom: 40px;
   width: 100%;
   height: auto;
}

#full_button {
   cursor: pointer;
}

#chat_area{   
   width: 100%;
   min-width: 180px;
   height:100%;
   overflow:hidden;
   padding-top:240px;
   padding-bottom:40px;
   position:absolute;
   box-sizing: border-box;
}

</style>

<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body onresize="doResize()" onload="doResize()">
   <div id="board" style="position: absolute; background:transparent; z-index:100;" onclick="getMousePosition(event, this)" ></div>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	
	<input id="slideshow_status" type="hidden" value="false"/>  <!-- 슬라이드쇼 진행상태 -->
	<input id="slideshow_file" type="hidden" value=""/>  <!-- 슬라이드쇼 진행되는 파일 이름 -->
	
	<input id="file_name" type="hidden" value="${file_name}"/>  <!-- 자신이 선택한 파일 이름 -->
	<input id="slide_max" type="hidden" value="1" /> <!-- 선택한 파일 슬라이드의 전체 수 -->
	<input id="index" type="hidden" value="1" /> <!-- 메인 슬라이드 인덱스 -->
	
	<input id="s_index" type="hidden" value="1" /> <!-- 하단 슬라이드 인덱스 -->
	<input id="s_max" type="hidden" value="1" /> <!-- 하단 슬라이드 전체 수 -->

	<div id="content_wrap">

		<div id="content_area">
			<div class="slide_area">
				<div class="image_cell">
					<img id="slide_img" src="./image/prev.png" alt="Slide Image" onclick="getMousePosition(event, this)" />
				</div>
			</div>
		</div>
		<div id="right_bar">
			<div id="top_status">
				<div style="height: 40px; width: 50%; float: left;"></div>
				<div style="height: 40px; width: 50%; float: left; text-align: right;">
					<c:choose>
						<c:when test="${ u_type == 'host'}">
							<input id="show_button" type="button" class="start_button" value="시작" onclick="Slide_show()" />
						</c:when>
						<c:otherwise>

						</c:otherwise>
					</c:choose>
				</div>
			</div>
			<div id="user_list">
				<div id="user_info" class="user_info"></div>
			</div>
			<div id="chat_area">
				<div
					style="width: 100%; height: 100%; padding-bottom: 30px; box-sizing: border-box;">
					<div id="chat_a" style="width: 100%; height: 100%; overflow-y: scroll; border: 0; background-color: transparent;"></div>
				</div>
				<div
					style="position: absolute; width: 100%; height: 30px; bottom: 40px; z-index: 298;">
					<div style="float: left; width: 90%; height: 100%;">
						<input id="chat" type="text"
							style="width: 100%; height: 100%; background-color: transparent; box-sizing: border-box; border-top: 2px solid #cccccc; border-bottom: 2px solid #cccccc;" />
					</div>
					<div style="float: left; width: 10%; height: 100%;">
						<input type="button" value="▼" style="width: 100%; height: 100%; background-color: #eeeeee; box-sizing: border-box; border: 2px solid #cccccc;"	onclick="Chat_msg()" />
					</div>
				</div>
			</div>
		</div>
	</div>

   <div id="bottom_nav">
      <div style="width: 200px; height: 40px; margin: 0 auto;">
         <div style="width: 50px; height: 40px; float: left;">
            <img id="before" alt="before" onclick="Slide_pre()" title="before"   style="cursor: pointer;" src="./image/before.png" />
         </div>
         <div style="width: 100px; height: 40px; float: left;">
            <input id="index" type="hidden" value="1" /> 
            <input id="slide_i" type="text"/>  / <span id="len">${slide_count}</span> 
         </div>
         <div style="width: 50px; height: 40px; float: left;">
            <img id="next" alt="next" onclick="Slide_next()" title="next"   style="cursor: pointer;" src="./image/next.png" />
         </div>
      </div>
   </div>

	<div id="slide_list_menu">
		<img alt="slide list" src="./image/slideList.png" style="width: 36px; height: 36px; padding-top: 2px; cursor: pointer;" />
	</div>

	<div id="slide_list">		
		<div id="test">
			<img id="preview" alt="preview" class="slide_prev" src="./image/prev.png" />
		</div>		
		<div style="width: 50px; height: 40px; float: left;">
			<img id="before_p" alt="before" onclick="pSlide_pre()" title="before" style="cursor: pointer; display: none;" src="./image/before.png" />
		</div>
		<div style="width: 50px; height: 40px; float: left;">
			<img id="next_p" alt="next" onclick="pSlide_next()" title="next" style="cursor: pointer; display: none;" src="./image/next.png" />
		</div>
	</div>

	<div id="file_list_menu">
		<div style="color: #878787; width: 250px; height: 40px; font-size: 1.2em; line-height: 40px; font-weight: bold; border: 1px solid #878787; box-sizing: border-box; padding: 0 20px;">
			PT File 선택 : 
			<select id="pt_select" onchange="Select_PPT(this.value)" style="width:80px;">
				<c:set var="index" value="0"></c:set>
				<c:forEach var="Row" items="${fileList}">
					<option value="${index}">${Row.file_name}</option>
					<c:set var="index" value="${index+1}"></c:set>
				</c:forEach>
			</select>
		</div>
	</div>
	
	<!-- 추가 -->
	   <div id="tool_list_menu">
      <img alt="slide list" src="./image/slideList.png" style="width: 36px; height: 36px; padding-top: 2px; cursor: pointer;" />
   </div>

   <div id="tool_list">      

         <input id="t1" type="radio" name="tool" value="cursor" checked="checked" style="display: none;" />
         <input id="t2" type="radio" name="tool" value="check" style="display: none;" />
         <input id="t3" type="radio" name="tool" value="star" style="display: none;" />
         <input id="t4" type="radio" name="tool" value="eraser" style="display: none;" />


         <label for="t1">
            <span style="width: 40px; height: 40px;  display: inline-block; border:0; padding:0; margin:0;"><img src="./image/csr.png" style="width:38px; height:38px;  border:1px solid black; padding:0; margin:0;"></span>
         </label>
         <label for="t2">
            <span style="width: 40px; height: 40px; display: inline-block; border:0; padding:0; margin:0; "><img src="./image/point_chk.png"  style="width:38px; height:38px;  border:1px solid black; padding:0; margin:0;"></span>
         </label>
         <label for="t3">
            <span style="width: 40px; height: 40px;  display: inline-block; border:0; padding:0; margin:0;"><img src="./image/point_star.png"  style="width:38px; height:38px;  border:1px solid black; padding:0; margin:0;"></span>
         </label>
         <label for="t4">
            <span style="width: 40px; height: 40px; display: inline-block; border:0; padding:0; margin:0;"><img src="./image/point_star.png"  style="width:38px; height:38px;  border:1px solid black; padding:0; margin:0;"></span>
         </label>
   </div>
   
	

	<div style="position: absolute; bottom: 0; right: 0; height: 40px; width: 40px; z-index: 300;">
		<img id="full_button" alt="full screen" title="full screen"	src="./image/full.png" style="width: 36px; height: 36px;" />
	</div>

   <div style=" text-align:center; width: 250px; font-size: 1.2em; height: 40px; line-height:40px; position: fixed; bottom:0; right: 45px; z-index:330;color: #878787; font-weight: bold; border: 1px solid #878787; box-sizing: border-box;" onclick="copyThis()">
      URL 공유하기
   </div>
</body>
</html>