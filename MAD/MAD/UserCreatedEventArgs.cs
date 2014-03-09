using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using MAD.DataAccessLayer;

namespace MAD
{
    public class UserCreatedEventArgs : EventArgs
    {
        public UserCreatedEventArgs(User user)
        {
            if (user == null)
            {
                throw new ArgumentNullException("user");
            }
            this.user = user;
        }

        private readonly User user;
        public User User
        {
            get { return user; }
        }
    }
}