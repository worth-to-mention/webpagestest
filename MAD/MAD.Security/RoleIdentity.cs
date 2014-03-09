using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Principal;
using System.Text;
using System.Threading.Tasks;
using System.Web.Security;

namespace MAD.Security
{
    public class RoleIdentity : IIdentity  
    {

        private FormsAuthenticationTicket ticket;

        public RoleIdentity(FormsAuthenticationTicket ticket)
        {
            if (ticket == null)
            {
                throw new ArgumentNullException("ticket", "Missing object reference.");
            }
            this.ticket = ticket;
        }

        public FormsAuthenticationTicket Ticket
        {
            get
            {
                return ticket;
            }
        }

        public string[] Roles
        {
            get
            {
                return ticket.UserData.Split(new[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
            }
        }

        #region IIdentity Members

        public string AuthenticationType
        {
            get { return "Custom"; }
        }

        public bool IsAuthenticated
        {
            get { return true; }
        }

        public string Name
        {
            get { return ticket.Name; }
        }
        #endregion
    }
}
