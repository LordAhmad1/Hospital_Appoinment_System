@echo off
echo ============================================
echo VIEW ALL USERS IN DATABASE
echo ============================================
echo.
echo This will show you all users before deletion.
echo.
pause
echo.
echo Running SQL script to view all users...
echo.

sqlcmd -S .\SQLEXPRESS -E -i "view_users_before_deletion.sql"

echo.
echo Review the data above.
echo If you want to delete all users, run delete_all_users.bat
echo.
pause
