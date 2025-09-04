using System;
using System.Configuration;
using System.Net.Mail;
using System.Net;

namespace HospitalAppointmentSystem
{
    public static class EmailHelper
    {
        public static bool SendOTPEmail(string toEmail, string otp)
        {
            try
            {
                // Get email settings from Web.config
                string smtpEmail = ConfigurationManager.AppSettings["SmtpEmail"];
                string smtpPassword = ConfigurationManager.AppSettings["SmtpPassword"];
                
                // If email settings are not configured, return false
                if (string.IsNullOrEmpty(smtpEmail) || string.IsNullOrEmpty(smtpPassword))
                {
                    return false;
                }
                
                // Determine SMTP settings based on email provider
                string smtpServer = "smtp.gmail.com";
                int smtpPort = 587;
                
                if (smtpEmail.Contains("@outlook.com") || smtpEmail.Contains("@hotmail.com"))
                {
                    smtpServer = "smtp-mail.outlook.com";
                    smtpPort = 587;
                }
                else if (smtpEmail.Contains("@yahoo.com"))
                {
                    smtpServer = "smtp.mail.yahoo.com";
                    smtpPort = 587;
                }
                
                using (SmtpClient smtp = new SmtpClient(smtpServer, smtpPort))
                {
                    smtp.EnableSsl = true;
                    smtp.Credentials = new NetworkCredential(smtpEmail, smtpPassword);
                    
                    MailMessage mail = new MailMessage();
                    mail.From = new MailAddress(smtpEmail, "Hospital Appointment System");
                    mail.To.Add(toEmail);
                    mail.Subject = "Password Reset OTP";
                    mail.Body = string.Format(
                        "Your password reset OTP code is: {0}\n\n" +
                        "This code will expire in 10 minutes.\n\n" +
                        "If you didn't request this password reset, please ignore this email.\n\n" +
                        "Best regards,\nHospital Appointment System Team", 
                        otp);
                    mail.IsBodyHtml = false;
                    
                    smtp.Send(mail);
                    return true;
                }
            }
            catch (Exception ex)
            {
                return false;
            }
        }
        
        public static string GetEmailSetupInstructions()
        {
            return @"
To enable email sending, add these settings to your Web.config file in the <appSettings> section:

For Gmail:
<add key=""SmtpEmail"" value=""your-email@gmail.com"" />
<add key=""SmtpPassword"" value=""your-app-password"" />

For Outlook/Hotmail:
<add key=""SmtpEmail"" value=""your-email@outlook.com"" />
<add key=""SmtpPassword"" value=""your-password"" />

For Yahoo:
<add key=""SmtpEmail"" value=""your-email@yahoo.com"" />
<add key=""SmtpPassword"" value=""your-app-password"" />

Note: For Gmail and Yahoo, you need to use an App Password, not your regular password.
You can generate an App Password in your Google/Yahoo account settings.
";
        }
    }
}
