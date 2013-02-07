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
//ελεγχος χρήστη check user's credentials
String pagetoshow ="";
Boolean redirect=false;
if((session.getAttribute("verified")==null)||((Integer)session.getAttribute("verified")==0))
{        
user.setEmail(request.getParameter( "username" )+mail);
try
{
        /*
         * edo tha mpei kai ldap authentication
        */
    String username=request.getParameter( "username" );
    String password=request.getParameter( "password" );
    String LDAPresponse =LDAPauth(username,password,LDAPserver,mail);
    //out.println(LDAPresponse);
    //  String LDAPresponse =LDAPauth();
    if (user.getEmail().contains(";"))
    {
        pagetoshow="<p>SQL injection attempt</p>";
        user.setEmail(" ");
    }
    if (LDAPresponse.equalsIgnoreCase("OK"))
    {

    statement = connection.createStatement();

    rs = statement.executeQuery("SELECT * FROM sp_User where  '"+user.getEmail()+"'=email;");
    //SELECT `rights`,`name`, `surname` FROM `User` WHERE `email` = 'email@hua.gr';

    if(!rs.next())//den exei kanei xana login
    {
        
        // session.setAttribute("verified",2);
         statement = connection.createStatement();
         User user2 =LDAPauth2(username,password,LDAPserver,mail);
         user.setUser(user2);
         session.setAttribute("verified",1);      
        try{ 
            
                String insert="INSERT INTO sp_User ( name, surname, department, role,email)"
        + " VALUES ('"+user.getFirst_Name()+"','"+user.getLast_Name()+"','0','1','"+user.getEmail()+"')";   
                    
          
                
            statement = connection.createStatement();
            statement.executeUpdate(insert, Statement.RETURN_GENERATED_KEYS);
            ResultSet res = statement.getGeneratedKeys();

           // out.println(res.toString());
            while (res.next())
            { 
               user.setId(res.getInt(1));
            }
              String insert2="INSERT INTO sp_uExtra (user_id,name_en,surname_en)"
        + " VALUES ('"+user.getId()+"','','')";                       
                       redirect=true;  
            statement = connection.createStatement();
            statement.executeUpdate(insert2);
            
           user.setRole(1);
           
             
        }catch(Exception ex){
            pagetoshow+=ex.toString();
        }    
       
    }
    else//yparxei hdh
    {    
     
        user.setFirst_Name(rs.getString("name"));
        user.setLast_Name(rs.getString("surname"));
        user.setId(rs.getInt("id"));
        user.setLast_Name(rs.getString("surname"));
        user.setRole(rs.getInt("role"));
        user.setDepartment(rs.getInt("department"));
        session.setAttribute("verified",1);

    }
    rs.close();
    
    }
    else
    {
         pagetoshow+="<p></br><b>Δώσατε λάθος συνδυασμό UserName και κωδικού</b></p>";
    }

    
}
catch (NullPointerException ex)
{
     pagetoshow+="<p>Επιστροφή στην είσοδο</p><a href='index.jsp'>Σφάλμα εισόδου.</a>";
}
catch (SQLException ex)
{
   pagetoshow+="<p>Επιστροφή στην είσοδο</p><a href='index.jsp'>Σφάλμα εισόδου.</a>";
}
}
else if((session.getAttribute("verified")==null)||((Integer)session.getAttribute("verified")==2))
{   
   // pagetoshow+="mphka\n";
   // pagetoshow+=request.getParameter("Department");
     
}
else
{
   /* session.setAttribute("subid","-1");
    session.setAttribute("itemid",-1);*/
}
%>

<%
//initialise a new submission 

if (        (session.getAttribute("verified")!=null)&&    ((Integer)session.getAttribute("verified")==1 )        )
{  
      ;

}
else if (     (session.getAttribute("verified")!=null)&&    ((Integer)session.getAttribute("verified")==2 )        )
{
     
}
else
{
   pagetoshow+="<a href='index.jsp'></br>Δεν έχετε κάνει σύνδεση<br/>Πάτηστε για login</a>";
}


%>



<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	
	<title>Κεντρική Σελίδα</title>
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

        <%
