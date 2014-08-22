<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="EUC-KR"%>
<!DOCTYPE html>
<html>
<head>
<script type="text/javascript" src="./js/jquery-1.11.1.min.js"></script>
<script type="text/javascript" src="./js/screenfull.js"></script>
<script src="./js/meeting.js"></script>
<script src='./js/socket.io.js'></script>
<link rel="stylesheet" type="text/css" href="./css/pt.css" />

<meta charset="UTF-8">
<meta name="viewport"
	content="initial-scale=1.0, maximum-scale=1.0, user-scalable=no, width=device-width" />
<title>SyncPT D2fest</title>
</head>
<body>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
	<% session.removeAttribute("u_id"); %>
	<div id="content_wrap">
		<div id="left_bar">
			<div style="height: 100%; width: 100%; padding-bottom: 40px; box-sizing: border-box;">
				<div style="height: 100%; width: 100%; float: left;">
					<div style="float: right; height: 100%; position: relative;">
						<input type="button" value="▶" id="leftBarButton" onclick="leftBarOpen(this)" />
					</div>
					<div style="float: right; height: 100%; width: 100%;">
						<div style="width: 100%; height: 7%; box-sizing: border-box;">
							<c:choose>
								<c:when test="${ u_type == 'host'}">
									<input id="show_button" type="button" class="start_button" value="시작" onclick="Slide_show()" />
								</c:when>
								<c:otherwise>
									<input id="request_button" type="button" class="start_button" value="권한 요청" onclick="c_Request()" style="display: none;" />
								</c:otherwise>
							</c:choose>
						</div>
						<div style="width: 100%; height: 93%; padding: 2%; box-sizing: border-box; background-color: rgba(0, 0, 0, 0.4); position: relative;">
							<div style="color: cornflowerblue;">
								<div>파일 선택</div>
								<div>
									<select id="pt_select" onchange="Select_PPT(this.value)" style="width:100%; height:3vmin;">
										<c:set var="index" value="0"></c:set>
										<c:forEach var="Row" items="${fileList}">
											<option value="${Row.file_name}">${Row.file_name}</option>
											<c:set var="index" value="${index+1}"></c:set>
										</c:forEach>
									</select>
								</div>
							</div>
							<div id="inkPalette">
								<div>잉크 주석</div>
								<div style="width: 90%; position: relative; float: left;">
									<div style="float: left; width: 50%; height: 100%;">
										<div class="box">
											<div class="content" style="background-color: red;" id="red" onclick="color(this)"></div>
										</div>
										<div class="box">
											<div class="content" style="background-color: orange;" id="orange" onclick="color(this)"></div>
										</div>
										<div class="box">
											<div class="content" style="background-color: yellow;" id="yellow" onclick="color(this)"></div>
										</div>
										<div class="box">
											<div class="content" style="background-color: green;" id="green" onclick="color(this)"></div>
										</div>
										<div class="box">
											<div class="content" style="background-color: blue;" id="blue" onclick="color(this)"></div>
										</div>
									</div>
									<div style="float: left; position: absolute; left: 25%; width: 50%; height: 100%;">
										<div class="box">
											<div class="content" style="background: navy;" id="navy" onclick="color(this)"></div>
										</div>
										<div class="box">
											<div class="content" style="background: purple;" id="purple" onclick="color(this)"></div>
										</div>
										<div class="box">
											<div class="content" style="background: maroon;" id="maroon" onclick="color(this)"></div>
										</div>
										<div class="box">
											<div class="content" style="background: black;" id="black" onclick="color(this)"></div>
										</div>
										<div class="box">
											<div class="content" style="background: white;" id="white" onclick="color(this)"></div>
										</div>
									</div>
								</div>
								<div
									style="right: 0; width: 45%; box-sizing: border-box; position: absolute; overflow: hidden;">
									<div class="box2">
										<div class="content">
											<input type="button" class="ink_button" value="지우기" onclick="erase()" />
										</div>
									</div>
									<div class="box2">
										<div class="content">
											<input type="button" class="ink_button" value="숨기기" onclick="hideCanvas()" />
										</div>
									</div>
									<div class="box2">
										<div class="content">
											<input type="button" class="ink_button" value="실행취소" onclick="undoCanvas()" />
										</div>
									</div>
									<div class="box2">
										<div class="content">
											<input type="button" class="ink_button" value="다시실행" onclick="redoCanvas()" />
										</div>
									</div>
									<div style="width: 191%;">
										<div class="box">
											<div class="content" style="box-sizing: border-box; border: 1px solid black; background: black;" id="chooseColor"></div>
										</div>
									</div>
								</div>
							</div>
							<div>
								<a href="http://220.69.203.93/SyncPT_project/Access?access_code=${access_code}${media_type}" class="start_button" onclick="copyThis(); return false;">링크 공유</a>
							</div>
							<div>
								<input type="button" class="start_button" value="미디어 연결" id="trySignalButton" onclick="trySignaling()" />
							</div>
							<div>
								<a class="start_button" id="download_path" href="#" onclick="window.open(this.href, '', ''); return false;">파일 다운로드</a>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div id="right_bar">
			<div style="float: left; height: 100%; position: relative; background: red;">
				<input type="button" value="▶" id="rightBarButton" onclick="rightBarOpen(this)" />
			</div>
			<div style="float: left; width: 100%; height: 100%; overflow: hidden; position: relative;">
				<div class="box3" id="mediaBox1">
					<div class="content" style="text-align: center;">
						<img id="MicButton" alt="" src="./image/micOn.png" style="width: auto; height: 80%; cursor: pointer;" onclick="toggleMic()" />
					</div>
				</div>
				<div class="box3" id="mediaBox2">
					<div class="content">
						<div id="local_media" style="width: 100%; height: 100%;"></div>
					</div>
				</div>
				<div class="box3" id="mediaBox3">
					<div class="content">
						<div id="volumeControl" class="volumeBox">
							<div id="volUp" style="text-align: center; width: 100%; height: 15%; border: 0; background: blue; cursor: pointer; background: url(./image/volUp.png); background-size: 55% 100%; background-repeat: no-repeat; background-position: top center;" onclick="volumeControl(this)">
							</div>
							<div style="text-align: center; width: 100%; font-size: 2.7em; line-height: 90%; position: relative; cursor: pointer; padding-bottom: 2px; height: 70%;">
								<img id="mute" src="./image/speakerOn.png" style="height: 100%; width: auto;" onclick="volumeControl(this)" />
							</div>
							<div id="volDown" style="text-align: center; width: 100%; height: 15%; border: 0; background: blue; cursor: pointer; background: url(./image/volDown.png); background-size: 55% 100%; background-repeat: no-repeat; background-position: bottom center;" onclick="volumeControl(this)"></div>
						</div>
					</div>
				</div>
				<div class="box3" id="mediaBox4">
					<div class="content">
						<div id="remote_media" style="width: 100%; height: 100%;">
						</div>
					</div>
				</div>
				<div id="user_info" class="user_info">
				</div>
			</div>
		</div>
		<div id="content_area">
			<div class="slide_area">
				<div class="image_cell">
					<img id="slide_img" src="./image/prev.png" alt="Slide Image" />
					<canvas id="can" style="position: absolute; z-index: 70; box-sizing: border-box; border: 1px solid red; display: block;">
					</canvas>
				</div>
			</div>
			<div id="chat_wrap">				
				<div id="chat_area">
					<div style="width: 100%; height: 100%; padding-bottom: 30px; box-sizing: border-box;">
						<div id="chat_a" style="overflow-y: scroll; width: 100%; height: 100%; padding: 0 32px; border: 0; background-color: transparent; color: white; text-shadow: 1px 1px 0px darkgray;">
						</div>
					</div>
					<div style="width: 100%; height: 30px; position: relative; bottom: 30px; background-color: rgba(0, 0, 0, 0.1);">
						<div style="float: left; width: 90%; height: 30px;">
							<input id="chat" type="text" style="width: 100%; height: 30px; border: 0; text-indent: 32px; background-color: transparent; box-sizing: border-box; color: white; text-shadow: 1px 1px 0px darkgray;" />
						</div>
						<div style="float: left; width: 10%; height: 30px;">
							<input type="button" value="Send" class="start_button" style="font-size: 0.6em; height: 30px; line-height: 0.6em; background-color: rgb(87, 87, 87)" onclick="Chat_msg()" />
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>

	<div id="bottom_nav">
		<div style="width: 200px; height: 40px; margin: 0 auto;">
			<div style="width: 50px; height: 40px; float: left;">
				<img id="before" alt="before" onclick="Slide_pre()" title="before" style="cursor: pointer;" src="./image/before.png" />
			</div>
			<div style="width: 100px; height: 40px; float: left;">
				<input id="index" type="hidden" value="1" />
				<input id="slide_i" type="text" />
				<span> / </span>
				<span id="len">${slide_count}</span>
			</div>
			<div style="width: 50px; height: 40px; float: left;">
				<img id="next" alt="next" onclick="Slide_next()" title="next" style="cursor: pointer;" src="./image/next.png" />
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

	
	
	<div style="position: fixed; bottom: 0; right: 0; height: 40px; width: 40px; z-index: 300;">
		<img id="full_button" alt="full screen" title="full screen" src="./image/full.png" style="width: 36px; height: 36px;" />
	</div>
	<div style="position: fixed; bottom: 0; right: 50px; height: 40px; width: 40px; z-index: 301;"> 
		<input type="button" value="▼" id="chat_wrapButton" style="float: left;" onclick="chatwrapOpen(this)" />
	</div>
	<script type="text/javascript">
