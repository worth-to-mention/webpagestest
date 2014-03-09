<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="CreateRolesView.ascx.cs" Inherits="MAD.Views.AdministrativeViews.CreateRolesView" %>
<div>
    <asp:ValidationSummary ValidationGroup="CreateRoleValidationGroup" runat="server" />
    <asp:Label ID="ErrorLabel" runat="server" />
</div>
<div class="propertyBox">
    <div class="propertyBox-item">
        <div class="propertyBox-item-key">            
            <asp:Label AssociatedControlID="RoleNameTextBox" runat="server">Enter role name:</asp:Label>
        </div>
        <div class="propertyBox-item-value">
            <asp:TextBox ID="RoleNameTextBox" runat="server" />
            <asp:RequiredFieldValidator 
                ControlToValidate="RoleNameTextBox" 
                runat="server"
                ValidationGroup="CreateRoleValidationGroup" 
                ErrorMessage="You must specify a role name."
                ForeColor="Red"/>
        </div>
    </div>
    <div class="propertyBox-item">
        <div class="propertyBox-item-key">            
            <asp:Button 
                ID="AddRoleButton" 
                OnClick="AddRoleButton_Click" 
                Text="CreateRole" 
                CausesValidation="true"
                ValidationGroup="CreateRoleValidationGroup"
                runat="server"/>
        </div>
        <div class="propertyBox-item-value">

        </div>
    </div>
</div>
