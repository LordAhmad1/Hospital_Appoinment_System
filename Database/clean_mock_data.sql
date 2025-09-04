-- Clean Mock Data Script
-- This script removes all sample/mock data from the database

USE HospitalDB;
GO

-- Delete all sample data
DELETE FROM BloodTests;
DELETE FROM Appointments;
DELETE FROM Patients;
DELETE FROM Doctors;
DELETE FROM Hospitals;

-- Reset identity columns to start from 1
DBCC CHECKIDENT ('BloodTests', RESEED, 0);
DBCC CHECKIDENT ('Appointments', RESEED, 0);
DBCC CHECKIDENT ('Patients', RESEED, 0);
DBCC CHECKIDENT ('Doctors', RESEED, 0);
DBCC CHECKIDENT ('Hospitals', RESEED, 0);

-- Clear any password reset tokens
DELETE FROM PasswordResetTokens;
DBCC CHECKIDENT ('PasswordResetTokens', RESEED, 0);

-- Clear any OTP data
DELETE FROM PasswordResetOTP;
DBCC CHECKIDENT ('PasswordResetOTP', RESEED, 0);

PRINT 'All mock data has been removed from the database.';
PRINT 'Database is now clean and ready for production use.';
GO

