<jsp:useBean id="user" class="mypak.User" scope="session"/>
<%--
    Document   : central
    Created on : Apr 20, 2011, 6:42:08 PM
    Author     : Marios
--%>

<%@page import="java.io.DataInputStream"%>
<%@page import="java.lang.Integer"%>
<%@page import="java.sql.*" %>

<%@include file= "variables.jsp" %>
<%@include file= "functions.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<% 
response.setHeader("Access-Control-Allow-Origin","*");
%>

<%String cowriters="";
  if ((session.getAttribute("verified")!=null)&&(Integer)session.getAttribute("verified")==1)
  {
     
            String sql="SELECT * FROM sp_Cowriter co, sp_User u WHERE co.user_id= "+user.getId()+" and co.co_id= u.id";  
                                       
             try{
             statement = connection.createStatement();
             rs = statement.executeQuery(sql);
          
          
            cowriters+= "<option value=-1></option>";
           // out.println(res.toString());
            while (rs.next())
            { 
            cowriters+="<option value="+rs.getString("co_id")+">"+rs.getString("email")+"</option>";

            }
         
           }catch (Exception e)
           {
            //out.println(e.toString());
           }  
  }
%>


<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.1/jquery.min.js"></script>
<script>
    
var counter=0; 
//var aucount=document.getElementById("AuthCount");
  //  document.getElementById("AuthCount").value="0";
$(function () {
    $('#minus').live('click',function(e){
       if(counter!=0){
           $('#extradiv tr:last-child').remove(); 
        counter--; document.getElementById("AuthCount").setAttribute('value',counter);
     /* */   if(counter==0)
        {
            var parent= document.getElementById("minus0");
            parent.removeChild(parent.lastChild);
        }
       }
       
    });
});

$(function () {
    $('#plus0').live('click',function(e){
    
    if(counter==0)
    {
        $('#minus0').append('<span id="minus"><img src="images/32.png" width="24px">');
    }
    $('#extradiv').append('<tr><td></br><label>Ονοματεπώνυμο Συγγραφέα</label><br> <input name="writer'+counter+'"  id="writer'+counter+'" style="width: 250px; height: 25px" type="text" />\n\
<select id="sel'+counter+'" onchange="changeName('+counter+')" style="width: 150px;" > <%out.print(cowriters);%> <option value="other">άλλος</option></select><span id="plus"><img  src="images/48.png" width="24px" /></span><span id="minus"><img src="images/32.png" width="24px"></span> <div id="newuser'+counter+'" ></div> </td></tr>');
         counter++; document.getElementById("AuthCount").setAttribute('value',counter);
    });
});



$(function () {
    $('#plus').live('click',function(e){    
     if(counter==0){
        $('#minus0').append('<span id="minus"><img src="images/32.png" width="24px">');
    }
    $('#extradiv').append('<tr><td></br><label>Ονοματεπώνυμο Συγγραφέα</label><br> <input name="writer'+counter+'"  id="writer'+counter+'" style="width: 250px; height: 25px" type="text" />\n\
<select id="sel'+counter+'" onchange="changeName('+counter+')" style="width: 150px;" > <%out.print(cowriters);%> <option value="other">άλλος</option></select><span id="plus"><img  src="images/48.png" width="24px" /></span><span id="minus"><img src="images/32.png" width="24px"></span> <div id="newuser'+counter+'" ></div> </td></tr>');
        counter++;
        document.getElementById("AuthCount").setAttribute('value',counter);
    });
    });

</script>

