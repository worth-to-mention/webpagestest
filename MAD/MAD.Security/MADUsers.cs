using System;
using System.Linq;
using System.Collections.Generic;
using System.Configuration;
using System.Security.Cryptography;
using System.Security.Principal;
using System.Text;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using MAD.DataAccessLayer;
using MAD.DataAccessLayer.DataProviders;

namespace MAD.Security
{
    public static class MADUsers
    {
        private static readonly string connectionString;
        private static readonly UserDataProvider dataProvider;

        static MADUsers()
        {
            ConnectionStringSettings settings = ConfigurationManager.ConnectionStrings["MAD"];
            if (settings == null)
            {
                throw new InvalidOperationException("Can not initialize MADUsers without connection string.");
            }
            connectionString = settings.ConnectionString;

            dataProvider = new UserDataProvider(connectionString);
        }

        public static HttpCookie CreateAuthCookie(string userName, bool rememberUser)
        {
            HttpCookie authCookie = FormsAuthentication.GetAuthCookie(userName, rememberUser);
            FormsAuthenticationTicket ticket = FormsAuthentication.Decrypt(authCookie.Value);
            string userData = String.Join(",", MADRoles.GetRolesForUser(userName).Select(el => el.RoleName));
            var newTicket = new FormsAuthenticationTicket(
                ticket.Version,
                ticket.Name,
                ticket.IssueDate,
                ticket.Expiration,
                ticket.IsPersistent,
                userData,
                ticket.CookiePath
                );
            authCookie.Value = FormsAuthentication.Encrypt(newTicket);
            return authCookie;
        }

        public static bool ValidateUser(string userName, string password)
        {
            User user = GetUser(userName);
            if (user == null)
                return false;
            if (user.IsLocked)
                return false;

            UserCredentials credentials = GetUserCredentials(user.UserID);
            password = HashPassword(password, credentials.PasswordSalt);

            return String.Equals(password, credentials.Password, StringComparison.Ordinal);
        }

        public static User CreateUser(string userName, string password)
        {
            string passwordSalt = GenerateRandomString(128);
            password = HashPassword(password, passwordSalt);
            var registrationDate = DateTime.UtcNow;
            var lastActivityDate = registrationDate;
            var isLocked = false;

            return dataProvider.CreateUser(userName, registrationDate, lastActivityDate
                , isLocked, password, passwordSalt);
        }

        public static List<User> GetAllUsers()
        {
            return dataProvider.GetAllUsers();
        }

        public static User GetUser()
        {
            IPrincipal user = HttpContext.Current.User;
            
            if (!user.Identity.IsAuthenticated)
                return null;

            string userName = user.Identity.Name;

            return GetUser(userName);
        }

        public static User GetUser(string userName)
        {
            return dataProvider.GetUserByUserName(userName);
        }

        public static User GetUser(Guid userID)
        {
            return dataProvider.GetUser(userID);
        }

        public static UserCredentials GetUserCredentials(Guid userID)
        {
            return dataProvider.GetUserCredentials(userID);
        }

        public static void SetUserLockStatus(Guid userID, bool lockStatus)
        {
            dataProvider.SetUserLock(userID, lockStatus);
        }

        public static bool IsAuthenticated()
        {
            IPrincipal user = HttpContext.Current.User;
            if (user == null)
                return false;
            return user.Identity.IsAuthenticated;
        }

        #region Hash generators

        public static string GetMD5HashFromString(string source)
        {
            MD5 md5 = MD5.Create();
            byte[] bytes = md5.ComputeHash(Encoding.Unicode.GetBytes(source));
            var sb = new StringBuilder();
            foreach(byte b in bytes)
            {
                sb.Append(b.ToString("X2"));
            }
            return sb.ToString();
        }

        public static string GenerateRandomString(uint length)
        {
            byte[] bytes = new byte[length / 2];
            var r = new RNGCryptoServiceProvider();
            r.GetBytes(bytes);
            var sb = new StringBuilder();
            foreach(byte b in bytes)
            {
                sb.Append(b.ToString("X2"));
            }
            return sb.ToString();
        }

        public static string HashPassword(string password, string passwordSalt)
        {
            password = GetMD5HashFromString(password);
            password = password + passwordSalt;
            password = GetMD5HashFromString(password);
            return password;
        }
        #endregion
    }
}
