<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="CreateUsersView.ascx.cs" Inherits="MAD.Views.AdministrativeViews.CreateUsersView" %>
<%@ Import Namespace="System.Web.Routing" %>
<div id="CreateUserBlock" runat="server">
    <div>
        <asp:Label ID="ErrorLabel" runat="server" />
        <asp:ValidationSummary ValidationGroup="CreateUserValidationGroup" runat="server"/>
    </div>
    <div class="propertyBox">
        <div class="propertyBox-item">
            <div class="propertyBox-item-key">
                <asp:Label runat="server" 
                    AssociatedControlID="UserNameTextBox">
                    User name:
                </asp:Label>
            </div>
            <div class="propertyBox-item-value">
                <asp:TextBox ID="UserNameTextBox" runat="server" />
                <asp:RequiredFieldValidator 
                    ControlToValidate="UserNameTextBox"
                    ValidationGroup="CreateUserValidationGroup"
                    runat="server"
                    ErrorMessage="You must specify user name."
                    Display="Dynamic" />
            </div>
        </div>
        <div class="propertyBox-item">
            <div class="propertyBox-item-key">
                <asp:Label 
                    AssociatedControlID="PasswordTextBox" 
                    runat="server">
                    Password:
                </asp:Label>
            </div>
            <div class="propertyBox-item-value">
                <asp:TextBox ID="PasswordTextBox"
                    TextMode="Password"
                    runat="server" />
                <asp:RequiredFieldValidator 
                    ControlToValidate="PasswordTextBox"
                    ValidationGroup="CreateUserValidationGroup"
                    ErrorMessage="You must specify password"
                    runat="server" 
                    Display="Dynamic"/>
            </div>
        </div>
        <div class="propertyBox-item">
            <div class="propertyBox-item-key">
                <asp:Label
                    AssociatedControlID="RepeatPasswordTextBox"
                    runat="server">
                    Repeat password:
                </asp:Label>
            </div>
            <div class="propertyBox-item-value">
                <asp:TextBox ID="RepeatPasswordTextBox"
                    TextMode="Password"
                    runat="server" />
                <asp:CompareValidator
                    ControlToValidate="PasswordTextBox"
                    ControlToCompare="RepeatPasswordTextBox"
                    ValidationGroup="CreateUserValidationGroup"
                    ErrorMessage="Passwords does not match."
                    runat="server" 
                    Display="Dynamic"/>
            </div>
        </div>
        <div class="propertyBox-item">
            <div class="propertyBox-item-key">
                <asp:Button ID="CreateUserButton"
                    OnClick="CreateUserButton_Click"
                    CausesValidation="true"
                    ValidationGroup="CreateUserValidationGroup"
                    Text="Create user"
                    runat="server" 
                    />
            </div>
            <div class="propertyBox-item-value">
          
            </div>
        </div>
    </div>
</div>