<script type="text/javascript">
    function changeName(num)
    {
        var index = document.getElementById('sel'+num.toString()+"").value;// .selectedIndex;
     
       if (document.getElementById("sel"+num.toString()+"").value=="other")
       {/*
           br = document.createElement('br');
           document.getElementById("newuser"+num.toString()+"").appendChild(br);
           
           lb = document.createElement('label');          
           lb.innerHTML="Εισάγεται το email για να προσκληθεί :";
           document.getElementById("newuser"+num.toString()+"").appendChild(lb);
           
           input=document.createElement('input');           
           input.style.property="width: 200px; height: 25px";           
           document.getElementById("newuser"+num.toString()+"").appendChild(input);
           
           strng=document.createElement('strong');           
           strng.innerHTML="@hua.gr";           
           document.getElementById("newuser"+num.toString()+"").appendChild(strng);  
           document.getElementById("writer"+num.toString()+"").value= " ";*/
            
       }else if (document.getElementById("sel"+num.toString()+"").value=="-1")
       {
        document.getElementById("writer"+num.toString()+"").value= " ";
         var parent=  document.getElementById("newuser"+num.toString());
          if (parent.hasChildNodes()){
         parent.removeChild(parent.lastChild);
         parent.removeChild(parent.lastChild);
         parent.removeChild(parent.lastChild); 
         parent.removeChild(parent.lastChild); }
       }       
       else
       {          
            var parent=  document.getElementById("newuser"+num.toString());
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
              document.getElementById("writer"+num.toString()+"").value= post.surname+","+post.name  ;            
                });
           }); 
       }
    }
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
        fd.append("sub_id", document.getElementById('sub_id').value);
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
           location.href = 'active.jsp';
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



/*if (kati==0)
{
alert("συμπληρώθηκε σωστα");

return true;
}*/


</script>       

    
    
<%
String pagetoshow="";
%>
 <%
  int status=0;
  int sub_id=-1;
  if (request.getParameter("sub_id")!=null)
  {
    sub_id =    Integer.parseInt(request.getParameter("sub_id")) ;
    status =1;
  }
 
 //dhmioyrgia antikeimenoy kai prosthiki metadedomenwn 
  if ((session.getAttribute("verified")!=null)&&(Integer)session.getAttribute("verified")==1)
  {   
      
      
      String fname="";
      try{
      fname=StringToUTF(request.getParameter("metadataValue0")); //   out.println("mphka0"+fname);
      if(!fname.equals("")&&(status==0))
      {
      
    }  
    }catch(Exception e)
    {
       //out.println("exc"+e.toString());
    }
    try {
     //   out.println("mphka1");
      if(!fname.equals("")&&(status==0))
      {
     //   out.println("mphka2");
        String sql="INSERT INTO sp_Publication (user_id,status, collection_id)"
                  + " VALUES ('"+user.getId()+"','0' ,'"+user.getDepartment()+"' )" ;
                                     //   +user.getId()+"');";        
          
        try{
        statement = connection.createStatement();
        statement.executeUpdate(sql, Statement.RETURN_GENERATED_KEYS);
        ResultSet res = statement.getGeneratedKeys();

        // out.println(res.toString());
        while (res.next())
        { 
            sub_id=res.getInt(1);

        }
        
        }catch (Exception ex)
        {
       out.println(ex.toString());
        } 
     
  

/*       
	allo.paketo.NeoWS service = new allo.paketo.NeoWS();
	allo.paketo.NeoWSPortType port = service.getNeoWSHttpSoap12Endpoint();
	*/
        mydspacews.DspaceWS service = new mydspacews.DspaceWS();
	mydspacews.DspaceWSPortType port = service.getDspaceWSHttpSoap12Endpoint();

       //  out.println("mphka 2 status"+status+" sub_id"+sub_id+"value0 "+fname);
         
       String username = dspaceuser;
       String comid = community;//+session.getAttribute("comid");
       String colid = ""+user.getDepartment();//+session.getAttribute("colid");        
    //   Integer subid =(Integer)session.getAttribute("subid");
       String MDvalue="";
       //  Δημιουργία μιας νέας υποβολής        
    //   out.println("mphka3");
       Integer itemid = Integer.parseInt(port.addThesis(username, comid, colid));
       session.setAttribute("itemid",itemid);
      // out.println("to item id einai "+itemid);
       statement = connection.createStatement();        
       int updateresult = statement.executeUpdate("Update sp_Publication SET item_id = "+itemid+" WHERE sub_id ="+sub_id+" LIMIT 1 ;");   
       statement.executeUpdate("Update sp_Publication SET status = '1' WHERE sub_id ="+sub_id+" LIMIT 1 ;");   
   
       for (int i=0;i<metadata.length;i++)
       {
                      
           try
           {
           MDvalue=StringToUTF(request.getParameter("metadataValue"+i));              
           String result = port.addMetadata(username,""+session.getAttribute("itemid"), metadata[i][1], metadata[i][2], metadata[i][3], metadata[i][4], MDvalue); 
           
           if(i==titlenum)
           {
             statement.executeUpdate("Update sp_Publication SET `title` = '"+MDvalue+"' WHERE sub_id ="+sub_id+" LIMIT 1 ;");    
           }
           
           if(i==yearnum)
           {
             statement.executeUpdate("Update sp_Publication SET `year` = '"+ MDvalue+"' WHERE sub_id ="+sub_id+" LIMIT 1 ;");    
           }
           
           if(i==citationnum)
           {
             statement.executeUpdate("Update sp_Publication SET `citation` = '"+ MDvalue+"' WHERE sub_id ="+sub_id+" LIMIT 1 ;");    
           }
           
           }
           catch (Exception ex) 
           {
          out.println("exception 2"+ex.toString()+"o arithmos einai "+i);
           }                            
       }
      try{ 
        //out.println("to authcount einai"+request.getParameter("AuthCount"));
            for(int j=0;j<= Integer.parseInt(request.getParameter("AuthCount"));j++)
            {
            try
                {
                MDvalue=StringToUTF(request.getParameter("writer"+j));              
                String result = port.addMetadata(username,""+session.getAttribute("itemid"), metadata[0][1], metadata[0][2], metadata[0][3], metadata[0][4], MDvalue); 
                }
                catch (Exception ex) 
                {
                    //  out.println("exception 2"+ex.toString());
                } 
            }
        }
           catch (Exception ex) 
           {
          //    out.println("edo exception  3"+ex.toString());
           }
              try
           {
           MDvalue=StringToUTF(request.getParameter("pubType"));              
           String result = port.addMetadata(username,""+session.getAttribute("itemid"), "dc", "type", "", "el", type[Integer.parseInt(MDvalue)-1][0]); 
           }
           catch (Exception ex) 
           {
            //  out.println("exception 2"+ex.toString());
           } 
        status=1;        
       }
      
      }    
      catch(Exception ex)
      {
       //   out.println("exception 2"+ex.toString());
      }
       
      
    }