var u_id = '${u_id}';
var u_name = '${u_name}';
var user_type = '${u_type}';
var slideshow_status = false; // 슬라이드쇼 진행상태 
var slideshow_file; // 슬라이드쇼 진행되는 파일 이름
var slideshow_index = 1; // 슬라이드쇼 인덱스 
var slideshow_max; // 슬라이드쇼 파일 슬라이드 장 수

var file_name = '${file_name}'; // 사용자가 선택한 파일 이름 
var slide_max = '${slide_count}'; // 선택한 파일 슬라이드의 전체 수   
var slide_index = 1; // 메인 뷰어 슬라이드 인덱스

var sub_index = 1; // 하단 뷰어 슬라이드 인덱스
var sub_slide_max = 1; // 하단 뷰어 슬라이드 전체 수

//rtc관련
var media_type = '${media_type}'; //
var isOpen = '${isopen}';

var brtype;
var conntype;
var sock;
var trySignalActive = false;

//권한 요청 관련
var request_list = new Array(); // 권한 요청 중인 참여자들 
var request_user; // 권한을 부여받은 참여자

///////////캔버스 전역변수 ///////////
var canvas, ctx, w, h, flag = false;
var prevX = 0;
var currX = 0;
var prevY = 0;
var currY = 0;
var pageList = {};
var LineColor = "black", lineWidth = 2;
var slide_img = document.getElementById('slide_img');
canvas = document.getElementById('can');
ctx = canvas.getContext("2d");

// 캔버스 관련
var target = $('body')[0];

if (media_type === '0') {
    brtype = 'none';
    conntype = true;
} else if (media_type === '1') {
    brtype = 'audio';
    conntype = true;
} else if (media_type === '2') {
    brtype = 'audio';
    conntype = false;
} else if (media_type === '3') {
    brtype = 'video';
    conntype = true;
} else {
    brtype = 'video';
    conntype = false;
}

//rtc관련
var hash = '${access_code}'; // 엑세스 코드
var meeting = new Meeting(hash, brtype, conntype, u_id);

var localMediaStream = document.getElementById('local_media');
var remoteMediaStreams = document.getElementById('remote_media');
var localstream; // 토글 버튼 동작 위해서 스트림 저장

if (user_type === 'host') {
    document.getElementById('inkPalette').style.display = 'block';
}
initCanvasPage();

    // on getting local or remote streams
