using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Principal;
using System.Text;
using System.Threading.Tasks;
using System.Threading;
using System.Web;
using System.Web.Security;

namespace MAD.Security
{
    public class MADSecurityHttpModule : IHttpModule
    {
        private void RegisterMADPrincipal()
        {
            IPrincipal user = HttpContext.Current.User; 
            
            if (user != null && user.Identity.IsAuthenticated && user.Identity.AuthenticationType == "Forms")
            {
                var formsIdentity = user.Identity as FormsIdentity;
                if (formsIdentity != null)
                {
                    var newIdentity = new RoleIdentity(formsIdentity.Ticket);
                    var newPrincipal = new RolePrincipal(newIdentity);

                    HttpContext.Current.User = newPrincipal;
                    Thread.CurrentPrincipal = newPrincipal;
                }
                
            }
        }

        #region IHttpModule Members

        public void Dispose()
        {
            
        }

        public void Init(HttpApplication context)
        {
            context.PostAuthenticateRequest += context_PostAuthenticateRequest;
        }

        void context_PostAuthenticateRequest(object sender, EventArgs e)
        {
            RegisterMADPrincipal();           
        }

        #endregion
    }
}
