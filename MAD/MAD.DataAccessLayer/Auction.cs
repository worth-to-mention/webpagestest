using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using MAD.DataAccessLayer.Extentions;

namespace MAD.DataAccessLayer
{
    public class Auction
    {
        public Auction(Guid auctionID, Guid userID, string auctionTitle, bool isStarted, bool isClosed
            , DateTime? startDate = null, DateTime? endDate = null)
        {
            this.auctionID = auctionID;
            this.userID = userID;

            if (String.IsNullOrEmpty(auctionTitle))
            {
                throw new ArgumentException("Auction title can not be blank.", "auctionTitle");
            }
            this.auctionTitle = auctionTitle;
            
            this.isStarted = isStarted;
            this.isClosed = isClosed;
            this.startDate = startDate;
            this.endDate = endDate;
        }

        public Auction(IDataRecord record)
            : this(
                record.Get<Guid>("AuctionID"),
                record.Get<Guid>("UserID"),
                record.Get<String>("Title"),
                record.Get<Boolean>("IsStarted"),
                record.Get<Boolean>("IsClosed"),
                record.Get<DateTime?>("StartDate"),
                record.Get<DateTime?>("EndDate")
            )
        { }

        private Guid userID;
        public Guid UserID
        {
            get { return userID; }
        }

        private Guid auctionID;
        public Guid AuctionID
        {
            get
            {
                return auctionID;
            }
        }

        private string auctionTitle;
        public string AuctionTitle
        {
            get
            {
                return auctionTitle;
            }
        }

        private DateTime? startDate;
        public DateTime? StartDate
        {
            get
            {
                return startDate;
            }
        }

        private DateTime? endDate;
        public DateTime? EndDate
        {
            get
            {
                return endDate;
            }
        }

        private bool isStarted;
        public bool IsStarted
        {
            get
            {
                return isStarted;
            }
        }

        private bool isClosed;
        public bool IsClosed
        {
            get { return isClosed; }
        }
    }
}
