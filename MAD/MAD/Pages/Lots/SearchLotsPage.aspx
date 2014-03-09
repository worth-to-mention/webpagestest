<%@ Page Title="" Language="C#" MasterPageFile="~/Layout/Default/DefaultLayout.master" AutoEventWireup="true" CodeBehind="SearchLotsPage.aspx.cs" Inherits="MAD.Pages.Lots.SearchLotsPage" %>
<asp:Content ID="Content1" ContentPlaceHolderID="CenterColumn" runat="server">
    <div class="propertyBox">
        <div class="propertyBox-item">
            <div class="propertyBox-item-key">
                Lot title like:
            </div>
            <div class="propertyBox-item-value">
                <asp:TextBox ID="LotTitleLikeTextBox" runat="server" />
                <asp:RegularExpressionValidator
                    ControlToValidate="LotTitleLikeTextBox" runat="server"
                    ValidationGroup="SearchLotValidationGroup"
                    ValidationExpression="\w[\w|\d|\s]{2,249}"
                    ErrorMessage="Invalid search string" />
            </div>
        </div>
        <div class="propertyBox-item">
            <div class="propertyBox-item-value">
                <asp:Button ID="SearchLotsButton"
                    CausesValidation="true"
                    ValidationGroup="SearchLotValidationGroup"
                    Text="Find"
                    OnClick="SearchLotsButton_Click"
                    runat="server" />
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
</asp:Content>
