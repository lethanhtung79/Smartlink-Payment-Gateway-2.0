using System;
using System.Collections;
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
using vn.com.sml.ecom;


public partial class Vpc_Dr : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        String responseCode = Request.QueryString["vpc_ResponseCode"];
        if (responseCode != null && responseCode.Length > 0)
        {
            Hashtable hash = new Hashtable();
            foreach (String key in Request.QueryString.AllKeys)
            {
                if (key.StartsWith("vpc_"))
                {
                    hash.Add(key, Request.QueryString[key]);
                }
            }

            Payment payment = new Payment();
            payment.SecureSecret = "198BE3F2E8C75A53F38C1C4A5B6DBA27";
            payment.checkSum(hash);
            if (payment.isEmptysecureSecret())
            {
                vpc_SecureHash.Text = "<font color='orange'><strong>NO SECURE SECRET</strong></font>";
            }
            else
            {
                if (payment.isValidsecureHash())
                {
                    vpc_SecureHash.Text = "<font color='blue'><strong>CORRECT</strong></font>";
                }
                else
                {
                    vpc_SecureHash.Text = "<font color='red'><strong>INVALID</strong></font>";
                }
            }
        }
        else
        {
            vpc_SecureHash.Text = "<font color='red'><strong>ERROR</strong></font>";
        }
        
    }
}
