using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Net.Mail;
using System.Web;
using System.Text;

namespace HospitalAppointmentSystem
{
    public static class SecurityEmailService
    {
        private static readonly string smtpServer = ConfigurationManager.AppSettings["SmtpServer"] ?? "smtp.gmail.com";
        private static readonly int smtpPort = int.Parse(ConfigurationManager.AppSettings["SmtpPort"] ?? "587");
        private static readonly string smtpUsername = ConfigurationManager.AppSettings["SmtpUsername"] ?? "";
        private static readonly string smtpPassword = ConfigurationManager.AppSettings["SmtpPassword"] ?? "";
        private static readonly string fromEmail = ConfigurationManager.AppSettings["FromEmail"] ?? "noreply@hospitalappointment.com";
        private static readonly string fromName = ConfigurationManager.AppSettings["FromName"] ?? "Hospital Appointment System";

        private static void LogEmailNotification(string userEmail, string notificationType, string status, string details)
        {
            try
            {
                // Simple logging to debug output for now - handle null values safely
                string safeUserEmail = userEmail ?? "Unknown";
                string safeNotificationType = notificationType ?? "Unknown";
                string safeStatus = status ?? "Unknown";
                string safeDetails = details ?? "No details";
                

                
                // Try to log to database if possible
                try
                {
                    // Check if connection string exists
                    if (ConfigurationManager.ConnectionStrings["HospitalDB"] == null)
                    {
                        return;
                    }

                    string connectionString = ConfigurationManager.ConnectionStrings["HospitalDB"].ConnectionString;
                    if (string.IsNullOrEmpty(connectionString))
                    {
                        return;
                    }

                    using (SqlConnection conn = new SqlConnection(connectionString))
                    {
                        conn.Open();
                        
                        string query = @"
                            INSERT INTO EmailNotifications (UserEmail, NotificationType, Status, Details, SentAt)
                            VALUES (@UserEmail, @NotificationType, @Status, @Details, @SentAt)";
                        
                        using (SqlCommand cmd = new SqlCommand(query, conn))
                        {
                            cmd.Parameters.AddWithValue("@UserEmail", safeUserEmail);
                            cmd.Parameters.AddWithValue("@NotificationType", safeNotificationType);
                            cmd.Parameters.AddWithValue("@Status", safeStatus);
                            cmd.Parameters.AddWithValue("@Details", safeDetails);
                            cmd.Parameters.AddWithValue("@SentAt", DateTime.Now);
                            
                            cmd.ExecuteNonQuery();
                        }
                    }
                }
                catch (Exception dbEx)
                {
                    // Continue without database logging
                }
            }
            catch (Exception ex)
            {
                // Don't throw the exception to avoid breaking the main functionality
            }
        }

        /// <summary>
        /// Sends a login notification email when someone logs into an account
        /// </summary>
        /// <param name="userEmail">The email address of the account owner</param>
        /// <param name="request">The HTTP request object to get device information</param>
        /// <param name="loginTime">When the login occurred</param>
        /// <param name="userName">The name of the user who logged in</param>
        public static void SendLoginNotification(string userEmail, HttpRequest request, DateTime loginTime, string userName)
        {
            try
            {
                string ipAddress = GetClientIPAddress(request);
                string userAgent = GetUserAgent(request);
                string deviceInfo = GetDeviceInfo(userAgent);
                string location = GetLocationFromIP(ipAddress);

                string subject = "🔐 New Login Detected - Hospital Appointment System";
                string body = GenerateLoginNotificationEmail(userName, loginTime, ipAddress, deviceInfo, location, userAgent);

                SendEmail(userEmail, subject, body);
                
                // Log the email notification
                LogEmailNotification(userEmail, "LoginNotification", "Success", "Login notification sent for " + (userName ?? "Unknown"));
            }
            catch (Exception ex)
            {
                // Log the error but don't throw to avoid breaking the login process
                LogEmailNotification(userEmail, "LoginNotification", "Failed", ex.Message);
            }
        }

