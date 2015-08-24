<?php

// Define Constants
// ----------------
// This is secret for encoding the MD5 hash
// This secret will vary from merchant to merchant
// To not create a secure hash, let SECURE_SECRET be an empty string - ""
// $SECURE_SECRET = "secure-hash-secret";
$SECURE_SECRET = "198BE3F2E8C75A53F38C1C4A5B6DBA27";

// add the start of the vpcURL querystring parameters
$vpcURL = $_POST["virtualPaymentClientURL"] . "?";

// Remove the Virtual Payment Client URL from the parameter hash as we 
// do not want to send these fields to the Virtual Payment Client.
unset($_POST["virtualPaymentClientURL"]); 
unset($_POST["SubButL"]);

// Create the request to the Virtual Payment Client which is a URL encoded GET
// request. Since we are looping through all the data we may as well sort it in
// case we want to create a secure hash and add it to the VPC data if the
// merchant secret has been provided.
$md5HashData = $SECURE_SECRET;
ksort ($_POST);

// set a parameter to show the first pair in the URL
$appendAmp = 0;

foreach($_POST as $key => $value) {

    // create the md5 input and URL leaving out any fields that have no value
    if (strlen($value) > 0) {
        
        // this ensures the first paramter of the URL is preceded by the '?' char
        if ($appendAmp == 0) {
            $vpcURL .= urlencode($key) . '=' . urlencode($value);
            $appendAmp = 1;
        } else {
            $vpcURL .= '&' . urlencode($key) . "=" . urlencode($value);
        }
        $md5HashData .= $value;
    }
}

// Create the secure hash and append it to the Virtual Payment Client Data if
// the merchant secret has been provided.
if (strlen($SECURE_SECRET) > 0) {
    $vpcURL .= "&vpc_SecureHash=" . strtoupper(md5($md5HashData));
}

// FINISH TRANSACTION - Redirect the customers using the Digital Order
// ===================================================================
header("Location: ".$vpcURL);

