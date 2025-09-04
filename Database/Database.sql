-- Hospital Appointment System Database Script
-- Create database tables for the hospital appointment system

-- Patients table
CREATE TABLE Patients (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100) UNIQUE NOT NULL,
    Phone NVARCHAR(20),
    DateOfBirth DATE,
    Password NVARCHAR(100) NOT NULL,
    CreatedDate DATETIME DEFAULT GETDATE()
);

-- Hospitals table
CREATE TABLE Hospitals (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    Address NVARCHAR(200),
    Phone NVARCHAR(20),
    Email NVARCHAR(100),
    City NVARCHAR(50),
    Rating DECIMAL(3,2) DEFAULT 0,
    Specializations NVARCHAR(500),
    CreatedDate DATETIME DEFAULT GETDATE()
);

-- Doctors table
CREATE TABLE Doctors (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    Specialization NVARCHAR(100) NOT NULL,
    HospitalId INT FOREIGN KEY REFERENCES Hospitals(Id),
    Phone NVARCHAR(20),
    Email NVARCHAR(100),
    CreatedDate DATETIME DEFAULT GETDATE()
);

-- Appointments table
CREATE TABLE Appointments (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    PatientEmail NVARCHAR(100) NOT NULL,
    HospitalId INT FOREIGN KEY REFERENCES Hospitals(Id),
    DoctorId INT FOREIGN KEY REFERENCES Doctors(Id),
    AppointmentDate DATE NOT NULL,
    AppointmentTime TIME NOT NULL,
    Status NVARCHAR(20) DEFAULT 'Scheduled', -- Scheduled, Completed, Cancelled
    Notes NVARCHAR(500),
    CreatedDate DATETIME DEFAULT GETDATE()
);

-- BloodTests table
CREATE TABLE BloodTests (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    PatientEmail NVARCHAR(100) NOT NULL,
    HospitalId INT FOREIGN KEY REFERENCES Hospitals(Id),
    DoctorId INT FOREIGN KEY REFERENCES Doctors(Id),
    TestName NVARCHAR(100) NOT NULL,
    TestType NVARCHAR(50),
    TestDate DATE NOT NULL,
    Result NVARCHAR(100),
    Unit NVARCHAR(20),
    ReferenceRange NVARCHAR(100),
    Status NVARCHAR(20) DEFAULT 'Pending', -- Normal, Abnormal, Pending
    CreatedDate DATETIME DEFAULT GETDATE()
);

-- Database is ready for production use
-- No sample data included

-- Password Reset Tokens table
CREATE TABLE PasswordResetTokens (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Email NVARCHAR(100) NOT NULL,
    Token NVARCHAR(100) NOT NULL,
    ExpiryDate DATETIME NOT NULL,
    IsUsed BIT DEFAULT 0,
    CreatedDate DATETIME DEFAULT GETDATE()
);

-- Create indexes for better performance
CREATE INDEX IX_Patients_Email ON Patients(Email);
CREATE INDEX IX_Appointments_PatientEmail ON Appointments(PatientEmail);
CREATE INDEX IX_Appointments_Date ON Appointments(AppointmentDate);
CREATE INDEX IX_BloodTests_PatientEmail ON BloodTests(PatientEmail);
CREATE INDEX IX_Doctors_HospitalId ON Doctors(HospitalId);
CREATE INDEX IX_Doctors_Specialization ON Doctors(Specialization);
CREATE INDEX IX_PasswordResetTokens_Email ON PasswordResetTokens(Email);
CREATE INDEX IX_PasswordResetTokens_Token ON PasswordResetTokens(Token);
