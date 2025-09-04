-- =============================================
-- Create EmailNotifications Table for Security Email Tracking
-- =============================================

USE HospitalDB;
GO

-- Create EmailNotifications table if it doesn't exist
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'EmailNotifications')
BEGIN
    CREATE TABLE EmailNotifications (
        Id INT PRIMARY KEY IDENTITY(1,1),
        UserEmail NVARCHAR(255) NOT NULL,
        NotificationType NVARCHAR(100) NOT NULL, -- 'LoginNotification', 'PasswordChangeNotification'
        Status NVARCHAR(50) NOT NULL, -- 'Success', 'Failed'
        Details NVARCHAR(1000) NULL,
        SentAt DATETIME NOT NULL DEFAULT GETDATE()
    );
    PRINT 'EmailNotifications table created successfully';
END
ELSE
BEGIN
    PRINT 'EmailNotifications table already exists';
END

-- Create indexes for better performance
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_EmailNotifications_UserEmail' AND object_id = OBJECT_ID('EmailNotifications'))
BEGIN
    CREATE INDEX IX_EmailNotifications_UserEmail ON EmailNotifications(UserEmail);
    PRINT 'Index created on EmailNotifications.UserEmail';
END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_EmailNotifications_NotificationType' AND object_id = OBJECT_ID('EmailNotifications'))
BEGIN
    CREATE INDEX IX_EmailNotifications_NotificationType ON EmailNotifications(NotificationType);
    PRINT 'Index created on EmailNotifications.NotificationType';
END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_EmailNotifications_SentAt' AND object_id = OBJECT_ID('EmailNotifications'))
BEGIN
    CREATE INDEX IX_EmailNotifications_SentAt ON EmailNotifications(SentAt);
    PRINT 'Index created on EmailNotifications.SentAt';
END

GO

-- Verify table creation
SELECT 'EmailNotifications table created successfully!' AS Status;
SELECT COUNT(*) AS TableCount FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'EmailNotifications';

-- Show table structure
EXEC sp_help 'EmailNotifications';

GO
