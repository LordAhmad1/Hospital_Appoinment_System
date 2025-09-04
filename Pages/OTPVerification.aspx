<%@ Page Title="OTP Verification" Language="C#" AutoEventWireup="true" CodeFile="OTPVerification.aspx.cs" Inherits="HospitalAppointmentSystem.OTPVerification" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>OTP Verification - Hospital System</title>
    
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
            top: 15%;
            left: 10%;
            animation-delay: 0s;
        }
        
        .shape:nth-child(2) {
            width: 120px;
            height: 120px;
            top: 70%;
            right: 10%;
            animation-delay: 2s;
        }
        
        .shape:nth-child(3) {
            width: 60px;
            height: 60px;
            bottom: 15%;
            left: 15%;
            animation-delay: 4s;
        }
        
        .shape:nth-child(4) {
            width: 100px;
            height: 100px;
            top: 25%;
            right: 25%;
            animation-delay: 1s;
        }
        
        .shape:nth-child(5) {
            width: 70px;
            height: 70px;
            bottom: 30%;
            right: 15%;
            animation-delay: 3s;
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
        
        .otp-wrapper {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem;
            position: relative;
        }
        
        .otp-container {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(25px);
            border-radius: 30px;
            box-shadow: 
                0 35px 70px rgba(0, 0, 0, 0.2),
                0 0 0 1px rgba(255, 255, 255, 0.2),
                inset 0 1px 0 rgba(255, 255, 255, 0.3);
            overflow: hidden;
            width: 100%;
            max-width: 500px;
            position: relative;
            transform: translateY(0);
            transition: all 0.5s cubic-bezier(0.4, 0, 0.2, 1);
            border: 1px solid rgba(255, 255, 255, 0.3);
        }
        
        .otp-container:hover {
            transform: translateY(-8px) scale(1.02);
            box-shadow: 
                0 45px 90px rgba(0, 0, 0, 0.25),
                0 0 0 1px rgba(255, 255, 255, 0.3),
                inset 0 1px 0 rgba(255, 255, 255, 0.4);
        }
        
        .otp-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 50%, #f093fb 100%);
            color: white;
            padding: 3.5rem 2.5rem 2.5rem;
            text-align: center;
            position: relative;
            overflow: hidden;
        }
        
        .otp-header::before {
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
        
        .otp-title {
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
        
        .otp-subtitle {
            font-size: 1.2rem;
            opacity: 0.95;
            position: relative;
            z-index: 1;
            font-weight: 300;
            letter-spacing: 0.5px;
        }
        
        .otp-body {
            padding: 3.5rem 3rem;
            background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
        }
        
        .user-info {
            background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
            border-radius: 20px;
            padding: 1.5rem;
            margin-bottom: 2rem;
            border: 2px solid #e2e8f0;
            text-align: center;
        }
        
        .user-info h4 {
            color: #2d3748;
            font-weight: 600;
            margin-bottom: 0.5rem;
        }
        
        .user-info p {
            color: #667eea;
            font-weight: 500;
            margin: 0;
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
        
        .otp-input-container {
            display: flex;
            gap: 1rem;
            justify-content: center;
            margin-bottom: 2rem;
        }
        
        .otp-input {
            width: 60px;
            height: 60px;
            border: 2px solid #e2e8f0;
            border-radius: 15px;
            text-align: center;
            font-size: 1.5rem;
            font-weight: 700;
            color: #2d3748;
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            background: #ffffff;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
        }
        
        .otp-input:focus {
            border-color: #667eea;
            box-shadow: 
                0 0 0 6px rgba(102, 126, 234, 0.15),
                0 8px 25px rgba(102, 126, 234, 0.2);
            outline: none;
            transform: translateY(-3px);
        }
        
        .otp-input.filled {
            border-color: #28a745;
            background: linear-gradient(135deg, #d4edda 0%, #c3e6cb 100%);
            color: #155724;
        }
        
        .btn-verify {
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
            margin-bottom: 1.5rem;
        }
        
        .btn-verify::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.3), transparent);
            transition: left 0.6s;
        }
        
        .btn-verify:hover::before {
            left: 100%;
        }
        
        .btn-verify:hover {
            transform: translateY(-4px);
            box-shadow: 
                0 15px 35px rgba(102, 126, 234, 0.4),
                0 8px 25px rgba(0, 0, 0, 0.2);
        }
        
        .btn-verify:active {
            transform: translateY(-2px);
        }
        
        .btn-verify:disabled {
            opacity: 0.7;
            cursor: not-allowed;
            transform: none;
        }
        
        .btn-resend {
            width: 100%;
            padding: 1rem;
            font-size: 1rem;
            font-weight: 600;
            border-radius: 15px;
            background: transparent;
            border: 2px solid #667eea;
            color: #667eea;
            transition: all 0.3s ease;
            cursor: pointer;
            margin-bottom: 2rem;
        }
        
        .btn-resend:hover {
            background: #667eea;
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.3);
        }
        
        .btn-resend:disabled {
            opacity: 0.5;
            cursor: not-allowed;
            transform: none;
        }
        
        .timer {
            text-align: center;
            color: #a0aec0;
            font-weight: 500;
            margin-bottom: 1rem;
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
        
        .back-to-register {
            text-align: center;
            margin-top: 2rem;
            padding-top: 2rem;
            border-top: 2px solid #e2e8f0;
        }
        
        .back-to-register a {
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
        
        .back-to-register a:hover {
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
            .otp-wrapper {
                padding: 1rem;
            }
            
            .otp-container {
                max-width: 100%;
                margin: 0 1rem;
            }
            
            .otp-header {
                padding: 2.5rem 1.5rem 2rem;
            }
            
            .otp-body {
                padding: 2.5rem 2rem;
            }
            
            .otp-title {
                font-size: 2rem;
            }
            
            .otp-input-container {
                gap: 0.75rem;
            }
            
            .otp-input {
                width: 50px;
                height: 50px;
                font-size: 1.25rem;
            }
        }
        
        @media (max-width: 480px) {
            .otp-body {
                padding: 2rem 1.5rem;
            }
            
            .otp-input-container {
                gap: 0.5rem;
            }
            
            .otp-input {
                width: 45px;
                height: 45px;
                font-size: 1.1rem;
            }
            
            .btn-verify {
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
        <div class="shape"></div>
    </div>
    
    <div class="otp-wrapper">
        <div class="otp-container">
            <div class="otp-header">
                <div class="logo-container">
                    <i class="fas fa-hospital"></i>
                </div>
                <h1 class="otp-title">
                    <i class="fas fa-shield-alt"></i> Verify OTP
                </h1>
                <p class="otp-subtitle">Enter the 6-digit code sent to your email</p>
            </div>
            
            <div class="otp-body">
                <div id="messageContainer" class="message-container">
                    <!-- Messages will be displayed here -->
                </div>
                
                <div class="user-info">
                    <h4 id="userName">Welcome!</h4>
                    <p id="userEmail">Please check your email for the OTP code</p>
                </div>
                
                <div class="form-group">
                    <label class="form-label">
                        <i class="fas fa-key"></i> Enter OTP Code
                    </label>
                    <div class="otp-input-container">
                        <input type="text" class="otp-input" maxlength="1" data-index="0">
                        <input type="text" class="otp-input" maxlength="1" data-index="1">
                        <input type="text" class="otp-input" maxlength="1" data-index="2">
                        <input type="text" class="otp-input" maxlength="1" data-index="3">
                        <input type="text" class="otp-input" maxlength="1" data-index="4">
                        <input type="text" class="otp-input" maxlength="1" data-index="5">
                    </div>
                </div>
                
                <button type="button" class="btn-verify" id="btnVerify">
                    <i class="fas fa-check"></i> Verify OTP
                </button>
                
                <div class="timer" id="timer">
                    Resend code in <span id="countdown">60</span> seconds
                </div>
                
                <button type="button" class="btn-resend" id="btnResend" disabled>
                    <i class="fas fa-redo"></i> Resend OTP
                </button>
                
                <div class="divider">
                    <span>Need help?</span>
                </div>
                
                <div class="back-to-register">
                    <a href="Register.aspx">
                        <i class="fas fa-arrow-left"></i> Back to Registration
                    </a>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        let countdown = 60;
        let timerInterval;
        let userEmail = '';
        let userName = '';
        
        // Auto-focus on first OTP input when page loads
        document.addEventListener('DOMContentLoaded', function() {
            const firstInput = document.querySelector('.otp-input[data-index="0"]');
            if (firstInput) {
                firstInput.focus();
            }
            
            // Get user info from URL parameters
            const urlParams = new URLSearchParams(window.location.search);
            userEmail = urlParams.get('email') || '';
            userName = urlParams.get('username') || 'User';
            
            // Update user info display
            document.getElementById('userName').textContent = `Welcome, ${userName}!`;
            document.getElementById('userEmail').textContent = userEmail;
            
            // Start countdown timer
            startCountdown();
            
            // Check for error messages in URL
            const error = urlParams.get('error');
            if (error) {
                showMessage(error, 'error');
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
        
        // OTP input handling
        document.querySelectorAll('.otp-input').forEach(input => {
            input.addEventListener('input', function(e) {
                const value = e.target.value;
                const index = parseInt(e.target.dataset.index);
                
                // Only allow numbers
                if (!/^\d*$/.test(value)) {
                    e.target.value = '';
                    return;
                }
                
                // Update input styling
                if (value) {
                    e.target.classList.add('filled');
                } else {
                    e.target.classList.remove('filled');
                }
                
                // Move to next input
                if (value && index < 5) {
                    document.querySelector(`.otp-input[data-index="${index + 1}"]`).focus();
                }
            });
            
            input.addEventListener('keydown', function(e) {
                const index = parseInt(e.target.dataset.index);
                
                // Handle backspace
                if (e.key === 'Backspace' && !e.target.value && index > 0) {
                    document.querySelector(`.otp-input[data-index="${index - 1}"]`).focus();
                }
            });
        });
        
        // Verify OTP
        document.getElementById('btnVerify').addEventListener('click', function() {
            const otpInputs = document.querySelectorAll('.otp-input');
            const otp = Array.from(otpInputs).map(input => input.value).join('');
            
            if (otp.length !== 6) {
                showMessage('Please enter the complete 6-digit OTP code.', 'error');
                return;
            }
            
            // Show loading state
            const btnVerify = document.getElementById('btnVerify');
            btnVerify.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Verifying...';
            btnVerify.disabled = true;
            btnVerify.classList.add('btn-loading');
            
            // Verify OTP
            verifyOTP(otp);
        });
        
        function verifyOTP(otp) {
            fetch('http://localhost:3000/api/verify-otp', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({ 
                    email: userEmail, 
                    otp: otp 
                })
            })
            .then(response => response.json())
            .then(data => {
                const btnVerify = document.getElementById('btnVerify');
                
                if (data.success) {
                    showMessage('OTP verified successfully! Completing registration...', 'success');
                    
                    // Redirect to ASP.NET completion page instead of calling Node.js API
                    setTimeout(() => {
                        window.location.href = 'CompleteRegistration.aspx';
                    }, 2000);
                } else {
                    showMessage(data.message || 'Invalid OTP code. Please try again.', 'error');
                    clearOTPInputs();
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showMessage('An error occurred. Please try again later.', 'error');
                clearOTPInputs();
            })
            .finally(() => {
                // Reset button state
                const btnVerify = document.getElementById('btnVerify');
                btnVerify.innerHTML = '<i class="fas fa-check"></i> Verify OTP';
                btnVerify.disabled = false;
                btnVerify.classList.remove('btn-loading');
            });
        }
        
        function clearOTPInputs() {
            document.querySelectorAll('.otp-input').forEach(input => {
                input.value = '';
                input.classList.remove('filled');
            });
            document.querySelector('.otp-input[data-index="0"]').focus();
        }
        
        // Resend OTP
        document.getElementById('btnResend').addEventListener('click', function() {
            const btnResend = document.getElementById('btnResend');
            btnResend.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Sending...';
            btnResend.disabled = true;
            
            fetch('http://localhost:3000/api/send-otp', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({ email: userEmail })
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    showMessage('New OTP code has been sent to your email.', 'success');
                    clearOTPInputs();
                    startCountdown();
                } else {
                    showMessage(data.message || 'Failed to send OTP. Please try again.', 'error');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showMessage('An error occurred. Please try again later.', 'error');
            })
            .finally(() => {
                btnResend.innerHTML = '<i class="fas fa-redo"></i> Resend OTP';
            });
        });
        
        function startCountdown() {
            countdown = 60;
            const btnResend = document.getElementById('btnResend');
            const timer = document.getElementById('timer');
            const countdownSpan = document.getElementById('countdown');
            
            btnResend.disabled = true;
            timer.style.display = 'block';
            
            timerInterval = setInterval(() => {
                countdown--;
                countdownSpan.textContent = countdown;
                
                if (countdown <= 0) {
                    clearInterval(timerInterval);
                    btnResend.disabled = false;
                    timer.style.display = 'none';
                }
            }, 1000);
        }
    </script>
</body>
</html>
