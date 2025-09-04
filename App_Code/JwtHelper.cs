using System;
using System.Collections.Generic;
using System.Configuration;
using System.Security.Cryptography;
using System.Text;
using System.Data.SqlClient;
using System.Data;
using System.Web.Script.Serialization;

namespace HospitalAppointmentSystem
{
    public class JwtHelper
    {
        private static readonly string SecretKey = ConfigurationManager.AppSettings["JwtSecretKey"] ?? "YourSuperSecretKeyForHospitalAppointmentSystem2024";
        private static readonly string Issuer = ConfigurationManager.AppSettings["JwtIssuer"] ?? "HospitalAppointmentSystem";
        private static readonly string Audience = ConfigurationManager.AppSettings["JwtAudience"] ?? "HospitalAppointmentUsers";
        private static readonly int ExpirationMinutes = int.Parse(ConfigurationManager.AppSettings["JwtExpirationMinutes"] ?? "1440");

        /// <summary>
        /// Creates a simple JWT-like token for the user
        /// </summary>
        public static string GenerateToken(string email, string firstName, string lastName, string role = "Patient")
        {
            var tokenData = new
            {
                email = email,
                firstName = firstName,
                lastName = lastName,
                role = role,
                issuedAt = DateTime.UtcNow.ToString("yyyy-MM-dd HH:mm:ss"),
                expiresAt = DateTime.UtcNow.AddMinutes(ExpirationMinutes).ToString("yyyy-MM-dd HH:mm:ss"),
                issuer = Issuer,
                audience = Audience,
                jti = Guid.NewGuid().ToString()
            };

            var json = new JavaScriptSerializer().Serialize(tokenData);
            var jsonBytes = Encoding.UTF8.GetBytes(json);
            var base64Json = Convert.ToBase64String(jsonBytes);
            
            // Create a simple signature
            var signature = CreateSignature(base64Json);
            
            return base64Json + "." + signature;
        }

        /// <summary>
        /// Validates and extracts data from a token
        /// </summary>
        public static TokenValidationResult ValidateToken(string token)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(token))
                    return new TokenValidationResult { IsValid = false };

                var parts = token.Split('.');
                if (parts.Length != 2)
                    return new TokenValidationResult { IsValid = false };

                var base64Json = parts[0];
                var signature = parts[1];

                // Verify signature
                var expectedSignature = CreateSignature(base64Json);
                if (signature != expectedSignature)
                    return new TokenValidationResult { IsValid = false };

                // Decode JSON
                var jsonBytes = Convert.FromBase64String(base64Json);
                var json = Encoding.UTF8.GetString(jsonBytes);
                var tokenData = new JavaScriptSerializer().Deserialize<Dictionary<string, object>>(json);

                // Check expiration
                var expiresAtStr = tokenData["expiresAt"].ToString();
                var expiresAt = DateTime.Parse(expiresAtStr);
                if (DateTime.UtcNow > expiresAt)
                    return new TokenValidationResult { IsValid = false };

                // Check issuer and audience
                if (tokenData["issuer"].ToString() != Issuer || tokenData["audience"].ToString() != Audience)
                    return new TokenValidationResult { IsValid = false };

                return new TokenValidationResult
                {
                    IsValid = true,
                    Email = tokenData["email"].ToString(),
                    FirstName = tokenData["firstName"].ToString(),
                    LastName = tokenData["lastName"].ToString(),
                    Role = tokenData["role"].ToString()
                };
            }
            catch
            {
                return new TokenValidationResult { IsValid = false };
            }
        }

        /// <summary>
        /// Creates a simple HMAC signature
        /// </summary>
        private static string CreateSignature(string data)
        {
            using (var hmac = new HMACSHA256(Encoding.UTF8.GetBytes(SecretKey)))
            {
                var hash = hmac.ComputeHash(Encoding.UTF8.GetBytes(data));
                return Convert.ToBase64String(hash);
            }
        }

        /// <summary>
        /// Refreshes a token by generating a new one
        /// </summary>
        public static string RefreshToken(string email)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;
            
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT FirstName, LastName FROM Patients WHERE Email = @Email";
                
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
                                string firstName = reader["FirstName"].ToString();
                                string lastName = reader["LastName"].ToString();
                                return GenerateToken(email, firstName, lastName);
                            }
                        }
                    }
                    catch
                    {
                        return null;
                    }
                }
            }
            return null;
        }

        /// <summary>
        /// Checks if a token is expired
        /// </summary>
        public static bool IsTokenExpired(string token)
        {
            try
            {
                var result = ValidateToken(token);
                return !result.IsValid;
            }
            catch
            {
                return true;
            }
        }

        /// <summary>
        /// Gets user email from token
        /// </summary>
        public static string GetUserEmailFromToken(string token)
        {
            try
            {
                var result = ValidateToken(token);
                return result.IsValid ? result.Email : null;
            }
            catch
            {
                return null;
            }
        }

        /// <summary>
        /// Gets user role from token
        /// </summary>
        public static string GetUserRoleFromToken(string token)
        {
            try
            {
                var result = ValidateToken(token);
                return result.IsValid ? result.Role : null;
            }
            catch
            {
                return null;
            }
        }

        /// <summary>
        /// Token validation result
        /// </summary>
        public class TokenValidationResult
        {
            public bool IsValid { get; set; }
            public string Email { get; set; }
            public string FirstName { get; set; }
            public string LastName { get; set; }
            public string Role { get; set; }
        }
    }
}
