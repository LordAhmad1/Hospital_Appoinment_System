<%@ Page Title="Profile" Language="C#" MasterPageFile="/Site.Master" AutoEventWireup="true" CodeFile="Profile.aspx.cs" Inherits="HospitalAppointmentSystem.UserProfile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <meta charset="utf-8" />
    <style>
        .modern-profile {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
        }
        
        .profile-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 20px;
            padding: 3rem;
            margin-bottom: 2rem;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            position: relative;
            overflow: hidden;
        }
        
        .profile-section::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(255,255,255,0.1) 0%, transparent 70%);
            animation: float 6s ease-in-out infinite;
        }
        
        @keyframes float {
            0%, 100% { transform: translateY(0px) rotate(0deg); }
            50% { transform: translateY(-20px) rotate(180deg); }
        }
        .profile-avatar-container {
            position: relative;
            margin-bottom: 1rem;
        }
        .profile-avatar-wrapper {
            position: relative;
            display: inline-block;
            cursor: pointer;
            margin-bottom: 0.5rem;
        }
        .profile-avatar {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.2);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 3rem;
            position: relative;
            overflow: hidden;
            transition: all 0.3s ease;
            border: 3px solid rgba(255, 255, 255, 0.3);
        }
        .profile-avatar:hover {
            transform: scale(1.05);
            border-color: rgba(255, 255, 255, 0.6);
        }
        .profile-photo {
            width: 100%;
            height: 100%;
            object-fit: cover;
            border-radius: 50%;
        }
        .profile-avatar-overlay {
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0, 0, 0, 0.7);
            border-radius: 50%;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            opacity: 0;
            transition: opacity 0.3s ease;
            color: white;
        }
        .profile-avatar-wrapper:hover .profile-avatar-overlay {
            opacity: 1;
        }
        .upload-icon {
            font-size: 1.5rem;
            margin-bottom: 0.25rem;
        }
        .upload-text {
            font-size: 0.8rem;
            font-weight: 500;
        }
        .profile-photo-input {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            opacity: 0;
            cursor: pointer;
            z-index: 10;
        }
        .profile-photo-info {
            margin-top: 0.5rem;
        }
        .profile-avatar-wrapper:active {
            transform: scale(0.98);
        }
        .profile-avatar-wrapper:focus-within .profile-avatar-overlay {
            opacity: 1;
        }
        .d-none {
            display: none !important;
        }
        .form-floating {
            margin-bottom: 1rem;
        }
        .btn-save {
            padding: 0.75rem 2rem;
            font-size: 1.1rem;
            font-weight: 600;
        }
        .info-card {
            border: none;
            border-radius: 20px;
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
            background: white;
        }
        
        .info-card .card-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 20px 20px 0 0;
            border: none;
            padding: 1.5rem;
        }
        
        .form-control {
            border-radius: 10px;
            border: 2px solid #e9ecef;
            transition: all 0.3s ease;
        }
        
        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            border-radius: 10px;
            padding: 0.75rem 2rem;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(102, 126, 234, 0.3);
        }
        
        .main-content {
            background: transparent;
        }
        .stats-card {
            transition: all 0.3s ease;
            border: none;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            overflow: hidden;
            position: relative;
        }
        
        .stats-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, rgba(255,255,255,0.3), rgba(255,255,255,0.1));
        }
        
        .stats-card:hover {
            transform: translateY(-10px) scale(1.02);
            box-shadow: 0 15px 35px rgba(0,0,0,0.15);
        }
        
        .stats-card .card-body {
            padding: 2rem;
        }
        
        .stats-icon {
            font-size: 2.5rem;
            opacity: 0.8;
            transition: all 0.3s ease;
        }
        
        .stats-card:hover .stats-icon {
            transform: scale(1.1);
            opacity: 1;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="modern-profile">
        <!-- Profile Header -->
        <div class="profile-section">
            <div class="row align-items-center">
                <div class="col-md-3 text-center">
                    <div class="profile-avatar-container">
                        <div class="profile-avatar-wrapper">
                            <div class="profile-avatar" id="profileAvatar">
                                <asp:Image ID="imgProfilePhoto" runat="server" CssClass="profile-photo" Visible="false" />
                                <asp:Label ID="defaultAvatar" runat="server" CssClass="fas fa-user" Visible="true"></asp:Label>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-9">
                    <h1 class="mb-3 fw-bold">
                        <span class="profile-title">Profile</span>
                    </h1>
                    <p class="mb-0 fs-5">
                        <span class="profile-subtitle">Manage your personal information and account settings</span>
                    </p>
                </div>
            </div>
        </div>

    <!-- Profile Statistics -->
    <div class="row mb-4">
        <div class="col-md-3 mb-3">
            <div class="card stats-card bg-primary text-white">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h4 class="card-title mb-0">
                                <span class="total-appointments-text">Total Appointments</span>
                            </h4>
                            <h2 class="mb-0">
                                <asp:Label ID="lblTotalAppointments" runat="server" Text="0"></asp:Label>
                            </h2>
                        </div>
                        <i class="fas fa-calendar-check stats-icon"></i>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="col-md-3 mb-3">
            <div class="card stats-card bg-success text-white">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h4 class="card-title mb-0">
                                <span class="completed-appointments-text">Completed</span>
                            </h4>
                            <h2 class="mb-0">
                                <asp:Label ID="lblCompletedAppointments" runat="server" Text="0"></asp:Label>
                            </h2>
                        </div>
                        <i class="fas fa-check-circle stats-icon"></i>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="col-md-3 mb-3">
            <div class="card stats-card bg-info text-white">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h4 class="card-title mb-0">
                                <span class="blood-tests-text">Blood Tests</span>
                            </h4>
                            <h2 class="mb-0">
                                <asp:Label ID="lblBloodTests" runat="server" Text="0"></asp:Label>
                            </h2>
                        </div>
                        <i class="fas fa-flask stats-icon"></i>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="col-md-3 mb-3">
            <div class="card stats-card bg-warning text-white">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h4 class="card-title mb-0">
                                <span class="member-since-text">Member Since</span>
                            </h4>
                            <h2 class="mb-0">
                                <asp:Label ID="lblMemberSince" runat="server" Text="2024"></asp:Label>
                            </h2>
                        </div>
                        <i class="fas fa-calendar-alt stats-icon"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Profile Form -->
    <div class="row">
        <div class="col-md-8">
            <div class="card info-card">
                <div class="card-header">
                    <h5 class="mb-0">
                        <i class="fas fa-user-edit me-2"></i>
                        <span class="personal-info-text">Personal Information</span>
                    </h5>
                </div>
                <div class="card-body">
                    <asp:Panel ID="pnlProfile" runat="server">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-floating mb-3">
                                    <asp:TextBox ID="txtFirstName" runat="server" CssClass="form-control" placeholder="First Name"></asp:TextBox>
                                    <label for="<%= txtFirstName.ClientID %>">
                                        <span class="firstName-label">First Name</span>
                                    </label>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-floating mb-3">
                                    <asp:TextBox ID="txtLastName" runat="server" CssClass="form-control" placeholder="Last Name"></asp:TextBox>
                                    <label for="<%= txtLastName.ClientID %>">
                                        <span class="lastName-label">Last Name</span>
                                    </label>
                                </div>
                            </div>
                        </div>
                        
                        <div class="form-floating mb-3">
                            <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="Email" TextMode="Email" ReadOnly="true"></asp:TextBox>
                            <label for="<%= txtEmail.ClientID %>">
                                <span class="email-label">Email</span>
                            </label>
                        </div>
                        
                        <div class="form-floating mb-3">
                            <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control" placeholder="Phone" TextMode="Phone"></asp:TextBox>
                            <label for="<%= txtPhone.ClientID %>">
                                <span class="phone-label">Phone</span>
                            </label>
                        </div>
                        
                        <div class="form-floating mb-3">
                            <asp:TextBox ID="txtNationalID" runat="server" CssClass="form-control" placeholder="National ID"></asp:TextBox>
                            <label for="<%= txtNationalID.ClientID %>">
                                <span class="nationalId-label">National ID</span>
                            </label>
                        </div>
                        
                        <div class="form-floating mb-3">
                            <asp:TextBox ID="txtDateOfBirth" runat="server" CssClass="form-control" placeholder="Date of Birth" TextMode="Date"></asp:TextBox>
                            <label for="<%= txtDateOfBirth.ClientID %>">
                                <span class="birthDate-label">Date of Birth</span>
                            </label>
                        </div>
                        
                        <asp:Button ID="btnSave" runat="server" Text="Save Changes" CssClass="btn btn-primary btn-save" OnClick="btnSave_Click" OnClientClick="console.log('Save button clicked'); return true;" />
                        
                        <asp:Label ID="lblMessage" runat="server" CssClass="text-success mt-2 d-block"></asp:Label>
                    </asp:Panel>
                </div>
            </div>
        </div>
        
        <div class="col-md-4">
            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0">
                        <i class="fas fa-shield-alt me-2"></i>
                        <span class="account-security-text">Account Security</span>
                    </h5>
                </div>
                <div class="card-body">
                    <div class="mb-3">
                        <h6>
                            <span class="change-password-text">Change Password</span>
                        </h6>
                        <p class="text-muted small">
                            <span class="password-info-text">Update your password to keep your account secure</span>
                        </p>
                        <button type="button" class="btn btn-outline-primary btn-sm" data-bs-toggle="modal" data-bs-target="#changePasswordModal">
                            <span class="change-password-button-text">Change Password</span>
                        </button>
                    </div>
                    
                    <hr>
                    
                    <div class="mb-3">
                        <h6>
                            <span class="account-status-text">Account Status</span>
                        </h6>
                        <p class="text-muted small">
                            <span class="status-info-text">Your account is active and verified</span>
                        </p>
                        <span class="badge bg-success">
                            <span class="active-status-text">Active</span>
                        </span>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Change Password Modal -->
    <div class="modal fade" id="changePasswordModal" tabindex="-1" aria-labelledby="changePasswordModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="changePasswordModalLabel">
                        <span class="change-password-modal-title">Change Password</span>
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="form-floating mb-3">
                        <asp:TextBox ID="txtCurrentPassword" runat="server" CssClass="form-control" placeholder="Current Password" TextMode="Password"></asp:TextBox>
                        <label for="<%= txtCurrentPassword.ClientID %>">
                            <span class="currentPassword-label">Current Password</span>
                        </label>
                    </div>
                    
                    <div class="form-floating mb-3">
                        <asp:TextBox ID="txtNewPassword" runat="server" CssClass="form-control" placeholder="New Password" TextMode="Password"></asp:TextBox>
                        <label for="<%= txtNewPassword.ClientID %>">
                            <span class="newPassword-label">New Password</span>
                        </label>
                    </div>
                    
                    <div class="form-floating mb-3">
                        <asp:TextBox ID="txtConfirmNewPassword" runat="server" CssClass="form-control" placeholder="Confirm New Password" TextMode="Password"></asp:TextBox>
                        <label for="<%= txtConfirmNewPassword.ClientID %>">
                            <span class="confirmNewPassword-label">Confirm New Password</span>
                        </label>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                        <span class="cancel-text">Cancel</span>
                    </button>
                    <asp:Button ID="btnChangePassword" runat="server" Text="Change Password" CssClass="btn btn-primary" OnClick="btnChangePassword_Click" />
                </div>
            </div>
        </div>
    </div>

    <!-- Success Modal -->
    <div class="modal fade" id="successModal" tabindex="-1" aria-labelledby="successModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header bg-success text-white">
                    <h5 class="modal-title" id="successModalLabel">
                        <i class="fas fa-check-circle me-2"></i>
                                                 Success
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body text-center">
                    <i class="fas fa-check-circle fa-3x text-success mb-3"></i>
                                         <h5>Profile Updated!</h5>
                     <p class="text-muted">Your profile information has been updated successfully.</p>
                </div>
                <div class="modal-footer">
                                             <button type="button" class="btn btn-success" data-bs-dismiss="modal">OK</button>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Function to update user name in sidebar
        function updateSidebarUserName() {
            var userName = sessionStorage.getItem('userName') || 'User';
            var userNameElements = document.querySelectorAll('#userName, #userText');
            for (var i = 0; i < userNameElements.length; i++) {
                var element = userNameElements[i];
                element.textContent = userName;
            }
        }

        // Add translations for profile page
        var profileTranslations = {
            tr: {
                profileTitle: "Profile",
                profileSubtitle: "Manage your personal information and account settings",
                totalAppointmentsText: "Total Appointments",
                completedAppointmentsText: "Completed",
                bloodTestsText: "Blood Tests",
                memberSinceText: "Member Since",
                personalInfoText: "Personal Information",
                firstNameLabel: "First Name",
                lastNameLabel: "Last Name",
                emailLabel: "Email",
                phoneLabel: "Phone",
                nationalIdLabel: "National ID",
                birthDateLabel: "Date of Birth",
                saveChangesText: "Save Changes",
                accountSecurityText: "Account Security",
                changePasswordText: "Change Password",
                passwordInfoText: "Update your password to keep your account secure",
                changePasswordButtonText: "Change Password",
                accountStatusText: "Account Status",
                statusInfoText: "Your account is active and verified",
                activeStatusText: "Active",
                changePasswordModalTitle: "Change Password",
                currentPasswordLabel: "Current Password",
                newPasswordLabel: "New Password",
                confirmNewPasswordLabel: "Confirm New Password",
                cancelText: "Cancel",
                changePasswordButtonText: "Change Password"
            },
            ar: {
                profileTitle: "الملف الشخصي",
                profileSubtitle: "إدارة معلوماتك الشخصية وإعدادات الحساب",
                totalAppointmentsText: "إجمالي المواعيد",
                completedAppointmentsText: "مكتمل",
                bloodTestsText: "فحوصات الدم",
                memberSinceText: "عضو منذ",
                personalInfoText: "المعلومات الشخصية",
                firstNameLabel: "الاسم الأول",
                lastNameLabel: "اسم العائلة",
                emailLabel: "البريد الإلكتروني",
                phoneLabel: "الهاتف",
                nationalIdLabel: "الهوية الوطنية",
                birthDateLabel: "تاريخ الميلاد",
                saveChangesText: "حفظ التغييرات",
                accountSecurityText: "أمان الحساب",
                changePasswordText: "تغيير كلمة المرور",
                passwordInfoText: "قم بتحديث كلمة المرور للحفاظ على أمان حسابك",
                changePasswordButtonText: "تغيير كلمة المرور",
                accountStatusText: "حالة الحساب",
                statusInfoText: "حسابك نشط ومتحقق منه",
                activeStatusText: "نشط",
                changePasswordModalTitle: "تغيير كلمة المرور",
                currentPasswordLabel: "كلمة المرور الحالية",
                newPasswordLabel: "كلمة المرور الجديدة",
                confirmNewPasswordLabel: "تأكيد كلمة المرور الجديدة",
                cancelText: "إلغاء",
                changePasswordButtonText: "تغيير كلمة المرور"
            }
        };

        // Extend the existing changeLanguage function
        var originalChangeLanguage = window.changeLanguage;
        window.changeLanguage = function(lang) {
            if (originalChangeLanguage) {
                originalChangeLanguage(lang);
            }
            
            // Update profile page specific elements
            var profileElements = document.querySelectorAll('[class*="-label"], [class*="-text"], [class*="-title"], [class*="-subtitle"], [class*="-button"]');
            for (var i = 0; i < profileElements.length; i++) {
                var element = profileElements[i];
                var key = element.className.split('-')[0];
                if (profileTranslations[lang] && profileTranslations[lang][key]) {
                    element.textContent = profileTranslations[lang][key];
                }
            }
        };

        // Add event listener for success modal
        document.addEventListener('DOMContentLoaded', function() {
            var successModal = document.getElementById('successModal');
            if (successModal) {
                successModal.addEventListener('hidden.bs.modal', function() {
                    updateSidebarUserName();
                });
            }

        });
    </script>
    </div>
</asp:Content>
