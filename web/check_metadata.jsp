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
String subid="";
 if((session.getAttribute("verified")==null)||(Integer)session.getAttribute("verified")!=1)
     {
pagetoshow="<a href='index.jsp'></br>Δεν έχετε κάνει σύνδεση<br/>Πάτηστε για login</a>";
 }
 else
 {
     pagetoshow="";
     subid=request.getParameter("sid");
     
    // session.setAttribute("subid",request.getParameter("sid")); 
     
     
 }
%>

<script type="text/javascript">
    var counter=0; 
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
   var area1 = document.getElementById("bt1");
   var but1 =document.createElement("input")
   but1.setAttribute("type", "submit");
   but1.value= "Αποστολή σφαλμάτων"
   
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
        counter++;
        if (!area1.hasChildNodes())
        {
          area1.appendChild(but1);
        }
        
        
    }
    else
    {
        try{
        contentArea.removeChild(contentArea.firstChild);            
        contentArea.removeChild(contentArea.firstChild);
        contentArea.removeChild(contentArea.firstChild);
        counter -- ;
        if(counter==0)
        {
          area1.removeChild(area1.firstChild);
        }
        }
        catch(e)
        {
        }
    }
    return false;
    //document.getElementById("fileerror").innerHTML("<textarea name='filetextarea' style='width: 250px; height: 90px'>Sfalma arxeioy</textarea>");
}

function displayerrorBox(num)
{
    var txtarea=document.createElement("textarea");
    txtarea.name="errorarea"+num;
    var labeltext=document.createTextNode("Περιγραφή Σφάλματος");
    var label =document.createElement("label");    
    label.appendChild(labeltext);
    var contentArea=document.getElementById("errorbox"+num);
    var cbox=document.getElementById("Checkbox"+num);
   var br =document.createElement("br");
   var area1 = document.getElementById("bt1");
   var but1 =document.createElement("input")
    but1.setAttribute("type", "submit");
     but1.value= "Αποστολή σφαλμάτων"
    if (cbox.checked)
    {
        try{        
        while (contentArea.hasChildNodes()) {   
        contentArea.removeChild(contentArea.firstChild);
        }
        }
        catch(e)
        {
        }
        contentArea.appendChild(label);
        contentArea.appendChild(br); 
        contentArea.appendChild(txtarea);
        counter++;
        if (!area1.hasChildNodes())
        {
          area1.appendChild(but1);
        }
    }
    else
    {
        try{ 
        while (contentArea.hasChildNodes()) {   
        contentArea.removeChild(contentArea.firstChild);
        contentArea.removeChild(contentArea.firstChild);
        contentArea.removeChild(contentArea.firstChild);
        counter -- ;
        if(counter==0)
        {
          area1.removeChild(area1.firstChild);
        }
       
        }
        }
        catch(e)
        {
        }
    }
    return false;
}
</script>



