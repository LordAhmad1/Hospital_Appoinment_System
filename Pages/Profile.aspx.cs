using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.Security;
using System.IO;

namespace HospitalAppointmentSystem
{
    public partial class UserProfile : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Ensure proper UTF-8 encoding
            Response.ContentEncoding = System.Text.Encoding.UTF8;
            Response.Charset = "UTF-8";
            if (!IsPostBack)
            {
                if (User.Identity.IsAuthenticated)
                {
                    LoadUserProfile();
                    LoadUserStatistics();
                }
                else
                {
                    Response.Redirect("/pages/Login.aspx");
                }
            }
        }

        private void LoadUserProfile()
        {
            string email = User.Identity.Name;
            string connectionString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT FirstName, LastName, Phone, DateOfBirth, NationalID FROM Patients WHERE Email = @Email";
                
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@Email", email);
                    
                    try
                    {
                        conn.Open();
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                txtFirstName.Text = reader["FirstName"].ToString();
                                txtLastName.Text = reader["LastName"].ToString();
                                txtPhone.Text = reader["Phone"].ToString();
                                
                                if (reader["DateOfBirth"] != DBNull.Value)
                                {
                                    DateTime birthDate = Convert.ToDateTime(reader["DateOfBirth"]);
                                    txtDateOfBirth.Text = birthDate.ToString("yyyy-MM-dd");
                                }
                                
                                txtNationalID.Text = reader["NationalID"] != DBNull.Value ? reader["NationalID"].ToString() : "";
                                
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        lblMessage.Text = "Error loading profile: " + ex.Message;
                        lblMessage.CssClass = "text-danger mt-2 d-block";
                    }
                }
            }
        }

        private void LoadUserStatistics()
        {
            string email = User.Identity.Name;
            string connectionString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                try
                {
                    conn.Open();

                    // Load total appointments
                    string appointmentsQuery = "SELECT COUNT(*) FROM Appointments WHERE PatientEmail = @Email";
                    using (SqlCommand cmd = new SqlCommand(appointmentsQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@Email", email);
                        object result = cmd.ExecuteScalar();
                        int totalAppointments = (result != null && result != DBNull.Value) ? Convert.ToInt32(result) : 0;
                        lblTotalAppointments.Text = totalAppointments.ToString();
                    }

                    // Load completed appointments
                    string completedQuery = "SELECT COUNT(*) FROM Appointments WHERE PatientEmail = @Email AND Status = 'Completed'";
                    using (SqlCommand cmd = new SqlCommand(completedQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@Email", email);
                        object result = cmd.ExecuteScalar();
                        int completedAppointments = (result != null && result != DBNull.Value) ? Convert.ToInt32(result) : 0;
                        lblCompletedAppointments.Text = completedAppointments.ToString();
                    }

                    // Load blood tests
                    string bloodTestsQuery = "SELECT COUNT(*) FROM BloodTests WHERE PatientEmail = @Email";
                    using (SqlCommand cmd = new SqlCommand(bloodTestsQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@Email", email);
                        object result = cmd.ExecuteScalar();
                        int bloodTests = (result != null && result != DBNull.Value) ? Convert.ToInt32(result) : 0;
                        lblBloodTests.Text = bloodTests.ToString();
                    }

                    // Load member since year
                    string memberSinceQuery = "SELECT YEAR(CreatedDate) FROM Patients WHERE Email = @Email";
                    using (SqlCommand cmd = new SqlCommand(memberSinceQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@Email", email);
                        object result = cmd.ExecuteScalar();
                        if (result != null)
                        {
                            lblMemberSince.Text = result.ToString();
                        }
                        else
                        {
                            lblMemberSince.Text = "2024";
                        }
                    }
                }
                catch (Exception ex)
                {
                    // Handle error silently for statistics
                    lblTotalAppointments.Text = "0";
                    lblCompletedAppointments.Text = "0";
                    lblBloodTests.Text = "0";
                    lblMemberSince.Text = "2024";
                }
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            
            try
            {
                // Check if user is authenticated
                if (!User.Identity.IsAuthenticated)
                {
                    lblMessage.Text = "User is not authenticated. Please log in again.";
                    lblMessage.CssClass = "text-danger mt-2 d-block";
                    return;
                }

                string email = User.Identity.Name;
                
                // Validate required fields
                if (string.IsNullOrEmpty(txtFirstName.Text.Trim()) || 
                    string.IsNullOrEmpty(txtLastName.Text.Trim()) ||
                    string.IsNullOrEmpty(txtPhone.Text.Trim()) ||
                    string.IsNullOrEmpty(txtNationalID.Text.Trim()))
                {
                    lblMessage.Text = "Please fill in all required fields.";
                    lblMessage.CssClass = "text-danger mt-2 d-block";
                    return;
                }

                string connectionString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"UPDATE Patients 
                                   SET FirstName = @FirstName, 
                                       LastName = @LastName, 
                                       Phone = @Phone, 
                                       DateOfBirth = @DateOfBirth, 
                                       NationalID = @NationalID 
                                   WHERE Email = @Email";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@FirstName", txtFirstName.Text.Trim());
                        cmd.Parameters.AddWithValue("@LastName", txtLastName.Text.Trim());
                        cmd.Parameters.AddWithValue("@Phone", txtPhone.Text.Trim());
                        cmd.Parameters.AddWithValue("@NationalID", txtNationalID.Text.Trim());
                        cmd.Parameters.AddWithValue("@Email", email);

                        if (!string.IsNullOrEmpty(txtDateOfBirth.Text))
                        {
                            cmd.Parameters.AddWithValue("@DateOfBirth", DateTime.Parse(txtDateOfBirth.Text));
                        }
                        else
                        {
                            cmd.Parameters.AddWithValue("@DateOfBirth", DBNull.Value);
                        }

                        try
                        {
                            conn.Open();
                            int rowsAffected = cmd.ExecuteNonQuery();

                                                         if (rowsAffected > 0)
                             {
                                 // Update sessionStorage with new user name and email, then show modal
                                 string script = string.Format(@"
                                     <script>
                                         sessionStorage.setItem('userName', '{0}');
                                         sessionStorage.setItem('userEmail', '{1}');
                                         // Show success modal using jQuery or vanilla JS
                                         var modal = document.getElementById('successModal');
                                         if (modal) {{
                                             var bsModal = new bootstrap.Modal(modal);
                                             bsModal.show();
                                         }} else {{
                                             alert('Profile Updated Successfully!');
                                         }}
                                     </script>", txtFirstName.Text.Trim(), email);
                                 System.Web.UI.ScriptManager.RegisterStartupScript(this, GetType(), "showSuccessModal", script, false);
                                 
                                 // Also update the label message
                                 lblMessage.Text = "Profile updated successfully!";
                                 lblMessage.CssClass = "text-success mt-2 d-block";
                             }
                            else
                            {
                                lblMessage.Text = "No changes were made to your profile. User email: " + email;
                                lblMessage.CssClass = "text-info mt-2 d-block";
                            }
                        }
                        catch (Exception ex)
                        {
                            lblMessage.Text = "Error updating profile: " + ex.Message;
                            lblMessage.CssClass = "text-danger mt-2 d-block";
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Unexpected error: " + ex.Message;
                lblMessage.CssClass = "text-danger mt-2 d-block";
            }
        }

        protected void btnChangePassword_Click(object sender, EventArgs e)
        {
            string email = User.Identity.Name;
            string currentPassword = txtCurrentPassword.Text;
            string newPassword = txtNewPassword.Text;
            string confirmPassword = txtConfirmNewPassword.Text;

            // Validate new password confirmation
            if (newPassword != confirmPassword)
            {
                lblMessage.Text = "New password and confirmation password do not match.";
                lblMessage.CssClass = "text-danger mt-2 d-block";
                return;
            }

            // Validate password strength
            if (newPassword.Length < 6)
            {
                lblMessage.Text = "Password must be at least 6 characters long.";
                lblMessage.CssClass = "text-danger mt-2 d-block";
                return;
            }

            string connectionString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                // First, verify current password
                string verifyQuery = "SELECT COUNT(*) FROM Patients WHERE Email = @Email AND Password = @Password";
                
                using (SqlCommand cmd = new SqlCommand(verifyQuery, conn))
                {
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@Password", currentPassword);

                    try
                    {
                        conn.Open();
                        object result = cmd.ExecuteScalar();
                        int count = (result != null && result != DBNull.Value) ? Convert.ToInt32(result) : 0;

                        if (count == 0)
                        {
                            lblMessage.Text = "Current password is incorrect.";
                            lblMessage.CssClass = "text-danger mt-2 d-block";
                            return;
                        }
                    }
                    catch (Exception ex)
                    {
                        lblMessage.Text = "Error verifying current password: " + ex.Message;
                        lblMessage.CssClass = "text-danger mt-2 d-block";
                        return;
                    }
                }

                // Update password
                string updateQuery = "UPDATE Patients SET Password = @NewPassword WHERE Email = @Email";
                
                using (SqlCommand cmd = new SqlCommand(updateQuery, conn))
                {
                    cmd.Parameters.AddWithValue("@NewPassword", newPassword);
                    cmd.Parameters.AddWithValue("@Email", email);

                    try
                    {
                        int rowsAffected = cmd.ExecuteNonQuery();

                        if (rowsAffected > 0)
                        {
                            lblMessage.Text = "Password changed successfully!";
                            lblMessage.CssClass = "text-success mt-2 d-block";
                            
                            // Get user's first name for email notification
                            string firstName = GetUserFirstName(email);
                            
                            // Send password change notification email with device information
                            SecurityEmailService.SendPasswordChangeNotification(email, Request, DateTime.Now, firstName);
                            
                            // Clear password fields
                            txtCurrentPassword.Text = "";
                            txtNewPassword.Text = "";
                            txtConfirmNewPassword.Text = "";
                            
                            // Close modal using JavaScript
                            System.Web.UI.ScriptManager.RegisterStartupScript(this, GetType(), "closeModal", 
                                "document.getElementById('changePasswordModal').classList.remove('show'); " +
                                "document.body.classList.remove('modal-open'); " +
                                "document.querySelector('.modal-backdrop').remove();", true);
                        }
                        else
                        {
                            lblMessage.Text = "Failed to update password.";
                            lblMessage.CssClass = "text-danger mt-2 d-block";
                        }
                    }
                    catch (Exception ex)
                    {
                        lblMessage.Text = "Error changing password: " + ex.Message;
                        lblMessage.CssClass = "text-danger mt-2 d-block";
                    }
                }
            }
        }

        private string GetUserFirstName(string email)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;
            
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                try
                {
                    conn.Open();
                    string query = "SELECT FirstName FROM Patients WHERE Email = @Email";
                    
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@Email", email);
                        object result = cmd.ExecuteScalar();
                        return (result != null && result != DBNull.Value) ? result.ToString() : "User";
                    }
                }
                catch (Exception)
                {
                    return "User";
                }
            }
        }



    }
}
