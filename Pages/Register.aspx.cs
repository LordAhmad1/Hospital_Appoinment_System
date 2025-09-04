using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;
using System.Web.Script.Serialization;
using System.Collections.Generic;

namespace HospitalAppointmentSystem
{
    public partial class Register : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Response.ContentEncoding = System.Text.Encoding.UTF8;
            Response.Charset = "UTF-8";
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            try
            {
                // Clear any previous messages
                lblMessage.Visible = false;
                
                // Get form data
                string firstName = (Request.Form["txtFirstName"] ?? "").Trim();
                string lastName = (Request.Form["txtLastName"] ?? "").Trim();
                string email = (Request.Form["txtEmail"] ?? "").Trim();
                string phone = (Request.Form["txtPhone"] ?? "").Trim();
                string nationalID = (Request.Form["txtNationalID"] ?? "").Trim();
                string dateOfBirthStr = Request.Form["txtDateOfBirth"] ?? "";
                string password = Request.Form["txtPassword"] ?? "";
                string confirmPassword = Request.Form["txtConfirmPassword"] ?? "";
                string agreeTerms = Request.Form["chkAgree"] ?? "";

                // Validate form
                if (!ValidateForm(firstName, lastName, email, phone, nationalID, dateOfBirthStr, password, confirmPassword, agreeTerms))
                {
                    return;
                }

                // Check if email already exists
                if (EmailExists(email))
                {
                    ShowMessage("An account with this email already exists.", "danger");
                    return;
                }

                // Parse date of birth
                DateTime dateOfBirth;
                if (!DateTime.TryParse(dateOfBirthStr, out dateOfBirth))
                {
                    ShowMessage("Please enter a valid date of birth.", "danger");
                    return;
                }

                // Store registration data in session
                Session["RegistrationData"] = new
                {
                    FirstName = firstName,
                    LastName = lastName,
                    Email = email,
                    Phone = phone,
                    NationalID = nationalID,
                    DateOfBirth = dateOfBirth,
                    Password = password
                };

                // Send OTP code via NodeMailer
                bool otpSent = SendOTPCode(email, firstName + " " + lastName);
                
                if (otpSent)
                {
                    // Show success message and redirect
                    ShowMessage("OTP sent successfully! Redirecting to verification page...", "success");
                    // Add a small delay to show the message before redirecting
                    System.Threading.Thread.Sleep(1000);
                    Response.Redirect("OTPVerification.aspx?email=" + Server.UrlEncode(email) + "&username=" + Server.UrlEncode(firstName + " " + lastName));
                }
                else
                {
                    // If OTP sending failed, show error message
                    ShowMessage("Failed to send OTP code. Please try again.", "danger");
                }
            }
            catch (Exception ex)
            {
                // Show error message
                ShowMessage("Registration failed. Please try again.", "danger");
            }
        }

        private bool ValidateForm(string firstName, string lastName, string email, string phone, string nationalID, string dateOfBirth, string password, string confirmPassword, string agreeTerms)
        {
            if (string.IsNullOrEmpty(firstName))
            {
                ShowMessage("First name is required.", "danger");
                return false;
            }

            if (string.IsNullOrEmpty(lastName))
            {
                ShowMessage("Last name is required.", "danger");
                return false;
            }

            if (string.IsNullOrEmpty(email))
            {
                ShowMessage("Email address is required.", "danger");
                return false;
            }

            if (string.IsNullOrEmpty(phone))
            {
                ShowMessage("Phone number is required.", "danger");
                return false;
            }

            if (string.IsNullOrEmpty(nationalID))
            {
                ShowMessage("National ID is required.", "danger");
                return false;
            }

            if (string.IsNullOrEmpty(password))
            {
                ShowMessage("Password is required.", "danger");
                return false;
            }

            if (password != confirmPassword)
            {
                ShowMessage("Passwords do not match.", "danger");
                return false;
            }

            if (string.IsNullOrEmpty(agreeTerms))
            {
                ShowMessage("You must accept the terms and conditions.", "danger");
                return false;
            }

            return true;
        }

        private bool EmailExists(string email)
        {
            try
            {
                string connectionString = ConfigurationManager.ConnectionStrings["HospitalDB"].ConnectionString;
                
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    string query = "SELECT COUNT(*) FROM Patients WHERE Email = @Email";
                    
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@Email", email);
                        int count = (int)cmd.ExecuteScalar();
                        return count > 0;
                    }
                }
            }
            catch (Exception)
            {
                return false; // Assume email doesn't exist if there's an error
            }
        }

        private bool SendOTPCode(string email, string username)
        {
            try
            {
                // Create HTTP client to call Node.js API with NodeMailer
                using (var client = new System.Net.WebClient())
                {
                    client.Headers[System.Net.HttpRequestHeader.ContentType] = "application/json";
                    
                    // Prepare the request data for NodeMailer
                    var requestData = new Dictionary<string, string>
                    {
                        { "email", email },
                        { "username", username }
                    };
                    
                    // Convert to JSON using built-in serializer
                    var serializer = new JavaScriptSerializer();
                    string jsonData = serializer.Serialize(requestData);
                    
                    // Send POST request to Node.js API with NodeMailer
                    string response = client.UploadString("http://localhost:3000/api/send-otp", jsonData);
                    
                    // Parse the response
                    var result = serializer.Deserialize<Dictionary<string, object>>(response);
                    
                    return result.ContainsKey("success") && (bool)result["success"];
                }
            }
            catch (Exception)
            {
                return false;
            }
        }

        private void ShowMessage(string message, string type)
        {
            lblMessage.Text = message;
            lblMessage.CssClass = "alert alert-" + type;
            lblMessage.Visible = true;
        }
    }
}
