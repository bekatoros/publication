<%-- 
    Document   : index
    Created on : Apr 20, 2011, 6:22:28 PM
    Author     : Marios
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>Είσοδος</title>
	<meta charset="utf-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1, user-scalable=0" />
	<link rel="shortcut icon" type="image/x-icon" href="css/images/favicon.ico" />
	<link rel="stylesheet" href="css/style.css" type="text/css" media="all" />
	<link href='http://fonts.googleapis.com/css?family=Raleway:400,900,800,700,600,500,300,200,100' rel='stylesheet' type='text/css'>
	
	<script src="js/jquery-1.8.0.min.js" type="text/javascript"></script>
	<!--[if lt IE 9]>
		<script src="js/modernizr.custom.js"></script>
	<![endif]-->
	<script src="js/jquery.carouFredSel-5.5.0-packed.js" type="text/javascript"></script>
	<script src="js/functions.js" type="text/javascript"></script>
</head>

<body>
    <div id="wrapper">
	<!-- shell -->
	<div class="shell">
		<!-- container -->
		<div class="container">
			<!-- header -->
			<header id="header">
				
<%@include file="header.jsp" %>
			</header>
			<!-- end of header -->
			<!-- navigation -->
			<nav id="navigation">
				<a href="#" class="nav-btn">HOME<span></span></a>
				<ul>
					
				</ul>
				<div class="cl">&nbsp;</div>
			</nav>
			<!-- end of navigation -->
			<!-- slider-holder -->
			<div class="slider-holder">
				
			</div>

			<!-- main -->
			<div class="main" align="center">

				<div class="featured" align="center" >
                                    <p>
                           <strong>Καλώς ήρθατε</strong>&nbsp;</p>
		<div  >
			<form action="central.jsp" method="post" align="center">
		<p  >Δώστε το <strong>Username</strong> 
		σας</p>
				<div  >
                                    <input name="username" type="text" size="15" style="height: 18px; width: 98px;" tabindex="1"/>
                                    @hua.gr<br/>
                    <br/>
                   Δώστε τον <strong>κωδικό</strong> σας<br/>
					<input name="password" size="20" type="password" tabindex="2"/>
                                            <br/><br/>
					<input class="large blue button"  name="Submit" type="submit" value="Σύνδεση" tabindex="3"/></div>
			</form>
		</div>
					
				</div>

				<section class="cols">
                               
				</section>

				<section class="entries">
			
     
			<!-- end of main -->
			<div class="cl">&nbsp;</div>
			
			<!-- footer -->
							
<%@include file="footer.jsp" %>
			<!-- end of footer -->
		</div>
		<!-- end of container -->
	</div>
	<!-- end of shell -->
</div>
<!-- end of wrapper -->
	
</body>

</html>


