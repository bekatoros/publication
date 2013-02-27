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
	
	<title>Στατιστικά Υποβολών</title>
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
                                
                                try
                                 {  
                                   
                                    statement = connection.createStatement();
                                    rs = statement.executeQuery("SELECT d.name,s.com_id,count(*) as count"
                                    + " FROM Submission as s ,Dep_Com as d WHERE year(completion)= "
                                    + "(year(now())-1) and s.com_id=d.com_id  group by com_id;");
                                    out.println("<h4  align='center'>Υποβολές προηγούμενου χρόνου ανά τμήμα</h4>");
                                    out.println("<table border='1'  align='center'>");
                                    while (rs.next())
                                    {                                     
                                     out.println("<tr><td>"+rs.getString("d.name") +" "+rs.getInt("count") +"</td></tr>");
                                    }
                                    out.println("</table></βρ>");                                   
                                    
                                  }
                                  catch(Exception ex)
                                  {
                                       out.println("<p>"+ex.toString()+"</p>") ;
                                  }
                                
                                 try
                                 {  
                                   
                                    statement = connection.createStatement();
                                    rs = statement.executeQuery("SELECT d.name,s.com_id,count(*) as count"
                                    + " FROM Submission as s ,Dep_Com as d WHERE year(completion)= "
                                    + "year(now()) and s.com_id=d.com_id  group by com_id;");
                                    out.println("<h4  align='center'>Υποβολές ανά τμήμα (τρέχων έτος)</h4>");
                                    out.println("<table border='1'  align='center'>");
                                    while (rs.next())
                                    {                                     
                                     out.println("<tr><td>"+rs.getString("d.name") +" "+rs.getInt("count") +"</td></tr>");
                                    }
                                    out.println("</table>");                                   
                                    
                                  }
                                  catch(Exception ex)
                                  {
                                       out.println("<p>"+ex.toString()+"</p>") ;
                                  }
                                
                        
                              
                                
                                /*
 SELECT d.name,s.com_id,s.col_id,col.name,count(*) as count FROM Submission as s ,Dep_Com as d ,Collection as col  WHERE year(completion)= (year(now())-1) and s.com_id=d.com_id  and s.col_id=col.col_id and col.com_id =d.com_id group by s.com_id,s.col_id;
 */
                                  try
                                 {  
                                   
                                    statement = connection.createStatement();
                                    rs = statement.executeQuery("SELECT d.name,s.com_id,s.col_id,col.name,count(*) "
                                    + "as count FROM Submission as s ,Dep_Com as d ,Collection as col "
                                    + " WHERE year(completion)= (year(now())-1) and s.com_id=d.com_id  "
                                    + "and s.col_id=col.col_id and col.com_id =d.com_id group by s.com_id,s.col_id;");
                                    out.println("<h4  align='center'>Υποβολές ανά επίπεδο</h4>");
                                    out.println("<table border='1'  align='center'>");
                                    while (rs.next())
                                    {                                     
                                     out.println("<tr><td>"+rs.getString("d.name") +" "+rs.getString("col.name") +" "+rs.getInt("count") +"</td></tr>");
                                    }
                                    out.println("</table>");                                   
                                    
                                  }
                                  catch(Exception ex)
                                  {
                                       out.println("<p>"+ex.toString()+"</p>") ;
                                  }
                                
                                 try
                                 {  
                                   
                                    statement = connection.createStatement();
                                    rs = statement.executeQuery("SELECT d.name,s.com_id,s.col_id,col.name,count(*) "
                                    + "as count FROM Submission as s ,Dep_Com as d ,Collection as col "
                                    + " WHERE year(completion)= year(now()) and s.com_id=d.com_id  "
                                    + "and s.col_id=col.col_id and col.com_id =d.com_id group by s.com_id,s.col_id;");
                                    out.println("<h4  align='center'>Υποβολές ανά επίπεδο (τρέχων έτος)</h4>");
                                    out.println("<table border='1'  align='center'>");
                                    while (rs.next())
                                    {                                     
                                     out.println("<tr><td>"+rs.getString("d.name") +" "+rs.getString("col.name") +" "+rs.getInt("count") +"</td></tr>");
                                    }
                                    out.println("</table><p></p>");                                   
                                    
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