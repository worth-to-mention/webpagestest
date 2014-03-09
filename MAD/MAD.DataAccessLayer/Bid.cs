using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using MAD.DataAccessLayer.Extentions;

namespace MAD.DataAccessLayer
{
    public class Bid
    {

        public Bid(Guid bidID, Guid userID, Guid lotID
            ,decimal price, DateTime bidDate)
        {
            this.bidID = bidID;
            this.userID = userID;
            this.lotID = lotID;
            this.price = price;
            this.bidDate = bidDate;
        }

        public Bid(IDataRecord record)
            : this(
            record.Get<Guid>("BidID"),
            record.Get<Guid>("UserID"),
            record.Get<Guid>("LotID"),
            record.Get<Decimal>("Price"),
            record.Get<DateTime>("BidDate")
            )
        { }

        private Guid bidID;
        public Guid BidID
        {
            get { return bidID; }
        }

        private Guid userID;
        public Guid UserID
        {
            get { return userID; }
        }

        private Guid lotID;
        public Guid LotID
        {
            get { return lotID; }
        }

        private decimal price;
        public decimal Price
        {
            get { return price; }
        }

        private DateTime bidDate;
        public DateTime BidDate
        {
            get { return bidDate; }
        }
    }
}
