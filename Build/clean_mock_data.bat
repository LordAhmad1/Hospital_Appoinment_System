@echo off
echo Cleaning mock data from Hospital Appointment System Database...
echo.

REM Check if LocalDB is available
sqlcmd -S "(LocalDB)\MSSQLLocalDB" -Q "SELECT @@VERSION" >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: LocalDB is not available. Please install SQL Server LocalDB.
    pause
    exit /b 1
)

echo Running cleanup script...
sqlcmd -S "(LocalDB)\MSSQLLocalDB" -d "HospitalDB" -i "Database/clean_mock_data.sql"

if %errorlevel% equ 0 (
    echo.
    echo Mock data cleanup completed successfully!
    echo.
    echo All sample data has been removed from the database.
    echo Database is now clean and ready for production use.
    echo.
    echo You can now register new accounts and add real data.
) else (
    echo.
    echo ERROR: Mock data cleanup failed. Please check the error messages above.
)

pause

