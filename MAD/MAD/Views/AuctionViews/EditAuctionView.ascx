<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="EditAuctionView.ascx.cs" Inherits="MAD.Views.AuctionViews.EditAuctionView" %>
<div class="propertiBox">
    <asp:Label ID="AuctionTitle" runat="server" />
    <asp:HyperLink ID="ShowAuctionLink" runat="server">
        [view]
    </asp:HyperLink>
</div>
<div id="AuctionStatusBlock" runat="server">
    <asp:Button ID="StatusButton" runat="server" OnClick="StatusButton_Click" />
</div>
<div class="propertyBox" id="CreateLotBlock" runat="server" visible="false">
    <div class="propertyBox-item">
        <div class="propertyBox-item-key">
            Lot title:
        </div>
        <div class="propertyBox-itemvalue">
            <asp:TextBox ID="LotTitleTextBox" runat="server" />
            <asp:RegularExpressionValidator
                ControlToValidate="LotTitleTextBox"
                ValidationGroup="CreateLotValidationGroup"
                ValidationExpression="\w[\w|\d|\s]{2,249}"
                ErrorMessage="Lot title must be in range [3-250]"
                runat="server" />
        </div>
    </div>
    <div class="propertyBox-item">
        <div class="propertyBox-item-key">
            Lot description:
        </div>
        <div class="propertyBox-item-value">            
            <asp:TextBox ID="LotDescriptionTextBox" runat="server" />
            <asp:RequiredFieldValidator
                ControlToValidate="LotDescriptionTextBox"
                ValidationGroup="CreateLotValidationGroup"
                ErrorMessage="Lot description can not be blank."
                runat="server" />
        </div>
    </div>
    <div class="propertyBox-item">
        <div class="propertyBox-item-key">
            Lot starting price:
        </div>
        <div class="propertyBox-item-value">
            <asp:TextBox ID="StartingPriceTextBox" runat="server" />
            <asp:RegularExpressionValidator 
                ControlToValidate="StartingPriceTextBox"
                ValidationGroup="CreateLotValidationGroup"
                ValidationExpression="\d+"
                ErrorMessage="Lot starting price must be a number."
                runat="server" />
        </div>
    </div>
    <div class="propertyBox-item">
        <div class="propertyBox-item-key">
            <asp:Button ID="CreateLotButton"
                CausesValidation="true"
                ValidationGroup="CreateLotValidationGroup"
                Text="Add new lot"
                OnClick="CreateLotButton_Click"
                runat="server" />
        </div>
        <div class="propertyBox-item-value">

        </div>
    </div>
</div>
<asp:Repeater ID="LotsRepeater" runat="server" OnItemCommand="LotsRepeater_ItemCommand">
    <HeaderTemplate>
        <table>
            <tr>
                <th>
                    Lot title
                </th>
            </tr>
    </HeaderTemplate>
    <ItemTemplate>
        <tr>
            <td>
                <a href="<%# GetRouteUrl("ShowLotRoute", new { lot_id = Eval("LotID")})%>" >
                    <%# DataBinder.Eval(Container.DataItem, "Title") %>
                </a>
            </td>
            <td>
                <% if (!AuctionStarted()) {%>
                <asp:LinkButton CommandName="DeleteLot" runat="server">
                    Delete lot
                </asp:LinkButton>
                <%} %>
            </td>
        </tr>
    </ItemTemplate>
    <FooterTemplate>
        </table>
    </FooterTemplate>
</asp:Repeater>