meeting.onaddstream = function (e) {
    'use strict';
    if (e.type === 'local') {
        localMediaStream.appendChild(e.contents);
        localstream = e.stream;
        //document.getElementById('micToggleButton').onclick = toggleMic;
    }
    if (e.type === 'remote') {
        remoteMediaStreams.insertBefore(e.contents, remoteMediaStreams.firstChild);
    }
};
    // custom signaling channel
    // you can use each and every signaling channel
    // any websocket, socket.io, or XHR implementation
    // any SIP server
    // anything! etc.
meeting.openSignalingChannel = function (callback) {
    'use strict';
    sock = io.connect('http://220.69.203.93:8080/').on('message', callback);
    return sock;
};

    // if someone leaves; just remove his audio
meeting.onuserleft = function (message) {
    'use strict';
    var contents, element;

    if (message.maintain) {
        if (user_type === 'host' && message.rtc) {
            contents = document.getElementById('partin');
            if (contents) {
                contents.parentNode.removeChild(contents);
            }
        } else if (user_type !== 'host' && message.rtc) {
            trySignalActive = message.available;
        }
        
        element = document.getElementById(message.userid);
        element.parentNode.removeChild(element);
    }
    else {
        alert("방장이 회의를 종료시켰습니다. 메인 화면으로 이동합니다.");
        location.href='index.jsp';
    }
};

    // check pre-created meeting rooms
    // it is useful to auto-join
    // or search pre-created sessions
    // 0단계
    // signaler Init for client
meeting.check(); // 꼭필요함

    // 1단계
    // 방장이면 먼저 방을 생성한다.
meeting.enterroom(hash, u_id);

if (media_type === '0') {

} else if (media_type === '1') {
    if (user_type !== 'host') {
        document.getElementById('mediaBox3').style.display = 'block';
    } else {
        document.getElementById('mediaBox1').style.display = 'block';
    }
} else if (media_type === '2') {
    document.getElementById('mediaBox1').style.display = 'block';
    document.getElementById('mediaBox3').style.display = 'block';

} else if (media_type === '3') {
    if (user_type !== 'host') {
        document.getElementById('mediaBox4').style.display = 'block';
    } else {
        document.getElementById('mediaBox2').style.display = 'block';
    }
} else if (media_type === '4') {
    document.getElementById('mediaBox4').style.display = 'block';
    document.getElementById('mediaBox2').style.display = 'block';
}

//////////////////////////////////////////////////////////////////////////
console.log(media_type + ' : ' + isOpen);
// 2단계
if ((brtype !== 'none') && (navigator.mozGetUserMedia || navigator.webkitGetUserMedia)) { // 미디어를 사용한다. 
    if (user_type === 'host') { // 방장
        meeting.setup(hash, isOpen); // 방장
    } else { // 참여자
        meeting.onmeeting(hash);
    }
}

// 3단계
// 방정보 초기화
if (user_type !== 'host') {
    meeting.tryOfferInfo(hash, u_id);
}

    // 4단계
    // 방 공개 flag 수정

$('#full_button').click(function () {
    if (screenfull.enabled) {
        screenfull.toggle(target);
    }
    if (screenfull.isFullscreen) {
        $('#full_button').attr('src', './image/unfull.png');
    } else {
        $('#full_button').attr('src', './image/full.png');
    }
});
$('#chat').keypress(function (e) { //크롬 브라우저 esc이벤트 1회 무시 방지 (이미지 토글 안됨 방지)
    'use strict';
    if (e.keyCode === 13) {
        Chat_msg();
    }
});

$(document).keyup(function (e) { //크롬 브라우저 esc이벤트 1회 무시 방지 (이미지 토글 안됨 방지)
    'use strict';
    if (e.keyCode === 27) {
        $('#full_button').attr('src', './image/full.png');
    }
});
$(document).keydown(function (e) { //f11 전체화면 무시 (토글 이미지 및 screenfull.js 버그 방지)
    'use strict';
    if (e.keyCode === 122) {
        e.preventDefault();
    }
});
canvas.addEventListener("mousemove", function (e) {
    getPosition('move', e);
}, false);
canvas.addEventListener("mousedown", function (e) {
    getPosition('down', e);
}, false);
canvas.addEventListener("mouseup", function (e) {
    getPosition('up', e);
}, false);
canvas.addEventListener("mouseout", function (e) {
    getPosition('up', e);
}, false);
canvas.addEventListener("touchstart", function (e) {
    getPosition('tDown', e);
}, false);
canvas.addEventListener("touchmove", function (e) {
    getPosition('tMove', e);
}, false);
canvas.addEventListener("touchend", function (e) {
    getPosition('up', e);
}, false);
canvas.addEventListener("touchcancel", function (e) {
    getPosition('up', e);
}, false);

function initCanvasPage() {
    'use strict';
    var i;
    pageList = {};
    pageList.length = slide_max+1;
    for (i = 1; i <= slide_max; i += 1) {
        pageList[i] = {};
        pageList[i].length = 0;
        pageList[i].lineIndex = -1;
    }
    drawPage();
}

function drawPage() {
    'use strict';
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    var pageTotalLine = pageList[slideshow_index].lineIndex + 1, i, j, currLine, LineTotalDot, x, y;

    for (i = 0; i < pageTotalLine; i += 1) {
        currLine = pageList[slideshow_index][i];
        LineTotalDot = currLine.length;
        x = currLine[0].x * canvas.width;
        y = currLine[0].y * canvas.height;
        
        if (LineTotalDot > 1) {
            ctx.beginPath();
            ctx.moveTo(x, y);
            for (j = 1; j < currLine.length; j += 1) {
                x = currLine[j].x * canvas.width;
                y = currLine[j].y * canvas.height;
                ctx.lineTo(x, y);
            }
            ctx.strokeStyle = currLine.color;
            ctx.lineWidth = 2;
            ctx.stroke();
            ctx.closePath();
        } else {
            ctx.beginPath();
            ctx.fillStyle = currLine.color;
            ctx.fillRect(x, y, 2, 2);
            ctx.closePath();
        }
    }
}

