using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using MAD.DataAccessLayer.Extentions;

namespace MAD.DataAccessLayer.DataProviders
{
    public class RoleDataProvider : DataProvider
    {
        public RoleDataProvider(string connectionString)
            : base(connectionString)
        { }

        /// <summary>
        /// Create new role with specified name.
        /// </summary>
        /// <param name="roleName">Name of the role to create.</param>
        /// <returns>ID of the created role.</returns>
        public Role CreateRole(string roleName)
        {
            Role role = null;
            var connection = new SqlConnection(connectionString);
            try
            {
                connection.Open();
                var factory = new SqlCommandFactory(connection)
                    .AsStoredProcedure("[dbo].[SP_Roles_CreateRole]")
                    .WithParams()
                        .AddNVarChar("@roleName", roleName)
                        .AddGuidOut("@roleID")
                    .ParamsEnd()
                    .ExecuteNonQuery();
                role = new Role(
                    factory.GetParameter<Guid>("@roleID"),
                    roleName
                    );
            }
            catch(Exception)
            {
                // todo log exception.
#if DEBUG
                throw;
#endif
            }
            finally
            {
                if (connection != null)
                    connection.Close();
            }
            return role;
        }

        public void DeleteRole(Guid roleID)
        {
            if (roleID == null)
            {
                throw new ArgumentNullException("roleID");
            }
            var connection = new SqlConnection(connectionString);
            try
            {
                connection.Open();

                var factory = new SqlCommandFactory(connection)
                    .AsStoredProcedure("[dbo].[SP_Roles_DeleteRole]")
                    .WithParams()
                        .AddGuid("@roleID", roleID)
                    .ParamsEnd();

                factory.ExecuteNonQuery();
            }
            catch (Exception)
            {
                // todo log exception
#if DEBUG
                throw;
#endif
            }
            finally
            {
                if (connection != null)
                    connection.Close();
            }
        }

        public Role GetRole(Guid roleID)
        {
            Role role = null;
            var connection = new SqlConnection(connectionString);
            try 
	        {	        
		        connection.Open();
                role = new SqlCommandFactory(connection)
                    .AsStoredProcedure("[dbo].[SP_Roles_GetRole]")
                    .WithParams()
                        .AddGuid("@roleID", roleID)
                    .ParamsEnd()
                    .ExecuteReader()
                    .AsEnumerable().Select(record => new Role(record))
                    .FirstOrDefault();
	        }
	        catch (Exception)
	        {
                // todo log exception
#if DEBUG		
		        throw;
#endif
	        }
            finally
            {
                if (connection != null)
                    connection.Close();
            }
            return role;
        }

        public Role GetRoleByName(string roleName)
        {
            Role role = null;
            var connection = new SqlConnection(connectionString);
            try 
	        {	        
		        connection.Open();
                role = new SqlCommandFactory(connection)
                    .AsStoredProcedure("[dbo].[SP_Roles_GetRoleByName]")
                    .WithParams()
                        .AddNVarChar("@roleName", roleName)
                    .ParamsEnd()
                    .ExecuteReader()
                    .AsEnumerable().Select(record => new Role(record))
                    .FirstOrDefault();
	        }
	        catch (Exception)
	        {
#if DEBUG
		        throw;
#endif
	        }
            finally
            {
                if (connection != null)
                    connection.Close();
            }
            return role;
        }

        /// <summary>
        /// Returns existing roles in the database.
        /// </summary>
        /// <returns>List of existing roles.</returns>
        public List<Role> GetAllRoles()
        {
            List<Role> roles = null;
            var connection = new SqlConnection(connectionString);
            try
            {
                connection.Open();
                roles = new SqlCommandFactory(connection)
                    .AsStoredProcedure("[dbo].[SP_Roles_GetAllRoles]")
                    .ExecuteReader()
                    .AsEnumerable().Select(record => new Role(record))
                    .ToList();
            }
            catch(Exception)
            {
                // todo log exception
#if DEBUG
                throw;
#endif
            }
            finally
            {
                if (connection != null)
                    connection.Close();
            }
            return roles ?? new List<Role>();
        }

        /// <summary>
        /// Checks whether exist users with specified role.
        /// </summary>
        /// <param name="roleID">Role id.</param>
        /// <returns>True if exists one or more users with specified role.</returns>
        public bool ExistUsersWithRole(Guid roleID)
        {
            if (roleID == null)
            {
                throw new ArgumentNullException("roleID");
            }
            bool exist = true;
            var connection = new SqlConnection(connectionString);
            try
            {
                connection.Open();
                exist = new SqlCommandFactory(connection)
                    .AsStoredProcedure("[dbo].[SP_UsersRoles_ExistUsersWithRole]")
                    .WithParams()
                        .AddGuid("@roleID", roleID)
                        .AddBitOut("@usersExist")
                    .ParamsEnd()
                    .ExecuteNonQuery()
                    .GetParameter<bool>("@usersExist");
            }
            catch(Exception)
            {
                // todo log exception.
#if DEBUG
                throw;
#endif
            }
            finally
            {
                if (connection != null)
                    connection.Close();
            }
            return exist;
        }

