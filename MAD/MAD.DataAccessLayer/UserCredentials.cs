using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using MAD.DataAccessLayer.Extentions;

namespace MAD.DataAccessLayer
{
    public class UserCredentials
    {

        public UserCredentials(string password, string passwordSalt)
        {
            if (String.IsNullOrEmpty(password))
            {
                throw new ArgumentException("Password can not be blank.", "password");
            }
            this.password = password;

            if (String.IsNullOrEmpty(passwordSalt))
            {
                throw new ArgumentException("Password salt can not be blank.", "passwordSalt");
            }
            this.passwordSalt = passwordSalt;
        }

        public UserCredentials(IDataRecord record)
            : this(
            record.Get<String>("Password"),
            record.Get<String>("PasswordSalt")
            )
        { }

        private string password;
        public string Password
        {
            get { return password; }
        }

        private string passwordSalt;
        public string PasswordSalt
        {
            get { return passwordSalt; }
        }
    }
}
