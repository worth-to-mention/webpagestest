using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using MAD.DataAccessLayer;

namespace MAD
{
    public class RoleCreatedEventArgs : EventArgs
    {
        public RoleCreatedEventArgs(Role role)
        {
            if (role == null)
            {
                throw new ArgumentNullException("role");
            }
            this.role = role;
        }

        private readonly Role role;
        public Role Role
        {
            get { return role; }
        }
    }
}