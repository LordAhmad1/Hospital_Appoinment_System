using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.Security;

namespace HospitalAppointmentSystem
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Ensure proper UTF-8 encoding
            Response.ContentEncoding = System.Text.Encoding.UTF8;
            Response.Charset = "UTF-8";
            if (!IsPostBack)
            {
                // Check if user is already authenticated
                if (User.Identity.IsAuthenticated)
                {
                    Response.Redirect("/Pages/Dashboard.aspx");
                }
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            // Get form data from Request.Form since we're using HTML inputs
            string email = (Request.Form["txtEmail"] ?? "").Trim();
            string password = Request.Form["txtPassword"] ?? "";
            string rememberMe = Request.Form["chkRememberMe"] ?? "";

            // Validate input
            if (string.IsNullOrEmpty(email) || string.IsNullOrEmpty(password))
            {
                ShowMessage("Please enter both email and password.", "error");
                return;
            }

            // Validate email format
            if (!IsValidEmail(email))
            {
                ShowMessage("Please enter a valid email address.", "error");
                return;
            }

            // Show loading state
            btnLogin.Text = "Signing In...";
            btnLogin.CssClass = "btn btn-primary btn-login btn-loading";
            btnLogin.Enabled = false;

            try
            {
                string errorMessage;
                if (ValidateUser(email, password, out errorMessage))
                {
                    // Create authentication ticket
                    FormsAuthentication.SetAuthCookie(email, !string.IsNullOrEmpty(rememberMe));
                    
                    // Get user's first name for display
                    string firstName = GetUserFirstName(email);
                    
                    // Send login notification email with device information
                    SecurityEmailService.SendLoginNotification(email, Request, DateTime.Now, firstName);
                    
                    // Show success message briefly before redirect
                    ShowMessage("Login successful! Redirecting to dashboard...", "success");
                    
                    // Add script to set user name and email in sessionStorage and redirect
                    string script = string.Format(@"
                        <script>
                            sessionStorage.setItem('userName', '{0}');
                            sessionStorage.setItem('userEmail', '{1}');
                            setTimeout(function() {{
                                window.location.href = '/Pages/Dashboard.aspx';
                            }}, 1500);
                        </script>", firstName, email);
                    Response.Write(script);
                }
                else
                {
                    ShowMessage(errorMessage, "error");
                }
            }
            catch (Exception ex)
            {
                ShowMessage("An error occurred during login. Please try again later.", "error");
                // Log the exception for debugging
            }
            finally
            {
                // Reset button state
                btnLogin.Text = "Sign In";
                btnLogin.CssClass = "btn btn-primary btn-login";
                btnLogin.Enabled = true;
            }
        }

        private string GetUserFirstName(string email)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["HospitalDB"].ConnectionString;
            
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

        private bool ValidateUser(string email, string password, out string errorMessage)
        {
            errorMessage = "";
            string connectionString = ConfigurationManager.ConnectionStrings["HospitalDB"].ConnectionString;
            
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                try
                {
                    conn.Open();
                    
                    // First, check if the user exists
                    string checkUserQuery = "SELECT COUNT(*) FROM Patients WHERE Email = @Email";
                    using (SqlCommand checkCmd = new SqlCommand(checkUserQuery, conn))
                    {
                        checkCmd.Parameters.AddWithValue("@Email", email);
                        int userCount = (int)checkCmd.ExecuteScalar();
                        
                        if (userCount == 0)
                        {
                            errorMessage = "User not found. Please check your email address or create a new account.";
                            return false;
                        }
                    }
                    
                    // Then check password
                    string query = "SELECT COUNT(*) FROM Patients WHERE Email = @Email AND Password = @Password";
                    
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@Email", email);
                        cmd.Parameters.AddWithValue("@Password", HashPassword(password)); // Hash the password for comparison
                        
                        int count = (int)cmd.ExecuteScalar();
                        if (count == 0)
                        {
                            errorMessage = "Invalid password. Please check your credentials and try again.";
                        }
                        return count > 0;
                    }
                }
                catch (Exception ex)
                {
                    // Log the exception
                    errorMessage = "Database connection error. Please try again later.";
                    return false;
                }
            }
        }

        private void ShowMessage(string message, string messageType)
        {
            // Since we're using HTML inputs and client-side JavaScript for messages,
            // we'll use JavaScript to display the message
            string escapedMessage = message.Replace("'", "\\'").Replace("\"", "\\\"");
            string script = string.Format(@"
                <script>
                    if (typeof showMessage === 'function') {{
                        showMessage('{0}', '{1}');
                    }}
                </script>", escapedMessage, messageType.ToLower());
            Response.Write(script);
        }

        private void ClearMessages()
        {
            // Messages are now handled client-side, so this method is not needed
            // but keeping it for compatibility
        }

        private bool IsValidEmail(string email)
        {
            try
            {
                var addr = new System.Net.Mail.MailAddress(email);
                return addr.Address == email;
            }
            catch
            {
                return false;
            }
        }

        private string HashPassword(string password)
        {
            using (System.Security.Cryptography.SHA256 sha256 = System.Security.Cryptography.SHA256.Create())
            {
                byte[] bytes = System.Text.Encoding.UTF8.GetBytes(password);
                byte[] hash = sha256.ComputeHash(bytes);
                return Convert.ToBase64String(hash);
            }
        }


    }
}
