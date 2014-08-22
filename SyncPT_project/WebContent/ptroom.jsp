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
						<input type="button" value="��" id="leftBarButton" onclick="leftBarOpen(this)" />
					</div>
					<div style="float: right; height: 100%; width: 100%;">
						<div style="width: 100%; height: 7%; box-sizing: border-box;">
							<c:choose>
								<c:when test="${ u_type == 'host'}">
									<input id="show_button" type="button" class="start_button" value="����" onclick="Slide_show()" />
								</c:when>
								<c:otherwise>
									<input id="request_button" type="button" class="start_button" value="���� ��û" onclick="c_Request()" style="display: none;" />
								</c:otherwise>
							</c:choose>
						</div>
						<div style="width: 100%; height: 93%; padding: 2%; box-sizing: border-box; background-color: rgba(0, 0, 0, 0.4); position: relative;">
							<div style="color: cornflowerblue;">
								<div>���� ����</div>
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
								<div>��ũ �ּ�</div>
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
											<input type="button" class="ink_button" value="�����" onclick="erase()" />
										</div>
									</div>
									<div class="box2">
										<div class="content">
											<input type="button" class="ink_button" value="�����" onclick="hideCanvas()" />
										</div>
									</div>
									<div class="box2">
										<div class="content">
											<input type="button" class="ink_button" value="�������" onclick="undoCanvas()" />
										</div>
									</div>
									<div class="box2">
										<div class="content">
											<input type="button" class="ink_button" value="�ٽý���" onclick="redoCanvas()" />
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
								<a href="http://220.69.203.93:8080/SyncPT_project/Access?access_code=${access_code}${media_type}" class="start_button" onclick="copyThis(); return false;">��ũ ����</a>
							</div>
							<div>
								<input type="button" class="start_button" value="�̵�� ����" id="trySignalButton" onclick="trySignaling()" />
							</div>
							<div>
								<a class="start_button" id="download_path" href="#" onclick="window.open(this.href, '', ''); return false;">���� �ٿ�ε�</a>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div id="right_bar">
			<div style="float: left; height: 100%; position: relative; background: red;">
				<input type="button" value="��" id="rightBarButton" onclick="rightBarOpen(this)" />
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
		<input type="button" value="��" id="chat_wrapButton" style="float: left;" onclick="chatwrapOpen(this)" />
	</div>
	<script type="text/javascript">
var u_id = '${u_id}';
var u_name = '${u_name}';
var user_type = '${u_type}';
var slideshow_status = false; // �����̵�� ������� 
var slideshow_file; // �����̵�� ����Ǵ� ���� �̸�
var slideshow_index = 1; // �����̵�� �ε��� 
var slideshow_max; // �����̵�� ���� �����̵� �� ��

var file_name = '${file_name}'; // ����ڰ� ������ ���� �̸� 
var slide_max = '${slide_count}'; // ������ ���� �����̵��� ��ü ��   
var slide_index = 1; // ���� ��� �����̵� �ε���

var sub_index = 1; // �ϴ� ��� �����̵� �ε���
var sub_slide_max = 1; // �ϴ� ��� �����̵� ��ü ��

//rtc����
var media_type = '${media_type}'; //
var isOpen = '${isopen}';

var brtype;
var conntype;
var sock;
var trySignalActive = false;

//���� ��û ����
var request_list = new Array(); // ���� ��û ���� �����ڵ� 
var request_user; // ������ �ο����� ������

///////////ĵ���� �������� ///////////
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

// ĵ���� ����
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

//rtc����
var hash = '${access_code}'; // ������ �ڵ�
var meeting = new Meeting(hash, brtype, conntype, u_id);

var localMediaStream = document.getElementById('local_media');
var remoteMediaStreams = document.getElementById('remote_media');
var localstream; // ��� ��ư ���� ���ؼ� ��Ʈ�� ����

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
    sock = io.connect('http://220.69.203.93:8888/').on('message', callback);
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
        alert("������ ȸ�Ǹ� ������׽��ϴ�. ���� ȭ������ �̵��մϴ�.");
        location.href='index.jsp';
    }
};

    // check pre-created meeting rooms
    // it is useful to auto-join
    // or search pre-created sessions
    // 0�ܰ�
    // signaler Init for client
