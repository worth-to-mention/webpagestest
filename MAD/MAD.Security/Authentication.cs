using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using System.Web.Security;

namespace MAD.Security
{
    public static class Authentication
    {
        public static FormsAuthenticationTicket CreateAuthTicket(string userName, bool isPersistent, TimeSpan timeout) 
        {
            string userData = GetRolesForUser(userName);
            return CreateAuthTicket(
                2,
                userName,
                DateTime.Now,
                DateTime.Now + timeout,
                isPersistent,
                userData);
        }

        public static FormsAuthenticationTicket CreateAuthTicket(
            int version,
            string userName,
            DateTime issueDate,
            DateTime expirationDate,
            bool isPersistent,
            string userData
            ) 
        {
            string cookiePath = FormsAuthentication.FormsCookiePath;
            return CreateAuthTicket(
                version,
                userName,
                issueDate,
                expirationDate,
                isPersistent,
                userData,
                cookiePath
                );
        }

        public static FormsAuthenticationTicket CreateAuthTicket(
            int version,
            string userName,
            DateTime issueDate,
            DateTime expirationDate,
            bool isPersistent,
            string userData,
            string cookiePath
            ) 
        {
            if (String.IsNullOrEmpty(userName))
            {
                throw new ArgumentException("Argument userName can not be blank.", "userName");
            }
            if (userData == null)
            {
                throw new ArgumentNullException("userData", "Missing object reference.");
            }
            if (cookiePath == null)
            {
                throw new ArgumentNullException("cookiePath", "Missing object reference.");
            }
            return new FormsAuthenticationTicket(
                version,
                userName,
                issueDate,
                expirationDate,
                isPersistent,
                userData,
                cookiePath
                );
 
        }

        private static string GetRolesForUser(string userName)
        {
            return String.Join(",", MADRoles.GetRolesForUser(userName));
        }
 
    }
}
