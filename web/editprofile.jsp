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
response.setHeader("Access-Control-Allow-Origin","*");
%>

<%
String toshow="";
 if ((session.getAttribute("verified")!=null)&&(Integer)session.getAttribute("verified")==1)
{
     
     if(request.getParameter("user_id")!=null)
     {
         try{
      String user_id = request.getParameter("user_id"); 
      String name = request.getParameter("2ndname"); 
      String surname = request.getParameter("2ndsurname"); 
      String depvalue = request.getParameter("department"); 
      statement = connection.createStatement(); 
      statement.executeUpdate("Update sp_User SET `department` = '"+depvalue+"' WHERE id ="+user_id+" LIMIT 1 ;");    
      statement.executeUpdate("Update sp_uExtra SET `name_en` = '"+name+"' WHERE user_id ="+user_id+" LIMIT 1 ;");   
      statement.executeUpdate("Update sp_uExtra SET `surname_en` = '"+surname+"' WHERE user_id ="+user_id+" LIMIT 1 ;"); 
    toshow="Οι αλλαγές αποθηκεύτηκαν";               
     // out.println(""+user_id+name+surname+depvalue);
           }catch(Exception e)
           {
            //    out.println(""+e.toString());
           }
     }
     
 }
%>

<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.1/jquery.min.js"></script>

<script type="text/javascript">
    function changeName()
    {
        
        var index = document.getElementById('sel').value;// .selectedIndex;
     
       if (document.getElementById("sel").value=="other")
       {
           document.getElementById("writer").style.visibility="hidden";
           br = document.createElement('br');
           document.getElementById("newuser").appendChild(br);
           
           lb = document.createElement('label');          
           lb.innerHTML="Εισάγεται το email για να προσκληθεί :";
    //       
           
           document.getElementById("newuser").appendChild(lb);
           
           input=document.createElement('input');           
           input.style.property="width: 200px; height: 25px";    
           input.setAttribute("name","email");
           input.setAttribute("id", "email");
           document.getElementById("newuser").appendChild(input);
           
           strng=document.createElement('strong');           
           strng.innerHTML="@hua.gr";           
           document.getElementById("newuser").appendChild(strng);  
           document.getElementById("writer").innerHTML= " ";
        //   document.getElementById("writer").setAttribute("name", "writer");
           
       }else if (document.getElementById("sel").value=="-1")
       {document.getElementById("writer").style.visibility="visible";
        document.getElementById("writer").innerHTML= " ";
         var parent=  document.getElementById("newuser");
          if (parent.hasChildNodes()){
         parent.removeChild(parent.lastChild);
         parent.removeChild(parent.lastChild);
         parent.removeChild(parent.lastChild); 
         parent.removeChild(parent.lastChild); }
       }       
       else
       {         document.getElementById("writer").style.visibility="visible"; 
            var parent=  document.getElementById("newuser");
            if (parent.hasChildNodes()){
         parent.removeChild(parent.lastChild);
         parent.removeChild(parent.lastChild);
         parent.removeChild(parent.lastChild); 
         parent.removeChild(parent.lastChild); }
     var url="<%out.print(jsonURL);%>"+index;
	    $.getJSON(url,function(json){
            // loop through the posts here
           // alert(json);
            //document.getElementById("writer"+num.toString()+"").value=json;
              $.each(json,function(i,post){
              document.getElementById("writer").innerHTML= post.surname+","+post.name  ;            
                });
           }); 
       }
    }
    </script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	
	<title>Αλλαγή Profile</title>
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
				
<table>
					<tr>
						<td >
							<img src='images/hua1.gif' width='61' height='60' />
						</td>
						<td >
                                                    <a href='http://www.hua.gr'>Χαροκόπειο Πανεπιστήμιο</a>
                                                        </br>					
							<a href='http://www.library.hua.gr'>Βιβλιοθήκη και Κέντρο Πληροφόρησης</a>
                                                              </br>	
						<a href="central.jsp">Σύστημα Ηλεκτρονικής Υποβολής Δημοσιεύσεων στην ΕΣΤΙΑ</a>
						</td>
					</tr>
					
				</table>
				<!-- search -->
				<div class="search">
					
<div class="cl">&nbsp;</div><p></p>
				</div>
				<!-- end of search -->
				<div class="cl">&nbsp;</div>
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
			<div class="slider-holder">
				
			</div>

			<!-- main -->
			<div class="main">

				<div class="featured" align='center'>
                                    <%
 if ((session.getAttribute("verified")!=null)&&(Integer)session.getAttribute("verified")==1)
  {
     
            String sql="SELECT * FROM  sp_User u,sp_uExtra e WHERE "+user.getId()+" = u.id and u.id=e.user_id;";  
                                       
             try{
             statement = connection.createStatement();
             rs = statement.executeQuery(sql);
                   
           // out.println(res.toString());
            if (rs.next())
            { 
           //+="<option value="+rs.getString("id")+">"+rs.getString("email")+"</option>";
                out.println("<div align='center'> <strong >"+toshow+"</strong></div>");
            out.println("<form method='post' action=editprofile.jsp  class='auto-style3' >"
                    +"<input type='hidden' id='id' name='user_id' value='"+rs.getString("u.id")+"' />" 
                    + "<label>Επώνυμο</label></br>"
                    + "<strong>"+rs.getString("u.surname")+"</strong></br>"
                    + "<label>Όνομα</label></br>"
                    + "<strong>"+rs.getString("u.name")+"</strong></br>"
                    + "<label>Επώνυμο σε 2η γλώσσα</label></br>"
                    + "<input name='2ndsurname' value='"+rs.getString("e.surname_en")+"'></input></br>"                   
                    + "<label>Όνομα σε 2η γλώσσα</label></br>"
                    + "<input name='2ndname' value='"+rs.getString("e.name_en")+"'></input></br>"               
                    + "<label>Τμήμα</label></br>"
                    +"<select name='department' style='width: 250px' >");
             
            String selected="";
            for (int i=0;i < department.length;i++)
            {
                if(rs.getInt("department")==i)
                {
                    selected="selected='selected'";
                }
                else
                {
                    selected="";
                  }
                    out.println( "<option value='"+department[i][1]+"'"+selected+">"+department[i][0]+"</option>");
            }
            out.println( "</select></br></br>"
                    + "<input class='large blue button' type='submit' value='Αλλαγή ' /></br>"
                    + "</form>");
            }
         
           }catch (Exception e)
           {
          //  out.println(e.toString());
           }      
     
     
     
 }
 %>
					
				</div>

			</div>

     
			<!-- end of main -->
			<div class="cl">&nbsp;</div>
			
			<!-- footer -->
			<div id="footer">
				<div class="footer-nav">
					<ul>
						<li><a href="license.html">Άδεια χρήσης</a> </li>
						<li><a href="about.html">About</a></li>
						<li><a href="mailto:bekatoros@hua.gr">Επικοινωνία</a></li>
						
					</ul>
					<div class="cl">&nbsp;</div>
				</div>
				<p class="copy">&copy; Copyright 2012<span>|</span>. Design by <a href="http://bekatoros.eu" target="_blank">Marios Bekatoros</a></p>
				<div class="cl">&nbsp;</div>
			</div>
			<!-- end of footer -->
		</div>
		<!-- end of container -->
	</div>
	<!-- end of shell -->
</div>
<!-- end of wrapper -->
	  
                  
</body>

</html>
                            
                            
