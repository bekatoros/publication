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
	
	<title>Κεντρική Σελίδα</title>
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

		<div id="header">
			<h1 class="auto-style2" style="width: 758px; height: 109px"><a href="central.jsp">Σύστημα Ηλεκτρονικής Υποβολής Εργασιών στην Estia</a></h1>

		</div>

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
    <%-- start web service invocation --%><hr/>
    <%
    try {
	allo.paketo.NeoWS service = new allo.paketo.NeoWS();
	allo.paketo.NeoWSPortType port = service.getNeoWSHttpSoap12Endpoint();
	 // TODO initialize WS operation arguments here
	java.lang.String username = "";
	java.lang.String comid = "";
	java.lang.String colid = "";
	// TODO process result here
	java.lang.Integer result = port.addThesis("bekatoros@hua.gr", "0","0");
	out.println("Result = "+result);
    } catch (Exception ex) {
        out.println(ex.toString());
	// TODO handle custom exceptions here
    }
    %>
    <%-- end web service invocation --%><hr/>



			<div id="content"  class="auto-style3">
                            <%
                            out.println(pagetoshow);
                            %>
                            <%
                            if ((session.getAttribute("verified")!=null)&&(Integer)session.getAttribute("verified")==1)
                            {
                                if(user.getRole()==1)//administrator
                                {
                                    //kati tha kanei kai aytos

                                }else
                                if(user.getRole()==2)//library
                                {
                                    //active tasks();

                                    //statistics??? isos administrator

                                }else
                                if(user.getRole()==3)//secretery
                                {
                                    //add new submission(s)

                                    //active submissions

                                    //completed submissions (one year period?)

                                }
                            }
                            %>
			</div>
    <%-- start web service invocation --%><hr/>
  
    <%-- end web service invocation --%><hr/>

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