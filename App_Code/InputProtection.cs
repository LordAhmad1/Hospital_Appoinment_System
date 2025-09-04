using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Net;
using System.Security.Cryptography;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Security;

namespace HospitalAppointmentSystem
{
    public static class InputProtection
    {
        #region Input Validation

        /// <summary>
        /// Validates and sanitizes email address
        /// </summary>
        public static bool IsValidEmail(string email)
        {
            if (string.IsNullOrWhiteSpace(email))
                return false;

            try
            {
                // Basic email validation
                var regex = new Regex(@"^[^@\s]+@[^@\s]+\.[^@\s]+$");
                if (!regex.IsMatch(email))
                    return false;

                // Check for suspicious patterns
                if (email.Contains("..") || email.Contains("--") || email.Length > 254)
                    return false;

                // Check for SQL injection patterns
                if (ContainsSqlInjection(email))
                    return false;

                return true;
            }
            catch
            {
                return false;
            }
        }

        /// <summary>
        /// Validates password strength
        /// </summary>
        public static bool IsValidPassword(string password)
        {
            if (string.IsNullOrWhiteSpace(password) || password.Length < 8)
                return false;

            // Check for minimum requirements
            bool hasUpperCase = password.Any(char.IsUpper);
            bool hasLowerCase = password.Any(char.IsLower);
            bool hasDigit = password.Any(char.IsDigit);
            bool hasSpecialChar = password.Any(c => !char.IsLetterOrDigit(c));

            return hasUpperCase && hasLowerCase && hasDigit && hasSpecialChar;
        }

        /// <summary>
        /// Validates phone number format
        /// </summary>
        public static bool IsValidPhone(string phone)
        {
            if (string.IsNullOrWhiteSpace(phone))
                return false;

            // Remove all non-digit characters
            string digitsOnly = new string(phone.Where(char.IsDigit).ToArray());
            
            // Check if it's a valid length (7-15 digits)
            if (digitsOnly.Length < 7 || digitsOnly.Length > 15)
                return false;

            // Check for SQL injection
            if (ContainsSqlInjection(phone))
                return false;

            return true;
        }

        /// <summary>
        /// Validates national ID format
        /// </summary>
        public static bool IsValidNationalId(string nationalId)
        {
            if (string.IsNullOrWhiteSpace(nationalId))
                return false;

            // Remove spaces and dashes
            string cleanId = nationalId.Replace(" ", "").Replace("-", "");
            
            // Check if it contains only digits and letters
            if (!cleanId.All(c => char.IsLetterOrDigit(c)))
                return false;

            // Check length (typically 10-11 characters)
            if (cleanId.Length < 10 || cleanId.Length > 11)
                return false;

            // Check for SQL injection
            if (ContainsSqlInjection(nationalId))
                return false;

            return true;
        }

        /// <summary>
        /// Validates date format
        /// </summary>
        public static bool IsValidDate(string dateString)
        {
            if (string.IsNullOrWhiteSpace(dateString))
                return false;

            try
            {
                DateTime date = DateTime.Parse(dateString);
                
                // Check if date is not in the future (for birth dates)
                if (date > DateTime.Now)
                    return false;

                // Check if date is not too far in the past (reasonable birth date)
                if (date < DateTime.Now.AddYears(-120))
                    return false;

                return true;
            }
            catch
            {
                return false;
            }
        }

        /// <summary>
        /// Validates appointment date and time
        /// </summary>
        public static bool IsValidAppointmentDateTime(string dateString, string timeString)
        {
            if (!IsValidDate(dateString))
                return false;

            try
            {
                DateTime appointmentDate = DateTime.Parse(dateString);
                TimeSpan appointmentTime = TimeSpan.Parse(timeString);

                // Check if appointment is not in the past
                DateTime appointmentDateTime = appointmentDate.Add(appointmentTime);
                if (appointmentDateTime < DateTime.Now)
                    return false;

                // Check if appointment is not too far in the future (1 year max)
                if (appointmentDateTime > DateTime.Now.AddYears(1))
                    return false;

                return true;
            }
            catch
            {
                return false;
            }
        }

        #endregion

        #region Input Sanitization

        /// <summary>
        /// Sanitizes text input to prevent XSS
        /// </summary>
        public static string SanitizeText(string input)
        {
            if (string.IsNullOrWhiteSpace(input))
                return string.Empty;

            // Remove HTML tags
            input = Regex.Replace(input, @"<[^>]*>", string.Empty);
            
            // Encode special characters
            input = HttpUtility.HtmlEncode(input);
            
            // Remove null characters
            input = input.Replace("\0", string.Empty);
            
            // Trim whitespace
            input = input.Trim();
            
            return input;
        }

        /// <summary>
        /// Sanitizes name input
        /// </summary>
        public static string SanitizeName(string name)
        {
            if (string.IsNullOrWhiteSpace(name))
                return string.Empty;

            // Remove HTML and special characters except letters, spaces, and hyphens
            name = Regex.Replace(name, @"[^a-zA-Z\s\-']", string.Empty);
            
            // Remove multiple spaces
            name = Regex.Replace(name, @"\s+", " ");
            
            // Capitalize first letter of each word
            name = CultureInfo.CurrentCulture.TextInfo.ToTitleCase(name.ToLower());
            
            return name.Trim();
        }

