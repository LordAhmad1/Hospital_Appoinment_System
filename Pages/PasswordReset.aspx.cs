using System;
using System.Web.UI;

namespace HospitalAppointmentSystem
{
    public partial class PasswordReset : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Ensure proper UTF-8 encoding
            Response.ContentEncoding = System.Text.Encoding.UTF8;
            Response.Charset = "UTF-8";
        }
    }
}
