<%@ Page Title="Logout" Language="C#" MasterPageFile="/Site.Master" AutoEventWireup="true" CodeFile="Logout.aspx.cs" Inherits="HospitalAppointmentSystem.Logout" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <meta charset="utf-8" />
    <style>
        body {
            font-family: Arial, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .logout-container {
            text-align: center;
            padding: 2rem;
        }
        .spinner {
            border: 4px solid rgba(255, 255, 255, 0.3);
            border-radius: 50%;
            border-top: 4px solid white;
            width: 40px;
            height: 40px;
            animation: spin 1s linear infinite;
            margin: 0 auto 1rem;
        }
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        
        /* Hide sidebar on logout page */
        .sidebar {
            display: none !important;
        }
        
        .main-content {
            margin-left: 0 !important;
            width: 100% !important;
        }
        
        .top-navbar {
            display: none !important;
        }
        
        .footer {
            display: none !important;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="logout-container">
        <div class="spinner"></div>
        <h2>Logging out...</h2>
        <p>Please wait...</p>
    </div>
</asp:Content>
