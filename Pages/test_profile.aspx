<%@ Page Title="Test Profile" Language="C#" MasterPageFile="/Site.Master" AutoEventWireup="true" CodeFile="test_profile.aspx.cs" Inherits="HospitalAppointmentSystem.test_profile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-4">
        <h2>Test Profile Save</h2>
        
        <div class="card">
            <div class="card-body">
                <div class="mb-3">
                    <label>First Name:</label>
                    <asp:TextBox ID="txtTestFirstName" runat="server" CssClass="form-control" Text="Test User"></asp:TextBox>
                </div>
                
                <div class="mb-3">
                    <label>Last Name:</label>
                    <asp:TextBox ID="txtTestLastName" runat="server" CssClass="form-control" Text="Test Last"></asp:TextBox>
                </div>
                
                <asp:Button ID="btnTestSave" runat="server" Text="Test Save" CssClass="btn btn-primary" OnClick="btnTestSave_Click" />
                
                <asp:Label ID="lblTestMessage" runat="server" CssClass="mt-2 d-block"></asp:Label>
            </div>
        </div>
    </div>
</asp:Content>
