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
</script>

<style type="text/css">

	body {
	    font-family: "Nanum Gothic", sans-serif;
	}
	#bg_wrap{
	   position:relative;
	   width: 100%;
	   height: 100vh;
	   margin:0; padding:0;
	   color:white;
	   background: url(./image/bg1.jpg) no-repeat center center; 
	    -webkit-background-size: cover;
	    -moz-background-size: cover;
	    -o-background-size: cover;
	    background-size: cover;
	   
	}
	#user_area{
	   text-shadow: 1px 1px 3px black;
	   position:absolute;
	   font-weight:bold;
	   right:10%;
	   bottom:10%;
	   width: 450px;
	   height: 50px;
	   margin:0; padding:0;
	}
	#logo_area{
	   position:absolute;
	   top:5%;
	   left:10%;
	   width:245px;
	   height: 75px;
	   margin:0; padding:0;
	}
	#bg{
	   width:auto;
	   height: 100vh;
	   margin: auto;
	   padding:0;
	   vertical-align: middle;
	}
	#bottom{
	   bottom:0px;
	   position:relative;
	   width: 100%;
	   height: 50px;
	   background-color: #333;
	   margin:0; padding:0;
	}
</style>
<link rel="stylesheet" type="text/css" href="css/global.css" />
<meta charset="UTF-8">
<title></title>
</head>
<body>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	
	<!-- 만약 엑세스 코드 값이 있다면 url을 통해서 접속한 상태. 사용자 입력 안내창을 띄어준 후 로그인 -->
	<c:if test="${access_code != null}" var="bool">
		<script type="text/javascript">
			alert("사용자 이름을 입력해주시기 바랍니다.");
		</script>	
	</c:if>	
	
	<div id="bg_wrap">
    	<div id="user_area" >
    		<!-- 로그인 컨트롤러로 이동 -->
        	<form action="Login" method="post">
            	사용자 이름 
	            <input type="text" name="u_name" class="nameBox" />
	            <input type="submit" value="시작 하기" class="buttonRed" />
	            <c:if test="${access_code != null}" var="bool">
					<input type="hidden" name="access_code" value="${access_code}" />
				</c:if>	
         	</form>
      	</div>

      	<div id="logo_area">
        	<img src="./image/sptLogo.png" width="270" height="60" />
      	</div>
	</div>	
<body>
</html>