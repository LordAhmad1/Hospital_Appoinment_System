-- Create PasswordResetOTP table for storing OTP codes
CREATE TABLE PasswordResetOTP (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    Email NVARCHAR(255) NOT NULL,
    OTP NVARCHAR(10) NOT NULL,
    CreatedAt DATETIME NOT NULL,
    ExpiresAt DATETIME NOT NULL,
    IsUsed BIT DEFAULT 0
);

-- Create index for faster lookups
CREATE INDEX IX_PasswordResetOTP_Email ON PasswordResetOTP(Email);
CREATE INDEX IX_PasswordResetOTP_ExpiresAt ON PasswordResetOTP(ExpiresAt);

-- Clean up expired OTPs (optional - you can run this periodically)
-- DELETE FROM PasswordResetOTP WHERE ExpiresAt < GETDATE();
