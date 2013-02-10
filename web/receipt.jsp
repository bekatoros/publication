<%-- 
    Document   : receipt
    Created on : May 27, 2011, 6:07:20 PM
    Author     : it20726
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<jsp:useBean id="user" class="mypak.User" scope="session"/>
<jsp:setProperty name="user" property="*"/>
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
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>Αποδεικτικό Υποβολής</title>
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
                                    pagetoshow="";
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
                            out.println(pagetoshow);
                            
                            if ((session.getAttribute("verified")!=null)&&(Integer)session.getAttribute("verified")==1)
                            {/* */
                                if((user.getRole()==3)||(user.getRole()==2))//secretery + library
                                {
                try{
                                   Integer sid=Integer.parseInt(request.getParameter( "sid" ));
                                    out.println(" <h1>Απόδειξη υποβολής εργασίας</h1>");  
                                    
                                    statement = connection.createStatement();
                                    rs2 = statement.executeQuery("SELECT * FROM Submission where  '"+sid+"'=sub_id;");
                                    int comid=-1;
                                    String fullname="";
                                    int colid=-1;
                                    String email="";
                                    String substring="";
                                    Date complete=null;
                                    if(rs2.next())
                                    {
                                        comid= rs2.getInt("com_id");           
                                        colid=rs2.getInt("col_id");  
                                        fullname=rs2.getString("full_name");
                                        complete=rs2.getTimestamp("completion");
                                        email=rs2.getString("email");
                                        substring=email.substring(2,email.length()-mail.length());
                                    }                                                                      
                                    rs2.close();
                                   String epipedo =collection[colid];
                                    String tmhma = department [comid-3][0];                                  
                                    out.println("<p>Το όνομα του/της φοιτητή/ριας είναι "+fullname+" με ΑΜ "+substring+" και σπουδαζει στο τμήμα "+tmhma+" σε "+epipedo+" επίπεδο "
                                            + "και ολοκλήρωσε την υποβολή της εργασίας στις "+complete.toLocaleString()+"</p>");
                } catch(Exception E)
                {
                    System.out.println(E.toString());
                    }
                                   
                                }
                                else
                                {
                                     out.println("<p>Δεν έχεις δικαιώμα πρόσβασης σε αυτή τη σελίδα</p>"
                                            + "<a href='central.jsp'>Επιστροφή στην κεντρική σελίδα</a>");
                                }
                            }
                            %>
			</div>

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


