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
String pagetoshow= "<a href='index.jsp'></br>Δεν έχετε κάνει σύνδεση<br/>Πάτηστε για login</a>";
String msg="";
 try{
if((Integer)session.getAttribute("verified")==1)
{
    String errormsg="";
    boolean trigger=false; 
  
        
      String subid =(String) request.getParameter("sub_id");        
         
        
      statement = connection.createStatement();
      rs = statement.executeQuery("SELECT * FROM Submission where  '"+subid+"'=sub_id;");
      if(!rs.next())
      {
                                      //Δεν υπάρχει τέτοια υποβολή
      }
       else //Εμφάνιση εγγραφής
      {  
          
       int bitid= rs.getInt("bit_id"); 
       String itemid=rs.getString("item_id");
       String email = rs.getString("email");
                                   //itemid",itemid);  
       String element="";
      //  int temp=(Integer)session.getAttribute("itemid");
      /*  if(subid.equals("-1"))
        {
            throw new Exception();
        }
        if(temp==-1)
        {
            throw new Exception();
        }*/
      
        remoteservice.NeoWS service = new remoteservice.NeoWS();
        remoteservice.NeoWSPortType port = service.getNeoWSHttpSoap11Endpoint();
        String MDvalue;
        String result;
        
        result = port.clearMetaData(dspaceuser,itemid, "dc","subject","","el");
        result = port.clearMetaData(dspaceuser,itemid, "dc","subject","","en");       
        for (int i=0;i<metadata.length;i++)
        {
            try {

              /*
              *Θα γίνεται changeMetaData στο DSpace για όλα τα μεταδεδομένα
              */
            MDvalue=StringToUTF(request.getParameter("metadataValue"+i)); 
            //System.out.println("changing Metadata"+i);
            if(metadata[i][2].equals("subject"))
            { //Αν είναι τύπου subject
                result = port.addMetadata(dspaceuser,itemid, metadata[i][1], metadata[i][2], metadata[i][3], metadata[i][4], MDvalue); 
            }
            else
            {//Αν είναι άλλου τύπου
                result = port.changeMetadata(dspaceuser,itemid, metadata[i][1], metadata[i][2], metadata[i][3], metadata[i][4], MDvalue); 	
            }        


            } catch (Exception ex) {
                // TODO handle custom exceptions here
            }

            if((request.getParameter("cbox"+i)!=null)&&(request.getParameter("cbox"+i).equalsIgnoreCase("on")))
            {
                trigger=true;
             try{   
             errormsg=StringToUTF(request.getParameter("errorarea"+i));
             //SQL SUB_ERROR με i gia arithmo error msg
             statement = connection.createStatement();
             int res = statement.executeUpdate("INSERT INTO Sub_Error (sub_id,error,description,metadata_id)VALUES ('"+subid+"', '', '"+errormsg+"', '"+i+"')");
             }
             catch(Exception e){}    

            }
        }
        
        try {
        MDvalue=StringToUTF(request.getParameter("description"));
        result=port.changeMetadata(dspaceuser, itemid.toString(),"dc", "description","","el",MDvalue);
        }        
        catch(Exception e){} 
           
        if((request.getParameter("filecbox")!=null)&&(request.getParameter("filecbox").equalsIgnoreCase("on")))
        {
            trigger=true;
         try
         {    
         errormsg=StringToUTF(request.getParameter("ferrorarea"));
         statement = connection.createStatement();
         int res2 = statement.executeUpdate("INSERT INTO Sub_Error (sub_id,error,description,metadata_id)VALUES ('"+subid+"', '', '"+errormsg+"', '-1')");

         }catch(Exception e){}

            //SQL INSERT   ERROR -1 για το αρχειο
        }
        String message;
         //αν δεν έχει υπάρξει σφάλμα
        if (!trigger)
        {
             try { 
             //kane to state toy submission se finalstate 
             statement = connection.createStatement();                 
             int res=statement.executeUpdate("UPDATE Submission SET status = '"+finalstate+"' WHERE sub_id ='"+subid+"' LIMIT 1 ;");
             res=statement.executeUpdate("UPDATE Submission SET completion =now() WHERE sub_id ='"+subid+"' LIMIT 1 ;");
             }
             catch(Exception E)
             {}   
           // System.out.println("complete Submission");
            try {	        
            result = port.completeSubmission(dspaceuser,itemid);  
            result = port.clearMetaData(dspaceuser,itemid,"dc","description","provenance","en");
            } catch (Exception ex) {
                // TODO handle custom exceptions here
            }



            /*
            *steile mail sto foithth oti h ypovolh oloklhrothike
            */   
            message=messageFinished;
            String secemail="";
            String secretary="";
            // steile mail sth grammateia oti h ypovolh oloklhrothike  
            statement = connection.createStatement();
            rs = statement.executeQuery("select email from User where id=(SELECT submitter FROM `Submission` WHERE sub_id="+subid+")");
            if(rs.next())
            {
              secretary=rs.getString("email");  
             secemail="Ολοκληρώθηκε η υποβολή για μια εργασία \n"
                     + "Παρακαλώ μπείτε στο http://"+appserver+"/Platform/receipt.jsp?sid="+subid
                     + " για το Αποδεικτικό Υποβολής\n"
                     + "Με εκτίμηση η Βιβλιοθήκη του Πανεπιστημίου";
            }      

           // Αποστολή μηνύματος  ηλεκτρονικού ταχυδρομείου
           sendMail(mailuser+mail,secretary,"Υποβλήθηκε μια Εργασία",secemail,mailserver,mailuser+mail,mailpass);

        }//αν έχει υπάρξει σφάλμα
        else
        {
            //SQL kane to state toy submission se errorstate

             try {
             int res=statement.executeUpdate("UPDATE Submission SET status = '"+errorstate+"' WHERE sub_id ='"+subid+"' LIMIT 1 ;");
             }
             catch(Exception E)
             {} 
            //steile mail sto foithth oti yphrxe sfalma kai prepei na xanabei sto systhma          
             message=messageError;

        }
       // Αποστολή μηνύματος  ηλεκτρονικού ταχυδρομείου
       sendMail(mailuser+mail,email,"Υποβολή Εργασίας",message,mailserver,mailuser+mail,mailpass);

           
      
}
}

}
catch(Exception E)
{
    
    
   // out.println("epiasa to sfalma");
  out.println("sfalma"+E.toString());
} 
  
