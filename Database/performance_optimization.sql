-- Performance Optimization Script for Hospital Appointment System
-- This script adds additional indexes and optimizations to improve application performance

USE HospitalDB;
GO

-- Add composite indexes for better query performance
CREATE INDEX IX_Appointments_PatientEmail_Status ON Appointments(PatientEmail, Status);
CREATE INDEX IX_Appointments_PatientEmail_Date ON Appointments(PatientEmail, AppointmentDate);
CREATE INDEX IX_Appointments_Date_Status ON Appointments(AppointmentDate, Status);
CREATE INDEX IX_BloodTests_PatientEmail_Status ON BloodTests(PatientEmail, Status);
CREATE INDEX IX_BloodTests_PatientEmail_Date ON BloodTests(PatientEmail, TestDate);

-- Add indexes for foreign key columns that are frequently used in JOINs
CREATE INDEX IX_Appointments_HospitalId ON Appointments(HospitalId);
CREATE INDEX IX_Appointments_DoctorId ON Appointments(DoctorId);
CREATE INDEX IX_BloodTests_HospitalId ON BloodTests(HospitalId);
CREATE INDEX IX_BloodTests_DoctorId ON BloodTests(DoctorId);

-- Add indexes for frequently filtered columns
CREATE INDEX IX_Appointments_Status ON Appointments(Status);
CREATE INDEX IX_BloodTests_Status ON BloodTests(Status);
CREATE INDEX IX_BloodTests_TestType ON BloodTests(TestType);

-- Add covering indexes for common queries
CREATE INDEX IX_Appointments_Covering ON Appointments(PatientEmail, AppointmentDate, Status) 
INCLUDE (Id, HospitalId, DoctorId, AppointmentTime, Notes, CreatedDate);

CREATE INDEX IX_BloodTests_Covering ON BloodTests(PatientEmail, TestDate, Status) 
INCLUDE (Id, HospitalId, DoctorId, TestName, TestType, Result, Unit, ReferenceRange, CreatedDate);

-- Update statistics for better query plan generation
UPDATE STATISTICS Appointments;
UPDATE STATISTICS BloodTests;
UPDATE STATISTICS Patients;
UPDATE STATISTICS Doctors;
UPDATE STATISTICS Hospitals;

-- Create a view for frequently accessed appointment data
CREATE VIEW vw_AppointmentDetails AS
SELECT 
    a.Id,
    a.PatientEmail,
    a.AppointmentDate,
    a.AppointmentTime,
    a.Status,
    a.Notes,
    a.CreatedDate,
    d.Name AS DoctorName,
    d.Specialization,
    h.Name AS HospitalName,
    h.City AS HospitalCity
FROM Appointments a
INNER JOIN Doctors d ON a.DoctorId = d.Id
INNER JOIN Hospitals h ON a.HospitalId = h.Id;

-- Create a view for frequently accessed blood test data
CREATE VIEW vw_BloodTestDetails AS
SELECT 
    bt.Id,
    bt.PatientEmail,
    bt.TestName,
    bt.TestType,
    bt.TestDate,
    bt.Result,
    bt.Unit,
    bt.ReferenceRange,
    bt.Status,
    bt.CreatedDate,
    d.Name AS DoctorName,
    h.Name AS HospitalName
FROM BloodTests bt
INNER JOIN Doctors d ON bt.DoctorId = d.Id
INNER JOIN Hospitals h ON bt.HospitalId = h.Id;

-- Create a stored procedure for getting patient statistics (more efficient than multiple queries)
CREATE PROCEDURE sp_GetPatientStatistics
    @PatientEmail NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        (SELECT COUNT(*) FROM Appointments WHERE PatientEmail = @PatientEmail) AS TotalAppointments,
        (SELECT COUNT(*) FROM Appointments WHERE PatientEmail = @PatientEmail AND AppointmentDate >= CAST(GETDATE() AS DATE) AND Status = 'Scheduled') AS UpcomingAppointments,
        (SELECT COUNT(*) FROM BloodTests WHERE PatientEmail = @PatientEmail) AS TotalBloodTests,
        (SELECT COUNT(DISTINCT HospitalId) FROM Appointments WHERE PatientEmail = @PatientEmail) AS TotalHospitals;
END;
GO

-- Create a stored procedure for getting recent appointments
CREATE PROCEDURE sp_GetRecentAppointments
    @PatientEmail NVARCHAR(100),
    @TopCount INT = 5
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT TOP (@TopCount)
        a.AppointmentDate,
        a.AppointmentTime,
        a.Status,
        d.Name AS DoctorName,
        h.Name AS HospitalName
    FROM Appointments a
    INNER JOIN Doctors d ON a.DoctorId = d.Id
    INNER JOIN Hospitals h ON a.HospitalId = h.Id
    WHERE a.PatientEmail = @PatientEmail
    ORDER BY a.AppointmentDate DESC, a.AppointmentTime;
END;
GO

-- Create a stored procedure for getting filtered appointments
CREATE PROCEDURE sp_GetFilteredAppointments
    @PatientEmail NVARCHAR(100),
    @Status NVARCHAR(20) = NULL,
    @HospitalId INT = NULL,
    @DateFrom DATE = NULL,
    @DateTo DATE = NULL,
    @PageNumber INT = 1,
    @PageSize INT = 10
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @Offset INT = (@PageNumber - 1) * @PageSize;
    
    DECLARE @SQL NVARCHAR(MAX) = N'
    SELECT a.Id, a.AppointmentDate, a.AppointmentTime, a.Status, a.Notes,
           d.Name AS DoctorName, h.Name AS HospitalName, d.Specialization
    FROM Appointments a 
    INNER JOIN Doctors d ON a.DoctorId = d.Id 
    INNER JOIN Hospitals h ON a.HospitalId = h.Id 
    WHERE a.PatientEmail = @Email';
    
    IF @Status IS NOT NULL
        SET @SQL = @SQL + N' AND a.Status = @Status';
    
    IF @HospitalId IS NOT NULL
        SET @SQL = @SQL + N' AND a.HospitalId = @HospitalId';
    
    IF @DateFrom IS NOT NULL
        SET @SQL = @SQL + N' AND a.AppointmentDate >= @DateFrom';
    
    IF @DateTo IS NOT NULL
        SET @SQL = @SQL + N' AND a.AppointmentDate <= @DateTo';
    
    SET @SQL = @SQL + N' ORDER BY a.AppointmentDate DESC, a.AppointmentTime
                       OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY';
    
    EXEC sp_executesql @SQL, 
         N'@Email NVARCHAR(100), @Status NVARCHAR(20), @HospitalId INT, @DateFrom DATE, @DateTo DATE, @Offset INT, @PageSize INT',
         @PatientEmail, @Status, @HospitalId, @DateFrom, @DateTo, @Offset, @PageSize;
END;
GO

PRINT 'Performance optimization completed successfully!';
PRINT 'Added indexes and stored procedures for better query performance.';
