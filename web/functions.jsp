<%@page import="mypak.User"%>
<%@page import="javax.naming.directory.SearchResult"%>
<%@page import="javax.naming.NamingEnumeration"%>
<%@page import="javax.naming.directory.SearchControls"%>
<%@page import="javax.naming.ldap.LdapContext"%>
<%@page import="javax.naming.ldap.InitialLdapContext"%>
<%@page import="javax.naming.directory.Attributes"%>
<%@page import="javax.naming.NamingException"%>
<%@page import="javax.naming.directory.InitialDirContext"%>
<%@page import="javax.naming.directory.DirContext"%>
<%@page import="javax.naming.Context"%>
<%@page import="java.util.Hashtable"%>
<%@page import="java.util.Properties"%>
<%@page import="java.sql.*" %>
<%@page import="javax.mail.*" %>
<%@page import="javax.mail.internet.*" %>
<%@page import="java.util.Date"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>


<%!
public String StringToUTF(String temp) throws java.io.UnsupportedEncodingException
{//converts a simple String to UTF
     byte[] bytes = new byte[temp.length()];  
     for (int i = 0; i < temp.length(); i++) 
     {
        bytes[i] = (byte) temp.charAt(i);
     }   
 
    return  new String(bytes, "UTF-8");
}

public String sendMail(String from,String to,String subject,String message,String mailserver,String mailuser,String mailpass)
{       
      try { 
            // create some properties
            Properties props = new Properties();
            // Creating the server
            props.put("mail.smtp.host", mailserver);
            // Definning that the communication will need a username\password pair
            props.put("mail.smtp.auth","true");
             // Geting the default Session
            Session session = Session.getDefaultInstance(props, null);
            boolean sessionDebug = false;
            session.setDebug(sessionDebug);
            
            
            Message msg = new MimeMessage(session);
            // Set the from address
            msg.setFrom(new InternetAddress(from));
            // Making the receipient
            // Setting the receipient
            msg.setRecipient(Message.RecipientType.TO, new InternetAddress(to));           
            // Setting the subject of the email
            msg.setSubject(subject);
            // Setting the email date
            msg.setSentDate(new java.util.Date());
            // Setting the message header
            msg.setHeader("X-Mailer", "sendmail");
            
            // create and fill the text message part
            MimeBodyPart textMimeBodyPart = new MimeBodyPart();
            textMimeBodyPart.setText(message,"UTF-8");
            // create and fill the html message part            
            // create the Multipart and its parts to it
            Multipart contentMimeBodyPart = new MimeMultipart("alternative");
            contentMimeBodyPart.addBodyPart(textMimeBodyPart);
            //   contentMimeBodyPart.addBodyPart(htmlMimeBodyPart);
            // add the Multipart to the message
            msg.setContent(contentMimeBodyPart);

            // Creating a smtp transport object
            Transport transport = session.getTransport("smtp");
            // Connecting to the server and requiring authentication
            transport.connect(mailserver, mailuser, mailpass);
            msg.saveChanges(); // saving the changes
            // Send the message
            transport.sendMessage(msg, msg.getAllRecipients());
            // Closing the transport
            transport.close();
            
           
        }
        catch (Exception e) {
        return e.toString()+"5";
        }
    
    return "OK";

      
    
}

public String LDAPauth(String username,String password,String LDAPserver,String mail)
{
 String msg="";  
 if(password.equalsIgnoreCase(""))
 {
     msg="nopass";
 }
        Hashtable env = new Hashtable(11);
	env.put(Context.INITIAL_CONTEXT_FACTORY,"com.sun.jndi.ldap.LdapCtxFactory");
        //LDAP server
	env.put(Context.PROVIDER_URL, "ldap://"+LDAPserver);
        //authentication type
	env.put(Context.SECURITY_AUTHENTICATION, "simple");
        //username
        env.put(Context.SECURITY_PRINCIPAL, username+mail);  
        //password
	env.put(Context.SECURITY_CREDENTIALS, password);
        //check credentials
	try {
	    // Create initial context
	    DirContext ctx = new InitialDirContext(env);
            //ctx.getAttributes(name)    
	    ctx.close();
	} catch (NamingException e) {
            msg+=e.toString();	   
	}  
        
    return "OK"+msg;
}

public User LDAPauth2(String username,String password,String LDAPserver,String mail)
{
 String msg="";
 User myuser = new User();  
 if(password.equalsIgnoreCase(""))
 {
     msg="nopass";
 }
        LdapContext ctx = null;  
    
        Hashtable  env = new Hashtable ();  
           
	env.put(Context.INITIAL_CONTEXT_FACTORY,"com.sun.jndi.ldap.LdapCtxFactory");
        //LDAP server
	env.put(Context.PROVIDER_URL, "ldap://"+LDAPserver);
        //authentication type
	env.put(Context.SECURITY_AUTHENTICATION, "simple");
        //username
        env.put(Context.SECURITY_PRINCIPAL, username+mail);  
        //password
	env.put(Context.SECURITY_CREDENTIALS, password);
        //env.put(Context.)
        //check credentials
	try {
	    // Create initial context
	    ctx = new InitialLdapContext(env,null);  
        //    Attributes attrs = ctx.getAttributes("DN=hua.gr,CN = Person, CN=Schema,DC=hua,DC=gr);"
               
          try {  
  
            SearchControls constraints = new SearchControls();  
            constraints.setSearchScope(SearchControls.SUBTREE_SCOPE);  
            String[] attrIDs = { "distinguishedName",  
                    "sn",  
                    "givenname",  
                    "mail",  
                    "telephonenumber"};  
            constraints.setReturningAttributes(attrIDs);  
            //First input parameter is search bas, it can be "CN=Users,DC=YourDomain,DC=com"  
            //Second Attribute can be uid=username  
            NamingEnumeration  answer = ctx.search("DC=hua,DC=gr", "sAMAccountName=" + username, constraints);  
            if (answer.hasMore()) {  
                Attributes attrs = ((SearchResult) answer.next()).getAttributes();  
               //  msg+="distinguishedName "+ attrs.get("distinguishedName");  
               myuser.setFirst_Name( (""+attrs.get("givenname")).substring(("givenname :").length()));  
               myuser.setLast_Name((""+attrs.get("sn")).substring(("sn :").length()));  
               myuser.setEmail((""+attrs.get("mail")).substring(("mail :").length())); 
               myuser.setDepartment(0);
               // msg+="telephonenumber "+ attrs.get("telephonenumber");  
            }
  
        } catch (Exception ex) {  
            msg+=ex.toString();	  
        }  
           // Attributes attrs = ctx.getAttributes("ou=People,sAMAccountName="+username)  ;  
           // msg+=attrs.get("sn").get();
	    ctx.close();
	} catch (NamingException e) {
            msg+=e.toString();	   
	}  
        
    return myuser;
}


%>