        /// <summary>
        /// Sends a password change notification email
        /// </summary>
        /// <param name="userEmail">The email address of the account owner</param>
        /// <param name="request">The HTTP request object to get device information</param>
        /// <param name="changeTime">When the password was changed</param>
        /// <param name="userName">The name of the user</param>
        public static void SendPasswordChangeNotification(string userEmail, HttpRequest request, DateTime changeTime, string userName)
        {
            try
            {
                string ipAddress = GetClientIPAddress(request);
                string userAgent = GetUserAgent(request);
                string deviceInfo = GetDeviceInfo(userAgent);
                string location = GetLocationFromIP(ipAddress);

                string subject = "🔑 Password Changed - Hospital Appointment System";
                string body = GeneratePasswordChangeEmail(userName, changeTime, ipAddress, deviceInfo, location, userAgent);

                SendEmail(userEmail, subject, body);
                
                // Log the email notification
                LogEmailNotification(userEmail, "PasswordChangeNotification", "Success", "Password change notification sent for " + (userName ?? "Unknown"));
            }
            catch (Exception ex)
            {
                LogEmailNotification(userEmail, "PasswordChangeNotification", "Failed", ex.Message);
            }
        }

        private static string GetClientIPAddress(HttpRequest request)
        {
            try
            {
                // Check for forwarded headers (common with proxies/load balancers)
                string forwardedFor = request.Headers["X-Forwarded-For"];
                if (!string.IsNullOrEmpty(forwardedFor))
                {
                    string[] ips = forwardedFor.Split(',');
                    return ips[0].Trim();
                }

                // Check for X-Real-IP header
                string realIP = request.Headers["X-Real-IP"];
                if (!string.IsNullOrEmpty(realIP))
                {
                    return realIP.Trim();
                }

                // Check for X-Client-IP header
                string clientIP = request.Headers["X-Client-IP"];
                if (!string.IsNullOrEmpty(clientIP))
                {
                    return clientIP.Trim();
                }

                // Fall back to UserHostAddress
                string userHostAddress = request.UserHostAddress;
                if (!string.IsNullOrEmpty(userHostAddress) && userHostAddress != "::1")
                {
                    return userHostAddress;
                }

                return "127.0.0.1";
            }
            catch (Exception ex)
            {
                return "Unknown";
            }
        }

        private static string GetUserAgent(HttpRequest request)
        {
            try
            {
                return request.UserAgent ?? "Unknown";
            }
            catch (Exception ex)
            {
                return "Unknown";
            }
        }

        private static string GetDeviceInfo(string userAgent)
        {
            if (string.IsNullOrEmpty(userAgent) || userAgent == "Unknown")
                return "Unknown Device";

            try
            {
                // Simple device detection based on user agent
                if (userAgent.Contains("Windows"))
                {
                    if (userAgent.Contains("Chrome"))
                        return "Windows PC - Chrome Browser";
                    else if (userAgent.Contains("Firefox"))
                        return "Windows PC - Firefox Browser";
                    else if (userAgent.Contains("Edge"))
                        return "Windows PC - Edge Browser";
                    else
                        return "Windows PC";
                }
                else if (userAgent.Contains("Mac"))
                {
                    if (userAgent.Contains("Safari"))
                        return "Mac - Safari Browser";
                    else if (userAgent.Contains("Chrome"))
                        return "Mac - Chrome Browser";
                    else
                        return "Mac";
                }
                else if (userAgent.Contains("iPhone") || userAgent.Contains("iPad"))
                {
                    return "iOS Device";
                }
                else if (userAgent.Contains("Android"))
                {
                    return "Android Device";
                }
                else if (userAgent.Contains("Linux"))
                {
                    return "Linux Device";
                }
                else
                {
                    return "Unknown Device";
                }
            }
            catch
            {
                return "Unknown Device";
            }
        }

        private static string GetLocationFromIP(string ipAddress)
        {
            // For now, return a placeholder. In a real implementation, you could use an IP geolocation service
            if (ipAddress == "127.0.0.1" || ipAddress == "::1" || ipAddress == "Unknown")
                return "Local Network";
            else
                return "Unknown Location"; // You could integrate with IP geolocation APIs here
        }

