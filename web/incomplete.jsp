<%@page import="java.io.DataInputStream"%>
<jsp:useBean id="user" class="mypak.User" scope="session"/>
<jsp:setProperty name="user" property="*"/>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%--
    Document   : central
    Created on : Apr 20, 2011, 6:42:08 PM
    Author     : Marios
--%>
<%@page import="java.sql.*" %>
<%@include file= "variables.jsp" %>
<%@include file= "functions.jsp" %>


<%
String pagetoshow="";
%>





<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	
	<title>Δημοσιεύεσεις χωρίς έγγραφο</title>
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
    
    <!-- wrapper -->
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
			<!-- navigaation -->
			<nav id="navigation">
				<a href="#" class="nav-btn">HOME<span></span></a>
				<ul >
					<li >
                                    <%
                                    if((session.getAttribute("verified")==null)||(Integer)session.getAttribute("verified")!=1)
                                    {
                                        out.println("Δεν έχεις κάνει Login");
                                    }
                                    else if ((Integer)session.getAttribute("verified")==1)
                                    {
                                   out.print("Καλώς ήρθες "+user.getFirst_Name()+" "+user.getLast_Name());
                                    }
                                    %>
				</li>
                                <li    > 
                                     <%
                                     if ((Integer)session.getAttribute("verified")==1)
                                    {
                                    out.print("<a   href='central.jsp'>Αρχική</a>");
                                    }
                                    %>
                                    </li>
					
                                    <li   >

				<a   href="logout.jsp" ><%
                                if((session.getAttribute("verified")==null)||(Integer)session.getAttribute("verified")!=1)
                                {
                                    out.println("");
                                }
                                else if ((Integer)session.getAttribute("verified")==1)
                                {
                                    out.print("Αποσύνδεση");
                                }
                                    %></a></li>
				</ul>
				<div class="cl">&nbsp;</div>
			</nav>
			<!-- end of navigation -->
			<!-- slider-holder -->
			

			<!-- main -->
			<div class="main">

				<div class="featured" align='center'>
                                   <%
                            if ((session.getAttribute("verified")!=null)&&(Integer)session.getAttribute("verified")==1)
                            { 
                                if(user.getRole()==1)
                                {
                                    try{
                                            String title="";  
                                            String sub_id="";
                                            String item_id="";
                                            statement = connection.createStatement();
                                            rs = statement.executeQuery("SELECT * FROM sp_Publication WHERE status='1' AND user_id="+user.getId()+" ORDER BY RAND()");                                           
                                            out.println("<h4  align='center'>Δημοσιεύεσεις χωρίς έγγραφο</h4>");
                                            out.println("<table border='1'  align='center'>");
                                            while (rs.next())
                                            {                                 
                                              title=rs.getString("title");  
                                              item_id=rs.getString("item_id");
                                              sub_id=rs.getString("sub_id");
                                            //substring=email.substring(0,email.length()-mail.length());   
                                            //level=rs.getInt("col_id");
                                            out.println("<tr><td><a href='submit.jsp?sub_id="+sub_id+"'>"+title+"</a></td></tr>");
                                            }
                                            out.println("</table>");
                                          //  out.println("<div align='center'><a href='active.jsp' target='_blank' align='center'>Δείτε όλες τις δημοσιεύεσεις</a></div>");
                                                                      
                                  }
                                  catch(Exception ex)
                                  {
                                       out.println("<p>"+ex.toString()+"</p>") ;
                                  }

                                }
                              
                            }
                            else
                            {
                                    out.println(pagetoshow);
                            }
                            %>  
					
				</div>

			
			</div>

     
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