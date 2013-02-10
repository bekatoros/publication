<jsp:useBean id="user" class="mypak.User" scope="session"/>
<%--
    Document   : central
    Created on : Apr 20, 2011, 6:42:08 PM
    Author     : Marios
--%>
<%@page import="mypak.User"%>
<%@page import="java.io.DataInputStream"%>
<%@page import="java.lang.Integer"%>
<%@page import="java.sql.*" %>

<%@include file= "variables.jsp" %>
<%@include file= "functions.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<script type="text/javascript">
function fileSelected() {
        var file = document.getElementById('fileToUpload').files[0];
        if (file) {
          var fileSize = 0;
          if (file.size > 1024 * 1024)
            fileSize = (Math.round(file.size * 100 / (1024 * 1024)) / 100).toString() + 'MB';
          else
            fileSize = (Math.round(file.size * 100 / 1024) / 100).toString() + 'KB';
  
          //document.getElementById('fileName').innerHTML = 'Όνομα : ' + file.name;
          document.getElementById('fileSize').innerHTML = 'Μέγεθος : ' + fileSize;
        //  document.getElementById('fileType').innerHTML = 'Τύπος : ' + file.type;
        
        }
      }

      function uploadFile() {
        var fd = new FormData();
        fd.append("fileToUpload", document.getElementById('fileToUpload').files[0]);
      //  fd.append("sub_id", document.getElementById('sub_id').value);
        var xhr = new XMLHttpRequest();        
        xhr.upload.addEventListener("progress", uploadProgress, false);
        xhr.addEventListener("load", uploadComplete, false);
        xhr.addEventListener("error", uploadFailed, false);
        xhr.addEventListener("abort", uploadCanceled, false);        
        xhr.open("POST", "upload.jsp");
        lb=document.createElement('label');
        lb.innerHTML='Πρόοδος ανεβάσματος : ';
        document.getElementById('prbar').appendChild(lb);
        pr=document.createElement('progress');
        //pr.setIdAttribute('pr', true);
        pr.id='pr';
        pr.setAttribute('max','100');
        pr.setAttribute('value','0');
        document.getElementById('prbar').appendChild(pr);
        document.getElementById('bt1').style.visibility="hidden";

        xhr.send(fd);
      }

      function uploadProgress(evt) {
        if (evt.lengthComputable) {
          var percentComplete = Math.round(evt.loaded * 100 / evt.total);
       //   document.getElementById('progressNumber').innerHTML = percentComplete.toString() + '%';
          document.getElementById('pr').setAttribute('value', percentComplete.toString());
          
        }
        else {
          document.getElementById('progressNumber').innerHTML = 'unable to compute';
        }
      }

      function uploadComplete(evt) {
           location.href = 'submit_2.jsp';
        /* This event is raised when the server send back a response */
     //   alert(evt.target.responseText);
      }

      function uploadFailed(evt) {
          document.getElementById('bt1').style.visibility="visible";
        alert("There was an error attempting to upload the file."+evt.target.responseText);
      }

      function uploadCanceled(evt) {
             document.getElementById('bt1').style.visibility="visible";
        alert("The upload has been canceled by the user or the browser dropped the connection.");
      }
   
</script>       


<script type="text/javascript">
function validate()
{
  // alert("μπηκα"); 
//dhmiourghse dynamika th function  
    
 var trigger=true;
    for (i=0;i< <%out.print(""+metadata.length);%> ;i++)
    {
      
       var MDvalue=document.getElementById("mdV"+i);
       var MDlabel=document.getElementById("metadatalabel"+i);
       var MDerror=document.getElementById("error"+i);       
    
       if (i<7)
       {
        if(MDvalue.value==null||MDvalue.value=="")
	{
	fn=1;
	MDlabel.style.color="#FF0000";
	MDerror.innerHTML =  ('<p>Το πεδίο είναι υποχρεωτικό</p>');
	MDerror.style.color="#FF0000";
        trigger=false;
	}
	else
	{	
	fn=0;
	MDlabel.style.color="";
	MDerror.innerHTML =  ('');
	MDerror.style.color="";
	}
       }
   }
   
   return trigger;
}



</script>       

