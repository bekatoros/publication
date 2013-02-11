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
if ((session.getAttribute("verified")!=null)&&(Integer)session.getAttribute("verified")==1)
  {
    try{
     if(request.getParameter("sel").equals("other"))
     {
       
         
         try{
            if(!request.getParameter("email").equals(""))
            {
                //send invite to mail
              //  out.print(request.getParameter("email"));
                 sendMail(user.getEmail()+mail,request.getParameter("email")+mail,"Πρόσκληση στο σύστημα υποβολή δημοσιεύσεων",invitation,mailserver,mailuser+mail,mailpass);
                      
            }
         }
         catch(Exception e){
                           
        }
     }
     else
     {
       // out.println("selection number"+request.getParameter("sel").toString()); 
        
              String insert="INSERT INTO sp_Cowriter ( user_id, co_id )"
        + " VALUES ("+user.getId()+","+request.getParameter("sel").toString()+");";   
                                
            try{
            statement = connection.createStatement();
            statement.executeUpdate(insert);}
            catch(Exception e){}
           insert="INSERT INTO sp_Cowriter ( user_id, co_id )"
        + " VALUES ("+request.getParameter("sel").toString()+","+user.getId()+");";   
                                
            try{
            statement = connection.createStatement();
            statement.executeUpdate(insert);}
            catch(Exception e){
               // out.println(e.toString());
            }
          }
         }catch(Exception e)
        {
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
	
	<title>Προσθήκη συνεργατών</title>
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
			<header id="header"><%@include file="header.jsp" %>
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
                                    </br>
                                    	
<%       
if ((session.getAttribute("verified")!=null)&&(Integer)session.getAttribute("verified")==1)
  {
     
            String sql="SELECT distinct u.surname,u.name,e.surname_en,e.name_en,u.email FROM sp_Cowriter co, sp_User u ,sp_uExtra e  WHERE co.user_id= "+user.getId()+" and co.co_id=u.id  and u.id=e.user_id";  
          

             String value="";                       
             try{
             statement = connection.createStatement();
             rs2 = statement.executeQuery(sql);
         //out.println(rs2.);  
          out.println("<table align='center' border='1' ><tr><td><b>Ονοματεπώνυμο</b></td><td><b>Full name</b></td><td><b>E-mail</b></td></b>");
            while (rs2.next())
            { 
            value="<tr><td> "+rs2.getString("u.surname")+","+rs2.getString("u.name") +" </td><td> "+rs2.getString("e.surname_en")+","+rs2.getString("e.name_en") +"  </td>   <td> "+rs2.getString("u.email")+" </td>  </tr> ";
             out.println(value);
            }
         out.println("</table>");
           }catch (Exception e)
           {
         //   out.println(e.toString());
           }  
  }     
%>
  
 <%
 if ((session.getAttribute("verified")!=null)&&(Integer)session.getAttribute("verified")==1)
  {
            String cowriters="";
            String sql="SELECT * FROM  sp_User u WHERE "+user.getId()+" != u.id";  
                                       
             try{
             statement = connection.createStatement();
             rs = statement.executeQuery(sql);
          
          
            cowriters+= "<option value=-1></option>";
           // out.println(res.toString());
            while (rs.next())
            { 
            cowriters+="<option value="+rs.getString("id")+">"+rs.getString("email")+"</option>";

            }
         
           }catch (Exception e)
           {
       // ///    out.println(e.toString());
           }  

     out.println("<form action='addco.jsp'  method='post'  class='auto-style3'>");
   out.println("<table align='center'><tr><td align='center' ></br><label  >Ονοματεπώνυμο Συγγραφέα</label></td></tr><tr align='center'><td><br> <label  id='writer' style='width: 250px; height: 25px' type='text' /></label>"
         + " <select id='sel' name='sel' onchange='changeName()' style='width: 150px;' > "
         +cowriters+" <option value='other'>άλλος</option></select></td></tr><tr><td> <div id='newuser' ></div> </td></tr></table>" + "</br>"
         + "<input class='large blue button' type='submit' id='bt1'  value='Υποβολή' /> </br>  </form></br> "
                                            + " ");
                                      
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
                            
                            
