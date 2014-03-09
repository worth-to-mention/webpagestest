<%@ Page Title="" Language="C#" MasterPageFile="~/Layout/Administrative/AdministrativeLayout.master" AutoEventWireup="true" CodeBehind="CreateUsersPage.aspx.cs" Inherits="MAD.Pages.Administrative.CreateUsersPage" %>
<%@ Register TagPrefix="MAD" TagName="CreateUsersView" Src="~/Views/AdministrativeViews/CreateUsersView.ascx"%>
<%@ Register TagPrefix="MAD" TagName="ShowUsersView" Src="~/Views/AdministrativeViews/ShowUsersView.ascx"%>

<asp:Content ID="Content1" ContentPlaceHolderID="CenterColumn" runat="server">
    <div class="leftColumn">
        <MAD:CreateUsersView runat="server" OnUserCreated="Unnamed_UserCreated"/>
    </div>
    <div class="rightColumn">
        <MAD:ShowUsersView runat="server" />
    </div>    
</asp:Content>