<%
String pagetoshow="";
%>
<%
String message="";
//Αν ο χρήστης δεν έχει κάνει Login ακόμα
if((session.getAttribute("verified")==null)||((Integer)session.getAttribute("verified")!=1))
{
    try
    {
        if (request.getParameter( "username" ).contains(";"))
        {
            pagetoshow="<p>SQL injection attempt</p>";      
            throw new  Exception();
        }
        String username=request.getParameter( "username" );
        String password=request.getParameter( "password" );
        String LDAPresponse =LDAPauth(username,password,LDAPserver,mail);
        //out.println(LDAPresponse);
        if (LDAPresponse.equalsIgnoreCase("OK"))
        {

        statement = connection.createStatement();

        rs = statement.executeQuery("SELECT * FROM Submission where  '"+request.getParameter( "username" )+mail+"'=email;");
        

        if(!rs.next())
        {
            pagetoshow+="<p>Δεν έχετε ακόμα δικαίωμα για να υποβάλετε την εργασία σας"
                    + "</br>Παρακαλώ επικοινωνήστε με τη γραμματεία του τμήματος </p>";
        }
        else
        {        
            User user2 =LDAPauth2(username,password,LDAPserver,mail);
            user.setUser(user2);
            session.setAttribute("status", rs.getInt("status"));
            session.setAttribute("subid", rs.getInt("sub_id"));
            session.setAttribute("comid", rs.getInt("com_id"));
            session.setAttribute("itemid", rs.getInt("item_id"));
            session.setAttribute("colid", rs.getInt("col_id"));
            session.setAttribute("verified",1);

        }
        rs.close();
        }
        else
        {
             pagetoshow+="<a href='submit.jsp'></br>Δώσατε λάθος συνδυασμό UserName και κωδικού<br/>Πάτησε για login</a>";
        }

    }
    catch (Exception ex)
    {
         pagetoshow+="<p>Επιστροφή στην είσοδο</p><a href='submit.jsp'>Σφάλμα εισόδου.</a>";
    }

}//αν έχει ήδη ενεργό session
else if ((Integer)session.getAttribute("verified")==1)
{
    
    statement = connection.createStatement();
    rs = statement.executeQuery("SELECT * FROM Submission where  '"+session.getAttribute("subid") +"'=sub_id;");
    if(!rs.next())
    {
           
    }
    else
    {  
            session.setAttribute("status", rs.getInt("status")); 
    }
    rs.close();
   
    try
    {
        remoteservice.NeoWS service = new remoteservice.NeoWS();        
	remoteservice.NeoWSPortType port = service.getNeoWSHttpSoap11Endpoint();
    if ((Integer)session.getAttribute("status")==0)
    {//εδώ θα λαμβάνει τα δεδομένα από την πρώτη φόρμα
      
       //Θεωρούμε ότι τα έχει λάβει σωστά από τη 1η φόρμα (Javascript)      
              
       // TODO initialize WS operation arguments here        
       String username = dspaceuser;
       String comid = ""+session.getAttribute("comid");
       String colid = ""+session.getAttribute("colid");        
       Integer subid =(Integer)session.getAttribute("subid");
       String MDvalue="";
       //  Δημιουργία μιας νέας υποβολής        
       try
       {
       Integer itemid = port.addThesis(username, comid, colid);
       session.setAttribute("itemid",itemid);
       statement = connection.createStatement();        
       int updateresult = statement.executeUpdate("Update Submission SET item_id = "+itemid+" WHERE sub_id ="+subid+" LIMIT 1 ;");   
       String fname=  StringToUTF(request.getParameter("metadataValue"+namepointer));
       updateresult = statement.executeUpdate("Update Submission SET full_name = '"+fname+"' WHERE sub_id ="+subid+" LIMIT 1 ;");
          
      
       // Εδώ θα γίνεται η προσθήκη των μεταδεδομένων 
       
       for (int i=0;i<metadata.length;i++)
       {
           try
           {
           MDvalue=StringToUTF(request.getParameter("metadataValue"+i));              
           String result = port.addMetadata(username,""+session.getAttribute("itemid"), metadata[i][1], metadata[i][2], metadata[i][3], metadata[i][4], MDvalue); 
           }
           catch (Exception ex) 
           {

           }                            
       }
               
       }
       catch (Exception ex) 
       {   
       }
       
  
    
          String months= request.getParameter("months");
     
          if (months.equals("0"))
          {
      
          //nothing to do
          }
          else
          {
             
           try{   
               statement=null;
             statement = connection.createStatement();
            int res = statement.executeUpdate("INSERT INTO delay (`sub_id`,`release`,`checked`)VALUES ('"+subid+"',(DATE_ADD(now(), INTERVAL "+months+" MONTH)),0);");    
           
           }
             catch(Exception e){  out.println(e.toString());}  
          }
          
       //Εδώ θα προσθέσω αν έχει εικόνες,πινακες ,διαγράμματα , xartes  kai σελιδες      
       
          MDvalue=""+request.getParameter("pages")+" σ.";
          try{              
          if (request.getParameter("sxedia").equalsIgnoreCase("on"))
          {
             MDvalue+=", σχ.";
          }
          }catch(Exception e){}
          try{
          if (request.getParameter("pinakes").equalsIgnoreCase("on"))
          {
          MDvalue+=", πιν.";
          }
          }catch(Exception e){}
          try{
          if (request.getParameter("eikones").equalsIgnoreCase("on"))
          {
              MDvalue+=", εικ.";
          }
          }catch(Exception e){}
          try{
          if (request.getParameter("diagrammata").equalsIgnoreCase("on"))
          {
          MDvalue+=", διαγρ.";
          }
          }catch(Exception e){}
          try{
          if (request.getParameter("xartes").equalsIgnoreCase("on"))
          {
          MDvalue+=", χάρτες";
          }
          }catch(Exception e){}
          try{
          String result = port.addMetadata(username, ""+session.getAttribute("itemid"),"dc", "description","","el", MDvalue);
          result = port.addMetadata(username, ""+session.getAttribute("itemid"),"dc", "language","iso","en","gre");
          int index=Integer.parseInt(colid);
          result = port.addMetadata(username, ""+session.getAttribute("itemid"),"dc", "type","","el",type[index]);
          Date mydate=new Date();
          result = port.addMetadata(username, ""+session.getAttribute("itemid"),"dc", "date","created","",""+(mydate.getYear()+1900));                           
          int res=statement.executeUpdate("UPDATE Submission SET status = '1' WHERE sub_id ='"+session.getAttribute("subid")+"' LIMIT 1 ;");
          session.setAttribute("status",1); 
          }
          catch(Exception ex){out.println(ex.toString());}
    }
    
    else if ((Integer)session.getAttribute("status")==errorstate)
    {//O Φοιτητής Υποβάλει τα διορθωμένα
       //   out.println("mphka1");   
       String MDvalue="";
       // Εδώ θα γίνεται η αλλαγή των μεταδεδομένων 
       boolean trigger=false;
       String subid =""+ (Integer)session.getAttribute("subid");
      rs = statement.executeQuery("SELECT * FROM  Sub_Error where  '"+session.getAttribute("subid")+"'=sub_id;");
      int MDid=0;     
    
     
      while(rs.next())
      {
           MDid= rs.getInt("metadata_id");
           //System.out.println("Mphka"+MDid);
           try
           {    
              // out.println("mphka sthn allagh metadata1 to id einai"+MDid);
                MDvalue=StringToUTF(request.getParameter("metadataValue"+MDid));    
               // out.println("phra to metadata to MDvalue einai "+MDvalue);
                trigger=true;
                String result = port.changeMetadata(dspaceuser,""+session.getAttribute("itemid"), metadata[MDid][1], metadata[MDid][2], metadata[MDid][3], metadata[MDid][4], MDvalue);
               // out.println("mphka sthn allagh metadata3 to MDvalue einai "+MDvalue);
                if(metadata[MDid][3].equals("author"))
                {
                statement = connection.createStatement();
                int updateresult = statement.executeUpdate("Update Submission SET full_name = '"+MDvalue+"' WHERE sub_id ="+subid+" LIMIT 1 ;");   
                }
                
           }
           catch (Exception ex) 
           {
             //  out.println(ex.toString());
           }                            
       }       
       rs = statement.executeQuery("SELECT * FROM  Sub_Error where  '"+session.getAttribute("subid")+"'=sub_id AND metadata_id="+fileerror+" ;");
       try//Λήψη αρχείου 
       {
           if(rs.next())
           {    
            
            statement = connection.createStatement();
            session.setAttribute("status",1); 
            try {
                port.removeFile(dspaceuser,""+session.getAttribute("itemid"), "1");
             }catch (Exception ex) {System.out.println(ex.toString());}
            int res=statement.executeUpdate("UPDATE Submission SET status = '1' WHERE sub_id ='"+session.getAttribute("subid")+"' LIMIT 1 ;");               
            res =statement.executeUpdate("DELETE FROM Sub_Error WHERE sub_id = '"+session.getAttribute("subid")+"' AND metadata_id!="+fileerror+";");
            if(trigger)
            {
                           trigger=false;           
            }
         }                         
       }
       catch(Exception E)
       {
           System.out.println(E.toString());
       }
        
       try {             
          if (trigger){ //Υποβολή ξανά για έλεγχο από βιβλιοθήκη
             int res=statement.executeUpdate("UPDATE Submission SET status = '2' WHERE sub_id ='"+session.getAttribute("subid")+"' LIMIT 1 ;");
               session.setAttribute("status",2); 
               res =statement.executeUpdate("DELETE FROM Sub_Error WHERE sub_id = '"+session.getAttribute("subid")+"';");
               sendMail(librarymail,librarymail,"Υποβολή πτυχιακής",notificationmsg,mailserver,mailuser+mail,mailpass);
           }
       }
       catch(Exception E)
       {
           System.out.println(E.toString());
       }  
                            
     }
    
    }
    catch (Exception ex)
    {
        
    }
   
         
}
     
