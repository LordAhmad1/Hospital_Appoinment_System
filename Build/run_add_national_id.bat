@echo off
echo ========================================
echo Adding NationalID Column to Patients Table
echo ========================================
echo.

echo Running SQL script to add NationalID column...
sqlcmd -S "(LocalDB)\MSSQLLocalDB" -d HospitalDB -i add_national_id.sql

if %ERRORLEVEL% EQU 0 (
    echo.
    echo SUCCESS: NationalID column added to Patients table!
    echo.
    echo You can now register new users with National ID.
) else (
    echo.
    echo ERROR: Failed to add NationalID column.
    echo Please check that:
    echo 1. SQL Server LocalDB is installed
    echo 2. HospitalDB database exists
    echo 3. You have permission to modify the database
)

echo.
pause
