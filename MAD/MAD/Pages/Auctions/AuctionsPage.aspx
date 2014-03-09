<%@ Page Title="" Language="C#" MasterPageFile="~/Layout/Default/DefaultLayout.master" AutoEventWireup="true" CodeBehind="AuctionsPage.aspx.cs" Inherits="MAD.Pages.Auctions.AuctionsPage" %>
<%@ Register TagName="ShowAuctionsView" TagPrefix="MAD" Src="~/Views/AuctionViews/ShowAuctionsView.ascx" %>
<asp:Content ID="Content1" ContentPlaceHolderID="CenterColumn" runat="server">
    <MAD:ShowAuctionsView runat="server" />
</asp:Content>
