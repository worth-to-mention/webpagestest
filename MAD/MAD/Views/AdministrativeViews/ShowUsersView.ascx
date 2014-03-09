<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ShowUsersView.ascx.cs" Inherits="MAD.Views.AdministrativeViews.ShowUsersView" %>
<asp:Repeater ID="UsersRepeater" runat="server" OnItemCommand="UsersRepeater_ItemCommand">
    <HeaderTemplate>
        <table>
            <tr>
                <th>
                    User name
                </th>
                <th>
                    Registration date
                </th>
                <th>
                    Lastactivity date
                </th>
            </tr>
    </HeaderTemplate>
    <ItemTemplate>
        <tr >
            <td><%# Eval("UserName") %></td>
            <td><%# Eval("RegistrationDate") %></td>
            <td><%# Eval("LastActivityDate") %></td>
            <td>
                <asp:LinkButton CommandName="LockUser" runat="server">
                    <%# (bool)Eval("IsLocked") ? "Unlock" : "Lock" %>
                </asp:LinkButton>
            </td>
            <td>
                <a href="<%# GetRouteUrl("UserRolesRoute", new { user_name = Eval("UserName")})%>" >
                    Edit roles
                </a>
            </td>
        </tr>
    </ItemTemplate>
    <FooterTemplate>
        </table>
    </FooterTemplate>
</asp:Repeater>
