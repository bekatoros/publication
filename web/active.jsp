<%@page import="java.io.DataInputStream"%>
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
 boolean change= false;
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
     if((request.getParameter("Submit")!=null)&&
             (StringToUTF(request.getParameter("Submit")).equals("Υποβολή Αλλαγών")))
       
     {
         change=true;  
     }
     
 }
%>

<%


if((user.getRole()==1)&&(!sub_id.equals("0")))//erxetai apo to edit_submission
{
       statement = connection.createStatement();
       rs = statement.executeQuery("SELECT * FROM sp_Publication where  '"+sub_id +"'=sub_id;");
       if(rs.next())
       {
           int status = rs.getInt("status");          
           
           
           if ((status==finalstate)&&(change))//allazoyme ta metadedomena
           {
           //   out.print("allazo ta metadedomena");
               
    String errormsg="";
    boolean trigger=false; 
   //perno to sub_id
     sub_id =(String) request.getParameter("sub_id");        
    //erothma sth vash gia item_id
       rs2 = statement.executeQuery("SELECT * FROM sp_Publication where  sub_id="+sub_id+";");
      //out.println("mphka");
        String id="";
        if (rs2.next()){
                                            
           id = ""+rs2.getInt("item_id"); 
           
         }  
        String itemid=""+id;
        
        mydspacews.DspaceWS service = new mydspacews.DspaceWS();
	mydspacews.DspaceWSPortType port = service.getDspaceWSHttpSoap12Endpoint();
	
        String MDvalue;
        String result;        
        //svhnei toys authors sta ellhnika
     //   result = port.clearMetaData(dspaceuser,itemid, "dc","subject","","el");
        //svhno toys authors sta agglika
       // result = port.clearMetaData(dspaceuser,itemid, "dc","subject","","en");       
      //allazo ta metadedomena ektos apo toys authors
        for (int i=0;i<metadata.length;i++)
        {
            try {

              /*
              *Θα γίνεται changeMetaData στο DSpace για όλα τα μεταδεδομένα
              */
            MDvalue=StringToUTF(request.getParameter("metadataValue"+i)); 
            
            if(metadata[i][2].equals("title")&&metadata[i][4].equals("el"))
            { //kanoyme updata sto titlo sth vasi
                statement = connection.createStatement(); 
                statement.executeUpdate("Update sp_Publication SET `title` = '"+MDvalue+"' WHERE sub_id ="+sub_id+" LIMIT 1 ;");    
     
            }
            
           if(i==citationnum)
           {
             statement.executeUpdate("Update sp_Publication SET `citation` = '"+ MDvalue+"' WHERE sub_id ="+sub_id+" LIMIT 1 ;");    
           }
          
             if(i==yearnum)
           {
             statement.executeUpdate("Update sp_Publication SET `year` = '"+ MDvalue+"' WHERE sub_id ="+sub_id+" LIMIT 1 ;");    
           }
            
            if(metadata[i][2].equals("contributor"))
            { //Αν είναι τύπου subject
              //  result = port.changeMetadata(dspaceuser,itemid, metadata[i][1], metadata[i][2], metadata[i][3], metadata[i][4], MDvalue); 
            }
            else
            {//Αν είναι άλλου τύπου
                result = port.changeMetadata(dspaceuser,itemid, metadata[i][1], metadata[i][2], metadata[i][3], metadata[i][4], MDvalue); 	
            }       


            } catch (Exception ex) {
                // TODO handle custom exceptions here
            }

            
        }
        int k=-1;
        k=Integer.parseInt(request.getParameter("writers_no"));
      //  out.println("o arithmos twn writer einai"+k);
        result = port.clearMetaData(dspaceuser,itemid, "dc", "contributor","author", "el"); 
      //  out.println("apotelesma "+result);
        for (int j=0; j < k  ;j++)
        {
            
            try{
          
                MDvalue=StringToUTF(request.getParameter("writer"+j)); 
               // out.println(MDvalue);
                result = port.addMetadata(dspaceuser,itemid, "dc", "contributor","author", "el", MDvalue); 
           }
            catch (Exception ex) {
                out.println(ex.toString());
                // TODO handle custom exceptions here
            }
        }
        
        
     /*   
                isos na toy dino th dynatothta na antikathista to arxeio tha doyme.   
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
      */
 
           }                          
     }  
}



%>




<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	
	<title>Υποβληθείσες Δημοσιεύσεις</title>
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
                            if ((session.getAttribute("verified")!=null)&&(Integer)session.getAttribute("verified")==1)
                            { 
                                if(user.getRole()==1)
                                {
                                    try{
                                  String title="";  
                                  // sub_id=0;
                                            String item_id="";
                                            statement = connection.createStatement();
                                            rs = statement.executeQuery("SELECT * FROM sp_Publication WHERE status="+finalstate+" AND user_id="+user.getId()+" ORDER BY RAND()");                                           
                                            out.println("<h4  align='center'>Yποβληθείσες Δημοσιεύεσεις</h4>");
                                            out.println("<table border='1'  align='center'>");
                                            while (rs.next())
                                            {                                 
                                              title=rs.getString("title");  
                                              item_id=rs.getString("item_id");
                                              sub_id=rs.getString("sub_id");
                                            //substring=email.substring(0,email.length()-mail.length());   
                                            //level=rs.getInt("col_id");
                                            out.println("<tr><td><a href='edit_submission.jsp?sub_id="+sub_id+"'>"+title+"</a></td></tr>");
                                            }
                                            out.println("</table>");
                                          //  out.println("<div align='center'><a href='active.jsp' target='_blank' align='center'>Δείτε όλες τις δημοσιεύεσεις</a></div>");
                                                                      
                                  }
                                  catch(Exception ex)
                                  {
                                       out.println("<p>"+ex.toString()+"</p>") ;
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

     
			<!-- end of main -->
			<div class="cl">&nbsp;</div>
			
			<!-- footer -->
			<div id="footer">
				<div class="footer-nav">
					<ul>
						<li><a href="license.html">Άδεια χρήσης</a> </li>
						<li><a href="about.html">About</a></li>
						<li> <a href="mailto:bekatoros@hua.gr">Επικοινωνία</a></li>
						
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