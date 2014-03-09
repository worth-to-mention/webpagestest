using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Principal;
using System.Text;
using System.Threading.Tasks;

namespace MAD.Security
{
    public class RolePrincipal : IPrincipal
    {
        private RoleIdentity identity;

        public RolePrincipal(RoleIdentity identity)
        {
            if (identity == null)
            {
                throw new ArgumentNullException("identity", "Missing object reference.");
            }
            this.identity = identity;
        }

        #region IPrincipal Members

        public IIdentity Identity
        {
            get { return identity; }
        }

        public bool IsInRole(string role)
        {
            return identity.Roles.Contains(role, StringComparer.OrdinalIgnoreCase);
        }

        #endregion
    }
}
