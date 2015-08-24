<%@ LANGUAGE=vbscript %>
<%
Option Explicit

' Turn off default error checking, as any errors are explicitly handled
'On Error Resume Next

%>
<!--#include file="vpc_md5.asp"-->
<%

' *******************************************
' START OF MAIN PROGRAM
' *******************************************

' The Page does a redirect to the Virtual Payment Client

' Define Constants
' ----------------
' This is secret for encoding the MD5 hash
' This secret will vary from merchant to merchant
' To not create a secure hash, let SECURE_SECRET be an empty string - ""
' Const SECURE_SECRET = "Your-Secure-Secret"
Const SECURE_SECRET = "198BE3F2E8C75A53F38C1C4A5B6DBA27"

' Stop the page being cached on the web server
Response.Expires = 0

' *******************************************
' Define Variables
' *******************************************
' Local Variables
Dim hashValidated, errorExists, errorTitle

' Standard Receipt Data
Dim amount, locale, batchNo, command, message, version, cardType, orderInfo, _
    merchantID, additionalData, merchTxnRef, transactionNo, acqResponseCode, responseCode, currencycode

' Initialise the Local Variables
hashValidated = "<font color='orange'><b>Not Calculated</b></font>"
errorTitle = ""
errorExists = 0

' If we have a SECURE_SECRET then validate the incoming data using the MD5 hash
' included in the incoming data
If Len(SECURE_SECRET) > 0 And Len(Request.QueryString("vpc_SecureHash")) > 0 Then
    ' Find out if the incoming data is in a POST or a GET
    ' Create a 2 dimensional array to hold the form variables so we can sort them
    Dim MyArray
    Dim count
    Dim item
    ReDim MyArray((Request.QueryString.Count),1)

    ' Enter each of the appropriate form variables into the array.
    count = 1
    For Each item In Request.QueryString
        ' Do not include the Virtual Payment Client URL, the Submit button 
        ' from the form post, or any control fields, as we do not want to send 
        ' these fields to the Virtual Payment Client. 
        If Request.QueryString(item) <> "" And item <> "vpc_SecureHash" Then
            ' Add the item to the array
            MyArray (count,0) = item                
            MyArray (count,1) = Request.QueryString(item)
            ' Increment the count to the next array location
            count = count + 1
        End If
    Next

    ' Validate the Secure Hash (remember MD5 hashes are not case sensitive)
    If UCase(Request.QueryString("vpc_SecureHash")) = UCase(doSecureHash) Then
        ' Secure Hash validation succeeded,
        ' add a data field to be displayed later.
        hashValidated = "<font color='#00AA00'><b>CORRECT</b></font>"
    Else
        ' Secure Hash validation failed, add a data field to be displayed
        ' later.
        hashValidated = "<font color='#FF0066'><b>INVALID HASH</b></font>"
        errorExists = 1
    End If
End If

If Err Then
    message = "Error validating Secure Hash: " & Err.Source & " - " & Err.number & " - " & Err.Description
    Response.End
End If

' FINISH TRANSACTION - Output the VPC Response Data
' =====================================================
' For the purposes of demonstration, we simply display the Result fields on a
' web page.

' Extract the available receipt fields from the VPC Response
' If not present then set the value to "No Value Returned" using the 
' null2unknown Function

' Standard Receipt Data
version         = null2unknown(Request.QueryString("vpc_Version"))
locale          = null2unknown(Request.QueryString("vpc_Locale"))
command         = null2unknown(Request.QueryString("vpc_Command"))
merchantID      = null2unknown(Request.QueryString("vpc_Merchant"))
merchTxnRef     = null2unknown(Request.QueryString("vpc_MerchTxnRef"))
amount          = null2unknown(Request.QueryString("vpc_Amount"))
currencycode        = null2unknown(Request.QueryString("vpc_CurrencyCode"))
orderInfo       = null2unknown(Request.QueryString("vpc_OrderInfo"))
'Version 1
responseCode    = null2unknown(Request.QueryString("vpc_ResponseCode"))
'Version 1.1
'responseCode    = null2unknown(Request.QueryString("vpc_ResponseCode"))
transactionNo   = null2unknown(Request.QueryString("vpc_TransactionNo"))
cardType        = null2unknown(Request.QueryString("vpc_CardType"))
batchNo         = null2unknown(Request.QueryString("vpc_BatchNo"))
acqResponseCode = null2unknown(Request.QueryString("vpc_AcqResponseCode"))
'Version 1.1
'additionalData  = null2unknown(Request.QueryString("vpc_AdditionalData"))

'Version 1
additionalData  = null2unknown(Request.QueryString("vpc_AdditionData"))

If Len(message) = 0 then
    message     = null2unknown(Request.QueryString("vpc_Message"))
End If


' FINISH TRANSACTION - Process the VPC Response Data
' =====================================================
' For the purposes of demonstration, we simply display the Result fields on
' a web page.

' Show this page as an error page if vpc_responseCode is equal to  "7"
If responseCode = "7" Or responseCode = "No Value Returned" Or errorExists = 1 Then 
    errorTitle = "Error "
