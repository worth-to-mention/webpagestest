<%@ Page Title="" Language="C#" MasterPageFile="~/Layout/Default/DefaultLayout.master" AutoEventWireup="true" CodeBehind="CreateAuctionPage.aspx.cs" Inherits="MAD.Pages.Auctions.CreateAuctionPage" %>
<%@ Register TagName="CreateAuctionView" TagPrefix="MAD" Src="~/Views/AuctionViews/CreateAuctionView.ascx" %>
<asp:Content ID="Content1" ContentPlaceHolderID="CenterColumn" runat="server">
    <MAD:CreateAuctionView runat="server" />
</asp:Content>
