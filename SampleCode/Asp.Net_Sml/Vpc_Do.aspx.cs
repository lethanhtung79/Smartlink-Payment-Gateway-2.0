using System;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Security.Cryptography;
using vn.com.sml.ecom;
using System.IO;


public partial class _Default : System.Web.UI.Page 
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    protected void btnSumit_Click(object sender, EventArgs e)
    {
        Payment payment = new Payment();
        payment.SecureSecret = "198BE3F2E8C75A53F38C1C4A5B6DBA27";
        payment.VirtualPaymentClientUrl = "https://paymentcert.smartlink.com.vn:8181/vpcpay.do";
        /*
         * 1. Tao mot Hashtable co cac parameter nhu sau:
         * Hashtable hash = new Hashtable();
         * hash.Add("vpc_Version", "1.1");
         * hash.Add("vpc_Command", "pay");
         * hash.Add("vpc_AccessCode", "ECAFAB");
         * hash.Add("vpc_MerchTxnRef", "20120118100323");
         * ... (add vao cac parameter mong muon truyen di)
         * 2. Gui cac tham so toi smartlink:
         * Response.Redirect(payment.getRedirectUrl(hash));
         */

        //Trong vi du nay su dung du lieu tu form submit len:
        Hashtable hash = new Hashtable();
        foreach (String key in Request.Form.AllKeys)
        {
            if (key.StartsWith("vpc_"))
            {
                hash.Add(key, Request.Form[key]);
            }
        }
        Response.Redirect(payment.getRedirectUrl(hash));
    }
}
