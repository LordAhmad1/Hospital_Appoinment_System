const express = require('express');
const nodemailer = require('nodemailer');
const cors = require('cors');
const crypto = require('crypto'); // Built-in Node.js module
const sql = require('mssql'); // SQL Server package
require('dotenv').config({ path: './email-config.env' });

const app = express();
const PORT = process.env.PORT || 3000;

// Database configuration
const dbConfig = {
    server: process.env.DB_SERVER || 'localhost',
    database: process.env.DB_NAME || 'HospitalDB',
    options: {
        encrypt: false,
        trustServerCertificate: true,
        trustedConnection: true,
        integratedSecurity: true
    }
};

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Email configuration
const transporter = nodemailer.createTransport({
    service: 'gmail', // You can change this to your email provider
    auth: {
        user: process.env.EMAIL_USER || 'your-email@gmail.com',
        pass: process.env.EMAIL_PASS || 'your-app-password'
    }
});

// Verify email configuration on startup
transporter.verify(function(error, success) {
    if (error) {
        // Email configuration error

    } else {

    }
});

// Store reset tokens (in production, use a database)
const resetTokens = new Map();

// Store OTP codes (in production, use a database)
const otpCodes = new Map();

// Generate reset token
function generateResetToken() {
    return crypto.randomBytes(32).toString('hex');
}

// Generate OTP code (6 digits)
function generateOTP() {
    return Math.floor(100000 + Math.random() * 900000).toString();
}

// Hash password using SHA256
function hashPassword(password) {
    const crypto = require('crypto');
    return crypto.createHash('sha256').update(password).digest('base64');
}

// Send password reset email
app.post('/api/send-reset-email', async (req, res) => {
    try {
        const { email } = req.body;

        if (!email) {
            return res.status(400).json({ 
                success: false, 
                message: 'Email is required' 
            });
        }

        // Generate reset token
        const resetToken = generateResetToken();
        const resetLink = `http://localhost:64931/pages/ResetPassword.aspx?token=${resetToken}`;
        
        // Store token with email (expires in 1 hour)
        resetTokens.set(resetToken, {
            email: email,
            expires: Date.now() + (60 * 60 * 1000) // 1 hour
        });

        // Email template
        const mailOptions = {
            from: process.env.EMAIL_USER || 'your-email@gmail.com',
            to: email,
            subject: 'Password Reset Request - Hospital Appointment System',
            html: `
                <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
                    <div style="background: linear-gradient(135deg, #007bff 0%, #0056b3 100%); color: white; padding: 30px; text-align: center; border-radius: 10px 10px 0 0;">
                        <h1 style="margin: 0; font-size: 24px;">Password Reset Request</h1>
                        <p style="margin: 10px 0 0 0; opacity: 0.9;">Hospital Appointment System</p>
                    </div>
                    
                    <div style="background: #f8f9fa; padding: 30px; border-radius: 0 0 10px 10px;">
                        <p style="color: #333; font-size: 16px; line-height: 1.6;">
                            Hello,<br><br>
                            We received a request to reset your password for your Hospital Appointment System account.
                        </p>
                        
                        <div style="text-align: center; margin: 30px 0;">
                            <a href="${resetLink}" 
                               style="background: linear-gradient(135deg, #007bff 0%, #0056b3 100%); 
                                      color: white; 
                                      padding: 15px 30px; 
                                      text-decoration: none; 
                                      border-radius: 8px; 
                                      font-weight: bold; 
                                      display: inline-block;
                                      box-shadow: 0 4px 15px rgba(0, 123, 255, 0.3);">
                                Reset Your Password
                            </a>
                        </div>
                        
                        <p style="color: #666; font-size: 14px; line-height: 1.6;">
                            If you didn't request this password reset, please ignore this email. 
                            This link will expire in 1 hour for security reasons.
                        </p>
                        
                        <div style="margin-top: 30px; padding-top: 20px; border-top: 1px solid #dee2e6;">
                            <p style="color: #999; font-size: 12px; margin: 0;">
                                If the button doesn't work, copy and paste this link into your browser:<br>
                                <a href="${resetLink}" style="color: #007bff; word-break: break-all;">${resetLink}</a>
                            </p>
                        </div>
                    </div>
                </div>
            `
        };

        // Send email
        await transporter.sendMail(mailOptions);

        res.json({ 
            success: true, 
            message: 'Password reset email sent successfully' 
        });

    } catch (error) {
        // Error sending reset email
        res.status(500).json({ 
            success: false, 
            message: 'Failed to send reset email. Please try again later.' 
        });
    }
});

