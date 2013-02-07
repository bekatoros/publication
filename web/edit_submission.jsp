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
String pagetoshow;
String sub_id="0";
 if((session.getAttribute("verified")==null)||(Integer)session.getAttribute("verified")!=1)
     {
pagetoshow="<a href='index.jsp'></br>Δεν έχετε κάνει σύνδεση<br/>Πάτηστε για login</a>";
 }
 else
 {
     pagetoshow="";
     if(request.getParameter("sub_id")!=null)
                 {
     sub_id = request.getParameter("sub_id"); 
         }
     
 }
%>

<script type="text/javascript">
function displayFerrorBox()
{
    var txtarea=document.createElement("textarea");
    txtarea.name="ferrorarea";
    var labeltext=document.createTextNode("Περιγραφή Σφάλματος");
    var contentArea=document.getElementById("fileerror");
    var label =document.createElement("label");    
    label.appendChild(labeltext);
    var br =document.createElement("br");
    var cbox=document.getElementById("fcbox");
   
    if (cbox.checked)
    {
        try{        
        contentArea.removeChild(contentArea.firstChild);
        contentArea.removeChild(contentArea.firstChild);
        contentArea.removeChild(contentArea.firstChild);
        }
        catch(e)
        {
        }
        contentArea.appendChild(label);        
        contentArea.appendChild(br);        
        contentArea.appendChild(txtarea);
        
        
    }
    else
    {
        try{
        contentArea.removeChild(contentArea.firstChild);            
        contentArea.removeChild(contentArea.firstChild);
        contentArea.removeChild(contentArea.firstChild);
        }
        catch(e)
        {
        }
    }
    return false;
    //document.getElementById("fileerror").innerHTML("<textarea name='filetextarea' style='width: 250px; height: 90px'>Sfalma arxeioy</textarea>");
}


</script>

<%

String msg="";
 try{
if((Integer)session.getAttribute("verified")==1)
{     
           
      
}
  
}
catch(Exception E)
{
   // out.println("epiasa to sfalma");
  //System.out.println("sfalma"+E.toString());
} 
  
%>


