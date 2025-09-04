<%@ Page Title="Password Reset" Language="C#" AutoEventWireup="true" CodeFile="PasswordReset.aspx.cs" Inherits="HospitalAppointmentSystem.PasswordReset" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Password Reset - Hospital System</title>
    
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
        
        .reset-wrapper {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem;
            position: relative;
        }
        
        .reset-container {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(25px);
            border-radius: 30px;
            box-shadow: 
                0 35px 70px rgba(0, 0, 0, 0.2),
                0 0 0 1px rgba(255, 255, 255, 0.2),
                inset 0 1px 0 rgba(255, 255, 255, 0.3);
            overflow: hidden;
            width: 100%;
            max-width: 480px;
            position: relative;
            transform: translateY(0);
            transition: all 0.5s cubic-bezier(0.4, 0, 0.2, 1);
            border: 1px solid rgba(255, 255, 255, 0.3);
        }
        
        .reset-container:hover {
            transform: translateY(-8px) scale(1.02);
            box-shadow: 
                0 45px 90px rgba(0, 0, 0, 0.25),
                0 0 0 1px rgba(255, 255, 255, 0.3),
                inset 0 1px 0 rgba(255, 255, 255, 0.4);
        }
        
        .reset-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 50%, #f093fb 100%);
            color: white;
            padding: 3.5rem 2.5rem 2.5rem;
            text-align: center;
            position: relative;
            overflow: hidden;
        }
        
        .reset-header::before {
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
        
        .reset-title {
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
        
        .reset-subtitle {
            font-size: 1.2rem;
            opacity: 0.95;
            position: relative;
            z-index: 1;
            font-weight: 300;
            letter-spacing: 0.5px;
        }
        
        .reset-body {
            padding: 3.5rem 3rem;
            background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
        }
        
        .form-group {
            margin-bottom: 2rem;
            position: relative;
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
        
        .btn-reset {
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
        
        .btn-reset::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.3), transparent);
            transition: left 0.6s;
        }
        
        .btn-reset:hover::before {
            left: 100%;
        }
        
        .btn-reset:hover {
            transform: translateY(-4px);
            box-shadow: 
                0 15px 35px rgba(102, 126, 234, 0.4),
                0 8px 25px rgba(0, 0, 0, 0.2);
        }
        
        .btn-reset:active {
            transform: translateY(-2px);
        }
        
        .btn-reset:disabled {
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
        
        .back-to-login {
            text-align: center;
            margin-top: 2rem;
            padding-top: 2rem;
            border-top: 2px solid #e2e8f0;
        }
        
        .back-to-login a {
            color: #667eea;
            text-decoration: none;
            font-weight: 700;
            transition: all 0.3s ease;
            padding: 0.75rem 1.5rem;
            border-radius: 15px;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            font-size: 1.1rem;
        }
        
        .back-to-login a:hover {
            color: #764ba2;
            background: rgba(102, 126, 234, 0.1);
            text-decoration: none;
            transform: translateY(-2px);
        }
        
        .message-container {
            margin-bottom: 2rem;
        }
        
        .alert {
            border-radius: 20px;
            border: none;
            padding: 1.25rem 1.5rem;
            font-weight: 500;
            position: relative;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        }
        
        .alert-success {
            background: linear-gradient(135deg, #d4edda 0%, #c3e6cb 100%);
            color: #155724;
        }
        
        .alert-danger {
            background: linear-gradient(135deg, #f8d7da 0%, #f5c6cb 100%);
            color: #721c24;
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
        .btn-loading {
            position: relative;
            color: transparent !important;
        }
        
        .btn-loading::after {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            width: 20px;
            height: 20px;
            margin: -10px 0 0 -10px;
            border: 2px solid transparent;
            border-top: 2px solid white;
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }
        
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        
        /* Responsive design */
        @media (max-width: 768px) {
            .reset-wrapper {
                padding: 1rem;
            }
            
            .reset-container {
                max-width: 100%;
                margin: 0 1rem;
            }
            
            .reset-header {
                padding: 2.5rem 1.5rem 2rem;
            }
            
            .reset-body {
                padding: 2.5rem 2rem;
            }
            
            .reset-title {
                font-size: 2rem;
            }
        }
        
        @media (max-width: 480px) {
            .reset-body {
                padding: 2rem 1.5rem;
            }
            
            .form-control {
                padding: 1.25rem 1.5rem;
                font-size: 1rem;
            }
            
            .btn-reset {
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
    
    <div class="reset-wrapper">
        <div class="reset-container">
            <div class="reset-header">
                <div class="logo-container">
                    <i class="fas fa-hospital"></i>
                </div>
                <h1 class="reset-title">
                    <i class="fas fa-key"></i> Reset Password
                </h1>
                <p class="reset-subtitle">Enter your email to receive reset instructions</p>
            </div>
            
            <div class="reset-body">
                <form id="resetForm">
                    <div id="messageContainer" class="message-container">
                        <!-- Messages will be displayed here -->
                    </div>
                    
                    <div class="form-group">
                        <label for="txtEmail" class="form-label">
                            <i class="fas fa-envelope"></i> Email Address
                        </label>
                        <input type="email" class="form-control" id="txtEmail" placeholder="Enter your email address" required>
                    </div>
                    
                    <button type="submit" class="btn-reset" id="btnReset">
                        <i class="fas fa-paper-plane"></i> Send Reset Link
                    </button>
                    
                    <div class="divider">
                        <span>Remember your password?</span>
                    </div>
                    
                    <div class="back-to-login">
                        <a href="Login.aspx">
                            <i class="fas fa-sign-in-alt"></i> Back to Sign In
                        </a>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Auto-focus on email field when page loads
        document.addEventListener('DOMContentLoaded', function() {
            const emailInput = document.getElementById('txtEmail');
            if (emailInput) {
                emailInput.focus();
            }
            
            // Check for error messages in URL
            const urlParams = new URLSearchParams(window.location.search);
            const error = urlParams.get('error');
            const success = urlParams.get('success');
            
            if (error) {
                showMessage(error, 'error');
            }
            if (success) {
                showMessage(success, 'success');
            }
        });
        
        // Show messages function
        function showMessage(message, type) {
            const messageContainer = document.getElementById('messageContainer');
            const alertClass = type === 'error' ? 'alert-danger' : 'alert-success';
            
            messageContainer.innerHTML = `
                <div class="alert ${alertClass} alert-dismissible fade show" role="alert">
                    ${message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            `;
        }
        
        // Handle form submission
        document.getElementById('resetForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            const email = document.getElementById('txtEmail').value.trim();
            const btnReset = document.getElementById('btnReset');
            
            if (!email) {
                showMessage('Please enter your email address.', 'error');
                return;
            }
            
            if (!isValidEmail(email)) {
                showMessage('Please enter a valid email address.', 'error');
                return;
            }
            
            // Show loading state
            btnReset.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Sending...';
            btnReset.disabled = true;
            btnReset.classList.add('btn-loading');
            
            // Send reset email
            sendResetEmail(email);
        });
        
        function isValidEmail(email) {
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            return emailRegex.test(email);
        }
        
        function sendResetEmail(email) {
            fetch('http://localhost:3000/api/send-reset-email', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({ email: email })
            })
            .then(response => response.json())
            .then(data => {
                const btnReset = document.getElementById('btnReset');
                
                if (data.success) {
                    showMessage('Password reset link has been sent to your email address. Please check your inbox.', 'success');
                    document.getElementById('txtEmail').value = '';
                } else {
                    showMessage(data.message || 'Failed to send reset email. Please try again.', 'error');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showMessage('An error occurred. Please try again later.', 'error');
            })
            .finally(() => {
                // Reset button state
                const btnReset = document.getElementById('btnReset');
                btnReset.innerHTML = '<i class="fas fa-paper-plane"></i> Send Reset Link';
                btnReset.disabled = false;
                btnReset.classList.remove('btn-loading');
            });
        }
    </script>
</body>
</html>
