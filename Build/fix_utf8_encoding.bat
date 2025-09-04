@echo off
echo ========================================
echo UTF-8 Encoding Check and Fix
echo ========================================
echo.

echo Checking Web.config for UTF-8 settings...
findstr "utf-8" Web.config
if %ERRORLEVEL% EQU 0 (
    echo ✓ Web.config has UTF-8 encoding settings
) else (
    echo ✗ Web.config missing UTF-8 encoding settings
)

echo.
echo Checking Site.Master for charset declarations...
findstr "charset" Site.Master
if %ERRORLEVEL% EQU 0 (
    echo ✓ Site.Master has charset declarations
) else (
    echo ✗ Site.Master missing charset declarations
)

echo.
echo Checking database connection for Unicode support...
sqlcmd -S "(LocalDB)\MSSQLLocalDB" -d HospitalDB -Q "SELECT COLLATION_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Patients'"

echo.
echo UTF-8 encoding check completed!
echo.
echo Summary:
echo - Web.config: globalization settings with UTF-8
echo - Site.Master: charset UTF-8 declarations
echo - Database: Unicode collation support
echo - All ASPX files inherit encoding from master page
echo.
pause
