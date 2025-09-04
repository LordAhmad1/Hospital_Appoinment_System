node server.js# =============================================
# DELETE ALL USERS FROM DATABASE - PowerShell
# =============================================
# This script will delete all users from the Patients table

Write-Host "============================================" -ForegroundColor Yellow
Write-Host "DELETE ALL USERS FROM DATABASE" -ForegroundColor Yellow
Write-Host "============================================" -ForegroundColor Yellow
Write-Host ""

Write-Host "WARNING: This will permanently delete ALL user data!" -ForegroundColor Red
Write-Host "Make sure you have a backup before proceeding." -ForegroundColor Red
Write-Host ""

$confirmation = Read-Host "Are you sure you want to delete ALL users? (yes/no)"
if ($confirmation -ne "yes") {
    Write-Host "İşlem iptal edildi." -ForegroundColor Yellow
    exit
}

# Database connection string
$connectionString = "Data Source=.\SQLEXPRESS;Initial Catalog=HospitalDB;Integrated Security=True"

try {
    # Load SQL Server assembly
    Add-Type -AssemblyName System.Data.SqlClient
    
    # Create connection
    $connection = New-Object System.Data.SqlClient.SqlConnection($connectionString)
    $connection.Open()
    
    Write-Host "Connected to database successfully." -ForegroundColor Green
    
    # First, let's see how many users we have
    $countQuery = "SELECT COUNT(*) AS TotalUsers FROM Patients"
    $countCommand = New-Object System.Data.SqlClient.SqlCommand($countQuery, $connection)
    $userCount = $countCommand.ExecuteScalar()
    
    Write-Host "Total users in database: $userCount" -ForegroundColor Cyan
    
    if ($userCount -eq 0) {
        Write-Host "No users found in database. Nothing to delete." -ForegroundColor Yellow
        $connection.Close()
        exit
    }
    
    # Show all users before deletion
    Write-Host "`nUsers that will be deleted:" -ForegroundColor Yellow
    $selectQuery = "SELECT PatientID, FirstName, LastName, Email, Phone, NationalID, DateOfBirth, CreatedDate, IsVerified FROM Patients ORDER BY CreatedDate DESC"
    $selectCommand = New-Object System.Data.SqlClient.SqlCommand($selectQuery, $connection)
    $reader = $selectCommand.ExecuteReader()
    
    while ($reader.Read()) {
        Write-Host "ID: $($reader['PatientID']) | Name: $($reader['FirstName']) $($reader['LastName']) | Email: $($reader['Email'])" -ForegroundColor White
    }
    $reader.Close()
    
    # Confirm deletion
    Write-Host "`n" -ForegroundColor Yellow
    $finalConfirmation = Read-Host "Do you want to proceed with deleting ALL $userCount users? (yes/no)"
    if ($finalConfirmation -ne "yes") {
        Write-Host "İşlem iptal edildi." -ForegroundColor Yellow
        $connection.Close()
        exit
    }
    
    # Delete all users
    Write-Host "`nDeleting all users..." -ForegroundColor Yellow
    $deleteQuery = "DELETE FROM Patients"
    $deleteCommand = New-Object System.Data.SqlClient.SqlCommand($deleteQuery, $connection)
    $rowsAffected = $deleteCommand.ExecuteNonQuery()
    
    Write-Host "Successfully deleted $rowsAffected users from the database." -ForegroundColor Green
    
    # Verify deletion
    $verifyQuery = "SELECT COUNT(*) AS RemainingUsers FROM Patients"
    $verifyCommand = New-Object System.Data.SqlClient.SqlCommand($verifyQuery, $connection)
    $remainingUsers = $verifyCommand.ExecuteScalar()
    
    Write-Host "Remaining users in database: $remainingUsers" -ForegroundColor Cyan
    
    if ($remainingUsers -eq 0) {
        Write-Host "All users have been successfully deleted!" -ForegroundColor Green
    } else {
        Write-Host "Warning: Some users may still remain in the database." -ForegroundColor Red
    }
    
    $connection.Close()
    
} catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Make sure SQL Server is running and the connection string is correct." -ForegroundColor Yellow
}

Write-Host "`nPress any key to exit..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