%>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>Υποβολή Δημοσίευσης</title>
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
				
<%@include file="header.jsp" %>
			</header>
<!-- navigaation -->
			<nav id="navigation" >
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
	

        
        
			<!-- main -->
			<div class="main">

				<div class="featured" align="center" >
                                    
					 <%  
                            out.println(pagetoshow);
                            %>
                            <%
                            if ((session.getAttribute("verified")!=null)&&(Integer)session.getAttribute("verified")==1)
                            {
                               // out.println("status ="+session.getAttribute("status"));
                               // out.println("message= "+message);
                               //Κατασταση Υποβολής μεταδεδομενων
                                
                                
                                if (status==0)
                                {//metadata insert
                                    /*     0         1       2       3           4           5                   6
                                     *όνομα πεδιου,schema,element,qualifier,language,υποχρεωτικό 1=ναι 0=οχι,large 1=nai 0=oxi
                                     */
                                    //θα γίνει και JavaScript έλεγχος δεδομένων action='submit_2.jsp' 

                                    String compulsory="";
                                    out.println("<h1>Εισαγωγή στοιχείων</h1></br>");
                                    out.println("<form action='submit.jsp'  onSubmit='return validate();' method='post'  class='auto-style3'>");
                                    boolean dual=false;
                                    out.println( "<input type='hidden'  id='AuthCount' name='AuthCount' value='0'><table border='0' cellpadding='1' cellspacing='1' align='center' id='table'>  <tbody>");
                                    out.println("<label id='pubTypelabel' name='pubTypelabel'  >Τύπος δημοσίευσης</label><br />"+typeSelect);   
                                    String name = user.getLast_Name()+","+user.getFirst_Name();
                                    String value ="";
                                    String extraspan="";
                                    for (int i=0;i<metadata.length;i++)
                                    {
                                        if (metadata[i][3].equals("author"))
                                        {
                                            value=name;
                                            extraspan="<span id='plus0'><img src='images/48.png' width='24px' /></span>"
                                                    + "<span id='minus0'>"//<img src='images/32.png' width='24px' />"
                                                    + "</span><div id='extradiv'></div >";

                                        }else
                                        {
                                            value="";
                                            extraspan="";
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
                                            + "	</label>&nbsp;<div><input name='metadataValue"+i+"' id='mdV"+i+"' style='width: 250px; height: 25px' type='text' value='"+value+"'/>"+extraspan+"</div>");
                                        }
                                        else
                                        {
                                           out.println("<br /><label id='metadatalabel"+i+"' style=' color:#43648d'>"+metadata[i][0]+compulsory+"<br />	</label>"
                                            + "&nbsp;<textarea name='metadataValue"+i+"' id='mdV"+i+"' style='width: 250px; height: 90px'></textarea>"+extraspan);
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
                                    
                                    /*       out.println( "<label id='pages'  >Αριθμός Σελίδων *<br />"
                                            + "	</label>&nbsp;<input name='pages' style='width: 250px; height: 25px' type='text'/>");  
                                                                                                                               
                                   out.println("</br><label>Η Εργασία σας περιέχει κάτι από τα παρακάτω;</label>"
                                           + "<br /><table border='0' cellpadding='1' cellspacing='1' align='center'> <tbody><tr><td>Σχέδια</td>"+
					"<td><input name='sxedia' type='checkbox' /></td><td>Εικόνες</td><td><input name='eikones' type='checkbox' /></td>"+
                                        "</tr><tr><td>Πίνακες</td><td><input name='pinakes' type='checkbox' /></td><td>"+
					"Διαγράμματα</td><td><input name='diagrammata' type='checkbox' /></td></tr><tr><td align='center' colspan='4'>"+
					"Χάρτες<input name='xartes' type='checkbox' /></td></tr></tbody></table>");*/
                                                                  
                                   out.println( "<br /><label>Τα πεδία με * είναι υποχρεωτικά και <br />"
                                           + "το πεδίο Ονοματεπώνυμο Συγγραφέα πρέπει<br> να συμπληρωθεί σε μορφή 'Επώνυμο,Όνομα' </label>");
                                 
                                   out.println("<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
                                            +"<input class='large blue button' name='Button1 style='width: 70px; height: 30px' type='submit' value='Υποβολή' />"
                                            + "<br /></form>");
                                }
                               //Κατασταση Υποβολής αρχείου
                               if (status==1)
                               {//file insert
                               
                                 out.println("<h1>Υποβολή Αρχείου</h1><br/><br/>"
                                            +"Το αρχείο που θα ανεβάσετε πρέπει να είναι τύπου PDF</br>"
                                       //     +"<a href='http://www.hua.gr/images/stories/mainsite/lib/gray_PTYX.pdf' target='_blank'>Οδηγίες για τη μορφή της εργασίας</a>"
                                            +"<form id='upload' action='upload.jsp' method='post' enctype='multipart/form-data'>"
                                            +"<input type='hidden' id='sub_id' name='sub_id' value='"+sub_id+"' />" 
                                            +"<div><label for='fileselect'>Επιλογή αρχείου:</label>  "
                                            + "<INPUT  type='file' name='fileToUpload' id='fileToUpload' onchange='fileSelected();' />   </div>"
                                            +"<div id='prbar'></div>"
                                            +" <div id='fileSize'></div>"
                                            + "<input class='large blue button' type='button' id='bt1' onclick='uploadFile()' value='Υποβολή' />   </form> "
                                            + " ");

                               }
                               
                               
                                
                                
                            }
                            %>
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
		
</div>

	
</body>

</html>