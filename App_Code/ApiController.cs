using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.Script.Serialization;

namespace HospitalAppointmentSystem
{
    [WebService(Namespace = "http://hospitalappointmentsystem.com/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [ScriptService]
    public class ApiController : System.Web.Services.WebService
    {
        private readonly string connectionString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;
        private readonly JavaScriptSerializer serializer = new JavaScriptSerializer();

        #region Authentication API

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public string Login(string email, string password)
        {
            try
            {
                if (string.IsNullOrEmpty(email) || string.IsNullOrEmpty(password))
                {
                    return CreateErrorResponse("Email and password are required");
                }

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    string query = "SELECT FirstName, LastName, Email FROM Patients WHERE Email = @Email AND Password = @Password";
                    
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@Email", email);
                        cmd.Parameters.AddWithValue("@Password", password);
                        
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                string firstName = reader["FirstName"].ToString();
                                string lastName = reader["LastName"].ToString();
                                
                                // Generate JWT token
                                string token = JwtHelper.GenerateToken(email, firstName, lastName);
                                
                                var response = new
                                {
                                    success = true,
                                    message = "Login successful",
                                    token = token,
                                    user = new
                                    {
                                        email = email,
                                        firstName = firstName,
                                        lastName = lastName,
                                        fullName = firstName + " " + lastName
                                    }
                                };
                                
                                return serializer.Serialize(response);
                            }
                        }
                    }
                }
                
                return CreateErrorResponse("Invalid email or password");
            }
            catch (Exception ex)
            {
                return CreateErrorResponse(string.Format("Login error: {0}", ex.Message));
            }
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public string Register(string firstName, string lastName, string email, string password, string phone, string nationalId)
        {
            try
            {
                // Validate input
                if (string.IsNullOrEmpty(firstName) || string.IsNullOrEmpty(lastName) || 
                    string.IsNullOrEmpty(email) || string.IsNullOrEmpty(password))
                {
                    return CreateErrorResponse("All required fields must be filled");
                }

                if (password.Length < 6)
                {
                    return CreateErrorResponse("Password must be at least 6 characters long");
                }

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    
                    // Check if email already exists
                    string checkQuery = "SELECT COUNT(*) FROM Patients WHERE Email = @Email";
                    using (SqlCommand checkCmd = new SqlCommand(checkQuery, conn))
                    {
                        checkCmd.Parameters.AddWithValue("@Email", email);
                        int count = (int)checkCmd.ExecuteScalar();
                        
                        if (count > 0)
                        {
                            return CreateErrorResponse("Email already registered");
                        }
                    }
                    
                    // Insert new user
                    string insertQuery = @"INSERT INTO Patients (FirstName, LastName, Email, Password, Phone, NationalID, CreatedDate) 
                                         VALUES (@FirstName, @LastName, @Email, @Password, @Phone, @NationalID, @CreatedDate)";
                    
                    using (SqlCommand cmd = new SqlCommand(insertQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@FirstName", firstName);
                        cmd.Parameters.AddWithValue("@LastName", lastName);
                        cmd.Parameters.AddWithValue("@Email", email);
                        cmd.Parameters.AddWithValue("@Password", password);
                        cmd.Parameters.AddWithValue("@Phone", phone ?? "");
                        cmd.Parameters.AddWithValue("@NationalID", nationalId ?? "");
                        cmd.Parameters.AddWithValue("@CreatedDate", DateTime.Now);
                        
                        cmd.ExecuteNonQuery();
                    }
                }
                
                // Generate token for new user
                string token = JwtHelper.GenerateToken(email, firstName, lastName);
                
                var response = new
                {
                    success = true,
                    message = "Registration successful",
                    token = token,
                    user = new
                    {
                        email = email,
                        firstName = firstName,
                        lastName = lastName,
                                                                fullName = firstName + " " + lastName
                    }
                };
                
                return serializer.Serialize(response);
            }
            catch (Exception ex)
            {
                return CreateErrorResponse(string.Format("Registration error: {0}", ex.Message));
            }
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public string RefreshToken(string token)
        {
            try
            {
                var tokenResult = JwtHelper.ValidateToken(token);
                if (!tokenResult.IsValid)
                {
                    return CreateErrorResponse("Invalid token");
                }

                string email = tokenResult.Email;
                if (string.IsNullOrEmpty(email))
                {
                    return CreateErrorResponse("Invalid token claims");
                }

                string newToken = JwtHelper.RefreshToken(email);
                if (string.IsNullOrEmpty(newToken))
                {
                    return CreateErrorResponse("Failed to refresh token");
                }

                var response = new
                {
                    success = true,
                    message = "Token refreshed successfully",
                    token = newToken
                };
                
                return serializer.Serialize(response);
            }
            catch (Exception ex)
            {
                return CreateErrorResponse(string.Format("Token refresh error: {0}", ex.Message));
            }
        }

        #endregion

        #region Profile API

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public string GetProfile(string token)
        {
            try
            {
                var tokenResult = JwtHelper.ValidateToken(token);
                if (!tokenResult.IsValid)
                {
                    return CreateErrorResponse("Invalid token");
                }

                string email = tokenResult.Email;
                
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    string query = "SELECT FirstName, LastName, Email, Phone, DateOfBirth, NationalID FROM Patients WHERE Email = @Email";
                    
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@Email", email);
                        
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                var profile = new
                                {
                                    firstName = reader["FirstName"].ToString(),
                                    lastName = reader["LastName"].ToString(),
                                    email = reader["Email"].ToString(),
                                    phone = reader["Phone"].ToString(),
                                    dateOfBirth = reader["DateOfBirth"] != DBNull.Value ? 
                                        Convert.ToDateTime(reader["DateOfBirth"]).ToString("yyyy-MM-dd") : "",
                                    nationalId = reader["NationalID"].ToString()
                                };
                                
                                var response = new
                                {
                                    success = true,
                                    profile = profile
                                };
                                
                                return serializer.Serialize(response);
                            }
                        }
                    }
                }
                
                return CreateErrorResponse("Profile not found");
            }
            catch (Exception ex)
            {
                return CreateErrorResponse(string.Format("Get profile error: {0}", ex.Message));
            }
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public string UpdateProfile(string token, string firstName, string lastName, string phone, string nationalId, string dateOfBirth)
        {
            try
            {
                var tokenResult = JwtHelper.ValidateToken(token);
                if (!tokenResult.IsValid)
                {
                    return CreateErrorResponse("Invalid token");
                }

                string email = tokenResult.Email;
                
                // Validate input
                if (string.IsNullOrEmpty(firstName) || string.IsNullOrEmpty(lastName))
                {
                    return CreateErrorResponse("First name and last name are required");
                }

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    string query = @"UPDATE Patients 
                                   SET FirstName = @FirstName, 
                                       LastName = @LastName, 
                                       Phone = @Phone, 
                                       NationalID = @NationalID, 
                                       DateOfBirth = @DateOfBirth 
                                   WHERE Email = @Email";
                    
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@FirstName", firstName);
                        cmd.Parameters.AddWithValue("@LastName", lastName);
                        cmd.Parameters.AddWithValue("@Phone", phone ?? "");
                        cmd.Parameters.AddWithValue("@NationalID", nationalId ?? "");
                        cmd.Parameters.AddWithValue("@Email", email);
                        
                        if (!string.IsNullOrEmpty(dateOfBirth))
                        {
                            cmd.Parameters.AddWithValue("@DateOfBirth", DateTime.Parse(dateOfBirth));
                        }
                        else
                        {
                            cmd.Parameters.AddWithValue("@DateOfBirth", DBNull.Value);
                        }
                        
                        int rowsAffected = cmd.ExecuteNonQuery();
                        
                        if (rowsAffected > 0)
                        {
                            var response = new
                            {
                                success = true,
                                message = "Profile updated successfully"
                            };
                            
                            return serializer.Serialize(response);
                        }
                    }
                }
                
                return CreateErrorResponse("Failed to update profile");
            }
            catch (Exception ex)
            {
                return CreateErrorResponse(string.Format("Update profile error: {0}", ex.Message));
            }
        }

        #endregion

        #region Appointments API

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public string GetAppointments(string token)
        {
            try
            {
                var tokenResult = JwtHelper.ValidateToken(token);
                if (!tokenResult.IsValid)
                {
                    return CreateErrorResponse("Invalid token");
                }

                string email = tokenResult.Email;
                
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    string query = @"SELECT a.AppointmentID, a.AppointmentDate, a.AppointmentTime, a.Status, 
                                          h.HospitalName, d.DoctorName, d.Specialization
                                   FROM Appointments a
                                   INNER JOIN Hospitals h ON a.HospitalID = h.HospitalID
                                   INNER JOIN Doctors d ON a.DoctorID = d.DoctorID
                                   WHERE a.PatientEmail = @Email
                                   ORDER BY a.AppointmentDate DESC, a.AppointmentTime DESC";
                    
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@Email", email);
                        
                        var appointments = new List<object>();
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                appointments.Add(new
                                {
                                    appointmentId = reader["AppointmentID"],
                                    appointmentDate = Convert.ToDateTime(reader["AppointmentDate"]).ToString("yyyy-MM-dd"),
                                    appointmentTime = reader["AppointmentTime"].ToString(),
                                    status = reader["Status"].ToString(),
                                    hospitalName = reader["HospitalName"].ToString(),
                                    doctorName = reader["DoctorName"].ToString(),
                                    specialization = reader["Specialization"].ToString()
                                });
                            }
                        }
                        
                        var response = new
                        {
                            success = true,
                            appointments = appointments
                        };
                        
                        return serializer.Serialize(response);
                    }
                }
            }
            catch (Exception ex)
            {
                return CreateErrorResponse(string.Format("Get appointments error: {0}", ex.Message));
            }
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public string CreateAppointment(string token, int hospitalId, int doctorId, string appointmentDate, string appointmentTime)
        {
            try
            {
                var tokenResult = JwtHelper.ValidateToken(token);
                if (!tokenResult.IsValid)
                {
                    return CreateErrorResponse("Invalid token");
                }

                string email = tokenResult.Email;
                
                // Validate input
                if (hospitalId <= 0 || doctorId <= 0 || string.IsNullOrEmpty(appointmentDate) || string.IsNullOrEmpty(appointmentTime))
                {
                    return CreateErrorResponse("All appointment details are required");
                }

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    
                    // Check if appointment slot is available
                    string checkQuery = @"SELECT COUNT(*) FROM Appointments 
                                        WHERE HospitalID = @HospitalID AND DoctorID = @DoctorID 
                                        AND AppointmentDate = @AppointmentDate AND AppointmentTime = @AppointmentTime";
                    
                    using (SqlCommand checkCmd = new SqlCommand(checkQuery, conn))
                    {
                        checkCmd.Parameters.AddWithValue("@HospitalID", hospitalId);
                        checkCmd.Parameters.AddWithValue("@DoctorID", doctorId);
                        checkCmd.Parameters.AddWithValue("@AppointmentDate", DateTime.Parse(appointmentDate));
                        checkCmd.Parameters.AddWithValue("@AppointmentTime", appointmentTime);
                        
                        int count = (int)checkCmd.ExecuteScalar();
                        if (count > 0)
                        {
                            return CreateErrorResponse("This appointment slot is already booked");
                        }
                    }
                    
                    // Create appointment
                    string insertQuery = @"INSERT INTO Appointments (PatientEmail, HospitalID, DoctorID, AppointmentDate, AppointmentTime, Status, CreatedDate) 
                                         VALUES (@PatientEmail, @HospitalID, @DoctorID, @AppointmentDate, @AppointmentTime, 'Scheduled', @CreatedDate)";
                    
                    using (SqlCommand cmd = new SqlCommand(insertQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@PatientEmail", email);
                        cmd.Parameters.AddWithValue("@HospitalID", hospitalId);
                        cmd.Parameters.AddWithValue("@DoctorID", doctorId);
                        cmd.Parameters.AddWithValue("@AppointmentDate", DateTime.Parse(appointmentDate));
                        cmd.Parameters.AddWithValue("@AppointmentTime", appointmentTime);
                        cmd.Parameters.AddWithValue("@CreatedDate", DateTime.Now);
                        
                        cmd.ExecuteNonQuery();
                    }
                }
                
                var response = new
                {
                    success = true,
                    message = "Appointment created successfully"
                };
                
                return serializer.Serialize(response);
            }
            catch (Exception ex)
            {
                return CreateErrorResponse(string.Format("Create appointment error: {0}", ex.Message));
            }
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public string CancelAppointment(string token, int appointmentId)
        {
            try
            {
                var tokenResult = JwtHelper.ValidateToken(token);
                if (!tokenResult.IsValid)
                {
                    return CreateErrorResponse("Invalid token");
                }

                string email = tokenResult.Email;
                
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    string query = "UPDATE Appointments SET Status = 'Cancelled' WHERE AppointmentID = @AppointmentID AND PatientEmail = @PatientEmail";
                    
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@AppointmentID", appointmentId);
                        cmd.Parameters.AddWithValue("@PatientEmail", email);
                        
                        int rowsAffected = cmd.ExecuteNonQuery();
                        
                        if (rowsAffected > 0)
                        {
                            var response = new
                            {
                                success = true,
                                message = "Appointment cancelled successfully"
                            };
                            
                            return serializer.Serialize(response);
                        }
                    }
                }
                
                return CreateErrorResponse("Appointment not found or already cancelled");
            }
            catch (Exception ex)
            {
                return CreateErrorResponse(string.Format("Cancel appointment error: {0}", ex.Message));
            }
        }

        #endregion

        #region Hospitals and Doctors API

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public string GetHospitals()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    string query = "SELECT HospitalID, HospitalName, Address, Phone FROM Hospitals ORDER BY HospitalName";
                    
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        var hospitals = new List<object>();
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                hospitals.Add(new
                                {
                                    hospitalId = reader["HospitalID"],
                                    hospitalName = reader["HospitalName"].ToString(),
                                    address = reader["Address"].ToString(),
                                    phone = reader["Phone"].ToString()
                                });
                            }
                        }
                        
                        var response = new
                        {
                            success = true,
                            hospitals = hospitals
                        };
                        
                        return serializer.Serialize(response);
                    }
                }
            }
            catch (Exception ex)
            {
                return CreateErrorResponse(string.Format("Get hospitals error: {0}", ex.Message));
            }
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public string GetDoctors(int hospitalId = 0)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    string query = hospitalId > 0 
                        ? "SELECT DoctorID, DoctorName, Specialization, HospitalID FROM Doctors WHERE HospitalID = @HospitalID ORDER BY DoctorName"
                        : "SELECT DoctorID, DoctorName, Specialization, HospitalID FROM Doctors ORDER BY DoctorName";
                    
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        if (hospitalId > 0)
                        {
                            cmd.Parameters.AddWithValue("@HospitalID", hospitalId);
                        }
                        
                        var doctors = new List<object>();
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                doctors.Add(new
                                {
                                    doctorId = reader["DoctorID"],
                                    doctorName = reader["DoctorName"].ToString(),
                                    specialization = reader["Specialization"].ToString(),
                                    hospitalId = reader["HospitalID"]
                                });
                            }
                        }
                        
                        var response = new
                        {
                            success = true,
                            doctors = doctors
                        };
                        
                        return serializer.Serialize(response);
                    }
                }
            }
            catch (Exception ex)
            {
                return CreateErrorResponse(string.Format("Get doctors error: {0}", ex.Message));
            }
        }

        #endregion

        #region Statistics API

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public string GetUserStatistics(string token)
        {
            try
            {
                var tokenResult = JwtHelper.ValidateToken(token);
                if (!tokenResult.IsValid)
                {
                    return CreateErrorResponse("Invalid token");
                }

                string email = tokenResult.Email;
                
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    
                    var statistics = new Dictionary<string, int>();
                    
                    // Total appointments
                    string totalQuery = "SELECT COUNT(*) FROM Appointments WHERE PatientEmail = @Email";
                    using (SqlCommand cmd = new SqlCommand(totalQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@Email", email);
                        statistics["totalAppointments"] = (int)cmd.ExecuteScalar();
                    }
                    
                    // Completed appointments
                    string completedQuery = "SELECT COUNT(*) FROM Appointments WHERE PatientEmail = @Email AND Status = 'Completed'";
                    using (SqlCommand cmd = new SqlCommand(completedQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@Email", email);
                        statistics["completedAppointments"] = (int)cmd.ExecuteScalar();
                    }
                    
                    // Blood tests
                    string bloodTestsQuery = "SELECT COUNT(*) FROM BloodTests WHERE PatientEmail = @Email";
                    using (SqlCommand cmd = new SqlCommand(bloodTestsQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@Email", email);
                        statistics["bloodTests"] = (int)cmd.ExecuteScalar();
                    }
                    
                    // Member since year
                    string memberSinceQuery = "SELECT YEAR(CreatedDate) FROM Patients WHERE Email = @Email";
                    using (SqlCommand cmd = new SqlCommand(memberSinceQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@Email", email);
                        object result = cmd.ExecuteScalar();
                        statistics["memberSince"] = result != null ? (int)result : DateTime.Now.Year;
                    }
                    
                    var response = new
                    {
                        success = true,
                        statistics = statistics
                    };
                    
                    return serializer.Serialize(response);
                }
            }
            catch (Exception ex)
            {
                return CreateErrorResponse(string.Format("Get statistics error: {0}", ex.Message));
            }
        }

        #endregion

        #region Helper Methods

        private string CreateErrorResponse(string message)
        {
            var errorResponse = new
            {
                success = false,
                message = message
            };
            
            return serializer.Serialize(errorResponse);
        }

        #endregion
    }
}
