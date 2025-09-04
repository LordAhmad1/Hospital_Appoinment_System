-- =============================================
-- Create PasswordResetOTP Table for OTP System
-- =============================================

USE HospitalDB;
GO

-- Create PasswordResetOTP table if it doesn't exist
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'PasswordResetOTP')
BEGIN
    CREATE TABLE PasswordResetOTP (
        Id INT PRIMARY KEY IDENTITY(1,1),
        Email NVARCHAR(255) NOT NULL,
        OTP NVARCHAR(10) NOT NULL,
        CreatedAt DATETIME NOT NULL,
        ExpiresAt DATETIME NOT NULL
    );
    PRINT 'PasswordResetOTP table created successfully';
END
ELSE
BEGIN
    PRINT 'PasswordResetOTP table already exists';
END

-- Create index on Email for better performance
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_PasswordResetOTP_Email' AND object_id = OBJECT_ID('PasswordResetOTP'))
BEGIN
    CREATE INDEX IX_PasswordResetOTP_Email ON PasswordResetOTP(Email);
    PRINT 'Index created on PasswordResetOTP.Email';
END
ELSE
BEGIN
    PRINT 'Index on PasswordResetOTP.Email already exists';
END

-- Create indexes for better performance
CREATE INDEX IX_PasswordResetOTP_ExpiresAt ON PasswordResetOTP(ExpiresAt);
CREATE INDEX IX_PasswordResetOTP_Email_OTP ON PasswordResetOTP(Email, OTP);
GO

-- Insert test data (optional - for testing)
-- INSERT INTO PasswordResetOTP (Email, OTP, CreatedAt, ExpiresAt) 
-- VALUES ('test@example.com', '123456', GETDATE(), DATEADD(MINUTE, 10, GETDATE()));
GO

-- Verify table creation
SELECT 'PasswordResetOTP table created successfully!' AS Status;
SELECT COUNT(*) AS TableCount FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'PasswordResetOTP';
GO

-- Show table structure
EXEC sp_help 'PasswordResetOTP';
GO
