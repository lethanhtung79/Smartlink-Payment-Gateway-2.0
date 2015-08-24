<?php

// Define Constants
// ----------------
// This is secret for encoding the MD5 hash
// This secret will vary from merchant to merchant
// To not create a secure hash, let SECURE_SECRET be an empty string - ""
// $SECURE_SECRET = "secure-hash-secret";
$SECURE_SECRET = "198BE3F2E8C75A53F38C1C4A5B6DBA27";

// If there has been a merchant secret set then sort and loop through all the
// data in the Virtual Payment Client response. While we have the data, we can
// append all the fields that contain values (except the secure hash) so that
// we can create a hash and validate it against the secure hash in the Virtual
// Payment Client response.

// NOTE: If the vpc_ResponseCode in not a single character then
// there was a Virtual Payment Client error and we cannot accurately validate
// the incoming data from the secure hash. */

// get and remove the vpc_ResponseCode code from the response fields as we
// do not want to include this field in the hash calculation
$vpc_Txn_Secure_Hash = $_GET["vpc_SecureHash"];
unset($_GET["vpc_SecureHash"]); 

// set a flag to indicate if hash has been validated
$errorExists = false;

if (strlen($SECURE_SECRET) > 0 && $_GET["vpc_ResponseCode"] != "No Value Returned") {

    $md5HashData = $SECURE_SECRET;

    // sort all the incoming vpc response fields and leave out any with no value
    foreach($_GET as $key => $value) {
        if ($key != "vpc_SecureHash" or strlen($value) > 0) {
            $md5HashData .= $value;
        }
    }
    
    // Validate the Secure Hash (remember MD5 hashes are not case sensitive)
	// This is just one way of displaying the result of checking the hash.
	// In production, you would work out your own way of presenting the result.
	// The hash check is all about detecting if the data has changed in transit.
    if (strtoupper($vpc_Txn_Secure_Hash) == strtoupper(md5($md5HashData))) {
        // Secure Hash validation succeeded, add a data field to be displayed
        // later.
        $hashValidated = "<FONT color='#00AA00'><strong>CORRECT</strong></FONT>";
    } else {
        // Secure Hash validation failed, add a data field to be displayed
        // later.
        $hashValidated = "<FONT color='#FF0066'><strong>INVALID HASH</strong></FONT>";
        $errorExists = true;
    }
} else {
    // Secure Hash was not validated, add a data field to be displayed later.
    $hashValidated = "<FONT color='orange'><strong>Not Calculated - No 'SECURE_SECRET' present.</strong></FONT>";
}

// Define Variables
// ----------------
// Extract the available receipt fields from the VPC Response
// If not present then let the value be equal to 'No Value Returned'

// Standard Receipt Data
$version         = null2unknown($_GET["vpc_Version"]);
$locale          = null2unknown($_GET["vpc_Locale"]);
$command         = null2unknown($_GET["vpc_Command"]);
$merchantID      = null2unknown($_GET["vpc_Merchant"]);
$merchTxnRef     = null2unknown($_GET["vpc_MerchTxnRef"]);
$amount          = null2unknown($_GET["vpc_Amount"]);
$currencyCode    = null2unknown($_GET["vpc_CurrencyCode"]);
$orderInfo       = null2unknown($_GET["vpc_OrderInfo"]);
$txnResponseCode = null2unknown($_GET["vpc_ResponseCode"]);
$transactionNo   = null2unknown($_GET["vpc_TransactionNo"]);
$additionData    = null2unknown($_GET["vpc_AdditionData"]);
$batchNo         = null2unknown($_GET["vpc_BatchNo"]);
$acqResponseCode = null2unknown($_GET["vpc_AcqResponseCode"]);
$message         = null2unknown($_GET["vpc_Message"]);

// *******************
// END OF MAIN PROGRAM
// *******************

// FINISH TRANSACTION - Process the VPC Response Data
// =====================================================
// For the purposes of demonstration, we simply display the Result fields on a
// web page.

// Show 'Error' in title if an error condition
$errorTxt = "";

