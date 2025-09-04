@echo off
echo ============================================
echo DELETE ALL USERS FROM DATABASE
echo ============================================
echo.
echo WARNING: This will permanently delete ALL user data!
echo Make sure you have a backup before proceeding.
echo.
pause
echo.
echo Running SQL script to delete all users...
echo.

sqlcmd -S .\SQLEXPRESS -E -i "delete_all_users.sql"

echo.
echo Script execution completed.
echo Check the output above for results.
echo.
pause
