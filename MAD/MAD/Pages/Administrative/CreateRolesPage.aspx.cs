using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MAD.Pages.Administrative
{
    public partial class CreateRolesPage : System.Web.UI.Page
    {
        protected void Unnamed_RoleCreated(object sender, RoleCreatedEventArgs e)
        {
            Response.Redirect(GetRouteUrl("CreateRolesRoute", null));
        }


    }
}