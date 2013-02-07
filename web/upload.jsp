<%-- 
    Document   : upload
    Created on : Aug 1, 2012, 10:15:50 AM
    Author     : marios
--%>

<%@page import="javazoom.upload.parsing.CosUploadFile"%>
<%@page import="java.io.FileOutputStream"%>
<%@page import="java.io.File"%>
<jsp:useBean id="user" class="mypak.User" scope="session"/>
<%@page import="javazoom.upload.*"%>
<%@page import="java.io.DataInputStream"%>
<%@page import="java.lang.Integer"%>
<%@page import="java.sql.*" %>
<%@page import="java.io.OutputStream"%>
<%@page import="java.io.DataInputStream"%>
<%@page import="java.lang.Integer"%>
<%@page import="java.sql.*" %>

<%@include file= "variables.jsp" %>
<%@include file= "functions.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>


<%%>


<%

if  ((Integer)session.getAttribute("status")==1)
    {
        //Παίρνει το αρχείο και το ανεβάζει στο Dspace
        try {
            remoteservice.NeoWS service = new remoteservice.NeoWS();        
	    remoteservice.NeoWSPortType port = service.getNeoWSHttpSoap11Endpoint();
            String contentType = request.getContentType();           
            if (contentType != null) 
            {
                 /*
                DataInputStream in = new DataInputStream(request.getInputStream());
                int formDataLength = request.getContentLength();
                byte dataBytes[] = new byte[formDataLength];
                int byteRead = 0;
                int totalBytesRead = 0;                
                while (totalBytesRead < formDataLength) 
                {
                    byteRead = in.read(dataBytes, totalBytesRead, formDataLength);
                    totalBytesRead += byteRead;   
                }              */
                String subid =""+ (Integer)session.getAttribute("subid");
                String id = ""+ (Integer)session.getAttribute("itemid");
                
                MultipartFormDataRequest mrequest=new MultipartFormDataRequest(request);
               // String sub_id=  mrequest.getParameter("sub_id");
                Hashtable myhash = mrequest.getFiles();
                response.setContentType("application/pdf");
                String name = port.showMetadataValue(dspaceuser, id, "dc","contributor","author","el")+".pdf";
                response.setHeader("Content-disposition", "attachment; filename=\""+name+"\""); // The Save As popup magic is done here. You can give it any filename you want, this only won't work in MSIE, it will use current request URL as filename instead.
                //OutputStream os = response.getOutputStream();  ; 
                CosUploadFile file = (CosUploadFile) myhash.get("fileToUpload");
                             
              
                
                //os.write( file.getData() ); 
                //os.flush(); 
                file.setFileName(name);                
                file.setContentType("application/pdf");
               
                Integer bitid = port.addFile(dspaceuser, id, file.getData(), name);//επιστρέφει το kωδικο του bitstream
                
                statement = connection.createStatement();
                int updateresult = statement.executeUpdate("Update Submission SET bit_id = "+bitid+" WHERE sub_id ="+subid+" LIMIT 1 ;");  
                int res=statement.executeUpdate("UPDATE Submission SET status = '2' WHERE sub_id ='"+session.getAttribute("subid")+"' LIMIT 1 ;");
                res =statement.executeUpdate("DELETE FROM Sub_Error WHERE sub_id = '"+session.getAttribute("subid")+"';");
                session.setAttribute("status",2); 
              //Αποστολή mail στη βιβλιοθήκη για νεα εργασία.
                sendMail(librarymail,librarymail,"Υποβολή πτυχιακής",notificationmsg,mailserver,mailuser+mail,mailpass);
            }
            
        }catch (Exception ex) {
       System.out.println(ex.toString());
       out.println(ex.toString());
            // TODO handle custom exceptions here
        }     
      
     }

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h1>Hello World!</h1>
    </body>
</html>
