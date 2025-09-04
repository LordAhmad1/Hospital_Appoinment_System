-- =============================================
-- DELETE ALL USERS FROM PATIENTS TABLE
-- =============================================
-- WARNING: This will permanently delete ALL user data!
-- Make sure you have a backup before running this script.

USE HospitalDB;
GO

-- First, let's see how many users we have
SELECT COUNT(*) AS TotalUsers FROM Patients;
GO

-- Show all users before deletion (for reference)
SELECT 
    PatientID,
    FirstName,
    LastName,
    Email,
    Phone,
    NationalID,
    DateOfBirth,
    CreatedDate,
    IsVerified
FROM Patients
ORDER BY CreatedDate DESC;
GO

-- Delete all users from the Patients table
DELETE FROM Patients;
GO

-- Verify deletion
SELECT COUNT(*) AS RemainingUsers FROM Patients;
GO

-- Reset the identity column (optional - only if you want to start fresh)
-- DBCC CHECKIDENT ('Patients', RESEED, 0);
-- GO

PRINT 'All users have been deleted from the Patients table.';
PRINT 'The table is now empty.';
GO
