<%@ Page Language="C#" AutoEventWireup="true"  CodeFile="Vpc_Do.aspx.cs" Inherits="_Default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title>ASP.NET MERCHANT SAMPLE</title>
</head>
<body>
<center><h1>ASP.NET Merchant Example - Request Details</H1></center>
    <div align="center">
    <form id="form1" runat="server">
    <table width="800px" cellpadding="0" cellspacing="0">
        <tr align="left">
            <td>
            <asp:Label ID="Label2" runat="server" Text="VPC Version"></asp:Label>
            </td>
            <td>
            <asp:TextBox ID="vpc_Version" runat="server" Text="2.0"></asp:TextBox>
            </td>
        </tr>
        <tr align="left">
            <td>
            <asp:Label ID="Label3" runat="server" Text="Command Type"></asp:Label>
            </td>
            <td>
            <asp:TextBox ID="vpc_Command" runat="server" Text="pay"></asp:TextBox>
            </td>
        </tr>
        <tr align="left">
            <td>
            <asp:Label ID="Label4" runat="server" Text="Merchant AccessCode"></asp:Label>
            </td>
            <td>
            <asp:TextBox ID="vpc_AccessCode" runat="server" Text="ECAFAB"></asp:TextBox>
            </td>
        </tr>
        <tr align="left">
            <td>
            <asp:Label ID="Label5" runat="server" Text="Merchant Transaction Reference"></asp:Label>
            </td>
            <td>
            <asp:TextBox ID="vpc_MerchTxnRef" runat="server" Text="20120118100323"></asp:TextBox>
            </td>
        </tr>
        <tr align="left">
            <td>
            <asp:Label ID="Label6" runat="server" Text="MerchantID"></asp:Label>
            </td>
            <td>
            <asp:TextBox ID="vpc_Merchant" runat="server" Text="SMLTEST"></asp:TextBox>
            </td>
        </tr>
        <tr align="left">
            <td>
            <asp:Label ID="Label7" runat="server" Text="Transaction OrderInfo"></asp:Label>
            </td>
            <td>
            <asp:TextBox ID="vpc_OrderInfo" runat="server" Text="Shop test"></asp:TextBox>
            </td>
        </tr>
        <tr align="left">
            <td>
            <asp:Label ID="Label8" runat="server" Text="Purchase Amount"></asp:Label>
            </td>
            <td>
            <asp:TextBox ID="vpc_Amount" runat="server" Text="1000000"></asp:TextBox>
            </td>
        </tr>
        <tr align="left">
            <td>
            <asp:Label ID="Label11" runat="server" Text="Currency"></asp:Label>
            </td>
            <td>
            <asp:TextBox ID="vpc_Currency" runat="server" Text="VND"></asp:TextBox>
            </td>
        </tr>
        <tr align="left">
            <td>
            <asp:Label ID="Label9" runat="server" Text="Payment Server Display Language Locale"></asp:Label>
            </td>
            <td>
            <asp:TextBox ID="vpc_Locale" runat="server" Text="vn"></asp:TextBox>
            </td>
        </tr>
        <tr align="left">
            <td>
            <asp:Label ID="Label10" runat="server" Text="Receipt ReturnURL"></asp:Label>
            </td>
            <td>
            <asp:TextBox ID="vpc_ReturnURL" runat="server" Width="350px" Text="http://localhost/Asp.Net_Sml/Vpc_Dr.aspx"></asp:TextBox>
            </td>
        </tr>
        <tr align="left">
            <td>
            <asp:Label ID="Label1" runat="server" Text="Receipt BackURL"></asp:Label>
            </td>
            <td>
            <asp:TextBox ID="vpc_BackURL" runat="server" Width="350px" Text=""></asp:TextBox>
            </td>
        </tr>
        <tr align="left">
            <td>
            <asp:Label ID="Label12" runat="server" Text="Ticket No."></asp:Label>
            </td>
            <td>
            <asp:TextBox ID="vpc_TicketNo" runat="server" Text="210.245.54.120"></asp:TextBox>
            </td>
        </tr>
    </table>
    <br />
    <div align="center">
        <asp:Button ID="btnSumit" runat="server" Text="Pay now" onclick="btnSumit_Click" />
    </div>
    </form>
    </div>
    <br />
    <br />
    <br />
    <br />
    <div align="center">
        SMARTLINK CARD., JSC
    </div>
</body>
</html>
