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
    public partial class CreateUsersView : System.Web.UI.UserControl
    {

        #region Events

        public event EventHandler<UserCreatedEventArgs> UserCreated;
        protected virtual void OnUserCreated(UserCreatedEventArgs e)
        {
            var handler = UserCreated;
            if (handler != null)
            {
                UserCreated(this, e);
            }
        }

        #endregion
        protected void CreateUserButton_Click(object sender, EventArgs e)
        {
            Page.Validate("CreateUserValidationGroup");
            if (Page.IsValid)
            {
                string userName = UserNameTextBox.Text.Trim();
                string password = PasswordTextBox.Text.Trim();
                if (MADUsers.GetUser(userName) == null)
                {
                    User user = MADUsers.CreateUser(userName, password);

                    OnUserCreated(new UserCreatedEventArgs(user));
                }
                else
                {
                    ErrorLabel.Text = "User with the same name already exists.";
                }
                
            }

        }
    }
}