<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>Επεξεργασία - Εμφάνιση Δημοσίευσης</title>
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
                            out.println(pagetoshow);
                            %>
                            <%
                            if ((session.getAttribute("verified")!=null)&&(Integer)session.getAttribute("verified")==1)
                            {
                               
                                if((user.getRole()==1)&&(!sub_id.equals("0")))
                                {
                                    
                                  statement = connection.createStatement();
                                  rs = statement.executeQuery("SELECT * FROM sp_Publication where  '"+sub_id +"'=sub_id;");
                                  if(!rs.next())
                                  {
                                      //Δεν υπάρχει τέτοια υποβολή
                                  }
                                  else //Εμφάνιση εγγραφής
                                  {  
                                   int bitid= rs.getInt("bit_id"); 
                                   Integer itemid=rs.getInt("item_id");
                                  // session.setAttribute("email",rs.getString("email") );
                                   session.setAttribute("itemid",itemid);  
                                   String element="";

     
  
	
	
                                    
                                    try {
                                //	allo.paketo.NeoWS service = new allo.paketo.NeoWS();
                                   //     allo.paketo.NeoWSPortType port = service.getNeoWSHttpSoap12Endpoint();
	

                                        mydspacews.DspaceWS service = new mydspacews.DspaceWS();
                                        mydspacews.DspaceWSPortType port = service.getDspaceWSHttpSoap12Endpoint();
	

                                       out.println("<h2>Αλλαγή στοιχείων δημοσίευσης</h2>");   

                                     //  out.println("Αν υπάρχει σφάλμα πατήστε το αντίστοιχο κουτάκι δεξιά για να περιγράψετε το σφάλμα</br>"
                                  //               + "Μπορείτε να κάνετε και απευθείας αλλαγές πάνω στα μεταδεδομένα</br>");
                                       out.println("</br><form action='active.jsp' method='get'><input type='hidden' name='sub_id' value='"+sub_id+"'>"
                                               +"<input type='hidden' id='sub_id' name='sub_id' value='"+sub_id+"' />" 
                                               + "<a href='http://"+dspaceserver+retrieve+bitid+"' target='_blank'>"
                                               + "Δείτε το αρχείο</a>");
                                      // out.println("<div id='fileerror'></div>");
                                       out.println("</br></br>");
                                       //Εμφάνιση Μεταδεδομένων
                                       String result ="";
                                       elSubject=null;
                                       enSubject=null;
                                       elCounter=0;
                                       enCounter=0;
                                       boolean dual=false;
                                       out.println( "<table border='0' cellpadding='0' cellspacing='0' align='center'>  <tbody>");
                                       for (int i=0;i<metadata.length;i++)
                                       {    
                                           if (metadata[i][7].equals("0"))
                                           {                                        
                                               out.println("<tr><td align='center' colspan='2'>");
                                           }
                                           else
                                           {                                            
                                               if(dual)//αν έχει προηγηθεί το πρώτο από τα 2
                                               {                                                
                                                  out.println("<td align='center'>");
                                               }   
                                               else//αν είναι το πρώτο από το ζευγάρι
                                               {
                                                   out.println("<tr><td align='center'>");
                                               }
                                           }
                                           //System.out.println("quering metadata "+(i+1)+" of "+metadata.length);
                                           try{
                                           result="";
                                           if (metadata[i][2].equals("contributor"))// αν είναι dc.contributor 
                                           {
                                             if (metadata[i][4].equals("el"))//αν είναι στα ελληνικά
                                              {
                                                  if(elCounter==0)
                                                  {
                                                     result=port.showMetadataValue(dspaceuser, itemid.toString(), metadata[i][1], metadata[i][2], metadata[i][3], metadata[i][4]);
                                                      elSubject=result.split("%");
                                                      elCounter++;
                                                      result="";
                                                  }
                                                //  result=elSubject[elCounter++];                                                  
                                              }
                                              if (metadata[i][4].equals("en"))//αν είναι στα αγγλικα
                                              {
                                                  if(enCounter==0)
                                                  {
                                                      result=port.showMetadataValue(dspaceuser, itemid.toString(), metadata[i][1], metadata[i][2], metadata[i][3], metadata[i][4]);
                                                      enSubject=result.split("%");
                                                      enCounter++; result="";
                                                  }
                                               //   result=enSubject[enCounter++];  
                                               
                                              }
                                           }
                                           else // Αν ειναι διαφορετικό από dc.subject
                                           {
                                             result=port.showMetadataValue(dspaceuser, itemid.toString(), metadata[i][1], metadata[i][2], metadata[i][3], metadata[i][4]);
                                           }    
                                                   
                                           } catch (Exception ex) 
                                           {
                                                    // TODO handle custom exceptions here
                                           }
                                           
                                           if (metadata[i][6].equals("0"))
                                           {
                                                element="style='width: 250px; height: 25px' type='text'";
                                           }
                                           else
                                           {
                                               element="style='width: 250px; height: 90px'";
                                           }
                                            if (!metadata[i][2].equals("contributor"))// αν είναι dc.contributor 
                                           {
                                           out.println("<table align='center'><tr><td colspan='2' align='center'><b style='color:#43648d' >"+metadata[i][0]+"</b></td></tr>"+
                                            "<tr><td><textarea "+element+" name='metadataValue"+i+"' >" +result+"</textarea></td>");                                          
                                           out.println("</tr></table>");
                                                                                    }
                                           if (metadata[i][7].equals("0"))
                                           {                                        
                                               out.println("</td></tr>");
                                           }
                                           else
                                           {                                            
                                               if(dual)//αν έχει προηγηθεί το πρώτο από τα 2
                                               {
                                                   out.println("</td></tr>");
                                                   dual=false;
                                               }   
                                               else//αν είναι το πρώτο από το ζευγάρι
                                               {
                                                   out.println("</td>");
                                                   dual=true;
                                               }
                                           }
                                           

                                        }                          
                                       /*
                                        if(enSubject!=null){   
                                        for (int i=0;i<enSubject.length;i++)
                                            {                               
                                                out.println("<tr><td align='center' colspan='2'>"
                                                    + "<b style='color:#43648d' >Συγγραφέας στα Αγγλικά</b></br>"
                                                    + "<textarea style='width: 250px; height: 25px' type='text'"
                                                    + " name='writer"+i+"' >"+enSubject[i]+"</textarea></td></tr>");
                                            }
                                        } */
                                      
                                        if(elSubject!=null){   
                                        for (int i=0;i<elCounter;i++)
                                            {                               
                                                out.println("<tr><td align='center' colspan='2'>"
                                                    + "<b style='color:#43648d' >Συγγραφέας στα Ελληνικά</b></br>"
                                                    + "<textarea style='width: 250px; height: 25px' type='text'"
                                                    + " name='writer"+i+"' >"+elSubject[i]+"</textarea></td></tr>");
                                            }
                                        }                                        
                        
                                         out.println(" </tbody></table>"+"<input type='hidden' id='writers_no' name='writers_no' value='"+elSubject.length+"' />" );
                                         out.println("<br/><table align ='center'><tr><td><form  method='post' action='active.jsp'><input class='large blue button' type='submit' value='Επιστροφή' name='Button1'></form></td>"
                                                 + "<td>&nbsp;&nbsp;</td>"
                                                 + "<td><input class='large blue button' name='Submit' type='submit' value='Υποβολή Αλλαγών' name='Button1' /></td></tr></table></form>"
                                                 + "<div></br></div></br>");

                                      rs.close(); 
                                      } catch (Exception ex) 
                                      {
                                            // TODO handle custom exceptions here
                                       out.println(ex.toString());
                                      }
                                 }
                                }
                           else   if((user.getRole()==1)&&(sub_id.equals("0")))
                            {
                               out.println("<p>Δεν επέλεξες σωστή δημοσίευση.</p><br>"
                                       + "<a href='central.jsp'>Επιστροφή στην αρχική σελίδα </a>");
                               
                              }  else                              
                                {
                                   out.println("<p>Δεν έχεις δικαίωμα πρόσβασης σε αυτή τη σελίδα</p>");

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
	<div id="container">

		

</body>

</html>