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





<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
     <%
                         
                               
                                 out.println("<label>Υποβολή Αρχείου</label><br/><br/>"
                                            +"Το αρχείο που θα ανεβάσετε πρέπει να είναι τύπου PDF</br>"
                                       //     +"<a href='http://www.hua.gr/images/stories/mainsite/lib/gray_PTYX.pdf' target='_blank'>Οδηγίες για τη μορφή της εργασίας</a>"
                                            +"<form id='upload' action='upload.jsp' method='post' enctype='multipart/form-data'>"
                                           +"<input type='hidden'  name='sub_id' value='63' />" 
                                            +"<div><label for='fileselect'>Files to upload:</label>  "
                                            + "<INPUT type='file' name='fileToUpload' id='fileToUpload' onchange='fileSelected();' />   </div>"
                                            + "<div id='fileName'></div>"
                                            +" <div id='fileSize'></div>"
                                            +" <div id='fileType'></div>"
                                          //  + "   <div id='filedrag'>or drop files here</div>  "                                       
                                         //   + "<div id='submitbutton'  align='center'>  "
                                            + "<input type='submit'  value='Υποβολή' /> <div id='progressNumber'></div>  </form> "
                                            + " ");

                           
                            %>
    </body>
</html>
