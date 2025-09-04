using System;
using System.Configuration;
using System.Data.SqlClient;

namespace HospitalAppointmentSystem
{
    public partial class SiteMaster : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Ensure proper UTF-8 encoding
            Response.ContentEncoding = System.Text.Encoding.UTF8;
            Response.Charset = "UTF-8";
            
            if (!IsPostBack)
            {
                // Set page title if not already set
                if (string.IsNullOrEmpty(Page.Title))
                {
                    Page.Title = "Hastane Randevu Sistemi";
                }
            }
        }

        protected string GetUserDisplayName()
        {
            // For now, return a default value and let JavaScript handle the user name
            // This avoids authentication context issues in the code-behind
            return "User";
        }
    }
}
