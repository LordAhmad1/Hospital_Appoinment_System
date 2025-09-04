@echo off
echo ========================================
echo Checking Patients Table Structure
echo ========================================
echo.

echo Checking if NationalID column exists in Patients table...
sqlcmd -S "(LocalDB)\MSSQLLocalDB" -d HospitalDB -Q "SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Patients' ORDER BY ORDINAL_POSITION"

echo.
echo ========================================
echo Checking sample data in Patients table
echo ========================================
echo.

sqlcmd -S "(LocalDB)\MSSQLLocalDB" -d HospitalDB -Q "SELECT TOP 3 Id, FirstName, LastName, Email, Phone, NationalID, DateOfBirth FROM Patients"

echo.
pause
