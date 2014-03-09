using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using MAD.DataAccessLayer.Extentions;

namespace MAD.DataAccessLayer
{
    public class RoleComparer : IEqualityComparer<Role>
    {

        #region IEqualityComparer<Role> Members

        public bool Equals(Role x, Role y)
        {
            return x.Equals(y);
        }

        public int GetHashCode(Role obj)
        {
            return obj == null ? 0 :
                obj.GetHashCode();
        }

        #endregion
    }
    public class Role : IEquatable<Role>
    {
        public Role(Guid roleID, string roleName)
        {
            if (roleID == null)
            {
                throw new ArgumentNullException("roleID", "Argument roleID can not be null.");
            }
            this.roleID = roleID;

            if (String.IsNullOrEmpty(roleName))
            {
                throw new ArgumentException("Argument roleName can not be blank.", "roleName");
            }
            this.roleName = roleName;
        }

        public Role(IDataRecord record)
            : this(
            record.Get<Guid>("RoleID"),
            record.Get<String>("RoleName")
            )
        { }

        private readonly Guid roleID;
        public Guid RoleID
        {
            get
            {
                return roleID;
            }
        }

        private readonly string roleName;
        public string RoleName
        {
            get
            {
                return roleName;
            }
        }

        #region IEquatable<Role> Members

        public bool Equals(Role other)
        {
            if (Object.ReferenceEquals(other, null))
                return false;
            return this.RoleName.Equals(other.RoleName);
        }

        #endregion

        public static bool operator == (Role first, Role second)
        {
            if ((object)first == null) return Object.Equals(first, second);
            return first.Equals(second);
        }
        public static bool operator != (Role first, Role second)
        {
            return !(first == second);
        }

        public override bool Equals(object obj)
        {
            return Equals(obj as Role);
        }

        public override string ToString()
        {
            return RoleName;
        }

        public override int GetHashCode()
        {
            return BitConverter.ToInt32(RoleID.ToByteArray(), 0);
        }
    }
}