// Verify reset token
app.post('/api/verify-reset-token', (req, res) => {
    try {
        const { token } = req.body;

        if (!token) {
            return res.status(400).json({ 
                success: false, 
                message: 'Token is required' 
            });
        }

        const tokenData = resetTokens.get(token);

        if (!tokenData) {
            return res.status(400).json({ 
                success: false, 
                message: 'Invalid or expired token' 
            });
        }

        if (Date.now() > tokenData.expires) {
            resetTokens.delete(token);
            return res.status(400).json({ 
                success: false, 
                message: 'Token has expired' 
            });
        }

        res.json({ 
            success: true, 
            email: tokenData.email 
        });

    } catch (error) {
        // Error verifying token
        res.status(500).json({ 
            success: false, 
            message: 'Error verifying token' 
        });
    }
});

// Reset password
app.post('/api/reset-password', async (req, res) => {
    try {
        const { token, newPassword } = req.body;

        if (!token || !newPassword) {
            return res.status(400).json({ 
                success: false, 
                message: 'Token and new password are required' 
            });
        }

        const tokenData = resetTokens.get(token);

        if (!tokenData) {
            return res.status(400).json({ 
                success: false, 
                message: 'Invalid or expired token' 
            });
        }

        if (Date.now() > tokenData.expires) {
            resetTokens.delete(token);
            return res.status(400).json({ 
                success: false, 
                message: 'Token has expired' 
            });
        }

        // Update password in database
        try {
            const pool = await sql.connect(dbConfig);
            
            // Hash the new password
            const hashedPassword = hashPassword(newPassword);
            
            // Update the password in the Patients table
            const result = await pool.request()
                .input('email', sql.NVarChar, tokenData.email)
                .input('password', sql.NVarChar, hashedPassword)
                .query('UPDATE Patients SET Password = @password WHERE Email = @email');
            
            if (result.rowsAffected[0] > 0) {
                // Remove the token after successful update
                resetTokens.delete(token);
                

                
                res.json({ 
                    success: true, 
                    message: 'Password reset successfully' 
                });
            } else {
                res.status(400).json({ 
                    success: false, 
                    message: 'Email not found in database' 
                });
            }
            
            await pool.close();
            
        } catch (dbError) {
            // Database error
            res.status(500).json({ 
                success: false, 
                message: 'Database error occurred' 
            });
        }

    } catch (error) {
        // Error resetting password
        res.status(500).json({ 
            success: false, 
            message: 'Error resetting password' 
        });
    }
});