End If
    
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
    <head>
        <title>
             - <%=errorTitle%>Response Page</title>
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
            td       { font-family:Verdana,Arial,sans-serif; font-size:8pt; color:#08185A }
            td.red   { font-family:Verdana,Arial,sans-serif; font-size:8pt; color:#FF0066 }
            td.green { font-family:Verdana,Arial,sans-serif; font-size:8pt; color:#00AA00 }
            th       { font-family:Verdana,Arial,sans-serif; font-size:10pt; color:#08185A; font-weight:bold; background-color:#E1E1E1; padding-top:0.5em; padding-bottom:0.5em}
            input    { font-family:Verdana,Arial,sans-serif; font-size:8pt; color:#08185A; background-color:#E1E1E1; font-weight:bold }
            select   { font-family:Verdana,Arial,sans-serif; font-size:8pt; color:#08185A; background-color:#E1E1E1; font-weight:bold; width:463 }
            textarea { font-family:Verdana,Arial,sans-serif; font-size:8pt; color:#08185A; background-color:#E1E1E1; font-weight:normal; scrollbar-arrow-color:#08185A; scrollbar-base-color:#E1E1E1 }
            --></style>
    </head>
    <body>
        <!-- Start Branding Table -->
        <table width="100%" border="2" cellpadding="2" bgcolor="#C1C1C1" ID="Table1">
            <tr>
                <td bgcolor="#E1E1E1" width="90%"><h2 class="co">&nbsp;Virtual Payment Client - ASP Merchant</h2></td>
                <td bgcolor="#C1C1C1" align="center"><h3 class="co">Smartlink</h3></td>
            </tr>
        </table>
        <!-- End Branding Table -->
        <center><h1>ASP Merchant - Response - <%=errorTitle%></h1></center>
        <table width="85%" align="center" cellpadding="5" border="0" ID="Table2">
            <tr bgcolor="#C1C1C1">
                <td colspan="2" height="25"><p><strong>&nbsp;Basic Transaction Fields</strong></p></td>
            </tr>
            <tr>
                <td align="right" width="55%"><strong><i>VPC API Version: </i></strong></td>
                <td width="45%"><%=version%></td>
            </tr>
            <tr bgcolor="#E1E1E1">
                <td align="right"><strong><i>Command: </i></strong></td>
                <td><%=command%></td>
            </tr>
            <tr>
                <td align="right"><strong><i>Merchant Transaction Reference: </i></strong></td>
                <td><%=merchTxnRef%></td>
            </tr>
            <tr bgcolor="#E1E1E1">
                <td align="right"><strong><i>Merchant ID: </i></strong></td>
                <td><%=merchantID%></td>
            </tr>
            <tr>
                <td align="right"><strong><i>Order Information: </i></strong></td>
                <td><%=orderInfo%></td>
            </tr>
            <tr bgcolor="#E1E1E1">
                <td align="right"><strong><i>Amount: </i></strong></td>
                <td><%=amount%></td>
            </tr>
            <tr>
                <td align="right" width="55%"><strong><i>Currency: </i></strong></td>
                <td width="45%"><%=currencycode%></td>
            </tr>
            <tr bgcolor="#E1E1E1">
                <td align="right" width="55%"><strong><i>Language: </i></strong></td>
                <td width="45%"><%=locale%></td>
            </tr>
            <tr>
                <td colspan="2" align="center">
                    <font color="#C1C1C1">Fields above are the request values returned.<br />
                        <hr />
                        Fields below are the response fields for a Standard Transaction.<br />
                    </font>
                </td>
            </tr>
            <tr bgcolor="#E1E1E1">
                <td align="right"><strong><i>VPC Transaction Response Code: </i></strong></td>
                <td><%=responseCode%></td>
            </tr>
            <tr>
                <td align="right"><strong><i>Transaction Response Code Description: </i></strong></td>
                <td><%=getResponseDescription(responseCode)%></td>
            </tr>
            <% 
    ' Only display the following fields if not an error condition
    If responseCode <> "7" And responseCode <> "No Value Returned" Then 
%>
            <tr bgcolor="#E1E1E1">
                <td align="right"><strong><i>Transaction Number: </i></strong></td>
                <td><%=transactionNo%></td>
            </tr>
            <tr>
                <td align="right"><strong><i>Acquirer Response Code: </i></strong></td>
                <td><%=acqResponseCode%></td>
            </tr>
            <tr bgcolor="#E1E1E1">
                <td align="right"><strong><i>Message: </i></strong></td>
                <td><%=message%></td>
            </tr>
            <tr>
                <td align="right"><strong><i>Batch Number: </i></strong></td>
                <td><%=batchNo%></td>
            </tr>
            <tr bgcolor="#E1E1E1">
                <td align="right"><strong><i>Card Type: </i></strong></td>
                <td><%=cardType%></td>
            </tr>
<% End If %>
            <tr>
                <td colspan="2"><hr /></td>
            </tr>
            <tr bgcolor="#C1C1C1">
                <td colspan="2" height="25"><p><strong>&nbsp;Hash Validation</strong></p></td>
            </tr>
            <tr>
                <td align="right"><strong><i>Hash Validated Correctly: </i></strong></td>
                <td><%=hashValidated%></td>
            </tr>
        </table>
        <center><p><a href='vpc_asp_serverhost.html'>New Transaction</a></p></center>
    </body>
</html>
<%    

' *******************
' END OF MAIN PROGRAM
' *******************
 
'  -----------------------------------------------------------------------------

Function doSecureHash()

    Dim md5HashData
    Dim index
    
    ' sort the array only if we are creating the MD5 hash
    MyArray = sortArray(MyArray)

    ' start the MD5 input
    md5HashData = SECURE_SECRET
    
    ' loop though the array and add each parameter value to the MD5 input
    index = 0
    count = 0
    For index = 0 to UBound(MyArray)
        If (Len(MyArray(index,1)) > 0) Then
            md5HashData = md5HashData & URLDecode(MyArray(index,1))
            count = count + 1
        End If
    Next
    ' increment the count to the next array location
    count = count + 1
    
    doSecureHash = UCase(MD5(md5HashData))

End Function

'  -----------------------------------------------------------------------------

' This function takes an array and sorts it
'
' @param MyArray is the array to be sorted
Function SortArray(MyArray)

    Dim keepChecking
    Dim loopCounter
    Dim firstKey
    Dim secondKey
    Dim firstValue
    Dim secondValue
    
    keepChecking = TRUE
    loopCounter = 0
    
    Do Until keepChecking = FALSE
        keepChecking = FALSE
        For loopCounter = 0 To (UBound(MyArray)-1)
            If MyArray(loopCounter,0) > MyArray((loopCounter+1),0) Then
                ' transpose the key
                firstKey = MyArray(loopCounter,0)
                secondKey = MyArray((loopCounter+1),0)
                MyArray(loopCounter,0) = secondKey
                MyArray((loopCounter+1),0) = firstKey
                ' transpose the key's value
                firstValue = MyArray(loopCounter,1)
                secondValue = MyArray((loopCounter+1),1)
                MyArray(loopCounter,1) = secondValue
                MyArray((loopCounter+1),1) = firstValue
                keepChecking = TRUE
            End If
        Next
    Loop
    SortArray = MyArray
End Function

'  -----------------------------------------------------------------------------
     
' This function takes a String and add a value if empty
'
' @param inputData is the String to be tested
' @return String If input is empty returns string - "No Value Returned", Else returns inputData
Function null2unknown(inputData) 
    
    If inputData = "" Then
        null2unknown = "No Value Returned"
    Else
        null2unknown = inputData
    End If

End Function

'  -----------------------------------------------------------------------------

' This function uses the URL Encoded value retrieved from the Digital
' Receipt and returns a decoded string
'
' @param input containing the URLEncoded input value
'
' @return a string of the decoded input
'
Function URLDecode(encodedTxt)

    Dim output
    Dim percentSplit

    If encodedTxt = "" Then
        URLDecode = ""
        Exit Function
    End If

    ' First convert the + to a space
    output = Replace(encodedTxt, "+", " ")

    ' Then convert the %hh to normal code
    percentSplit = Split(output, "%")

    If IsArray(percentSplit) Then
        output = percentSplit(0)
        Dim i
        Dim part
        Dim strHex
        Dim Letter
        For i = Lbound(percentSplit) To UBound(percentSplit) - 1
            part = percentSplit(i + 1)
            strHex = "&H" & Left(part, 2)
            Letter = Chr(strHex)
            output = output & Letter & Right(part, Len(part) -2)
        Next
    End If

    URLDecode = output

End Function

'  -----------------------------------------------------------------------------

' This function uses the Transaction Response code retrieved from the Digital
' Receipt and returns an appropriate description for the QSI Response Code
'
' @param vResponseCode containing the QSI Response Code
'
' @return description containing the appropriate description
'
Function getResponseDescription(responseCode)

    Select Case responseCode
        Case "0"  
            getResponseDescription = "Giao dich thanh cong"
        Case "1"   
            getResponseDescription = "Ngan hang tu choi thanh toan: the/tai khoan bi khoa"
        Case "2"   
            getResponseDescription = "Loi so 2"
        Case "3"   
            getResponseDescription = "The het han"
        Case "4"   
            getResponseDescription = "Qua so lan giao dich cho phep. (Sai OTP, qua han muc trong ngay)"
        Case "5"   
            getResponseDescription = "Khong co tra loi tu Ngan hang"
        Case "6"   
            getResponseDescription = "Loi giao tiep voi Ngan hang"
        Case "7"   
            getResponseDescription = "Tai khoan khong du tien"
        Case "8"   
            getResponseDescription = "Loi du lieu truyen"
        Case "9"   
            getResponseDescription = "Kieu giao dich khong duoc ho tro"
        Case Else  
            getResponseDescription = "Loi khong xac dinh"
    End Select
End Function



%>