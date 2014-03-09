using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Routing;

using MAD.Security;
using MAD.DataAccessLayer;
using MAD.Extentions;

namespace MAD.Views.AdministrativeViews
{
    public partial class AddRolesToUserView : System.Web.UI.UserControl, INamingContainer
    {
        private List<Role> allRoles;
        private List<Role> userRoles;
        private User user;

        protected override void OnInit(EventArgs e)
        {
            string userName = Page.RouteData.Values["user_name"].ToString();
            if (String.IsNullOrEmpty(userName))
            {
                userName = Page.Request.QueryString["user_name"];
                if (String.IsNullOrEmpty(userName))
                {
                    Response.StatusCode = 404;
                    Response.End();
                }
            }

            user = MADUsers.GetUser(userName);
            if (user == null)
            {
                Response.StatusCode = 404;
                Response.End();
            }
            allRoles = MADRoles.GetAllRoles();
            userRoles = MADRoles.GetRolesForUser(userName);

            UserRolesCheckBoxList.AutoPostBack = true;
            UserRolesCheckBoxList.SelectedIndexChanged += UserRolesCheckBoxList_SelectedIndexChanged;
            UserRolesCheckBoxList.DataSource = allRoles;
            UserRolesCheckBoxList.DataTextField = "RoleName";
            UserRolesCheckBoxList.DataBind();

            foreach (ListItem item in UserRolesCheckBoxList.Items)
            {
                item.Selected = userRoles.Contains(
                    allRoles.Where(role => role.RoleName == item.Text)
                    .FirstOrDefault()
                    );
            }            
        }

        private void UserRolesCheckBoxList_SelectedIndexChanged(object sender, EventArgs e)
        {
            var checkBoxList = sender as CheckBoxList;
            if (checkBoxList == null)
                return;
            var items = checkBoxList.Items.AsEnumerable();
            var roleItems =
                from item in items
                from role in allRoles
                where item.Text == role.RoleName
                select new
                {
                    role,
                    item
                };

            var selectedRoles = roleItems.Where(roleItem => roleItem.item.Selected).Select(roleItem => roleItem.role).ToList();
            var unselectedRoles = roleItems.Where(roleItem => !roleItem.item.Selected).Select(roleItem => roleItem.role).ToList();

            var rolesToAdd = selectedRoles.Except(userRoles).ToList();
            var rolesToDelete = userRoles.Intersect(unselectedRoles).ToList();

            // Add selected roles to the user.
            rolesToAdd.ForEach(role => MADRoles.AddRoleToUser(user, role));
            // Remove unselected rles from the user.
            rolesToDelete.ForEach(role => MADRoles.RemoveRoleFromUser(user, role));
            
        }
    }
}