// Send password reset success notification
app.post('/api/send-password-reset-notification', async (req, res) => {
    try {
        const { email, username } = req.body;

        if (!email) {
            return res.status(400).json({ 
                success: false, 
                message: 'Email is required' 
            });
        }

        // Email template for password reset success
        const mailOptions = {
            from: process.env.EMAIL_USER || 'your-email@gmail.com',
            to: email,
            subject: 'Password Reset Successful - Hospital Appointment System',
            html: `
                <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
                    <div style="background: linear-gradient(135deg, #28a745 0%, #20c997 100%); color: white; padding: 30px; text-align: center; border-radius: 10px 10px 0 0;">
                        <h1 style="margin: 0; font-size: 24px;">Password Reset Successful</h1>
                        <p style="margin: 10px 0 0 0; opacity: 0.9;">Hospital Appointment System</p>
                    </div>
                    
                    <div style="background: #f8f9fa; padding: 30px; border-radius: 0 0 10px 10px;">
                        <p style="color: #333; font-size: 16px; line-height: 1.6;">
                            Hello ${username || 'User'},<br><br>
                            Your password has been successfully reset for your Hospital Appointment System account.
                        </p>
                        
                        <div style="background: #d4edda; border: 1px solid #c3e6cb; border-radius: 8px; padding: 20px; margin: 20px 0;">
                            <h3 style="color: #155724; margin: 0 0 10px 0;">✅ Password Reset Complete</h3>
                            <p style="color: #155724; margin: 0; font-size: 14px;">
                                You can now log in to your account using your new password.
                            </p>
                        </div>
                        
                        <div style="text-align: center; margin: 30px 0;">
                            <a href="http://localhost:64931/pages/Login.aspx" 
                               style="background: linear-gradient(135deg, #28a745 0%, #20c997 100%); 
                                      color: white; 
                                      padding: 15px 30px; 
                                      text-decoration: none; 
                                      border-radius: 8px; 
                                      font-weight: bold; 
                                      display: inline-block;
                                      box-shadow: 0 4px 15px rgba(40, 167, 69, 0.3);">
                                Login to Your Account
                            </a>
                        </div>
                        
                        <p style="color: #666; font-size: 14px; line-height: 1.6;">
                            If you did not request this password reset, please contact our support team immediately.
                        </p>
                        
                        <div style="margin-top: 30px; padding-top: 20px; border-top: 1px solid #dee2e6;">
                            <p style="color: #999; font-size: 12px; margin: 0;">
                                This is an automated message. Please do not reply to this email.
                            </p>
                        </div>
                    </div>
                </div>
            `
        };

        // Send email
        await transporter.sendMail(mailOptions);

        res.json({ 
            success: true, 
            message: 'Password reset notification sent successfully' 
        });

    } catch (error) {
        // Error sending password reset notification
        res.status(500).json({ 
            success: false, 
            message: 'Failed to send password reset notification' 
        });
    }
});

// Send login notification
app.post('/api/send-login-notification', async (req, res) => {
    try {
        const { email, username, loginTime, ipAddress } = req.body;

        if (!email) {
            return res.status(400).json({ 
                success: false, 
                message: 'Email is required' 
            });
        }

        // Email template for login notification
        const mailOptions = {
            from: process.env.EMAIL_USER || 'your-email@gmail.com',
            to: email,
            subject: 'New Login Detected - Hospital Appointment System',
            html: `
                <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
                    <div style="background: linear-gradient(135deg, #007bff 0%, #0056b3 100%); color: white; padding: 30px; text-align: center; border-radius: 10px 10px 0 0;">
                        <h1 style="margin: 0; font-size: 24px;">New Login Detected</h1>
                        <p style="margin: 10px 0 0 0; opacity: 0.9;">Hospital Appointment System</p>
                    </div>
                    
                    <div style="background: #f8f9fa; padding: 30px; border-radius: 0 0 10px 10px;">
                        <p style="color: #333; font-size: 16px; line-height: 1.6;">
                            Hello ${username || 'User'},<br><br>
                            We detected a new login to your Hospital Appointment System account.
                        </p>
                        
                        <div style="background: #d1ecf1; border: 1px solid #bee5eb; border-radius: 8px; padding: 20px; margin: 20px 0;">
                            <h3 style="color: #0c5460; margin: 0 0 15px 0;">🔐 Login Details</h3>
                            <p style="color: #0c5460; margin: 5px 0; font-size: 14px;"><strong>Time:</strong> ${loginTime || new Date().toLocaleString()}</p>
                            <p style="color: #0c5460; margin: 5px 0; font-size: 14px;"><strong>IP Address:</strong> ${ipAddress || 'Unknown'}</p>
                            <p style="color: #0c5460; margin: 5px 0; font-size: 14px;"><strong>Account:</strong> ${email}</p>
                        </div>
                        
                        <div style="background: #fff3cd; border: 1px solid #ffeaa7; border-radius: 8px; padding: 20px; margin: 20px 0;">
                            <h3 style="color: #856404; margin: 0 0 10px 0;">⚠️ Security Notice</h3>
                            <p style="color: #856404; margin: 0; font-size: 14px;">
                                If this login was not authorized by you, please change your password immediately and contact our support team.
                            </p>
                        </div>
                        
                        <div style="text-align: center; margin: 30px 0;">
                            <a href="http://localhost:64931/pages/PasswordReset.aspx" 
                               style="background: linear-gradient(135deg, #dc3545 0%, #c82333 100%); 
                                      color: white; 
                                      padding: 15px 30px; 
                                      text-decoration: none; 
                                      border-radius: 8px; 
                                      font-weight: bold; 
                                      display: inline-block;
                                      box-shadow: 0 4px 15px rgba(220, 53, 69, 0.3);">
                                Change Password
                            </a>
                        </div>
                        
                        <p style="color: #666; font-size: 14px; line-height: 1.6;">
                            This notification helps keep your account secure by alerting you to any new login activity.
                        </p>
                        
                        <div style="margin-top: 30px; padding-top: 20px; border-top: 1px solid #dee2e6;">
                            <p style="color: #999; font-size: 12px; margin: 0;">
                                This is an automated security notification. Please do not reply to this email.
                            </p>
                        </div>
                    </div>
                </div>
            `
        };

        // Send email
        await transporter.sendMail(mailOptions);

        res.json({ 
            success: true, 
            message: 'Login notification sent successfully' 
        });

    } catch (error) {
        // Error sending login notification
        res.status(500).json({ 
            success: false, 
            message: 'Failed to send login notification' 
        });
    }
});