function draw() {
    'use strict';
    ctx.beginPath();
    ctx.moveTo(prevX, prevY);
    ctx.lineTo(currX, currY);
    ctx.strokeStyle = LineColor;
    ctx.lineWidth = lineWidth;
    ctx.stroke();
    ctx.closePath();
}
function getPosition(res, e) {
    'use strict';
    var lineNo, NextDotIndex, percentX, percentY;
    if (user_type === 'host' && slideshow_status) {
        if (res === 'move') {
            if (flag) {
                lineNo = pageList[slideshow_index].lineIndex;
                NextDotIndex = pageList[slideshow_index][lineNo].length;
                pageList[slideshow_index][lineNo][NextDotIndex] = {};
                prevX = currX;
                prevY = currY;
                currX = e.clientX - canvas.offsetLeft;
                currY = e.clientY - canvas.offsetTop;
                percentX = currX / canvas.width;
                percentY = currY / canvas.height;
                pageList[slideshow_index][lineNo][NextDotIndex].x = percentX;
                pageList[slideshow_index][lineNo][NextDotIndex].y = percentY;
                pageList[slideshow_index][lineNo].length += 1;
                draw();
            }
        } else if (res === 'tMove') {
            e.preventDefault();
            lineNo = pageList[slideshow_index].lineIndex;
            NextDotIndex = pageList[slideshow_index][lineNo].length;
            pageList[slideshow_index][lineNo][NextDotIndex] = {};
            prevX = currX;
            prevY = currY;
            currX = e.touches[0].clientX - canvas.offsetLeft;
            currY = e.touches[0].clientY - canvas.offsetTop;
            percentX = currX / canvas.width;
            percentY = currY / canvas.height;
            pageList[slideshow_index][lineNo][NextDotIndex].x = percentX;
            pageList[slideshow_index][lineNo][NextDotIndex].y = percentY;
            pageList[slideshow_index][lineNo].length += 1;
            draw();
        } else if (res === 'down') {
            currX = e.clientX - canvas.offsetLeft;
            currY = e.clientY - canvas.offsetTop;
            percentX = currX / canvas.width;
            percentY = currY / canvas.height;
            lineNo = pageList[slideshow_index].lineIndex + 1;
            pageList[slideshow_index].lineIndex += 1;
            pageList[slideshow_index].length = lineNo + 1;
            pageList[slideshow_index][lineNo] = {};
            pageList[slideshow_index][lineNo][0] = {}; 
            pageList[slideshow_index][lineNo][0].x = percentX;
            pageList[slideshow_index][lineNo][0].y = percentY;
            pageList[slideshow_index][lineNo].length = 1;
            pageList[slideshow_index][lineNo].color = LineColor;
            flag = true;
            ctx.beginPath();
            ctx.fillStyle = LineColor;
            ctx.fillRect(currX - 1, currY - 1, 2, 2);
            ctx.closePath();
        } else if (res === 'up' && flag) {
            lineNo = pageList[slideshow_index].lineIndex;
            flag = false;
            meeting.syncPoint('draw', hash, pageList[slideshow_index][lineNo]);
            drawPage();
        } else if (res === 'tDown') {
            e.preventDefault();
            currX = e.touches[0].clientX - canvas.offsetLeft;
            currY = e.touches[0].clientY - canvas.offsetTop;
            percentX = currX / canvas.width;
            percentY = currY / canvas.height;
            lineNo = pageList[slideshow_index].lineIndex + 1;
            pageList[slideshow_index].lineIndex += 1;
            pageList[slideshow_index].length = lineNo + 1;
            pageList[slideshow_index][lineNo] = {};
            pageList[slideshow_index][lineNo][0] = {}; 
            pageList[slideshow_index][lineNo][0].x = percentX;
            pageList[slideshow_index][lineNo][0].y = percentY;
            pageList[slideshow_index][lineNo].length = 1;
            pageList[slideshow_index][lineNo].color = LineColor;
            flag = true;
            ctx.beginPath();
            ctx.fillStyle = LineColor;
            ctx.fillRect(currX - 1, currY - 1, 2, 2);
            ctx.closePath();
        }
    }
}

function color(obj) {
    'use strict';
    LineColor = obj.id;
    document.getElementById('chooseColor').style.background=LineColor;
}

function erase() {
    'use strict';
    if (user_type === 'host') {
        var m = confirm("모두 지우시겟습니까?");

        if (m) {
            pageList[slideshow_index] = {};
            pageList[slideshow_index].length = 0;
            pageList[slideshow_index].lineIndex = -1;
            ctx.clearRect(0, 0, canvas.width, canvas.height);

            meeting.syncPoint('clear', hash, undefined);
        }
    } else {
        pageList[slideshow_index] = {};
        pageList[slideshow_index].length = 0;
        pageList[slideshow_index].lineIndex = -1;
        ctx.clearRect(0, 0, canvas.width, canvas.height);
    }
}

function undoCanvas() {
    'use strict';
    if(pageList[slideshow_index].lineIndex > -1) {
        pageList[slideshow_index].lineIndex -= 1;
    }
    drawPage();
    if (user_type === 'host') {
        meeting.syncPoint('undo', hash, undefined);
    }
}

function redoCanvas() {
    'use strict';
    if (pageList[slideshow_index].length - 1 > pageList[slideshow_index].lineIndex) {
        pageList[slideshow_index].lineIndex += 1;
    }
    drawPage();
    if (user_type === 'host') {
        meeting.syncPoint('redo', hash, undefined);
    }
}

function hideCanvas() {
    'use strict';
    if (document.getElementById('can').style.display === 'block') {
        document.getElementById('can').style.display = 'none';
    } else {
        document.getElementById('can').style.display = 'block';
    }
    if (user_type === 'host') {
        meeting.syncPoint('hide', hash, undefined);
    }
}
////////캔버스 함수 끝//////////
      /*
       0 : none
       1 : audio + 1:n
       2 : audio + 1:1
       3 : video + 1:n
       4 : video + 1:1
       */

       
