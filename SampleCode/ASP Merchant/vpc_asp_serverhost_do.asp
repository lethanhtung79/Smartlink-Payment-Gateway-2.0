<%@ LANGUAGE=vbscript %>
<%

Option Explicit

' Turn off default error checking, as any errors are explicitly handled
On Error Resume Next

' Include the MD5 code that will be used to create the secure hash if required
%>
<!--#include file="vpc_md5.asp"-->
<%
' *******************************************
' START OF MAIN PROGRAM
' *******************************************

' The Page redirects the cardholder to the Virtual Payment Client (VPC)

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

Dim message
Dim count
Dim item
Dim seperator
Dim redirectURL

' Create a 2 dimensional Array that we will use if we need a Secure Hash
If Len(SECURE_SECRET) > 0 Then
    Dim MyArray
    ReDim MyArray(Request.Form.Count,1)
End If

' Create the URL that will send the data to the Virtual Payment Client
redirectURL = Request("virtualPaymentClientURL")

' Add each of the appropriate form variables to the data.
seperator = "?"
count = 1
For Each item In Request.Form

    ' Do not include the Virtual Payment Client URL, the Submit button 
    ' from the form post, or any empty form fields, as we do not want to send 
    ' these fields to the Virtual Payment Client. 
    ' Also construct the VPC URL QueryString while looping through the Form data.
    If Request(item) <> "" And item <> "SubButL" And item <> "virtualPaymentClientURL" Then

        ' Add the item to the array if we need a Secure Hash
        If Len(SECURE_SECRET) > 0 Then
            MyArray (count,0) = CStr(item)
            MyArray (count,1) = CStr(Request(item))
        End If
        ' Add the data to the VPC URL QueryString
        redirectURL = redirectURL & seperator & Server.URLEncode(CStr(item)) & "=" & Server.URLEncode(CStr(Request(item)))
        seperator = "&"

        ' Increment the count to the next array location
        count = count + 1

    End If
Next

' If there is no Secure Secret then there is no need to create the Secure Hash
If Len(SECURE_SECRET) > 0 Then

    ' Create MD5 Message-Digest Algorithm hash and add it to the data to be sent
    redirectURL = redirectURL & seperator & "vpc_SecureHash=" & doSecureHash

    If Err Then
        message = "Error creating Secure Hash: " & Err.Source & " - " & Err.number & " - " & Err.Description
        Response.Redirect Request("vpc_ReturnURL") & "?vpc_Message=" & message
        Response.End
    End If

End If

' FINISH TRANSACTION - Send the cardholder to the VPC
' ===================================================
' For the purposes of demonstration, we perform a standard URL redirect. 
Response.Redirect redirectURL
Response.End

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
            md5HashData = md5HashData & MyArray(index,1)
            count = count + 1
        End If
    Next
    ' increment the count to the next array location
    count = count + 1
    
    doSecureHash = MD5(md5HashData)

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
%>