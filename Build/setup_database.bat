@echo off
echo Setting up Hospital Appointment System Database...
echo.

REM Check if LocalDB is available
sqlcmd -S "(LocalDB)\MSSQLLocalDB" -Q "SELECT @@VERSION" >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: LocalDB is not available. Please install SQL Server LocalDB.
    pause
    exit /b 1
)

echo Creating database...
sqlcmd -S "(LocalDB)\MSSQLLocalDB" -Q "IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'HospitalDB') CREATE DATABASE HospitalDB"

echo Running database script...
sqlcmd -S "(LocalDB)\MSSQLLocalDB" -d "HospitalDB" -i "Database.sql"

if %errorlevel% equ 0 (
    echo.
    echo Database setup completed successfully!
    echo.
    echo Database is ready for production use.
    echo No sample data has been inserted.
    echo.
    echo You can now run the application and register new accounts.
) else (
    echo.
    echo ERROR: Database setup failed. Please check the error messages above.
)

pause
