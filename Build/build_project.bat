@echo off
echo ========================================
echo Building Hospital Appointment System
echo ========================================
echo.

echo This will create the HospitalAppointmentSystem.dll file
echo.

echo Step 1: Opening Visual Studio...
start "" "appoinmentsystem.sln"

echo.
echo ========================================
echo Manual Steps Required:
echo ========================================
echo 1. Wait for Visual Studio to open
echo 2. Right-click on "HospitalAppointmentSystem" in Solution Explorer
echo 3. Select "Set as Startup Project"
echo 4. Press Ctrl+Shift+B to build the solution
echo 5. Check the Output window for "Build succeeded"
echo 6. The DLL will be created in the bin\ folder
echo.

echo ========================================
echo Expected Result:
echo ========================================
echo After successful build, you should see:
echo - bin\HospitalAppointmentSystem.dll
echo - bin\HospitalAppointmentSystem.pdb
echo.

echo ========================================
echo Troubleshooting:
echo ========================================
echo If build fails:
echo - Check Error List window for errors
echo - Clean solution (Build -^> Clean Solution)
echo - Rebuild solution (Build -^> Rebuild Solution)
echo.

pause
