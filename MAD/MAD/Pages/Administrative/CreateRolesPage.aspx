<%@ Page Title="" Language="C#" MasterPageFile="~/Layout/Administrative/AdministrativeLayout.master" AutoEventWireup="true" CodeBehind="CreateRolesPage.aspx.cs" Inherits="MAD.Pages.Administrative.CreateRolesPage" %>
<%@ Register TagPrefix="MAD"  TagName="CreateRolesView" Src="~/Views/AdministrativeViews/CreateRolesView.ascx" %>
<%@ Register TagPrefix="MAD"  TagName="ShowRolesView" Src="~/Views/AdministrativeViews/ShowRolesView.ascx" %>
<asp:Content ID="Content1" ContentPlaceHolderID="CenterColumn" runat="server">
    <div class="leftColumn">
        <MAD:CreateRolesView runat="server" OnRoleCreated="Unnamed_RoleCreated"/>
    </div>
    <div class="rightColumn">
        <MAD:ShowRolesView runat="server" />
    </div>
</asp:Content>
