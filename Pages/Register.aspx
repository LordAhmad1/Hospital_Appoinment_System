<%@ Page Title="Register" Language="C#" AutoEventWireup="true" CodeFile="Register.aspx.cs" Inherits="HospitalAppointmentSystem.Register" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Register - Hospital System</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 50%, #f093fb 100%);
            min-height: 100vh;
            font-family: 'Poppins', sans-serif;
            position: relative;
            overflow-x: hidden;
        }
        
        body::before {
            content: '';
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: 
                radial-gradient(circle at 20% 80%, rgba(120, 119, 198, 0.4) 0%, transparent 50%),
                radial-gradient(circle at 80% 20%, rgba(255, 119, 198, 0.4) 0%, transparent 50%),
                radial-gradient(circle at 40% 40%, rgba(120, 219, 255, 0.3) 0%, transparent 50%),
                radial-gradient(circle at 90% 90%, rgba(255, 183, 77, 0.3) 0%, transparent 50%);
            z-index: -1;
            animation: backgroundShift 20s ease-in-out infinite;
        }
        
        @keyframes backgroundShift {
            0%, 100% { 
                transform: scale(1) rotate(0deg);
                opacity: 1;
            }
            50% { 
                transform: scale(1.1) rotate(1deg);
                opacity: 0.8;
            }
        }
        
        .floating-shapes {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            overflow: hidden;
            z-index: -1;
        }
        
        .shape {
            position: absolute;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 50%;
            animation: float 6s ease-in-out infinite;
        }
        
        .shape:nth-child(1) {
            width: 80px;
            height: 80px;
            top: 20%;
            left: 10%;
            animation-delay: 0s;
        }
        
        .shape:nth-child(2) {
            width: 120px;
            height: 120px;
            top: 60%;
            right: 15%;
            animation-delay: 2s;
        }
        
        .shape:nth-child(3) {
            width: 60px;
            height: 60px;
            bottom: 20%;
            left: 20%;
            animation-delay: 4s;
        }
        
        .shape:nth-child(4) {
            width: 100px;
            height: 100px;
            top: 30%;
            right: 30%;
            animation-delay: 1s;
        }
        
        @keyframes float {
            0%, 100% { 
                transform: translateY(0px) rotate(0deg);
                opacity: 0.7;
            }
            50% { 
                transform: translateY(-20px) rotate(180deg);
                opacity: 1;
            }
        }
        
        .register-wrapper {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem;
            position: relative;
        }
        
        .register-container {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(25px);
            border-radius: 30px;
            box-shadow: 
                0 35px 70px rgba(0, 0, 0, 0.2),
                0 0 0 1px rgba(255, 255, 255, 0.2),
                inset 0 1px 0 rgba(255, 255, 255, 0.3);
            overflow: hidden;
            width: 100%;
            max-width: 600px;
            position: relative;
            transform: translateY(0);
            transition: all 0.5s cubic-bezier(0.4, 0, 0.2, 1);
            border: 1px solid rgba(255, 255, 255, 0.3);
        }
        
        .register-container:hover {
            transform: translateY(-8px) scale(1.02);
            box-shadow: 
                0 45px 90px rgba(0, 0, 0, 0.25),
                0 0 0 1px rgba(255, 255, 255, 0.3),
                inset 0 1px 0 rgba(255, 255, 255, 0.4);
        }
        
        .register-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 50%, #f093fb 100%);
            color: white;
            padding: 3.5rem 2.5rem 2.5rem;
            text-align: center;
            position: relative;
            overflow: hidden;
        }
        
        .register-header::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: 
                radial-gradient(circle, rgba(255, 255, 255, 0.15) 0%, transparent 70%);
            animation: float 8s ease-in-out infinite;
        }
        
        .logo-container {
            position: relative;
            z-index: 1;
            margin-bottom: 2rem;
        }
        
        .logo-container i {
            background: linear-gradient(135deg, #fff, #f0f0f0);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            filter: drop-shadow(0 6px 12px rgba(0,0,0,0.3));
            font-size: 4rem;
        }
        
        .register-title {
            font-size: 2.5rem;
            font-weight: 800;
            margin-bottom: 0.75rem;
            position: relative;
            z-index: 1;
            text-shadow: 0 3px 6px rgba(0,0,0,0.2);
            background: linear-gradient(135deg, #fff, #f0f0f0);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        
        .register-subtitle {
            font-size: 1.2rem;
            opacity: 0.95;
            position: relative;
            z-index: 1;
            font-weight: 300;
            letter-spacing: 0.5px;
        }
        
        .register-body {
            padding: 3.5rem 3rem;
            background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
        }
        
        .form-group {
            margin-bottom: 2rem;
            position: relative;
        }
        
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1.5rem;
        }
        
        .form-label {
            display: block;
            margin-bottom: 1rem;
            font-weight: 600;
            color: #2d3748;
            font-size: 1rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            position: relative;
        }
        
        .form-label i {
            margin-right: 0.75rem;
            color: #667eea;
            font-size: 1.1rem;
        }
        
        .form-control {
            border: 2px solid #e2e8f0;
            border-radius: 20px;
            padding: 1.5rem 2rem;
            font-size: 1.1rem;
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            background: #ffffff;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
            width: 100%;
            font-weight: 500;
            color: #2d3748;
        }
        
        .form-control:focus {
            border-color: #667eea;
            box-shadow: 
                0 0 0 6px rgba(102, 126, 234, 0.15),
                0 8px 25px rgba(102, 126, 234, 0.2);
            background: white;
            outline: none;
            transform: translateY(-3px);
        }
        
        .form-control::placeholder {
            color: #a0aec0;
            font-weight: 400;
        }
        
        .terms-checkbox {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            margin-bottom: 2.5rem;
        }
        
        .form-check-input {
            width: 1.5rem;
            height: 1.5rem;
            accent-color: #667eea;
            cursor: pointer;
            border-radius: 6px;
            border: 2px solid #e2e8f0;
            transition: all 0.3s ease;
        }
        
        .form-check-input:checked {
            border-color: #667eea;
            transform: scale(1.1);
        }
        
        .form-check-label {
            cursor: pointer;
            font-size: 0.95rem;
            color: #4a5568;
            font-weight: 500;
            user-select: none;
        }
        
        .btn-register {
            width: 100%;
            padding: 1.5rem;
            font-size: 1.2rem;
            font-weight: 700;
            border-radius: 20px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 50%, #f093fb 100%);
            border: none;
            color: white;
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            position: relative;
            overflow: hidden;
            cursor: pointer;
            text-transform: uppercase;
            letter-spacing: 1px;
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.3);
        }
        
        .btn-register::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.3), transparent);
            transition: left 0.6s;
        }
        
        .btn-register:hover::before {
            left: 100%;
        }
        
        .btn-register:hover {
            transform: translateY(-4px);
            box-shadow: 
                0 15px 35px rgba(102, 126, 234, 0.4),
                0 8px 25px rgba(0, 0, 0, 0.2);
        }
        
        .btn-register:active {
            transform: translateY(-2px);
        }
        
        .btn-register:disabled {
            opacity: 0.7;
            cursor: not-allowed;
            transform: none;
        }
        
        .divider {
            text-align: center;
            margin: 2.5rem 0;
            position: relative;
            color: #a0aec0;
            font-weight: 500;
        }
        
        .divider::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 0;
            right: 0;
            height: 1px;
            background: linear-gradient(90deg, transparent, #e2e8f0, transparent);
        }
        
        .divider span {
            background: white;
            padding: 0 1.5rem;
            position: relative;
            z-index: 1;
        }
        
        .login-link {
            text-align: center;
            margin-top: 2rem;
            padding-top: 2rem;
            border-top: 2px solid #e2e8f0;
        }
        
        .login-link a {
            color: #667eea;
            text-decoration: none;
            font-weight: 600;
            font-size: 1.1rem;
            transition: all 0.3s ease;
            padding: 0.75rem 1.5rem;
            border-radius: 15px;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .login-link a:hover {
            color: #764ba2;
            background: rgba(102, 126, 234, 0.1);
            text-decoration: none;
            transform: translateY(-2px);
        }
        
        .login-link a i {
            font-size: 1.2rem;
        }
        
        /* Message styling */
        .message-container {
            margin-bottom: 2rem;
        }
        
        .alert {
            border: none;
            border-radius: 15px;
            padding: 1.25rem 1.5rem;
            font-weight: 500;
            position: relative;
            overflow: hidden;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }
        
        .alert::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 5px;
            height: 100%;
        }
        
        .alert-success::before {
            background: #28a745;
        }
        
        .alert-danger::before {
            background: #dc3545;
        }
        
        .btn-close {
            border-radius: 50%;
            padding: 0.5rem;
            transition: all 0.3s ease;
        }
        
        .btn-close:hover {
            background: rgba(0, 0, 0, 0.1);
            transform: scale(1.1);
        }
        
        /* Loading animation */
        .loading {
            position: relative;
            opacity: 0.7;
        }
        
        .loading::before {
            content: '';
            position: absolute;
            top: 50%;
            right: 15px;
            width: 16px;
            height: 16px;
            margin-top: -8px;
            border: 2px solid transparent;
            border-top: 2px solid white;
            border-radius: 50%;
            animation: spin 1s linear infinite;
            z-index: 1;
        }
        
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        
        /* Responsive design */
        @media (max-width: 768px) {
            .register-wrapper {
                padding: 1rem;
            }
            
            .register-container {
                max-width: 100%;
                margin: 0 1rem;
            }
            
            .register-header {
                padding: 2.5rem 1.5rem 2rem;
            }
            
            .register-body {
                padding: 2.5rem 2rem;
            }
            
            .register-title {
                font-size: 2rem;
            }
            
            .form-row {
                grid-template-columns: 1fr;
            }
        }
        
        @media (max-width: 480px) {
            .register-body {
                padding: 2rem 1.5rem;
            }
            
            .form-control {
                padding: 1.25rem 1.5rem;
                font-size: 1rem;
            }
            
            .btn-register {
                padding: 1.25rem;
                font-size: 1.1rem;
            }
        }
    </style>