meeting.check(); // ���ʿ���

    // 1�ܰ�
    // �����̸� ���� ���� �����Ѵ�.
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
// 2�ܰ�
if ((brtype !== 'none') && (navigator.mozGetUserMedia || navigator.webkitGetUserMedia)) { // �̵� ����Ѵ�. 
    if (user_type === 'host') { // ����
        meeting.setup(hash, isOpen); // ����
    } else { // ������
        meeting.onmeeting(hash);
    }
}

// 3�ܰ�
// ������ �ʱ�ȭ
if (user_type !== 'host') {
    meeting.tryOfferInfo(hash, u_id);
}

    // 4�ܰ�
    // �� ���� flag ����

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
$('#chat').keypress(function (e) { //ũ�� ������ esc�̺�Ʈ 1ȸ ���� ���� (�̹��� ��� �ȵ� ����)
    'use strict';
    if (e.keyCode === 13) {
        Chat_msg();
    }
});

$(document).keyup(function (e) { //ũ�� ������ esc�̺�Ʈ 1ȸ ���� ���� (�̹��� ��� �ȵ� ����)
    'use strict';
    if (e.keyCode === 27) {
        $('#full_button').attr('src', './image/full.png');
    }
});
$(document).keydown(function (e) { //f11 ��üȭ�� ���� (��� �̹��� �� screenfull.js ���� ����)
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
        var m = confirm("��� ����ðٽ��ϱ�?");

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
////////ĵ���� �Լ� ��//////////
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
    
    if (e.value === '��') {
    	chatwrap.style.bottom = '-20%';
        e.value = '��';
    } else {
    	chatwrap.style.bottom = '40px';
        e.value = '��';
    }
}
       
function leftBarOpen(e) {
    'use strict';
    var leftBar = document.getElementById('left_bar');
    if (e.value === '��') {
        leftBar.style.left = '-20%';
        e.value = '��';
    } else {
        leftBar.style.left = '0';
        e.value = '��';
    }
}
function rightBarOpen(e) {
    'use strict';
    var rightBar = document.getElementById('right_bar');
    if (e.value === '��') {
        rightBar.style.right = '-15%';
        e.value = '��';
    } else {
        rightBar.style.right = '0';
        e.value = '��';
    }
}

    // ppt ����
function Select_PPT(value) {
    'use strict';

    //�����ϸ��
    meeting.selectfile(hash, value);
}

    // ä�� �޼��� ����
function Chat_msg() {
    'use strict';
    var chat_msg = document.getElementById('chat').value;
    document.getElementById('chat').value = '';


    $('#chat_a').append(u_name + ' : ' + chat_msg + '<br/>');
    $("#chat_a").scrollTop($("#chat_a")[0].scrollHeight);
    meeting.chat(hash, chat_msg, u_name);
}

    // ppt ���� ��������
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
        document.getElementById('slide_i').value = index; // ���� �����̵� �ε��� ��ȣ ǥ��
    }
}

    // ppt ���� ��������
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
            document.getElementById('slide_i').value = index; // ���� �����̵� �ε��� ��ȣ ǥ��
        }
    } else {
        if (parseInt(index, 10) < slide_max) {            
            index = parseInt(index, 10) + 1;
            slide_index = index;
            filename = file_name + '-' + slide_index + '.jpg';
            
            slide_img.src = '.\\uploadStorage\\' + '${access_code}' + '\\' + filename;
            document.getElementById('slide_i').value = index; // ���� �����̵� �ε��� ��ȣ ǥ��
        }
    }
}

    // �̴� �� ����������
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

    // �̴� �� ����������
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

    // �����̵� �� �����ϱ�
