using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MAD.DataAccessLayer.Extentions
{
    public static class SqlDataReaderExtentions
    {
        public static IEnumerable<IDataRecord> AsEnumerable(this SqlDataReader reader)
        {
            try
            {
                foreach (IDataRecord record in reader)
                {
                    yield return record;
                }
            }
            finally
            {
                if (reader != null)
                    reader.Close();
            }
            
        }
    }
}
