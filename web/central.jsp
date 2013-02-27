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

if((session.getAttribute("verified")==null)||((Integer)session.getAttribute("verified")!=1))
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

    rs = statement.executeQuery("SELECT * FROM User where  '"+user.getEmail()+"'=email;");
    //SELECT `rights`,`name`, `surname` FROM `User` WHERE `email` = 'email@hua.gr';

    if(!rs.next())
    {
        pagetoshow+="<a><a href='index.jsp'>Δεν έχετε δικαίωμα πρόσβασης στην σελίδα</a>";
       
       try{
        user=null;
        }catch(Exception E)
       {} 
    }
    else
    {        
        
        user.setFirst_Name(rs.getString("name"));
        user.setId(rs.getInt("id"));
        user.setLast_Name(rs.getString("surname"));
        user.setRole(rs.getInt("role"));
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
else
{
    session.setAttribute("subid","-1");
    session.setAttribute("itemid",-1);
}
%>

<%
//initialise a new submission 

if ((session.getAttribute("verified")!=null)&&(Integer)session.getAttribute("verified")==1)
{  
      
  try{
      if(user.getRole()==3)//secretery
      {
          try{ 
         
       pagetoshow="";
       
       
        Integer depnum=0 ;
        depnum = Integer.parseInt((String)request.getParameter("Department"));
        String uname ="";        
        String temp="";        
     //   uname= StringToUTF((String)request.getParameter("username"));        
        Integer level =0;
        level= Integer.parseInt((String)request.getParameter("Level"));
        Integer day =0;
        day= Integer.parseInt((String)request.getParameter("day"));
        Integer month =0;
        month= Integer.parseInt((String)request.getParameter("month"));
        Integer year =0;
        year= Integer.parseInt((String)request.getParameter("year"));
      
         
           for (int m=1;m<=5;m++)
           {

                try{
                    uname= StringToUTF((String)request.getParameter("username"+m));        
                    if(uname.contains(";"))
                    {
                        throw new Exception();
                    }
                    if  (uname.equals(""))
                    {
                    //pagetoshow+="<p>Το πεδίο Username είναι κενό</p>";
                    }
                    else
                    {

                        statement = connection.createStatement();

                        try {

                            rs = statement.executeQuery("SELECT * FROM Submission where  '"+uname+"@hua.gr'=email;"); 
                            if(rs.next())
                            {
                            pagetoshow+="<p>Η εγγραφή του φοιτητή με email "+uname+"@hua.gr υπάρχει ήδη</p>";   
                            }
                            else
                            {
                                String insert="INSERT INTO Submission ( email, com_id, col_id, deadline,submitter)"
                                        + " VALUES ('"+uname+"@hua.gr','"+depnum+"' , '"+level+"', '"+year+"-"+month+"-"+day+" 11:59:59','"
                                        +user.getId()+"');";        
                               
                                int result= statement.executeUpdate(insert);
                               // statement.
                                pagetoshow+="<p>Η εγγραφή του χρήστη με email "+uname+"@hua.gr προστέθηκε</p>";


                                //sendMail(String from,String to,String subject,String message,String mailserver,String mailuser,String mailpass) paradeigma
                                //Αποστολή mail προς το φοιτητή
                                sendMail(user.getEmail(),uname+mail,"Υποβολή πτυχιακής",mailmsg,mailserver,mailuser+mail,mailpass);
                            }
                        }
                        catch(Exception ex)
                        {
                            pagetoshow="<p>"+ex.toString()+"</p>" ;
                        }
                    }
                }catch(Exception ex)
                {
                    pagetoshow+="" ;
                }
                                     
        }             
      
      }catch(Exception ex)
      {
           pagetoshow+="" ;
      }
     }
  }
  catch(Exception ex)
  {
           pagetoshow="<p>Έχει μείνει άλλο session ανοικτό παρακαλώ πατήστε Αποσύνδεση και ξανασυνδεθείτε</p>" ;
  }
}
else
{
   pagetoshow+="<a href='index.jsp'></br>Δεν έχετε κάνει σύνδεση<br/>Πάτηστε για login</a>";
}


%>



<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	
	<title>Κεντρική Σελίδα</title>
	<link rel="stylesheet" type="text/css" href="style.css?v=0.1" />
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

                                %>
                                </a></li>
			</ul>
		</div>

		<div id="main" >
                    <div id='content'  >
                         <%
                         try{
                             out.println(pagetoshow);
                           int level=-1;
                            if ((session.getAttribute("verified")!=null)&&(Integer)session.getAttribute("verified")==1)
                            {
                                 String email;
                                 int number;
                                 String extra="";
                                 String fullname;
                                 String substring="";  
                                if(user.getRole()==1)//administrator
                                {
                                    //kati tha kanei kai aytos

                                }else
                                if(user.getRole()==2)//library
                                {
                                     out.println("<table align='center'><tr><td><form action='statistics.jsp' method='post' >"
                                       + "<input class='large blue button' name='Button1' type='submit' value='Στατιστικά χρήσης' ></input> </form></td></table>");
                                  
                                  out.println("<h4  align='center'>Ενεργές εργασίες</h4>");  
                                  try{  
                                    //active tasks();
                                    statement = connection.createStatement();
                                    rs = statement.executeQuery("SELECT * FROM Submission WHERE (status=2 or status=4 ) LIMIT 5");
                                    
                                    out.println("<table border='1' align='center'>");
                                    while (rs.next())
                                    {//Στο λινκ τεξτ κατι θα βαλω αν και δε ξερω τι.μαλλον ονομα χρήστη
                                     number=rs.getInt("sub_id");   
                                     fullname=rs.getString("full_name") ;
                                     email=rs.getString("email");
                                     substring=email.substring(0,email.length()-mail.length());
                                     level=rs.getInt("col_id");
                                      if (level==2)
                                     {
                                      statement2 = connection.createStatement();
                                      try{
                                      rs2 = statement2.executeQuery("SELECT datediff(`release`,now()) as days FROM delay WHERE sub_id="+number);
                                      
                                      if (rs2.next())
                                      {
                                       extra=" "+rs2.getString("days");
                                      }
                                      }catch(Exception e)
                                      {
                                          out.println(e.toString());
                                      }
                                    }
                                     out.println("<tr><td><a href='check_metadata.jsp?sid="+number+"'>"+substring+" "+collection[level]+" "+fullname+"</a>"+extra+"</td></tr>");
                                    extra="";
                                    }
                                    out.println("</table>");
                                     out.println("<div align='center'><a href='showactive.jsp' target='_blank' align='center'>Δείτε όλες τις ενεργές εργασίες</a></div></br>");
                                  }
                                  catch(Exception ex)
                                  {
                                       out.println("<p>"+ex.toString()+"</p>") ;
                                  }
                                  
                                    
                                   try
                                   {  
                                    //active tasks();
                                    statement = connection.createStatement();
                                    rs = statement.executeQuery("SELECT * FROM Submission WHERE status="+finalstate+" ORDER BY RAND() LIMIT 5");
                                    //  episης θα εμφανιζει το λινκ για τα αποδεικτικο υποβολής        
                                    out.println("<h4  align='center'>Ολοκληρωμένες Υποβολές</h4>");
                                    out.println("<table border='1'  align='center'>");
                                    
                                    while (rs.next())
                                    {//Στο λινκ τεξτ κατι θα βαλω αν και δε ξερω τι.μαλλον ονομα χρήστη
                                     number=rs.getInt("sub_id");
                                     email=rs.getString("email");
                                     substring=email.substring(0,email.length()-mail.length());
                                     fullname=rs.getString("full_name") ;
                                     level=rs.getInt("col_id");
                                    //θα τυπώσει όσες υποβολές έχουν ολοκληρωθεί  δηλαδή έχουν state = final
                                 
                                     out.println("<tr><td><a href='receipt.jsp?sid="+number+"' target='_blank'>"+substring+" "+collection[level]+" "+fullname+"</a></td></tr>");
                                    }
                                    out.println("</table>");
                                    out.println("<div align='center'><a href='completed.jsp' target='_blank' align='center'>Δείτε όλες τις ολοκληρωμένες υποβολές</a></div>");
                                  }
                                  catch(Exception ex)
                                  {
                                       out.println("<p>"+ex.toString()+"</p>") ;
                                  }
                                    
                                }else
                                if(user.getRole()==3)//secretery
                                {
                                    
                                    
                                    //add new submission(s)
                                  
                                     out.println("<table align='center'><tr><td><form action='newsub.jsp' method='post' style='width: 211px; height: 27px'>"
                                       + "<input class='large blue button' name='Button1' type='submit' value='Υποβολή νέων εργασιών' ></input> </form></td>"
                                   + "<td><form action='mulsub.jsp' method='post' style='width: 211px; height: 27px'>"
                                       + "<input class='large blue button' name='Button2' type='submit' value='Υποβολή πολλαπλών εργασιών' ></input> </form><td><tr></table>"); 
                                   try
                                   {  
                                    //active submissions 
                                    statement = connection.createStatement();
                                    rs = statement.executeQuery("SELECT * FROM Submission WHERE ( status="+finalstate+"  or status=4) AND submitter="+user.getId()+" ORDER BY RAND() LIMIT 5");
                                    //  episης θα εμφανιζει το λινκ για τα αποδεικτικο υποβολής        
                                    out.println("<h4  align='center'>Ολοκληρωμένες Υποβολές</h4>");
                                    out.println("<table border='1'  align='center'>");
                                    while (rs.next())
                                    {//θα τυπώσει όσες υποβολές έχουν ολοκληρωθεί  δηλαδή έχουν state = final 
                                     number=rs.getInt("sub_id");
                                     email=rs.getString("email");
                                     substring=email.substring(0,email.length()-mail.length());     
                                     fullname=rs.getString("full_name") ;  
                                     level=rs.getInt("col_id");
                                     out.println("<tr><td><a href='receipt.jsp?sid="+number+"' target='_blank'>"+substring+" "+collection[level]+" "+fullname+"</a></td></tr>");
                                    }
                                    out.println("</table>");
                                    out.println("<div align='center'><a href='completed.jsp' target='_blank' align='center'>Δείτε όλες τις ολοκληρωμένες υποβολές</a></div>");
                                  }
                                  catch(Exception ex)
                                  {
                                       out.println("<p>"+ex.toString()+"</p>") ;
                                  }
                                    
                                   out.println("<h4  align='center'>Εργασίες υπό έλεγχο</h4>");  
                                  try{  
                                    //active tasks();
                                    statement = connection.createStatement();
                                    rs = statement.executeQuery("SELECT * FROM Submission WHERE status=2 AND submitter="+user.getId()+" LIMIT 5");
                                    
                                    out.println("<table border='1' align='center'>");
                                    while (rs.next())
                                    {//Στο λινκ τεξτ κατι θα βαλω αν και δε ξερω τι.μαλλον ονομα χρήστη
                                     number=rs.getInt("sub_id");   
                                     fullname=rs.getString("full_name") ;
                                     email=rs.getString("email");
                                     substring=email.substring(0,email.length()-mail.length());
                                     level=rs.getInt("col_id");
                                     out.println("<tr><td>"+substring+" "+collection[level]+" "+fullname+"</td></tr>");
                                    }
                                    out.println("</table>");
                                     out.println("<div align='center'><a href='showactive.jsp' target='_blank' align='center'>Δείτε όλες τις ενεργές εργασίες</a></div></br>");
                                  }
                                  catch(Exception ex)
                                  {
                                       out.println("<p>"+ex.toString()+"</p>") ;
                                  }  
                                     
                                   //εμφανίζει όσους δεν εχουν αρχίσει την υποβολή
                                   try
                                   {                                      
                                    statement = connection.createStatement();
                                    rs = statement.executeQuery("SELECT * FROM Submission WHERE status=0 AND submitter="+user.getId()+" ORDER BY RAND() LIMIT 5");                                           
                                    out.println("<h4  align='center'>Μη ενεργές υποβολές</h4>");
                                    out.println("<table border='1'  align='center'>");
                                    while (rs.next())
                                    {                                 
                                     email=rs.getString("email");   
                                     substring=email.substring(0,email.length()-mail.length());   
                                     level=rs.getInt("col_id");
                                     out.println("<tr><td>"+substring+" "+collection[level]+"</td></tr>");
                                    }
                                    out.println("</table>");
                                    out.println("<div align='center'><a href='nonactive.jsp' target='_blank' align='center'>Δείτε όλες τις μη ενεργές υποβολές</a></div>");
                                  }
                                  catch(Exception ex)
                                  {
                                       out.println("<p>"+ex.toString()+"</p>") ;
                                  }    
                                    
                                }
                            }
                             
                         }catch(Exception ex)
                         {
                                
                          }
                            %></div>

		</div>

	</div>
<div class="clear">
</div>
<%@include file="footer.jsp" %>
</body>

</html>
                            
                            