function Slide_show() {
    'use strict';
    var filename;
    $('#show_button').attr('onclick', 'Slide_stop()');
    $('#show_button').attr('value', '����');
    slideshow_status = true; // �����̵�� ���� ���·� ����
    slideshow_file = file_name;
    slideshow_max = slide_max;
    slideshow_index = 1;

    filename = slideshow_file + '-1.jpg';

    slide_img.src = '.\\uploadStorage\\' + '${access_code}' + '\\' + filename; // �����̵� �̹���
    document.getElementById('slide_i').value = '1'; // ���� �ε��� ǥ��
    $('#len').html(slideshow_max); // �� �����̵� �� ��

    $('#preview').attr('style', 'display:none;');
    sub_slide_max = slide_max;
    sub_index = 1;

    // �ϴ� �����̵� ���
    $('#test').html('');
    for (var i = 1; i <= slideshow_max; i += 1) {
        var file = './uploadStorage/' + '${access_code}' + '/' + slideshow_file + '-' + i + '.jpg';
        $('#test').append('<img id=\"slide'+i+'" style=\"display:none;\" class=\"slide_prev\" src=\"' + file + '\" />');
    }
    $('#pt_select').attr('style', 'width:0px;');

    // �ϴ� �����̵� ȭ�� Ȱ��ȭ
    $('#slide1').attr('style', 'display:block;');
    $('#before_p').attr('style', 'cursor: pointer; display:block;');
    $('#next_p').attr('style', 'cursor: pointer; display:block;');
    
    // room,file,type
    meeting.slideShow(hash, file_name, slideshow_status);
}

     // �����̵� �� �����ϱ�
function Slide_stop() {
    'use strict';
    var index;
    index = '#slide' + sub_index;
    $('#show_button').attr('onclick', 'Slide_show()');
    $('#show_button').attr('value', '����');
    $(index).attr('style', 'display:none;');
    
    $('#test').html('');
    $('#test').append('<img id=\"preview\" alt=\"preview\" class=\"slide_prev\" src=\"./image/prev.png\" />');
    
    
    request_user = null;
    request_list = new Array();

    initCanvasPage();

    meeting.slideShow(hash, file_name, false);
}

// ���� ��û
function c_Request() {    
    $('#request_button').attr('onclick', 'Request_cancel()');
    $('#request_button').attr('value', '��û ���');
    meeting.c_request(hash, u_id);
}

// ����
function refuse(receiver) {
    var id, index;
       id = '#' + receiver + '_btn';
       $(id).html('');
       
       // ���� ��û ����Ʈ���� �����ϱ�
    index = request_list.indexOf(receiver);
    request_list.splice(index,1);
       
    meeting.refuse(hash, receiver);
}
     
// ��û ���
function Request_cancel() {
    $('#request_button').attr('onclick', 'c_Request()');
    $('#request_button').attr('value', '���� ��û');
    meeting.request_cancel(hash, u_id);
}
     
// �����̵� ���� ��û ����(������)
function Request_stop(receiver) {
    meeting.request_stop(hash, receiver);
}

    // ��û �����ϱ� 
function c_Accept(receiver) {
    var id, index;
    request_user = receiver;
    id = '#' + receiver + '_btn';
    $(id).html('<input type=\"button\" style=\"font-size:0.8em; float:right;\" value=\"����\" onclick=\"Request_stop(\'' + receiver + '\')\"/>');
    
    index = request_list.indexOf(receiver);
    request_list.splice(index,1);
    
    for(var i in request_list) {        
        var elem = document.getElementById(request_list[i] + '_btn');
        elem.children[0].setAttribute("disabled",true);
        elem.children[1].setAttribute("disabled",true);
    }
    
    meeting.c_accept(hash, receiver);
}

    // url ����    
function copyThis() {
    'use strict';
    var url;
    url = 'http://220.69.203.93:8080/SyncPT_project/Access?access_code=${access_code}${media_type}';
    prompt('Ctrl + C�� �����ø� ���縦 �� ���ֽ��ϴ�.\n����� �������� ���� â�� �ݰ� \n���� ��ư�� �� Ŭ�� �Ͽ� \n��ũ ���縦 ������ �ֽʽÿ�.', url);
}

    // �߰��� �ñ׳θ� �õ�
