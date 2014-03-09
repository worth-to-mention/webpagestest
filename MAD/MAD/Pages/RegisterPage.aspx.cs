using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MAD.DataAccessLayer;
using MAD.Security;

namespace MAD.Pages
{
    public partial class RegisterPage : System.Web.UI.Page
    {
        protected override void OnInit(EventArgs e)
        {
            base.OnInit(e);
            string role = RouteData.Values["role"].ToString();

            if (role == "choose")
            {
                ChooseRolePlaceHolder.Visible = true;
                RegisterPlaceholder.Visible = false;
            }
            else
            {
                ChooseRolePlaceHolder.Visible = false;
                RegisterPlaceholder.Visible = true;
            }
        }

        protected void Unnamed_UserCreated(object sender, UserCreatedEventArgs e)
        {
            string defaultUrl = GetRouteUrl("DefaultRoute", null);
            string param = RouteData.Values["role"].ToString();
            Role role = MADRoles.GetRole(param);
            if (role != null)
            {
                MADRoles.AddRoleToUser(e.User, role);
                HttpCookie authCookie = MADUsers.CreateAuthCookie(e.User.UserName, true);
                Response.SetCookie(authCookie);
                Response.Redirect(defaultUrl, true);
            }
            else
            {
                Response.Redirect(GetRouteUrl("RegisterRoute", null), true);
            }
        }
    }
}