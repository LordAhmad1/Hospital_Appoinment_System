<%@ Page Title="Language Settings" Language="C#" MasterPageFile="/Site.Master" AutoEventWireup="true" CodeFile="LanguageSwitcher.aspx.cs" Inherits="HospitalAppointmentSystem.LanguageSwitcher" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <meta charset="utf-8" />
    <style>
        .language-card {
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            cursor: pointer;
        }
        
        .language-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.15);
        }
        
        .language-card.selected {
            border: 2px solid #007bff;
            background-color: #f8f9fa;
        }
        
        .flag-icon {
            width: 60px;
            height: 40px;
            object-fit: cover;
            border-radius: 5px;
            margin-bottom: 1rem;
        }
        
        .language-name {
            font-size: 1.2rem;
            font-weight: 600;
            margin-bottom: 0.5rem;
        }
        
        .language-native {
            font-size: 1rem;
            color: #6c757d;
            margin-bottom: 0.5rem;
        }
        
        .language-description {
            font-size: 0.9rem;
            color: #6c757d;
            line-height: 1.4;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-4">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card">
                    <div class="card-header bg-primary text-white">
                        <h4 class="mb-0">
                            <i class="fas fa-globe me-2"></i>
                            <span data-translate="languageSettings">Language Settings</span>
                        </h4>
                    </div>
                    <div class="card-body">
                        <p class="text-muted mb-4">
                            <span data-translate="selectLanguage">Select your preferred language for the application interface.</span>
                        </p>
                        
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <div class="card language-card" id="turkishCard" onclick="selectLanguage('tr')">
                                    <div class="card-body text-center">
                                        <img src="data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNjAiIGhlaWdodD0iNDAiIHZpZXdCb3g9IjAgMCA2MCA0MCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPHJlY3Qgd2lkdGg9IjYwIiBoZWlnaHQ9IjQwIiBmaWxsPSIjRTAyNzE5Ii8+CjxyZWN0IHdpZHRoPSI2MCIgaGVpZ2h0PSIyMCIgeT0iMjAiIGZpbGw9IiNGRkZGRkYiLz4KPGNpcmNsZSBjeD0iMzAiIGN5PSIyMCIgcj0iOCIgZmlsbD0iI0YwQjAwMCIvPgo8Y2lyY2xlIGN4PSIzNiIgY3k9IjE0IiByPSI0IiBmaWxsPSIjRjBCMDAwIi8+Cjwvc3ZnPgo=" alt="Turkish Flag" class="flag-icon" />
                                        <div class="language-name">Türkçe</div>
                                        <div class="language-native">Turkish</div>
                                        <div class="language-description">
                                            <span data-translate="turkishDescription">Official language of Turkey. Left-to-right text direction.</span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="col-md-6 mb-3">
                                <div class="card language-card" id="arabicCard" onclick="selectLanguage('ar')">
                                    <div class="card-body text-center">
                                        <img src="data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNjAiIGhlaWdodD0iNDAiIHZpZXdCb3g9IjAgMCA2MCA0MCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPHJlY3Qgd2lkdGg9IjYwIiBoZWlnaHQ9IjQwIiBmaWxsPSIjMDA5NzM5Ii8+CjxyZWN0IHdpZHRoPSI2MCIgaGVpZ2h0PSIyMCIgeT0iMTAiIGZpbGw9IiNGRkZGRkYiLz4KPHJlY3Qgd2lkdGg9IjYwIiBoZWlnaHQ9IjIwIiB5PSIzMCIgZmlsbD0iI0YwQjAwMCIvPgo8cGF0aCBkPSJNIDAgMjAgTCA2MCAyMCIgc3Ryb2tlPSIjMDA5NzM5IiBzdHJva2Utd2lkdGg9IjIiLz4KPC9zdmc+Cg==" alt="Arabic Flag" class="flag-icon" />
                                        <div class="language-name">العربية</div>
                                        <div class="language-native">Arabic</div>
                                        <div class="language-description">
                                            <span data-translate="arabicDescription">Semitic language. Right-to-left text direction.</span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="text-center mt-4">
                            <asp:Button ID="btnSaveLanguage" runat="server" Text="Save Language Preference" 
                                       CssClass="btn btn-primary btn-lg" OnClick="btnSaveLanguage_Click" />
                        </div>
                        
                        <div class="alert alert-info mt-3" role="alert">
                            <i class="fas fa-info-circle me-2"></i>
                            <span data-translate="languageNote">Your language preference will be saved and applied to all pages. You can change it anytime from this page.</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Function to select language
        function selectLanguage(lang) {
            // Remove selected class from all cards
            document.querySelectorAll('.language-card').forEach(card => {
                card.classList.remove('selected');
            });
            
            // Add selected class to clicked card
            if (lang === 'tr') {
                document.getElementById('turkishCard').classList.add('selected');
            } else if (lang === 'ar') {
                document.getElementById('arabicCard').classList.add('selected');
            }
            
            // Store selected language
            document.getElementById('<%= hdnSelectedLanguage.ClientID %>').value = lang;
        }
        
        // Initialize selected language on page load
        document.addEventListener('DOMContentLoaded', function() {
            const currentLang = localStorage.getItem('preferredLanguage') || 'tr';
            selectLanguage(currentLang);
        });
    </script>
</asp:Content>
