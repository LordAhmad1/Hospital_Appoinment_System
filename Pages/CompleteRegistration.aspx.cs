using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Security.Cryptography;
using System.Text;

namespace HospitalAppointmentSystem
{
    public partial class CompleteRegistration : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Ensure proper UTF-8 encoding
            Response.ContentEncoding = System.Text.Encoding.UTF8;
            Response.Charset = "UTF-8";
            
            // Automatically complete user registration when page loads
            if (!IsPostBack)
            {
                CompleteUserRegistration();
            }
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static object CompleteUserRegistration()
        {
            try
            {
                // Get registration data from session
                var registrationData = HttpContext.Current.Session["RegistrationData"];
                
                if (registrationData == null)
                {
                    return new { success = false, message = "Registration data not found. Please try registering again." };
                }

                // Use reflection to get the anonymous object properties
                var dataType = registrationData.GetType();
                var firstName = dataType.GetProperty("FirstName").GetValue(registrationData, null).ToString();
                var lastName = dataType.GetProperty("LastName").GetValue(registrationData, null).ToString();
                var email = dataType.GetProperty("Email").GetValue(registrationData, null).ToString();
                var phone = dataType.GetProperty("Phone").GetValue(registrationData, null).ToString();
                var nationalID = dataType.GetProperty("NationalID").GetValue(registrationData, null).ToString();
                var dateOfBirth = (DateTime)dataType.GetProperty("DateOfBirth").GetValue(registrationData, null);
                var password = dataType.GetProperty("Password").GetValue(registrationData, null).ToString();

                // Insert user into database
                bool success = InsertUserIntoDatabase(firstName, lastName, email, phone, nationalID, dateOfBirth, password);

                if (success)
                {
                    // Clear session data
                    HttpContext.Current.Session.Remove("RegistrationData");

                    return new { success = true, message = "Registration completed successfully" };
                }
                else
                {

                    return new { success = false, message = "Failed to create account. Please try again." };
                }
            }
            catch (Exception ex)
            {
                return new { success = false, message = "An error occurred: " + ex.Message };
            }
        }

        private static bool InsertUserIntoDatabase(string firstName, string lastName, string email, string phone, string nationalID, DateTime dateOfBirth, string password)
        {
            try
            {
                // Hash the password
                string hashedPassword = HashPassword(password);

                // Get connection string from Web.config
                string connectionString = ConfigurationManager.ConnectionStrings["HospitalDB"].ConnectionString;

                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();

                    // Check if email already exists
                    string checkEmailQuery = "SELECT COUNT(*) FROM Patients WHERE Email = @Email";
                    using (SqlCommand checkCommand = new SqlCommand(checkEmailQuery, connection))
                    {
                        checkCommand.Parameters.AddWithValue("@Email", email);
                        int existingCount = (int)checkCommand.ExecuteScalar();
                        
                        if (existingCount > 0)
                        {
                            return false; // Email already exists
                        }
                    }

                    // Insert new user
                    string insertQuery = @"
                        INSERT INTO Patients (FirstName, LastName, Email, Phone, NationalID, DateOfBirth, Password, CreatedDate) 
                        VALUES (@FirstName, @LastName, @Email, @Phone, @NationalID, @DateOfBirth, @Password, @CreatedDate)";

                    using (SqlCommand command = new SqlCommand(insertQuery, connection))
                    {
                        command.Parameters.AddWithValue("@FirstName", firstName);
                        command.Parameters.AddWithValue("@LastName", lastName);
                        command.Parameters.AddWithValue("@Email", email);
                        command.Parameters.AddWithValue("@Phone", phone);
                        command.Parameters.AddWithValue("@NationalID", nationalID);
                        command.Parameters.AddWithValue("@DateOfBirth", dateOfBirth);
                        command.Parameters.AddWithValue("@Password", hashedPassword);
                        command.Parameters.AddWithValue("@CreatedDate", DateTime.Now);

                        int rowsAffected = command.ExecuteNonQuery();

                        return rowsAffected > 0;
                    }
                }
            }
            catch (Exception ex)
            {
                // Log the error (you might want to add proper logging here)
                return false;
            }
        }

        private static string HashPassword(string password)
        {
            using (SHA256 sha256 = SHA256.Create())
            {
                byte[] bytes = Encoding.UTF8.GetBytes(password);
                byte[] hash = sha256.ComputeHash(bytes);
                return Convert.ToBase64String(hash);
            }
        }
    }
}
