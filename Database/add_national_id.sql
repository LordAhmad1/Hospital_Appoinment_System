-- Add NationalID column to Patients table
USE HospitalDB;
GO

-- Add NationalID column (nullable initially)
ALTER TABLE Patients ADD NationalID NVARCHAR(20);

-- Add index for better performance
CREATE INDEX IX_Patients_NationalID ON Patients(NationalID);

-- Update existing records with a default value (optional)
-- UPDATE Patients SET NationalID = 'TEMP_' + CAST(Id AS NVARCHAR(10)) WHERE NationalID IS NULL;

-- Add unique constraint on NationalID (only for non-null values)
-- Note: We'll make it nullable to avoid issues with existing data
-- ALTER TABLE Patients ADD CONSTRAINT UQ_Patients_NationalID UNIQUE (NationalID);

PRINT 'NationalID column added successfully to Patients table.';
PRINT 'Note: Column is nullable to avoid issues with existing data.';