// Show this page as an error page if vpc_ResponseCode equals '0'
if ($txnResponseCode != "0" || $txnResponseCode == "No Value Returned" || $errorExists) {
    $errorTxt = "Error ";
}
    
// This is the display title for 'Receipt' page 
$title = $_GET["Title"];

// The URL link for the receipt to do another transaction.
// Note: This is ONLY used for this example and is not required for 
// production code. You would hard code your own URL into your application
// to allow customers to try another transaction.
//TK//$againLink = URLDecode($_GET["AgainLink"]);

?>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
    <head>
        <title><?=$title?> - <?=$errorTxt?>Response Page</title>
        <meta http-equiv="Content-Type" content="text/html, charset=utf-8">
        <style type="text/css">
            <!--
            h1       { font-family:Arial,sans-serif; font-size:24pt; color:#08185A; font-weight:100}
            h2.co    { font-family:Arial,sans-serif; font-size:24pt; color:#08185A; margin-top:0.1em; margin-bottom:0.1em; font-weight:100}
            h3.co    { font-family:Arial,sans-serif; font-size:16pt; color:#000000; margin-top:0.1em; margin-bottom:0.1em; font-weight:100}
            body     { font-family:Verdana,Arial,sans-serif; font-size:10pt; color:#08185A background-color:#FFFFFF }
            p        { font-family:Verdana,Arial,sans-serif; font-size:8pt; color:#FFFFFF }
            a:link   { font-family:Verdana,Arial,sans-serif; font-size:8pt; color:#08185A }
            a:visited{ font-family:Verdana,Arial,sans-serif; font-size:8pt; color:#08185A }
            a:hover  { font-family:Verdana,Arial,sans-serif; font-size:8pt; color:#FF0000 }
            a:active { font-family:Verdana,Arial,sans-serif; font-size:8pt; color:#FF0000 }
			tr       { height:25px; }
			tr.shade { height:25px; background-color:#E1E1E1 }
			tr.title { height:25px; background-color:#C1C1C1 }
            td       { font-family:Verdana,Arial,sans-serif; font-size:8pt; color:#08185A }
            td.red   { font-family:Verdana,Arial,sans-serif; font-size:8pt; color:#FF0066 }
            td.green { font-family:Verdana,Arial,sans-serif; font-size:8pt; color:#00AA00 }
            th       { font-family:Verdana,Arial,sans-serif; font-size:10pt; color:#08185A; font-weight:bold; background-color:#E1E1E1; padding-top:0.5em; padding-bottom:0.5em}
            input    { font-family:Verdana,Arial,sans-serif; font-size:8pt; color:#08185A; background-color:#E1E1E1; font-weight:bold }
            select   { font-family:Verdana,Arial,sans-serif; font-size:8pt; color:#08185A; background-color:#E1E1E1; font-weight:bold; width:463 }
            textarea { font-family:Verdana,Arial,sans-serif; font-size:8pt; color:#08185A; background-color:#E1E1E1; font-weight:normal; scrollbar-arrow-color:#08185A; scrollbar-base-color:#E1E1E1 }
            -->
        </style>
    </head>
    <body>
		<!-- start branding table -->
		<table width='100%' border='2' cellpadding='2' bgcolor='#C1C1C1'>
			<tr>
				<td bgcolor='#E1E1E1' width='90%'><h2 class='co'>&nbsp;Virtual Payment Client - Version 1</h2></td>
				<td bgcolor='#C1C1C1' align='center'><h3 class='co'>Smartlink</h3></td>
			</tr>
		</table>
		<!-- end branding table -->
        <!-- End Branding Table -->
        <center><h1><?=$title?> - <?=$errorTxt?>Response Page</h1></center>
        <table width="85%" align="center" cellpadding="5" border="0">
            <tr class="title">
                <td colspan="2" height="25"><P><strong>&nbsp;Basic Transaction Fields</strong></P></td>
            </tr>
            <tr>
                <td align="right" width="55%"><strong><i>VPC API Version: </i></strong></td>
                <td width="45%"><?=$version?></td>
            </tr>
            <tr class="shade">
                <td align="right"><strong><i>Command: </i></strong></td>
                <td><?=$command?></td>
            </tr>
            <tr>
                <td align="right"><strong><i>Merchant Transaction Reference: </i></strong></td>
                <td><?=$merchTxnRef?></td>
            </tr>
            <tr class="shade">
                <td align="right"><strong><i>Merchant ID: </i></strong></td>
                <td><?=$merchantID?></td>
            </tr>
            <tr>
                <td align="right"><strong><i>Order Information: </i></strong></td>
                <td><?=$orderInfo?></td>
            </tr>
            <tr class="shade">
                <td align="right"><strong><i>Purchase Amount: </i></strong></td>
                <td><?=$amount?></td>
            </tr>
            <tr>
                <td colspan="2" align="center">
                    <font color="#C1C1C1">Fields above are the request values returned.<br />
                    <HR />
                    Fields below are the response fields for a Standard Transaction.<br /></font>
                </td>
            </tr>
            <tr class="shade">
                <td align="right"><strong><i>VPC Transaction Response Code: </i></strong></td>
                <td><?=$txnResponseCode?></td>
            </tr>
            <tr>
                <td align="right"><strong><i>Transaction Response Code Description: </i></strong></td>
                <td><?=getResponseDescription($txnResponseCode)?></td>
            </tr>
            <tr class="shade">
                <td align="right"><strong><i>Message: </i></strong></td>
                <td><?=$message?></td>
            </tr>
            <tr>
                <td align="right"><strong><i>Transaction Number: </i></strong></td>
                <td><?=$transactionNo?></td>
            </tr>
            <tr class="shade">
                <td align="right"><strong><i>Acquirer Response Code: </i></strong></td>
                <td><?=$acqResponseCode?></td>
            </tr>
            <tr>
                <td align="right"><strong><i>Batch Number: </i></strong></td>
                <td><?=$batchNo?></td>
            </tr>
            <tr class="shade">
                <td align="right"><strong><i>Additional Data: </i></strong></td>
                <td><?=$additionData?></td>
            </tr>
            <tr>
                <td colspan="2"><HR /></td>
            </tr>
            <tr class="title">
                <td colspan="2" height="25"><P><strong>&nbsp;Hash Validation</strong></P></td>
            </tr>
            <tr>
                <td align="right"><strong><i>Hash Validated Correctly: </i></strong></td>
                <td><?=$hashValidated?></td>
            </tr>
	    </table>
    </body>
</html>

<?    
// End Processing

// This method uses the QSI Response code retrieved from the Digital
// Receipt and returns an appropriate description for the QSI Response Code
//
// @param $responseCode String containing the QSI Response Code
//
// @return String containing the appropriate description
//
function getResponseDescription($responseCode) {

    switch ($responseCode) {
        case "0" : $result = "Giao dich thanh cong"; break;
        case "1" : $result = "Ngan hang tu choi thanh toan: the/tai khoan bi khoa"; break;
        case "2" : $result = "Loi so 2"; break;
        case "3" : $result = "The het han"; break;
        case "4" : $result = "Qua so lan giao dich cho phep. (Sai OTP, qua han muc trong ngay)"; break;
        case "5" : $result = "Khong co tra loi tu Ngan hang"; break;
        case "6" : $result = "Loi giao tiep voi Ngan hang"; break;
        case "7" : $result = "Tai khoan khong du tien"; break;
        case "8" : $result = "Loi du lieu truyen"; break;
        case "9" : $result = "Kieu giao dich khong duoc ho tro"; break;
        default  : $result = "Loi khong xac dinh"; 
    }
    return $result;
}



//  -----------------------------------------------------------------------------

// If input is null, returns string "No Value Returned", else returns input
function null2unknown($data) {
    if ($data == "") {
        return "No Value Returned";
    } else {
        return $data;
    }
} 
    
//  ----------------------------------------------------------------------------