// Generic email sending endpoint
app.post('/api/send-email', async (req, res) => {
    try {
        const { to, subject, html } = req.body;

        if (!to || !subject || !html) {
            return res.status(400).json({ 
                success: false, 
                message: 'To, subject, and html are required' 
            });
        }

        // Email template
        const mailOptions = {
            from: process.env.EMAIL_USER || 'your-email@gmail.com',
            to: to,
            subject: subject,
            html: html
        };

        // Send email
        await transporter.sendMail(mailOptions);

        res.json({ 
            success: true, 
            message: 'Email sent successfully' 
        });

    } catch (error) {
        // Error sending email
        res.status(500).json({ 
            success: false, 
            message: 'Failed to send email' 
        });
    }
});

// Send OTP for account verification
app.post('/api/send-otp', async (req, res) => {
    try {
        const { email, username } = req.body;

        if (!email) {
            return res.status(400).json({ 
                success: false, 
                message: 'Email is required' 
            });
        }

        // Generate OTP code
        const otpCode = generateOTP();
        
        // Store OTP with email and username (expires in 10 minutes)
        otpCodes.set(otpCode, {
            email: email,
            username: username || '',
            expires: Date.now() + (10 * 60 * 1000) // 10 minutes
        });

        // Email template for OTP
        const mailOptions = {
            from: process.env.EMAIL_USER || 'your-email@gmail.com',
            to: email,
            subject: 'Account Verification - Hospital Appointment System',
            html: `
                <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
                    <div style="background: linear-gradient(135deg, #28a745 0%, #20c997 100%); color: white; padding: 30px; text-align: center; border-radius: 10px 10px 0 0;">
                        <h1 style="margin: 0; font-size: 24px;">Account Verification</h1>
                        <p style="margin: 10px 0 0 0; opacity: 0.9;">Hospital Appointment System</p>
                    </div>
                    
                    <div style="background: #f8f9fa; padding: 30px; border-radius: 0 0 10px 10px;">
                        <p style="color: #333; font-size: 16px; line-height: 1.6;">
                            Hello,<br><br>
                            Thank you for registering with the Hospital Appointment System. To complete your account creation, please use the verification code below:
                        </p>
                        
                        <div style="text-align: center; margin: 30px 0;">
                            <div style="background: #28a745; color: white; padding: 20px; border-radius: 10px; font-size: 32px; font-weight: bold; letter-spacing: 5px; display: inline-block; min-width: 200px;">
                                ${otpCode}
                            </div>
                        </div>
                        
                        <p style="color: #666; font-size: 14px; line-height: 1.6;">
                            This verification code will expire in 10 minutes for security reasons.
                            If you didn't create an account with us, please ignore this email.
                        </p>
                        
                        <div style="margin-top: 30px; padding-top: 20px; border-top: 1px solid #dee2e6;">
                            <p style="color: #999; font-size: 12px; margin: 0;">
                                For security reasons, never share this code with anyone.
                            </p>
                        </div>
                    </div>
                </div>
            `
        };

        // Send email
        await transporter.sendMail(mailOptions);

        res.json({ 
            success: true, 
            message: 'OTP sent successfully to your email' 
        });

    } catch (error) {
        // Error sending OTP
        res.status(500).json({ 
            success: false, 
            message: 'Failed to send OTP. Please try again later.' 
        });
    }
});

