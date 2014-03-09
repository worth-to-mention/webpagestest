<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ShowAuctionView.ascx.cs" Inherits="MAD.Views.AuctionViews.ShowAuctionView" %>
<div class="propertyBox">
    <div class="propertyBox-item">
        <div class="propertyBox-item-key">
            Auction title:
        </div>
        <div class="propertyBox-item-value">
            <asp:Label ID="AuctionTitleLabel" runat="server" />
            <asp:PlaceHolder ID="EditAuctionPlaceholder" runat="server">                
                <asp:HyperLink ID="EditAuctionLink" runat="server">
                    [manage]
                </asp:HyperLink>                
            </asp:PlaceHolder>
        </div>
    </div>
    <div class="propertyBox-item">
        <div class="propertyBox-item-key">
            Auctioneer:
        </div>
        <div class="propertyBox-item-value">
            <asp:Label ID="AuctioneerLabel" runat="server" />
        </div>
    </div>
    <div class="propertyBox-item">
        <div class="propertyBox-item-key">
            Auction status:
        </div>
        <div class="propertyBox-item-value">
            <asp:Label ID="AuctionStatusLabel" runat="server" />
        </div>
    </div>
    <div class="propertyBox-item">
        <div class="propertyBox-item-key">
            <asp:HyperLink ID="AuctioneerLink"
                runat="server" />
        </div>
        <div class="propertyBox-item-value">
            <asp:HyperLink NavigateUrl="<%$Routeurl:routename=AuctionsRoute%>" runat="server">
                all auctions
            </asp:HyperLink>
        </div>
    </div>


</div>
<asp:Repeater ID="LotsRepeater" runat="server">
    <ItemTemplate>
        <div class="lot">
            <div class="lot-title">
                <%# DataBinder.Eval(Container.DataItem, "Title") %>
            </div>
            <div class="lot-description">
                <%# DataBinder.Eval(Container.DataItem, "Description") %>
            </div>
            <div class="lot-startingPrice">
                <%# DataBinder.Eval(Container.DataItem, "StartingPrice") %>
            </div>
            <div class="lot-details">
                <a 
                    href="<%#GetRouteUrl("ShowLotRoute", new { lot_id = Eval("LotID").ToString()})%>"
                    >
                    Details
                </a>
            </div>
            <asp:PlaceHolder ID="IsSoldPlaceholder" Visible='<%# (bool)Eval("IsSold") %>' runat="server">
                <div class="lot-status-sold">
                    Sold
                </div>
            </asp:PlaceHolder>
        </div>
    </ItemTemplate>
</asp:Repeater>