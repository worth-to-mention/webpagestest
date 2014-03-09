<%@ Page Title="" Language="C#" MasterPageFile="~/Layout/Default/DefaultLayout.master" AutoEventWireup="true" CodeBehind="ShowLotPage.aspx.cs" Inherits="MAD.Pages.Lots.ShowLotPage" %>
<asp:Content ID="Content1" ContentPlaceHolderID="CenterColumn" runat="server">
    <div class="propertyBox" style="float: left;">
        <div class="propertyBox-item">
            <div class="propertyBox-item-key">
                Auction:
            </div>
            <div class="propertyBox-item-value">
                <asp:HyperLink ID="AuctionLink" runat="server" />
            </div>
        </div>
        <div class="propertyBox-item">
            <div class="propertyBox-item-key">
                Lot title:
            </div>
            <div class="propertyBox-item-value">
                <asp:Label ID="LotTitleLabel" runat="server" />
            </div>
        </div>
        <div class="propertyBox-item">
            <div class="propertyBox-item-key">
                Lot description:
            </div>
            <div class="propertyBox-item-value">
                <asp:Label ID="LotDescriptionLabel" runat="server" />
            </div>
        </div>
        <div class="propertyBox-item">
            <div class="propertyBox-item-key">
                Lot starting price:
            </div>
            <div class="propertyBox-item-value">
                <asp:Label ID="LotStartingPriceLabel" runat="server" />
            </div>
        </div>
        <div class="propertyBox-item">
            <div class="propertyBox-item-key">
                Lot current price
            </div>
            <div class="propertyBox-item-value">
                <asp:Label ID="LotCurrentPriceLabel" runat="server" />
            </div>
        </div>
        <div class="propertyBox-item">
            <div class="propertyBox-item-key">
                Lot status:
            </div>
            <div class="propertyBox-item-value">
                <asp:Label ID="LotStatusLabel" runat="server" />
            </div>
        </div>
        <asp:PlaceHolder ID="BidPlaceholder" runat="server" >
            <div class="propertyBox-item">
                <div class="propertyBox-item-key">
                    Bid price:
                </div>
                <div class="propertyBox-item-value">
                    <asp:TextBox ID="BidPriceTextBox" runat="server" />
                    <asp:RegularExpressionValidator
                        ControlToValidate="BidPriceTextBox"
                        ValidationGroup="LeaveBidValidationGroup"
                        ValidationExpression="\d+(.\d+)?"
                        runat="server" 
                        ErrorMessage="Invalid price"/>
                </div>
            </div>
            <div class="propertyBox-item">
                <div class="propertyBox-item-key">

                </div>
                <div class="propertyBox-item-value">
                    <asp:Button ID="LeaveBidButton"
                        CausesValidation="true"
                        ValidationGroup="LeaveBidValidationGroup"
                        OnClick="LeaveBidButton_Click"
                        Text="Leave a bid" 
                        runat="server"/>
                </div>
            </div>
        </asp:PlaceHolder>

        <div class="propertyBox-item">
            <div class="propertyBox-item-key">

            </div>
            <div class="propertyBox-item-value">

            </div>
        </div>
    </div>
    <div style="float: right;">
        <asp:Repeater ID="BidsRepeater" runat="server">
            <HeaderTemplate>
                <table>
                    <tr>
                        <th>User</th>
                        <th>Bid price</th>
                        <th>Date</th>
                    </tr>
            </HeaderTemplate>
            <ItemTemplate>
                <tr>
                    <td>
                        <%#Eval("UserID") %>
                    </td>
                    <td>
                        <%#Eval("Price") %>
                    </td>
                    <td>
                        <%#Eval("BidDate") %>
                    </td>
                </tr>
            </ItemTemplate>
            <FooterTemplate>
                </table>
            </FooterTemplate>
        </asp:Repeater>
    </div>
</asp:Content>
