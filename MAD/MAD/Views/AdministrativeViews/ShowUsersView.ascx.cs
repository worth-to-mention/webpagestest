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
    public partial class ShowUsersView : System.Web.UI.UserControl
    {
        private List<User> users;

        protected override void OnInit(EventArgs e)
        {
            users = MADUsers.GetAllUsers();
            UsersRepeater.DataSource = users;
            UsersRepeater.DataBind();
        }

        protected void UsersRepeater_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "LockUser")
            {
                User user = users[e.Item.ItemIndex];
                MADUsers.SetUserLockStatus(user.UserID, !user.IsLocked);
                users = MADUsers.GetAllUsers();
                UsersRepeater.DataSource = users;
                UsersRepeater.DataBind();
            }
        }
    }
}