using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;

namespace HospitalAppointmentSystem
{
    public partial class ResetPassword : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Check if token is provided
                string token = Request.QueryString["token"];
                if (string.IsNullOrEmpty(token))
                {
                    ShowError("Invalid reset link. Please request a new password reset.");
                    return;
                }

                // For now, we'll use a simple approach
                // In a real application, you'd validate the token against a database
                ViewState["Token"] = token;
            }
        }

        protected void btnResetPassword_Click(object sender, EventArgs e)
        {
            try
            {
                string newPassword = txtNewPassword.Text.Trim();
                string confirmPassword = txtConfirmPassword.Text.Trim();
                string token = ViewState["Token"] != null ? ViewState["Token"].ToString() : null;

                // Validate input
                if (string.IsNullOrEmpty(newPassword))
                {
                    ShowError("Please enter a new password.");
                    return;
                }

                if (newPassword != confirmPassword)
                {
                    ShowError("Passwords do not match.");
                    return;
                }

                if (newPassword.Length < 6)
                {
                    ShowError("Password must be at least 6 characters long.");
                    return;
                }

                // Get email from the form
                string email = txtEmail.Text.Trim();
                
                // Validate email
                if (string.IsNullOrEmpty(email))
                {
                    ShowError("Please enter your email address.");
                    return;
                }

                // Update password in database
                if (UpdatePassword(email, newPassword))
                {
                    ShowSuccess("Password reset successfully! You can now login with your new password.");
                    
                    // Send password reset success notification
                    SendPasswordResetNotification(email);
                    
                    // Clear the form
                    txtNewPassword.Text = "";
                    txtConfirmPassword.Text = "";
                }
                else
                {
                    ShowError("Failed to reset password. The email '" + email + "' was not found in the database. Please check your email address and try again.");
                }
            }
            catch (Exception ex)
            {
                ShowError("An error occurred while resetting your password. Please try again.");
            }
        }

        private bool UpdatePassword(string email, string newPassword)
        {
            try
            {
                string connectionString = ConfigurationManager.ConnectionStrings["HospitalDB"].ConnectionString;
                
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    
                    // Hash the password (use proper hashing in production)
                    string hashedPassword = HashPassword(newPassword);
                    
                    // First, check if the email exists
                    string checkQuery = "SELECT COUNT(*) FROM Patients WHERE Email = @Email";
                    using (SqlCommand checkCmd = new SqlCommand(checkQuery, conn))
                    {
                        checkCmd.Parameters.AddWithValue("@Email", email);
                        int count = (int)checkCmd.ExecuteScalar();
                        
                        if (count == 0)
                        {
                            return false;
                        }
                    }
                    
                    string query = "UPDATE Patients SET Password = @Password WHERE Email = @Email";
                    
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@Password", hashedPassword);
                        cmd.Parameters.AddWithValue("@Email", email);
                        
                        int rowsAffected = cmd.ExecuteNonQuery();
                        return rowsAffected > 0;
                    }
                }
            }
            catch (Exception ex)
            {
                return false;
            }
        }

        private void SendPasswordResetNotification(string email)
        {
            try
            {
                using (var client = new System.Net.WebClient())
                {
                    client.Headers.Add("Content-Type", "application/json");
                    
                    // Get username from database for personalization
                    string username = GetUsernameByEmail(email);
                    
                    string jsonData = "{\"email\":\"" + email + "\",\"username\":\"" + username + "\"}";
                    client.UploadString("http://localhost:3000/api/send-password-reset-notification", "POST", jsonData);
                }
            }
            catch (Exception ex)
            {
                // Silent fail - password reset was successful
            }
        }

        private string GetUsernameByEmail(string email)
        {
            try
            {
                string connectionString = ConfigurationManager.ConnectionStrings["HospitalDB"].ConnectionString;
                
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    
                    string query = "SELECT FirstName, LastName FROM Patients WHERE Email = @Email";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@Email", email);
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                string firstName = reader["FirstName"]?.ToString() ?? "";
                                string lastName = reader["LastName"]?.ToString() ?? "";
                                return (firstName + " " + lastName).Trim();
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                // Silent fail
            }
            
            return "";
        }

        private string HashPassword(string password)
        {
            // Simple hash implementation
            // In production, use proper password hashing like BCrypt or PBKDF2
            using (var sha256 = System.Security.Cryptography.SHA256.Create())
            {
                var hashedBytes = sha256.ComputeHash(System.Text.Encoding.UTF8.GetBytes(password));
                return Convert.ToBase64String(hashedBytes);
            }
        }

        private void ShowError(string message)
        {
            lblMessage.Text = message;
            lblMessage.CssClass = "text-danger mt-2 d-block";
        }

        private void ShowSuccess(string message)
        {
            lblMessage.Text = message;
            lblMessage.CssClass = "text-success mt-2 d-block";
        }
    }
}