        private static string GenerateLoginNotificationEmail(string userName, DateTime loginTime, string ipAddress, string deviceInfo, string location, string userAgent)
        {
            StringBuilder sb = new StringBuilder();
            
            sb.AppendLine("<!DOCTYPE html>");
            sb.AppendLine("<html>");
            sb.AppendLine("<head>");
            sb.AppendLine("<meta charset='UTF-8'>");
            sb.AppendLine("<title>New Login Detected</title>");
            sb.AppendLine("<style>");
            sb.AppendLine("body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }");
            sb.AppendLine(".container { max-width: 600px; margin: 0 auto; padding: 20px; }");
            sb.AppendLine(".header { background: linear-gradient(135deg, #007bff 0%, #0056b3 100%); color: white; padding: 30px; text-align: center; border-radius: 10px 10px 0 0; }");
            sb.AppendLine(".content { background: #f8f9fa; padding: 30px; border-radius: 0 0 10px 10px; }");
            sb.AppendLine(".alert { background: #fff3cd; border: 1px solid #ffeaa7; padding: 15px; border-radius: 5px; margin: 20px 0; }");
            sb.AppendLine(".info-box { background: white; border: 1px solid #dee2e6; padding: 20px; border-radius: 5px; margin: 15px 0; }");
            sb.AppendLine(".info-row { display: flex; justify-content: space-between; margin: 10px 0; }");
            sb.AppendLine(".label { font-weight: bold; color: #495057; }");
            sb.AppendLine(".value { color: #6c757d; }");
            sb.AppendLine(".footer { text-align: center; margin-top: 30px; color: #6c757d; font-size: 14px; }");
            sb.AppendLine(".btn { display: inline-block; padding: 12px 24px; background: #dc3545; color: white; text-decoration: none; border-radius: 5px; margin: 10px 5px; }");
            sb.AppendLine("</style>");
            sb.AppendLine("</head>");
            sb.AppendLine("<body>");
            sb.AppendLine("<div class='container'>");
            
            // Header
            sb.AppendLine("<div class='header'>");
            sb.AppendLine("<h1>🔐 New Login Detected</h1>");
            sb.AppendLine("<p>Hospital Appointment System Security Alert</p>");
            sb.AppendLine("</div>");
            
            // Content
            sb.AppendLine("<div class='content'>");
            sb.AppendLine("<p>Hello <strong>" + (userName ?? "User") + "</strong>,</p>");
            sb.AppendLine("<p>We detected a new login to your Hospital Appointment System account.</p>");
            
            // Alert box
            sb.AppendLine("<div class='alert'>");
            sb.AppendLine("<strong>⚠️ Security Notice:</strong> If this wasn't you, please change your password immediately and contact support.");
            sb.AppendLine("</div>");
            
            // Login details
            sb.AppendLine("<div class='info-box'>");
            sb.AppendLine("<h3>📱 Login Details</h3>");
            sb.AppendLine("<div class='info-row'><span class='label'>Time:</span><span class='value'>" + loginTime.ToString("yyyy-MM-dd HH:mm:ss") + "</span></div>");
            sb.AppendLine("<div class='info-row'><span class='label'>Device:</span><span class='value'>" + (deviceInfo ?? "Unknown") + "</span></div>");
            sb.AppendLine("<div class='info-row'><span class='label'>IP Address:</span><span class='value'>" + (ipAddress ?? "Unknown") + "</span></div>");
            sb.AppendLine("<div class='info-row'><span class='label'>Location:</span><span class='value'>" + (location ?? "Unknown") + "</span></div>");
            sb.AppendLine("</div>");
            
            // Action buttons
            sb.AppendLine("<div style='text-align: center; margin: 30px 0;'>");
            sb.AppendLine("<a href='/Pages/Profile.aspx' class='btn' style='background: #28a745;'>✅ This Was Me</a>");
            sb.AppendLine("<a href='/Pages/ResetPassword.aspx' class='btn'>🔑 Change Password</a>");
            sb.AppendLine("</div>");
            
            sb.AppendLine("<p>If you have any questions or concerns, please contact our support team.</p>");
            sb.AppendLine("</div>");
            
            // Footer
            sb.AppendLine("<div class='footer'>");
            sb.AppendLine("<p>This is an automated security notification. Please do not reply to this email.</p>");
            sb.AppendLine("<p>© 2024 Hospital Appointment System. All rights reserved.</p>");
            sb.AppendLine("</div>");
            
            sb.AppendLine("</div>");
            sb.AppendLine("</body>");
            sb.AppendLine("</html>");
            
            return sb.ToString();
        }