        public List<Role> GetUserRoles(Guid userID)
        {
            List<Role> roles = null;
            var connection = new SqlConnection(connectionString);
            try
            {
                connection.Open();
                roles = new SqlCommandFactory(connection)
                    .AsStoredProcedure("[dbo].[SP_UsersRoles_GetUserRoles]")
                    .WithParams()
                        .AddGuid("@userID", userID)
                    .ParamsEnd()
                    .ExecuteReader()
                    .AsEnumerable().Select(record => new Role(record))
                    .ToList();
            }
            catch (Exception)
            {
                // todo log exception
#if DEBUG
                throw;
#endif
            }
            finally
            {
                if (connection != null)
                    connection.Close();
            }
            return roles ?? new List<Role>();
        }

        public List<User> GetUsersWithRole(Guid roleID)
        {
            List<User> users = null;
            var connection = new SqlConnection(connectionString);
            try
            {
                connection.Open();
                users = new SqlCommandFactory(connection)
                    .AsStoredProcedure("[dbo].[SP_UsersRoles_GetUsersWithRole]")
                    .WithParams()
                        .AddGuid("@roleID", roleID)
                    .ParamsEnd()
                    .ExecuteReader()
                    .AsEnumerable().Select(record => new User(record))
                    .ToList();

            }
            catch (Exception)
            {
                // todo log exception
#if DEBUG
                throw;
#endif
            }
            finally
            {

            }
            return users ?? new List<User>();
        }

        public void AssignRoleToUser(Guid userID, Guid roleID)
        {
            var connection = new SqlConnection(connectionString);
            try
            {
                connection.Open();
                var factory = new SqlCommandFactory(connection)
                    .AsStoredProcedure("[dbo].[SP_UsersRoles_AssignRoleToUser]")
                    .WithParams()
                        .AddGuid("@roleID", roleID)
                        .AddGuid("@userID", userID)
                    .ParamsEnd();
                factory.ExecuteNonQuery();
            }
            catch (Exception)
            {
                // todo log exception
#if DEBUG
                throw;
#endif
            }
            finally
            {
                if (connection != null)
                    connection.Close();
            }
        }

        public void RemoveRoleFromUser(Guid userID, Guid roleID)
        {
            var connection = new SqlConnection(connectionString);
            try
            {
                connection.Open();
                var factory = new SqlCommandFactory(connection)
                    .AsStoredProcedure("[dbo].[SP_UsersRoles_RemoveRoleFromUser]")
                    .WithParams()
                        .AddGuid("@userID", userID)
                        .AddGuid("@roleID", roleID)
                    .ParamsEnd()
                    .ExecuteNonQuery();
            }
            catch (Exception)
            {
#if DEBUG
                throw;
#endif
            }
            finally
            {
                if (connection != null)
                    connection.Close();
            }
        }

        public void RemoveAllRolesFromUser(Guid userID)
        {
            var connection = new SqlConnection(connectionString);
            try
            {
                connection.Open();
                var factory = new SqlCommandFactory(connection)
                    .AsStoredProcedure("[dbo].[SP_UsersRoles_RemoveAllRolesFromUser]")
                    .WithParams()
                        .AddGuid("@userID", userID)
                    .ParamsEnd()
                    .ExecuteNonQuery();
            }
            catch (Exception)
            {
#if DEBUG
                throw;
#endif
            }
            finally
            {
                if (connection != null)
                    connection.Close();
            }
        }

        public bool UserHasRole(Guid userID, Guid roleID)
        {
            bool userHasRole = false;

            var connection = new SqlConnection(connectionString);
            try
            {
                connection.Open();
                userHasRole = new SqlCommandFactory(connection)
                    .AsStoredProcedure("[dbo].[SP_UsersRoles_UserHasRole]")
                    .WithParams()
                        .AddGuid("@userID", userID)
                        .AddGuid("@roleID", roleID)
                        .AddBitOut("@result")
                    .ParamsEnd()
                    .ExecuteNonQuery()
                    .GetParameter<Boolean>("@result");
            }
            catch (Exception)
            {
                // todo log exception
#if DEBUG
                throw;
#endif
            }
            finally
            {
                if (connection != null)
                    connection.Close();
            }
            return userHasRole;
        }
    }
}
