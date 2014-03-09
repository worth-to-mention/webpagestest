<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ShowAuctionsView.ascx.cs" Inherits="MAD.Views.AuctionViews.ShowAuctionsView" %>
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