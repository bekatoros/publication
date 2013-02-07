<jsp:useBean id="user" class="mypak.User" scope="session"/>
<jsp:setProperty name="user" property="*"/>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%-- 
    Document   : statistics
    Created on : Feb 7, 2013, 9:32:53 AM
    Author     : marios
SELECT com_id,count(*) FROM `Submission` WHERE year(`completion`)=2012 group by `com_id`
SELECT col_id,count(*) FROM `Submission` WHERE year(`completion`)=2012 group by `col_id`
SELECT count(*) FROM `Submission` WHERE year(`completion`)=2012 group by `com_id`

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
	
	<title>Ολοκληρωμένες Υποβολές</title>
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
                            {
                                   int number;
                                   String email;
                                   String fullname;     
                                   String substring;
                                   int level;                                                                                                      
                                   try
                                   {  
                                    //active tasks();
                                    statement = connection.createStatement();
                                    
                                    if(user.getRole()==3)
                                    {//Γραμματεία
                                        rs = statement.executeQuery("SELECT * FROM Submission WHERE (status="+finalstate+" or status=4) AND submitter="+user.getId()+";");
                                    }
                                    else
                                    {
                                         rs = statement.executeQuery("SELECT * FROM Submission WHERE status="+finalstate);
                                    }
                                    
                                    //  episης θα εμφανιζει το λινκ για τα αποδεικτικο υποβολής        
                                    out.println("<h4  align='center'>Ολοκληρωμένες Υποβολές</h4>");
                                    out.println("<table border='1'  align='center'>");
                                    while (rs.next())
                                    {//Στο λινκ τεξτ κατι θα βαλω αν και δε ξερω τι.μαλλον ονομα χρήστη
                                     number=rs.getInt("sub_id");
                                    //θα τυπώσει όσες υποβολές έχουν ολοκληρωθεί  δηλαδή έχουν state = final
                                     email=rs.getString("email");
                                     fullname=rs.getString("full_name") ;
                                     substring=email.substring(0,email.length()-mail.length());
                                    //θα τυπώσει όσες υποβολές έχουν ολοκληρωθεί  δηλαδή έχουν state = final
                                        level=rs.getInt("col_id");
                                     out.println("<tr><td><a href='receipt.jsp?sid="+number+"' target='_blank'> "+substring+" "+collection[level]+" "+fullname+"</a></td></tr>");
                                    }
                                    out.println("</table>");                                    
                                  }
                                  catch(Exception ex)
                                  {
                                       out.println("<p>"+ex.toString()+"</p>") ;
                                  }
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