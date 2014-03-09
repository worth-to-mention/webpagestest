using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MAD.Pages.Administrative
{
    public partial class AdministrativePage : System.Web.UI.Page
    {
        protected override void OnInit(EventArgs e)
        {
            base.OnInit(e);
            string action = (string)RouteData.Values["action"];
            if (!String.IsNullOrEmpty(action))
                action = action.ToLower();
            switch (action)
            {
                case "addrolestouser":
                    AddRolesToUserAction();
                    break;
                case "createusers":
                    CreateUsersAction();
                    break;
                case "createroles":
                    CreateRolesAction();
                    break;
                default:
                    DefaultAction();
                    break;
            }
        }

        private void CreateRolesAction()
        {
            var view = Page.LoadControl("~/Views/AdministrativeViews/CreateRolesView.ascx");
            AdministrativePageViewPlaceholder.Controls.Add(view);
        }

        private void CreateUsersAction()
        {
            var view = Page.LoadControl("~/Views/AdministrativeViews/CreateUsersView.ascx");
            AdministrativePageViewPlaceholder.Controls.Add(view);
        }

        private void DefaultAction()
        {
            var view = Page.LoadControl("~/Views/AdministrativeViews/DefaultView.ascx");
            AdministrativePageViewPlaceholder.Controls.Add(view);
        }

        private void AddRolesToUserAction()
        {
            var view = Page.LoadControl("~/Views/AdministrativeViews/AddRolesToUserView.ascx");
            AdministrativePageViewPlaceholder.Controls.Add(view);
        }
    }
}