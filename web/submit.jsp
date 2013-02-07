<%-- 
    Document   : index
    Created on : Apr 20, 2011, 6:22:28 PM
    Author     : Marios
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>Είσοδος</title>
	<link rel="stylesheet" type="text/css" href="style.css?v=0.1" />
	<style type="text/css">
	.auto-style2 {
		margin-left: 0px;
		margin-bottom: 34px;
	}
	.auto-style3 {
	text-align: center;
}
	</style>
</head>

<body>
	<div id="container">

		 <div id="header" align='center'>		
	
				<table>
					<tr>
						<td >
							<img src='images/hua1.gif' width='61' height='60' />
						</td>
						<td >
							<h2><a href='http://www.hua.gr'>Χαροκόπειο Πανεπιστήμιο</a></h2>
                                                        </br>					
							<h2><a href='http://www.hua.gr/index.php?option=com_content&view=article&id=37&Itemid=318&lang=el'>Βιβλιοθήκη και Κέντρο Πληροφόρησης</a></h2>	
							
						</td>
					</tr>
					<tr>
					<td colspan="2"><h1><a>Σύστημα Ηλεκτρονικής Υποβολής Εργασιών στην ΕΣΤΙΑ</a></h1></td>
					</tr>
				</table>
		
			
		</div>

		<div id="menu-h">
			<ul style="height: 30px">				
			</ul>
		</div>

		<div id="main">

			
			<p class="auto-style3">
                            <span lang="el"><strong>Καλώς ήρθατε</strong></span>&nbsp;</p>
		<div class="auto-style3" >
			<form action="submit_2.jsp" method="post">
		<p class="auto-style3" >Δώστε το <span lang="en-us"><strong>Username</strong> 
		σας</span></p>
				<div class="auto-style3" >
                                    <input name="username" type="text" size="15" style="height: 18px; width: 98px;" tabindex="1"/>
                                    @hua.gr<br/>
                    <br/>
                    <span lang="el">Δώστε τον <strong>κωδικό</strong> σας</span><br/>
					<input name="password" size="20" type="password" tabindex="2"/>
                                            <br/><br/>
					<input class='large blue button' name="Submit" type="submit" value="Σύνδεση" tabindex="3"/></div>
			</form>
		</div>
		<p >&nbsp;</p>
			

		</div>

	</div>
<div class="clear">
</div>
	<div id="footer">
		<p>Επικοινωνία<br />
		<a href="license.html">Άδεια χρήσης</a> - <a href="about.html">About</a>
                </p>
	</div>
</body>

</html>


