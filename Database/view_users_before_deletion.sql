-- =============================================
-- VIEW ALL USERS BEFORE DELETION
-- =============================================
-- This script shows you all users in the database
-- Run this first to see what will be deleted

USE HospitalDB;
GO

-- Show total count
SELECT COUNT(*) AS TotalUsers FROM Patients;
GO

-- Show all users with their details
SELECT 
    PatientID,
    FirstName,
    LastName,
    Email,
    Phone,
    NationalID,
    DateOfBirth,
    CreatedDate,
    IsVerified,
    'Will be deleted' AS Status
FROM Patients
ORDER BY CreatedDate DESC;
GO

PRINT 'Review the data above before running the deletion script.';
PRINT 'If you want to proceed with deletion, run delete_all_users.sql';
GO
