<%@ Page Title="" Language="C#" MasterPageFile="~/Layout/Default/DefaultLayout.master" AutoEventWireup="true" CodeBehind="EditAuctionPage.aspx.cs" Inherits="MAD.Pages.Auctions.EditAuctionPage" %>
<%@ Register TagPrefix="MAD" TagName="EditAuctionView" Src="~/Views/AuctionViews/EditAuctionView.ascx" %>
<asp:Content ID="Content1" ContentPlaceHolderID="CenterColumn" runat="server">
    <MAD:EditAuctionView ID="EditAuctionControl" runat="server" />
</asp:Content>
