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

var media;

function mediaChange(evt) {
  var i, medias, streams;
  medias = document.getElementsByName('media');
  streams = document.getElementsByName('stream');
  media = 0;
  
  for (i = 0; i < medias.length; i++){
    if(medias[i].checked) {
      media = parseInt(media) + parseInt(medias[i].value);
    }
  }
  for (i = 0; i < streams.length; i++) {
    if (streams[i].checked){
      media = parseInt(media) + parseInt(streams[i].value);
    }
    if (evt.id === 'useNone') {
       streams[i].checked = false;
       streams[i].style.display = 'none';
    } else if (evt.id === 'useAudio' || evt.id === 'useVideo') {
       streams[i].checked = false;
       streams[i].style.display = 'block';
    }
  }

  document.getElementById('media_type').value = media;
  
  console.log(media);
}
function checkMediaSource() {
  var isChrome, isFirefox, uaudio, uvideo, oneway, twoway;
  isChrome = navigator.webkitGetUserMedia;
  isFirefox = navigator.mozGetUserMedia;

  uaudio = document.getElementById('useAudio');
  uvideo = document.getElementById('useVideo');
  oneway = document.getElementById('useOneway');
  twoway = document.getElementById('useTwoway');

//Chrome -> 소스 확인
//Firefox -> 전부 open
//나머지 -> rtc지원x
  media = 0;
  document.getElementById('useNone').checked = true;
  uaudio.disabled = true;
  uvideo.disabled = true;

  oneway.checked = false;
  twoway.checked = false;
  /////////hide
  oneway.style.display = 'none';
  twoway.style.display = 'none';

  if (isChrome) {
    MediaStreamTrack.getSources(function (sources) {
       console.log(sources);
      var i, result = {};

      for (i = 0; i < sources.length; i++) {
        result[sources[i].kind] = true;
      }
      
      console.log(result);
      console.log(result.audio);
      if (result['audio']) {
        uaudio.disabled = false;
      }
      if (result['video']) {
        uvideo.disabled = false;
      }
    });
  } else if (isFirefox) {
    uaudio.disabled = false;
    uvideo.disabled = false;
  }
}
</script>
<style type="text/css">
html {
	font-size: 62.5%;
}

body {
	font-family: 'Nanum Gothic', 'malgun gothic';
	color: #333333;
	margin: 0;
	padding: 0;
	width: 100%;
	font-size: 0.9em;
}

#content {
	padding: 600px 0 200px 0;
	margin: 0 auto;
	width: 1200px;
	overflow: hidden;
}

#content_top {
	background: url(./image/main_top.jpg) no-repeat center center;
	width: 100%;
	height: 600px;
	position: absolute;
	overflow: hidden;
}

#content_top>div {
	width: 1200px;
	margin: 0 auto;
}

#header_align {
	margin: 0 auto;
	width: 1200px;
	overflow: hidden;
}

#slide_preview {
	display: none;
}

