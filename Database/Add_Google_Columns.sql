-- Add Google Authentication columns to Patients table
USE HospitalDB;

-- Add GoogleUID column
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Patients' AND COLUMN_NAME = 'GoogleUID')
BEGIN
    ALTER TABLE Patients ADD GoogleUID NVARCHAR(255) NULL;
    PRINT 'Added GoogleUID column to Patients table';
END
ELSE
BEGIN
    PRINT 'GoogleUID column already exists in Patients table';
END

-- Add GooglePhotoURL column
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Patients' AND COLUMN_NAME = 'GooglePhotoURL')
BEGIN
    ALTER TABLE Patients ADD GooglePhotoURL NVARCHAR(500) NULL;
    PRINT 'Added GooglePhotoURL column to Patients table';
END
ELSE
BEGIN
    PRINT 'GooglePhotoURL column already exists in Patients table';
END

-- Add CreatedDate column if it doesn't exist
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Patients' AND COLUMN_NAME = 'CreatedDate')
BEGIN
    ALTER TABLE Patients ADD CreatedDate DATETIME DEFAULT GETDATE();
    PRINT 'Added CreatedDate column to Patients table';
END
ELSE
BEGIN
    PRINT 'CreatedDate column already exists in Patients table';
END

-- Create index on GoogleUID for better performance
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Patients_GoogleUID')
BEGIN
    CREATE INDEX IX_Patients_GoogleUID ON Patients(GoogleUID);
    PRINT 'Created index on GoogleUID column';
END
ELSE
BEGIN
    PRINT 'Index on GoogleUID already exists';
END

PRINT 'Google Authentication setup completed successfully!';
