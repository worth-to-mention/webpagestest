using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Configuration;
using MAD.DataAccessLayer;
using MAD.DataAccessLayer.DataProviders;
using MAD.Security;


namespace MAD.Auctioning
{
    public static class Auctions
    {
        private static string connectionString;
        private static AuctionDataProvider dataProvider;

        static Auctions()
        {
            ConnectionStringSettings settings = ConfigurationManager.ConnectionStrings["MAD"];
            if (settings == null)
            {
                throw new InvalidOperationException("Can not initialize Auctions without connection string.");
            }
            connectionString = settings.ConnectionString;

            dataProvider = new AuctionDataProvider(connectionString);
        }

        public static Auction CreateAuction(string auctionTitle)
        {
            User user = MADUsers.GetUser();
            return dataProvider.CreateAuction(user.UserID, auctionTitle);
        }
        public static Auction CreateAuction(User user, string auctionTitle)
        {
            return dataProvider.CreateAuction(user.UserID, auctionTitle);
        }

        public static List<Auction> GetActiveAuctions()
        {
            return dataProvider.GetActiveAuctions();
        }
        public static List<Auction> GetStartedAuctions()
        {
            return dataProvider.GetStartedAuctions();
        }

        public static List<Auction> GetUserAuctions()
        {
            User user = MADUsers.GetUser();
            if (user == null)
            {
                return new List<Auction>();
            }
            return GetUserAuctions(user.UserID);
        }
        public static List<Auction> GetUserAuctions(Guid userID)
        {
            return dataProvider.GetUserAuctions(userID);
        }

        public static Auction GetAuction(Guid auctionID)
        {
            return dataProvider.GetAuction(auctionID);
        }

        public static List<Lot> GetAuctionLots(Guid auctionID)
        {
            return dataProvider.GetAuctionLots(auctionID);
        }

        public static Lot GetLot(Guid lotID)
        {
            return dataProvider.GetLot(lotID);
        }

        public static decimal GetLotSumPrice(Guid lotID)
        {
            return dataProvider.GetLotPrice(lotID);
        }

        public static Lot CreateAuctionLot(Guid auctionID, string lotTitle, string lotDescription, decimal startingPrice)
        {
            return dataProvider.CreateLot(auctionID, lotTitle, lotDescription, startingPrice);
        }

        public static void StartAuction(Guid auctionID)
        {
            dataProvider.StartAuction(auctionID, DateTime.UtcNow);
        }
        public static void CloseAuction(Guid auctionID)
        {
            dataProvider.CloseAuction(auctionID, DateTime.UtcNow);
        }

        public static void Bid(Guid userID, Guid lotID, decimal price)
        {
            dataProvider.CreateBid(userID, lotID, price, DateTime.UtcNow);
        }

        public static List<Bid> GetLotBids(Guid lotID)
        {
            return dataProvider.GetLotBids(lotID);
        }

        public static void DeleteLot(Guid lotID)
        {
            dataProvider.DeleteLot(lotID);
        }

        public static List<Lot> FindLots(string searchString)
        {
            return dataProvider.SearchLotsByTitle(searchString);
        }
    }
}