.accessBox {
	text-shadow: 1px 1px 3px black;
	text-indent: 5px;
	margin: 2px 0;
	box-sizing: border-box;
	width: 100%;
	height: 2.6em;
	font-size: 1.25em;
	line-height: 2.1em;
	font-weight: bold;
	color: white;
	font-family: 'Nanum Gothic', 'malgun gothic';
	-moz-box-shadow: inset 0px 1px 0px 0px #f29c93;
	-webkit-box-shadow: inset 0px 1px 0px 0px #f29c93;
	box-shadow: inset 0px 1px 0px 0px #f29c93;
	background: -webkit-gradient(linear, left top, left bottom, color-stop(0.05, #fe0033
		), color-stop(1, #ce0006));
	background: -moz-linear-gradient(center top, #fe0033 5%, #ce0006 100%);
	filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#fe0033',
		endColorstr='#ce0006');
	background-color: #fe0033;
	border: 0.5em solid #fe0033;
	display: inline-block;
	-webkit-border-top-left-radius: 1.924em;
	-moz-border-radius-topleft: 1.924em;
	border-top-left-radius: 1.924em;
	-webkit-border-top-right-radius: 0px;
	-moz-border-radius-topright: 0px;
	border-top-right-radius: 0px;
	-webkit-border-bottom-right-radius: 1.924em;
	-moz-border-radius-bottomright: 1.924em;
	border-bottom-right-radius: 1.924em;
	-webkit-border-bottom-left-radius: 0px;
	-moz-border-radius-bottomleft: 0px;
	border-bottom-left-radius: 0px;
	margin: 0;
	padding: 0;
	background: none;
	display: inline-block;
}

.buttonRed {
	-moz-box-shadow: inset 0px 1px 0px 0px #f29c93;
	-webkit-box-shadow: inset 0px 1px 0px 0px #f29c93;
	box-shadow: inset 0px 1px 0px 0px #f29c93;
	background: -webkit-gradient(linear, left top, left bottom, color-stop(0.05, #fe0033
		), color-stop(1, #ce0006));
	background: -moz-linear-gradient(center top, #fe0033 5%, #ce0006 100%);
	filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#fe0033',
		endColorstr='#ce0006');
	background-color: #fe0033;
	-webkit-border-top-left-radius: 1.924em;
	-moz-border-radius-topleft: 1.924em;
	border-top-left-radius: 1.924em;
	-webkit-border-top-right-radius: 0px;
	-moz-border-radius-topright: 0px;
	border-top-right-radius: 0px;
	-webkit-border-bottom-right-radius: 1.924em;
	-moz-border-radius-bottomright: 1.924em;
	border-bottom-right-radius: 1.924em;
	-webkit-border-bottom-left-radius: 0px;
	-moz-border-radius-bottomleft: 0px;
	border-bottom-left-radius: 0px;
	border: 1px solid #d83526;
	display: inline-block;
	color: #ffffff;
	font-family: 'malgun gothic' Arial;
	font-size: 1.25em;
	font-weight: bold;
	font-style: normal;
	line-height: 2.1em;
	width: 100%;
	height: 2.6em;
	text-decoration: none;
	text-align: center;
	text-shadow: 1px 1px 0px #b23e35;
	margin: 0;
	padding: 0 4px 0 0;
}

.buttonRed:hover {
	background: -webkit-gradient(linear, left top, left bottom, color-stop(0.05, #ce0006
		), color-stop(1, #fe0033));
	background: -moz-linear-gradient(center top, #ce0006 5%, #fe0033 100%);
	filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#ce0006',
		endColorstr='#fe0033');
	background-color: #ce0006;
}

.buttonRed:active {
	position: relative;
	top: 1px;
}

header {
	position: fixed;
	background-color: #242424;
	width: 100%;
	height: 70px;
	z-index: 10;
	box-sizing: border-box;
}

#messageBox {
	z-index: 300;
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

#content_wrap {
	min-height: 100vh;
	margin-bottom: -150px;
	width: 100%;
	background: url(./image/bgpatt.gif) repeat;
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

@media ( min-width : 300px) {
	html {
		font-size: 65%;
	}
	#content {
		padding: 250px 0 200px 0;
		margin: 0 auto;
		width: 298px;
		overflow: hidden;
	}
	#content>div>div:nth-child(1) {
		width: 100%;
	}
	#content>div>div:nth-child(2) {
		width: 100%;
	}
	#header_align {
		margin: 0 auto;
		width: 298px;
		overflow: hidden;
	}
	#content_top>div {
		width: 298px;
		margin: 0 auto;
	}
	#content_top {
		background: url(./image/main_top.jpg) no-repeat center center;
		width: 100%;
		height: 250px;
		position: absolute;
	}
}

@media ( min-width : 500px) {
	html {
		font-size: 80%;
	}
	#content {
		padding: 250px 0 200px 0;
		margin: 0 auto;
		width: 476px;
		overflow: hidden;
	}
	#content>div>div:nth-child(1) {
		width: 100%;
	}
	#content>div>div:nth-child(2) {
		width: 100%;
	}
	#header_align {
		margin: 0 auto;
		width: 476px;
		overflow: hidden;
	}
	#content_top>div {
		width: 476px;
		margin: 0 auto;
	}
	#content_top {
		background: url(./image/main_top.jpg) no-repeat center center;
		width: 100%;
		height: 250px;
		position: absolute;
	}
}

@media ( min-width : 700px) {
	html {
		font-size: 95%;
	}
	#content {
		padding: 350px 0 200px 0;
		margin: 0 auto;
		width: 680px;
		overflow: hidden;
	}
	#content>div>div:nth-child(1) {
		width: 100%;
	}
	#content>div>div:nth-child(2) {
		width: 100%;
	}
	#header_align {
		margin: 0 auto;
		width: 680px;
		overflow: hidden;
	}
	#content_top>div {
		width: 680px;
		margin: 0 auto;
	}
	#content_top {
		background: url(./image/main_top.jpg) no-repeat center center;
		width: 100%;
		height: 350px;
		position: absolute;
	}
}

