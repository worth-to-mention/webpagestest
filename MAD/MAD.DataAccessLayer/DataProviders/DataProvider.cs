using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MAD.DataAccessLayer.DataProviders
{
    public abstract class DataProvider
    {
        protected readonly string connectionString;
        public DataProvider(string connectionString)
        {
            if (String.IsNullOrEmpty(connectionString))
            {
                throw new ArgumentException("connectionString can not be blank.", "connectionString");
            }
            this.connectionString = connectionString; 
        }
    }
}
