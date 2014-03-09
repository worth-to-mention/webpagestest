<%@ Page Title="" Language="C#" MasterPageFile="~/Layout/Administrative/AdministrativeLayout.master" AutoEventWireup="true" CodeBehind="AssignRolesToUserPage.aspx.cs" Inherits="MAD.Pages.Administrative.AssignRolesToUserPage" %>
<%@ Register TagName="AddRolesToUserView" TagPrefix="MAD" Src="~/Views/AdministrativeViews/AddRolesToUserView.ascx" %>
<asp:Content ID="Content1" ContentPlaceHolderID="CenterColumn" runat="server">
    <MAD:AddRolesToUserView runat="server" />
</asp:Content>
