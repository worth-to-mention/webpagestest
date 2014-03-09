<%@ Page Title="" Language="C#" MasterPageFile="~/Layout/Default/LoginLayout.master" AutoEventWireup="true" CodeBehind="RegisterPage.aspx.cs" Inherits="MAD.Pages.RegisterPage" %>
<%@ Register TagPrefix="MAD" TagName="CreateUsersView" Src="~/Views/AdministrativeViews/CreateUsersView.ascx" %>
<asp:Content ID="Content1" ContentPlaceHolderID="CenterColumn" runat="server">
    <asp:PlaceHolder ID="ChooseRolePlaceHolder" runat="server" Visible="true">
        <div class="chooseRoleMenu">
            <asp:HyperLink CssClass="auctioneerRole" NavigateUrl="<%$RouteUrl:routename=RegisterRoute, role=auctioneers%>"
                runat="server" >
                Auctioneer
            </asp:HyperLink>
            <asp:HyperLink CssClass="bidderRole" NavigateUrl="<%$RouteUrl:routename=RegisterRoute, role=bidders%>"
                runat="server">
                Bidder
            </asp:HyperLink>
        </div>
    </asp:PlaceHolder>
    <asp:PlaceHolder ID="RegisterPlaceholder" runat="server" Visible="false">        
        <MAD:CreateUsersView runat="server" OnUserCreated="Unnamed_UserCreated" />
    </asp:PlaceHolder>
</asp:Content>
