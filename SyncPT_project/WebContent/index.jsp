<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
     
     function loginRoom(code){
        document.getElementById('enterRoom').style.display ='block';
        if(code === 'close'){
        	document.getElementById('enterRoom').style.display ='none';
        } else {
        	document.getElementById('accode').value = code.substring(0, 7);
			document.getElementById('mdtype').value = code.substring(7, 8);
        }
     }
</script>
<style type="text/css">
   html {
      font-size: 62.5%;
   }
   body{
      background-color: #222222;
      font-family: 'Nanum Gothic', 'malgun gothic', sans-serif;
      margin: 0; padding: 0;
      width: 100%;
      font-size: 0.9em;
   }      
   @media (min-width: 300px) {
       html {
         font-size: 65%;
      }   
   }
   @media (min-width: 500px) {
       html {
          font-size: 80%;
       }
   }
   @media (min-width: 700px) {
       html {
          font-size:95%;
       }
   }
   @media (min-width: 900px) {
       html {
         font-size: 110%;
      }
       
   }
   @media (min-width: 1100px) {
       html {
          font-size: 125%;
       }
   }
   @media (min-width: 1300px) {
       html {
          font-size: 140%;
       }     
   }
   #bg_wrap{
      position:fixed;
      top:12vh;
      left:12vw;
      width: 76vw;
      height: 76vh;
      background: url(./image/bg1.jpg) no-repeat center center; 
      -webkit-background-size: cover;
      -moz-background-size: cover;
      -o-background-size: cover;
      background-size: cover;
   }
   #bg{
      width:auto;
      height: 100vh;
      margin: auto;
      padding:0;
      vertical-align: middle;
   }
   
.square {
   height: 15vw;
   width: 15vw;
}

.roomSildeImageFrame {
   box-sizing: border-box;
   padding: 3%;
   width: 100%;
   height: 75%;
   background: black;
   font-size: 5em;
}

.roomSildeImageFrame>div {
   background: url(./test11.ppt-1.jpg) no-repeat center center;
   -webkit-background-size: cover;
   -moz-background-size: cover;
   -o-background-size: cover;
   background-size: cover;
   width: 100%;
   height: 100%;
}

.roomInfo {
   width: 100%;
   height: 12.5%;
   background: #333;
}