@media ( min-width : 900px) {
	html {
		font-size: 110%;
	}
	#content {
		padding: 450px 0 200px 0;
		margin: 0 auto;
		width: 850px;
		overflow: hidden;
	}
	#header_align {
		margin: 0 auto;
		width: 850px;
		overflow: hidden;
	}
	#content_top>div {
		width: 850px;
		margin: 0 auto;
	}
	#content_top {
		background: url(./image/main_top.jpg) no-repeat center center;
		width: 100%;
		height: 450px;
		position: absolute;
	}
	#content>div>div:nth-child(1) {
		width: 60%;
		height: 100%;
	}
	#content>div>div:nth-child(2) {
		width: 40%;
		height: 100%;
	}
}

@media ( min-width : 1100px) {
	html {
		font-size: 125%;
	}
	#content {
		padding: 550px 0 200px 0;
		margin: 0 auto;
		width: 1000px;
		overflow: hidden;
	}
	#header_align {
		margin: 0 auto;
		width: 1000px;
		overflow: hidden;
	}
	#content_top>div {
		width: 1000px;
		margin: 0 auto;
	}
	#content_top {
		background: url(./image/main_top.jpg) no-repeat center center;
		width: 100%;
		height: 550px;
		position: absolute;
	}
	#content>div>div:nth-child(1) {
		float: left;
		width: 60%;
		height: 100%;
	}
	#content>div>div:nth-child(2) {
		float: left;
		width: 40%;
		height: 100%;
	}
}

@media ( min-width : 1300px) {
	html {
		font-size: 140%;
	}
	#content>div>div:nth-child(1) {
		float: left;
		width: 60%;
		height: 100%;
	}
	#content>div>div:nth-child(2) {
		float: left;
		width: 40%;
		height: 100%;
	}
}
</style>
<meta charset="UTF-8">
<meta name="viewport"
	content="initial-scale=1.0, maximum-scale=1.0, user-scalable=no, width=device-width" />
