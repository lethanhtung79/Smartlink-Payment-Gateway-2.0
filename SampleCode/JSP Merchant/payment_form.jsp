<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.Date"%>
<%@page import="java.io.*"%>
<%@page import="java.net.URLEncoder" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%
String strURLReturn = "http://localhost/shop/";
String strURL = "http://payment.smartlink.com.vn/gateway/";

Date today = new Date();
String getMerchantTntRef = "TEST_" + String.valueOf(today.getTime()).substring(5);
String getMerchantOrderInfo = String.valueOf(today.getTime() + 82009);

String strAccessCode = "ECAFAB";
String strMerchantCode = "SMLTEST";

%>
<html>
<head><title>Virtual Payment Client Example</title>
<meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1'>
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
</style></head>
<body>

<!-- Start Branding Table -->
<table width="100%" border="2" cellpadding="2" bgcolor="#C1C1C1">
    <tr>
        <td class="shade" width="90%"><h2 class="co">&nbsp;Virtual Payment Client Example</h2></td>
        <td bgcolor="#C1C1C1" align="center"><h3 class="co">Smartlink</h3></td>
    </tr>
</table>
<!-- End Branding Table -->

<center><h1>JSP 3-Party Basic Example - Request Details</h1></center>

<!-- The "Pay Now!" button submits the form, transferring control -->
<form action="vpc_Digital_Order.jsp" method="post">

<!-- get user input -->
<table width="80%" align="center" border="0" cellpadding='0' cellspacing='0'>

    <tr class="shade">
        <td width="1%">&nbsp;</td>
        <td width="40%" align="right"><strong><em>Virtual Payment Client URL:&nbsp;</em></strong></td>
        <td width="59%"><input type="text" name="virtualPaymentClientURL" size="63" value="<%=strURL%>vpcpay.do" maxlength="250"/></td>
    </tr>
    <tr>
        <td colspan="3">&nbsp;<hr width="75%">&nbsp;</td>
    </tr>
    <tr class="title">
        <td colspan="3" height="25"><p><strong>&nbsp;Basic 3-Party Transaction Fields</strong></p></td>
    </tr>
    <tr>
        <td>&nbsp;</td>
        <td align="right"><strong><em> VPC Version: </em></strong></td>
        <td><input type="text" name="vpc_Version" value="2.0" size="20" maxlength="8"/></td>
    </tr>
    <tr class="shade">
        <td>&nbsp;</td>
        <td align="right"><strong><em>Command Type: </em></strong></td>
        <td><input type="text" name="vpc_Command" value="pay" size="20" maxlength="16"/></td>
    </tr>
    <tr>
        <td>&nbsp;</td>
        <td align="right"><strong><em>Merchant AccessCode: </em></strong></td>
        <td>
            <input type="text" name="vpc_AccessCode" value="<%=strAccessCode%>" size="20" maxlength="8"/></td>
    </tr>
    <tr class="shade">
        <td>&nbsp;</td>
        <td align="right"><strong><em>Merchant Transaction Reference: </em></strong></td>
        <td><input type="text" name="vpc_MerchTxnRef" value="<%=getMerchantTntRef%>" size="20" maxlength="40"/></td>
    </tr>
    <tr>
        <td>&nbsp;</td>
        <td align="right"><strong><em>MerchantID: </em></strong></td>
        <td>
            <input type="text" name="vpc_Merchant" value="<%=strMerchantCode%>" size="20" maxlength="16"/></td>
    </tr>
    <tr class="shade">
        <td>&nbsp;</td>
        <td align="right"><strong><em>Transaction OrderInfo: </em></strong></td>
        <td><input type="text" name="vpc_OrderInfo" value="Shop test" size="20" maxlength="34"/></td>
    </tr>
    <tr>
        <td>&nbsp;</td>
        <td align="right"><strong><em>Purchase Amount: </em></strong></td>
        <td><input type="text" name="vpc_Amount" value="1000" size="20" maxlength="20"/></td>
    </tr>
    <tr class="shade">
        <td>&nbsp;</td>
        <td align="right"><strong><em>Receipt ReturnURL: </em></strong></td>
        <td>
            <input type="text" name="vpc_ReturnURL" size="63" value="<%=strURLReturn%>vpc_Digital_Receive.jsp" maxlength="250"/></td>
    </tr>
    <tr class="shade">
        <td>&nbsp;</td>
        <td align="right"><strong><em>Cancel URL: </em></strong></td>
        <td>
            <input type="text" name="vpc_BackURL" size="63" value="<%=strURLReturn%>payment_form.jsp" maxlength="250"/></td>
    </tr>
    <tr>
        <td>&nbsp;</td>
        <td align="right"><strong><em>Payment Server Display Language Locale: </em></strong></td>
        <td><input type="text" name="vpc_Locale" value="vn" size="20" maxlength="5"/></td>
    </tr>
	<tr class="shade">
        <td>&nbsp;</td>
        <td align="right"><strong><em>Currency: </em></strong></td>
        <td><input type="text" name="vpc_Currency" value="VND" size="20" maxlength="5"/></td>
    </tr>
	 <tr>
        <td>&nbsp;</td>
        <td align="right"><strong><em>IP address: </em></strong></td>
        <td><input type="text" name="vpc_TicketNo" maxlength="15" value="127.0.0.1"/></td>
    </tr>
    <tr><td colspan="3">&nbsp;<hr width="75%">&nbsp;</td></tr>
    <tr>    <td colspan="2">&nbsp;</td>
            <td><input type="submit" name="SubButL" value="Pay Now!"/></td></tr>


</table>

</form>
</body>
</html>