        private static string GeneratePasswordChangeEmail(string userName, DateTime changeTime, string ipAddress, string deviceInfo, string location, string userAgent)
        {
            StringBuilder sb = new StringBuilder();
            
            sb.AppendLine("<!DOCTYPE html>");
            sb.AppendLine("<html>");
            sb.AppendLine("<head>");
            sb.AppendLine("<meta charset='UTF-8'>");
            sb.AppendLine("<title>Password Changed</title>");
            sb.AppendLine("<style>");
            sb.AppendLine("body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }");
            sb.AppendLine(".container { max-width: 600px; margin: 0 auto; padding: 20px; }");
            sb.AppendLine(".header { background: linear-gradient(135deg, #28a745 0%, #1e7e34 100%); color: white; padding: 30px; text-align: center; border-radius: 10px 10px 0 0; }");
            sb.AppendLine(".content { background: #f8f9fa; padding: 30px; border-radius: 0 0 10px 10px; }");
            sb.AppendLine(".success { background: #d4edda; border: 1px solid #c3e6cb; padding: 15px; border-radius: 5px; margin: 20px 0; }");
            sb.AppendLine(".info-box { background: white; border: 1px solid #dee2e6; padding: 20px; border-radius: 5px; margin: 15px 0; }");
            sb.AppendLine(".info-row { display: flex; justify-content: space-between; margin: 10px 0; }");
            sb.AppendLine(".label { font-weight: bold; color: #495057; }");
            sb.AppendLine(".value { color: #6c757d; }");
            sb.AppendLine(".footer { text-align: center; margin-top: 30px; color: #6c757d; font-size: 14px; }");
            sb.AppendLine("</style>");
            sb.AppendLine("</head>");
            sb.AppendLine("<body>");
            sb.AppendLine("<div class='container'>");
            
            // Header
            sb.AppendLine("<div class='header'>");
            sb.AppendLine("<h1>🔑 Password Changed</h1>");
            sb.AppendLine("<p>Hospital Appointment System Security Notification</p>");
            sb.AppendLine("</div>");
            
            // Content
            sb.AppendLine("<div class='content'>");
            sb.AppendLine("<p>Hello <strong>" + (userName ?? "User") + "</strong>,</p>");
            sb.AppendLine("<p>Your Hospital Appointment System account password has been successfully changed.</p>");
            
            // Success box
            sb.AppendLine("<div class='success'>");
            sb.AppendLine("<strong>✅ Password Change Confirmed:</strong> Your account password has been updated successfully.");
            sb.AppendLine("</div>");
            
            // Change details
            sb.AppendLine("<div class='info-box'>");
            sb.AppendLine("<h3>📱 Change Details</h3>");
            sb.AppendLine("<div class='info-row'><span class='label'>Time:</span><span class='value'>" + changeTime.ToString("yyyy-MM-dd HH:mm:ss") + "</span></div>");
            sb.AppendLine("<div class='info-row'><span class='label'>Device:</span><span class='value'>" + (deviceInfo ?? "Unknown") + "</span></div>");
            sb.AppendLine("<div class='info-row'><span class='label'>IP Address:</span><span class='value'>" + (ipAddress ?? "Unknown") + "</span></div>");
            sb.AppendLine("<div class='info-row'><span class='label'>Location:</span><span class='value'>" + (location ?? "Unknown") + "</span></div>");
            sb.AppendLine("</div>");
            
            sb.AppendLine("<p>If you did not make this change, please contact our support team immediately.</p>");
            sb.AppendLine("</div>");
            
            // Footer
            sb.AppendLine("<div class='footer'>");
            sb.AppendLine("<p>This is an automated security notification. Please do not reply to this email.</p>");
            sb.AppendLine("<p>© 2024 Hospital Appointment System. All rights reserved.</p>");
            sb.AppendLine("</div>");
            
            sb.AppendLine("</div>");
            sb.AppendLine("</body>");
            sb.AppendLine("</html>");
            
            return sb.ToString();
        }

        private static void SendEmail(string toEmail, string subject, string body)
        {
            try
            {
                using (var client = new System.Net.WebClient())
                {
                    client.Headers.Add("Content-Type", "application/json");
                    
                    // Create a simple email data structure for the API
                    string jsonData = "{\"to\":\"" + toEmail + "\",\"subject\":\"" + subject + "\",\"html\":\"" + body.Replace("\"", "\\\"").Replace("\n", "\\n").Replace("\r", "") + "\"}";
                    client.UploadString("http://localhost:3000/api/send-email", "POST", jsonData);
                }
            }
            catch (Exception ex)
            {
                // Log error but don't throw to avoid breaking the main functionality
                System.Diagnostics.Debug.WriteLine("Failed to send email via API: " + ex.Message);
            }
        }

    }
}
