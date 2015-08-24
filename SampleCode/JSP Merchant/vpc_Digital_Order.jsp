<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%--
/* -----------------------------------------------------------------------------
 Version 3.1
-------------------------------------------------------------------------------- 
This example assumes that a form has been sent to this example with the
required fields. The example then processes the command and displays the
receipt or error to a HTML page in the users web browser.
*****
NOTE:
*****
  For jdk1.2, 1.3
  * Must have jsse.jar, jcert.jar and jnet.jar in your classpath
  * Best approach is to make them installed extensions - 
    i.e. put them in the jre/lib/ext directory.
  For jdk1.4 (jsse is already part of default installation - should run fine)
--------------------------------------------------------------------------------
@author SMARTLINK CARD,.JSC
------------------------------------------------------------------------------*/
--%>
<%@ page import="java.util.List,
                 java.util.ArrayList,
                 java.util.Collections,
                 java.util.Iterator,
                 java.util.Enumeration,
                 java.security.MessageDigest,
                 java.util.Map,
                 java.net.URLEncoder,
                 java.util.HashMap"%>

<%! // Define Constants
    // ****************
    // This is secret for encoding the MD5 hash
    // This secret will vary from merchant to merchant
    // static final String SECURE_SECRET = "your-secure-hash-secret";

    //SMLTEST
    static final String SECURE_SECRET = "198BE3F2E8C75A53F38C1C4A5B6DBA27";


	// This is an array for creating hex chars
	static final char[] HEX_TABLE = new char[] {
        '0', '1', '2', '3', '4', '5', '6', '7',
        '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'};
    //--------------------------------------------------------------------------
    //--------------------------------------------------------------------------
    /**
    * This method is for sorting the fields and creating an MD5 secure hash.
    *
    * @param fields is a map of all the incoming hey-value pairs from the VPC
    * @param buf is the hash being returned for comparison to the incoming hash
    */
    //--------------------------------------------------------------------------
    //--------------------------------------------------------------------------
    String hashAllFields(Map fields) {
        
        // create a list and sort it
        List fieldNames = new ArrayList(fields.keySet());
        Collections.sort(fieldNames);
        
        // create a buffer for the md5 input and add the secure secret first
        StringBuffer buf = new StringBuffer();
        buf.append(SECURE_SECRET);
        
        // iterate through the list and add the remaining field values
        Iterator itr = fieldNames.iterator();
        
		while (itr.hasNext()) {
            String fieldName = (String) itr.next();
            String fieldValue = (String) fields.get(fieldName);
            if ((fieldValue != null) && (fieldValue.length() > 0)) {
                buf.append(fieldValue);
            }
 	    }

        MessageDigest md5 = null;
        byte[] ba = null;
        
        // create the md5 hash and UTF-8 encode it
        try {
            md5 = MessageDigest.getInstance("MD5");
            ba = md5.digest(buf.toString().getBytes("UTF-8"));
         } catch (Exception e) {} // wont happen
       
        //return buf.toString();
        return hex(ba);
    
	} 
    //END hashAllFields()

    //--------------------------------------------------------------------------
    //--------------------------------------------------------------------------
    /**
     * Returns Hex output of byte array
     */
    //--------------------------------------------------------------------------
    //--------------------------------------------------------------------------
    static String hex(byte[] input) {
        // create a StringBuffer 2x the size of the hash array
        StringBuffer sb = new StringBuffer(input.length * 2);

        // retrieve the byte array data, convert it to hex
        // and add it to the StringBuffer
        for (int i = 0; i < input.length; i++) {
            sb.append(HEX_TABLE[(input[i] >> 4) & 0xf]);
            sb.append(HEX_TABLE[input[i] & 0xf]);
        }
        return sb.toString();
    }
    //END hex()
    //--------------------------------------------------------------------------
    //--------------------------------------------------------------------------
    /**
    * This method is for creating a URL query string.
    *
    * @param buf is the inital URL for appending the encoded fields to
    * @param fields is the input parameters from the order page
    */
    //--------------------------------------------------------------------------
    //--------------------------------------------------------------------------
    void appendQueryFields(StringBuffer buf, Map fields) {
        
        // create a list
        List fieldNames = new ArrayList(fields.keySet());
        Iterator itr = fieldNames.iterator();
        
        // move through the list and create a series of URL key/value pairs
        while (itr.hasNext()) {
            String fieldName = (String)itr.next();
            String fieldValue = (String)fields.get(fieldName);
            
            if ((fieldValue != null) && (fieldValue.length() > 0)) {
                // append the URL parameters
                buf.append(URLEncoder.encode(fieldName));
                buf.append('=');
                buf.append(URLEncoder.encode(fieldValue));
            }

            // add a '&' to the end if we have more fields coming.
            if (itr.hasNext()) {
                buf.append('&');
            }
        }
    
    } 
    //END appendQueryFields()
    //--------------------------------------------------------------------------
    //--------------------------------------------------------------------------
    %>

    <%
    //--------------------------------------------------------------------------
    //--------------------------------------------------------------------------
    // START OF MAIN PROGRAM
    //--------------------------------------------------------------------------
    //--------------------------------------------------------------------------
    // The Page does a redirect to the Virtual Payment Client
	// retrieve all the parameters into a hash map
	Map fields = new HashMap();
	
	for (Enumeration enum1 = request.getParameterNames(); enum1.hasMoreElements();) {
		String fieldName = (String) enum1.nextElement();
		String fieldValue = request.getParameter(fieldName);
		if ((fieldValue != null) && (fieldValue.length() > 0)) {
			fields.put(fieldName, fieldValue);
		}
	}
	
	// no need to send the vpc url, EnableAVSdata and submit button to the vpc
	String vpcURL = (String) fields.remove("virtualPaymentClientURL");
	fields.remove("SubButL");
        fields.remove("Title");
    
    	
    // Retrieve the order page URL from the incoming order page and add it to 
    // the hash map. This is only here to give the user the easy ability to go 
	// back to the Order page. This would not be required in a production system
    // NB. Other merchant application fields can be added in the same manner
	// String againLink = request.getHeader("Referer");
	//fields.put("AgainLink", againLink);

	// Create MD5 secure hash and insert it into the hash map if it was created
	// created. Remember if SECURE_SECRET = "" it will not be created
	if (SECURE_SECRET != null && SECURE_SECRET.length() > 0) {
		String secureHash = hashAllFields(fields);
		fields.put("vpc_SecureHash", secureHash);
	}
	
	// Create a redirection URL
	StringBuffer buf = new StringBuffer();
	buf.append(vpcURL).append('?');
	appendQueryFields(buf, fields);

	// Redirect to Virtual PaymentClient
    	response.sendRedirect(buf.toString());

%>