<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>Έλεγχος Στοιχείων Υποβολής</title>
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
                            out.println(pagetoshow);
                            %>
                            <%
                            if ((session.getAttribute("verified")!=null)&&(Integer)session.getAttribute("verified")==1)
                            {
                               
                                if(user.getRole()==2)//library
                                {
                                    
                                  statement = connection.createStatement();
                                  rs = statement.executeQuery("SELECT * FROM Submission where  '"+subid+"'=sub_id;");
                                  if(!rs.next())
                                  {
                                      //Δεν υπάρχει τέτοια υποβολή
                                  }
                                  else //Εμφάνιση εγγραφής
                                  {  
                                   int bitid= rs.getInt("bit_id"); 
                                   Integer itemid=rs.getInt("item_id");
                                   String email = rs.getString("email");
                                   int number=rs.getInt("sub_id"); 
                                   String extra="";
                                   int  level = rs.getInt("col_id"); 
                                   String element="";
                                   boolean wait=false;
     

                                    
                                    try {
                                       remoteservice.NeoWS service = new remoteservice.NeoWS();
                                       remoteservice.NeoWSPortType port = service.getNeoWSHttpSoap11Endpoint();

                                       out.println("<h2>Έλεγχος στοιχειών υποβολής</h2>");   

                                       out.println("Αν υπάρχει σφάλμα πατήστε το αντίστοιχο κουτάκι δεξιά για να περιγράψετε το σφάλμα</br>"
                                                 + "Μπορείτε να κάνετε και απευθείας αλλαγές πάνω στα μεταδεδομένα</br>");
                                       out.println("</br><form action='showactive.jsp' method='post'>"
                                                +"<input type='hidden' id='sub_id' name='sub_id' value='"+subid+"' />" 
                                               + "<a href='http://"+dspaceserver+retrieve+bitid+"' target='_blank'>"
                                               + "Δείτε το αρχείο</a><input name='filecbox' id='fcbox' onclick='displayFerrorBox()' name='FileCheckbox' type='checkbox' />");
                                       out.println("<div id='fileerror'></div>");
                                       out.println("</br></br>");
                                       //Εμφάνιση Μεταδεδομένων
                                       String result ="";
                                       elSubject=null;
                                       enSubject=null;
                                       elCounter=0;
                                       enCounter=0;
                                       boolean dual=false;
                                       out.println( "<table border='1' cellpadding='1' cellspacing='1' align='center'>  <tbody>");
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
                                           if (metadata[i][2].equals("subject"))// αν είναι dc.subject 
                                           {
                                              if (metadata[i][4].equals("el"))//αν είναι στα ελληνικά
                                              {
                                                  if(elCounter==0)
                                                  {
                                                      result=port.showMetadataValue(dspaceuser, itemid.toString(), metadata[i][1], metadata[i][2], metadata[i][3], metadata[i][4]);
                                                      elSubject=result.split(",");
                                                  }
                                                  result=elSubject[elCounter++];                                                  
                                              }
                                              if (metadata[i][4].equals("en"))//αν είναι στα αγγλικα
                                              {
                                                  if(enCounter==0)
                                                  {
                                                      result=port.showMetadataValue(dspaceuser, itemid.toString(), metadata[i][1], metadata[i][2], metadata[i][3], metadata[i][4]);
                                                      enSubject=result.split(",");
                                                  }
                                                  result=enSubject[enCounter++];                                                  
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
                                           out.println("<table align='center'><tr><td colspan='2' align='center'><b style='color:#43648d' >"+metadata[i][0]+"</b></td></tr>"+
                                            "<tr><td><textarea "+element+" name='metadataValue"+i+"' >"
                                            +result+"</textarea></td>");
                                           if(!metadata[i][2].equals("subject"))
                                           {
                                           out.println("<td><input name=cbox"+i+" id='Checkbox"+i+"' onclick='displayerrorBox("+i+")' type='checkbox' /></td>");
                                           }
                                           out.println("</tr><tr><td colspan='2' ><div align='center' width='100%' id='errorbox"+i+"'></div></td></tr></table>");
                                            
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
                                        
                                   //    dc 	description
                                         result=port.showMetadataValue(dspaceuser, itemid.toString(),"dc", "description","","el");
                                         
                                         out.println("<tr><td align='center' colspan='2'><table align='center'><tr><td colspan='2'><b style='color:#43648d'>Περιγραφή</b></td></tr>"+
                                            "<tr><td><textarea name='description' style='width: 250px; height: 90px'>"
                                            +result
                                            + "</textarea></td></tr></table></td></tr>"); 
                                         out.println(" </tbody></table>");
                                         
                                        if (level==2)
                                        {
                                        statement2 = connection.createStatement();
                                        try{
                                        rs2 = statement2.executeQuery("SELECT datediff(`release`,now()) as days FROM delay WHERE sub_id="+number+" and checked=false");

                                        if (rs2.next())
                                        {
                                       //     out.println("exei periodo anamonhs");
                                            wait =true;
                                           extra=" "+rs2.getString("days");
                                        }
                                        }catch(Exception e)
                                        {
                                            out.println(e.toString());
                                        }
                                       }
                                         if (wait){
                                           out.println("Έχει περίοδο αναμονής"+extra+" μέρες.</br><div name='bt1' id='bt1'></div>"); 
                                         } 
                                        else{
                                           out.println("<br/><input name='Submit' type='submit' value='Υποβολή' />");
                                        }
                                        
                                         out.println("</form>");
                                         
                                        if (wait){
                                           out.println("<form action='doctorate.jsp' method='post'>"
                                               +"<input type='hidden' id='sub_id' name='sub_id' value='"+subid+"' />"
                                               +"<input name='Submit' type='submit' value='Ενημέρωση Γραμματείας' />"
                                               + "</form>" );
                                       }
                                         rs.close(); 
                                      } catch (Exception ex) 
                                      {
                                            // TODO handle custom exceptions here
                                      }
                                 }
                                }
                                else                              
                                {
                                   out.println("<p>Δεν έχεις δικαίωμα πρόσβασης σε αυτή τη σελίδα</p>");

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