// Verify OTP for account creation
app.post('/api/verify-otp', (req, res) => {
    try {
        const { otp, email } = req.body;

        if (!otp || !email) {
            return res.status(400).json({ 
                success: false, 
                message: 'OTP and email are required' 
            });
        }

        const otpData = otpCodes.get(otp);

        if (!otpData) {
            return res.status(400).json({ 
                success: false, 
                message: 'Invalid OTP code' 
            });
        }

        if (otpData.email !== email) {
            return res.status(400).json({ 
                success: false, 
                message: 'OTP does not match the email address' 
            });
        }

        if (Date.now() > otpData.expires) {
            otpCodes.delete(otp);
            return res.status(400).json({ 
                success: false, 
                message: 'OTP has expired' 
            });
        }

        // OTP is valid - remove it from storage
        otpCodes.delete(otp);

        res.json({ 
            success: true, 
            message: 'OTP verified successfully',
            email: otpData.email,
            username: otpData.username
        });

    } catch (error) {
        // Error verifying OTP
        res.status(500).json({ 
            success: false, 
            message: 'Error verifying OTP' 
        });
    }
});

// Complete registration after OTP verification
app.post('/api/complete-registration', (req, res) => {
    try {
        const { firstName, lastName, email, phone, nationalID, dateOfBirth, password } = req.body;

        if (!firstName || !lastName || !email || !phone || !nationalID || !dateOfBirth || !password) {
            return res.status(400).json({ 
                success: false, 
                message: 'All registration fields are required' 
            });
        }

        // Here you would typically call your ASP.NET backend to complete the registration
        // For now, we'll just return success
        // In a real implementation, you would make an HTTP request to your ASP.NET API
        
        res.json({ 
            success: true, 
            message: 'Registration completed successfully',
            email: email
        });

    } catch (error) {
        // Error completing registration
        res.status(500).json({ 
            success: false, 
            message: 'Error completing registration' 
        });
    }
});

// Clean up expired tokens and OTP codes (run every hour)
setInterval(() => {
    const now = Date.now();
    
    // Clean up expired reset tokens
    for (const [token, data] of resetTokens.entries()) {
        if (now > data.expires) {
            resetTokens.delete(token);
        }
    }
    
    // Clean up expired OTP codes
    for (const [otp, data] of otpCodes.entries()) {
        if (now > data.expires) {
            otpCodes.delete(otp);
        }
    }
}, 60 * 60 * 1000); // 1 hour

// Health check endpoint
app.get('/api/health', (req, res) => {
    res.json({ 
        status: 'OK', 
        message: 'Email service is running',
        emailConfigured: !!(process.env.EMAIL_USER && process.env.EMAIL_PASS && 
                           process.env.EMAIL_USER !== 'your-email@gmail.com' && 
                           process.env.EMAIL_PASS !== 'your-16-digit-app-password')
    });
});

// Test email configuration endpoint
app.get('/api/test-email', async (req, res) => {
    try {
        if (!process.env.EMAIL_USER || !process.env.EMAIL_PASS || 
            process.env.EMAIL_USER === 'your-email@gmail.com' || 
            process.env.EMAIL_PASS === 'your-16-digit-app-password') {
            return res.status(400).json({
                success: false,
                message: 'Email not configured. Please update email-config.env with your Gmail credentials.'
            });
        }

        const testMailOptions = {
            from: process.env.EMAIL_USER,
            to: process.env.EMAIL_USER, // Send test email to yourself
            subject: 'Test Email - Hospital Appointment System',
            text: 'This is a test email to verify your email configuration is working correctly.'
        };

        await transporter.sendMail(testMailOptions);
        
        res.json({
            success: true,
            message: 'Test email sent successfully! Check your inbox.'
        });
    } catch (error) {
        // Test email error
        res.status(500).json({
            success: false,
            message: 'Failed to send test email: ' + error.message
        });
    }
});

app.listen(PORT, () => {

});
