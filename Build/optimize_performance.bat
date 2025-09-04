@echo off
echo ========================================
echo Hospital Appointment System
echo Performance Optimization Script
echo ========================================
echo.

echo Checking if LocalDB is available...
sqlcmd -S "(LocalDB)\MSSQLLocalDB" -Q "SELECT @@VERSION" >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: LocalDB is not available or not running.
    echo Please make sure SQL Server LocalDB is installed and running.
    echo.
    pause
    exit /b 1
)

echo LocalDB is available. Running performance optimization...
echo.

echo Executing performance optimization script...
sqlcmd -S "(LocalDB)\MSSQLLocalDB" -d "HospitalDB" -i "performance_optimization.sql"

if %errorlevel% equ 0 (
    echo.
    echo ========================================
    echo Performance optimization completed successfully!
    echo ========================================
    echo.
    echo The following optimizations have been applied:
    echo - Added composite indexes for better query performance
    echo - Added covering indexes for common queries
    echo - Created database views for frequently accessed data
    echo - Created stored procedures for optimized queries
    echo - Updated database statistics
    echo.
    echo Your application should now run faster!
    echo.
) else (
    echo.
    echo ERROR: Performance optimization failed.
    echo Please check the error messages above.
    echo.
)

pause