function chatwrapOpen(e) {
    'use strict';
    var chatwrap = document.getElementById('chat_wrap');
    var chatwrapbutton = document.getElementById('chat_wrapButton');
    
    if (e.value === '▼') {
    	chatwrap.style.bottom = '-20%';
        e.value = '▲';
    } else {
    	chatwrap.style.bottom = '40px';
        e.value = '▼';
    }
}
       
function leftBarOpen(e) {
    'use strict';
    var leftBar = document.getElementById('left_bar');
    if (e.value === '◀') {
        leftBar.style.left = '-20%';
        e.value = '▶';
    } else {
        leftBar.style.left = '0';
        e.value = '◀';
    }
}
function rightBarOpen(e) {
    'use strict';
    var rightBar = document.getElementById('right_bar');
    if (e.value === '▶') {
        rightBar.style.right = '-15%';
        e.value = '◀';
    } else {
        rightBar.style.right = '0';
        e.value = '▶';
    }
}

    // ppt 선택
function Select_PPT(value) {
    'use strict';

    //나만하면됨
    meeting.selectfile(hash, value);
}

    // 채팅 메세지 전송
function Chat_msg() {
    'use strict';
    var chat_msg = document.getElementById('chat').value;
    document.getElementById('chat').value = '';


    $('#chat_a').append(u_name + ' : ' + chat_msg + '<br/>');
    $("#chat_a").scrollTop($("#chat_a")[0].scrollHeight);
    meeting.chat(hash, chat_msg, u_name);
}

    // ppt 이전 페이지로
function Slide_pre() {
    'use strict';
    var filename, index;
    index = document.getElementById('slide_i').value;

    if (parseInt(index, 10) > 1) {
        index = parseInt(index, 10) - 1;                   
        
        if (slideshow_status) {
            slideshow_index = index;
            filename = slideshow_file + '-' + slideshow_index + '.jpg';
            
            drawPage();
            meeting.control(hash, index);
        } else {
            slide_index = index;
            filename = file_name + '-' + slide_index + '.jpg';
        }
        slide_img.src = '.\\uploadStorage\\' + '${access_code}' + '\\' + filename;
        document.getElementById('slide_i').value = index; // 현재 슬라이드 인덱스 번호 표시
    }
}

    // ppt 다음 페이지로
function Slide_next() {
    'use strict';
    var filename, index;
    index = document.getElementById('slide_i').value;

    if (slideshow_status) {
        if (parseInt(index, 10) < slideshow_max) {
            index = parseInt(index, 10) + 1;
            slideshow_index = index;
            filename = slideshow_file + '-' + slideshow_index + '.jpg';

            drawPage();
            meeting.control(hash, index);
            
            slide_img.src = '.\\uploadStorage\\' + '${access_code}' + '\\' + filename;
            document.getElementById('slide_i').value = index; // 현재 슬라이드 인덱스 번호 표시
        }
    } else {
        if (parseInt(index, 10) < slide_max) {            
            index = parseInt(index, 10) + 1;
            slide_index = index;
            filename = file_name + '-' + slide_index + '.jpg';
            
            slide_img.src = '.\\uploadStorage\\' + '${access_code}' + '\\' + filename;
            document.getElementById('slide_i').value = index; // 현재 슬라이드 인덱스 번호 표시
        }
    }
}

    // 미니 뷰 이전페이지
function pSlide_pre() {
    'use strict';
    var t;
    if (parseInt(sub_index, 10) > 1) {
        t = '#slide' + sub_index;
        $(t).attr('style', 'display:none;');
        sub_index = parseInt(sub_index, 10) - 1;
        t = '#slide' + sub_index; 
        $(t).attr('style', 'display:block;');
    }
}

    // 미니 뷰 다음페이지
function pSlide_next() {
    'use strict';
    //var index = sub_index;
    var t;
    if (sub_index < sub_slide_max) {
        t = '#slide' + sub_index;
        $(t).attr('style', 'display:none;');
        sub_index = parseInt(sub_index, 10) + 1;
        t = '#slide' + sub_index;
        $(t).attr('style', 'display:block;');
    }
}

    // 슬라이드 쇼 시작하기
function Slide_show() {
    'use strict';
    var filename;
    $('#show_button').attr('onclick', 'Slide_stop()');
    $('#show_button').attr('value', '종료');
    slideshow_status = true; // 슬라이드쇼 진행 상태로 변경
    slideshow_file = file_name;
    slideshow_max = slide_max;
    slideshow_index = 1;

    filename = slideshow_file + '-1.jpg';

    slide_img.src = '.\\uploadStorage\\' + '${access_code}' + '\\' + filename; // 슬라이드 이미지
    document.getElementById('slide_i').value = '1'; // 현재 인덱스 표시
    $('#len').html(slideshow_max); // 총 슬라이드 장 수

    $('#preview').attr('style', 'display:none;');
    sub_slide_max = slide_max;
    sub_index = 1;

    // 하단 슬라이드 뷰어
    $('#test').html('');
    for (var i = 1; i <= slideshow_max; i += 1) {
        var file = './uploadStorage/' + '${access_code}' + '/' + slideshow_file + '-' + i + '.jpg';
        $('#test').append('<img id=\"slide'+i+'" style=\"display:none;\" class=\"slide_prev\" src=\"' + file + '\" />');
    }
    $('#pt_select').attr('style', 'width:0px;');

    // 하단 슬라이드 화면 활성화
    $('#slide1').attr('style', 'display:block;');
    $('#before_p').attr('style', 'cursor: pointer; display:block;');
    $('#next_p').attr('style', 'cursor: pointer; display:block;');
    
    // room,file,type
    meeting.slideShow(hash, file_name, slideshow_status);
}

     // 슬라이드 쇼 종료하기
function Slide_stop() {
    'use strict';
    var index;
    index = '#slide' + sub_index;
    $('#show_button').attr('onclick', 'Slide_show()');
    $('#show_button').attr('value', '시작');
    $(index).attr('style', 'display:none;');
    
    $('#test').html('');
    $('#test').append('<img id=\"preview\" alt=\"preview\" class=\"slide_prev\" src=\"./image/prev.png\" />');
    
    
    request_user = null;
    request_list = new Array();

    initCanvasPage();

    meeting.slideShow(hash, file_name, false);
}

