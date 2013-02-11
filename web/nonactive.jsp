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
String pagetoshow="<a href='index.jsp'></br>Δεν έχετε κάνει σύνδεση<br/>Πάτηστε για login</a>";
%>




<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	
	<title>Μη Ενεργές Εργασίες</title>
	<link rel="stylesheet" type="text/css" href="style.css" />
	<style type="text/css">
	.auto-style1 {
		margin-left: 200px;
	}
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

			<%@include file="header.jsp" %>

		<div id="menu-h">
			<ul style="height: 30px">
				<li style="width: 350px; height: 27px">
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

				<li class="auto-style1" style="width: 100px; height: 27px">

				<a href="logout.jsp" style="width: 143px"><%
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
		</div>

		<div id="main">

			<div id="content"  class="auto-style3">
                           <%
                            if ((session.getAttribute("verified")!=null)&&(Integer)session.getAttribute("verified")==1)
                            {String substring="";  
                                if(user.getRole()==1)//administrator
                                {
                                   out.println("<p>Δεν έχεις δικαίωμα πρόσβασης σε αυτή τη σελίδα</p>");

                                }else
                                if(user.getRole()==3)//secretery
                                {
                                  String email;
                                  out.println("<h4  align='center'>Μη ενεργές υποβολές</h4>");  
                                  try{  
                                    //active tasks();
                                    statement = connection.createStatement();
                                     rs = statement.executeQuery("SELECT * FROM Submission WHERE status=0 AND submitter="+user.getId()+";");
                                    
                                    out.println("<table border='1' align='center'>");
                                    while (rs.next())
                                    {//Στο λινκ τεξτ κατι θα βαλω αν και δε ξερω τι.μαλλον ονομα χρήστη
                                     email=rs.getString("email"); 
                                     substring=email.substring(0,email.length()-mail.length());                             
                                     out.println("<tr><td>"+substring+"</td></tr>");
                                    }
                                    out.println("</table>");                                  
                                  }
                                  catch(Exception ex)
                                  {
                                       out.println("<p>"+ex.toString()+"</p>") ;
                                  }

                                }else
                                if(user.getRole()==2)//library
                                {
                                    out.println("<p>Δεν έχεις δικαίωμα πρόσβασης σε αυτή τη σελίδα</p>");
                                }
                            }
                            else
                            {
                                    out.println(pagetoshow);
                            }
                            %>
			</div>

		</div>

	</div>
<div class="clear">
</div>
<%@include file="footer.jsp" %>
</body>

</html>