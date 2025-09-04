<%@ Page Title="Blood Tests" Language="C#" MasterPageFile="/Site.Master" AutoEventWireup="true" CodeFile="BloodTests.aspx.cs" Inherits="HospitalAppointmentSystem.BloodTests" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <meta charset="utf-8" />
    <style>
        .modern-blood-tests {
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
        
        .test-result-card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            transition: all 0.3s ease;
            margin-bottom: 1rem;
            position: relative;
            overflow: hidden;
        }
        
        .test-result-card::before {
            content: '';
            position: absolute;
            left: 0;
            top: 0;
            bottom: 0;
            width: 5px;
            background: linear-gradient(180deg, #17a2b8, #138496);
        }
        
        .test-result-card.normal::before {
            background: linear-gradient(180deg, #28a745, #1e7e34);
        }
        
        .test-result-card.abnormal::before {
            background: linear-gradient(180deg, #dc3545, #c82333);
        }
        
        .test-result-card.pending::before {
            background: linear-gradient(180deg, #ffc107, #e0a800);
        }
        
        .test-result-card:hover {
            transform: translateX(5px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.12);
        }
        
        .result-value {
            font-weight: bold;
            font-size: 1.2em;
            padding: 0.5rem 1rem;
            border-radius: 8px;
            display: inline-block;
        }
        
        .normal-value {
            background: linear-gradient(135deg, #d4edda, #c3e6cb);
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        
        .abnormal-value {
            background: linear-gradient(135deg, #f8d7da, #f5c6cb);
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        
        .pending-value {
            background: linear-gradient(135deg, #fff3cd, #ffeaa7);
            color: #856404;
            border: 1px solid #ffeaa7;
        }
        
        .filters-card {
            border: none;
            border-radius: 20px;
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
            background: white;
        }
        
        .filters-card .card-header {
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
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="modern-blood-tests">
        <!-- Page Header -->
        <div class="page-header">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <h1 class="mb-3 fw-bold">
                        <i class="fas fa-flask me-3"></i>
                        <span class="blood-tests-title">Blood Tests</span>
                    </h1>
                    <p class="mb-0 fs-5">
                        <span class="blood-tests-subtitle">View your blood test results and medical reports</span>
                    </p>
                </div>
                <div class="col-md-4 text-end">
                    <i class="fas fa-vial fa-4x opacity-75"></i>
                </div>
            </div>
        </div>

    <!-- Filters -->
    <div class="card mb-4">
        <div class="card-body">
            <div class="row">
                <div class="col-md-3">
                    <label for="<%= ddlTestType.ClientID %>" class="form-label">
                        <span class="test-type-label">Test Type:</span>
                    </label>
                    <asp:DropDownList ID="ddlTestType" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="ddlTestType_SelectedIndexChanged">
                        <asp:ListItem Text="All" Value="" />
                        <asp:ListItem Text="Complete Blood Count" Value="CBC" />
                        <asp:ListItem Text="Cholesterol" Value="Cholesterol" />
                        <asp:ListItem Text="Glucose" Value="Glucose" />
                        <asp:ListItem Text="Liver Function" Value="Liver" />
                        <asp:ListItem Text="Kidney Function" Value="Kidney" />
                    </asp:DropDownList>
                </div>
                <div class="col-md-3">
                    <label for="<%= ddlStatus.ClientID %>" class="form-label">
                        <span class="status-label">Status:</span>
                    </label>
                    <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="ddlStatus_SelectedIndexChanged">
                        <asp:ListItem Text="All" Value="" />
                        <asp:ListItem Text="Normal" Value="Normal" />
                        <asp:ListItem Text="Abnormal" Value="Abnormal" />
                        <asp:ListItem Text="Pending" Value="Pending" />
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

    <!-- Test Results -->
    <asp:Panel ID="pnlNoTests" runat="server" Visible="false" CssClass="col-12">
        <div class="text-center py-5">
            <i class="fas fa-flask fa-3x text-muted mb-3"></i>
            <h5 class="text-muted">
                <span class="no-tests-text">No blood test results found yet.</span>
            </h5>
            <p class="text-muted">
                <span class="no-tests-subtitle">Your blood test results will be displayed here.</span>
            </p>
        </div>
    </asp:Panel>
    
    <div class="row">
        <asp:Repeater ID="rptBloodTests" runat="server">
            <ItemTemplate>
                <div class="col-md-6 col-lg-4 mb-4">
                    <div class="card test-result-card <%# GetResultClass(Eval("Status").ToString()) %>">
                        <div class="card-header">
                            <div class="d-flex justify-content-between align-items-center">
                                <h6 class="mb-0">
                                    <i class="fas fa-vial me-2"></i>
                                    <%# Eval("TestName") %>
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
                                        <span class="test-date-label">Test Date:</span>
                                    </small>
                                </div>
                                <div class="col-6 text-end">
                                    <small><%# Convert.ToDateTime(Eval("TestDate")).ToString("dd/MM/yyyy") %></small>
                                </div>
                            </div>
                            
                            <div class="row mb-2">
                                <div class="col-6">
                                    <small class="text-muted">
                                        <span class="result-label">Result:</span>
                                    </small>
                                </div>
                                <div class="col-6 text-end">
                                    <span class="result-value <%# GetValueClass(Eval("Status").ToString()) %>">
                                        <%# Eval("Result") %>
                                    </span>
                                </div>
                            </div>
                            
                            <div class="row mb-2">
                                <div class="col-6">
                                    <small class="text-muted">
                                        <span class="unit-label">Unit:</span>
                                    </small>
                                </div>
                                <div class="col-6 text-end">
                                    <small><%# Eval("Unit") %></small>
                                </div>
                            </div>
                            
                            <div class="row mb-2">
                                <div class="col-6">
                                    <small class="text-muted">
                                        <span class="reference-label">Reference:</span>
                                    </small>
                                </div>
                                <div class="col-6 text-end">
                                    <small><%# Eval("ReferenceRange") %></small>
                                </div>
                            </div>
                            
                            <div class="row">
                                <div class="col-6">
                                    <small class="text-muted">
                                        <span class="hospital-label">Hospital:</span>
                                    </small>
                                </div>
                                <div class="col-6 text-end">
                                    <small><%# Eval("HospitalName") %></small>
                                </div>
                            </div>
                        </div>
                        <div class="card-footer">
                            <div class="d-flex justify-content-between">
                                <small class="text-muted">
                                    <span class="doctor-label">Doctor:</span> <%# Eval("DoctorName") %>
                                </small>
                                <asp:Button ID="btnViewDetails" runat="server" Text="Details" CssClass="btn btn-sm btn-outline-primary" 
                                           CommandName="ViewDetails" CommandArgument='<%# Eval("Id") %>' OnCommand="btnViewDetails_Command" />
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
            <nav aria-label="Test results pagination">
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
        // Add translations for blood tests page
        var bloodTestsTranslations = {
            tr: {
                bloodTestsTitle: "Blood Tests",
                bloodTestsSubtitle: "View your blood test results",
                refreshText: "Refresh",
                testTypeLabel: "Test Type:",
                statusLabel: "Status:",
                dateFromLabel: "Start Date:",
                dateToLabel: "End Date:",
                filterText: "Filter",
                clearText: "Clear",
                testDateLabel: "Test Date:",
                resultLabel: "Result:",
                unitLabel: "Unit:",
                referenceLabel: "Reference:",
                hospitalLabel: "Hospital:",
                doctorLabel: "Doctor:",
                detailsText: "Details",
                noTestsText: "No blood test results found yet.",
                noTestsSubtitle: "Your blood test results will be displayed here.",
                previousText: "Previous",
                nextText: "Next"
            },
            ar: {
                bloodTestsTitle: "فحوصات الدم",
                bloodTestsSubtitle: "عرض نتائج فحوصات الدم",
                refreshText: "تحديث",
                testTypeLabel: "نوع الفحص:",
                statusLabel: "الحالة:",
                dateFromLabel: "تاريخ البداية:",
                dateToLabel: "تاريخ النهاية:",
                filterText: "تصفية",
                clearText: "مسح",
                testDateLabel: "تاريخ الفحص:",
                resultLabel: "النتيجة:",
                unitLabel: "الوحدة:",
                referenceLabel: "المرجع:",
                hospitalLabel: "المستشفى:",
                doctorLabel: "الطبيب:",
                detailsText: "التفاصيل",
                noTestsText: "لا توجد نتائج فحوصات دم بعد.",
                noTestsSubtitle: "ستظهر نتائج فحوصات الدم هنا.",
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
            
            // Update blood tests page specific elements
            var bloodTestsElements = document.querySelectorAll('[class*="-text"], [class*="-label"], [class*="-title"], [class*="-subtitle"]');
            for (var i = 0; i < bloodTestsElements.length; i++) {
                var element = bloodTestsElements[i];
                var key = element.className.split('-')[0];
                if (bloodTestsTranslations[lang] && bloodTestsTranslations[lang][key]) {
                    element.textContent = bloodTestsTranslations[lang][key];
                }
            }
        };
    </script>
</asp:Content>
