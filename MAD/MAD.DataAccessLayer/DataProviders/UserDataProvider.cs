using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using MAD.DataAccessLayer.Extentions;

namespace MAD.DataAccessLayer.DataProviders
{
    public class UserDataProvider : DataProvider
    {
        public UserDataProvider(string connectionString)
            : base(connectionString)
        { }

        public User CreateUser(string userName, DateTime registrationDate
            , DateTime lastActivityDate, bool isLocked, string password
            , string passwordSalt)
        {
            if (String.IsNullOrEmpty(userName))
            {
                throw new ArgumentException("userName can not be blank.", "userName");
            }
            if (userName.Length > 50)
            {
                throw new ArgumentException("userName can not be greater than 50 charachters.", "userName");
            }
            if (String.IsNullOrEmpty(password))
            {
                throw new ArgumentException("password can not be blank.", "password");
            }
            if (password.Length > 128)
            {
                throw new ArgumentException("password can not be greater than 128 characters.");
            }
            if (String.IsNullOrEmpty(passwordSalt))
            {
                throw new ArgumentException("passwordSalt can not be blank.", "passwordSalt");
            }
            if (passwordSalt.Length > 128)
            {
                throw new ArgumentException("passwordSalt can not be greater than 128 characters.");
            }
            User user = null;
            var connection = new SqlConnection(connectionString);
            try
            {
                connection.Open();
                var factory = new SqlCommandFactory(connection)
                    .AsStoredProcedure("[dbo].[SP_Users_CreateUser]")
                    .WithParams()
                        .AddNVarChar("@userName", userName)
                        .AddDateTime("@registrationDate", registrationDate)
                        .AddDateTime("@lastActivityDate", lastActivityDate)
                        .AddBit("@isLocked", isLocked)
                        .AddNVarChar("@password", password)
                        .AddNVarChar("@passwordSalt", passwordSalt)
                        .AddGuidOut("@userID")
                    .ParamsEnd()
                    .ExecuteNonQuery();
                user = new User(
                    factory.GetParameter<Guid>("@userID"),
                    userName,
                    registrationDate,
                    lastActivityDate,
                    isLocked
                    );

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
            return user;
        }

        public List<User> GetAllUsers()
        {
            List<User> users = null;
            var connection = new SqlConnection(connectionString);
            try
            {
                connection.Open();
                users = new SqlCommandFactory(connection)
                    .AsStoredProcedure("[dbo].[SP_Users_GetAllUsers]")
                    .ExecuteReader()
                    .AsEnumerable()
                    .Select(record => new User(record))
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
            return users ?? new List<User>();
        }

        public User GetUserByUserName(string userName)
        {
            if (String.IsNullOrEmpty(userName))
            {
                throw new ArgumentException("User name can not be blank.", "userName");
            }

            User user = null;

            var connection = new SqlConnection(connectionString);
            try
            {
                connection.Open();
                user = new SqlCommandFactory(connection)
                    .AsStoredProcedure("[dbo].[SP_Users_GetUserByUserName]")
                    .WithParams()
                        .AddNVarChar("@userName", userName)
                    .ParamsEnd()
                    .ExecuteReader()
                    .AsEnumerable()
                    .Select(record => new User(record))
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
            return user;
        }

        public User GetUser(Guid userID)
        {
            User user = null;
            var connection = new SqlConnection(connectionString);
            try
            {
                connection.Open();
                user = new SqlCommandFactory(connection)
                    .AsStoredProcedure("[dbo].[SP_Users_GetUser]")
                    .WithParams()
                        .AddGuid("@userID", userID)
                    .ParamsEnd()
                    .ExecuteReader()
                    .AsEnumerable()
                    .Select(record => new User(record))
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
            return user;
        }

        public UserCredentials GetUserCredentials(Guid userID)
        {
            UserCredentials credentials = null;

            var connection = new SqlConnection(connectionString);
            try
            {
                connection.Open();
                credentials = new SqlCommandFactory(connection)
                    .AsStoredProcedure("[dbo].[SP_Credentials_GetUserCredentials]")
                    .WithParams()
                        .AddGuid("@userID", userID)
                    .ParamsEnd()
                    .ExecuteReader()
                    .AsEnumerable()
                    .Select(record => new UserCredentials(record))
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
            return credentials;
        }

        public void SetUserLock(Guid userID, bool userLockStatus)
        {
            var connection = new SqlConnection(connectionString);
            try
            {
                connection.Open();
                var factory = new SqlCommandFactory(connection)
                    .AsStoredProcedure("[dbo].[SP_Users_LockUser]")
                    .WithParams()
                        .AddGuid("@userID", userID)
                        .AddBit("@lockUser", userLockStatus)
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
    }
}
