using System;
using System.Data.SqlClient;
using System.Configuration;

namespace HospitalAppointmentSystem
{
    public partial class test_profile : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                lblTestMessage.Text = "Page loaded successfully. User: " + (User.Identity.IsAuthenticated ? User.Identity.Name : "Not authenticated");
            }
        }

        protected void btnTestSave_Click(object sender, EventArgs e)
        {
            try
            {
                lblTestMessage.Text = "Button clicked! User: " + (User.Identity.IsAuthenticated ? User.Identity.Name : "Not authenticated");
                
                if (!User.Identity.IsAuthenticated)
                {
                    lblTestMessage.Text += " - User not authenticated!";
                    return;
                }

                string email = User.Identity.Name;
                string connectionString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = "UPDATE Patients SET FirstName = @FirstName, LastName = @LastName WHERE Email = @Email";
                    
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@FirstName", txtTestFirstName.Text.Trim());
                        cmd.Parameters.AddWithValue("@LastName", txtTestLastName.Text.Trim());
                        cmd.Parameters.AddWithValue("@Email", email);

                        conn.Open();
                        int rowsAffected = cmd.ExecuteNonQuery();
                        
                        lblTestMessage.Text += string.Format(" - Database update: {0} rows affected", rowsAffected);
                    }
                }
            }
            catch (Exception ex)
            {
                lblTestMessage.Text = "Error: " + ex.Message;
            }
        }
    }
}
