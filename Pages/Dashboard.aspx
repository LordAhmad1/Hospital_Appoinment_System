<%@ Page Title="Dashboard" Language="C#" MasterPageFile="/Site.Master" AutoEventWireup="true" CodeFile="Dashboard.aspx.cs" Inherits="HospitalAppointmentSystem.Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <meta charset="utf-8" />
    <style>
        .modern-dashboard {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
        }
        
        .welcome-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 20px;
            padding: 3rem;
            margin-bottom: 2rem;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            position: relative;
            overflow: hidden;
        }
        
        .welcome-section::before {
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
        
        .quick-actions-card {
            border: none;
            border-radius: 20px;
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
            background: white;
        }
        
        .quick-actions-card .card-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 20px 20px 0 0;
            border: none;
            padding: 1.5rem;
        }
        
        .action-btn {
            border-radius: 12px;
            padding: 1rem;
            font-weight: 600;
            transition: all 0.3s ease;
            border: none;
            position: relative;
            overflow: hidden;
        }
        
        .action-btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
            transition: left 0.5s;
        }
        
        .action-btn:hover::before {
            left: 100%;
        }
        
        .action-btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.15);
        }
        
        .appointment-card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            transition: all 0.3s ease;
            margin-bottom: 1rem;
            position: relative;
            overflow: hidden;
        }
        
        .appointment-card::before {
            content: '';
            position: absolute;
            left: 0;
            top: 0;
            bottom: 0;
            width: 5px;
            background: linear-gradient(180deg, #007bff, #0056b3);
        }
        
        .appointment-card.upcoming::before {
            background: linear-gradient(180deg, #28a745, #1e7e34);
        }
        
        .appointment-card.past::before {
            background: linear-gradient(180deg, #6c757d, #495057);
        }
        
        .appointment-card.cancelled::before {
            background: linear-gradient(180deg, #dc3545, #c82333);
        }
        
        .appointment-card:hover {
            transform: translateX(5px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.12);
        }
        
        .notifications-card {
            border: none;
            border-radius: 20px;
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
            background: white;
        }
        
        .notifications-card .card-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 20px 20px 0 0;
            border: none;
            padding: 1.5rem;
        }
        
        .notification-item {
            border-radius: 10px;
            border: none;
            margin-bottom: 0.5rem;
            background: linear-gradient(135deg, #e3f2fd 0%, #bbdefb 100%);
        }
        
        .empty-state {
            text-align: center;
            padding: 3rem 1rem;
            color: #6c757d;
        }
        
        .empty-state i {
            font-size: 4rem;
            margin-bottom: 1rem;
            opacity: 0.5;
        }
        
        .main-content {
            background: transparent;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="modern-dashboard">
        <!-- Welcome Section -->
        <div class="welcome-section">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <h1 class="mb-3 fw-bold">
                        <i class="fas fa-user-circle me-3"></i>
                        <span class="welcome-text">Welcome,</span>
                        <asp:Label ID="lblPatientName" runat="server" CssClass="fw-bold"></asp:Label>
                    </h1>
                    <p class="mb-0 fs-5">
                        <span class="welcome-subtitle">Your health is our priority. Manage your appointments with ease.</span>
                    </p>
                </div>
                <div class="col-md-4 text-end">
                    <i class="fas fa-heartbeat fa-4x opacity-75"></i>
                </div>
            </div>
        </div>

    <!-- Statistics Cards -->
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
                                <span class="upcoming-appointments-text">Upcoming Appointments</span>
                            </h4>
                            <h2 class="mb-0">
                                <asp:Label ID="lblUpcomingAppointments" runat="server" Text="0"></asp:Label>
                            </h2>
                        </div>
                        <i class="fas fa-clock stats-icon"></i>
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
                                <span class="hospitals-text">Hospitals</span>
                            </h4>
                            <h2 class="mb-0">
                                <asp:Label ID="lblHospitals" runat="server" Text="0"></asp:Label>
                            </h2>
                        </div>
                        <i class="fas fa-hospital-alt stats-icon"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>

        <!-- Quick Actions -->
        <div class="row mb-4">
            <div class="col-12">
                <div class="card quick-actions-card">
                    <div class="card-header">
                        <h4 class="mb-0">
                            <i class="fas fa-bolt me-2"></i>
                            <span class="quick-actions-text">Quick Actions</span>
                        </h4>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-3 mb-3">
                                <a href="/pages/Appointments.aspx" class="btn btn-primary action-btn w-100">
                                    <i class="fas fa-calendar-plus me-2"></i>
                                    <span class="new-appointment-text">New Appointment</span>
                                </a>
                            </div>
                            <div class="col-md-3 mb-3">
                                <a href="/pages/BloodTests.aspx" class="btn btn-info action-btn w-100">
                                    <i class="fas fa-flask me-2"></i>
                                    <span class="view-tests-text">Test Results</span>
                                </a>
                            </div>
                            <div class="col-md-3 mb-3">
                                <a href="/pages/Hospitals.aspx" class="btn btn-success action-btn w-100">
                                    <i class="fas fa-hospital-alt me-2"></i>
                                    <span class="find-hospital-text">Find Hospital</span>
                                </a>
                            </div>
                            <div class="col-md-3 mb-3">
                                <a href="/pages/Profile.aspx" class="btn btn-secondary action-btn w-100">
                                    <i class="fas fa-user-edit me-2"></i>
                                    <span class="edit-profile-text">Edit Profile</span>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Recent Appointments -->
        <div class="row">
            <div class="col-md-8">
                <div class="card">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h4 class="mb-0">
                            <i class="fas fa-history me-2"></i>
                            <span class="recent-appointments-text">Recent Appointments</span>
                        </h4>
                        <a href="/pages/Appointments.aspx" class="btn btn-outline-primary">
                            <span class="view-all-text">View All</span>
                        </a>
                    </div>
                    <div class="card-body">
                        <asp:Panel ID="pnlNoAppointments" runat="server" Visible="false" CssClass="empty-state">
                            <i class="fas fa-calendar-times"></i>
                            <h5 class="mb-3">
                                <span class="no-appointments-text">No appointments yet</span>
                            </h5>
                            <p class="text-muted mb-4">
                                <span class="no-appointments-desc">Start by booking your first appointment with our qualified doctors.</span>
                            </p>
                            <a href="/pages/Appointments.aspx" class="btn btn-primary btn-lg">
                                <i class="fas fa-calendar-plus me-2"></i>
                                <span class="book-appointment-text">Book Appointment</span>
                            </a>
                        </asp:Panel>
                    
                    <asp:Repeater ID="rptRecentAppointments" runat="server">
                        <ItemTemplate>
                            <div class="appointment-card card mb-3 <%# GetAppointmentStatusClass(Eval("Status").ToString()) %>">
                                <div class="card-body">
                                    <div class="row align-items-center">
                                        <div class="col-md-3">
                                            <h6 class="mb-1">
                                                <i class="fas fa-user-md me-1"></i>
                                                <span class="doctor-text">Doctor:</span>
                                            </h6>
                                            <p class="mb-0"><%# Eval("DoctorName") %></p>
                                        </div>
                                        <div class="col-md-3">
                                            <h6 class="mb-1">
                                                <i class="fas fa-hospital me-1"></i>
                                                <span class="hospital-text">Hospital:</span>
                                            </h6>
                                            <p class="mb-0"><%# Eval("HospitalName") %></p>
                                        </div>
                                        <div class="col-md-3">
                                            <h6 class="mb-1">
                                                <i class="fas fa-calendar me-1"></i>
                                                <span class="date-text">Date:</span>
                                            </h6>
                                            <p class="mb-0"><%# Convert.ToDateTime(Eval("AppointmentDate")).ToString("dd/MM/yyyy") %></p>
                                        </div>
                                        <div class="col-md-3">
                                            <span class="badge <%# GetStatusBadgeClass(Eval("Status").ToString()) %>">
                                                <%# GetStatusText(Eval("Status").ToString()) %>
                                            </span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </div>
        </div>
        
            <div class="col-md-4">
                <div class="card notifications-card">
                    <div class="card-header">
                        <h4 class="mb-0">
                            <i class="fas fa-bell me-2"></i>
                            <span class="notifications-text">Notifications</span>
                        </h4>
                    </div>
                    <div class="card-body">
                        <asp:Panel ID="pnlNoNotifications" runat="server" Visible="false" CssClass="empty-state">
                            <i class="fas fa-bell-slash"></i>
                            <h6 class="mb-2">
                                <span class="no-notifications-text">No notifications</span>
                            </h6>
                            <p class="text-muted small">
                                <span class="no-notifications-desc">You're all caught up!</span>
                            </p>
                        </asp:Panel>
                        
                        <asp:Repeater ID="rptNotifications" runat="server">
                            <ItemTemplate>
                                <div class="alert notification-item alert-dismissible fade show mb-2" role="alert">
                                    <i class="fas fa-info-circle me-2"></i>
                                    <%# Eval("Message") %>
                                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Add translations for dashboard page
        const dashboardTranslations = {
            tr: {
                welcomeText: "Welcome,",
                welcomeSubtitle: "Welcome to your hospital appointment system",
                totalAppointmentsText: "Total Appointments",
                upcomingAppointmentsText: "Upcoming Appointments",
                bloodTestsText: "Blood Tests",
                hospitalsText: "Hospitals",
                quickActionsText: "Quick Actions",
                newAppointmentText: "New Appointment",
                viewTestsText: "Test Results",
                findHospitalText: "Find Hospital",
                editProfileText: "Edit Profile",
                recentAppointmentsText: "Recent Appointments",
                viewAllText: "View All",
                doctorText: "Doctor:",
                hospitalText: "Hospital:",
                dateText: "Date:",
                noAppointmentsText: "You don't have any appointments yet.",
                bookAppointmentText: "Book Appointment",
                notificationsText: "Notifications",
                noNotificationsText: "No notifications."
            },
            ar: {
                welcomeText: "مرحباً،",
                welcomeSubtitle: "مرحباً بك في نظام مواعيد المستشفى",
                totalAppointmentsText: "إجمالي المواعيد",
                upcomingAppointmentsText: "المواعيد القادمة",
                bloodTestsText: "فحوصات الدم",
                hospitalsText: "المستشفيات",
                quickActionsText: "الإجراءات السريعة",
                newAppointmentText: "موعد جديد",
                viewTestsText: "نتائج الفحوصات",
                findHospitalText: "البحث عن مستشفى",
                editProfileText: "تعديل الملف الشخصي",
                recentAppointmentsText: "المواعيد الأخيرة",
                viewAllText: "عرض الكل",
                doctorText: "الطبيب:",
                hospitalText: "المستشفى:",
                dateText: "التاريخ:",
                noAppointmentsText: "لا توجد مواعيد بعد.",
                bookAppointmentText: "احجز موعد",
                notificationsText: "الإشعارات",
                noNotificationsText: "لا توجد إشعارات."
            }
        };

        // Extend the existing changeLanguage function
        const originalChangeLanguage = window.changeLanguage;
        window.changeLanguage = function(lang) {
            originalChangeLanguage(lang);
            
            // Update dashboard page specific elements
            const dashboardElements = document.querySelectorAll('[class*="-text"]');
            dashboardElements.forEach(element => {
                const key = element.className.split('-')[0];
                if (dashboardTranslations[lang] && dashboardTranslations[lang][key]) {
                    element.textContent = dashboardTranslations[lang][key];
                }
            });
        };
    </script>
</asp:Content>