        /// <summary>
        /// Sanitizes phone number
        /// </summary>
        public static string SanitizePhone(string phone)
        {
            if (string.IsNullOrWhiteSpace(phone))
                return string.Empty;

            // Keep only digits, spaces, dashes, and parentheses
            phone = Regex.Replace(phone, @"[^\d\s\-\(\)\+]", string.Empty);
            
            return phone.Trim();
        }

        /// <summary>
        /// Sanitizes national ID
        /// </summary>
        public static string SanitizeNationalId(string nationalId)
        {
            if (string.IsNullOrWhiteSpace(nationalId))
                return string.Empty;

            // Keep only alphanumeric characters
            nationalId = Regex.Replace(nationalId, @"[^a-zA-Z0-9]", string.Empty);
            
            return nationalId.ToUpper().Trim();
        }

        #endregion

        #region SQL Injection Prevention

        /// <summary>
        /// Checks if input contains SQL injection patterns
        /// </summary>
        public static bool ContainsSqlInjection(string input)
        {
            if (string.IsNullOrWhiteSpace(input))
                return false;

            string lowerInput = input.ToLower();
            
            // Common SQL injection patterns
            string[] sqlPatterns = {
                "select", "insert", "update", "delete", "drop", "create", "alter", "exec", "execute",
                "union", "union all", "or 1=1", "or '1'='1", "or 1", "admin'--", "admin'/*",
                "'; drop table", "'; delete from", "'; insert into", "'; update set",
                "xp_", "sp_", "sysobjects", "syscolumns", "information_schema",
                "waitfor delay", "benchmark", "sleep(", "load_file", "into outfile",
                "char(", "ascii(", "substring(", "concat(", "hex(", "unhex("
            };

            return sqlPatterns.Any(pattern => lowerInput.Contains(pattern));
        }

        /// <summary>
        /// Creates a safe SQL parameter
        /// </summary>
        public static SqlParameter CreateSafeParameter(string parameterName, object value)
        {
            if (value == null)
                return new SqlParameter(parameterName, DBNull.Value);

            // Additional validation for string parameters
            if (value is string)
            {
                string stringValue = value as string;
                if (ContainsSqlInjection(stringValue))
                    throw new ArgumentException("Input contains potentially dangerous content");
                
                // Limit string length
                if (stringValue.Length > 1000)
                    throw new ArgumentException("Input is too long");
            }

            return new SqlParameter(parameterName, value);
        }

        #endregion

        #region XSS Prevention

        /// <summary>
        /// Checks if input contains XSS patterns
        /// </summary>
        public static bool ContainsXss(string input)
        {
            if (string.IsNullOrWhiteSpace(input))
                return false;

            string lowerInput = input.ToLower();
            
            // Common XSS patterns
            string[] xssPatterns = {
                "<script", "javascript:", "vbscript:", "onload=", "onerror=", "onclick=",
                "onmouseover=", "onfocus=", "onblur=", "onchange=", "onsubmit=",
                "alert(", "confirm(", "prompt(", "eval(", "document.cookie",
                "window.location", "location.href", "document.write", "innerhtml",
                "outerhtml", "insertadjacenthtml", "createelement", "appendchild"
            };

            return xssPatterns.Any(pattern => lowerInput.Contains(pattern));
        }

        /// <summary>
        /// Encodes output to prevent XSS
        /// </summary>
        public static string EncodeOutput(string output)
        {
            if (string.IsNullOrWhiteSpace(output))
                return string.Empty;

            return HttpUtility.HtmlEncode(output);
        }

        #endregion

        #region Rate Limiting

        private static readonly Dictionary<string, List<DateTime>> _requestHistory = new Dictionary<string, List<DateTime>>();
        private static readonly object _lockObject = new object();

        /// <summary>
        /// Checks if request is within rate limit
        /// </summary>
        public static bool IsWithinRateLimit(string identifier, int maxRequests = 10, int timeWindowMinutes = 1)
        {
            lock (_lockObject)
            {
                DateTime now = DateTime.Now;
                DateTime cutoff = now.AddMinutes(-timeWindowMinutes);

                if (!_requestHistory.ContainsKey(identifier))
                {
                    _requestHistory[identifier] = new List<DateTime>();
                }

                // Remove old requests
                _requestHistory[identifier].RemoveAll(time => time < cutoff);

                // Check if within limit
                if (_requestHistory[identifier].Count >= maxRequests)
                    return false;

                // Add current request
                _requestHistory[identifier].Add(now);
                return true;
            }
        }

        #endregion

        #region Password Security