<title>SyncPT D2fest</title>
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
            beforeSubmit : function() {
                $('#result').html('<div id=\"messageBox\"><div style=\"font-size:0.8em; width: 100%; height: 20%; background-color:#ffffff; height:22px;\">Uploading...</div><div style=\"width: 100%; height: 60%; text-align: center;\"><br /><br />업로드 중입니다.<br /><img alt=\"uploading\" src=\"./image/ing.gif\" style="width:30px; padding-top:20px;\"/></div></div></div>');
            },
            success : function(data) {
            // 크롬, FF에서 반환되는 데이터(String)에는 pre태그가 쌓여있으므로
            // 정규식으로 태그 제거. IE의 경우 정상적으로 값이 반환된다.
                data = data.replace(/[<][^>]*[>]/gi, '');
                // JSON 객체로 변환
                var jData = JSON.parse(data);
                $('#result').html('');
                $('#slide_preview').attr('style', "display:block; width: 100%; overflow:hidden; height: auto; background-color: white;");
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
      newdiv.innerHTML = '<div style=\"width: 100%; height:auto; padding-top:10%;\"><div style=\"float: left; width: 82%\"><input type=\"text\" id=\"fileName'+counter+'\" class=\"accessBox\" readonly=\"readonly\"></div><div style=\"float: left; position: relative; width:18%; height:auto; overflow: hidden;\"><input type=\"button\" class=\"buttonRed\" value=\"파일 찾기\" /><input type=\"file\" class=\"file_hidden\" name=\"file'+counter+'\" id=\"filein'+counter+'\" onchange=\"setFileName(fileName'+counter+',filein'+counter+')\" /></div></div>';
      document.getElementById(divName).appendChild(newdiv);
      counter++;
   }
}
</script>
</head>
<body>
	<header>
		<div id="header_align">
			<img src="./image/sptLogo.png" style="width: 244px; height: 54px; padding-top: 6px;" />
		</div>
	</header>

	<div id="content_wrap">
		<div id="content_top">
			<div>
				<div
					style="position: absolute; bottom: 15%; font-size: 2.5em; font-weight: bold; color: white; text-shadow: 1px 1px 3px black;">
					${name}님<br>SyncPT에 방문하신 것을 환영합니다. <br>
					<span style="font-size: 0.6em;">SyncPT는 본인의 회의를 개설하거나 타인의 회의에 입장할	수 있습니다.</span>
				</div>
			</div>
		</div>
		<div id="content">
			<div style="overflow: hidden; width: 100%;">
				<div style="float: left;">
					<div style="font-size: 1.5em; font-weight: bold; padding: 10px 0;">파일을
						업로드 하여 회의 개설하기</div>
					<div style="font-size: 0.85em;">
						<form id="upload" action="FileUploadppt.do" method="POST" enctype="multipart/form-data">
							<div id="dynamicAdd">
								<div style="width: 100%; height: auto;">
									<div style="float: left; width: 82%">
										<input type="text" id="fileName1" class="accessBox"	readonly="readonly">
									</div>
									<div style="float: left; position: relative; width: 18%; height: auto; overflow: hidden;">
										<input type="button" class="buttonRed" value="파일 찾기" />
										<input type="file" class="file_hidden" name="file1" id="filein"	onchange="setFileName(fileName1, filein)" />
									</div>
								</div>
							</div>
							<div style="width: 100%;">
								<div style="padding-top: 5px; width: 18%; height: auto; float: left;">
									<input type="button" value="파일 추가" class="buttonRed" onclick="addInput('dynamicAdd')" />
								</div>
								<div style="padding-top: 5px; width: 18%; height: auto; float: left;">
									<input type="submit" class="buttonRed" value="업로드"	onclick="checkMediaSource()" />
								</div>
							</div>
						</form>
						<div id="result"></div>
					</div>
				</div>
				<div style="float: left;">
					<div style="width: 100%; box-sizing: border-box; padding: 3%; overflow: hidden;">
						<img id="slide_preview" src="./image/prev.png" alt="슬라이드 이미지" style="width: 100%; overflow: hidden; height: auto; background-color: white;" />
					</div>
				</div>
			</div>
			<div style="overflow: hidden; width: 100%;">
				<form id="code_Area" method="post" action="Access">
					<input type="hidden" name="u_id" value="${u_id}" />
					<input type="hidden" name="u_type" value="guest" />
					<hr />
					<div style="font-size: 1.5em; font-weight: bold; padding: 10px 0;">엑세스 코드를 입력하여 회의에 참여하기</div>
					<div style="font-size: 0.85em;">
						<div style="width: 100%; height: auto;">
							<div style="float: left; width: 82%">
								<input type="text" class="accessBox" name="access_code" />
							</div>
							<div style="float: left; position: relative; width: 18%; height: auto; overflow: hidden;">
								<input type="submit" value="확인" class="buttonRed">
							</div>
						</div>
					</div>
				</form>
			</div>
			<div id="access_Area" style="overflow: hidden; width: 100%;">
				<form method="post" action="Access">
					<div style="font-size: 1.5em; font-weight: bold; padding: 10px 0;">회의방 설정하기</div>
					<div style="font-size: 0.85em; width: 100%;">
						<div style="width: 100%;">
							<div style="float: left; width: 50%; font-size: 1.25em; font-weight: bold;">
								<div>미디어 장치 선택</div>
								<input type="radio" name="media" id="useNone" value="0" checked="checked" onchange="mediaChange(this)" />사용하지 않음 
								<input type="radio" name="media" id="useAudio" value="1" onchange="mediaChange(this)" />마이크 
								<input type="radio" name="media" id="useVideo" value="3" onchange="mediaChange(this)" />마이크와 카메라 <br />
								<b>미디어 전송 방식</b><br />
								<input type="radio" name="stream" id="useOneway" value="0" onchange="mediaChange(this)" />단방향(1-&gt;N)
								<input type="radio" name="stream" id="useTwoway" value="1" onchange="mediaChange(this)" />앙방향(1&lt;-&gt;1)<br />
								<div style="width: 100%; overflow: hidden; height: 60px;">
									<div id="access" style="float: left; pading: 20px 0;"></div>
									<div style="float: left;"></div>
									<input type="hidden" name="u_id" value="${u_id}" />
									<input type="hidden" name="u_type" value="host" />
									<input id="a_code" type="hidden" name="access_code" value="" />
									<input id="media_type" type="hidden" name="media_type" value="0" />
									<br />
								</div>
								<div>
									<input type="radio" name="isopen" id="isopen" value="0" checked="checked" />비공개
									<input type="radio" name="isopen" id="isopen" value="1" />공개
								</div>
								<div>
									<input type="text" name="room_name" />
								</div>
							</div>
							<div style="float: right; width: 22.5%;">
								<input type="submit" value="입장하기" class="buttonRed" />
							</div>
						</div>
						<br />
					</div>
				</form>
			</div>
		</div>
	</div>
	<footer></footer>
</body>
</html>