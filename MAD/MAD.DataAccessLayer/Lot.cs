using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using MAD.DataAccessLayer.Extentions;

namespace MAD.DataAccessLayer
{
    public class Lot
    {
        public Lot(Guid lotID, Guid auctionID, string title, string description
            , decimal startingPrice, bool isSold)
        {
            this.lotID = lotID;
            this.auctionID = auctionID;
            if (String.IsNullOrEmpty(title))
            {
                throw new ArgumentException("Lot title can not be blank.", "title");
            }
            this.title = title;
            if (String.IsNullOrEmpty(description))
            {
                throw new ArgumentException("Lot description can not be blank.", "description");
            }
            this.description = description;
            this.startingPrice = startingPrice;
            this.isSold = isSold;
        }
        
        public Lot(IDataRecord record)
            : this(
            record.Get<Guid>("LotID"),
            record.Get<Guid>("AuctionID"),
            record.Get<String>("Title"),
            record.Get<String>("Description"),
            record.Get<Decimal>("StartingPrice"),
            record.Get<Boolean>("IsSold")
            )
        { }

        private Guid lotID;
        public Guid LotID
        {
            get { return lotID; }
        }

        private Guid auctionID;
        public Guid AuctionID
        {
            get { return auctionID; }
        }

        private string title;
        public string Title
        {
            get { return title; }
        }

        private string description;
        public string Description
        {
            get { return description; }
        }

        private decimal startingPrice;
        public decimal StartingPrice 
        {
            get { return startingPrice; }
        }

        private bool isSold;
        public bool IsSold
        {
            get { return isSold; }
        }
    }
}
