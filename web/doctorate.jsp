<%-- 
    Document   : doctorate
    Created on : Dec 10, 2012, 10:41:13 AM
    Author     : marios
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
       String message="";  
        
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
        
        if (!trigger)
        {
             try { 
             //kane to state toy submission se finalstate 
             statement = connection.createStatement();                 
             int res=statement.executeUpdate("UPDATE Submission SET status = '4' WHERE sub_id ='"+subid+"' LIMIT 1 ;");
             res=statement.executeUpdate("UPDATE Submission SET completion =now() WHERE sub_id ='"+subid+"' LIMIT 1 ;");
              res=statement.executeUpdate("UPDATE delay SET checked=true WHERE sub_id ='"+subid+"' LIMIT 1 ;");
             
             }
             catch(Exception E)
             {}   
           // System.out.println("complete Submission");
            



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

           // Αποστολή μηνύματος  ηλεκτρονικού ταχυδρομείου στη γραμματεια
           sendMail(mailuser+mail,secretary,"Υποβλήθηκε μια Εργασία",secemail,mailserver,mailuser+mail,mailpass);

        }//αν έχει υπάρξει σφάλμα
       
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



<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
     <meta http-equiv="REFRESH" content="0;url=showactive.jsp">
  
</html>