// 권한 요청
function c_Request() {    
    $('#request_button').attr('onclick', 'Request_cancel()');
    $('#request_button').attr('value', '요청 취소');
    meeting.c_request(hash, u_id);
}

// 거절
function refuse(receiver) {
    var id, index;
       id = '#' + receiver + '_btn';
       $(id).html('');
       
       // 권한 요청 리스트에서 제거하기
    index = request_list.indexOf(receiver);
    request_list.splice(index,1);
       
    meeting.refuse(hash, receiver);
}
     
// 요청 취소
function Request_cancel() {
    $('#request_button').attr('onclick', 'c_Request()');
    $('#request_button').attr('value', '권한 요청');
    meeting.request_cancel(hash, u_id);
}
     
// 슬라이드 권한 요청 종료(방장이)
function Request_stop(receiver) {
    meeting.request_stop(hash, receiver);
}

    // 요청 수락하기 
function c_Accept(receiver) {
    var id, index;
    request_user = receiver;
    id = '#' + receiver + '_btn';
    $(id).html('<input type=\"button\" style=\"font-size:0.8em; float:right;\" value=\"종료\" onclick=\"Request_stop(\'' + receiver + '\')\"/>');
    
    index = request_list.indexOf(receiver);
    request_list.splice(index,1);
    
    for(var i in request_list) {        
        var elem = document.getElementById(request_list[i] + '_btn');
        elem.children[0].setAttribute("disabled",true);
        elem.children[1].setAttribute("disabled",true);
    }
    
    meeting.c_accept(hash, receiver);
}

    // url 생성    
function copyThis() {
    'use strict';
    var url;
    url = 'http://220.69.203.93/SyncPT_project/Access?access_code=${access_code}${media_type}';
    prompt('Ctrl + C를 누르시면 복사를 할 수있습니다.\n모바일 브라우저는 현재 창을 닫고 \n공유 버튼을 롱 클릭 하여 \n링크 복사를 선택해 주십시오.', url);
}

    // 중간에 시그널링 시도
function trySignaling() {
    if ((user_type !== 'host') && (navigator.mozGetUserMedia || navigator.webkitGetUserMedia)) {
        if (trySignalActive) {
            meeting.onmeeting(hash);
        } else {
            alert('미디어 접속인원이 초과되었습니다.');
        }
    }
}

function toggleMic() {
    'use strict';
    var tracks = localstream.getAudioTracks();
    for (var i = 0; i < tracks.length; i += 1) {
        tracks[i].enabled = !tracks[i].enabled;
    }
    if (tracks[0].enabled) {
        document.getElementById('MicButton').src = './image/micOn.png';
    } else {
        document.getElementById('MicButton').src = './image/micOff.png';
    }
}
function volumeControl (evt) {
    var myVid = remoteMediaStreams.firstElementChild;
    if (myVid) {    
        if (evt.id === 'mute') {
            myVid.muted = !myVid.muted;
            if (myVid.muted) {
                evt.src = './image/speakerOff.png';
            } else {
                evt.src = './image/speakerOn.png';
            }
        } else if (evt.id === 'volUp') {
            if( myVid.volume < 1) {
                myVid.volume += 0.2;
            }
            
        } else{
            if( myVid.volume > 0) {
                myVid.volume -= 0.2;
            }
        }
    }
}
    
    // 방 입장
sock.on('enter', function (data) {
    'use strict';    
    if(data.userid === u_id) { // 새로 접속한 경우
        console.log(data);
        var i, list, filename;
        list = data.user_list;
        
        $('#user_info').html(''); // 접속자 리스트 초기화
        
        // 방장, 자기자신, 나머지 순
        if (data.host !== u_id) {
            $('#user_info').append('<div id=\"'+ data.host +'\" style=\"overflow: hidden; height:1.0em; width:100%; background-color:rgba(255,51,51,0.4); margin-top:2px; color:white;\">'
            + '<div class=\"textdot\" style=\"width:50%; float:left; font-size:0.8em; box_siging:border-box;\">' + data.hostname + '</div>'
            + '<div class=\"button_group\" style=\"height:1.0em; width:50%; float:left; font-size:0.8em; box_siging:border-box;\" id=\"'+ data.host +'_btn\"></div></div>');
        }
        $('#user_info').append('<div id=\"'+ data.userid +'\" style=\"overflow: hidden; height:1.0em; width:100%; background-color:rgba(51,200,51,0.4); margin-top:2px; color:white;\">'
        + '<div class=\"textdot\" style=\"width:50%; float:left; font-size:0.8em; box_siging:border-box;\">' + data.username + '</div>'
        + '<div class=\"button_group\" style=\"height:1.0em; width:50%; float:left; font-size:0.8em; box_siging:border-box;\" id=\"'+ data.userid +'_btn\"></div></div>');
        
        for (i = 0; i < list.length; i += 1) {
            if(list[i].user_id!==data.host) {
                $('#user_info').append('<div id=\"'+ list[i].user_id +'\" style=\"overflow: hidden; height:1.0em; width:100%; background-color:rgba(0,0,0,0.4); margin-top:2px; color:white;\">'
                + '<div class=\"textdot\" style=\"width:50%; float:left; font-size:0.8em; box_siging:border-box;\">' + list[i].user_name + '</div>'
                + '<div class=\"button_group\" style=\"height:1.0em; width:50%; float:left; font-size:0.8em; box_siging:border-box;\" id=\"'+ list[i].user_id +'_btn\"></div></div>');
            }               
        }
        
        filename = file_name + '-' + slide_index + '.jpg';
        slide_img.src = '.\\uploadStorage\\' + '${access_code}' + '\\' + filename;
        document.getElementById('slide_i').value = slide_index;
        
        document.getElementById('download_path').setAttribute('href','.\\uploadStorage\\' + '${access_code}' + '\\' + file_name);        
    }
    else { // 기존에 접속한 경우 
        $('#user_info').append('<div id=\"'+ data.userid +'\" style=\"overflow: hidden; height:1.0em; width:100%; background-color:rgba(0,0,0,0.4); margin-top:2px; color:white;\">'
        + '<div class=\"textdot\" style=\"width:50%; float:left; font-size:0.8em; box_siging:border-box;\">' + data.user_name + '</div>'
        + '<div class=\"button_group\" style=\"height:1.0em; width:50%; float:left; font-size:0.8em; box_siging:border-box;\" id=\"'+ data.userid +'_btn\"></div></div>');
    }
});