if(redirect)
{
out.println("<meta http-equiv='REFRESH' content='0;url="+appserver+"/Publication_Submission/editprofile.jsp'>");
}           
%>
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
                         try{
                             out.println(pagetoshow);
                           int level=-1;
                            if ((session.getAttribute("verified")!=null)&&(Integer)session.getAttribute("verified")==1)
                            {
                                 String email;
                                 int number;
                                 String fullname;
                                 String substring="";  
                                if(user.getRole()==1)//administrator
                                {
                                 /*  out.println("<div align='center'><form  action='submit.jsp' method='post' style='width: 211px; height: 27px'>"+
                                        "<button align='center' id='bu1' "
                                       // + "onclick=\"parent.location='submit.jsp'\"" 
                                         + " name='Button1' type='submit'  >Απόθεση νέας Δημοσίευσης</button></form></div>"); */
                                    out.println("<table align='center'><tr><td><div align='center'><a class='large blue button' align='center' href='submit.jsp'>Απόθεση νέας Δημοσίευσης</a></div></td>");
                                    out.println("<td><div align='center'><a class='large blue button' align='center' href='addco.jsp'>Προσθήκη συνεργατών</a></div></td>"
                                            + "<td><div align='center'><a class='large blue button' align='center' href='editprofile.jsp'>Αλλαγή Profile</a></td></tr></table>");
                  //                     //  
                                 //    out.println("<div align='center'><a  href='submit.jsp'>Απόθεση νέας Δημοσίευσης</a></div>");                       
                                    //kati tha kanei kai aytos
 
                                        try
                                        {  
                                            String title="";  
                                            String sub_id="";
                                            statement = connection.createStatement();
                                            rs = statement.executeQuery("SELECT * FROM sp_Publication WHERE status="+finalstate+" AND user_id="+user.getId()+" ORDER BY RAND() LIMIT 5");                                           
                                            out.println("<h4  align='center'>Yποβληθείσες Δημοσιεύεσεις</h4>");
                                            out.println("<table  border='1'  align='center'>");
                                            while (rs.next())
                                            {                                 
                                              title=rs.getString("title");  
                                              sub_id=rs.getString("sub_id");
                                            //substring=email.substring(0,email.length()-mail.length());   
                                            //level=rs.getInt("col_id");
                                            out.println("<tr><td align='center'><a href='edit_submission.jsp?sub_id="+sub_id+"'>"+title+"</a></td></tr>");
                                            }
                                            out.println("</table>");
                                            out.println("<div align='center' align='center'><a href='active.jsp'  align='center'>Δείτε όλες τις δημοσιεύεσεις</a></div>");
                                     
                                        }
                                        catch(Exception ex)
                                        {
                                            out.println("<p>"+ex.toString()+"</p>") ;
                                        } 
                                 
                                        try
                                        {  
                                            String title="";  
                                            String sub_id="";
                                            statement = connection.createStatement();
                                            rs = statement.executeQuery("SELECT * FROM sp_Publication WHERE status="+1+" AND user_id="+user.getId()+" ORDER BY RAND() LIMIT 5");                                           
                                            out.println("<h4  align='center'>Δημοσιεύεσεις χωρίς έγγραφο</h4>");
                                            out.println("<table border='1'  align='center'>");
                                            while (rs.next())
                                            {                                 
                                              title=rs.getString("title");  
                                              sub_id=rs.getString("sub_id");
                                            //substring=email.substring(0,email.length()-mail.length());   
                                            //level=rs.getInt("col_id");
                                            out.println("<tr><td><a href='submit.jsp?sub_id="+sub_id+"'>"+title+"</a></td></tr>");
                                            }
                                            out.println("</table>");
                                            out.println("<div align='center'><a href='incomplete.jsp'  align='center'>Δείτε όλες τις δημοσιεύεσεις</a></div>");
                                        }
                                        catch(Exception ex)
                                        {
                                            out.println("<p>"+ex.toString()+"</p>") ;
                                        } 
                                }else
                                if(user.getRole()==2)//library
                                {
                                 
                                }
                            }
                             
                         }catch(Exception ex)
                         {
                                
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
				<p class="copy">&copy; Copyright 2012<span>|</span> Design by <a href="http://bekatoros.eu" target="_blank">Marios Bekatoros</a></p>
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
                            
                            
