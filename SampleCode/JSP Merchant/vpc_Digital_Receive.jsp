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
    /* Note:
       ----
       In a proper production environment, only the retrieving of all the input 
       parameters and the HTML output would be in this file. The following 
       constants and all other methods would be contained in a separate helper
       class so that users could not gain access to these values. */
    
    // This is secret for encoding the MD5 hash
    // This secret will vary from merchant to merchant
    // static final String SECURE_SECRET = "your-secure-hash-secret";
    //SMLTEST
    static final String SECURE_SECRET = "198BE3F2E8C75A53F38C1C4A5B6DBA27";
%>    
<%! // This is an array for creating hex chars
    static final char[] HEX_TABLE = new char[] {
        '0', '1', '2', '3', '4', '5', '6', '7',
        '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'};

    //--------------------------------------------------------------------------
    //--------------------------------------------------------------------------
    /**
    * This method is for sorting the fields and creating an MD5 secure hash.
    *
    * @param fields is a map of all the incoming hey-value pairs from the VPC
    * @return is the hash being returned for comparison to the incoming hash
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
       
       return hex(ba);
    
    }
    // end hashAllFields()
    //--------------------------------------------------------------------------
    //--------------------------------------------------------------------------
    /*
    * This method takes a byte array and returns a string of its contents
    *
    * @param input - byte array containing the input data
    * @return String containing the output String
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
    /*
    * This method takes a data String and returns a predefined value if empty
    * If data Sting is null, returns string "No Value Returned", else returns input
    *
    * @param in String containing the data String
    * @return String containing the output String
    */
    private static String null2unknown(String in) {
        if (in == null || in.length() == 0) {
            return "Không có giá trị trả về";
        } else {
            return in;
        }
    }
    // null2unknown()
    //--------------------------------------------------------------------------
    //--------------------------------------------------------------------------
    /*
    * This function uses the returned status code retrieved from the Digital
    * Response and returns an appropriate description for the code
    *
    * @param vResponseCode String containing the vpc_ResponseCode
    * @return description String containing the appropriate description
    */
    //--------------------------------------------------------------------------
    //--------------------------------------------------------------------------
    String getResponseDescription(String vResponseCode) {
        String result = "";
        // check if a single digit response code
        if (vResponseCode.length() >= 1) {
            // Java cannot switch on a string so turn everything to a char
            char input = vResponseCode.charAt(0);
            switch (input){
                case '0' : result = "Giao dịch thành công"; break;
                case '1' : result = "Ngân hàng từ chối thanh toán: thẻ/tài khoản bị khóa"; break;
                case '3' : result = "Thẻ hết hạn"; break;
                case '4' : result = "Lỗi người mua hàng: Quá số lần cho phép. (Sai OTP, quá hạn mức trong ngày)"; break;
                case '5' : result = "Không có trả lời của Ngân hàng"; break;
                case '6' : result = "Lỗi giao tiếp với Ngân hàng"; break;
                case '7' : result = "Tài khoản không đủ tiền"; break;
                case '8' : result = "Lỗi checksum dữ liệu"; break;
                case '9' : result = "Kiểu giao dịch không được hỗ trợ"; break;
                default  : result = "Không xác định";
            }
            return result;
        } else {
            return "Không có giá trị trả về";
        }
    }
   
    //--------------------------------------------------------------------------
    //--------------------------------------------------------------------------
    %>
    <%
    //--------------------------------------------------------------------------
    //--------------------------------------------------------------------------
    // START OF MAIN PROGRAM
    //--------------------------------------------------------------------------
    //--------------------------------------------------------------------------
    // The Page does a display to a browser
    // retrieve all the incoming parameters into a hash map
    Map fields = new HashMap();
    for (Enumeration enum1 = request.getParameterNames(); enum1.hasMoreElements();) {
        String fieldName = (String) enum1.nextElement();
        String fieldValue = request.getParameter(fieldName);
        if ((fieldValue != null) && (fieldValue.length() > 0)) {
            fields.put(fieldName, fieldValue);
        }
    }
    /*
    If there has been a merchant secret set then sort and loop through all the
    data in the Virtual Payment Client response. while we have the data, we can
    append all the fields that contain values (except the secure hash) so that
    we can create a hash and validate it against the secure hash in the Virtual
    Payment Client response.

    NOTE: If the vpc_ResponseCode in not a single character then
    there was a Virtual Payment Client error and we cannot accurately validate
    the incoming data from the secure hash. */

    // remove the vpc_ResponseCode code from the response fields as we do not 
    // want to include this field in the hash calculation
    String vpc_Txn_Secure_Hash = null2unknown((String) fields.remove("vpc_SecureHash"));
    String hashValidated = null;

    // defines if error message should be output
    boolean errorExists = false;
    
    if (SECURE_SECRET != null && SECURE_SECRET.length() > 0 && 
        (fields.get("vpc_ResponseCode") != null || fields.get("vpc_ResponseCode") != "Không có giá trị trả về")) {
        
        // create secure hash and append it to the hash map if it was created
        // remember if SECURE_SECRET = "" it wil not be created
        String secureHash = hashAllFields(fields);
    
        // Validate the Secure Hash (remember MD5 hashes are not case sensitive)
        if (vpc_Txn_Secure_Hash.equalsIgnoreCase(secureHash)) {
            // Secure Hash validation succeeded, add a data field to be 
            // displayed later.
            hashValidated = "<font color='#00AA00'><strong>CORRECT</strong></font>";
        } else {
            // Secure Hash validation failed, add a data field to be
            // displayed later.
            errorExists = true;
            hashValidated = "<font color='#FF0066'><strong>INVALID HASH</strong></font>";
        }
    } else {
        // Secure Hash was not validated, 
        hashValidated = "<font color='orange'><strong>Not Calculated - No 'SECURE_SECRET' present.</strong></font>";
    }

    // Extract the available receipt fields from the VPC Response
    // If not present then let the value be equal to 'Unknown'
    // Standard Receipt Data
    String amount          = null2unknown((String)fields.get("vpc_Amount"));
    String locale          = null2unknown((String)fields.get("vpc_Locale"));
    String batchNo         = null2unknown((String)fields.get("vpc_BatchNo"));
    String command         = null2unknown((String)fields.get("vpc_Command"));
    String message         = null2unknown((String)fields.get("vpc_Message"));
    String version         = null2unknown((String)fields.get("vpc_Version"));
    String orderInfo       = null2unknown((String)fields.get("vpc_OrderInfo"));
    String receiptNo       = null2unknown((String)fields.get("vpc_ReceiptNo"));
    String merchantID      = null2unknown((String)fields.get("vpc_Merchant"));
    String merchTxnRef     = null2unknown((String)fields.get("vpc_MerchTxnRef"));
    String authorizeID     = null2unknown((String)fields.get("vpc_AuthorizeId"));
    String transactionNo   = null2unknown((String)fields.get("vpc_TransactionNo"));
    String acqResponseCode = null2unknown((String)fields.get("vpc_AcqResponseCode"));
    String txnResponseCode = null2unknown((String)fields.get("vpc_ResponseCode"));
    String cardType        = null2unknown((String)fields.get("vpc_CardType"));


    String error = "";
    // Show this page as an error page if error condition
    if (txnResponseCode.equals("7") || txnResponseCode.equals("Không có giá trị trả về") || errorExists) {
        error = "Lỗi ";
    }
        
    // FINISH TRANSACTION - Process the VPC Response Data
    // =====================================================
    // For the purposes of demonstration, we simply display the Result fields on a
    // web page.