sock.on('page_control', function (data) {
    'use strict';
    var filename;
    
    slideshow_index = data.index;
    filename = slideshow_file + '-' + data.index + '.jpg';   // 동기화 x                   
    slide_img.src = '.\\uploadStorage\\' + '${access_code}' + '\\' + filename;
    document.getElementById('slide_i').value = slideshow_index; // 현재 슬라이드 인덱스 번호 표시
    drawPage();
});

sock.on('select_file', function (data) {
    'use strict';
    var filename;
    file_name = data.file; // 선택된 ppt파일 이름           
    slide_max = data.count; // 선택한 파일 슬라이드의 전체 수   
    slide_index = 1; // 메인 뷰어 슬라이드 인덱스 

    $('#len').html(slide_max); // 총 슬라이드 갯수 보여주기                          
    filename = file_name + '-' + '1.jpg'; // 선택한 ppt의 첫번째 슬라이드 화면 이미지
    document.getElementById('slide_img').src = '.\\uploadStorage\\' + '${access_code}' + '\\' + filename; // 슬라이드 첫 화면 보여주기
    document.getElementById('slide_i').value = '1'; // 현재 페이지 슬라이드 번호
    
    document.getElementById('download_path').setAttribute('href','.\\uploadStorage\\' + '${access_code}' + '\\' + file_name);
});

sock.on('show_start', function (data) {
    'use strict';
    var i, filename;

    slideshow_status = true; // 슬라이드쇼 진행 상태로 변경
    slideshow_file = data.file;
    slideshow_max = data.count;
    slideshow_index = 1;

    filename = slideshow_file + '-1.jpg';

    slide_img.src = '.\\uploadStorage\\' + '${access_code}' + '\\' + filename; // 슬라이드 이미지
    document.getElementById('slide_i').value = '1'; // 현재 인덱스 표시
    $('#len').html(slideshow_max); // 총 슬라이드 장 수

    // 슬라이드쇼가 진행되는 동안 메인 슬라이드 제어 권한 제거
    $('#request_button').attr('onclick', 'c_Request()');
    $('#request_button').attr('value', '권한 요청');
    $('#request_button').attr('style','display:block;');

    $('#next').attr('style', 'display:none;');
    $('#before').attr('style', 'display:none;');
    $('#preview').attr('style', 'display:none;');
    sub_slide_max = slideshow_max;
    sub_index = 1;

    // 하단 슬라이드 뷰어
    $('#test').html('');
    for (i = 1; i <= slideshow_max; i += 1) {
        var file = './uploadStorage/' + '${access_code}' + '/' + slideshow_file + '-' + i + '.jpg';
        $('#test').append('<img id=\"slide'+i+'" style=\"display:none;\" class=\"slide_prev\" src=\"' + file + '\" />');
    }
    $('#pt_select').attr('style', 'width:0px;');

    // 하단 슬라이드 화면 활성화
    $('#slide1').attr('style', 'display:block;');
    $('#before_p').attr('style', 'cursor: pointer; display:block;');
    $('#next_p').attr('style', 'cursor: pointer; display:block;');
});

sock.on('show_stop', function (data) {
    'use strict';
    var filename, index;

    $(".button_group").html('');

    slideshow_status = false; // 슬라이드쇼 진행 상태 변경

    filename = file_name + '-' + slide_index + '.jpg'; // 슬라이드쇼 진행되기 이전으로 돌아가기
    slide_img.src = '.\\uploadStorage\\' + '${access_code}' + '\\' + filename;
    index = '#slide' + sub_index;

    document.getElementById('slide_i').value = slide_index; // 슬라이드쇼 시작 이전에 보던 슬라이드 인덱스
    $('#len').html(slide_max); // 총 슬라이드 장 수

    $('#pt_select').attr('style', 'width:80px;');

    $('#preview').attr('style', 'display:block;');
    $('#next').attr('style', 'display:block;');
    $('#before').attr('style', 'display:block;');
    $(index).attr('style', 'display:none;');
    $('#before_p').attr('style', 'cursor: pointer; display:none;');
    $('#next_p').attr('style', 'cursor: pointer; display:none;');

    $('#test').append('<img id=\"preview\" alt=\"preview\" class=\"slide_prev\" src=\"./image/prev.png\" />');
    if(user_type !== 'host') {
        initCanvasPage();
        $('#request_button').attr('style','display:none;');
    }
});

sock.on('chat', function (data) {
    'use strict';
    $('#chat_a').append(data.u_name + ' : ' + data.chat_msg + '<br/>');
    $("#chat_a").scrollTop($("#chat_a")[0].scrollHeight);
});


sock.on('signalFlag', function (data) {
    'use strict';
    var contents;
    if (user_type !== 'host') {
        if (data.userid === u_id) { // 접속한 참여자
            meeting.setInRtc(data.result);
            if (!data.result) {
                contents = document.getElementById('self');
                localMediaStream.removeChild(contents);
                document.getElementById('mediaBox1').style.display = 'none';
                document.getElementById('mediaBox2').style.display = 'none';
            } else {
                if (media_type === '1') {
                    document.getElementById('mediaBox3').style.display = 'block';
                } else if (media_type === '2') {
                    document.getElementById('mediaBox1').style.display = 'block';
                    document.getElementById('mediaBox3').style.display = 'block';
                } else if (media_type === '3') {
                    document.getElementById('mediaBox2').style.display = 'block';
                } else if (media_type === '4') {
                    document.getElementById('mediaBox4').style.display = 'block';
                    document.getElementById('mediaBox2').style.display = 'block';
                }
            }
        } else { // 나머지
            trySignalActive = data.available;
        }
    }
});

