using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using MAD.DataAccessLayer.Extentions;

namespace MAD.DataAccessLayer
{
    public class User
    {
        public User(Guid userID, string userName, DateTime registrationDate
            , DateTime lastActivityDate, bool isLocked)
        {
            if (userID == null)
            {
                throw new ArgumentNullException("userID");
            }
            this.userID = userID;
            
            if (String.IsNullOrEmpty(userName))
            {
                throw new ArgumentException("String userName can not be blank.", "userName");
            }
            this.userName = userName;
            this.registrationDate = registrationDate;
            this.lastActivityDate = lastActivityDate;
            this.isLocked = isLocked;
        }

        public User(IDataRecord record)
            : this(
            record.Get<Guid>("UserID"),
            record.Get<String>("UserName"),
            record.Get<DateTime>("RegistrationDate"),
            record.Get<DateTime>("LastActivityDate"),
            record.Get<Boolean>("IsLocked")
            )
        { }

        private readonly Guid userID;
        public Guid UserID
        {
            get { return userID; }
        }

        private readonly string userName;
        public string UserName
        {
            get { return userName; }
        }

        private DateTime registrationDate;
        public DateTime RegistrationDate
        {
            get { return registrationDate; }
        }

        private DateTime lastActivityDate;
        public DateTime LastActivityDate
        {
            get { return lastActivityDate; }
        }        
        
        private readonly bool isLocked;
        public bool IsLocked
        {
            get { return isLocked; }
        }
    }
}