        /// <summary>
        /// Generates a secure random password
        /// </summary>
        public static string GenerateSecurePassword(int length = 12)
        {
            const string upperCase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
            const string lowerCase = "abcdefghijklmnopqrstuvwxyz";
            const string digits = "0123456789";
            const string specialChars = "!@#$%^&*()_+-=[]{}|;:,.<>?";

            var random = new RNGCryptoServiceProvider();
            var password = new StringBuilder();

            // Ensure at least one character from each category
            password.Append(GetRandomChar(upperCase, random));
            password.Append(GetRandomChar(lowerCase, random));
            password.Append(GetRandomChar(digits, random));
            password.Append(GetRandomChar(specialChars, random));

            // Fill the rest randomly
            string allChars = upperCase + lowerCase + digits + specialChars;
            for (int i = 4; i < length; i++)
            {
                password.Append(GetRandomChar(allChars, random));
            }

            // Shuffle the password
            return ShuffleString(password.ToString());
        }

        private static char GetRandomChar(string chars, RNGCryptoServiceProvider random)
        {
            byte[] bytes = new byte[1];
            random.GetBytes(bytes);
            return chars[bytes[0] % chars.Length];
        }

        private static string ShuffleString(string input)
        {
            char[] chars = input.ToCharArray();
            var random = new RNGCryptoServiceProvider();
            
            for (int i = chars.Length - 1; i > 0; i--)
            {
                byte[] bytes = new byte[1];
                random.GetBytes(bytes);
                int j = bytes[0] % (i + 1);
                char temp = chars[i];
                chars[i] = chars[j];
                chars[j] = temp;
            }
            
            return new string(chars);
        }

        #endregion

        #region CSRF Protection

        /// <summary>
        /// Generates a CSRF token
        /// </summary>
        public static string GenerateCsrfToken()
        {
            byte[] tokenBytes = new byte[32];
            using (var rng = new RNGCryptoServiceProvider())
            {
                rng.GetBytes(tokenBytes);
            }
            return Convert.ToBase64String(tokenBytes);
        }

        /// <summary>
        /// Validates CSRF token
        /// </summary>
        public static bool ValidateCsrfToken(string token, string sessionToken)
        {
            if (string.IsNullOrWhiteSpace(token) || string.IsNullOrWhiteSpace(sessionToken))
                return false;

            return token.Equals(sessionToken, StringComparison.Ordinal);
        }

        #endregion

        #region Input Length Validation

        /// <summary>
        /// Validates input length
        /// </summary>
        public static bool IsValidLength(string input, int minLength, int maxLength)
        {
            if (input == null)
                return minLength == 0;

            return input.Length >= minLength && input.Length <= maxLength;
        }

        /// <summary>
        /// Truncates input to maximum length
        /// </summary>
        public static string TruncateInput(string input, int maxLength)
        {
            if (string.IsNullOrWhiteSpace(input))
                return string.Empty;

            return input.Length <= maxLength ? input : input.Substring(0, maxLength);
        }

        #endregion

        #region Comprehensive Input Validation

        /// <summary>
        /// Validation result class for .NET Framework compatibility
        /// </summary>
        public class ValidationResult
        {
            public bool IsValid { get; set; }
            public string ErrorMessage { get; set; }

            public ValidationResult(bool isValid, string errorMessage)
            {
                IsValid = isValid;
                ErrorMessage = errorMessage;
            }
        }

        /// <summary>
        /// Comprehensive input validation for profile data
        /// </summary>
        public static ValidationResult ValidateProfileData(string firstName, string lastName, string phone, string nationalId, string dateOfBirth)
        {
            // Validate first name
            if (!IsValidLength(firstName, 2, 50))
                return new ValidationResult(false, "First name must be between 2 and 50 characters");

            if (ContainsSqlInjection(firstName) || ContainsXss(firstName))
                return new ValidationResult(false, "First name contains invalid characters");

            // Validate last name
            if (!IsValidLength(lastName, 2, 50))
                return new ValidationResult(false, "Last name must be between 2 and 50 characters");

            if (ContainsSqlInjection(lastName) || ContainsXss(lastName))
                return new ValidationResult(false, "Last name contains invalid characters");

            // Validate phone (optional)
            if (!string.IsNullOrWhiteSpace(phone) && !IsValidPhone(phone))
                return new ValidationResult(false, "Invalid phone number format");

            // Validate national ID (optional)
            if (!string.IsNullOrWhiteSpace(nationalId) && !IsValidNationalId(nationalId))
                return new ValidationResult(false, "Invalid national ID format");

            // Validate date of birth (optional)
            if (!string.IsNullOrWhiteSpace(dateOfBirth) && !IsValidDate(dateOfBirth))
                return new ValidationResult(false, "Invalid date of birth");

            return new ValidationResult(true, string.Empty);
        }

        /// <summary>
        /// Comprehensive input validation for appointment data
        /// </summary>
        public static ValidationResult ValidateAppointmentData(int hospitalId, int doctorId, string appointmentDate, string appointmentTime)
        {
            // Validate hospital ID
            if (hospitalId <= 0)
                return new ValidationResult(false, "Invalid hospital selection");

            // Validate doctor ID
            if (doctorId <= 0)
                return new ValidationResult(false, "Invalid doctor selection");

            // Validate appointment date and time
            if (!IsValidAppointmentDateTime(appointmentDate, appointmentTime))
                return new ValidationResult(false, "Invalid appointment date or time");

            return new ValidationResult(true, string.Empty);
        }

        #endregion
    }
}