%>





<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	
	<title>Ενεργές Εργασίες</title>
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

		 <div id="header" align='center'>		
	
				<table>
					<tr>
						<td >
							<img src='images/hua1.gif' width='61' height='60' />
						</td>
						<td >
							<h2><a href='http://www.hua.gr'>Χαροκόπειο Πανεπιστήμιο</a></h2>
                                                        </br>					
							<h2><a href='http://www.hua.gr/index.php?option=com_content&view=article&id=37&Itemid=318&lang=el'>Βιβλιοθήκη και Κέντρο Πληροφόρησης</a></h2>	
							
						</td>
					</tr>
					<tr>
					<td colspan="2"><h1><a href="central.jsp">Σύστημα Ηλεκτρονικής Υποβολής Εργασιών στην ΕΣΤΙΑ</a></h1></td>
					</tr>
				</table>
		
			
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

		<div id="main">

			<div id="content"  class="auto-style3">
                           <%
                               int number;
                         String fullname;
                                    String email;
                                    String substring;
                                    int level;
                                    String extra="";
                                
                            if ((session.getAttribute("verified")!=null)&&(Integer)session.getAttribute("verified")==1)
                            {
                                  session.setAttribute("subid","-1");
                                  session.setAttribute("itemid",-1);

                                if(user.getRole()==1)//administrator
                                {
                                   out.println("<p>Δεν έχεις δικαίωμα πρόσβασης σε αυτή τη σελίδα</p>");

                                }else
                                if(user.getRole()==2)//library
                                {
                                    out.println("<p>"+msg+"</p>");
                                
                                    
                                  out.println("<a href='showactive.jsp' align='center'>Ενεργές εργασίες</a>");  
                                  try{  
                                    //active tasks();
                                      
                                    
                                    statement = connection.createStatement();
                                    rs = statement.executeQuery("SELECT * FROM Submission WHERE status=2 or status=4 ");
                                    
                                    out.println("<table border='1' align='center'>");
                                    while (rs.next())
                                    {//Στο λινκ τεξτ κατι θα βαλω αν και δε ξερω τι.μαλλον ονομα χρήστη
                                     number=rs.getInt("sub_id");  
                                     fullname=rs.getString("full_name") ;
                                     email=rs.getString("email");                                     
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
                                         
                                     substring=email.substring(0,email.length()-mail.length());
                                     out.println("<tr><td><a href='check_metadata.jsp?sid="+number+"'>"+substring+" "+collection[level]+" "+fullname+"</a>"+extra+"</td></tr>");
                                    extra="";
                                    }
                                    out.println("</table>");                                  
                                  }
                                  catch(Exception ex)
                                  {
                                       out.println("<p>"+ex.toString()+"</p>") ;
                                  }

                                }else
                                if(user.getRole()==3)//secretery
                                {
                                    out.println("<h4  align='center'>Εργασίες υπό έλεγχο</h4>");  
                                  try{  
                                    //active tasks();
                                    statement = connection.createStatement();
                                    rs = statement.executeQuery("SELECT * FROM Submission WHERE status=2   AND submitter="+user.getId()+" ");
                                    
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
                                   }
                                  catch(Exception ex)
                                  {
                                      // out.println("<p>"+ex.toString()+"</p>") ;
                                  }  
                                     
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
	<div id="footer">
		<p>Επικοινωνία<br />
		<a href="license.html">Άδεια χρήσης</a> - <a href="about.html">About</a>
                </p>
	</div>
</body>

</html>