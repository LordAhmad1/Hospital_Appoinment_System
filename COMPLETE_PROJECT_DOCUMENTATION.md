# Hospital Appointment System - Complete Documentation

## Table of Contents
1. [Project Overview](#project-overview)
2. [System Architecture](#system-architecture)
3. [Technology Stack](#technology-stack)
4. [Database Structure](#database-structure)
5. [API Endpoints](#api-endpoints)
6. [Pages and Features](#pages-and-features)
7. [Authentication & Security](#authentication--security)
8. [Email System](#email-system)
9. [UI/UX Design](#uiux-design)
10. [Mobile Responsiveness](#mobile-responsiveness)
11. [File Structure](#file-structure)
12. [Setup Instructions](#setup-instructions)
13. [Configuration](#configuration)
14. [Recent Changes](#recent-changes)
15. [Troubleshooting](#troubleshooting)

## Project Overview

The Hospital Appointment System is a comprehensive web application designed for managing hospital appointments, patient records, blood test results, and hospital information. The system provides a modern, responsive interface for both patients and administrators.

### Key Features
- User registration and authentication
- Appointment booking and management
- Blood test results tracking
- Hospital directory and information
- Profile management
- Email notifications
- Mobile-responsive design
- Multi-language support (Turkish/Arabic)

## System Architecture

The application follows a hybrid architecture combining:
- **Frontend**: ASP.NET WebForms with Bootstrap 5
- **Backend**: ASP.NET WebForms (C#) + Node.js (Express)
- **Database**: SQL Server LocalDB
- **Email Service**: Nodemailer (Node.js)

### Architecture Diagram
```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Web Browser   │────│  ASP.NET Pages  │────│   SQL Server    │
│   (Frontend)    │    │   (WebForms)    │    │   (LocalDB)     │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │
         │                       │
         │              ┌─────────────────┐
         └──────────────│   Node.js API   │
                        │   (Express)     │
                        └─────────────────┘
                                 │
                        ┌─────────────────┐
                        │   Nodemailer    │
                        │  (Email Service)│
                        └─────────────────┘
```

## Technology Stack

### Frontend Technologies
- **ASP.NET WebForms**: Server-side web framework
- **Bootstrap 5.3.2**: CSS framework for responsive design
- **Font Awesome 6.4.0**: Icon library
- **jQuery 3.7.1**: JavaScript library
- **Vanilla JavaScript**: Custom functionality
- **CSS3**: Custom styling with animations

### Backend Technologies
- **ASP.NET WebForms (C#)**: Main application logic
- **Node.js**: Email service and API endpoints
- **Express.js**: Web framework for Node.js
- **Nodemailer**: Email sending library

### Database
- **SQL Server LocalDB**: Local database instance
- **T-SQL**: Database queries and procedures

### Development Tools
- **Visual Studio**: IDE for ASP.NET development
- **SQL Server Management Studio**: Database management
- **Git**: Version control

## Database Structure

### Tables

#### Patients Table
```sql
CREATE TABLE Patients (
    PatientID int IDENTITY(1,1) PRIMARY KEY,
    FirstName nvarchar(50) NOT NULL,
    LastName nvarchar(50) NOT NULL,
    Email nvarchar(100) UNIQUE NOT NULL,
    Password nvarchar(255) NOT NULL,
    Phone nvarchar(20),
    NationalID nvarchar(20),
    DateOfBirth date,
    Gender nvarchar(10),
    Address nvarchar(255),
    RegistrationDate datetime DEFAULT GETDATE(),
    IsEmailVerified bit DEFAULT 0
);
```

#### Hospitals Table
```sql
CREATE TABLE Hospitals (
    HospitalID int IDENTITY(1,1) PRIMARY KEY,
    Name nvarchar(100) NOT NULL,
    Address nvarchar(255),
    Phone nvarchar(20),
    Email nvarchar(100),
    Website nvarchar(100),
    Description ntext,
    ImageURL nvarchar(255),
    Specialties nvarchar(500),
    CreatedDate datetime DEFAULT GETDATE()
);
```

#### Appointments Table
```sql
CREATE TABLE Appointments (
    AppointmentID int IDENTITY(1,1) PRIMARY KEY,
    PatientID int FOREIGN KEY REFERENCES Patients(PatientID),
    HospitalID int FOREIGN KEY REFERENCES Hospitals(HospitalID),
    DoctorName nvarchar(100),
    AppointmentDate datetime NOT NULL,
    AppointmentTime time NOT NULL,
    Status nvarchar(20) DEFAULT 'Scheduled',
    Notes ntext,
    CreatedDate datetime DEFAULT GETDATE()
);
```

#### BloodTests Table
```sql
CREATE TABLE BloodTests (
    TestID int IDENTITY(1,1) PRIMARY KEY,
    PatientID int FOREIGN KEY REFERENCES Patients(PatientID),
    TestName nvarchar(100) NOT NULL,
    TestDate datetime NOT NULL,
    Result nvarchar(50),
    NormalRange nvarchar(50),
    Status nvarchar(20) DEFAULT 'Pending',
    Notes ntext,
    CreatedDate datetime DEFAULT GETDATE()
);
```

#### PasswordResetOTP Table
```sql
CREATE TABLE PasswordResetOTP (
    ID int IDENTITY(1,1) PRIMARY KEY,
    Email nvarchar(100) NOT NULL,
    OTP nvarchar(10) NOT NULL,
    ExpiryTime datetime NOT NULL,
    IsUsed bit DEFAULT 0,
    CreatedDate datetime DEFAULT GETDATE()
);
```

## API Endpoints

### Node.js API Endpoints (Port 3000)

#### Authentication & Password Reset
- `POST /api/send-reset-email` - Send password reset email
- `POST /api/verify-reset-token` - Verify password reset token
- `POST /api/reset-password` - Reset user password

#### Email Notifications
- `POST /api/send-password-reset-notification` - Send password reset success notification
- `POST /api/send-login-notification` - Send login notification
- `POST /api/send-email` - Generic email sending endpoint

#### OTP Verification
- `POST /api/send-otp` - Send OTP for account verification
- `POST /api/verify-otp` - Verify OTP code
- `POST /api/complete-registration` - Complete user registration

#### Testing
- `POST /api/test-email` - Test email configuration

### Request/Response Examples

#### Send Password Reset Email
```javascript
// Request
POST /api/send-reset-email
{
    "email": "user@example.com"
}

// Response
{
    "success": true,
    "message": "Password reset email sent successfully"
}
```

#### Verify Reset Token
```javascript
// Request
POST /api/verify-reset-token
{
    "token": "abc123def456"
}

// Response
{
    "success": true,
    "email": "user@example.com"
}
```

## Pages and Features

### Authentication Pages

#### Login Page (`/Pages/Login.aspx`)
- **Features**: User authentication, remember me, password reset link
- **Validation**: Email format, password requirements
- **Security**: Password hashing (SHA256), session management
- **Notifications**: Login success notifications via email

#### Register Page (`/Pages/Register.aspx`)
- **Features**: New user registration, form validation
- **Fields**: First name, last name, email, password, phone, national ID
- **Validation**: Email uniqueness, password strength, required fields
- **Process**: OTP verification required for account activation

#### Password Reset Pages
- **PasswordReset.aspx**: Request password reset
- **ResetPassword.aspx**: Complete password reset with token
- **Features**: Email-based reset, secure token validation

### Main Application Pages

#### Dashboard (`/Pages/Dashboard.aspx`)
- **Features**: Welcome section, statistics cards, quick actions, recent appointments, notifications
- **Design**: Modern card-based layout with animations
- **Responsive**: Mobile-optimized grid system

#### Appointments (`/Pages/Appointments.aspx`)
- **Features**: View appointments, book new appointments, filter by status
- **Functionality**: Time slot selection, appointment management
- **Status**: Scheduled, completed, cancelled

#### Blood Tests (`/Pages/BloodTests.aspx`)
- **Features**: View test results, filter by status/date
- **Results**: Normal, abnormal, pending status indicators
- **Design**: Color-coded result cards

#### Hospitals (`/Pages/Hospitals.aspx`)
- **Features**: Hospital directory, search functionality, detailed information
- **Information**: Contact details, specialties, descriptions
- **Design**: Card-based layout with hospital images

#### Profile (`/Pages/Profile.aspx`)
- **Features**: View and edit personal information
- **Fields**: Name, phone, national ID (email removed as requested)
- **Security**: Profile photo upload removed as requested
- **Design**: Modern profile layout with statistics

### Utility Pages

#### OTP Verification (`/Pages/OTPVerification.aspx`)
- **Purpose**: Verify email address during registration
- **Features**: OTP input, resend functionality, countdown timer

#### Language Switcher (`/Pages/LanguageSwitcher.aspx`)
- **Purpose**: Switch between Turkish and Arabic languages
- **Note**: Translation dropdown removed from sidebar as requested

## Authentication & Security

### Password Security
- **Hashing**: SHA256 (demo purposes - production should use BCrypt/PBKDF2)
- **Requirements**: Minimum 6 characters
- **Reset**: Secure token-based password reset

### Session Management
- **Storage**: sessionStorage for client-side user data
- **Data**: User name, email, authentication status
- **Security**: Automatic logout on session expiry

### Input Validation
- **Client-side**: JavaScript validation for immediate feedback
- **Server-side**: C# validation for security
- **Protection**: SQL injection prevention with parameterized queries

### Email Verification
- **Process**: OTP-based email verification during registration
- **Security**: Time-limited OTP codes
- **Database**: OTP storage with expiry tracking

## Email System

### Email Configuration
- **Service**: Nodemailer with Gmail SMTP
- **Configuration**: Environment variables for credentials
- **Security**: OAuth2 or app-specific passwords

### Email Templates

#### Password Reset Email
```html
Subject: Password Reset Request - Hospital Appointment System
Content: Professional HTML template with reset link and security information
```

#### Login Notification
```html
Subject: New Login Detected - Hospital Appointment System
Content: Security notification with login details and IP information
```

#### Password Reset Success
```html
Subject: Password Reset Successful - Hospital Appointment System
Content: Confirmation of successful password reset
```

### Email Features
- **HTML Templates**: Professional email designs
- **Personalization**: User name and email customization
- **Security**: Login notifications with IP tracking
- **Reliability**: Error handling and retry mechanisms

## UI/UX Design

### Design Principles
- **Modern**: Clean, contemporary interface design
- **Responsive**: Mobile-first approach with Bootstrap grid
- **Accessible**: High contrast, readable fonts, keyboard navigation
- **Consistent**: Unified color scheme and component styling

### Color Scheme
- **Primary**: Blue gradients (#007bff, #0056b3)
- **Secondary**: Gray tones (#6c757d, #495057)
- **Success**: Green (#28a745)
- **Danger**: Red (#dc3545)
- **Warning**: Orange (#ffc107)
- **Info**: Light blue (#17a2b8)

### Typography
- **Font Family**: System fonts (Segoe UI, Arial, sans-serif)
- **Headings**: Bold, hierarchical sizing
- **Body Text**: Readable, appropriate line height
- **Icons**: Font Awesome 6.4.0

### Components

#### Cards
- **Design**: Rounded corners, subtle shadows, hover effects
- **Animation**: Smooth transitions and floating effects
- **Content**: Structured information with icons

#### Buttons
- **Styles**: Primary, secondary, outline variants
- **States**: Hover, active, disabled states
- **Icons**: Font Awesome icons for better UX

#### Forms
- **Layout**: Bootstrap form components
- **Validation**: Real-time feedback with color coding
- **Accessibility**: Proper labels and ARIA attributes

### Animations
- **CSS Animations**: Smooth transitions, floating effects
- **Hover Effects**: Interactive feedback on user actions
- **Loading States**: Visual feedback during operations

## Mobile Responsiveness

### Breakpoints
- **Mobile**: < 576px
- **Tablet**: 576px - 991.98px
- **Desktop**: ≥ 992px

### Mobile Features

#### Sidebar
- **Behavior**: Slide-in from left on mobile
- **Toggle**: Hamburger menu button
- **Overlay**: Dark overlay when sidebar is open
- **Gestures**: Tap outside to close, escape key support

#### Navigation
- **Collapsible**: Mobile-friendly navigation menu
- **Touch-friendly**: Large tap targets
- **Accessibility**: Keyboard navigation support

#### Forms
- **Responsive**: Stacked layout on mobile
- **Input Types**: Appropriate mobile input types
- **Validation**: Mobile-friendly error messages

### Mobile Optimizations
- **Performance**: Optimized images and CSS
- **Touch**: Touch-friendly interface elements
- **Viewport**: Proper viewport meta tag
- **Scrolling**: Smooth scrolling behavior

## File Structure

```
AhmadProject/
├── App_Code/                          # C# helper classes
│   ├── ApiController.cs               # API communication
│   ├── EmailHelper.cs                 # Email utilities
│   ├── InputProtection.cs             # Input validation
│   ├── JwtHelper.cs                   # JWT token handling
│   ├── SecurityEmailService.cs        # Security email service
│   └── TranslationHelper.cs           # Translation utilities
├── Build/                             # Build and setup scripts
│   ├── build_project.bat              # Project build script
│   ├── check_database_structure.bat   # Database validation
│   ├── fix_utf8_encoding.bat          # Encoding fixes
│   ├── optimize_performance.bat       # Performance optimization
│   ├── run_add_national_id.bat        # National ID setup
│   ├── setup_database.bat             # Database setup
│   └── start_project.bat              # Project startup
├── Database/                          # Database scripts
│   ├── Database.sql                   # Main database schema
│   ├── Add_Google_Columns.sql         # Google integration
│   ├── add_national_id.sql            # National ID column
│   ├── Add_Phone_Column.sql           # Phone column
│   ├── Create_OTP_Table.sql           # OTP table creation
│   ├── EmailNotifications.sql         # Email notification setup
│   ├── PasswordResetOTP.sql           # Password reset OTP
│   ├── performance_optimization.sql   # Performance improvements
│   └── clean_mock_data.sql            # Mock data cleanup
├── Images/                            # Application images
├── Pages/                             # ASP.NET pages
│   ├── Dashboard.aspx                 # Main dashboard
│   ├── Appointments.aspx              # Appointment management
│   ├── BloodTests.aspx                # Blood test results
│   ├── Hospitals.aspx                 # Hospital directory
│   ├── Profile.aspx                   # User profile
│   ├── Login.aspx                     # User login
│   ├── Register.aspx                  # User registration
│   ├── PasswordReset.aspx             # Password reset request
│   ├── ResetPassword.aspx             # Password reset completion
│   ├── OTPVerification.aspx           # OTP verification
│   └── LanguageSwitcher.aspx          # Language switching
├── Scripts/                           # JavaScript files
│   ├── api-client.js                  # API client utilities
│   ├── rtl.css                        # Right-to-left CSS
│   ├── translations.js                # Translation system
│   └── WebForms/                      # ASP.NET WebForms scripts
├── Documentation/                     # Project documentation
│   ├── API_DOCUMENTATION.md           # API documentation
│   └── SYSTEM_DOCUMENTATION.md        # System documentation
├── Site.Master                        # Master page template
├── Default.aspx                       # Default page
├── Web.config                         # Application configuration
├── server.js                          # Node.js email server
├── package.json                       # Node.js dependencies
└── email-config.env                   # Email configuration
```

## Setup Instructions

### Prerequisites
1. **Visual Studio 2019/2022** with ASP.NET Web Development workload
2. **SQL Server LocalDB** (included with Visual Studio)
3. **Node.js** (v14 or higher)
4. **Git** (optional, for version control)

### Database Setup
1. Open Command Prompt as Administrator
2. Navigate to project directory
3. Run: `Build\setup_database.bat`
4. Verify database creation in SQL Server Management Studio

### Node.js Email Service Setup
1. Install Node.js dependencies:
   ```bash
   npm install
   ```
2. Configure email settings in `email-config.env`
3. Start email service:
   ```bash
   node server.js
   ```

### ASP.NET Application Setup
1. Open `appoinmentsystem.sln` in Visual Studio
2. Restore NuGet packages
3. Build solution (Ctrl+Shift+B)
4. Run application (F5)

### Email Configuration
1. Create Gmail app password or use OAuth2
2. Update `email-config.env`:
   ```
   EMAIL_USER=your-email@gmail.com
   EMAIL_PASS=your-app-password
   ```
3. Restart Node.js server

## Configuration

### Web.config Settings
```xml
<connectionStrings>
    <add name="HospitalDB" 
         connectionString="Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=|DataDirectory|\HospitalDB.mdf;Integrated Security=True" 
         providerName="System.Data.SqlClient" />
</connectionStrings>
```

### Email Configuration
```javascript
// server.js
const transporter = nodemailer.createTransporter({
    service: 'gmail',
    auth: {
        user: process.env.EMAIL_USER,
        pass: process.env.EMAIL_PASS
    }
});
```

### Security Settings
- **Password Hashing**: SHA256 (upgrade to BCrypt for production)
- **Session Timeout**: 30 minutes
- **OTP Expiry**: 10 minutes
- **Token Expiry**: 1 hour

## Recent Changes

### UI/UX Improvements
1. **Header Removal**: Removed top header as requested
2. **Sidebar Redesign**: Modern sidebar with user profile section
3. **Mobile Optimization**: Improved mobile sidebar functionality
4. **Page Redesigns**: Modern card-based layouts for all pages
5. **Notification Removal**: Removed notification button from header

### Feature Removals
1. **Translation Dropdown**: Removed from sidebar navigation
2. **Photo Upload**: Removed profile photo upload functionality
3. **Email Field**: Removed email field from profile page
4. **Mock Data**: Removed all sample/demo data from database
5. **Footer**: Removed footer section

### Security Enhancements
1. **Email Notifications**: Added login and password reset notifications
2. **Input Validation**: Enhanced server-side validation
3. **Error Handling**: Improved error handling and user feedback
4. **Debug Cleanup**: Removed all debug console.log statements

### Mobile Improvements
1. **Sidebar Toggle**: Fixed mobile sidebar toggle functionality
2. **Touch Gestures**: Added touch-friendly interactions
3. **Responsive Design**: Improved mobile layout and spacing
4. **Overlay System**: Added dark overlay for mobile sidebar

## Troubleshooting

### Common Issues

#### Database Connection Issues
- **Problem**: Cannot connect to LocalDB
- **Solution**: 
  1. Check if SQL Server LocalDB is installed
  2. Verify connection string in Web.config
  3. Run `Build\setup_database.bat` as Administrator

#### Email Service Not Working
- **Problem**: Emails not being sent
- **Solution**:
  1. Check if Node.js server is running (`node server.js`)
  2. Verify email credentials in `email-config.env`
  3. Check Gmail app password settings
  4. Test email endpoint: `POST http://localhost:3000/api/test-email`

#### Mobile Sidebar Issues
- **Problem**: Mobile sidebar not working
- **Solution**:
  1. Clear browser cache
  2. Check JavaScript console for errors
  3. Verify Bootstrap CSS is loading
  4. Test on different mobile devices

#### Login Issues
- **Problem**: Cannot login after registration
- **Solution**:
  1. Check if OTP verification is completed
  2. Verify email verification status in database
  3. Check password hashing consistency

### Performance Optimization
1. **Database Indexing**: Add indexes on frequently queried columns
2. **Caching**: Implement output caching for static content
3. **Image Optimization**: Compress and optimize images
4. **CSS/JS Minification**: Minify CSS and JavaScript files

### Security Considerations
1. **Password Hashing**: Upgrade from SHA256 to BCrypt
2. **HTTPS**: Implement SSL/TLS for production
3. **Input Sanitization**: Add comprehensive input sanitization
4. **Rate Limiting**: Implement API rate limiting
5. **Session Security**: Enhance session management

### Browser Compatibility
- **Supported**: Chrome 90+, Firefox 88+, Safari 14+, Edge 90+
- **Mobile**: iOS Safari 14+, Chrome Mobile 90+
- **Features**: CSS Grid, Flexbox, ES6 JavaScript

## Support and Maintenance

### Regular Maintenance Tasks
1. **Database Backup**: Regular database backups
2. **Log Monitoring**: Monitor application and error logs
3. **Security Updates**: Keep dependencies updated
4. **Performance Monitoring**: Monitor application performance

### Development Guidelines
1. **Code Standards**: Follow C# and JavaScript coding standards
2. **Documentation**: Update documentation with changes
3. **Testing**: Test on multiple browsers and devices
4. **Version Control**: Use Git for version control

### Future Enhancements
1. **Real-time Notifications**: WebSocket implementation
2. **Advanced Search**: Full-text search capabilities
3. **Reporting**: Advanced reporting and analytics
4. **API Documentation**: Swagger/OpenAPI documentation
5. **Unit Testing**: Comprehensive test coverage

---

**Last Updated**: December 2024  
**Version**: 1.0.0  
**Author**: Hospital Appointment System Development Team
