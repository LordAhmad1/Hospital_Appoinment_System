<%@ Page Title="Appointments" Language="C#" MasterPageFile="/Site.Master" AutoEventWireup="true" CodeFile="Appointments.aspx.cs" Inherits="HospitalAppointmentSystem.Appointments" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <meta charset="utf-8" />
    <style>
        .modern-appointments {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
        }
        
        .booking-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 20px;
            padding: 3rem;
            margin-bottom: 2rem;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            position: relative;
            overflow: hidden;
        }
        
        .booking-section::before {
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
        
        .appointment-card.scheduled::before {
            background: linear-gradient(180deg, #28a745, #1e7e34);
        }
        
        .appointment-card.completed::before {
            background: linear-gradient(180deg, #6c757d, #495057);
        }
        
        .appointment-card.cancelled::before {
            background: linear-gradient(180deg, #dc3545, #c82333);
        }
        
        .appointment-card:hover {
            transform: translateX(5px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.12);
        }
        
        .booking-form-card {
            border: none;
            border-radius: 20px;
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
            background: white;
        }
        
        .booking-form-card .card-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 20px 20px 0 0;
            border: none;
            padding: 1.5rem;
        }
        
        .time-slot {
            cursor: pointer;
            transition: all 0.3s ease;
            border-radius: 10px;
            border: 2px solid #e9ecef;
            background: white;
            position: relative;
            overflow: hidden;
        }
        
        .time-slot::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(0,123,255,0.1), transparent);
            transition: left 0.5s;
        }
        
        .time-slot:hover::before {
            left: 100%;
        }
        
        .time-slot:hover {
            border-color: #007bff;
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0,123,255,0.2);
        }
        
        .time-slot.selected {
            background: linear-gradient(135deg, #007bff, #0056b3);
            color: white;
            border-color: #007bff;
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(0,123,255,0.3);
        }
        
        .time-slot.disabled {
            background: #f8f9fa;
            color: #6c757d;
            cursor: not-allowed;
            opacity: 0.6;
        }
        
        .time-slot.disabled:hover {
            transform: none;
            box-shadow: none;
            border-color: #e9ecef;
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
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="modern-appointments">
        <!-- Booking Section -->
        <div class="booking-section">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <h1 class="mb-3 fw-bold">
                        <i class="fas fa-calendar-plus me-3"></i>
                        <span class="appointments-title">Appointment Management</span>
                    </h1>
                    <p class="mb-0 fs-5">
                        <span class="appointments-subtitle">Book new appointments or manage your existing appointments</span>
                    </p>
                </div>
                <div class="col-md-4 text-end">
                    <button type="button" class="btn btn-light btn-lg" data-bs-toggle="modal" data-bs-target="#bookingModal">
                        <i class="fas fa-plus me-2"></i>
                        <span class="new-appointment-text">New Appointment</span>
                    </button>
                </div>
            </div>
        </div>

        <!-- Appointment Filters -->
        <div class="card booking-form-card mb-4">
            <div class="card-header">
                <h4 class="mb-0">
                    <i class="fas fa-filter me-2"></i>
                    <span class="filters-text">Filter Appointments</span>
                </h4>
            </div>
            <div class="card-body">
            <div class="row">
                <div class="col-md-3">
                    <label for="<%= ddlStatus.ClientID %>" class="form-label">
                        <span class="status-label">Status:</span>
                    </label>
                    <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="ddlStatus_SelectedIndexChanged">
                        <asp:ListItem Text="All" Value="" />
                        <asp:ListItem Text="Scheduled" Value="Scheduled" />
                        <asp:ListItem Text="Completed" Value="Completed" />
                        <asp:ListItem Text="Cancelled" Value="Cancelled" />
                    </asp:DropDownList>
                </div>
                <div class="col-md-3">
                                         <label for="<%= ddlHospital.ClientID %>" class="form-label">
                         <span class="hospital-label">Hospital:</span>
                     </label>
                     <asp:DropDownList ID="ddlHospital" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="ddlHospital_SelectedIndexChanged">
                         <asp:ListItem Text="All Hospitals" Value="" />
                    </asp:DropDownList>
                </div>
                <div class="col-md-3">
                    <label for="<%= txtDateFrom.ClientID %>" class="form-label">
                        <span class="date-from-label">Start Date:</span>
                    </label>
                    <asp:TextBox ID="txtDateFrom" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                </div>
                <div class="col-md-3">
                    <label for="<%= txtDateTo.ClientID %>" class="form-label">
                        <span class="date-to-label">End Date:</span>
                    </label>
                    <asp:TextBox ID="txtDateTo" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                </div>
            </div>
            <div class="row mt-3">
                <div class="col-12">
                                         <asp:Button ID="btnFilter" runat="server" Text="Filter" CssClass="btn btn-primary" OnClick="btnFilter_Click" />
                     <asp:Button ID="btnClear" runat="server" Text="Clear" CssClass="btn btn-secondary" OnClick="btnClear_Click" />
                </div>
            </div>
        </div>
    </div>

    <!-- Appointments List -->
    <asp:Panel ID="pnlNoAppointments" runat="server" Visible="false" CssClass="col-12">
        <div class="text-center py-5">
            <i class="fas fa-calendar-times fa-3x text-muted mb-3"></i>
            <h5 class="text-muted">
                                 <span class="no-appointments-text">You don't have any appointments yet.</span>
            </h5>
            <p class="text-muted">
                                 <span class="no-appointments-subtitle">Click the button above to book a new appointment.</span>
            </p>
            <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#bookingModal">
                                 <span class="book-appointment-text">Book Appointment</span>
            </button>
        </div>
    </asp:Panel>
    
    <div class="row">
        <asp:Repeater ID="rptAppointments" runat="server">
            <ItemTemplate>
                <div class="col-md-6 col-lg-4 mb-4">
                    <div class="card appointment-card <%# GetAppointmentStatusClass(Eval("Status").ToString()) %>">
                        <div class="card-header">
                            <div class="d-flex justify-content-between align-items-center">
                                <h6 class="mb-0">
                                    <i class="fas fa-calendar-check me-2"></i>
                                    <%# Convert.ToDateTime(Eval("AppointmentDate")).ToString("dd/MM/yyyy") %>
                                </h6>
                                <span class="badge <%# GetStatusBadgeClass(Eval("Status").ToString()) %>">
                                    <%# GetStatusText(Eval("Status").ToString()) %>
                                </span>
                            </div>
                        </div>
                        <div class="card-body">
                            <div class="row mb-2">
                                <div class="col-6">
                                    <small class="text-muted">
                                                                                 <span class="time-label">Time:</span>
                                    </small>
                                </div>
                                <div class="col-6 text-end">
                                    <small><%# ((TimeSpan)Eval("AppointmentTime")).ToString(@"hh\:mm") %></small>
                                </div>
                            </div>
                            
                            <div class="row mb-2">
                                <div class="col-6">
                                    <small class="text-muted">
                                                                                 <span class="doctor-label">Doctor:</span>
                                    </small>
                                </div>
                                <div class="col-6 text-end">
                                    <small><%# Eval("DoctorName") %></small>
                                </div>
                            </div>
                            
                            <div class="row mb-2">
                                <div class="col-6">
                                    <small class="text-muted">
                                                                                 <span class="hospital-label">Hospital:</span>
                                    </small>
                                </div>
                                <div class="col-6 text-end">
                                    <small><%# Eval("HospitalName") %></small>
                                </div>
                            </div>
                            
                            <div class="row mb-2">
                                <div class="col-6">
                                    <small class="text-muted">
                                                                                 <span class="specialization-label">Specialization:</span>
                                    </small>
                                </div>
                                <div class="col-6 text-end">
                                    <small><%# Eval("Specialization") %></small>
                                </div>
                            </div>
                            
                            <div class="row">
                                                                 <div class="col-6">
                                     <small class="text-muted">
                                         <span class="notes-label">Notes:</span>
                                     </small>
                                 </div>
                                <div class="col-6 text-end">
                                    <small><%# Eval("Notes") %></small>
                                </div>
                            </div>
                        </div>
                        <div class="card-footer">
                            <div class="d-flex justify-content-between">
                                                                 <asp:Button ID="btnCancel" runat="server" Text="Cancel"  
                                           CssClass="btn btn-sm btn-outline-danger" 
                                           CommandName="CancelAppointment" 
                                           CommandArgument='<%# Eval("Id") %>' 
                                           OnCommand="btnCancel_Command"
                                           Visible='<%# Eval("Status").ToString() == "Scheduled" %>' />
                                                                 <asp:Button ID="btnReschedule" runat="server" Text="Reschedule"  
                                           CssClass="btn btn-sm btn-outline-warning" 
                                           CommandName="RescheduleAppointment" 
                                           CommandArgument='<%# Eval("Id") %>' 
                                           OnCommand="btnReschedule_Command"
                                           Visible='<%# Eval("Status").ToString() == "Scheduled" %>' />
                                                                 <asp:Button ID="btnViewDetails" runat="server" Text="Details"  
                                           CssClass="btn btn-sm btn-outline-primary" 
                                           CommandName="ViewDetails" 
                                           CommandArgument='<%# Eval("Id") %>' 
                                           OnCommand="btnViewDetails_Command" />
                            </div>
                        </div>
                    </div>
                </div>
            </ItemTemplate>

        </asp:Repeater>
    </div>

    <!-- Pagination -->
    <div class="row mt-4">
        <div class="col-12">
                         <nav aria-label="Appointment pagination">
                <ul class="pagination justify-content-center">
                    <li class="page-item">
                        <asp:LinkButton ID="lnkPrevious" runat="server" CssClass="page-link" OnClick="lnkPrevious_Click">
                                                         <span class="previous-text">Previous</span>
                        </asp:LinkButton>
                    </li>
                    <li class="page-item">
                        <asp:Label ID="lblPageInfo" runat="server" CssClass="page-link"></asp:Label>
                    </li>
                    <li class="page-item">
                        <asp:LinkButton ID="lnkNext" runat="server" CssClass="page-link" OnClick="lnkNext_Click">
                                                         <span class="next-text">Next</span>
                        </asp:LinkButton>
                    </li>
                </ul>
            </nav>
        </div>
    </div>

    <!-- Booking Modal -->
    <div class="modal fade" id="bookingModal" tabindex="-1" aria-labelledby="bookingModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="bookingModalLabel">
                                                 <span class="booking-modal-title">Book New Appointment</span>
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="<%= ddlBookingHospital.ClientID %>" class="form-label">
                                                                         <span class="hospital-selection-label">Select Hospital:</span>
                                </label>
                                <asp:DropDownList ID="ddlBookingHospital" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="ddlBookingHospital_SelectedIndexChanged">
                                </asp:DropDownList>
                            </div>
                            
                            <div class="mb-3">
                                <label for="<%= ddlBookingSpecialization.ClientID %>" class="form-label">
                                                                         <span class="specialization-selection-label">Select Specialization:</span>
                                </label>
                                <asp:DropDownList ID="ddlBookingSpecialization" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="ddlBookingSpecialization_SelectedIndexChanged">
                                </asp:DropDownList>
                            </div>
                            
                            <div class="mb-3">
                                <label for="<%= ddlBookingDoctor.ClientID %>" class="form-label">
                                    <span class="doctor-selection-label">Select Doctor:</span>
                                </label>
                                <asp:DropDownList ID="ddlBookingDoctor" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="ddlBookingDoctor_SelectedIndexChanged">
                                </asp:DropDownList>
                            </div>
                            
                            <div class="mb-3">
                                <label for="<%= txtBookingDate.ClientID %>" class="form-label">
                                    <span class="date-selection-label">Select Date:</span>
                                </label>
                                <asp:TextBox ID="txtBookingDate" runat="server" CssClass="form-control" TextMode="Date" AutoPostBack="true" OnTextChanged="txtBookingDate_TextChanged"></asp:TextBox>
                            </div>
                        </div>
                        
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label class="form-label">
                                    <span class="time-selection-label">Select Time:</span>
                                </label>
                                <div class="time-slots" id="timeSlots">
                                    <!-- Time slots will be populated dynamically -->
                                </div>
                            </div>
                            
                            <div class="mb-3">
                                <label for="<%= txtBookingNotes.ClientID %>" class="form-label">
                                    <span class="notes-label">Notlar:</span>
                                </label>
                                <asp:TextBox ID="txtBookingNotes" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" placeholder="Your appointment notes..."></asp:TextBox>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                        <span class="cancel-text">Cancel</span>
                    </button>
                    <asp:Button ID="btnBookAppointment" runat="server" Text="Book Appointment" CssClass="btn btn-primary" OnClick="btnBookAppointment_Click" />
                </div>
            </div>
        </div>
    </div>

    <script>
        // Add translations for appointments page
        var appointmentsTranslations = {
            tr: {
                appointmentsTitle: "Appointment Management",
                appointmentsSubtitle: "Book a new appointment or manage your existing appointments",
                newAppointmentText: "New Appointment",
                statusLabel: "Status:",
                hospitalLabel: "Hospital:",
                dateFromLabel: "Start Date:",
                dateToLabel: "End Date:",
                filterText: "Filter",
                clearText: "Clear",
                timeLabel: "Time:",
                doctorLabel: "Doctor:",
                specializationLabel: "Specialization:",
                notesLabel: "Notes:",
                cancelText: "Cancel",
                rescheduleText: "Reschedule",
                detailsText: "Details",
                noAppointmentsText: "No appointments found yet.",
                noAppointmentsSubtitle: "Click the button above to book a new appointment.",
                bookAppointmentText: "Book Appointment",
                previousText: "Previous",
                nextText: "Next",
                bookingModalTitle: "Book New Appointment",
                hospitalSelectionLabel: "Select Hospital:",
                specializationSelectionLabel: "Select Specialization:",
                doctorSelectionLabel: "Select Doctor:",
                dateSelectionLabel: "Select Date:",
                timeSelectionLabel: "Select Time:",
                cancelModalText: "Cancel"
            },
            ar: {
                appointmentsTitle: "إدارة المواعيد",
                appointmentsSubtitle: "احجز موعد جديد أو أدر مواعيدك الحالية",
                newAppointmentText: "موعد جديد",
                statusLabel: "الحالة:",
                hospitalLabel: "المستشفى:",
                dateFromLabel: "تاريخ البداية:",
                dateToLabel: "تاريخ النهاية:",
                filterText: "تصفية",
                clearText: "مسح",
                timeLabel: "الوقت:",
                doctorLabel: "الطبيب:",
                specializationLabel: "التخصص:",
                notesLabel: "ملاحظات:",
                cancelText: "إلغاء",
                rescheduleText: "إعادة جدولة",
                detailsText: "التفاصيل",
                noAppointmentsText: "لا توجد مواعيد بعد.",
                noAppointmentsSubtitle: "انقر على الزر أعلاه لحجز موعد جديد.",
                bookAppointmentText: "احجز موعد",
                previousText: "السابق",
                nextText: "التالي",
                bookingModalTitle: "حجز موعد جديد",
                hospitalSelectionLabel: "اختر المستشفى:",
                specializationSelectionLabel: "اختر التخصص:",
                doctorSelectionLabel: "اختر الطبيب:",
                dateSelectionLabel: "اختر التاريخ:",
                timeSelectionLabel: "اختر الوقت:",
                cancelModalText: "إلغاء"
            }
        };

        // Extend the existing changeLanguage function
        var originalChangeLanguage = window.changeLanguage;
        window.changeLanguage = function(lang) {
            if (originalChangeLanguage) {
                originalChangeLanguage(lang);
            }
            
            // Update appointments page specific elements
            var appointmentsElements = document.querySelectorAll('[class*="-text"], [class*="-label"], [class*="-title"], [class*="-subtitle"]');
            for (var i = 0; i < appointmentsElements.length; i++) {
                var element = appointmentsElements[i];
                var key = element.className.split('-')[0];
                if (appointmentsTranslations[lang] && appointmentsTranslations[lang][key]) {
                    element.textContent = appointmentsTranslations[lang][key];
                }
            }
        };

        // Time slot selection functionality
        function selectTimeSlot(timeSlot) {
            // Remove previous selection
            var selectedSlots = document.querySelectorAll('.time-slot.selected');
            for (var i = 0; i < selectedSlots.length; i++) {
                selectedSlots[i].classList.remove('selected');
            }
            
            // Add selection to clicked slot
            timeSlot.classList.add('selected');
            
            // Store selected time
            document.getElementById('selectedTime').value = timeSlot.dataset.time;
        }

        // Generate time slots
        function generateTimeSlots() {
            var timeSlotsContainer = document.getElementById('timeSlots');
            var startHour = 9;
            var endHour = 17;
            var interval = 30; // minutes
            
            timeSlotsContainer.innerHTML = '';
            
            for (var hour = startHour; hour < endHour; hour++) {
                for (var minute = 0; minute < 60; minute += interval) {
                    var time = hour.toString().padStart(2, '0') + ':' + minute.toString().padStart(2, '0');
                    var timeSlot = document.createElement('div');
                    timeSlot.className = 'time-slot p-2 border rounded mb-2';
                    timeSlot.dataset.time = time;
                    timeSlot.textContent = time;
                    timeSlot.onclick = function() { selectTimeSlot(this); };
                    
                    timeSlotsContainer.appendChild(timeSlot);
                }
            }
        }

        // Initialize time slots when modal opens
        document.addEventListener('DOMContentLoaded', function() {
            var bookingModal = document.getElementById('bookingModal');
            bookingModal.addEventListener('show.bs.modal', function() {
                generateTimeSlots();
            });
        });
    </script>
</asp:Content>
