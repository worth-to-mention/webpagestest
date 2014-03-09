<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="CreateAuctionView.ascx.cs" Inherits="MAD.Views.AuctionViews.CreateAuctionView" %>
<div class="propertyBox">
    <div class="propertyBox-Title">
        <asp:Label ID="CreateAuctionTitleLabel" runat="server" >
            Create new auction
        </asp:Label>
    </div>
    <div class="propertyBox-item">
        <div class="propertyBox-item-key">
            <asp:Label ID="AuctionTitleLabel" runat="server">
                Enter auction title:
            </asp:Label>
        </div>
        <div class="propertyBox-item-value">
            <asp:TextBox ID="AuctionTitleTextBox" runat="server" />
            <asp:RegularExpressionValidator
                ControlToValidate="AuctionTitleTextBox"
                ValidationGroup="CreateAuctionGroup"
                ValidationExpression="\w[\w|\d|\s]{2,249}"
                ErrorMessage="Auction title must starts with a letter and be in range [3-250]"
                runat="server" />
        </div>
    </div>
    <div class="propertyBox-item">
        <div class="propertyBox-item-key">
            <asp:Button ID="CreateAuctionButton" runat="server"  
                Text="Create auction"
                CausesValidation="true"
                ValidationGroup="CreateAuctionGroup"
                OnClick="CreateAuctionButton_Click"/>
        </div>
        <div class="propertyBox-item-value">

        </div>
    </div>
</div>