@echo off
echo Testing Hospital Appointment System Login...
echo.

echo 1. Testing database connection...
sqlcmd -S "(LocalDB)\MSSQLLocalDB" -d "HospitalDB" -Q "SELECT Email, FirstName, LastName FROM Patients WHERE Email = 'fatma.demir@email.com'"

echo.
echo 2. Testing password verification...
sqlcmd -S "(LocalDB)\MSSQLLocalDB" -d "HospitalDB" -Q "SELECT COUNT(*) FROM Patients WHERE Email = 'fatma.demir@email.com' AND Password = '123456'"

echo.
echo 3. All demo accounts:
sqlcmd -S "(LocalDB)\MSSQLLocalDB" -d "HospitalDB" -Q "SELECT Email, FirstName, LastName FROM Patients"

echo.
echo Test completed. If you see user data above, the database is working correctly.
echo You can now try logging in with: fatma.demir@email.com / 123456
pause
