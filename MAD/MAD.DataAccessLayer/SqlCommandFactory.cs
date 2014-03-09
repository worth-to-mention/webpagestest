using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MAD.DataAccessLayer
{
    public class SqlCommandFactory
    {
        private SqlCommand cmd;
        
        public SqlCommandFactory()
        {
            cmd = new SqlCommand();
        }
        public SqlCommandFactory(SqlConnection connection) : this()
        {
            AddConnection(connection);
        }



        public SqlCommand GetCommand()
        {
            return cmd;
        }

        #region Command options

        public SqlCommandFactory AddConnection(SqlConnection connection)
        {
            if (connection == null)
            {
                throw new ArgumentNullException("connection");
            }
            cmd.Connection = connection;
            return this;
        }

        public SqlCommandFactory AsStoredProcedure()
        {
            return SetCommandType(CommandType.StoredProcedure);
        }

        public SqlCommandFactory AsStoredProcedure(string procedureName)
        {
            if (String.IsNullOrEmpty(procedureName))
            {
                throw new ArgumentException("Procedure name can not be blank.", "procedureName");
            }
            return AsStoredProcedure().SetCommandText(procedureName);
        }

        public SqlCommandFactory AsText()
        {
            return SetCommandType(CommandType.Text);
        }

        public SqlCommandFactory AsText(string commandText)
        {
            if (String.IsNullOrEmpty(commandText))
            {
                throw new ArgumentException("Command text can not be blank.", "commandText");
            }
            return AsText().SetCommandText(commandText);
        }

        public SqlCommandFactory SetCommandType(CommandType cmdType)
        {
            cmd.CommandType = cmdType;
            return this;
        }


        public SqlCommandFactory SetCommandText(string cmdText)
        {
            cmd.CommandText = cmdText;
            return this;
        }

        #endregion

        #region Perameters

        public T GetParameter<T>(string paramName)
        {
            return (T)cmd.Parameters[paramName].Value;
        }

        public SqlParameterFactory WithParams()
        {
            return new SqlParameterFactory(this);
        }

        public SqlCommandFactory ParamsClear()
        {
            cmd.Parameters.Clear();
            return this;
        }

        #endregion

        #region Execute

        public SqlDataReader ExecuteReader()
        {
            return cmd.ExecuteReader();
        }
        
        public T ExecuteScalar<T>()
        {
            return (T)cmd.ExecuteScalar();
        }

        public SqlCommandFactory ExecuteNonQuery()
        {
            cmd.ExecuteNonQuery();
            return this;
        }

        #endregion

    }
}
