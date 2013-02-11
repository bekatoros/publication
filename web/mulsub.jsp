<jsp:useBean id="user" class="mypak.User" scope="session"/>
<jsp:setProperty name="user" property="*"/>
<%@page contentType="text/html"  pageEncoding="UTF-8"%>
<%--
    Document   : central
    Created on : Apr 20, 2011, 6:42:08 PM
    Author     : Marios
--%>
<%@page import="java.sql.*" %>
<%@include file= "variables.jsp" %>
<%@include file= "functions.jsp" %>

<script  type="text/JavaScript">

var monthtext=['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sept','Oct','Nov','Dec'];

function populatedropdown(dayfield, monthfield, yearfield){
var today=new Date()
var dayfield=document.getElementById(dayfield)
var monthfield=document.getElementById(monthfield)
var yearfield=document.getElementById(yearfield)
for (var i=0; i<31; i++)
dayfield.options[i]=new Option(i+1, i+1)
dayfield.options[today.getDate()]=new Option(today.getDate(), today.getDate(), true, true) //select today's day
for (var m=0; m<12; m++)
monthfield.options[m]=new Option(monthtext[m], m+1)
monthfield.options[today.getMonth()]=new Option(monthtext[today.getMonth()], today.getMonth()+1, true, true) //select today's month
var thisyear=today.getFullYear()
for (var y=0; y<2; y++){
yearfield.options[y]=new Option(thisyear, thisyear)
thisyear+=1
}
yearfield.options[0]=new Option(today.getFullYear(), today.getFullYear(), true, true) //select today's year
}

</script>

<%
String pagetoshow="";

if ((session.getAttribute("verified")!=null)&&(Integer)session.getAttribute("verified")==1)
{     
}
else
{
   pagetoshow="<a href='index.jsp'></br>Δεν έχετε κάνει σύνδεση<br/>Πάτηστε για login</a>";
}


%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	
	<title>Νέα Υποβολή</title>
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

			<div id="content" class='auto-style3'  >
                            <%
                            
                            

                            if ((session.getAttribute("verified")!=null)&&(Integer)session.getAttribute("verified")==1)
                            {

                                //
                                if(user.getRole()==1)//administrator
                                {
                                    out.println("<p>Δεν έχεις δικαιώμα πρόσβασης σε αυτή τη σελίδα</p>"
                                            + "<a href='central.jsp'>Επιστροφή στην κεντρική σελίδα</a>");
                                   
                                }else
                                if(user.getRole()==2)//library
                                {
                                    out.println("<p>Δεν έχεις δικαιώμα πρόσβασης σε αυτή τη σελίδα</p>"
                                            + "<a href='central.jsp'>Επιστροφή στην κεντρική σελίδα</a>");                                   
                                }else
                                if(user.getRole()==3)//secretery
                                {
                                    out.println(pagetoshow);
                                    //add new submission(s)
                                    
                                   // response.setContentType("text/html; charset=utf-8");
                                    response.setCharacterEncoding("utf-8"); 
                                    out.println("<form action='central.jsp' method='post' >"+
                                    "<label id='Label1'>Τμήμα&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+
                                    "</label><select name='Department' style='width: 250px' tabindex='1'>");

                                    for (int i=0;i < department.length;i++)
                                    {
                                            out.println( "<option value="+department[i][1]+">"+department[i][0]+"</option>");
                                    }
                                   out.println( "</select><br />"+
                                    "<br />"+
                                    "Επίπεδο&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+
                                    "<select name='Level' style='width: 250px'>");

                                    for (int i=0;i < collection.length;i++)
                                    {
                                            out.println( "<option value="+i+">"+collection[i]+"</option>");
                                    }
                                   out.println( "</select><br />"+
                                    "<br />Διορία Υποβολής&nbsp;&nbsp;&nbsp;&nbsp&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp"+
                                    "<select id='daydropdown'style='width: 60px' name='day' tabindex='4'></select>&nbsp"+
                                    "<select id='monthdropdown' style='width: 60px'name='month' tabindex='5'></select>&nbsp"+
                                    "<select id='yeardropdown'style='width: 60px' name='year' tabindex='6'></select><br />"+
                                    "<br />Username 1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp"+
                                    "<input name='username1' type='text' size='15' style='height: 18px; width: 160px;' tabindex='7'/>@hua.gr<br/>"+                                    
                                    
                                    "<br />Username 2&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp"+
                                    "<input name='username2' type='text' size='15' style='height: 18px; width: 160px;' tabindex='8'/>@hua.gr<br/>"+                                    
                                    
                                    "<br />Username 3&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp"+
                                    "<input name='username3' type='text' size='15' style='height: 18px; width: 160px;' tabindex='9'/>@hua.gr<br/>"+                                    
                                   
                                    "<br />Username 4&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp"+
                                    "<input name='username4' type='text' size='15' style='height: 18px; width: 160px;' tabindex='10'/>@hua.gr<br/>"+                                    
                                    
                                    "<br />Username 5&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp"+
                                    "<input name='username5' type='text' size='15' style='height: 18px; width: 160px;' tabindex='11'/>@hua.gr<br/>"+                                    
                                    "<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+
                                    "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp"+
                                    "<br/><input name='Submit' type='submit' value='Υποβολή' />"+
                                    "<script type='text/javascript'>window.onload=function(){populatedropdown('daydropdown', 'monthdropdown', 'yeardropdown')}</script>"+
                                    "</form>");

                                   

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