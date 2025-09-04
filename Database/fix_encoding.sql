-- Fix character encoding for Turkish names
USE HospitalDB;

-- Update patient names with proper Turkish characters
UPDATE Patients SET 
    FirstName = N'Ahmet',
    LastName = N'Yılmaz'
WHERE Email = 'ahmet.yilmaz@email.com';

UPDATE Patients SET 
    FirstName = N'Fatma',
    LastName = N'Demir'
WHERE Email = 'fatma.demir@email.com';

UPDATE Patients SET 
    FirstName = N'Mehmet',
    LastName = N'Kaya'
WHERE Email = 'mehmet.kaya@email.com';

UPDATE Patients SET 
    FirstName = N'Ayşe',
    LastName = N'Özkan'
WHERE Email = 'ayse.ozkan@email.com';

UPDATE Patients SET 
    FirstName = N'Ali',
    LastName = N'Çelik'
WHERE Email = 'ali.celik@email.com';

-- Verify the updates
SELECT Email, FirstName, LastName FROM Patients;
