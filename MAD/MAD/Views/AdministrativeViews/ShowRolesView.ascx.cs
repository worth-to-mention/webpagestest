using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MAD.DataAccessLayer;
using MAD.Security;

namespace MAD.Views.AdministrativeViews
{
    public partial class ShowRolesView : System.Web.UI.UserControl
    {
        private List<Role> roles;
        protected void Page_Load(object sender, EventArgs e)
        {
            roles = MADRoles.GetAllRoles();

            RoleRepeater.DataSource = roles;
            RoleRepeater.DataBind();
        }

        protected void RoleRepeater_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "Delete")
            {
                Role role = roles[e.Item.ItemIndex];
                if (MADRoles.ExistUsersWithRole(role.RoleID))
                {
                    ErrorLabel.Text = "There are exist users with this role. Delete this references< first.";
                }
                else
                {
                    MADRoles.DeleteRole(role.RoleID);
                    roles = MADRoles.GetAllRoles();
                    RoleRepeater.DataSource = roles;
                    RoleRepeater.DataBind();
                }


            }
        }
    }
}