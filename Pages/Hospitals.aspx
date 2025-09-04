<%@ Page Title="Hospitals" Language="C#" MasterPageFile="/Site.Master" AutoEventWireup="true" CodeFile="Hospitals.aspx.cs" Inherits="HospitalAppointmentSystem.Hospitals" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <meta charset="utf-8" />
    <style>
        .modern-hospitals {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
        }
        
        .page-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 20px;
            padding: 3rem;
            margin-bottom: 2rem;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            position: relative;
            overflow: hidden;
        }
        
        .page-header::before {
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
        
        .hospital-card {
            transition: all 0.3s ease;
            cursor: pointer;
            margin-bottom: 1.5rem;
            display: block;
            width: 100%;
            border: none;
            border-radius: 20px;
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
            overflow: hidden;
            position: relative;
        }
        
        .hospital-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #667eea, #764ba2);
        }
        
        .hospital-card:hover {
            transform: translateY(-10px) scale(1.02);
            box-shadow: 0 20px 40px rgba(0,0,0,0.15);
        }
        
        /* Ensure proper grid layout */
        .hospitals-grid {
            display: flex;
            flex-wrap: wrap;
            margin: -0.75rem;
        }
        
        .hospitals-grid .col-md-6,
        .hospitals-grid .col-lg-4 {
            padding: 0.75rem;
            flex: 0 0 auto;
            width: 100%;
        }
        
        @media (min-width: 768px) {
            .hospitals-grid .col-md-6 {
                flex: 0 0 50%;
                max-width: 50%;
                width: 50%;
            }
        }
        
        @media (min-width: 992px) {
            .hospitals-grid .col-lg-4 {
                flex: 0 0 33.333333%;
                max-width: 33.333333%;
                width: 33.333333%;
            }
        }
        
        /* Fallback for Bootstrap grid issues */
        .row {
            display: flex;
            flex-wrap: wrap;
            margin-right: -15px;
            margin-left: -15px;
        }
        
        .col-md-6, .col-lg-4 {
            position: relative;
            width: 100%;
            padding-right: 15px;
            padding-left: 15px;
        }
        
        @media (min-width: 768px) {
            .col-md-6 {
                flex: 0 0 50%;
                max-width: 50%;
            }
        }
        
        @media (min-width: 992px) {
            .col-lg-4 {
                flex: 0 0 33.333333%;
                max-width: 33.333333%;
            }
        }
        .hospital-image {
            height: 200px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 3rem;
            position: relative;
            overflow: hidden;
        }
        
        .hospital-image::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="grain" width="100" height="100" patternUnits="userSpaceOnUse"><circle cx="25" cy="25" r="1" fill="rgba(255,255,255,0.1)"/><circle cx="75" cy="75" r="1" fill="rgba(255,255,255,0.1)"/><circle cx="50" cy="10" r="0.5" fill="rgba(255,255,255,0.1)"/><circle cx="10" cy="60" r="0.5" fill="rgba(255,255,255,0.1)"/><circle cx="90" cy="40" r="0.5" fill="rgba(255,255,255,0.1)"/></pattern></defs><rect width="100" height="100" fill="url(%23grain)"/></svg>');
            opacity: 0.3;
        }
        
        .hospital-info {
            padding: 1.5rem;
            background: white;
        }
        
        .hospital-name {
            font-size: 1.25rem;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 0.5rem;
        }
        
        .hospital-address {
            color: #6c757d;
            font-size: 0.9rem;
            margin-bottom: 1rem;
        }
        
        .hospital-features {
            display: flex;
            flex-wrap: wrap;
            gap: 0.5rem;
            margin-bottom: 1rem;
        }
        
        .feature-badge {
            background: linear-gradient(135deg, #e3f2fd, #bbdefb);
            color: #1976d2;
            padding: 0.25rem 0.75rem;
            border-radius: 15px;
            font-size: 0.8rem;
            font-weight: 500;
        }
        
        .hospital-actions {
            display: flex;
            gap: 0.5rem;
        }
        
        .btn-hospital {
            flex: 1;
            border-radius: 10px;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
        }
        
        .btn-outline-primary {
            border: 2px solid #667eea;
            color: #667eea;
        }
        
        .btn-hospital:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.15);
        }
        
        .main-content {
            background: transparent;
        }
        .specialization-badge {
            font-size: 0.8em;
            margin-right: 0.25rem;
            margin-bottom: 0.25rem;
        }
        .rating-stars {
            color: #ffc107;
        }
        .search-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 15px;
            padding: 2rem;
            margin-bottom: 2rem;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="modern-hospitals">
        <!-- Search Section -->
        <div class="page-header">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <h1 class="mb-3 fw-bold">
                        <i class="fas fa-hospital-alt me-3"></i>
                        <span class="hospitals-title">Hospitals</span>
                    </h1>
                    <p class="mb-0 fs-5">
                        <span class="hospitals-subtitle">Find the most suitable hospital and book an appointment</span>
                    </p>
                </div>
                <div class="col-md-4 text-end">
                    <i class="fas fa-search fa-4x opacity-75"></i>
                </div>
            </div>
        </div>

    <!-- Search Filters -->
    <div class="card mb-4">
        <div class="card-body">
            <div class="row">
                <div class="col-md-4">
                    <label for="<%= txtSearch.ClientID %>" class="form-label">
                        <span class="search-label">Search Hospital:</span>
                    </label>
                    <div class="input-group">
                        <span class="input-group-text">
                            <i class="fas fa-search"></i>
                        </span>
                        <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" placeholder="Hospital name or location..."></asp:TextBox>
                    </div>
                </div>
                <div class="col-md-3">
                    <label for="<%= ddlSpecialization.ClientID %>" class="form-label">
                        <span class="specialization-label">Uzmanl&#305;k:</span>
                    </label>
                    <asp:DropDownList ID="ddlSpecialization" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="ddlSpecialization_SelectedIndexChanged">
                        <asp:ListItem Text="All Specializations" Value="" />
                        <asp:ListItem Text="Cardiology" Value="Cardiology" />
                        <asp:ListItem Text="Neurology" Value="Neurology" />
                        <asp:ListItem Text="Orthopedics" Value="Orthopedics" />
                        <asp:ListItem Text="Internal Medicine" Value="Internal Medicine" />
                        <asp:ListItem Text="Ophthalmology" Value="Ophthalmology" />
                        <asp:ListItem Text="ENT" Value="ENT" />
                        <asp:ListItem Text="Dermatology" Value="Dermatology" />
                        <asp:ListItem Text="Psychiatry" Value="Psychiatry" />
                        <asp:ListItem Text="Pediatrics" Value="Pediatrics" />
                        <asp:ListItem Text="Gynecology" Value="Gynecology" />
                    </asp:DropDownList>
                </div>
                <div class="col-md-3">
                    <label for="<%= ddlCity.ClientID %>" class="form-label">
                        <span class="city-label">City:</span>
                    </label>
                    <asp:DropDownList ID="ddlCity" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="ddlCity_SelectedIndexChanged">
                        <asp:ListItem Text="All Cities" Value="" />
                        <asp:ListItem Text="Istanbul" Value="Istanbul" />
                        <asp:ListItem Text="Ankara" Value="Ankara" />
                        <asp:ListItem Text="Izmir" Value="Izmir" />
                        <asp:ListItem Text="Bursa" Value="Bursa" />
                        <asp:ListItem Text="Antalya" Value="Antalya" />
                    </asp:DropDownList>
                </div>
                <div class="col-md-2">
                    <label for="<%= ddlRating.ClientID %>" class="form-label">
                        <span class="rating-label">Rating:</span>
                    </label>
                    <asp:DropDownList ID="ddlRating" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="ddlRating_SelectedIndexChanged">
                        <asp:ListItem Text="All" Value="0" />
                        <asp:ListItem Text="4+ Stars" Value="4" />
                        <asp:ListItem Text="3+ Stars" Value="3" />
                        <asp:ListItem Text="2+ Stars" Value="2" />
                    </asp:DropDownList>
                </div>
            </div>
            <div class="row mt-3">
                <div class="col-12">
                    <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn btn-primary" OnClick="btnSearch_Click" />
                    <asp:Button ID="btnClear" runat="server" Text="Clear" CssClass="btn btn-secondary" OnClick="btnClear_Click" />
                </div>
            </div>
        </div>
    </div>

    <!-- Hospitals List -->
    <asp:Panel ID="pnlNoHospitals" runat="server" Visible="false" CssClass="col-12">
        <div class="text-center py-5">
            <i class="fas fa-hospital fa-3x text-muted mb-3"></i>
            <h5 class="text-muted">
                <span class="no-hospitals-text">No hospitals found matching your search criteria.</span>
            </h5>
            <p class="text-muted">
                <span class="no-hospitals-subtitle">You can try different search criteria.</span>
            </p>
            <asp:Button ID="btnResetSearch" runat="server" Text="Reset Search" 
                       CssClass="btn btn-primary" OnClick="btnResetSearch_Click" />
        </div>
    </asp:Panel>
    
    <div class="row hospitals-grid">
        <asp:Repeater ID="rptHospitals" runat="server">
            <ItemTemplate>
                <div class="col-md-6 col-lg-4 mb-4">
                    <div class="card hospital-card h-100" data-hospital-id="<%# Eval("Id") %>" data-hospital-name="<%# Server.HtmlEncode(Eval("Name").ToString()) %>">
                        <img src='<%# GetHospitalImage(Eval("Id").ToString()) %>' class="hospital-image" alt='<%# Eval("Name") %>' />
                        <div class="card-body">
                            <h5 class="card-title">
                                <i class="fas fa-hospital me-2"></i>
                                <%# Eval("Name") %>
                            </h5>
                            
                            <div class="mb-2">
                                <i class="fas fa-map-marker-alt text-muted me-1"></i>
                                <small class="text-muted"><%# Eval("Address") %></small>
                            </div>
                            
                            <div class="mb-2">
                                <i class="fas fa-phone text-muted me-1"></i>
                                <small class="text-muted"><%# Eval("Phone") %></small>
                            </div>
                            
                            <div class="mb-3">
                                <div class="rating-stars">
                                    <%# GetStarRating(Convert.ToDouble(Eval("Rating"))) %>
                                </div>
                                <small class="text-muted">(<%# Eval("Rating") %>/5)</small>
                            </div>
                            
                            <div class="mb-3">
                                <h6 class="mb-2">
                                    <span class="specializations-label">Specializations:</span>
                                </h6>
                                <div>
                                    <%# GetSpecializationBadges(Eval("Specializations").ToString()) %>
                                </div>
                            </div>
                            
                            <div class="d-flex justify-content-between align-items-center">
                                <span class="badge bg-success">
                                    <i class="fas fa-clock me-1"></i>
                                    <span class="availability-text">Available</span>
                                </span>
                                <asp:Button ID="btnBookAppointment" runat="server" Text="Book Appointment" 
                                           CssClass="btn btn-primary btn-sm" 
                                           CommandName="BookAppointment" 
                                           CommandArgument='<%# Eval("Id") %>' 
                                           OnCommand="btnBookAppointment_Command" />
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
            <nav aria-label="Hospital pagination">
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

    <script>
        // Add event listeners when page loads
        document.addEventListener('DOMContentLoaded', function() {
            document.addEventListener('click', function(e) {
                if (e.target.closest('.hospital-card')) {
                    var card = e.target.closest('.hospital-card');
                    var hospitalId = card.getAttribute('data-hospital-id');
                    var hospitalName = card.getAttribute('data-hospital-name');
                    
                    // Store selected hospital info for appointment booking
                    sessionStorage.setItem('selectedHospitalId', hospitalId);
                    sessionStorage.setItem('selectedHospitalName', hospitalName);
                    
                    // Show confirmation
                    if (confirm('You selected "' + hospitalName + '" hospital. You will be redirected to the appointment page.')) {
                        window.location.href = '/pages/Appointments.aspx';
                    }
                }
            });
        });

        // Add translations for hospitals page
        var hospitalsTranslations = {
            tr: {
                hospitalsTitle: "Hospitals",
                hospitalsSubtitle: "Find the most suitable hospital and book an appointment",
                searchLabel: "Search Hospital:",
                specializationLabel: "Specialization:",
                cityLabel: "City:",
                ratingLabel: "Rating:",
                searchText: "Search",
                clearText: "Clear",
                specializationsLabel: "Specializations:",
                availabilityText: "Available",
                bookAppointmentText: "Book Appointment",
                noHospitalsText: "No hospitals found matching your search criteria.",
                noHospitalsSubtitle: "You can try different search criteria.",
                resetSearchText: "Reset Search",
                previousText: "Previous",
                nextText: "Next"
            },
            ar: {
                hospitalsTitle: "المستشفيات",
                hospitalsSubtitle: "ابحث عن المستشفى المناسب لك واحجز موعد",
                searchLabel: "البحث عن مستشفى:",
                specializationLabel: "التخصص:",
                cityLabel: "المدينة:",
                ratingLabel: "التقييم:",
                searchText: "بحث",
                clearText: "مسح",
                specializationsLabel: "التخصصات:",
                availabilityText: "متاح",
                bookAppointmentText: "احجز موعد",
                noHospitalsText: "لم يتم العثور على مستشفى يناسب معايير البحث.",
                noHospitalsSubtitle: "يمكنك تجربة معايير بحث مختلفة.",
                resetSearchText: "إعادة تعيين البحث",
                previousText: "السابق",
                nextText: "التالي"
            }
        };

        // Extend the existing changeLanguage function
        var originalChangeLanguage = window.changeLanguage;
        window.changeLanguage = function(lang) {
            if (originalChangeLanguage) {
                originalChangeLanguage(lang);
            }
            
            // Update hospitals page specific elements
            var hospitalsElements = document.querySelectorAll('[class*="-text"], [class*="-label"], [class*="-title"], [class*="-subtitle"]');
            for (var i = 0; i < hospitalsElements.length; i++) {
                var element = hospitalsElements[i];
                var key = element.className.split('-')[0];
                if (hospitalsTranslations[lang] && hospitalsTranslations[lang][key]) {
                    element.textContent = hospitalsTranslations[lang][key];
                }
            }
        };
    </script>
</asp:Content>