%>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>Υποβολή Πτυχιακής</title>
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
                color: #43648d;
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

			<div id="content" class="auto-style3" >
                            <%
                            out.println(pagetoshow);
                            %>
                            <%
                            if ((session.getAttribute("verified")!=null)&&(Integer)session.getAttribute("verified")==1)
                            {
                               // out.println("status ="+session.getAttribute("status"));
                               // out.println("message= "+message);
                               //Κατασταση Υποβολής μεταδεδομενων
                               
                               
                               
                                if ((Integer)session.getAttribute("status")==0)
                                {
                                     
                                    //metadata insert
                                    /*     0         1       2       3           4           5                   6
                                     *όνομα πεδιου,schema,element,qualifier,language,υποχρεωτικό 1=ναι 0=οχι,large 1=nai 0=oxi
                                     */
                                    //θα γίνει και JavaScript έλεγχος δεδομένων action='submit_2.jsp' 
                                    String name = user.getLast_Name()+","+user.getFirst_Name();
                                    String compulsory="";
                                    out.println("<label>Εισαγωγή στοιχείων</label></br>");
                                    out.println("<form action='submit_2.jsp'  onSubmit='return validate();' method='post'  class='auto-style3'>");
                                    boolean dual=false;
                                    out.println( "<table border='0' cellpadding='1' cellspacing='1' align='center'>  <tbody>");
                                    String value="";
                                    for (int i=0;i<metadata.length;i++)
                                    {
                                        if (metadata[i][3].equals("author"))
                                        {
                                            value=name;
                                           
                                        }else
                                        {
                                             value="";                                            
                                        }
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
                                        
                                        if (metadata[i][5].equals("1"))
                                        {
                                            compulsory=" *";                                          
                                        }
                                        else
                                        {
                                            compulsory="";
                                        }
                                        
                                        if (metadata[i][6].equals("0"))
                                        {
                                         out.println( "<br /><label id='metadatalabel"+i+"' style=' color:#43648d'>"+metadata[i][0]+compulsory+"<br />"
                                            + "	</label>&nbsp;<input name='metadataValue"+i+"' id='mdV"+i+"' style='width: 250px; height: 25px' type='text' value='"+value+"' /><span id='error"+i+"'></span>");
                                        }
                                        else
                                        {
                                           out.println("<br /><label id='metadatalabel"+i+"' style=' color:#43648d'>"+metadata[i][0]+compulsory+"<br />	</label>"
                                            + "&nbsp;<textarea name='metadataValue"+i+"' id='mdV"+i+"' style='width: 250px; height: 90px'></textarea><span id='error"+i+"'></span>");
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
                                   out.println(" </tbody></table>");
                                   out.println( "<label id='pages'  >Αριθμός Σελίδων *<br />"
                                            + "	</label>&nbsp;<input name='pages' style='width: 250px; height: 25px' type='text'/>");  
                                                                                                                                       
                                   out.println("</br><label>Η Εργασία σας περιέχει κάτι από τα παρακάτω;</label>"
                                           + "<br /><table border='0' cellpadding='1' cellspacing='1' align='center'> <tbody><tr><td>Σχέδια</td>"+
					"<td><input name='sxedia' type='checkbox' /></td><td>Εικόνες</td><td><input name='eikones' type='checkbox' /></td>"+
                                        "</tr><tr><td>Πίνακες</td><td><input name='pinakes' type='checkbox' /></td><td>"+
					"Διαγράμματα</td><td><input name='diagrammata' type='checkbox' /></td></tr><tr><td align='center' colspan='4'>"+
					"Χάρτες<input name='xartes' type='checkbox' /></td></tr></tbody></table>");
                               //   out.println("ffd"+session.getAttribute("colid")+session.getAttribute("colid").equals("1"));
                                  String col =session.getAttribute("colid").toString();
                                   if (col.equals("2"))     
                                   {
                                       out.println("</br><label>Περίοδος Αναμονής σε μήνες</label><select name='months' id='months' >");
                                        for (int i=0;i < delay.length;i++)
                                        {
                                            out.println( "<option value="+delay[i]+">"+delay[i]+"</option>");
                                        }
                                        out.println( "</select>");
                                   }
                                   
                                   out.println( "<br /><label>Τα πεδία με * είναι υποχρεωτικά και <br />"
                                           + "το πεδίο Ονοματεπώνυμο Συγγραφέα πρέπει να συμπληρωθεί σε μορφή 'Επώνυμο,Όνομα' </label>");
                                   
                                   out.println("<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
                                            +"<input class='large blue button' name='Button1 style='width: 70px; height: 30px' type='submit' value='Υποβολή' />"
                                            + "<br /></form>");
                                }
                               //Κατασταση Υποβολής αρχείου
                               if ((Integer)session.getAttribute("status")==1)
                               {//file insert
                                 statement = connection.createStatement();  
                                 rs = statement.executeQuery("SELECT * FROM  Sub_Error where  '"+session.getAttribute("subid")+"'=sub_id AND metadata_id="+fileerror+";");  
                                 String error="";
                                 if(rs.next())
                                 {
                                      error="<br/><label>Περιγραφή σφάλματος :"+rs.getString("description")+"</label>";  
                                 }
                                 out.println("<h1>Υποβολή Αρχείου</h1><br/>"
                                            +"Το αρχείο που θα ανεβάσετε πρέπει να είναι τύπου PDF</br>"
                                            +"<a  href='http://www.hua.gr/images/stories/mainsite/lib/gray_PTYX.pdf' target='_blank'>Οδηγίες μορφοποίησης εργασιών</a></br>"
                                            +"<form id='upload' action='upload.jsp' method='post' enctype='multipart/form-data'>"                                         
                                            +"<div><label for='fileselect'>Επιλογή αρχείου:</label>  "
                                            + "<INPUT type='file' name='fileToUpload' id='fileToUpload' onchange='fileSelected();' />   </div>"
                                            +"<div id='prbar'></div>"
                                            +" <div id='fileSize'></div>"
                                            + "<input class='large blue button' type='button' id='bt1' onclick='uploadFile()' value='Υποβολή' />   </form> "
                                            + " ");

                               }
                               //Κατάσταση Υπό Εξέταση 
                               if ((Integer)session.getAttribute("status")==2)
                               {
                               out.println("<p>Η υποβολή σας ελέγχεται από τους υπεύθυνους της βιβλιοθήκης.</br>"
                                       + "Όταν ολοκληρωθεί η διαδικασία θα ενημερωθείται μέσω ηλεκτρονικού ταχυδρομείου</p>");
                               }
                               
                               // Κατάσταση ολοκληρωμένη υποβολής                                
                               if ((Integer)session.getAttribute("status")==finalstate)
                               {
                                 out.println("<p>Η υποβολή σας έχει ολοκληρωθεί και έχει ενημερωθεί η γραμματεία του τμηματος σας</p>");                                    
                               }
                               //Κατάσταση Διόρθωση σφαλμάτων 
                               if ((Integer)session.getAttribute("status")==errorstate)
                               {
                                   String button="Υποβολή";
                                   /*Εμφάνιση κουτιών υποβολής για όλα τα λάθος μεταδεδομένα
                                    * Εμφάνιση των υποδείξεων από τη βιβλιοθήκη
                                    *Αν υπάρχει σφάλμα με το αρχείο εμφάνιση και κουτιού υποβολής 
                                    */      
                                     statement = connection.createStatement();

                                    rs = statement.executeQuery("SELECT * FROM  Sub_Error where  '"+session.getAttribute("subid")+"'=sub_id;");
                                    out.println("<form action='submit_2.jsp' method='post' >");
                                    //Εμφάνιση όλων των πεδίων προς διόρθωση
                                    String desc="";
                                    int MDid;
                                    Integer itemid=(Integer)session.getAttribute("itemid");
                                    String compulsory="";
                                    String error="";
                                    while(rs.next())
                                    {
                                            MDid= rs.getInt("metadata_id");
                                            error=rs.getString("description");
                                        if (MDid==fileerror)
                                        {
                                            
                                        }
                                        else
                                        {  
                                            remoteservice.NeoWS service = new remoteservice.NeoWS();
                                            remoteservice.NeoWSPortType port = service.getNeoWSHttpSoap11Endpoint();    
                                            String result=port.showMetadataValue(dspaceuser, itemid.toString(), metadata[MDid][1], metadata[MDid][2], metadata[MDid][3], metadata[MDid][4]);
                                            //αν είναι υποχρεωτικό    
                                            if (metadata[MDid][5].equals("1"))
                                            {
                                                compulsory=" *";                                          
                                            }
                                            else
                                            {
                                                compulsory="";
                                            }
                                            //μέγεθος κουτιού υποβολής
                                            if (metadata[MDid][6].equals("0"))
                                            {
                                             out.println( "<br /><br /><label id='metadatalabel"+MDid+"'>"+metadata[MDid][0]+compulsory+"<br />"
                                                + "	</label>&nbsp;<input id='metadataValue"+MDid+"' name='metadataValue"+MDid+"' style='width: 250px; height: 25px' type='text' value='"+result+"' /><span id='error"+MDid+"'></span>");
                                             
                                            }
                                            else
                                            {
                                               out.println("<br /><br /><label id='metadatalabel"+MDid+"'>"+metadata[MDid][0]+compulsory+"<br />	</label>"
                                                + "&nbsp;<textarea id='metadataValue"+MDid+"' name='metadataValue"+MDid+"' style='width: 250px; height: 90px'>"+result+"</textarea><span id='error"+MDid+"'></span>");
                                            }
                                            
                                        }
                                        
                                        if (MDid!=fileerror)
                                        {                                               
                                            out.println("<br/><label>Περιγραφή σφάλματος :"+error+"</label>");
                                        }
                                        else
                                        {
                                            out.println("<br/><label>Έχει εμφανιστεί το παρακάτω σφάλμα  στο αρχείο σας :"+error+"<br/>"
                                                    + "Παρακαλω να το υποβάλλεται διορθωμένο στην επόμενη οθόνη</label>");
                                            button="Επόμενο";
                                            
                                        }

                                    } 

                                    
                                    rs.close();   
                                    out.println("<br/><br/><input class='large blue button' name='Submit' type='submit' value='"+button+"' /></form>");
                               } 
                                
                                
                            }
                            %>
			</div>

		</div>

	</div>

	<div id="footer">
            		<p>Επικοινωνία<br />
		<a href="license.html">Άδεια χρήσης</a> - <a href="about.html">About</a>
                </p>
	</div>
</body>

</html>