</head>
<body>
    <!-- Floating background shapes -->
    <div class="floating-shapes">
        <div class="shape"></div>
        <div class="shape"></div>
        <div class="shape"></div>
        <div class="shape"></div>
    </div>
    
    <div class="register-wrapper">
        <div class="register-container">
            <div class="register-header">
                <div class="logo-container">
                    <i class="fas fa-hospital"></i>
                </div>
                <h1 class="register-title">
                    <i class="fas fa-user-plus"></i> Create Account
                </h1>
                <p class="register-subtitle">Join our hospital appointment system</p>
            </div>
            
            <div class="register-body">
                <form id="registerForm" runat="server">
                    <asp:Label ID="lblMessage" runat="server" Visible="false" CssClass="alert" />
                    
                    <div id="messageContainer" class="message-container">
                        <!-- Error messages will be displayed here -->
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="txtFirstName" class="form-label">
                                <i class="fas fa-user"></i> First Name
                            </label>
                            <input type="text" class="form-control" id="txtFirstName" name="txtFirstName" placeholder="Enter first name" required>
                        </div>
                        <div class="form-group">
                            <label for="txtLastName" class="form-label">
                                <i class="fas fa-user"></i> Last Name
                            </label>
                            <input type="text" class="form-control" id="txtLastName" name="txtLastName" placeholder="Enter last name" required>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="txtEmail" class="form-label">
                            <i class="fas fa-envelope"></i> Email Address
                        </label>
                        <input type="email" class="form-control" id="txtEmail" name="txtEmail" placeholder="Enter email address" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="txtPhone" class="form-label">
                            <i class="fas fa-phone"></i> Phone Number
                        </label>
                        <input type="tel" class="form-control" id="txtPhone" name="txtPhone" placeholder="Enter phone number" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="txtNationalID" class="form-label">
                            <i class="fas fa-id-card"></i> National ID
                        </label>
                        <input type="text" class="form-control" id="txtNationalID" name="txtNationalID" placeholder="Enter national ID" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="txtDateOfBirth" class="form-label">
                            <i class="fas fa-calendar"></i> Date of Birth
                        </label>
                        <input type="date" class="form-control" id="txtDateOfBirth" name="txtDateOfBirth" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="txtPassword" class="form-label">
                            <i class="fas fa-lock"></i> Password
                        </label>
                        <input type="password" class="form-control" id="txtPassword" name="txtPassword" placeholder="Create password" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="txtConfirmPassword" class="form-label">
                            <i class="fas fa-lock"></i> Confirm Password
                        </label>
                        <input type="password" class="form-control" id="txtConfirmPassword" name="txtConfirmPassword" placeholder="Confirm password" required>
                    </div>
                    
                    <div class="terms-checkbox">
                        <input type="checkbox" class="form-check-input" id="chkAgree" name="chkAgree" required>
                        <label for="chkAgree" class="form-check-label">
                            I agree to the <a href="#" style="color: #667eea; text-decoration: none;">Terms and Conditions</a>
                        </label>
                    </div>
                    
                    <asp:Button ID="btnRegister" runat="server" Text="Create Account" CssClass="btn-register" OnClick="btnRegister_Click" OnClientClick="return showLoading();" />
                    
                    <div class="divider">
                        <span>Already have an account?</span>
                    </div>
                    
                    <div class="login-link">
                        <a href="Login.aspx">
                            <i class="fas fa-sign-in-alt"></i> Sign In
                        </a>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Set default date of birth (18 years ago)
        document.addEventListener('DOMContentLoaded', function() {
            const dateOfBirthInput = document.getElementById('txtDateOfBirth');
            if (dateOfBirthInput) {
                const today = new Date();
                const eighteenYearsAgo = new Date(today.getFullYear() - 18, today.getMonth(), today.getDate());
                dateOfBirthInput.value = eighteenYearsAgo.toISOString().split('T')[0];
            }
            
            // Check for error messages in URL
            const urlParams = new URLSearchParams(window.location.search);
            const error = urlParams.get('error');
            if (error) {
                showMessage(getErrorMessage(error), 'error');
            }
        });
        
        // Show loading state
        function showLoading() {
            var btn = document.getElementById('<%= btnRegister.ClientID %>');
            if (btn.classList.contains("loading")) {
                return false; // يمنع الضغط المتكرر
            }

            // جرّب تغيير النص حسب نوع الزر
            if (btn.tagName.toLowerCase() === "input") {
                btn.value = "Sending OTP...";
            } else {
                btn.innerText = "Sending OTP...";
            }

            btn.classList.add("loading");
            return true; // يسمح بالـ PostBack يوصل للسيرفر
        }
        
        // Show messages
        function showMessage(message, type) {
            const messageContainer = document.getElementById('messageContainer');
            const alertClass = type === 'error' ? 'alert-danger' : 'alert-success';
            messageContainer.innerHTML = `<div class="alert ${alertClass}">${message}</div>`;
        }
        
        // Get error message
        function getErrorMessage(error) {
            const errorMessages = {
                'email_exists': 'An account with this email already exists.',
                'otp_send_failed': 'Failed to send OTP code. Please try again.',
                'first_name_required': 'First name is required.',
                'last_name_required': 'Last name is required.',
                'email_required': 'Email address is required.',
                'phone_required': 'Phone number is required.',
                'national_id_required': 'National ID is required.',
                'password_required': 'Password is required.',
                'passwords_dont_match': 'Passwords do not match.',
                'terms_not_accepted': 'You must accept the terms and conditions.',
                'invalid_date': 'Please enter a valid date of birth.',
                'registration_failed': 'Registration failed. Please try again.'
            };
            return errorMessages[error] || 'An error occurred. Please try again.';
        }
        
        // Password confirmation check
        document.getElementById('txtConfirmPassword').addEventListener('input', function() {
            const password = document.getElementById('txtPassword').value;
            const confirmPassword = this.value;
            
            if (password !== confirmPassword) {
                this.setCustomValidity('Passwords do not match');
            } else {
                this.setCustomValidity('');
            }
        });
    </script>
</body>
</html>