.accessBox{
   text-shadow: 1px 1px 3px black;
   text-indent:5px;
   margin:2px 0;
   box-sizing:border-box;
   width:100%;
   height:2.6em;
   font-size: 1em;
   line-height:2.1em;
   font-weight:bold;
   color: white;
   font-family: 'Nanum Gothic', 'malgun gothic';
   
   -moz-box-shadow:inset 0px 1px 0px 0px #f29c93;
   -webkit-box-shadow:inset 0px 1px 0px 0px #f29c93;
   box-shadow:inset 0px 1px 0px 0px #f29c93;
   background:-webkit-gradient( linear, left top, left bottom, color-stop(0.05, #fe0033), color-stop(1, #ce0006) );
   background:-moz-linear-gradient( center top, #fe0033 5%, #ce0006 100% );
   filter:progid:DXImageTransform.Microsoft.gradient(startColorstr='#fe0033', endColorstr='#ce0006');
   background-color:#fe0033;
   border:0.5em solid #fe0033;
   display:inline-block;
   
   -webkit-border-top-left-radius:1.924em;
   -moz-border-radius-topleft:1.924em;
   border-top-left-radius:1.924em;
   -webkit-border-top-right-radius:0px;
   -moz-border-radius-topright:0px;
   border-top-right-radius:0px;
   -webkit-border-bottom-right-radius:1.924em;
   -moz-border-radius-bottomright:1.924em;
   border-bottom-right-radius:1.924em;
   -webkit-border-bottom-left-radius:0px;
   -moz-border-radius-bottomleft:0px;
   border-bottom-left-radius:0px;
   margin:0;
   padding:0;
   background:none;
   display: inline-block;
}
.buttonRed {
   box-sizing: border-box;
   -moz-box-shadow:inset 0px 1px 0px 0px #f29c93;
   -webkit-box-shadow:inset 0px 1px 0px 0px #f29c93;
   box-shadow:inset 0px 1px 0px 0px #f29c93;
   background:-webkit-gradient( linear, left top, left bottom, color-stop(0.05, #fe0033), color-stop(1, #ce0006) );
   background:-moz-linear-gradient( center top, #fe0033 5%, #ce0006 100% );
   filter:progid:DXImageTransform.Microsoft.gradient(startColorstr='#fe0033', endColorstr='#ce0006');
   background-color:#fe0033;
   -webkit-border-top-left-radius:1.924em;
   -moz-border-radius-topleft:1.924em;
   border-top-left-radius:1.924em;
   -webkit-border-top-right-radius:0px;
   -moz-border-radius-topright:0px;
   border-top-right-radius:0px;
   -webkit-border-bottom-right-radius:1.924em;
   -moz-border-radius-bottomright:1.924em;
   border-bottom-right-radius:1.924em;
   -webkit-border-bottom-left-radius:0px;
   -moz-border-radius-bottomleft:0px;
   border-bottom-left-radius:0px;
   border:1px solid #d83526;
   display:inline-block;
   color:#ffffff;
   font-family:'malgun gothic' Arial;
   font-size: 1em;
   font-weight:bold;
   font-style:normal;
   line-height: 2.1em;
   width:100%;
   height:2.6em;
   text-decoration:none;
   text-align:center;
   text-shadow:1px 1px 0px #b23e35;
   margin:0;
   padding:0 4px 0 0;
}
.buttonRed:hover {
   background:-webkit-gradient( linear, left top, left bottom, color-stop(0.05, #ce0006), color-stop(1, #fe0033) );
   background:-moz-linear-gradient( center top, #ce0006 5%, #fe0033 100% );
   filter:progid:DXImageTransform.Microsoft.gradient(startColorstr='#ce0006', endColorstr='#fe0033');
   background-color:#ce0006;
}.buttonRed:active {
   position:relative;
   top:1px;
}

}.buttonRed:active {
   position:relative;
   top:1px;
}

#enterMain{
   position: fixed;
   bottom: 20vh;
   right: 32vw;
}
#enterRoom{
   display:none;
   padding:0;
   z-index:100;
   -moz-box-shadow:4px 4px 2px rgba(0, 0, 0, 0.30);
   -webkit-box-shadow:4px 4px 2px rgba(0, 0, 0, 0.30);
   box-shadow:4px 4px 2px rgba(0, 0, 0, 0.30);   
   width: 280px; /* 폭이나 높이가 일정해야 합니다. */
   height: 200px; /* 폭이나 높이가 일정해야 합니다. */
   border: 1px solid black;
   position: absolute;
   top: 50%; /* 화면의 중앙에 위치 */
   left: 50%; /* 화면의 중앙에 위치 */
   margin: -100px 0 0 -140px;
   /* 높이의 절반과 너비의 절반 만큼 margin 을 이용하여 조절 해 줍니다. */
   background-color: #333333;

}

#logo{
   position: fixed;
   top: 25vh;
   left: 19vw;
}
</style>
<meta charset="UTF-8">
<meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0, user-scalable=no, width=device-width" />
<title>SyncPT D2fest</title>
</head>
<body>
   <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
      <%@ page import="java.util.ArrayList, java.util.Enumeration, SyncPT.Model.Room_Entity" %>
   <jsp:useBean id="db" class="SyncPT.Model.DBofSyncPT" scope="page" />
   
   <%
      ArrayList<Room_Entity> room_list = new ArrayList<Room_Entity>();
      room_list = db.get_Openrooms();
   %>
   
   <!-- 만약 엑세스 코드 값이 있다면 url을 통해서 접속한 상태. 사용자 입력 안내창을 띄어준 후 로그인 -->
   <c:if test="${access_code != null}" var="bool">
      <script type="text/javascript">
         alert("사용자 이름을 입력해주시기 바랍니다.");
      </script>   
   </c:if>   
   
   <div id="bg_wrap"></div>
   <div style="position: fixed; width: 100vw; height: 100vh; overflow-y: scroll; float: right;">
      <div style="float: right; background-color: rgba(255,255,255,0.2); margin-right:12vw; padding:1vw;">
      <%
      if(room_list.size()!=0) {
         for(Room_Entity room : room_list) {
      %>
         <div class="square" onclick="loginRoom('<%=room.getAccess_code()%><%=room.getMedia_type()%>')">
            <div class="roomInfo" style="color:rgb(255,255,255);">
               <%=room.getHost_name()%> - <%=room.getRoom_name()%>
            </div>
            <div class="roomSildeImageFrame">
                  <img id="slide_img" src=".\uploadStorage\<%=room.getAccess_code()%>\<%=room.getFile_name()%>-1.jpg" alt="Slide Image" style="width:100%; height:100%;">
            </div>
         </div>      
      <%
         }
      }
      %>

      </div>
   </div>
      <div id="logo">
         <img src="./image/syncptLogo.png" style="width: 50%; height: auto;"/>
      </div>
   <div id="enterMain">
      <form action="Login" method="post">
         <div style="height:2.6em; width:26vmax; overflow: visible;">
            <div style="float: left; height: 100%; width:15vmax;">
               <input type="text" class="accessBox" name="u_name" />
            </div>
            <div style="float: left; height: 100%; width:10vw; padding-left:2%; ">
               <input type="submit" value="시작 하기" class="buttonRed" />
            </div>
         </div>
         <c:if test="${access_code != null}" var="bool">
            <input type="hidden" name="access_code" value="${access_code}" />
            <input type="hidden" name="media_type" value="${media_type}" />
         </c:if>
      </form>
   </div>
   
   
   <div id="enterRoom">
      <div style="height:40px; line-height:40px; text-indent: 10px; width:100%; color: white; font-size:20px;">
         <div style="float: left;">사용자 이름</div>
         <div style="float: right;">
            <input type="button" value="X" onclick="loginRoom('close')" style="width:26px; height:26px; border:0; background-color: #222222; color:white; margin-right:10px; " />
         </div>
      </div>
      <form action="Login">
      	<input type="hidden" name="u_type" value="guest" />
      	<input type="hidden" id="accode" name="access_code" />
      	<input type="hidden" id="mdtype" name="media_type" />
         <div style="background-color:#222222; height:100px; padding: 0 10px; line-height: 100px;"> 
            <input type="text" class="accessBox" name="u_name" style="font-size:20px;"/>
         </div>
         <div style="background-color:#222222; height:60px; padding: 0 10px ; line-height: 50px;"> 
            <input type="submit" value="입장" class="buttonRed" style="float: right; width:100px; height:40px; line-height:20px; font-size:20px;" />
         </div>
      </form>
   </div>
<body>
</html>