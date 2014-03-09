using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MAD.DataAccessLayer
{
    public class SqlParameterFactory
    {
        private SqlCommand cmd;
        private SqlCommandFactory cmdFactory;
  
        public SqlParameterFactory(SqlCommandFactory cmdFactory)
        {
            this.cmdFactory = cmdFactory;
            cmd = cmdFactory.GetCommand();
        }

        public SqlCommandFactory ParamsEnd()
        {
            cmd = null;
            return cmdFactory;
        }

        public SqlParameterFactory Add(string name, SqlDbType type, object val, ParameterDirection direction = ParameterDirection.Input)
        {
            if (String.IsNullOrEmpty(name))
            {
                throw new ArgumentException("Parameter name can not be blank.", "name");
            }

            cmd.Parameters.Add(CreateParameter(
                name,
                type,
                val,
                direction
                ));
            return this;
        }

        private SqlParameter CreateParameter(string name, SqlDbType type, object value, ParameterDirection direction = ParameterDirection.Input)
        {
            var param = new SqlParameter();
            param.ParameterName = name;
            param.SqlDbType = type;
            param.Direction = direction;
            param.Value = value;
            return param;
        }

        #region BIT

        public SqlParameterFactory AddBit(string name, Boolean val)
        {
            return Add(name, SqlDbType.Bit, val);
        }
        public SqlParameterFactory AddBitOut(string name)
        {
            return Add(name, SqlDbType.Bit, null, ParameterDirection.Output);
        }

        #endregion

        #region DATETIME

        public SqlParameterFactory AddDateTime(string name, DateTime val)
        {
            return Add(name, SqlDbType.DateTime, val);
        }
        public SqlParameterFactory AddDateTimeOut(string name)
        {
            return Add(name, SqlDbType.DateTime, null, ParameterDirection.Output);
        }

        #endregion

        #region SMALDATETIME

        public SqlParameterFactory AddSmallDateTime(string name, DateTime val)
        {
            return Add(name, SqlDbType.SmallDateTime, val);
        }
        public SqlParameterFactory AddSmallDateTimeOut(string name)
        {
            return Add(name, SqlDbType.SmallDateTime, null, ParameterDirection.Output);
        }

        #endregion

        #region DATE

        public SqlParameterFactory AddDate(string name, DateTime val)
        {
            return Add(name, SqlDbType.Date, val);
        }
        public SqlParameterFactory AddDateOut(string name)
        {
            return Add(name, SqlDbType.Date, null, ParameterDirection.Output);
        }

        #endregion

        #region TIME

        public SqlParameterFactory AddTime(string name, DateTime val)
        {
            return Add(name, SqlDbType.Time, val);
        }
        public SqlParameterFactory AddTimeOut(string name)
        {
            return Add(name, SqlDbType.Time, null, ParameterDirection.Output);
        }

        #endregion

        #region DATETIME2

        public SqlParameterFactory AddDateTime2(string name, DateTime val)
        {
            return Add(name, SqlDbType.DateTime2, val);
        }
        public SqlParameterFactory AddDateTime2Out(string name)
        {
            return Add(name, SqlDbType.DateTime2, null, ParameterDirection.Output);
        }

        #endregion

        #region SMALLINT

        public SqlParameterFactory AddSmallInt(string name, Int16 val)
        {
            return Add(name, SqlDbType.SmallInt, val);
        }
        public SqlParameterFactory AddSmallIntOut(string name)
        {
            return Add(name, SqlDbType.SmallInt, null, ParameterDirection.Output);
        }

        #endregion

        #region INT

        public SqlParameterFactory AddInt(string name, Int32 val)
        {
            return Add(name, SqlDbType.Int, val);
        }
        public SqlParameterFactory AddIntOut(string name)
        {
            return Add(name, SqlDbType.Int, null, ParameterDirection.Output);
        }

        #endregion

        #region BIGINT

        public SqlParameterFactory AddBigInt(string name, Int64 val)
        {
            return Add(name, SqlDbType.BigInt, val);
        }
        public SqlParameterFactory AddBigIntOut(string name)
        {
            return Add(name, SqlDbType.BigInt, null, ParameterDirection.Output);
        }

        #endregion

        #region NVARCHAR

        public SqlParameterFactory AddNVarChar(string name, String val)
        {
            return Add(name, SqlDbType.NVarChar, val);
        }
        public SqlParameterFactory AddNVarCharOut(string name)
        {
            return Add(name, SqlDbType.NVarChar, null, ParameterDirection.Output);
        }

        #endregion

        #region VARCHAR

        public SqlParameterFactory AddVarChar(string name, String val)
        {
            return Add(name, SqlDbType.VarChar, val);
        }
        public SqlParameterFactory AddVarCharOut(string name)
        {
            return Add(name, SqlDbType.VarChar, null, ParameterDirection.Output);
        }

        #endregion

        #region CHAR

        public SqlParameterFactory AddChar(string name, String val)
        {
            return Add(name, SqlDbType.Char, val);
        }
        public SqlParameterFactory AddCharOut(string name)
        {
            return Add(name, SqlDbType.Char, null, ParameterDirection.Output);
        }

        #region NTEXT

        public SqlParameterFactory AddNText(string name, string val)
        {
            return Add(name, SqlDbType.NText, val);
        }
        public SqlParameterFactory AddNTextOut(string name)
        {
            return Add(name, SqlDbType.NText, null, ParameterDirection.Output);
        }

        #endregion

        #region TEXT

        public SqlParameterFactory AddText(string name, string val)
        {
            return Add(name, SqlDbType.Text, val);
        }
        public SqlParameterFactory AddTextOut(string name)
        {
            return Add(name, SqlDbType.Text, null, ParameterDirection.Output);
        }

        #endregion



        #endregion

        #region XML

        public SqlParameterFactory AddXml(string name, String val)
        {
            return Add(name, SqlDbType.Xml, val);
        }
        public SqlParameterFactory AddXmlOut(string name)
        {
            return Add(name, SqlDbType.Xml, null, ParameterDirection.Output);
        }

        #endregion

        #region UNIQUEIDENTIFIER

        public SqlParameterFactory AddGuid(string name, Guid val)
        {
            return Add(name, SqlDbType.UniqueIdentifier, val);
        }
        public SqlParameterFactory AddGuidOut(string name)
        {
            return Add(name, SqlDbType.UniqueIdentifier, null, ParameterDirection.Output);
        }

        #endregion

        #region DECIMAL

        public SqlParameterFactory AddDecimal(string name, Decimal val)
        {
            return Add(name, SqlDbType.Decimal, val);
        }
        public SqlParameterFactory AddDecimalOut(string name)
        {
            return Add(name, SqlDbType.Decimal, null, ParameterDirection.Output);
        }

        #endregion

        #region MONEY

        public SqlParameterFactory AddMoney(string name, Decimal val)
        {
            return Add(name, SqlDbType.Money, val);
        }
        public SqlParameterFactory AddMoneyOut(string name)
        {
            return Add(name, SqlDbType.Money, null, ParameterDirection.Output);
        }

        #endregion

        #region SMALLMONEY

        public SqlParameterFactory AddSmallMoney(string name, Decimal val)
        {
            return Add(name, SqlDbType.SmallMoney, val);
        }
        public SqlParameterFactory AddSmallMoneyOut(string name)
        {
            return Add(name, SqlDbType.SmallMoney, null, ParameterDirection.Output);
        }

        #endregion

        #region FLOAT

        public SqlParameterFactory AddFloat(string name, Double val)
        {
            return Add(name, SqlDbType.Float, val);
        }
        public SqlParameterFactory AddFloatOut(string name)
        {
            return Add(name, SqlDbType.Float, null, ParameterDirection.Output);
        }

        #endregion

        #region REAL

        public SqlParameterFactory AddReal(string name, Single val)
        {
            return Add(name, SqlDbType.Real, val);
        }
        public SqlParameterFactory AddRealOut(string name)
        {
            return Add(name, SqlDbType.Real, null, ParameterDirection.Output);
        }

        #endregion

        #region BINARY

        public SqlParameterFactory AddBinary(string name, byte[] val)
        {
            return Add(name, SqlDbType.Binary, val);
        }
        public SqlParameterFactory AddBinaryOut(string name)
        {
            return Add(name, SqlDbType.Binary, null, ParameterDirection.Output);
        }

        #endregion

        #region Image

        public SqlParameterFactory AddImage(string name, byte[] val)
        {
            return Add(name, SqlDbType.Image, val);
        }
        public SqlParameterFactory AddImageOut(string name)
        {
            return Add(name, SqlDbType.Image, null, ParameterDirection.Output);
        }

        #endregion

        #region TIMESTAMP

        public SqlParameterFactory AddTimestamp(string name, byte[] val)
        {
            return Add(name, SqlDbType.Timestamp, val);
        }
        public SqlParameterFactory AddTimestampOut(string name)
        {
            return Add(name, SqlDbType.Timestamp, null, ParameterDirection.Output);
        }

        #endregion

        #region VARBINARY

        public SqlParameterFactory AddVarBinary(string name, byte[] val)
        {
            return Add(name, SqlDbType.VarBinary, val);
        }
        public SqlParameterFactory AddVarBinaryOut(string name)
        {
            return Add(name, SqlDbType.VarBinary, null, ParameterDirection.Output);
        }

        #endregion

        #region VARIANT

        public SqlParameterFactory AddVariant(string name, Object val)
        {
            return Add(name, SqlDbType.Variant, val);
        }
        public SqlParameterFactory AddVariantOut(string name)
        {
            return Add(name, SqlDbType.Variant, null, ParameterDirection.Output);
        }

        #endregion

        #region UDT

        public SqlParameterFactory AddUdt(string name, Object val)
        {
            return Add(name, SqlDbType.Udt, val);
        }
        public SqlParameterFactory AddUdtOut(string name)
        {
            return Add(name, SqlDbType.Udt, null, ParameterDirection.Output);
        }

        #endregion





    }
}
