using System;

namespace HospitalAppointmentSystem
{
    public partial class Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Redirect to login page
                Response.Redirect("/pages/Login.aspx");
            }
        }
    }
}
