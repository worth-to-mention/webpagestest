<%@ Page Title="" Language="C#" MasterPageFile="~/Layout/Default/DefaultLayout.master" AutoEventWireup="true" CodeBehind="UserAuctionsPage.aspx.cs" Inherits="MAD.Pages.Auctions.UserAuctionsPage" %>
<asp:Content ID="Content1" ContentPlaceHolderID="CenterColumn" runat="server">
<asp:Repeater ID="AuctionsRepeater" runat="server">
    <ItemTemplate>
        <div class="auction">
            <div class="auction-title">
                <a href="<%# GetRouteUrl("ShowAuctionRoute", new { auction_id = Eval("AuctionID").ToString()})%>">
                    <%# Eval("AuctionTitle") %>
                </a>
            </div>
            <div class="auction-status">
                <asp:PlaceHolder runat="server" Visible='<%# IsAuctionActive(Container.DataItem) %>'>
                    Active since <%# Eval("StartDate") %>
                </asp:PlaceHolder>
                <asp:PlaceHolder runat="server" Visible='<%# Eval("IsClosed") %>'>
                    Closed at <%# Eval("EndDate") %>
                </asp:PlaceHolder>
            </div>
        </div>
    </ItemTemplate>
</asp:Repeater>
</asp:Content>
