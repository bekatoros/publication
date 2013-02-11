<%-- 
    Document   : logout
    Created on : Apr 21, 2011, 9:49:26 AM
    Author     : Marios
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>Αποσύνδεση</title>
	<link rel="stylesheet" type="text/css" href="style.css" />
	<style type="text/css">
	.auto-style1 {
		margin-left: 588px;
	}
	.auto-style2 {
		margin-left: 0px;
		margin-bottom: 34px;
	}
	</style>
</head>

<body>
	<div id="container">

			<%@include file="header.jsp" %>

		<div id="menu-h">
			<ul style="height: 30px">
				<li style="width: 67px; height: 27px">
				</li>
				<li class="auto-style1" style="width: 100px; height: 27px">
				<a href="" style="width: 143px"></a></li>
			</ul>
		</div>

		<div id="main">

			<div id="content" >
			<%
       
                        out.println("Αποσυνδεθήκατε επιτυχώς");
                        if (session.getAttribute("status")!=null)
                        {
                            out.println("<p><a href='submit.jsp'> Επιστροφή στο Login </a></p>");
                        }
                        else
                        {     
                            out.println("<p><a href='index.jsp'> Επιστροφή στο Login </a></p>");
                        }
                        session.invalidate();
                        %>
			</div>

		</div>

	</div>
<div class="clear">
</div>
<%@include file="footer.jsp" %>
</body>

</html>


