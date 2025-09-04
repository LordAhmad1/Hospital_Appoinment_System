-- Add Phone column to Patients table if it doesn't exist
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Patients' AND COLUMN_NAME = 'Phone')
BEGIN
    ALTER TABLE Patients ADD Phone NVARCHAR(20) NULL;
    PRINT 'Phone column added to Patients table';
END
ELSE
BEGIN
    PRINT 'Phone column already exists in Patients table';
END