sock.on('syncPoint', function (data) {
    'use strict';
    var lineNo;
    if (data.action === 'draw') {
        lineNo = pageList[slideshow_index].lineIndex + 1;
        pageList[slideshow_index].lineIndex += 1;
        pageList[slideshow_index].length = lineNo + 1;
        pageList[slideshow_index][lineNo] = data.linedata;

        drawPage();
    } else if (data.action === 'undo') {
        undoCanvas();
    } else if (data.action === 'redo') {
        redoCanvas();
    } else if (data.action === 'hide') {
        hideCanvas();
    } else {
        erase();
    }
});

//권한 요청
sock.on('c_request', function (data) {
    var id;
    if(user_type === 'host') {
        request_list.push(data.from); // 권한 요청 리스트 
        if(request_user!=null) { // 권한 획득한 사용자가 있음
            id = '#' + data.from + '_btn';
            $(id).append('<input type=\"button\" style=\"float:right; font-size:0.8em;\" disabled=\"true\" value=\"수락\" onclick=\"c_Accept(\'' + data.from + '\')\"/>');
            $(id).append('<input type=\"button\" style=\"float:right; font-size:0.8em;\" disabled=\"true\" value=\"거절\" onclick=\"refuse(\''+ data.from + '\')\"/>');
        } else { // 권한을 획득한 사용자가 없음
            id = '#' + data.from + '_btn';
            $(id).append('<input type=\"button\" style=\"float:right; font-size:0.8em;\" value=\"수락\" onclick=\"c_Accept(\'' + data.from + '\')\"/>');
            $(id).append('<input type=\"button\" style=\"float:right; font-size:0.8em;\" value=\"거절\" onclick=\"refuse(\''+ data.from + '\')\"/>');
        }
    }  
});

//권한 수락
sock.on('c_accept', function (data) {
    var id;
    if(data.receiver === u_id) { // 권한을 부여받은 참여자
        // 슬라이드 통제권 주기
        $('#request_button').attr('onclick', 'Request_stop(\''+ u_id +'\')');
        $('#request_button').attr('value', '권한 종료');
        $('#next').attr('style', 'display:block;');
        $('#before').attr('style', 'display:block;');
    } else {
        id = '#' + data.receiver + '_btn';
        $(id).html('(권한 획득)');
    }
});

//권한 요청 종료
sock.on('request_stop', function (data) {
    if(data.receiver === u_id) {
        $('#request_button').attr('onclick', 'c_Request()');
        $('#request_button').attr('value', '권한 요청');

        $('#next').attr('style', 'display:none;');
        $('#before').attr('style', 'display:none;');
    }
    else if(user_type === 'host') {
        var id = '#' + data.receiver + '_btn';
        $(id).html('');
        
        request_user = null;
        
        for(var i in request_list) {   
            var elem = document.getElementById(request_list[i] + '_btn');
            elem.children[0].removeAttribute("disabled");
            elem.children[1].removeAttribute("disabled");
        }
    }
    else {
        $('#request_button').attr('disabled',false);
        var id = '#' + data.receiver + '_btn';
        $(id).html('');
    }
});

//권한 요청 중지
sock.on('request_cancel', function (data) {
    var id,index;
    if(user_type === 'host') {
        id = '#' + data.receiver + '_btn';
        $(id).html('');
        
        index = request_list.indexOf(data.receiver);
        request_list.splice(index,1);
    }
});

//권한 거절
sock.on('refuse', function (data) {
    if(data.receiver === u_id) {
        alert('권한 요청이 거부되었습니다.');
        $('#request_button').attr('onclick', 'c_Request()');
        $('#request_button').attr('value', '권한 요청');
    }
});

//방정보 초기화
sock.on('tryRoomInfo', function (data) {
    if (user_type === 'host' && slideshow_status) {
        meeting.tryRoomInfo(hash, data.userid, slideshow_file, slideshow_index, slideshow_max, canvas.style.display, pageList);
    } else if (data.userid === u_id) {
        canvas.style.display = data.hide;
        slideshow_status = true;
           slideshow_file = data.file;
        slideshow_max = data.max;
           slideshow_index = data.index;
           filename = slideshow_file + '-' + slideshow_index + '.jpg';
        slide_img.src = '.\\uploadStorage\\' + '${access_code}' + '\\' + filename;
        document.getElementById('slide_i').value = slideshow_index;
        $('#len').html(slideshow_max); // 총 슬라이드 장 수
        
        $('#request_button').attr('onclick', 'c_Request()');
        $('#request_button').attr('value', '권한 요청');
        $('#request_button').attr('style','display:block;');
        $('#pt_select').attr('style', 'width:0px;');
        $('#next').attr('style', 'display:none;');
        $('#before').attr('style', 'display:none;');
        $('#preview').attr('style', 'display:none;');

        sub_index = 1;
        sub_slide_max = slideshow_max;
            
        // 하단 슬라이드 뷰어
        $('#test').html('');
        for (var i = 1; i <= slideshow_max; i += 1) {
            var file = './uploadStorage/' + '${access_code}' + '/' + slideshow_file + '-' + i + '.jpg';
            $('#test').append('<img id=\"slide'+i+'" style=\"display:none;\" class=\"slide_prev\" src=\"' + file + '\" />');
        }

        // 하단 슬라이드 화면 활성화
        $('#slide1').attr('style', 'display:block;');
        $('#before_p').attr('style', 'cursor: pointer; display:block;');
        $('#next_p').attr('style', 'cursor: pointer; display:block;');
        
        pageList = data.point;
        drawPage();
    }
});

function doResize() {
    'use strict';
    var tp, le, wid, hei;
    tp = slide_img.offsetTop;
    le = slide_img.offsetLeft;
    wid = slide_img.clientWidth;
    hei = slide_img.clientHeight;
    canvas.style.top = tp + "px";
    canvas.style.left = le + "px";
    canvas.width = wid;
    canvas.height = hei;
    drawPage();
}
window.onresize = doResize;
document.getElementById('slide_img').onload = doResize;
	</script>
</body>
</html>