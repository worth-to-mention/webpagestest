using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MAD.Pages.Administrative
{
    public partial class CreateUsersPage : System.Web.UI.Page
    {
        protected void Unnamed_UserCreated(object sender, UserCreatedEventArgs e)
        {
            Response.Redirect(GetRouteUrl("CreateUsersRoute", null));
        }
    }
}