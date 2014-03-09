using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using MAD.Security;
using MAD.DataAccessLayer;

namespace MAD.Views.AdministrativeViews
{
    public partial class CreateRolesView : System.Web.UI.UserControl
    {
        #region Events

        public event EventHandler<RoleCreatedEventArgs> RoleCreated;
        protected virtual void OnRoleCreated(RoleCreatedEventArgs e)
        {
            var handler = RoleCreated;
            if (handler != null)
            {
                handler(this, e);
            }
        }

        #endregion
        protected void AddRoleButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                string roleName = RoleNameTextBox.Text.Trim();
                if (!MADRoles.RoleExists(roleName))
                {
                    Role role = MADRoles.CreateRole(roleName);

                    OnRoleCreated(new RoleCreatedEventArgs(role));
                }
                else
                {
                    ErrorLabel.Text = "Role with the same name already exists.";
                }
            }
        }
    }
}