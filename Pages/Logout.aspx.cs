using System;
using System.Web.Security;

namespace HospitalAppointmentSystem
{
    public partial class Logout : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Sign out the user
            FormsAuthentication.SignOut();
            
            // Clear session
            Session.Clear();
            Session.Abandon();
            
            // Redirect to login page after a short delay
            Response.AddHeader("Refresh", "2;url=Login.aspx");
        }
    }
}