%>  <!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.01 Transitional//EN'>
    <html>
    <head><title>SMARTLINK PAYMENT GATEWAY - <%=error%></title>
        <meta http-equiv='Content-Type' content='text/html, charset=utf-8'>
        <style type='text/css'>
            <!--
            h1       { font-family:Arial,sans-serif; font-size:20pt; font-weight:600; margin-bottom:0.1em; color:#08185A;}
            h2       { font-family:Arial,sans-serif; font-size:14pt; font-weight:100; margin-top:0.1em; color:#08185A;}
            h2.co    { font-family:Arial,sans-serif; font-size:24pt; font-weight:100; margin-top:0.1em; margin-bottom:0.1em; color:#08185A}
            h3       { font-family:Arial,sans-serif; font-size:16pt; font-weight:100; margin-top:0.1em; margin-bottom:0.1em; color:#08185A}
            h3.co    { font-family:Arial,sans-serif; font-size:16pt; font-weight:100; margin-top:0.1em; margin-bottom:0.1em; color:#FFFFFF}
            body     { font-family:Verdana,Arial,sans-serif; font-size:10pt; background-color:#FFFFFF; color:#08185A}
            th       { font-family:Verdana,Arial,sans-serif; font-size:8pt; font-weight:bold; background-color:#E1E1E1; padding-top:0.5em; padding-bottom:0.5em;  color:#08185A}
            tr       { height:25px; }
            .shade   { height:25px; background-color:#E1E1E1 }
            .title   { height:25px; background-color:#C1C1C1 }
            td       { font-family:Verdana,Arial,sans-serif; font-size:8pt;  color:#08185A }
            td.red   { font-family:Verdana,Arial,sans-serif; font-size:8pt;  color:#FF0066 }
            td.green { font-family:Verdana,Arial,sans-serif; font-size:8pt;  color:#008800 }
            p        { font-family:Verdana,Arial,sans-serif; font-size:10pt; color:#FFFFFF }
            p.blue   { font-family:Verdana,Arial,sans-serif; font-size:7pt;  color:#08185A }
            p.red    { font-family:Verdana,Arial,sans-serif; font-size:7pt;  color:#FF0066 }
            p.green  { font-family:Verdana,Arial,sans-serif; font-size:7pt;  color:#008800 }
            div.bl   { font-family:Verdana,Arial,sans-serif; font-size:7pt;  color:#C1C1C1 }
            div.red  { font-family:Verdana,Arial,sans-serif; font-size:7pt;  color:#FF0066 }
            li       { font-family:Verdana,Arial,sans-serif; font-size:8pt;  color:#FF0066 }
            input    { font-family:Verdana,Arial,sans-serif; font-size:8pt;  color:#08185A; background-color:#E1E1E1; font-weight:bold }
            select   { font-family:Verdana,Arial,sans-serif; font-size:8pt;  color:#08185A; background-color:#E1E1E1; font-weight:bold; }
            textarea { font-family:Verdana,Arial,sans-serif; font-size:8pt;  color:#08185A; background-color:#E1E1E1; font-weight:normal; scrollbar-arrow-color:#08185A; scrollbar-base-color:#E1E1E1 }
            -->
        </style>
    </head>
    <body>
<table width="90%" align="center" border="0" cellpadding='0' cellspacing='0'>
    <tr>
        <td height="70" colspan="2"><h1>WEBSITE THƯƠNG MẠI ĐIỆN TỬ</h1></td>
    </tr>
    <tr>
        <td background="images/header_bg.gif"></td>
        <td height="60" background="images/header_bg.gif">
            <h1>Thông tin kết quả thanh toán</h1>
        </td>
    </tr>
    <tr>
        <td><img src="images/shoppingcart.jpg" border="0"></td>
        <td width="80%" valign="top">

            <center>

            <center><h2><%=error%></h2></center>

            <table width="100%" align='center' cellpadding='5' border='0'>

                <tr class='title'>
                    <td colspan="2" height="25"><p><strong>Thông tin giao dịch</strong></p></td>
                </tr>
                <tr>
                    <td align='right' width='50%'><strong><i>VPC API Version: </i></strong></td>
                    <td width='50%'><%=version%></td>
                </tr>
                <tr class='shade'>
                    <td align='right'><strong><i>Ngôn ngữ: </i></strong></td>
                    <td><%=locale%></td>
                </tr>
                <tr>
                    <td align='right'><strong><i>Merchant ID: </i></strong></td>
                    <td><%=merchantID%></td>
                </tr>
                <tr class='shade'>
                    <td align='right'><strong><i>Lệnh: </i></strong></td>
                    <td><%=command%></td>
                </tr>
                <tr>
                    <td align='right'><strong><i>Mã hóa đơn: </i></strong></td>
                    <td><%=merchTxnRef%></td>
                </tr>
                <tr class='shade'>
                    <td align='right'><strong><i>Tổng số tiền: </i></strong></td>
                    <td><%=amount%></td>
                </tr>
                <tr>
                    <td align='right'><strong><i>Thông tin đơn hàng: </i></strong></td>
                    <td><%=orderInfo%></td>
                </tr>

                <tr>
                    <td colspan='2' align='center'><font color='#C1C1C1'>Các thông tin trên là thông tin đơn hàng đề nghị thanh toán.<br/></font><hr/>
                    </td>
                </tr>

                <tr class='title'>
                    <td colspan="2" height="25"><p><strong>Thông tin về kết quả giao dịch</strong></p></td>
                </tr>
                <tr class='shade'>
                    <td align='right'><strong><i>Mã kết quả giao dịch: </i></strong></td>
                    <td><%=txnResponseCode%></td>
                </tr>
                <tr>
                    <td align='right'><strong><i>Ý nghĩa của Mã kết quả giao dịch: </i></strong></td>
                    <td><%=getResponseDescription(txnResponseCode)%></td>
                </tr>
                <tr class='shade'>
                    <td align='right'><strong><i>Message: </i></strong></td>
                    <td><%=message%></td>
                </tr>
                <%
                // only display the following fields if not an error condition
                if (!txnResponseCode.equals("7") && !txnResponseCode.equals("Không có giá trị trả về")) {
                %>
                        <tr>
                            <td align='right'><strong><i>Receipt Number: </i></strong></td>
                            <td><%=receiptNo%></td>
                        </tr>
                        <tr class='shade'>
                            <td align='right'><strong><i>Transaction Number: </i></strong></td>
                            <td><%=transactionNo%></td>
                        </tr>
                        <tr>
                            <td align='right'><strong><i>Acquirer Response Code: </i></strong></td>
                            <td><%=acqResponseCode%></td>
                        </tr>
                        <tr class='shade'>
                            <td align='right'><strong><i>Bank Authorization ID: </i></strong></td>
                            <td><%=authorizeID%></td>
                        </tr>
                        <tr>
                            <td align='right'><strong><i>Batch Number: </i></strong></td>
                            <td><%=batchNo%></td>
                        </tr>
                        <tr class='shade'>
                            <td align='right'><strong><i>Card Type: </i></strong></td>
                            <td><%=cardType%></td>
                        </tr>
                        <tr class='title'>
                            <td colspan="2" height="25"><p><strong>Kiểm tra Hash</strong></p></td>
                        </tr>
                        <tr>
                            <td align="right"><strong><i>Kiểm tra giá trị Hash: </i></strong></td>
                            <td><%=hashValidated%></td>
                        </tr>

                <%
                }%></table><br/>

            </center>
        </td>
    </tr>
    <tr>
        <td align="center"  colspan="2">
            <P><A HREF='payment_form.jsp'>Thanh toán giao dịch mới</A></P>
        </td>
    </tr>
</table>

<center>
    SMARTLINK CARD., JSC
    <br>
    <%//=ttt%>
</center>
   
    </body>
    </html>