function trySignaling() {
    if ((user_type !== 'host') && (navigator.mozGetUserMedia || navigator.webkitGetUserMedia)) {
        if (trySignalActive) {
            meeting.onmeeting(hash);
        } else {
            alert('�̵�� �����ο��� �ʰ��Ǿ����ϴ�.');
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
    
    // �� ����
sock.on('enter', function (data) {
    'use strict';    
    if(data.userid === u_id) { // ���� ������ ���
        console.log(data);
        var i, list, filename;
        list = data.user_list;
        
        $('#user_info').html(''); // ������ ����Ʈ �ʱ�ȭ
        
        // ����, �ڱ��ڽ�, ������ ��
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
    else { // ������ ������ ��� 
        $('#user_info').append('<div id=\"'+ data.userid +'\" style=\"overflow: hidden; height:1.0em; width:100%; background-color:rgba(0,0,0,0.4); margin-top:2px; color:white;\">'
        + '<div class=\"textdot\" style=\"width:50%; float:left; font-size:0.8em; box_siging:border-box;\">' + data.user_name + '</div>'
        + '<div class=\"button_group\" style=\"height:1.0em; width:50%; float:left; font-size:0.8em; box_siging:border-box;\" id=\"'+ data.userid +'_btn\"></div></div>');
    }
});

sock.on('page_control', function (data) {
    'use strict';
    var filename;
    
    slideshow_index = data.index;
    filename = slideshow_file + '-' + data.index + '.jpg';   // ����ȭ x                   
    slide_img.src = '.\\uploadStorage\\' + '${access_code}' + '\\' + filename;
    document.getElementById('slide_i').value = slideshow_index; // ���� �����̵� �ε��� ��ȣ ǥ��
    drawPage();
});

sock.on('select_file', function (data) {
    'use strict';
    var filename;
    file_name = data.file; // ���õ� ppt���� �̸�           
    slide_max = data.count; // ������ ���� �����̵��� ��ü ��   
    slide_index = 1; // ���� ��� �����̵� �ε��� 

    $('#len').html(slide_max); // �� �����̵� ���� �����ֱ�                          
    filename = file_name + '-' + '1.jpg'; // ������ ppt�� ù��° �����̵� ȭ�� �̹���
    document.getElementById('slide_img').src = '.\\uploadStorage\\' + '${access_code}' + '\\' + filename; // �����̵� ù ȭ�� �����ֱ�
    document.getElementById('slide_i').value = '1'; // ���� ������ �����̵� ��ȣ
    
    document.getElementById('download_path').setAttribute('href','.\\uploadStorage\\' + '${access_code}' + '\\' + file_name);
});

sock.on('show_start', function (data) {
    'use strict';
    var i, filename;

    slideshow_status = true; // �����̵�� ���� ���·� ����
    slideshow_file = data.file;
    slideshow_max = data.count;
    slideshow_index = 1;

    filename = slideshow_file + '-1.jpg';

    slide_img.src = '.\\uploadStorage\\' + '${access_code}' + '\\' + filename; // �����̵� �̹���
    document.getElementById('slide_i').value = '1'; // ���� �ε��� ǥ��
    $('#len').html(slideshow_max); // �� �����̵� �� ��

    // �����̵� ����Ǵ� ���� ���� �����̵� ���� ���� ����
    $('#request_button').attr('onclick', 'c_Request()');
    $('#request_button').attr('value', '���� ��û');
    $('#request_button').attr('style','display:block;');

    $('#next').attr('style', 'display:none;');
    $('#before').attr('style', 'display:none;');
    $('#preview').attr('style', 'display:none;');
    sub_slide_max = slideshow_max;
    sub_index = 1;

    // �ϴ� �����̵� ���
    $('#test').html('');
    for (i = 1; i <= slideshow_max; i += 1) {
        var file = './uploadStorage/' + '${access_code}' + '/' + slideshow_file + '-' + i + '.jpg';
        $('#test').append('<img id=\"slide'+i+'" style=\"display:none;\" class=\"slide_prev\" src=\"' + file + '\" />');
    }
    $('#pt_select').attr('style', 'width:0px;');

    // �ϴ� �����̵� ȭ�� Ȱ��ȭ
    $('#slide1').attr('style', 'display:block;');
    $('#before_p').attr('style', 'cursor: pointer; display:block;');
    $('#next_p').attr('style', 'cursor: pointer; display:block;');
});

sock.on('show_stop', function (data) {
    'use strict';
    var filename, index;

    $(".button_group").html('');

    slideshow_status = false; // �����̵�� ���� ���� ����

    filename = file_name + '-' + slide_index + '.jpg'; // �����̵�� ����Ǳ� �������� ���ư���
    slide_img.src = '.\\uploadStorage\\' + '${access_code}' + '\\' + filename;
    index = '#slide' + sub_index;

    document.getElementById('slide_i').value = slide_index; // �����̵�� ���� ������ ���� �����̵� �ε���
    $('#len').html(slide_max); // �� �����̵� �� ��

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
        if (data.userid === u_id) { // ������ ������
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
        } else { // ������
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

//���� ��û
sock.on('c_request', function (data) {
    var id;
    if(user_type === 'host') {
        request_list.push(data.from); // ���� ��û ����Ʈ 
        if(request_user!=null) { // ���� ȹ���� ����ڰ� ����
            id = '#' + data.from + '_btn';
            $(id).append('<input type=\"button\" style=\"float:right; font-size:0.8em;\" disabled=\"true\" value=\"����\" onclick=\"c_Accept(\'' + data.from + '\')\"/>');
            $(id).append('<input type=\"button\" style=\"float:right; font-size:0.8em;\" disabled=\"true\" value=\"����\" onclick=\"refuse(\''+ data.from + '\')\"/>');
        } else { // ������ ȹ���� ����ڰ� ����
            id = '#' + data.from + '_btn';
            $(id).append('<input type=\"button\" style=\"float:right; font-size:0.8em;\" value=\"����\" onclick=\"c_Accept(\'' + data.from + '\')\"/>');
            $(id).append('<input type=\"button\" style=\"float:right; font-size:0.8em;\" value=\"����\" onclick=\"refuse(\''+ data.from + '\')\"/>');
        }
    }  
});

//���� ����
sock.on('c_accept', function (data) {
    var id;
    if(data.receiver === u_id) { // ������ �ο����� ������
        // �����̵� ������ �ֱ�
        $('#request_button').attr('onclick', 'Request_stop(\''+ u_id +'\')');
        $('#request_button').attr('value', '���� ����');
        $('#next').attr('style', 'display:block;');
        $('#before').attr('style', 'display:block;');
    } else {
        id = '#' + data.receiver + '_btn';
        $(id).html('(���� ȹ��)');
    }
});

//���� ��û ����
sock.on('request_stop', function (data) {
    if(data.receiver === u_id) {
        $('#request_button').attr('onclick', 'c_Request()');
        $('#request_button').attr('value', '���� ��û');

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

//���� ��û ����
sock.on('request_cancel', function (data) {
    var id,index;
    if(user_type === 'host') {
        id = '#' + data.receiver + '_btn';
        $(id).html('');
        
        index = request_list.indexOf(data.receiver);
        request_list.splice(index,1);
    }
});

//���� ����
sock.on('refuse', function (data) {
    if(data.receiver === u_id) {
        alert('���� ��û�� �źεǾ����ϴ�.');
        $('#request_button').attr('onclick', 'c_Request()');
        $('#request_button').attr('value', '���� ��û');
    }
});

//������ �ʱ�ȭ
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
        $('#len').html(slideshow_max); // �� �����̵� �� ��
        
        $('#request_button').attr('onclick', 'c_Request()');
        $('#request_button').attr('value', '���� ��û');
        $('#request_button').attr('style','display:block;');
        $('#pt_select').attr('style', 'width:0px;');
        $('#next').attr('style', 'display:none;');
        $('#before').attr('style', 'display:none;');
        $('#preview').attr('style', 'display:none;');

        sub_index = 1;
        sub_slide_max = slideshow_max;
            
        // �ϴ� �����̵� ���
        $('#test').html('');
        for (var i = 1; i <= slideshow_max; i += 1) {
            var file = './uploadStorage/' + '${access_code}' + '/' + slideshow_file + '-' + i + '.jpg';
            $('#test').append('<img id=\"slide'+i+'" style=\"display:none;\" class=\"slide_prev\" src=\"' + file + '\" />');
        }

        // �ϴ� �����̵� ȭ�� Ȱ��ȭ
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