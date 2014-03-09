<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ShowRolesView.ascx.cs" Inherits="MAD.Views.AdministrativeViews.ShowRolesView" %>
<div>
    <asp:Label ID="ErrorLabel" runat="server" />
</div>
<asp:Repeater runat="server" OnItemCommand="RoleRepeater_ItemCommand" ID="RoleRepeater">
    <HeaderTemplate>
        <table>
            <tr>
                <th>
                    Role name
                </th>
            </tr>
    </HeaderTemplate>
    <ItemTemplate>
        <tr>
            <td>
                <%# Eval("RoleName") %>
            </td>
            <td>
                <asp:LinkButton 
                    CommandName="Delete" 
                    CausesValidation="false"
                    runat="server">
                    Delete role
                </asp:LinkButton>
            </td>
        </tr>
    </ItemTemplate>
    <FooterTemplate>
        </table>
    </FooterTemplate>
</asp:Repeater>