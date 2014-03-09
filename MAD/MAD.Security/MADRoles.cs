using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Security.Principal;
using System.Web;
using MAD.DataAccessLayer;
using MAD.DataAccessLayer.DataProviders;

namespace MAD.Security
{
    public static class MADRoles
    {
        private static string connectionString;
        private static RoleDataProvider dataProvider;

        static MADRoles()
        {
            ConnectionStringSettings settings = ConfigurationManager.ConnectionStrings["MAD"];
            if (settings == null)
            {
                throw new InvalidOperationException("Can not initialize MADRoles without connection string.");
            }
            connectionString = settings.ConnectionString;

            dataProvider = new RoleDataProvider(connectionString);
        }

        public static string[] GetRolesFromIdentity()
        {
            IPrincipal user = HttpContext.Current.User;
            if (user == null || !user.Identity.IsAuthenticated)
                return new string[] {};

            RoleIdentity roleIdentity =  user.Identity as RoleIdentity;
            if (roleIdentity == null)
            {
                throw new InvalidOperationException("Can not get roles for current user. RoleIdentity is not set.");
            }
            return roleIdentity.Roles;
        }

        public static List<Role> GetRolesForUser()
        {
            User user = MADUsers.GetUser();
            if (user == null)
                return new List<Role>();
            return GetRolesForUser(user.UserName);
        }

        public static List<Role> GetRolesForUser(string userName)
        {
            User user = MADUsers.GetUser(userName);
            return dataProvider.GetUserRoles(user.UserID);
        }

        public static List<Role> GetAllRoles()
        {
            return dataProvider.GetAllRoles();
        }

        public static void DeleteRole(Guid roleID)
        {
            dataProvider.DeleteRole(roleID);
        }

        public static Role CreateRole(string roleName)
        {
            if (String.IsNullOrEmpty(roleName))
            {
                throw new ArgumentException("Argument roleName can not be blank.", "roleName");
            }
            return dataProvider.CreateRole(roleName);
        }

        public static Role GetRole(Guid roleID)
        {
            return dataProvider.GetRole(roleID);
        }
        public static Role GetRole(string roleName)
        {
            return dataProvider.GetRoleByName(roleName);
        }

        public static bool UserHasRole(Role role)
        {
            List<Role> roles = GetRolesForUser();
            return roles.Contains(role);
        }
        public static bool UserHasRole(User user, Role role)
        {
            List<Role> roles = GetRolesForUser(user.UserName);
            return roles.Contains(role);
        }
        public static bool UserHasRole(string roleName)
        {
            IPrincipal user = HttpContext.Current.User;
            if (user == null)
                return false;
            return user.IsInRole(roleName);
        }
        public static bool UserHasRole(User user, string roleName)
        {
            if (user == null)
            {
                throw new ArgumentNullException("user");
            }
            List<Role> roles = GetRolesForUser(user.UserName);
            return roles.Select(role => role.RoleName).Contains(roleName);
        }

        public static bool ExistUsersWithRole(Guid roleID)
        {
            if (roleID == null)
            {
                throw new ArgumentNullException("roleID");
            }
            return dataProvider.ExistUsersWithRole(roleID);
        }

        public static void AddRoleToUser(User user, Role role)
        {
            dataProvider.AssignRoleToUser(user.UserID, role.RoleID);
        }

        public static void RemoveRoleFromUser(User user, Role role)
        {
            dataProvider.RemoveRoleFromUser(user.UserID, role.RoleID);
        }
        public static bool RoleExists(string roleName)
        {
            Role role = GetRole(roleName);
            return role != null;
        }
    }
}
