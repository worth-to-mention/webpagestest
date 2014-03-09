<%@ Page Title="" Language="C#" MasterPageFile="~/Layout/Default/DefaultLayout.master" AutoEventWireup="true" CodeBehind="ShowAuctionPage.aspx.cs" Inherits="MAD.Pages.Auctions.ShowAuctionPage" %>
<%@ Register TagPrefix="MAD" TagName="ShowAuctionView" Src="~/Views/AuctionViews/ShowAuctionView.ascx" %>
<asp:Content ID="Content1" ContentPlaceHolderID="CenterColumn" runat="server">
    <MAD:ShowAuctionView ID="ShowAuctionControl" runat="server" />
</asp:Content>
