
<%@page import="javazoom.upload.parsing.CosUploadFile"%>
<%@page import="java.io.FileOutputStream"%>
<%@page import="java.io.File"%>
<jsp:useBean id="user" class="mypak.User" scope="session"/>
<%@page import="javazoom.upload.*"%>
<%@page import="java.io.DataInputStream"%>
<%@page import="java.lang.Integer"%>
<%@page import="java.sql.*" %>
<%@page import="java.io.OutputStream"%>

<%@include file= "variables.jsp" %>
<%@include file= "functions.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>


<%-- 
    Document   : upload
    Created on : Jul 31, 2012, 9:45:49 AM
    Author     : marios
--%>
<%

                    
                try {
                mydspacews.DspaceWS service = new mydspacews.DspaceWS();
                mydspacews.DspaceWSPortType port = service.getDspaceWSHttpSoap12Endpoint();
                String contentType = request.getContentType();           
                if (contentType != null) 
                {
                  //  contentType

               //     DataInputStream in = new DataInputStream(request.getInputStream());
                 /*   int formDataLength = request.getContentLength();
                    byte dataBytes[] = new byte[formDataLength];
                    int byteRead = 0;
                    int totalBytesRead = 0;                
                    while (totalBytesRead < formDataLength) 
                    {
                        byteRead = in.read(dataBytes, totalBytesRead, formDataLength);
                        totalBytesRead += byteRead;   
                    }    
                             
                    in.close();*/
                    
                   MultipartFormDataRequest mrequest=new MultipartFormDataRequest(request);
                   String sub_id=  mrequest.getParameter("sub_id");
                   out.println(""+sub_id);
                  Hashtable myhash = mrequest.getFiles();
                //   response.setContentType("application/pdf");
               // response.setHeader("Content-disposition", "attachment; filename=\"onoma.pdf\""); // The Save As popup magic is done here. You can give it any filename you want, this only won't work in MSIE, it will use current request URL as filename instead.

                // OutputStream os = response.getOutputStream();  ; 
                  CosUploadFile file = (CosUploadFile) myhash.get("fileToUpload");
                       
                  file.setContentType("application/pdf");
                  file.setFileName("kati.pdf");
            //    os.write( file.getData() ); 
             //      os.flush(); 
                   statement = connection.createStatement();
                 rs2 = statement.executeQuery("SELECT * FROM sp_Publication where  sub_id="+sub_id+";");
                    // out.println("mphka");
                 String result;
           if (rs2.next()){
                                            
               String id = ""+rs2.getInt("item_id"); 
            
                String name =rs2.getString("title")+".pdf"; //port.showMetadataValue(dspaceuser, id, "dc","contributor","author","el")+".pdf";

                Integer bitid =Integer.parseInt(port.addFile(dspaceuser, id, file.getData(), name));//επιστρέφει το kωδικο του bitstream
                if(bitid!=-1){
                port.completeSubmission(dspaceuser, id);
              //  statement = connection.createStatement();
              //  int updateresult = statement.executeUpdate("Update Submission SET bit_id = "+bitid+" WHERE sub_id ="+sub_id+" LIMIT 1 ;");  
                int res=statement.executeUpdate("UPDATE sp_Publication SET bit_id = '"+bitid+"' WHERE sub_id ='"+sub_id+"' LIMIT 1 ;");
               int res2=statement.executeUpdate("UPDATE sp_Publication SET status = '"+finalstate+"' WHERE sub_id ='"+sub_id+"' LIMIT 1 ;");
                  // out.println("" +res2+updateresult);          
                 
                try {	        
            result = port.completeSubmission(dspaceuser,id);  
            result = port.clearMetaData(dspaceuser,id,"dc","description","provenance","en");
            } catch (Exception ex) {
                System.out.println(ex.toString());
                out.println(""+ex.toString());
                // TODO handle custom exceptions here
            }
           }
           
           }
                 
                }
                }catch (Exception ex) {
                 System.out.println(ex.toString());
                    out.println(ex.toString());
                }
        


%>
<%
/*
if((user.getRole()==1)&&(!request.getParameter("sub_id").equals("0")))//erxetai apo to edit_submission
{
       statement = connection.createStatement();
       rs = statement.executeQuery("SELECT * FROM sp_Publication where  '"+request.getParameter("sub_id") +"'=sub_id;");
       if(rs.next())
       {
           int status = rs.getInt("status");
           
           if(status==1)//gia na apothikeytei to arxeio
           {                       
                try {

                String contentType = request.getContentType();           
                if (contentType != null) 
                {

                    DataInputStream in = new DataInputStream(request.getInputStream());
                    int formDataLength = request.getContentLength();
                    byte dataBytes[] = new byte[formDataLength];
                    int byteRead = 0;
                    int totalBytesRead = 0;                
                    while (totalBytesRead < formDataLength) 
                    {
                        byteRead = in.read(dataBytes, totalBytesRead, formDataLength);
                        totalBytesRead += byteRead;   
                    }    
                             
                    in.close();
                  //     String subid =""+ (Integer)session.getAttribute("subid");
                        //       String id = ""+ (Integer)session.getAttribute("itemid");
                  //   String name = port.showMetadataValue(dspaceuser, id, "dc","contributor","author","el")+".pdf";

                //  Integer bitid = port.addFile(dspaceuser, id, dataBytes, name);//επιστρέφει το kωδικο του bitstream
                //    
                 statement = connection.createStatement();
                 //       int updateresult = statement.executeUpdate("Update Submission SET bit_id = "+bitid+" WHERE sub_id ="+subid+" LIMIT 1 ;");  
                 int res=statement.executeUpdate("UPDATE sp_Publication SET status = '"+finalstate+"' WHERE sub_id ='"+request.getParameter("sub_id")+"' LIMIT 1 ;");
               
                
                 }

                }catch (Exception ex) {
                    System.out.println(ex.toString());
                    out.println(ex.toString());

                }
           }           
                                  
     }  
}
*/


%>